-- =====================================================================
-- Vape Shop Database — dane testowe
-- Wszystkie dane osobowe są fikcyjne (domena example.com jest
-- zarezerwowana do testów), hasła przechowywane jako hash bcrypt.
-- =====================================================================

USE vape_shop;

INSERT INTO categories (category_id, category_name) VALUES
(1, 'Liquids'),
(2, 'Cartridges'),
(3, 'Vapes'),
(4, 'Sticks'),
(5, 'Chargers');

INSERT INTO manufacturers (manufacturer_id, manufacturer_name) VALUES
(1, 'Vaporesso'),
(2, 'Juul Labs'),
(3, 'GeekVape'),
(4, 'Voopoo'),
(5, 'LiquidWorld'),
(6, 'Xiaomi'),
(7, 'Uwell'),
(8, 'OXVA');

INSERT INTO clients (client_id, full_name, email, phone, password_hash) VALUES
(1,  'Jan Kowalski',          'jan.kowalski@example.com',        '+48500000001',  '$2b$10$M8qiYVKzf1k9dj2QrpdsZe06ii3HohaJm8AJaQBgo7mV.RgRHd2BW'),
(2,  'Anna Nowak',            'anna.nowak@example.com',          '+48500000002',  '$2b$10$EoDPERJC6LZfJEuwOMzgaeRwFb5aewq2AXLkHrwkowalaD5UQvMs6'),
(3,  'Piotr Wiśniewski',      'piotr.wisniewski@example.com',    '+48500000003',  '$2b$10$joJJz1PnMtTdriOMoR7rVOBH3aiRUQgzd44wW0sJpJqKSDuJkOjxS'),
(4,  'Katarzyna Wójcik',      'katarzyna.wojcik@example.com',    '+48500000004',  '$2b$10$xS3Wfgjf04ImQ4xFvnHFku70l3SrhTi0eX0L.aYm4X50jKWmcgQ/6'),
(5,  'Tomasz Kamiński',       'tomasz.kaminski@example.com',     '+48500000005',  '$2b$10$xfsZ/JWMxBEFaomdOdOsN.PjE4Qy2TPf0K5S5ujdldnDDpYBcKAiW'),
(6,  'Olena Kovalenko',       'olena.kovalenko@example.com',     '+380500000006', '$2b$10$XS.MUUaCqDLYjUNO9kuaTODQc2Eu4bUa5y4JUggRHsRs/H743VbOi'),
(7,  'Andrii Shevchuk',       'andrii.shevchuk@example.com',     '+380500000007', '$2b$10$m0QaxE917jSKq.GdiSqhyOby.NUfq7L0bLtpM7qRG8pOlUv1ul8yq'),
(8,  'Magdalena Lewandowska', 'magdalena.lewandowska@example.com','+48500000008', '$2b$10$A6LTbaLStaFhljRQ2.m8yOzftd1I6b5UFc7tHL5t23ODbFCUpS6Eq'),
(9,  'Michał Zieliński',      'michal.zielinski@example.com',    '+48500000009',  '$2b$10$NpFHY2DFLtJWJQGNF/1HzubqBr69DxhyrrSeP4DAeh.LI/AnrTFTK'),
(10, 'Agnieszka Szymańska',   'agnieszka.szymanska@example.com', '+48500000010',  '$2b$10$4c/H9WBiaruntbBUL1zaoea8I32rvagtWeh742xscHuEZBA57oW7G'),
(11, 'Paweł Woźniak',         'pawel.wozniak@example.com',       '+48500000011',  '$2b$10$n0c4ZmP7QH1XjlCPE14dTuDnczOktTobiyEq2p70TSWbfiGthqKty'),
(12, 'Natalia Dąbrowska',     'natalia.dabrowska@example.com',   '+48500000012',  '$2b$10$KCNPZKa3xYQdYJBj4r8z..O6N0Iaa2V8U3qdLIVuLP8ncZng4n1u6'),
(13, 'Kamil Kozłowski',       'kamil.kozlowski@example.com',     '+48500000013',  '$2b$10$/IXEYNRVW5MrfFEXILs2.ekNrNSTmfGrm5O0SgZ5ieKHQ2CyY/e5W'),
(14, 'Iryna Bondarenko',      'iryna.bondarenko@example.com',    '+380500000014', '$2b$10$nqWgYFVBu1MYu6LqQIydR.LBOjiXrJnCy34UURhYz1p2qK/7UAs0i'),
(15, 'Marek Jankowski',       'marek.jankowski@example.com',     '+48500000015',  '$2b$10$HcXwVelps/Zv1q0FgkdveOQOHFE3gLIB4RSXrRquGyAKQv/7ydpL2');

