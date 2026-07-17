-- Creating the database 'jiban' if it does not exist.
CREATE DATABASE IF NOT EXISTS jiban_db;
-- Select the 'jiban' database to work within it.
USE jiban_db;

-- ==========================================
-- STEP 1: DROP TABLES (To prevent duplicate errors)
-- ==========================================
-- We drop tables in reverse order of dependencies to avoid foreign key constraint errors.
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
-- creating the tables
-- Creating the 'Customers' table to store customer details.
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(255) NOT NULL,
    city VARCHAR(100)
);
-- Creating the 'Products' table to store store items.
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL
);
-- Creating the 'Orders' table to record transactions.
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    customer_id INTEGER,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Creating the 'OrderDetails' table to store items inside each order.
CREATE TABLE OrderDetails (
    order_detail_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- inserting sample data
-- Inserting customers into the Customers table.
INSERT INTO Customers (customer_name, city) VALUES 
('Anisur Rahman', 'Dhaka'),
('Tanjila Akter', 'Chittagong'),
('Sujon Mia', 'Dhaka');
-- Inserting products into the Products table.
INSERT INTO Products (product_name, category, price) VALUES 
('Smartphone', 'Electronics', 500.00),
('Laptop', 'Electronics', 1000.00),
('T-Shirt', 'Clothing', 20.00),
('Jeans', 'Clothing', 40.00);
-- Inserting orders into the Orders table.
INSERT INTO Orders (customer_id, order_date) VALUES 
(1, '2026-07-01'),
(2, '2026-07-02'),
(3, '2026-07-03');
-- Inserting details for those orders.
INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES 
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 4, 3);
-- Query 1: Calculate Total Sales/Revenue for each order.
SELECT 
    OrderDetails.order_id,
    SUM(Products.price * OrderDetails.quantity) AS TotalBill
FROM OrderDetails
INNER JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY OrderDetails.order_id;

-- Query 2: Categorize Orders as 'High Value' or 'Low Value' using CASE WHEN.
SELECT 
    OrderDetails.order_id,
    SUM(Products.price * OrderDetails.quantity) AS TotalBill,
    CASE 
        WHEN SUM(Products.price * OrderDetails.quantity) > 200 THEN 'High Value Order'
        ELSE 'Low Value Order'
    END AS OrderCategory
FROM OrderDetails
INNER JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY OrderDetails.order_id;

-- Query 3: Find Sales by Category (Which category brings more money?).
SELECT
Products.category,
    SUM(Products.price * OrderDetails.quantity) AS TotalCategoryRevenue,
    SUM(OrderDetails.quantity) AS TotalItemsSold
FROM OrderDetails
INNER JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY Products.category;

-- Query 4: Advanced Customer Invoice (Connecting all tables together).
SELECT 
    Customers.customer_name AS Customer,
    Customers.city AS City,
    Orders.order_date AS Date,
    Products.product_name AS Product,
    OrderDetails.quantity AS Qty,
    (Products.price * OrderDetails.quantity) AS ItemTotal
FROM OrderDetails
INNER JOIN Orders ON OrderDetails.order_id = Orders.order_id
INNER JOIN Customers ON Orders.customer_id = Customers.customer_id
INNER JOIN Products ON OrderDetails.product_id = Products.product_id;
