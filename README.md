# E-Commerce-Order-Management-System

## Objective 
Develop an E-Commerce Order Management System using MySQL, where users can manage products, customers, orders, payments, and shipping. The system should support CRUD operations, filtering, sorting, aggregation, key relationships, joins, subqueries, and advanced SQL functions.

## 1. Database & Schema Setup

**Objective:** Create the `ecommerce` database and the 7 core tables (with primary/foreign keys) that model the store: categories, products, customers, orders, order line-items, payments and shipping.

## ▶ Demo Video

<a href="https://drive.google.com/file/d/1USIxfN-uTZeX62orW1BwpLAXqaUXoDIy/view?usp=sharing" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/▶-Watch%20Demo%20Video-181717?style=for-the-badge&logo=github&logoColor=white" alt="Watch Demo Video" />
</a>

## **SQL Query:**
```sql
CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE Categories (...);
CREATE TABLE Products (...);
CREATE TABLE Customers (...);
CREATE TABLE Orders (...);
CREATE TABLE Order_Items (...);
CREATE TABLE Payments (...);
CREATE TABLE Shipping (...);
```

**Output:**

| Table | Purpose |
|---|---|
| Categories | Product categories (Electronics, Fashion, etc.) |
| Products | Catalog of items for sale, linked to Categories |
| Customers | Registered shoppers |
| Orders | One row per placed order, linked to Customers |
| Order_Items | Line items inside an Order, linked to Products |
| Payments | Payment attempt/result for an Order |
| Shipping | Dispatch/delivery tracking for an Order |

---

## 2. Insert a New Product

**Objective:** Add a new product record to the catalog.

**SQL Query:**
```sql
INSERT INTO Products (name, category_id, price, stock_quantity, added_date) VALUES ('Wireless Mouse', 1, 1299.00, 50, CURRENT_DATE);
```

**Output:**

| product_id | name | category_id | price | stock_quantity | added_date |
|---|---|---|---|---|---|
| 16 | Wireless Mouse | 1 | 1299 | 50 | 2026-09-23 |

---

## 3. Insert a New Customer

**Objective:** Register a new customer.

**SQL Query:**
```sql
INSERT INTO Customers (name, email, phone_number, address, registration_date) VALUES ('Rahul Sharma', 'rahul@example.com', '9876543210', '123 Main St, Mumbai', CURRENT_DATE);
```

**Output:**

| customer_id | name | email | phone_number | address | registration_date |
|---|---|---|---|---|---|
| 11 | Rahul Sharma | rahul@example.com | 9876543210 | 123 Main St, Mumbai | 2026-09-23 |

---

## 4. Insert a New Order

**Objective:** Place a new order for customer #1.

**SQL Query:**
```sql
INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES (1, CURRENT_DATE, 1299.00, 'Pending');
```

**Output:**

| order_id | customer_id | order_date | total_amount | status |
|---|---|---|---|---|
| 21 | 1 | 2026-09-23 | 1299 | Pending |

---

## 5. Reduce Stock After a Sale

**Objective:** Decrease stock_quantity by 2 for product #1 (e.g. after a sale of 2 units).

**SQL Query:**
```sql
UPDATE Products SET stock_quantity = stock_quantity - 2 WHERE product_id = 1;
```

**Output:**

**Before:**

| product_id | name | stock_quantity |
|---|---|---|
| 1 | Wireless Mouse | 48 |

**After:**

| product_id | name | stock_quantity |
|---|---|---|
| 1 | Wireless Mouse | 46 |

---

## 6. Purge Old Cancelled Orders

**Objective:** Delete cancelled orders that are more than 30 days old, to keep the Orders table clean.

**SQL Query:**
```sql
DELETE FROM Orders
WHERE status = 'Cancelled' AND order_date < CURDATE() - INTERVAL 30 DAY;
```

**Output:**

**Rows deleted (2):**

| order_id | customer_id | order_date | status |
|---|---|---|---|
| 9 | 4 | 2025-03-25 | Cancelled |
| 15 | 6 | 2025-02-01 | Cancelled |

---

## 7. Recent Orders (Last 6 Months)

