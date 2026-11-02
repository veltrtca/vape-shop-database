-- =====================================================================
-- Vape Shop Database — scenariusze administracyjne
-- Uruchamiać po 01_schema.sql i 02_seed_data.sql (konto z uprawnieniami
-- administratora — potrzebne do CREATE USER / GRANT).
-- =====================================================================

USE vape_shop;

-- ---------------------------------------------------------------------
-- 1. Rozbudowa schematu: tabela opinii (CREATE TABLE)
-- Zastosowanie: oceny produktów, feedback od klientów.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
    review_id   INT       PRIMARY KEY AUTO_INCREMENT,
    client_id   INT       NOT NULL,
    product_id  INT       NOT NULL,
    rating      TINYINT   NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment     TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_review_client_product UNIQUE (client_id, product_id),
    CONSTRAINT fk_reviews_client
        FOREIGN KEY (client_id)  REFERENCES clients(client_id)   ON DELETE CASCADE,
    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

INSERT INTO reviews (client_id, product_id, rating, comment) VALUES
(1, 3, 5, 'Mocna bateria, polecam'),
(5, 8, 4, 'Dobry, ale ciężki'),
(9, 3, 5, NULL);

-- ---------------------------------------------------------------------
-- 2. Nowy użytkownik: analityk z dostępem tylko do odczytu
-- Zasada najmniejszych uprawnień: analityk nie widzi tabeli clients
-- (dane osobowe), ma tylko SELECT na danych sprzedażowych.
-- Hasło jest przykładowe — w praktyce nie trzyma się haseł w repozytorium.
-- ---------------------------------------------------------------------
DROP USER IF EXISTS 'analyst'@'localhost';
CREATE USER 'analyst'@'localhost' IDENTIFIED BY 'ChangeMe_123!';

GRANT SELECT ON vape_shop.orders         TO 'analyst'@'localhost';
GRANT SELECT ON vape_shop.order_items    TO 'analyst'@'localhost';
GRANT SELECT ON vape_shop.products       TO 'analyst'@'localhost';
GRANT SELECT ON vape_shop.categories     TO 'analyst'@'localhost';
GRANT SELECT ON vape_shop.manufacturers  TO 'analyst'@'localhost';
GRANT SELECT ON vape_shop.v_order_totals TO 'analyst'@'localhost';

SHOW GRANTS FOR 'analyst'@'localhost';

-- ---------------------------------------------------------------------
-- 3. Nowi producenci (INSERT)
-- Zastosowanie: umowa z nowym dostawcą.
-- ---------------------------------------------------------------------
INSERT INTO manufacturers (manufacturer_id, manufacturer_name) VALUES
(9,  'SMOK'),
(10, 'Lost Vape');

-- ---------------------------------------------------------------------
-- 4. Promocja -10% na liquidy (UPDATE w transakcji)
-- UWAGA: ALTER TABLE w MySQL powoduje niejawny COMMIT, dlatego zmiana
-- struktury jest PRZED transakcją — inaczej ROLLBACK by jej nie cofnął.
-- ---------------------------------------------------------------------
ALTER TABLE products ADD COLUMN original_price DECIMAL(10,2) NULL;

START TRANSACTION;

UPDATE products
SET original_price = product_price
WHERE category_id = 1
  AND original_price IS NULL;

UPDATE products
SET product_price = ROUND(product_price * 0.9, 2)
WHERE category_id = 1;

-- kontrola przed zatwierdzeniem
SELECT product_id, product_name, original_price, product_price
FROM products
WHERE category_id = 1;

COMMIT;      -- wszystko OK
-- ROLLBACK; -- w razie błędu

-- ---------------------------------------------------------------------
-- 5. Wycofanie produktów (DELETE vs. archiwizacja)
-- Produkt bez historii sprzedaży można usunąć.
-- Produkt, który był sprzedany, archiwizujemy (soft delete) — klucz obcy
-- fk_items_product i tak nie pozwoliłby go usunąć.
-- ---------------------------------------------------------------------

-- 5a. podgląd: wycofane produkty i liczba pozycji w zamówieniach
SELECT p.product_id, p.product_name, p.product_status,
       COUNT(oi.item_id) AS in_orders
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE p.product_status = 'discontinued'
GROUP BY p.product_id, p.product_name, p.product_status;

-- 5b. usunięcie produktów bez sprzedaży
--     (wiersz w tabeli podtypu, np. chargers, usunie się przez ON DELETE CASCADE)
DELETE FROM products
WHERE product_status = 'discontinued'
  AND product_id NOT IN (SELECT product_id FROM order_items);

-- 5c. archiwizacja pozostałych (sprzedanych) produktów
UPDATE products
SET product_status = 'archived'
WHERE product_status = 'discontinued';

-- 5d. kontrola
SELECT p.product_id, p.product_name, p.product_status,
       COUNT(oi.item_id) AS in_orders
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE p.product_status IN ('discontinued', 'archived')
GROUP BY p.product_id, p.product_name, p.product_status;
