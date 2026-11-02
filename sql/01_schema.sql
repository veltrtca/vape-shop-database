-- =====================================================================
-- Vape Shop Database — schemat bazy danych
-- SZBD: MySQL 8.0+
-- Autor: Kseniya Lankovskaya
-- =====================================================================

CREATE DATABASE IF NOT EXISTS vape_shop
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE vape_shop;

-- Usuwanie w odwrotnej kolejności zależności (najpierw tabele z FK)
DROP VIEW  IF EXISTS v_order_totals;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS chargers;
DROP TABLE IF EXISTS sticks;
DROP TABLE IF EXISTS vapes;
DROP TABLE IF EXISTS liquids;
DROP TABLE IF EXISTS cartridges;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS manufacturers;
DROP TABLE IF EXISTS categories;

-- ---------------------------------------------------------------------
-- Słowniki
-- ---------------------------------------------------------------------
CREATE TABLE categories (
    category_id    INT          PRIMARY KEY,
    category_name  VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE manufacturers (
    manufacturer_id    INT           PRIMARY KEY,
    manufacturer_name  VARCHAR(100)  NOT NULL UNIQUE
);

-- ---------------------------------------------------------------------
-- Klienci
-- ---------------------------------------------------------------------
CREATE TABLE clients (
    client_id      INT           PRIMARY KEY,
    full_name      VARCHAR(100)  NOT NULL,
    email          VARCHAR(255)  NOT NULL UNIQUE,
    phone          VARCHAR(20)   NOT NULL,
    password_hash  CHAR(60)      NOT NULL   -- hash bcrypt, nigdy hasło jawnym tekstem
);

-- ---------------------------------------------------------------------
-- Katalog produktów (nadtyp)
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id       INT            PRIMARY KEY,
    product_name     VARCHAR(100)   NOT NULL,
    product_price    DECIMAL(10,2)  NOT NULL CHECK (product_price > 0),
    category_id      INT            NOT NULL,
    manufacturer_id  INT            NOT NULL,
    product_status   VARCHAR(20)    NOT NULL DEFAULT 'in_stock'
        CHECK (product_status IN ('in_stock', 'low_stock', 'out_stock',
                                  'discontinued', 'archived')),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)     REFERENCES categories(category_id),
    CONSTRAINT fk_products_manufacturer
        FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

-- ---------------------------------------------------------------------
-- Tabele specjalistyczne (podtypy, relacja 1 : 0..1 z products)
-- PK = FK -> jeden produkt ma co najwyżej jeden wiersz w podtypie
-- ---------------------------------------------------------------------
CREATE TABLE liquids (
    product_id    INT          PRIMARY KEY,
    liquid_taste  VARCHAR(50)  NOT NULL,
    strength_mg   INT          NOT NULL CHECK (strength_mg BETWEEN 0 AND 50),
    expiry_date   DATE         NOT NULL,
    CONSTRAINT fk_liquids_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE cartridges (
    product_id      INT           PRIMARY KEY,
    resistance_ohm  DECIMAL(4,2)  NOT NULL CHECK (resistance_ohm > 0),
    capacity_ml     DECIMAL(4,1)  CHECK (capacity_ml > 0),
    CONSTRAINT fk_cartridges_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE vapes (
    product_id  INT          PRIMARY KEY,
    vape_color  VARCHAR(30),
    CONSTRAINT fk_vapes_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE sticks (
    product_id    INT          PRIMARY KEY,
    sticks_taste  VARCHAR(50),
    CONSTRAINT fk_sticks_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE chargers (
    product_id     INT          PRIMARY KEY,
    charger_color  VARCHAR(30),
    usb_type       VARCHAR(30),
    CONSTRAINT fk_chargers_product
        FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- Zamówienia
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id          INT           PRIMARY KEY,
    client_id         INT           NOT NULL,
    order_date        DATE          NOT NULL,
    order_status      VARCHAR(20)   NOT NULL
        CHECK (order_status IN ('processing', 'shipped', 'delivered', 'cancelled')),
    delivery_address  VARCHAR(255)  NOT NULL,
    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE order_items (
    item_id            INT            PRIMARY KEY,
    order_id           INT            NOT NULL,
    product_id         INT            NOT NULL,
    quantity           INT            NOT NULL CHECK (quantity > 0),
    price_at_purchase  DECIMAL(10,2)  NOT NULL CHECK (price_at_purchase >= 0),
    CONSTRAINT uq_order_product UNIQUE (order_id, product_id),
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)   REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)   -- RESTRICT: nie usuniemy sprzedanego produktu
);

-- ---------------------------------------------------------------------
-- Indeksy pod najczęstsze filtry w analizach
-- (kolumny FK InnoDB indeksuje automatycznie)
-- ---------------------------------------------------------------------
CREATE INDEX idx_orders_date     ON orders(order_date);
CREATE INDEX idx_orders_status   ON orders(order_status);
CREATE INDEX idx_products_status ON products(product_status);
CREATE INDEX idx_liquids_expiry  ON liquids(expiry_date);

-- ---------------------------------------------------------------------
-- Widok: wartość zamówienia liczona z pozycji
-- Zamiast przechowywać order_price w orders (dana wyliczalna = ryzyko
-- niespójności), sumę liczymy zawsze z order_items.
-- ---------------------------------------------------------------------
CREATE VIEW v_order_totals AS
SELECT
    o.order_id,
    o.client_id,
    o.order_date,
    o.order_status,
    SUM(oi.quantity)                        AS items_count,
    SUM(oi.quantity * oi.price_at_purchase) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.client_id, o.order_date, o.order_status;