**Objective:** List every order placed in the last 6 months.

**SQL Query:**
```sql
SELECT * FROM Orders WHERE order_date >= CURDATE() - INTERVAL 6 MONTH;
```

**Output:**

*(no rows returned)*

---

## 8. Top 5 Most Expensive Products

**Objective:** Find the 5 highest-priced products in the catalog.

**SQL Query:**
```sql
SELECT * FROM Products ORDER BY price DESC LIMIT 5;
```

**Output:**

| product_id | name | category_id | price | stock_quantity | added_date |
|---|---|---|---|---|---|
| 5 | Air Fryer | 2 | 6499 | 15 | 2025-02-15 |
| 12 | Smart Watch | 1 | 5999 | 22 | 2025-04-01 |
| 2 | Mechanical Keyboard | 1 | 3499 | 30 | 2025-01-20 |
| 8 | Running Shoes | 5 | 3299 | 40 | 2025-03-10 |
| 15 | Cricket Bat | 5 | 2999 | 12 | 2025-04-15 |

---

## 9. Customers With More Than 3 Orders

**Objective:** Identify loyal customers who have placed more than 3 orders.

**SQL Query:**
```sql
SELECT customer_id, COUNT(order_id) AS total_orders FROM Orders GROUP BY customer_id HAVING COUNT(order_id) > 3;
```

**Output:**

| customer_id | total_orders |
|---|---|
| 1 | 4 |
| 5 | 4 |

---

## 10. Pending Orders That Are Already Paid

**Objective:** Flag orders still marked 'Pending' even though payment already succeeded (a data/ops mismatch to investigate).

**SQL Query:**
```sql
SELECT o.* FROM Orders o JOIN Payments p ON o.order_id = p.order_id WHERE o.status = 'Pending' AND p.payment_status = 'Paid';
```

**Output:**

*(no rows returned)*

---

## 11. Products In Stock

**Objective:** List all products that currently have stock available.

**SQL Query:**
```sql
SELECT * FROM Products WHERE NOT (stock_quantity = 0);
```

**Output:**

| product_id | name | category_id | price | stock_quantity | added_date |
|---|---|---|---|---|---|
| 1 | Wireless Mouse | 1 | 1299 | 48 | 2025-01-15 |
| 2 | Mechanical Keyboard | 1 | 3499 | 30 | 2025-01-20 |
| 4 | Non-stick Pan | 2 | 899 | 20 | 2025-02-10 |
| 5 | Air Fryer | 2 | 6499 | 15 | 2025-02-15 |
| 6 | Cotton T-Shirt | 3 | 499 | 100 | 2025-03-01 |
| 7 | Denim Jacket | 3 | 2599 | 25 | 2025-03-05 |
| 8 | Running Shoes | 5 | 3299 | 40 | 2025-03-10 |
| 9 | Yoga Mat | 5 | 799 | 60 | 2025-03-12 |
| 11 | Cookbook | 4 | 599 | 35 | 2025-03-25 |
| 12 | Smart Watch | 1 | 5999 | 22 | 2025-04-01 |

*(showing 10 of 12 rows)*

---

## 12. Recent or High-Value Customers

**Objective:** Find customers who registered after 2022, or who have at least one big-ticket order (>10,000).

**SQL Query:**
```sql
SELECT DISTINCT c.* FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id WHERE c.registration_date > '2022-12-31' OR o.total_amount > 10000;
```

**Output:**

| customer_id | name | email | phone_number | address | registration_date |
|---|---|---|---|---|---|
| 3 | Amit Verma | amit@example.com | 9876500002 | 9 Lake View, Pune | 2023-01-05 |
| 4 | Sneha Iyer | sneha@example.com | 9876500003 | 78 MG Road, Bengaluru | 2023-02-14 |
| 6 | Neha Gupta | neha@example.com | 9876500005 | 5 Green Ave, Kolkata | 2023-03-18 |
| 7 | Karan Mehta |  | 9876500006 | 60 Ring Rd, Surat | 2023-04-01 |
| 8 | Anjali Rao | anjali@example.com | 9876500007 | 31 Hill St, Hyderabad | 2022-09-09 |
| 9 | Rohan Das | rohan@example.com | 9876500008 | 14 Canal Rd, Chennai | 2023-05-25 |
| 10 | Isha Kapoor | isha@example.com | 9876500009 | 88 Sea Face, Goa | 2023-06-30 |