INSERT INTO products (product_id, product_name, product_price, category_id, manufacturer_id, product_status) VALUES
(1,  'XROS Pod 0.6 ohm',        12.99, 2, 1, 'in_stock'),
(2,  'Mango Ice 50ml',          49.99, 1, 5, 'in_stock'),
(3,  'Aegis Solo 100W',        199.99, 3, 3, 'in_stock'),
(4,  'Juul Mango Pods',         79.99, 4, 2, 'in_stock'),
(5,  'USB-C Charger 65W',       39.99, 5, 6, 'in_stock'),
(6,  'Luxe XR Max Pod',         89.99, 2, 1, 'in_stock'),
(7,  'Strawberry Banana 60ml',  54.99, 1, 5, 'in_stock'),
(8,  'Voopoo Drag 4 177W',     219.99, 3, 4, 'in_stock'),
(9,  'Juul Tobacco Pods',       79.99, 4, 2, 'in_stock'),
(10, 'Magnetic USB Charger',    29.99, 5, 6, 'in_stock'),
(11, 'GTX Go 80 Kit',           69.99, 3, 1, 'in_stock'),
(12, 'Blueberry Frost 30ml',    34.99, 1, 5, 'in_stock'),
(13, 'Wenax K2 Pod Kit',        45.99, 3, 3, 'in_stock'),
(14, '1.0 ohm Coil',             8.99, 2, 1, 'in_stock'),
(15, 'Car Charger Adapter',     19.99, 5, 6, 'discontinued'),
(16, 'Watermelon Ice 100ml',    69.99, 1, 5, 'in_stock'),
(17, 'OXVA XLIM Pro Pod',       52.99, 3, 8, 'in_stock'),
(18, 'Menthol Pods 4-pack',     32.99, 4, 2, 'low_stock'),
(19, 'Battery 18650 3000mAh',   24.99, 5, 6, 'in_stock'),
(20, 'Vanilla Custard 50ml',    44.99, 1, 5, 'in_stock'),
(21, 'Caliburn G3 Pod Kit',     41.99, 3, 7, 'in_stock'),
(22, '0.8 ohm Mesh Coil',        9.99, 2, 3, 'in_stock'),
(23, 'Tobacco Classic 30ml',    39.99, 1, 5, 'in_stock'),
(24, 'Multiple USB Charger',    49.99, 5, 6, 'in_stock'),
(25, 'Berry Mix Pods',          36.99, 4, 2, 'out_stock'),
(26, 'Peach Ice 30ml',          32.99, 1, 5, 'in_stock'),
(27, 'Wireless Charging Dock',  59.99, 5, 6, 'discontinued');

INSERT INTO cartridges (product_id, resistance_ohm, capacity_ml) VALUES
(1,  0.60, 3.0),
(6,  0.40, 4.0),
(14, 1.00, NULL),   -- grzałka, bez zbiornika
(22, 0.80, NULL);   -- grzałka, bez zbiornika

INSERT INTO liquids (product_id, liquid_taste, strength_mg, expiry_date) VALUES
(2,  'Mango Ice',          6, '2028-12-12'),
(7,  'Strawberry Banana',  3, '2029-02-14'),
(12, 'Blueberry Frost',    0, '2035-04-15'),
(16, 'Watermelon Ice',     6, '2036-11-29'),
(20, 'Vanilla Custard',   12, '2037-08-09'),
(23, 'Tobacco Classic',   18, '2026-10-15'),
(26, 'Peach Ice',          6, '2026-12-20');

INSERT INTO vapes (product_id, vape_color) VALUES
(3, 'Black'), (8, 'Black-Red'), (11, 'Blue'),
(13, 'Green'), (17, 'Grey'), (21, 'Silver');

INSERT INTO sticks (product_id, sticks_taste) VALUES
(4, 'Mango'), (9, 'Tobacco'), (18, 'Menthol'), (25, 'Berry Mix');

