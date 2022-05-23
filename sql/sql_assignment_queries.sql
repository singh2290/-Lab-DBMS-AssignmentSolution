/*Author- Prateek Singh*/

/*Display the total number of customers based on gender who have placed orders of worth at least Rs.3000*/

select count(c.cus_id), c.cus_gender from customer c
join orders o on c.cus_id=o.cus_id
where ord_amount>=3000 group by c.cus_gender;

/*Display all the orders along with product name ordered by a customer having Customer_Id=2*/

select ord_id, ord_amount, ord_date, cus_id,pro_name from orders as o
join supplier_pricing as s on o.pricing_id=s.pricing_id 
join product as p on p.pro_id=s.pro_id
where cus_id=2;

/*Display the Supplier details who can supply more than one product.*/

select* from supplier where supp_id IN(select supp_id from supplier_pricing group by (supp_id) having count(supp_id)>1);

/*Find the least expensive product from each category and print the table with category id, name, product name and price of the product*/

select cat.cat_id, min(t2.supp_price) from category cat inner join(select * from product p inner join (select pro_id as id, supp_price from supplier_pricing group by(id) having min(supp_price)) as t1 on t1.id=p.pro_id) as t2 on t2.cat_id=cat.cat_id group by cat.cat_id;

/*Display the Id and Name of the Product ordered after “2021-10-05”*/

select pro_name, pro_desc from product as prod inner join
(select o.ord_date, sp.pro_id from orders as o inner join supplier_pricing as sp on sp.pricing_id=o.pricing_id and ord_date >="2021-10-05") as p1 on prod.pro_id = p1.pro_id;

/*Display customer name and gender whose names start or end with character 'A'.*/

select cus_name from customer where cus_name like 'a%' or cus_name like'%a';

/*Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent
Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.*/

drop procedure if exists supplier_ratings ;
DELIMITER &&  
CREATE PROCEDURE supplier_ratings ()  
BEGIN  
	
    SELECT sup.SUPP_ID as 'Supplier ID',sup.SUPP_NAME as 'Supplier Name',AVG(rate.RAT_RATSTARS) as 'Average Rating',
    CASE 
    WHEN AVG(rate.RAT_RATSTARS)=5 then "Excellent Service"
    WHEN AVG(rate.RAT_RATSTARS)>4 then "Good Service"
    WHEN AVG(rate.RAT_RATSTARS)>2 then "Average Service"
    ELSE "Poor Service"
    END as type_of_services
    FROM supplier sup 
    JOIN Supplier_pricing sp
	ON sup.SUPP_ID = sp.SUPP_ID  
    JOIN orders o
    ON sp.PRICING_ID=o.PRICING_ID
    JOIN rating rate
    ON o.ORD_ID=rate.ORD_ID GROUP BY (sup.SUPP_ID );
END &&  
DELIMITER ;  

call supplier_ratings();