---

## 13. All Products by Price (High to Low)

**Objective:** Rank the full product catalog from most to least expensive.

**SQL Query:**
```sql
SELECT * FROM Products ORDER BY price DESC;
```

**Output:**

| product_id | name | category_id | price | stock_quantity | added_date |
|---|---|---|---|---|---|
| 5 | Air Fryer | 2 | 6499 | 15 | 2025-02-15 |
| 12 | Smart Watch | 1 | 5999 | 22 | 2025-04-01 |
| 2 | Mechanical Keyboard | 1 | 3499 | 30 | 2025-01-20 |
| 8 | Running Shoes | 5 | 3299 | 40 | 2025-03-10 |
| 15 | Cricket Bat | 5 | 2999 | 12 | 2025-04-15 |
| 7 | Denim Jacket | 3 | 2599 | 25 | 2025-03-05 |
| 3 | Bluetooth Speaker | 1 | 2199 | 0 | 2025-02-01 |
| 14 | Backpack | 3 | 1599 | 0 | 2025-04-10 |
| 1 | Wireless Mouse | 1 | 1299 | 48 | 2025-01-15 |
| 13 | Table Lamp | 2 | 1199 | 18 | 2025-04-05 |

*(showing 10 of 15 rows)*

---

## 14. Order Count per Customer

**Objective:** Count how many orders each customer has placed.

**SQL Query:**
```sql
SELECT customer_id, COUNT(order_id) AS total_orders FROM Orders GROUP BY customer_id;
```

**Output:**

| customer_id | total_orders |
|---|---|
| 1 | 4 |
| 2 | 3 |
| 3 | 3 |
| 4 | 2 |
| 5 | 4 |
| 6 | 1 |
| 7 | 1 |
| 8 | 1 |
| 9 | 1 |

---

## 15. Revenue by Category

**Objective:** Total revenue generated by each product category.

**SQL Query:**
```sql
SELECT c.category_name, SUM(oi.subtotal) AS total_revenue FROM Categories c JOIN Products p ON c.category_id = p.category_id JOIN Order_Items oi ON p.product_id = oi.product_id GROUP BY c.category_id, c.category_name;
```

**Output:**

| category_name | total_revenue |
|---|---|
| Electronics | 39792 |
| Home & Kitchen | 16495 |
| Fashion | 4198 |
| Books | 1397 |
| Sports | 7097 |

---

## 16. Total Store Revenue

**Objective:** Sum of all order totals, excluding cancelled orders.

**SQL Query:**
```sql
SELECT SUM(total_amount) AS total_store_revenue FROM Orders WHERE status != 'Cancelled';
```

**Output:**

| total_store_revenue |
|---|
| 68181 |

---

## 17. Best-Selling Product

**Objective:** Find the single product with the highest total quantity sold.

**SQL Query:**
```sql
SELECT p.name, SUM(oi.quantity) AS total_quantity_sold FROM Order_Items oi JOIN Products p ON oi.product_id = p.product_id GROUP BY p.product_id, p.name ORDER BY total_quantity_sold DESC LIMIT 1;
```

**Output:**

| name | total_quantity_sold |
|---|---|
| Wireless Mouse | 9 |

---

## 18. Average Order Value

**Objective:** Calculate the average total_amount across all orders.

**SQL Query:**
```sql
SELECT AVG(total_amount) AS average_order_value FROM Orders;
```

**Output:**

| average_order_value |
|---|
| 3453.95 |

---

## 19. Add Foreign Keys (Orders → Customers)

**Objective:** Enforce referential integrity: every order must reference a real customer.

**SQL Query:**
```sql
ALTER TABLE Orders ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);
```

**Output:**

| Result |
|---|
| Foreign key constraint applied. |

> **Note:** SQLite defines foreign keys at table-creation time (already applied in Section 1); this `ALTER TABLE ... ADD CONSTRAINT` runs as-is on MySQL.