INSERT INTO chargers (product_id, charger_color, usb_type) VALUES
(5,  'Black', 'USB-C'),
(10, 'Black', 'USB-C'),
(15, 'Black', 'Car Socket'),
(19, 'Blue',  '18650'),
(24, 'White', 'Multi-USB'),
(27, 'White', 'Qi Wireless');

INSERT INTO orders (order_id, client_id, order_date, order_status, delivery_address) VALUES
(1,  1,  '2025-03-10', 'delivered',  'ul. Długa 15, 00-001 Warszawa'),
(2,  2,  '2025-03-12', 'delivered',  'ul. Krótka 3, 30-001 Kraków'),
(3,  3,  '2025-03-13', 'cancelled',  'ul. Szeroka 22, 80-001 Gdańsk'),
(4,  4,  '2025-03-15', 'delivered',  'ul. Wesoła 5, 50-001 Wrocław'),
(5,  5,  '2025-03-16', 'delivered',  'ul. Smutna 11, 60-001 Poznań'),
(6,  6,  '2025-06-17', 'delivered',  'ul. Nowa 7, 90-001 Łódź'),
(7,  7,  '2025-07-18', 'delivered',  'ul. Stara 9, 70-001 Szczecin'),
(8,  8,  '2025-08-19', 'delivered',  'ul. Zielona 13, 20-001 Lublin'),
(9,  9,  '2025-09-20', 'delivered',  'ul. Czerwona 4, 40-001 Katowice'),
(10, 10, '2025-10-21', 'delivered',  'ul. Niebieska 8, 81-001 Gdynia'),
(11, 11, '2025-11-22', 'delivered',  'ul. Żółta 12, 85-001 Bydgoszcz'),
(12, 12, '2025-11-23', 'cancelled',  'ul. Fioletowa 6, 15-001 Białystok'),
(13, 13, '2025-12-24', 'delivered',  'ul. Różowa 1, 25-001 Kielce'),
(14, 14, '2025-12-25', 'delivered',  'ul. Brązowa 10, 35-001 Rzeszów'),
(15, 15, '2026-01-10', 'delivered',  'ul. Szara 14, 45-001 Opole'),
(16, 1,  '2026-01-15', 'shipped',    'ul. Długa 15, 00-001 Warszawa'),
(17, 2,  '2026-01-20', 'delivered',  'ul. Krótka 3, 30-001 Kraków'),
(18, 3,  '2026-01-25', 'processing', 'ul. Szeroka 22, 80-001 Gdańsk'),
(19, 4,  '2026-01-26', 'processing', 'ul. Wesoła 5, 50-001 Wrocław'),
(20, 5,  '2026-01-27', 'shipped',    'ul. Smutna 11, 60-001 Poznań'),
(21, 6,  '2026-01-28', 'processing', 'ul. Nowa 7, 90-001 Łódź'),
(22, 7,  '2026-01-27', 'cancelled',  'ul. Stara 9, 70-001 Szczecin'),
(23, 8,  '2026-01-23', 'processing', 'ul. Zielona 13, 20-001 Lublin'),
(24, 9,  '2026-01-25', 'shipped',    'ul. Czerwona 4, 40-001 Katowice'),
(25, 10, '2026-01-01', 'processing', 'ul. Niebieska 8, 81-001 Gdynia'),
(26, 11, '2026-01-05', 'processing', 'ul. Żółta 12, 85-001 Bydgoszcz'),
(27, 12, '2026-01-10', 'shipped',    'ul. Fioletowa 6, 15-001 Białystok'),
(28, 13, '2026-01-15', 'processing', 'ul. Różowa 1, 25-001 Kielce'),
(29, 14, '2026-01-20', 'processing', 'ul. Brązowa 10, 35-001 Rzeszów'),
(30, 15, '2026-01-25', 'shipped',    'ul. Szara 14, 45-001 Opole');

