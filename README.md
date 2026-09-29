# 🛒 E-Commerce Order Management System

A comprehensive MySQL database solution designed to manage and streamline core e-commerce operations, including products, customers, orders, payments, and shipping logstics.

---

## 📌 Objectives

Develop an **E-Commerce Order Management System** using **MySQL** that enables admins to manage operations efficiently and analyze sales data using advanced SQL queries, joins, window functions, and dynamic conditional logic.

---

## 🚀 Key Features

* **CRUD Operations**: Manage products, customers, and orders with automated inventory stock updates.
* **Complex Data Filtering & Analysis**: Retrieve records based on dynamic date ranges, status filters, and spending thresholds.
* **Customer Loyalty & Sales Categorization**: Dynamic classification of customers and product performance using SQL `CASE` statements.
* **Financial Analytics**: Compute store performance metrics including monthly revenue trends, average order values, and category-level earnings.

---

## 📐 Database Schema

The database consists of **7 interconnected tables** linked through primary and foreign keys:

### Entity Relationship Diagram (ASCII Overview)

```text
+------------------+         +------------------+         +------------------+
|    Categories    |         |     Products     |         |    Customers     |
+------------------+         +------------------+         +------------------+
| category_id (PK) | <-------| category_id (FK) |         | customer_id (PK) |
| category_name    |         | product_id (PK)  |         | name, email      |
+------------------+         | name, price      |         | phone, address   |
                             | stock_quantity   |         +------------------+
                             +------------------+                  |
                                      ^                            |
                                      |                            v
+------------------+         +------------------+         +------------------+
|     Payments     |         |   Order_Items    |         |      Orders      |
+------------------+         +------------------+         +------------------+
| payment_id (PK)  |         | order_item_id(PK)|         | order_id (PK)    |
| order_id (FK)  |-------->| order_id (FK)    |<--------| customer_id (FK) |
| method, status   |         | product_id (FK)  |         | order_date       |
+------------------+         | quantity         |         | total_amount     |
                             | subtotal         |         | status           |
                             +------------------+         +------------------+
                                                                   |
                                                                   v
                                                          +------------------+
                                                          |     Shipping     |
                                                          +------------------+
                                                          | shipping_id (PK) |
                                                          | order_id (FK)    |
                                                          | shipping_status  |
                                                          +------------------+
```

### Table Structure

1. **`Categories`**: `category_id` (PK), `category_name`
2. **`Products`**: `product_id` (PK), `name`, `category_id` (FK), `price`, `stock_quantity`, `added_date`
3. **`Customers`**: `customer_id` (PK), `name`, `email`, `phone_number`, `address`, `registration_date`
4. **`Orders`**: `order_id` (PK), `customer_id` (FK), `order_date`, `total_amount`, `status` (`Pending`, `Shipped`, `Delivered`, `Cancelled`)
5. **`Order_Items`**: `order_item_id` (PK), `order_id` (FK), `product_id` (FK), `quantity`, `subtotal`
6. **`Payments`**: `payment_id` (PK), `order_id` (FK), `payment_date`, `payment_method` (`Credit Card`, `PayPal`, `UPI`), `payment_status` (`Paid`, `Pending`, `Failed`)
7. **`Shipping`**: `shipping_id` (PK), `order_id` (FK), `shipping_date`, `delivery_date`, `shipping_status` (`Dispatched`, `In Transit`, `Delivered`)

---

## 🛠️ Included SQL Functionalities

The project script (`ecommerce_management.sql`) implements the following core SQL requirements:

### 1. CRUD Operations
* Insert new records into products, customers, and orders tables.
* Dynamic stock level updates upon order creation.
* Automated removal of cancelled orders older than 30 days.

### 2. Querying & Filtering (`WHERE`, `HAVING`, `LIMIT`)
* Retrieve orders placed within the last 6 months.
* Extract top 5 highest-priced products.
* Identify customers with more than 3 placed orders.

### 3. Logical Operations (`AND`, `OR`, `NOT`)
* Select orders where `status = 'Pending'` **AND** `payment_status = 'Paid'`.
* Fetch all products that are **NOT** out of stock.
* Filter customers registered after 2022 **OR** with purchases exceeding ₹10,000.

### 4. Sorting & Aggregations (`ORDER BY`, `GROUP BY`)
* Display products sorted by price in descending order.
* Calculate total orders per customer and total revenue per product category.
* Compute total store revenue, average order value, max/min pricing, and total customer count.

### 5. Joins & Subqueries
* Multi-table joins across `Orders`, `Customers`, `Payments`, and `Shipping`.
* Subqueries to find customers who placed orders above average spending.

### 6. Advanced SQL (Window Functions & CASE Expressions)
* **Customer Loyalty Classification**:
  * `Gold`: Total spend > ₹50,000
  * `Silver`: Total spend between ₹20,000 and ₹50,000
  * `Bronze`: Total spend < ₹20,000
* **Product Performance**:
  * `Best Seller`: Quantity sold > 500 units
  * `Popular`: Quantity sold between 200–500 units
  * `Regular`: Quantity sold < 200 units
* **Window Functions**: Rank customers by total spending and calculate cumulative store revenue over time.

---

## 📂 Repository Structure

```text
.
├── README.md                  # Project documentation
└── ecommerce_management.sql   # Database setup & SQL queries script
```

---

## 💻 How to Setup and Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/ecommerce-order-management.git
   cd ecommerce-order-management
   ```

2. **Import into MySQL**:
   ```bash
   mysql -u root -p < ecommerce_management.sql
   ```

3. **Verify Database**:
   ```sql
   USE ecommerce_db;
   SHOW TABLES;
   ```