---

## 20. Add Foreign Keys (Order_Items → Products)

**Objective:** Enforce referential integrity: every line item must reference a real product.

**SQL Query:**
```sql
ALTER TABLE Order_Items ADD CONSTRAINT fk_items_products FOREIGN KEY (product_id) REFERENCES Products(product_id);
```

**Output:**

| Result |
|---|
| Foreign key constraint applied. |

> **Note:** SQLite defines foreign keys at table-creation time (already applied in Section 1); this `ALTER TABLE ... ADD CONSTRAINT` runs as-is on MySQL.

---

## 21. Add Foreign Keys (Payments → Orders)

**Objective:** Enforce referential integrity: every payment must reference a real order.

**SQL Query:**
```sql
ALTER TABLE Payments ADD CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES Orders(order_id);
```

**Output:**

| Result |
|---|
| Foreign key constraint applied. |

> **Note:** SQLite defines foreign keys at table-creation time (already applied in Section 1); this `ALTER TABLE ... ADD CONSTRAINT` runs as-is on MySQL.

---

## 22. Products With Category Name

**Objective:** Show each product alongside its readable category name (instead of just an ID).

**SQL Query:**
```sql
SELECT p.product_id, p.name AS product_name, c.category_name, p.price FROM Products p INNER JOIN Categories c ON p.category_id = c.category_id;
```

**Output:**

| product_id | product_name | category_name | price |
|---|---|---|---|
| 1 | Wireless Mouse | Electronics | 1299 |
| 2 | Mechanical Keyboard | Electronics | 3499 |
| 3 | Bluetooth Speaker | Electronics | 2199 |
| 4 | Non-stick Pan | Home & Kitchen | 899 |
| 5 | Air Fryer | Home & Kitchen | 6499 |
| 6 | Cotton T-Shirt | Fashion | 499 |
| 7 | Denim Jacket | Fashion | 2599 |
| 8 | Running Shoes | Sports | 3299 |
| 9 | Yoga Mat | Sports | 799 |
| 10 | Novel - Fiction | Books | 399 |

*(showing 10 of 15 rows)*

---

## 23. Orders With Customer Contact Info

**Objective:** Show each order together with the ordering customer's name/email/phone.

**SQL Query:**
```sql
SELECT o.order_id, o.order_date, o.total_amount, c.name, c.email, c.phone_number FROM Orders o LEFT JOIN Customers c ON o.customer_id = c.customer_id;
```

**Output:**

| order_id | order_date | total_amount | name | email | phone_number |
|---|---|---|---|---|---|
| 1 | 2025-04-02 | 1299 | Rahul Sharma | rahul@example.com | 9876543210 |
| 2 | 2025-05-14 | 3499 | Rahul Sharma | rahul@example.com | 9876543210 |
| 3 | 2025-06-20 | 899 | Rahul Sharma | rahul@example.com | 9876543210 |
| 4 | 2025-07-11 | 5999 | Rahul Sharma | rahul@example.com | 9876543210 |
| 5 | 2025-04-18 | 2199 | Priya Patel | priya@example.com | 9876500001 |
| 6 | 2025-06-02 | 799 | Priya Patel | priya@example.com | 9876500001 |
| 7 | 2025-05-01 | 6499 | Amit Verma | amit@example.com | 9876500002 |
| 8 | 2025-05-01 | 15999 | Amit Verma | amit@example.com | 9876500002 |
| 9 | 2025-03-25 | 499 | Sneha Iyer | sneha@example.com | 9876500003 |
| 10 | 2025-07-01 | 2599 | Sneha Iyer | sneha@example.com | 9876500003 |

*(showing 10 of 20 rows)*

---

## 24. Orders Missing / Not-Yet-Dispatched Shipments

**Objective:** Find orders that have no shipping record yet, or whose shipment hasn't been dispatched.

**SQL Query:**
```sql
SELECT o.order_id, o.order_date, o.status, s.shipping_status FROM Shipping s RIGHT JOIN Orders o ON s.order_id = o.order_id WHERE s.shipping_id IS NULL OR s.shipping_status != 'Dispatched';
```

