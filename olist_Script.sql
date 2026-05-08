-- Create Database olist_dataset;
-- use olist_dataset;

-- Create table olist_orders_dataset ( order_id varchar(60) Primary key, 
-- customer_id varchar(60), order_status varchar(20),
--  order_purchase_timestamp varchar(60) Null ,order_approved_at varchar(60) Null,
--  order_delivered_carrier_date varchar(60) Null, order_delivered_customer_date varchar(60) Null,
--  order_estimated_delivery_date varchar(60));


-- Create table olist_customer_dataset( customer_id Varchar(60) Primary Key , customer_unique_id varchar(60) , 
-- customer_zip_code_prefix int, customer_city varchar(40), customer_state varchar(20));  

-- Create Table  olist_geolocation_dataset (geolocation_zip_code_prefix int, geolocation_lat Decimal(15,13),
-- geolocation_lng Decimal(15,13),geolocation_city varchar(40),geolocation_state varchar(20)); 

-- Create Table olist_sellers_dataset(seller_id varchar(40) Primary Key,seller_zip_code_prefix Int,
-- seller_city varchar(40),seller_state varchar(20));


-- LOAD DATA LOCAL INFILE 'D:/Roshan/Olist_E-commerce_Analysis/olist_orders_dataset.csv'
-- INTO TABLE olist_orders_dataset
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (order_id,customer_id ,order_status, order_purchase_timestamp,order_approved_at,
-- order_delivered_carrier_date,order_delivered_customer_date,order_estimated_delivery_date); 


-- LOAD DATA LOCAL INFILE 'D:/Roshan/Olist_E-commerce_Analysis/olist_customers_dataset.csv'
-- INTO TABLE olist_customer_dataset
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (customer_id,customer_unique_id,customer_zip_code_prefix, customer_city,
-- customer_state);

-- select Count(*) as count from olist_customer_dataset ;

-- LOAD DATA LOCAL INFILE 'D:/Roshan/Olist_E-commerce_Analysis/olist_geolocation_dataset.csv'
-- INTO TABLE olist_geolocation_dataset
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (geolocation_zip_code_prefix,geolocation_lat,geolocation_lng, geolocation_city,
-- geolocation_state);

Select Count(*) as count from olist_geolocation_dataset;



-- Create Table olist_sellers_dataset(seller_id varchar(40) Primary Key,seller_zip_code_prefix Int,
-- seller_city varchar(40),seller_state varchar(20));

-- LOAD DATA LOCAL INFILE 'D:/Roshan/Olist_E-commerce_Analysis/olist_sellers_dataset.csv'
-- INTO TABLE olist_sellers_dataset
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (seller_id,seller_zip_code_prefix,seller_city, seller_state);

-- select Count(*) as count from olist_sellers_dataset ;




