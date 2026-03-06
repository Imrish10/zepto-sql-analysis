CREATE DATABASE zepto_analysis;

USE zepto_analysis;

CREATE TABLE zepto_raw (
    category VARCHAR(100),
    product_name VARCHAR(255),
    mrp DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    available_quantity INT,
    selling_price DECIMAL(10,2),
    weight_gms INT,
    out_of_stock VARCHAR(10),
    quantity INT
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255),
    category_id INT,
    mrp DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    available_quantity INT,
    selling_price DECIMAL(10,2),
    weight_gms INT,
    out_of_stock VARCHAR(10),
    quantity INT,

    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
);

INSERT INTO categories (category_name)
SELECT DISTINCT category
FROM zepto_raw;

INSERT INTO products (
product_name,
category_id,
mrp,
discount_percent,
available_quantity,
selling_price,
weight_gms,
out_of_stock,
quantity
)

SELECT
r.product_name,
c.category_id,
r.mrp,
r.discount_percent,
r.available_quantity,
r.selling_price,
r.weight_gms,
r.out_of_stock,
r.quantity

FROM zepto_raw r
JOIN categories c
ON r.category = c.category_name;

SELECT COUNT(*) AS total_products
FROM products;

SELECT *
FROM products
WHERE mrp IS NULL;

SELECT * 
FROM products 
WHERE mrp = 0;

DELETE FROM products
WHERE product_id = 3603;

SELECT *
FROM products
WHERE product_id = 3603;

SELECT product_name, COUNT(*)
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1;

SELECT c.category_name,
COUNT(p.product_id) AS total_products

FROM products p
JOIN categories c
ON p.category_id = c.category_id

GROUP BY c.category_name
ORDER BY total_products DESC;

SELECT c.category_name,
AVG(p.discount_percent) AS avg_discount

FROM products p
JOIN categories c
ON p.category_id = c.category_id

GROUP BY c.category_name
ORDER BY avg_discount DESC;

SELECT product_name, mrp
FROM products
ORDER BY mrp DESC
LIMIT 10;

SELECT product_name, discount_percent
FROM products
ORDER BY discount_percent DESC
LIMIT 10;

SELECT p.product_name,
c.category_name

FROM products p
JOIN categories c
ON p.category_id = c.category_id

WHERE p.out_of_stock = 'TRUE';

SELECT c.category_name,
COUNT(*) AS out_of_stock_products

FROM products p
JOIN categories c
ON p.category_id = c.category_id

WHERE p.out_of_stock = 'TRUE'

GROUP BY c.category_name;

SELECT product_name,
mrp,
selling_price,
(mrp - selling_price) AS discount_value

FROM products
ORDER BY discount_value DESC;

SELECT SUM(available_quantity) AS total_inventory
FROM products;

SELECT c.category_name,
AVG(p.selling_price) AS avg_price

FROM products p
JOIN categories c
ON p.category_id = c.category_id

GROUP BY c.category_name;

SELECT product_name, discount_percent
FROM products
WHERE discount_percent > 50
ORDER BY discount_percent DESC;

SELECT product_name, available_quantity
FROM products
ORDER BY available_quantity DESC
LIMIT 10;

SELECT product_name,
       selling_price / NULLIF(weight_gms,0) AS price_per_gram
FROM products
ORDER BY price_per_gram DESC;

SELECT p.product_name,
       c.category_name,
       p.discount_percent,
       RANK() OVER (ORDER BY p.discount_percent DESC) AS discount_rank
FROM products p
JOIN categories c
ON p.category_id = c.category_id;

SELECT c.category_name,
AVG(p.selling_price) AS avg_price

FROM products p
JOIN categories c
ON p.category_id = c.category_id

GROUP BY c.category_name
ORDER BY avg_price DESC
LIMIT 1;

SELECT c.category_name,
AVG(p.discount_percent) AS avg_discount

FROM products p
JOIN categories c
ON p.category_id = c.category_id

GROUP BY c.category_name
ORDER BY avg_discount DESC
LIMIT 1;

SELECT out_of_stock,
COUNT(*) AS product_count
FROM products
GROUP BY out_of_stock;

WITH high_discount_products AS
(
SELECT product_name, discount_percent
FROM products
WHERE discount_percent > 40
)

SELECT *
FROM high_discount_products
ORDER BY discount_percent DESC;