**Output:**

| order_id | order_date | status | shipping_status |
|---|---|---|---|
| 1 | 2025-04-02 | Delivered | Delivered |
| 2 | 2025-05-14 | Delivered | Delivered |
| 5 | 2025-04-18 | Delivered | Delivered |
| 6 | 2025-06-02 | Delivered | Delivered |
| 7 | 2025-05-01 | Delivered | Delivered |
| 8 | 2025-05-01 | Delivered | Delivered |
| 10 | 2025-07-01 | Shipped | In Transit |
| 11 | 2025-04-10 | Delivered | Delivered |
| 12 | 2025-04-22 | Delivered | Delivered |
| 13 | 2025-05-30 | Delivered | Delivered |

*(showing 10 of 19 rows)*

---

## 25. Customers Who Never Ordered

**Objective:** Find registered customers who have not placed any order yet.

**SQL Query:**
```sql
SELECT c.customer_id, c.name FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;
```

**Output:**

| customer_id | name |
|---|---|
| 10 | Isha Kapoor |

---

## 26. Orders From Recently Registered Customers

**Objective:** List orders placed by customers who joined after 2022.

**SQL Query:**
```sql
SELECT * FROM Orders WHERE customer_id IN (SELECT customer_id FROM Customers WHERE registration_date > '2022-12-31');
```

**Output:**

| order_id | customer_id | order_date | total_amount | status |
|---|---|---|---|---|
| 7 | 3 | 2025-05-01 | 6499 | Delivered |
| 8 | 3 | 2025-05-01 | 15999 | Delivered |
| 9 | 4 | 2025-03-25 | 499 | Cancelled |
| 10 | 4 | 2025-07-01 | 2599 | Shipped |
| 15 | 6 | 2025-02-01 | 399 | Cancelled |
| 16 | 7 | 2025-06-10 | 1599 | Pending |
| 18 | 9 | 2025-07-20 | 3499 | Pending |
| 20 | 3 | 2025-08-10 | 899 | Shipped |

---

## 27. Highest-Spending Customer

**Objective:** Identify the single customer with the highest total spend.

**SQL Query:**
```sql
SELECT * FROM Customers WHERE customer_id = (SELECT customer_id FROM Orders GROUP BY customer_id ORDER BY SUM(total_amount) DESC LIMIT 1);
```

**Output:**

| customer_id | name | email | phone_number | address | registration_date |
|---|---|---|---|---|---|
| 3 | Amit Verma | amit@example.com | 9876500002 | 9 Lake View, Pune | 2023-01-05 |

---

## 28. Products Never Ordered

**Objective:** Find products that have never appeared in any order (candidates for promotion or delisting).

**SQL Query:**
```sql
SELECT * FROM Products WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Order_Items);
```

**Output:**

| product_id | name | category_id | price | stock_quantity | added_date |
|---|---|---|---|---|---|
| 6 | Cotton T-Shirt | 3 | 499 | 100 | 2025-03-01 |

---

## 29. Orders per Month

**Objective:** Count how many orders were placed in each calendar month.

**SQL Query:**
```sql
SELECT MONTHNAME(order_date) AS order_month, COUNT(order_id) AS total_orders FROM Orders GROUP BY MONTH(order_date), MONTHNAME(order_date);
```

**Output:**

| order_month | total_orders |
|---|---|
| February | 1 |
| March | 1 |
| April | 4 |
| May | 4 |
| June | 4 |
| July | 4 |
| August | 2 |

---

## 30. Delivery Time per Shipment

**Objective:** Calculate how many days each delivered shipment took, from dispatch to delivery.

**SQL Query:**
```sql
SELECT shipping_id, order_id, DATEDIFF(delivery_date, shipping_date) AS delivery_time_days FROM Shipping WHERE delivery_date IS NOT NULL;
```

**Output:**

| shipping_id | order_id | delivery_time_days |
|---|---|---|
| 1 | 1 | 3 |
| 2 | 2 | 4 |
| 4 | 5 | 5 |
| 5 | 6 | 2 |
| 6 | 7 | 6 |
| 7 | 8 | 5 |
| 9 | 11 | 4 |
| 10 | 12 | 4 |
| 11 | 13 | 4 |
| 12 | 17 | 4 |

