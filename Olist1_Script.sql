 -- use olist_dataset;
 
-- Select Count(order_id) as total_delivery from olist_orders_dataset
-- where order_status='delivered';

-- Select late_delivery, total_delivery,
-- (late_delivery/total_delivery) * 100 as percentage
-- From
-- (Select 
-- Sum(Case when  order_delivered_customer_date> order_estimated_delivery_date Then 1 Else 0 End ) as late_delivery,
-- Count(order_id) as total_delivery
-- from olist_orders_dataset
-- where order_status='delivered') as summary;

SET SESSION wait_timeout = 800;
--  
-- Create Table geo_less as Select geolocation_zip_code_prefix, Avg(geolocation_lat) as Avg_lat , Avg(geolocation_lng) as Avg_lng 
-- from olist_geolocation_dataset
-- Group By geolocation_zip_code_prefix;

SET SESSION wait_timeout = 28800;
SET SESSION interactive_timeout = 28800;
SET global net_read_timeout = 300;
SET global net_write_timeout = 300;

CREATE INDEX idx_geo_zip ON geo_less(geolocation_zip_code_prefix);
CREATE INDEX idx_cust_zip ON olist_customer_dataset(customer_zip_code_prefix);
CREATE INDEX idx_seller_zip ON olist_sellers_dataset(seller_zip_code_prefix);

SELECT * FROM geo_less ;

WITH c AS (
    SELECT 
        cu.customer_id,
        g.Avg_lat,
        g.Avg_lng
    FROM olist_customer_dataset cu
    LEFT JOIN geo_less g
        ON cu.customer_zip_code_prefix = g.geolocation_zip_code_prefix
),

s AS (
    SELECT 
        se.seller_id,
        g.Avg_lat,
        g.Avg_lng
    FROM olist_sellers_dataset se
    LEFT JOIN geo_less g
        ON se.seller_zip_code_prefix = g.geolocation_zip_code_prefix
),

i AS (
    SELECT 
        it.order_id,
        it.seller_id,
        c.Avg_lat AS customer_lat,
        c.Avg_lng AS customer_lng,
        s.Avg_lat AS seller_lat,
        s.Avg_lng AS seller_lng
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset it
        ON o.order_id = it.order_id
    JOIN c
        ON o.customer_id = c.customer_id
    JOIN s
        ON it.seller_id = s.seller_id
)

SELECT 
    delivery_flag,
    Round(AVG(distance),2) AS avg_distance
FROM (
    SELECT 
        6371 * ACOS(
            COS(RADIANS(i.seller_lat)) *
            COS(RADIANS(i.customer_lat)) *
            COS(RADIANS(i.seller_lng) - RADIANS(i.customer_lng)) +
            SIN(RADIANS(i.seller_lat)) *
            SIN(RADIANS(i.customer_lat))
        ) AS distance,

        CASE 
            WHEN ol.order_delivered_customer_date > ol.order_estimated_delivery_date
            THEN 'Late'
            ELSE 'On_Time'
        END AS delivery_flag

    FROM i
    JOIN olist_orders_dataset ol
        ON i.order_id = ol.order_id

    WHERE ol.order_status = 'delivered'
) AS dis

GROUP BY delivery_flag;
 
 






