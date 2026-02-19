Select * From Customer limit 5
--1.Total revenue by male vs female customer

Select Gender, Sum(Purchase_amt) as Revenue
From Customer
Group By Gender

--2.Customers who used discount but spent > average purchase amount

Select customer_id,purchase_amt
From customer
Where discount_applied = 'Yes' and purchase_amt >= (select avg(purchase_amt)from customer)

--3.Top 5 products by highest average review rating.


Select item_purchased ,AVG(review_rating) 
From Customer
Group by item_purchased
Order by review_rating Desc
limit 5

--4.Average purchase amount: standard vs express shipping

Select shipping_type,Round(AVG(purchase_amt),2) as avg_amt
From Customer
Where shipping_type in ('Standard','Express')
Group by shipping_type

--5.Do subscribed customers spend more? (avg spend and total revenue comparison)

Select subscription_status, Round(Avg(purchase_amt),2) as avg_amt ,Sum(purchase_amt) as revenue
From Customer
Group by subscription_status

--6.Top 5 products by highest % of purchases with discounts

SELECT 
    item_purchased,
    ROUND(
        100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*), 
    2) AS discount_percentage
FROM Customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5

--7.Customer segmentation (new/returning/loyal based on previous purchases)

Select
	Case
	 When previous_purchases = '1' then 'New'
	 When previous_purchases between 2 and 10 then 'Returning'
	 Else 'Loyal'
End as Customer_segment,
Round(Sum(purchase_amt),2) as Revenue
From Customer
Group by Customer_segment
Order by revenue Desc

--8.Revenue by age group 

SELECT age_group, ROUND(SUM(purchase_amt), 2) AS revenue
FROM (
    SELECT purchase_amt,
           CASE
               WHEN age BETWEEN 18 AND 25 THEN '18-25'
               WHEN age BETWEEN 26 AND 35 THEN '26-35'
               WHEN age BETWEEN 36 AND 45 THEN '36-45'
               WHEN age BETWEEN 46 AND 55 THEN '46-55'
               WHEN age BETWEEN 56 AND 65 THEN '56-65'
               WHEN age BETWEEN 66 AND 100 THEN '66-100'
               ELSE 'Outside Range'
           END AS age_group
    FROM Customer
) t
GROUP BY age_group
ORDER BY revenue desc

