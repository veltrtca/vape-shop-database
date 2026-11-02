-- =====================================================================
-- Vape Shop Database — zapytania analityczne
-- Przychód liczony z pozycji zamówień (quantity * price_at_purchase),
-- zamówienia anulowane są wykluczone ze sprzedaży.
-- =====================================================================

USE vape_shop;

-- ---------------------------------------------------------------------
-- 1. TOP-10 produktów
-- Pytanie biznesowe: które produkty sprzedają się najlepiej
-- (sztuki i przychód)?
-- ---------------------------------------------------------------------
SELECT
    p.product_name,
    c.category_name,
    SUM(oi.quantity)                                 AS units_sold,
    COUNT(DISTINCT o.order_id)                       AS orders_count,
    ROUND(SUM(oi.quantity * oi.price_at_purchase), 2) AS revenue
FROM products p
JOIN categories  c  ON c.category_id = p.category_id
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders      o  ON o.order_id    = oi.order_id
WHERE o.order_status <> 'cancelled'
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY units_sold DESC, revenue DESC
LIMIT 10;

-- ---------------------------------------------------------------------
-- 2. Produkty bez sprzedaży
-- Pytanie biznesowe: który towar zalega w katalogu i nigdy nie trafił
-- do żadnego zamówienia?
-- ---------------------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.product_price,
    p.product_status
FROM products p
JOIN categories c        ON c.category_id = p.category_id
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL
ORDER BY p.product_price DESC;

-- ---------------------------------------------------------------------
-- 3. Ryzyko magazynowe: niski zapas i krótki termin ważności
-- Pytanie biznesowe: co trzeba domówić, a co szybko wyprzedać?
-- Liquidy z terminem ważności < 90 dni od dziś lub już przeterminowane.
-- ---------------------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.product_status,
    CASE
        WHEN p.product_status = 'out_stock' THEN 'Brak'
        WHEN p.product_status = 'low_stock' THEN 'Mało'
        ELSE 'Dostępne'
    END                                   AS stock_problem,
    l.expiry_date,
    DATEDIFF(l.expiry_date, CURDATE())    AS days_to_expiry,
    CASE
        WHEN l.expiry_date IS NULL                         THEN '-'
        WHEN l.expiry_date <  CURDATE()                    THEN 'Przeterminowany'
        WHEN l.expiry_date <  CURDATE() + INTERVAL 90 DAY  THEN 'Upływa termin ważności'
        ELSE 'Normalny termin'
    END                                   AS expiry_problem
FROM products p
LEFT JOIN liquids l ON l.product_id = p.product_id
WHERE p.product_status IN ('low_stock', 'out_stock')
   OR l.expiry_date < CURDATE() + INTERVAL 90 DAY
ORDER BY
    CASE p.product_status
        WHEN 'out_stock' THEN 1
        WHEN 'low_stock' THEN 2
        ELSE 3
    END,
    l.expiry_date;

-- ---------------------------------------------------------------------
-- 4. Sprzedaż według miesięcy
-- Pytanie biznesowe: jak zmieniają się liczba zamówień, średnia wartość
-- zamówienia (AOV) i przychód w czasie?
-- ---------------------------------------------------------------------
SELECT
    DATE_FORMAT(order_date, '%Y-%m')  AS month,
    COUNT(*)                          AS orders_count,
    ROUND(AVG(order_total), 2)        AS avg_order_value,
    ROUND(SUM(order_total), 2)        AS monthly_revenue
FROM v_order_totals
WHERE order_status <> 'cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- ---------------------------------------------------------------------
-- 5. Producenci: szerokość oferty i poziom cen
-- Pytanie biznesowe: od których dostawców zależy asortyment?
-- ---------------------------------------------------------------------
SELECT
    m.manufacturer_name,
    COUNT(p.product_id)               AS product_count,
    COUNT(DISTINCT p.category_id)     AS category_count,
    ROUND(AVG(p.product_price), 2)    AS avg_price
FROM manufacturers m
LEFT JOIN products p ON p.manufacturer_id = m.manufacturer_id
GROUP BY m.manufacturer_id, m.manufacturer_name
ORDER BY product_count DESC, m.manufacturer_name;

-- ---------------------------------------------------------------------
-- 6. Dni z najwyższym przychodem (TOP-5)
-- Pytanie biznesowe: kiedy występują szczyty sprzedaży?
-- ---------------------------------------------------------------------
SELECT
    order_date,
    COUNT(*)                    AS orders_count,
    ROUND(SUM(order_total), 2)  AS daily_revenue
FROM v_order_totals
WHERE order_status <> 'cancelled'
GROUP BY order_date
ORDER BY daily_revenue DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- 7. Najcenniejsi klienci (TOP-5)
-- Pytanie biznesowe: kto powinien trafić do programu lojalnościowego?
-- ---------------------------------------------------------------------
SELECT
    cl.client_id,
    cl.full_name,
    COUNT(t.order_id)              AS total_orders,
    ROUND(SUM(t.order_total), 2)   AS total_spent,
    ROUND(AVG(t.order_total), 2)   AS avg_order_value,
    MIN(t.order_date)              AS first_purchase,
    MAX(t.order_date)              AS last_purchase
FROM clients cl
JOIN v_order_totals t ON t.client_id = cl.client_id
WHERE t.order_status <> 'cancelled'
GROUP BY cl.client_id, cl.full_name
ORDER BY total_spent DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- 8. Przychód według kategorii
-- Pytanie biznesowe: które segmenty produktowe generują przychód?
-- ---------------------------------------------------------------------
SELECT
    c.category_name                                   AS category,
    COUNT(DISTINCT o.order_id)                        AS orders_count,
    SUM(oi.quantity)                                  AS items_sold,
    ROUND(SUM(oi.quantity * oi.price_at_purchase), 2) AS total_revenue
FROM categories c
JOIN products    p  ON p.category_id = c.category_id
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders      o  ON o.order_id    = oi.order_id
WHERE o.order_status <> 'cancelled'
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC;
