-- 1. Display 10 rows from 'store' database
SELECT * FROM store
LIMIT 10;

-- 2. Display the total number of orders and customers
SELECT
COUNT(DISTINCT(order_id)) AS total_orders
FROM store;

SELECT
COUNT(DISTINCT(customer_id))
AS number_of_customers
FROM store;

-- 3. Display customer details and filter by customer id;
SELECT
customer_id,
customer_email,
customer_phone
FROM store
WHERE customer_id = 1;

-- 4. Display items filtered by item id;
SELECT
item_1_id,
item_1_name,
item_1_price
FROM store
WHERE item_1_id = 4;

-- 5. Create customers table from store table
CREATE TABLE customers AS 
SELECT DISTINCT
customer_id,
customer_phone,
customer_email
FROM store;

-- 6. Add primary key to customers table
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- 7. Create items table from store table and add primary key
CREATE TABLE items AS
SELECT DISTINCT
item_1_id AS item_id,
item_1_name AS name,
item_1_price AS price
FROM store
UNION
SELECT DISTINCT
item_2_id AS item_id,
item_2_name AS name,
item_2_price AS Price
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT DISTINCT
item_1_id AS item_id,
item_1_name AS name,
item_1_price AS price
FROM store
WHERE item_1_id IS NOT NULL;

-- 8. Add primary key to items table
ALTER TABLE items
ADD PRIMARY KEY(item_id);

-- 9. Create a cross reference table for orders and items from store table
CREATE TABLE orders_items AS
SELECT
order_id,
item_1_id AS item_id
FROM store
UNION ALL
SELECT
order_id,
item_2_id AS item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT
order_id,
item_1_id
FROM store
WHERE item_1_id IS NOT NULL;

-- 10. Create orders table from store table
CREATE TABLE orders AS
SELECT
order_id,
order_date,
customer_id
FROM store;

-- 11. Add primary key to orders
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- 12. Add foreign keys to orders and orders_items
ALTER TABLE orders
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (item_id)
REFERENCES items(item_id);

-- 13. Add foreign key to order_items 
ALTER TABLE orders_items
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- 14. Display customer email whose order date is greater than July 25, 2019 from store
SELECT customer_email, order_date
FROM store
WHERE order_date > '2019-07-25';

-- 15. Display customer email whose order date is greater than July 25, 2019 from normalize tables
SELECT customer_email, order_date
FROM customers, orders
WHERE customers.customer_id = orders.customer_id
AND
orders.order_date > '2019-07-25';

-- 16. Display the number of orders containing each unique item from store
WITH all_items AS (
  SELECT item_1_id AS item_id
  FROM store
  UNION ALL
  SELECT item_2_id AS item_id
  FROM store
  WHERE item_2_id IS NOT NULL
  UNION ALL
  SELECT item_1_id AS item_id
  FROM store
  WHERE item_1_id IS NOT NULL
)
SELECT item_id, COUNT(*)
FROM all_items
GROUP BY item_id;

-- 17.  Display the number of orders containing each unique item from normalize table
SELECT item_id, COUNT(*)
FROM orders_items
GROUP BY item_id;