-- price_at_purchase = cena w momencie zakupu (może różnić się od
-- aktualnej ceny katalogowej, np. przez promocję)
INSERT INTO order_items (item_id, order_id, product_id, quantity, price_at_purchase) VALUES
(1,  1,  3,  1, 199.99),  -- Aegis Solo 100W
(2,  1,  14, 1,   8.99),  -- 1.0 ohm Coil
(3,  2,  6,  1,  89.99),  -- Luxe XR Max Pod
(4,  3,  4,  2,  79.99),  -- Juul Mango Pods
(5,  4,  2,  1,  49.99),  -- Mango Ice 50ml
(6,  4,  7,  1,  54.99),  -- Strawberry Banana 60ml
(7,  4,  12, 1,  31.49),  -- Blueberry Frost 30ml (promocja -10%)
(8,  5,  8,  1, 219.99),  -- Voopoo Drag 4 177W
(9,  6,  16, 1,  69.99),  -- Watermelon Ice 100ml
(10, 6,  20, 2,  44.99),  -- Vanilla Custard 50ml
(11, 7,  1,  2,  12.99),  -- XROS Pod 0.6 ohm
(12, 7,  22, 2,   9.99),  -- 0.8 ohm Mesh Coil
(13, 8,  11, 1,  69.99),  -- GTX Go 80 Kit
(14, 9,  3,  1, 199.99),  -- Aegis Solo 100W
(15, 9,  5,  1,  39.99),  -- USB-C Charger 65W
(16, 9,  19, 1,  24.99),  -- Battery 18650 3000mAh
(17, 10, 17, 1,  52.99),  -- OXVA XLIM Pro Pod
(18, 10, 23, 2,  35.99),  -- Tobacco Classic 30ml (promocja -10%)
(19, 11, 9,  1,  79.99),  -- Juul Tobacco Pods
(20, 12, 13, 2,  45.99),  -- Wenax K2 Pod Kit
(21, 13, 7,  1,  54.99),  -- Strawberry Banana 60ml
(22, 14, 6,  1,  89.99),  -- Luxe XR Max Pod
(23, 15, 8,  1, 219.99),  -- Voopoo Drag 4 177W
(24, 15, 2,  1,  49.99),  -- Mango Ice 50ml
(25, 15, 15, 1,  19.99),  -- Car Charger Adapter
(26, 16, 20, 1,  44.99),  -- Vanilla Custard 50ml
(27, 17, 16, 1,  69.99),  -- Watermelon Ice 100ml
(28, 17, 7,  1,  54.99),  -- Strawberry Banana 60ml
(29, 17, 12, 1,  34.99),  -- Blueberry Frost 30ml
(30, 18, 3,  1, 199.99),  -- Aegis Solo 100W
(31, 19, 21, 1,  41.99),  -- Caliburn G3 Pod Kit
(32, 19, 1,  2,  12.99),  -- XROS Pod 0.6 ohm
(33, 19, 22, 2,   9.99),  -- 0.8 ohm Mesh Coil
(34, 20, 10, 1,  29.99),  -- Magnetic USB Charger
(35, 20, 14, 1,   8.99),  -- 1.0 ohm Coil
(36, 21, 13, 1,  45.99),  -- Wenax K2 Pod Kit
(37, 21, 2,  1,  49.99),  -- Mango Ice 50ml
(38, 21, 23, 1,  39.99),  -- Tobacco Classic 30ml
(39, 21, 19, 1,  22.49),  -- Battery 18650 3000mAh (promocja -10%)
(40, 22, 18, 2,  32.99),  -- Menthol Pods 4-pack
(41, 23, 17, 1,  52.99),  -- OXVA XLIM Pro Pod
(42, 24, 11, 2,  69.99),  -- GTX Go 80 Kit
(43, 24, 5,  1,  39.99),  -- USB-C Charger 65W
(44, 25, 13, 1,  45.99),  -- Wenax K2 Pod Kit
(45, 25, 14, 1,   8.99),  -- 1.0 ohm Coil
(46, 25, 22, 1,   9.99),  -- 0.8 ohm Mesh Coil
(47, 26, 19, 1,  24.99),  -- Battery 18650 3000mAh
(48, 27, 6,  1,  89.99),  -- Luxe XR Max Pod
(49, 28, 8,  1, 219.99),  -- Voopoo Drag 4 177W
(50, 29, 16, 1,  69.99),  -- Watermelon Ice 100ml
(51, 29, 20, 1,  44.99),  -- Vanilla Custard 50ml
(52, 30, 7,  2,  54.99),  -- Strawberry Banana 60ml
(53, 30, 12, 2,  34.99);  -- Blueberry Frost 30ml
