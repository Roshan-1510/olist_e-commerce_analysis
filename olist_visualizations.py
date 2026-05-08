import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


cnx = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Roshan@15",
    database="olist_dataset"
)

# Query 1

data = {
    'Status': ['Late Deliveries', 'On Time Deliveries'],
    'Percentage': [8.11, 91.89]
}
df1 = pd.DataFrame(data)


print(df1)

# Visualization

sns.barplot(x='Status', y='Percentage', data=df1)
plt.title('Percentage of Late Deliveries')
plt.xlabel('Delivery Status')
plt.ylabel('Percentage')
plt.show()


# Query 2

query2 = """ With c as (
    Select cu.customer_id, cu.customer_zip_code_prefix, g.Avg_lat, g.Avg_lng 
    From olist_customer_dataset cu
    Left Join geo_less g on cu.customer_zip_code_prefix = g.geolocation_zip_code_prefix
),
s as (
    Select se.seller_id, se.seller_zip_code_prefix, g.Avg_lat, g.Avg_lng 
    From olist_sellers_dataset se
    Left Join geo_less g on se.seller_zip_code_prefix = g.geolocation_zip_code_prefix
),
i as (
    Select it.order_id, it.seller_id, 
        c.Avg_lat as customer_lat, c.Avg_lng as customer_lng,
        s.Avg_lat as seller_lat, s.Avg_lng as seller_lng 
    From olist_orders_dataset o 
    Join olist_customer_dataset cu on o.customer_id = cu.customer_id 
    Join olist_order_items_dataset it on o.order_id = it.order_id 
    Join olist_sellers_dataset se on se.seller_id = it.seller_id
    Join c on cu.customer_id = c.customer_id
    Join s on se.seller_id = s.seller_id
)
Select delivery_flag, Avg(distance) as avg_distance
From (
    Select 
        6371 * ACOS(
            COS(RADIANS(i.seller_lat)) * COS(RADIANS(i.customer_lat)) *
            COS(RADIANS(i.seller_lng) - RADIANS(i.customer_lng)) +
            SIN(RADIANS(i.seller_lat)) * SIN(RADIANS(i.customer_lat))
        ) as distance,
        Case when order_delivered_customer_date > order_estimated_delivery_date 
            Then 'Late' Else 'On_Time' End as delivery_flag
    From i 
    Join olist_orders_dataset ol on i.order_id = ol.order_id
    Where ol.order_status = 'delivered'
) as dis
Group by delivery_flag; """

df2 = pd.read_sql(query2, cnx)
print(df2)

# Visualization

sns.barplot(x='delivery_flag', y='avg_distance', data=df2)
plt.title('Average Distance for Late vs On-Time Deliveries')
plt.xlabel('Delivery Status')
plt.ylabel('Average Distance (km)')
plt.show()

# Query 3

query3 = """ Select 
    Avg(Case When TRIM(REPLACE(sub.product_category_name_english, '\r', '')) = 'electronics' 
        Then DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) 
        Else Null End) as Avg_elec_del,
    Avg(Case When TRIM(REPLACE(sub.product_category_name_english, '\r', '')) != 'electronics' 
        Then DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) 
        Else Null End) as Avg_del 
From (
    Select Distinct o.order_id, n.product_category_name_english, 
        o.order_delivered_customer_date, o.order_estimated_delivery_date
    From olist_order_items_dataset i 
    Join olist_orders_dataset o on i.order_id = o.order_id
    Join olist_products_dataset p on i.product_id = p.product_id
    Join product_category_name_translation n on p.product_category_name = n.product_category_name
    Where o.order_status = 'delivered'
) sub;"""

df3 = pd.read_sql(query3, cnx)
print(df3)

# Visualization

categories = ['Electronics', 'Other']
avg_distances = [df3.iloc[0]['Avg_elec_del'], df3.iloc[0]['Avg_del']]
sns.barplot(x=categories, y=avg_distances)
plt.title('Average Days Before Estimated Delivery Date — Electronics vs Other')
plt.xlabel('Product Category')
plt.ylabel('Average Delivery Delay (days)')
plt.axhline(y=0, color='black', linewidth=0.8)
plt.show()

# Query 4

query4 = """ With c as (
    Select i.seller_id, o.order_id, 
        o.order_delivered_carrier_date, o.order_approved_at
    From olist_orders_dataset o 
    Join olist_order_items_dataset i on o.order_id = i.order_id
),
s as (
    Select seller_id, Count(order_id) as order_by_seller 
    From c 
    Group by seller_id
)
Select 
    Avg(Case When order_by_seller > 36 
        Then DATEDIFF(c.order_delivered_carrier_date, c.order_approved_at) 
        Else Null End) as Avg_high_vol_days,
    Avg(Case When order_by_seller <= 36 
        Then DATEDIFF(c.order_delivered_carrier_date, c.order_approved_at) 
        Else Null End) as Avg_low_vol_days
From c 
Left Join s on c.seller_id = s.seller_id;"""

df4 = pd.read_sql(query4, cnx)
print(df4)

# Visualization

categories = ['High Volume Sellers', 'Low Volume Sellers']
avg_delays = [df4.iloc[0]['Avg_high_vol_days'], df4.iloc[0]['Avg_low_vol_days']]
sns.barplot(x=categories, y=avg_delays)
plt.title('Average Delivery Time for High vs Low Volume Sellers')
plt.xlabel('Seller Volume')
plt.ylabel('Average Delivery Time (days)')
plt.show()


# Close connection when done
cnx.close()

