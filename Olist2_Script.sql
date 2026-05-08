-- Create Table olist_products_dataset(
-- product_id varchar(60) Primary Key,
-- product_category_name Varchar(60),
-- product_name_lenght Int,
-- product_description_lenght Int,
-- product_photos_qty Int,
-- product_weight_g Int,
-- product_length_cm Int,
-- product_height_cm Int,
-- product_width_cm Int
-- );

-- Create Table product_category_name_translation(
-- product_category_name Varchar(60),
-- product_category_name_english Varchar(60)
-- );


-- LOAD DATA LOCAL INFILE 'E:/Programs Roshan/Olist_E-commerce_Analysis/olist_products_dataset.csv'
-- INTO TABLE olist_products_dataset
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (product_id,
--  product_category_name,
--  product_name_lenght,
--  product_description_lenght,
--  product_photos_qty,
--  product_weight_g,
--  product_length_cm,
--  product_height_cm,
--  product_width_cm);
 
-- LOAD DATA LOCAL INFILE 'E:/Programs Roshan/Olist_E-commerce_Analysis/product_category_name_translation.csv'
-- INTO TABLE product_category_name_translation
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (product_category_name,
--  product_category_name_english);


-- Select Avg(Case When TRIM(REPLACE(sub.product_category_name_english, '\r', '')) ='electronics' Then DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)
-- Else Null End) as Avg_elec_del,
-- Avg(Case When TRIM(REPLACE(sub.product_category_name_english, '\r', '')) !='electronics' Then DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)
-- Else Null End) as Avg_del From
-- (Select Distinct o.order_id,n.product_category_name_english, o.order_delivered_customer_date,o.order_estimated_delivery_date
-- From olist_order_items_dataset i join olist_orders_dataset o 
-- on i.order_id=o.order_id
-- Join olist_products_dataset p on i.product_id=p.product_id
-- Join product_category_name_translation n on p.product_category_name=n.product_category_name
-- where o.order_status='delivered') sub;


With c as(Select i.seller_id,o.order_id, o.order_delivered_carrier_date, 
o.order_approved_at
From olist_orders_dataset o 
Join olist_order_items_dataset i on o.order_id=i.order_id),

s as (Select seller_id,Count(order_id) as order_by_seller From c group by seller_id)

Select Avg(Case When order_by_seller>36 Then DATEDIFF(c.order_delivered_carrier_date, c.order_approved_at) Else Null End) as Avg_high_vol_days,
Avg(Case When order_by_seller<=36 Then DATEDIFF(c.order_delivered_carrier_date, c.order_approved_at) Else Null End) as Avg_low_vol_days
From c Left Join s on c.seller_id=s.seller_id;





 