---

## 31. Orders With Formatted Date

**Objective:** Display order dates in DD-MM-YYYY format for reporting.

**SQL Query:**
```sql
SELECT order_id, DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_order_date FROM Orders;
```

**Output:**

| order_id | formatted_order_date |
|---|---|
| 1 | 02-04-2025 |
| 2 | 14-05-2025 |
| 3 | 20-06-2025 |
| 4 | 11-07-2025 |
| 5 | 18-04-2025 |
| 6 | 02-06-2025 |
| 7 | 01-05-2025 |
| 8 | 01-05-2025 |
| 9 | 25-03-2025 |
| 10 | 01-07-2025 |

*(showing 10 of 20 rows)*

---

## 32. Product Names in Uppercase

**Objective:** Normalize product names to uppercase for a catalog export.

**SQL Query:**
```sql
SELECT product_id, UPPER(name) AS uppercase_name, price FROM Products;
```

**Output:**

| product_id | uppercase_name | price |
|---|---|---|
| 1 | WIRELESS MOUSE | 1299 |
| 2 | MECHANICAL KEYBOARD | 3499 |
| 3 | BLUETOOTH SPEAKER | 2199 |
| 4 | NON-STICK PAN | 899 |
| 5 | AIR FRYER | 6499 |
| 6 | COTTON T-SHIRT | 499 |
| 7 | DENIM JACKET | 2599 |
| 8 | RUNNING SHOES | 3299 |
| 9 | YOGA MAT | 799 |
| 10 | NOVEL - FICTION | 399 |

*(showing 10 of 15 rows)*

---

## 33. Clean Customer Names

**Objective:** Strip stray leading/trailing whitespace from customer names.

**SQL Query:**
```sql
SELECT customer_id, TRIM(name) AS clean_name FROM Customers;
```

**Output:**

| customer_id | clean_name |
|---|---|
| 1 | Rahul Sharma |
| 2 | Priya Patel |
| 3 | Amit Verma |
| 4 | Sneha Iyer |
| 5 | Vikram Singh |
| 6 | Neha Gupta |
| 7 | Karan Mehta |
| 8 | Anjali Rao |
| 9 | Rohan Das |
| 10 | Isha Kapoor |

---

## 34. Fill Missing Emails

**Objective:** Replace NULL emails with a friendly placeholder for display.

**SQL Query:**
```sql
SELECT customer_id, name, COALESCE(email, 'Not Provided') AS email FROM Customers;
```

**Output:**

| customer_id | name | email |
|---|---|---|
| 1 | Rahul Sharma | rahul@example.com |
| 2 | Priya Patel | priya@example.com |
| 3 | Amit Verma | amit@example.com |
| 4 | Sneha Iyer | sneha@example.com |
| 5 | Vikram Singh | vikram@example.com |
| 6 | Neha Gupta | neha@example.com |
| 7 | Karan Mehta | Not Provided |
| 8 | Anjali Rao | anjali@example.com |
| 9 | Rohan Das | rohan@example.com |
| 10 | Isha Kapoor | isha@example.com |

---

## 35. Customer Spending Rank

**Objective:** Rank customers by total amount spent, highest first.

**SQL Query:**
```sql
SELECT customer_id, SUM(total_amount) AS total_spent, RANK() OVER (ORDER BY SUM(total_amount) DESC) AS spending_rank FROM Orders GROUP BY customer_id;
```

**Output:**

| customer_id | total_spent | spending_rank |
|---|---|---|
| 3 | 23397 | 1 |
| 8 | 12998 | 2 |
| 1 | 11696 | 3 |
| 5 | 8096 | 4 |
| 2 | 4297 | 5 |
| 9 | 3499 | 6 |
| 4 | 3098 | 7 |
| 7 | 1599 | 8 |
| 6 | 399 | 9 |

---

## 36. Monthly Revenue With Running Total

**Objective:** Show monthly revenue plus a cumulative (running) revenue total.

