CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;


-- Tables & Relationships


--1. Categories Table

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. Products Table

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category_id INT,
    price DECIMAL (10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    added_date DATE NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 3. Customers Table

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone_number VARCHAR(20),
    address TEXT,
    registration_date DATE NOT NULL
);

-- 4. Orders Table

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) DEFAULT 0.00,
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. Order_Items Table

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Payments Table

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('Credit Card', 'PayPal', 'UPI') NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. Shipping Table

CREATE TABLE Shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    shipping_date DATE,
    delivery_date DATE,
    shipping_status ENUM('Dispatched', 'In Transit', 'Delivered') DEFAULT 'Dispatching' 
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- TASKS & FUNCTIONALITIES


-- 1. Implement CRUD Operations

INSERT INTO Categories (category_name) VALUES ('Electronics'), ('Clothing'), ('Books');

INSERT INTO Products (name, category_id, price, stock_quantity, added_date) VALUES
('Laptop', 1, 65000.00, 15, '2023-01-10'),
('Smartphone', 1, 25000.00, 0, '2023-02-15'),
('Headphones', 1, 2000.00, 50, '2023-03-01');

INSERT INTO Customers (name, email, phone_number, address, registration_date) VALUES
('John Doe', 'john@example.com', '1234567890', '123 Elm Street, Springfield', '2023-01-05'),
('Alice Smith', NULL, '0987654321', '456 Oak Avenue, Metropolis', '2023-02-20');

INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES
(1, CURDATE(), 65000.00, 'Pending');

UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1;

DELETE FROM Orders
WHERE status = 'Cancelled' AND order_date < (CURDATE(), INTERVAL 30 DAY);

--2. Use SQL Clauses (WHERE, HAVING, LINIT)

SELECT * FROM Orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

SELECT * FORM Products
ORDER BY price DESC
LIMIT 5;

SELCT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id 
HAVING COUNT(order_id) > 3;

--3. Apply SQL Operator (AND, OR, NOT)

SELECT o.*
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
WHERE o.status = 'Pending' AND p.payment_status = 'Paid';

SELECT * FROM Products
WHERE NOT stock_quantity = 0;

SELECT DISTINCT c.*
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE YEAR(c.registration_date) > 2022 OR o.total_amount > 10000;

-- 4. Sorting & Grouping Data (ORDER BY, GROUP BY)

SELECT * FROM Products
ORDER BY price DESC;

SELECT category_id, COUNT(order_id) AS total_orders_placed
FROM Orders 
GROUP BY category_id;

SELECT c.customer_name, SUM(oi.subtotal) AS total_revenue
FROM Customers c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name;

-- 5. Use Aggregate Functions (SUM, AVG, MAX, MIN, COUNT)

SELECT SUM(total_amount) AS total_store_revenue
FROM Orders
WHERE status != 'Cancelled';

SELECT product_id, SUM(quantity) AS total_quantity_sold 
FROM Order_Items 
GROUP BY product_id 
ORDER BY total_quantity_sold DESC 
LIMIT 1;

SELECT AVG(total_amount) AS average_order_value 
FROM Orders;


-- 6. Establish Primary & Foreign Key Relationships

ALTER TABLE Orders 
ADD CONSTRAINT fk_orders_customers 
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Products 
ADD CONSTRAINT fk_products_categories 
FOREIGN KEY (category_id) REFERENCES Categories(category_id) 
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Order_Items 
ADD CONSTRAINT fk_order_items_orders 
FOREIGN KEY (order_id) REFERENCES Orders(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_order_items_products 
FOREIGN KEY (product_id) REFERENCES Products(product_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Payments 
ADD CONSTRAINT fk_payments_orders 
FOREIGN KEY (order_id) REFERENCES Orders(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Shipping 
ADD CONSTRAINT fk_shipping_orders 
FOREIGN KEY (order_id) REFERENCES Orders(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;


-- 7. Implement Joins


SELECT p.product_id, p.name AS product_name, c.category_name, p.price
FROM Products p
INNER JOIN Categories c ON p.category_id = c.category_id;

SELECT o.order_id, o.order_date, o.total_amount, o.status, c.name AS customer_name, c.email
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

SELECT o.order_id, o.order_date, s.shipping_status
FROM Shipping s
LEFT JOIN Orders o ON s.order_id = o.order_id
WHERE s.shipping_id IS NULL OR s.shipping_status != 'Delivered';

SELECT c.customer_id, c.name, c.email
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- 8. Use Subqueries


SELECT * FROM Orders
WHERE customer_id IN (
    SELECT customer_id
    FROM Customers
    WHERE YEAR(registration_date) > 2022
);

SELECT * FROM Customers
WHERE customer_id = (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
);

SELECT * FROM Products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM Order_Items
);

-- 9. Implement Date & Time Functions

SELECT MONTH(order_date) AS order_month, COUNT(order_id) AS total_orders 
FROM Orders 
GROUP BY MONTH(order_date);

SELECT shipping_id, order_id, DATEDIFF(delivery_date, shipping_date) AS delivery_time_days 
FROM Shipping 
WHERE delivery_date IS NOT NULL AND shipping_date IS NOT NULL;

SELECT order_id, DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_order_date 
FROM Orders;

-- 10. Use String Manipulation Functions

SELECT UPPER(name) AS uppercase_product_name 
FROM Products;

SELECT TRIM(name) AS cleaned_customer_name 
FROM Customers;

SELECT customer_id, name, COALESCE(email, 'Not Provided') AS email_status 
FROM Customers;

-- 11. Implement Window Functions

SELECT customer_id, SUM(total_amount) AS total_spent,
       DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS customer_rank 
FROM Orders 
GROUP BY customer_id;

SELECT order_date, total_amount,
       SUM(total_amount) OVER (ORDER BY order_date) AS cumulative_revenue 
FROM Orders;

SELECT order_id, order_date,
       COUNT(order_id) OVER (ORDER BY order_date, order_id) AS running_order_count 
FROM Orders;

-- 12. Apply SQL CASE Expressions

SELECT c.customer_id, c.name, COALESCE(SUM(o.total_amount), 0) AS total_spent,
       CASE 
           WHEN SUM(o.total_amount) > 50000 THEN 'Gold'
           WHEN SUM(o.total_amount) BETWEEN 20000 AND 50000 THEN 'Silver'
           ELSE 'Bronze'
       END AS Loyalty_Status
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

SELECT p.product_id, p.name, COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
       CASE 
           WHEN SUM(oi.quantity) > 500 THEN 'Best Seller'
           WHEN SUM(oi.quantity) BETWEEN 200 AND 500 THEN 'Popular'
           ELSE 'Regular'
       END AS Product_Category
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name;