CREATE DATABASE ecommerce; 
USE ecommerce; 
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    category_id INT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    added_date DATE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(20),
    address TEXT,
    registration_date DATE
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled'),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method ENUM('Credit Card', 'PayPal', 'UPI'),
    payment_status ENUM('Paid', 'Pending', 'Failed'),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
CREATE TABLE Shipping (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    shipping_date DATE,
    delivery_date DATE,
    shipping_status ENUM('Dispatched', 'In Transit', 'Delivered'),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO Products (name, category_id, price, stock_quantity, added_date) VALUES ('Wireless Mouse', 1, 1299.00, 50, CURRENT_DATE);
INSERT INTO Customers (name, email, phone_number, address, registration_date) VALUES ('Rahul Sharma', 'rahul@example.com', '9876543210', '123 Main St, Mumbai', CURRENT_DATE);
INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES (1, CURRENT_DATE, 1299.00, 'Pending');
UPDATE Products SET stock_quantity = stock_quantity - 2 WHERE product_id = 1;
DELETE FROM Orders
WHERE status = 'Cancelled' AND order_date < CURDATE() - INTERVAL 30 DAY;
SELECT * FROM Orders WHERE order_date >= CURDATE() - INTERVAL 6 MONTH;
SELECT * FROM Products ORDER BY price DESC LIMIT 5;
SELECT customer_id, COUNT(order_id) AS total_orders FROM Orders GROUP BY customer_id HAVING COUNT(order_id) > 3;
SELECT o.* FROM Orders o JOIN Payments p ON o.order_id = p.order_id WHERE o.status = 'Pending' AND p.payment_status = 'Paid';
SELECT * FROM Products WHERE NOT (stock_quantity = 0);
SELECT DISTINCT c.* FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id WHERE c.registration_date > '2022-12-31' OR o.total_amount > 10000;
SELECT * FROM Products ORDER BY price DESC;
SELECT customer_id, COUNT(order_id) AS total_orders FROM Orders GROUP BY customer_id;
SELECT c.category_name, SUM(oi.subtotal) AS total_revenue FROM Categories c JOIN Products p ON c.category_id = p.category_id JOIN Order_Items oi ON p.product_id = oi.product_id GROUP BY c.category_id, c.category_name;
SELECT SUM(total_amount) AS total_store_revenue FROM Orders WHERE status != 'Cancelled';
SELECT p.name, SUM(oi.quantity) AS total_quantity_sold FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id GROUP BY p.product_id, p.name ORDER BY total_quantity_sold DESC LIMIT 1;
SELECT AVG(total_amount) AS average_order_value FROM Orders;
ALTER TABLE Orders ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);
ALTER TABLE Order_Items ADD CONSTRAINT fk_items_products FOREIGN KEY (product_id) REFERENCES Products(product_id);
ALTER TABLE Payments ADD CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES Orders(order_id);
SELECT p.product_id, p.name AS product_name, c.category_name, p.price FROM Products p INNER JOIN Categories c ON p.category_id = c.category_id;
SELECT o.order_id, o.order_date, o.total_amount, c.name, c.email, c.phone_number FROM Orders o LEFT JOIN Customers c ON o.customer_id = c.customer_id;
SELECT o.order_id, o.order_date, o.status, s.shipping_status FROM Shipping s RIGHT JOIN Orders o ON s.order_id = o.order_id WHERE s.shipping_id IS NULL OR s.shipping_status != 'Dispatched';
SELECT c.customer_id, c.name FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;
SELECT * FROM Orders WHERE customer_id IN (SELECT customer_id FROM Customers WHERE registration_date > '2022-12-31');
SELECT * FROM Customers WHERE customer_id = (SELECT customer_id FROM Orders GROUP BY customer_id ORDER BY SUM(total_amount) DESC LIMIT 1);
SELECT * FROM Products WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Order_Items);
SELECT MONTHNAME(order_date) AS order_month, COUNT(order_id) AS total_orders FROM Orders GROUP BY MONTH(order_date), MONTHNAME(order_date);
SELECT shipping_id, order_id, DATEDIFF(delivery_date, shipping_date) AS delivery_time_days FROM Shipping WHERE delivery_date IS NOT NULL;
SELECT order_id, DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_order_date FROM Orders;
SELECT product_id, UPPER(name) AS uppercase_name, price FROM Products;
SELECT customer_id, TRIM(name) AS clean_name FROM Customers;
SELECT customer_id, name, COALESCE(email, 'Not Provided') AS email FROM Customers;
SELECT customer_id, SUM(total_amount) AS total_spent, RANK() OVER (ORDER BY SUM(total_amount) DESC) AS spending_rank FROM Orders GROUP BY customer_id;
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, SUM(total_amount) AS monthly_revenue, SUM(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS cumulative_revenue FROM Orders GROUP BY DATE_FORMAT(order_date, '%Y-%m');
SELECT order_id, order_date, customer_id, COUNT(order_id) OVER (ORDER BY order_date, order_id) AS running_order_count FROM Orders;
SELECT c.customer_id, c.name, COALESCE(SUM(o.total_amount), 0) AS total_spent, CASE WHEN SUM(o.total_amount) > 50000 THEN 'Gold' WHEN SUM(o.total_amount) BETWEEN 20000 AND 50000 THEN 'Silver' ELSE 'Bronze' END AS Loyalty_Status FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id GROUP BY c.customer_id, c.name;
SELECT p.product_id, p.name, COALESCE(SUM(oi.quantity), 0) AS units_sold, CASE  WHEN SUM(oi.quantity) > 500 THEN 'Best Seller' WHEN SUM(oi.quantity) BETWEEN 200 AND 500 THEN 'Popular' ELSE 'Regular' END AS Product_Category FROM Products p LEFT JOIN Order_Items oi ON p.product_id = oi.product_id GROUP BY p.product_id, p.name;