**SQL Query:**
```sql
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, SUM(total_amount) AS monthly_revenue, SUM(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS cumulative_revenue FROM Orders GROUP BY DATE_FORMAT(order_date, '%Y-%m');
```

**Output:**

| order_month | monthly_revenue | cumulative_revenue |
|---|---|---|
| 2025-02 | 399 | 399 |
| 2025-03 | 499 | 898 |
| 2025-04 | 7996 | 8894 |
| 2025-05 | 28996 | 37890 |
| 2025-06 | 3896 | 41786 |
| 2025-07 | 25095 | 66881 |
| 2025-08 | 2198 | 69079 |

---

## 37. Running Order Count

**Objective:** Show a running count of orders as they occur over time.

**SQL Query:**
```sql
SELECT order_id, order_date, customer_id, COUNT(order_id) OVER (ORDER BY order_date, order_id) AS running_order_count FROM Orders;
```

**Output:**

| order_id | order_date | customer_id | running_order_count |
|---|---|---|---|
| 15 | 2025-02-01 | 6 | 1 |
| 9 | 2025-03-25 | 4 | 2 |
| 1 | 2025-04-02 | 1 | 3 |
| 11 | 2025-04-10 | 5 | 4 |
| 5 | 2025-04-18 | 2 | 5 |
| 12 | 2025-04-22 | 5 | 6 |
| 7 | 2025-05-01 | 3 | 7 |
| 8 | 2025-05-01 | 3 | 8 |
| 2 | 2025-05-14 | 1 | 9 |
| 13 | 2025-05-30 | 5 | 10 |

*(showing 10 of 20 rows)*

---

## 38. Customer Loyalty Tiers

**Objective:** Classify each customer as Gold / Silver / Bronze based on total spend.

**SQL Query:**
```sql
SELECT c.customer_id, c.name, COALESCE(SUM(o.total_amount), 0) AS total_spent, CASE WHEN SUM(o.total_amount) > 50000 THEN 'Gold' WHEN SUM(o.total_amount) BETWEEN 20000 AND 50000 THEN 'Silver' ELSE 'Bronze' END AS Loyalty_Status FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id GROUP BY c.customer_id, c.name;
```

**Output:**

| customer_id | name | total_spent | Loyalty_Status |
|---|---|---|---|
| 1 | Rahul Sharma | 11696 | Bronze |
| 2 | Priya Patel | 4297 | Bronze |
| 3 | Amit Verma | 23397 | Silver |
| 4 | Sneha Iyer | 3098 | Bronze |
| 5 | Vikram Singh | 8096 | Bronze |
| 6 | Neha Gupta | 399 | Bronze |
| 7 | Karan Mehta | 1599 | Bronze |
| 8 | Anjali Rao | 12998 | Bronze |
| 9 | Rohan Das | 3499 | Bronze |
| 10 | Isha Kapoor | 0 | Bronze |

---

## 39. Product Popularity Tiers

**Objective:** Classify each product as Best Seller / Popular / Regular based on units sold.

**SQL Query:**
```sql
SELECT p.product_id, p.name, COALESCE(SUM(oi.quantity), 0) AS units_sold, CASE  WHEN SUM(oi.quantity) > 500 THEN 'Best Seller' WHEN SUM(oi.quantity) BETWEEN 200 AND 500 THEN 'Popular' ELSE 'Regular' END AS Product_Category FROM Products p LEFT JOIN Order_Items oi ON p.product_id = oi.product_id GROUP BY p.product_id, p.name;
```

**Output:**

| product_id | name | units_sold | Product_Category |
|---|---|---|---|
| 1 | Wireless Mouse | 9 | Regular |
| 2 | Mechanical Keyboard | 4 | Regular |
| 3 | Bluetooth Speaker | 1 | Regular |
| 4 | Non-stick Pan | 2 | Regular |
| 5 | Air Fryer | 2 | Regular |
| 6 | Cotton T-Shirt | 0 | Regular |
| 7 | Denim Jacket | 1 | Regular |
| 8 | Running Shoes | 1 | Regular |
| 9 | Yoga Mat | 1 | Regular |
| 10 | Novel - Fiction | 2 | Regular |

*(showing 10 of 15 rows)*

---
