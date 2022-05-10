---
title: "Shopify  Data science Challenge"
author: "Taiwo Owoseni"
date: "May 9th 2022"
output:
  pdf_document: default
  html_notebook: default
subtitle: SQL
---

### Questions

-   How many orders were shipped by Speedy Express in total?

-   What is the last name of the employee with the most orders?

-   What product was ordered the most by customers in Germany?

#### Question 1

How many orders were shipped by Speedy Express in total?

``` sql
SELECT COUNT(*) as 'number of orders: '
FROM Shippers sh
JOIN  Orders o
ON o.ShipperID = sh.ShipperID
WHERE sh.ShipperName = 'Speedy Express';
```

**Query Result: 54**

\

------------------------------------------------------------------------

#### Question 2

What is the last name of the employee with the most orders?

``` sql
/* create the view seperately */

CREATE VIEW count_orders_view AS
SELECT e.EmployeeID, Count(o.OrderID) as "no_order"
FROM Employees e
JOIN Orders o
ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID
ORDER BY "no_order" DESC
LIMIT 1;
```

``` sql
/* get Employee's LastName */

SELECT e.LastName
FROM Employees e,
count_orders_view v
WHERE v.EmployeeID = e.EmployeeID;
```

**Query Result : Peacock**\

------------------------------------------------------------------------

#### Question 3

What product was ordered the most by customers in Germany?

``` sql
/* All German Orders  */

CREATE view german_orders_view AS

SELECT o.OrderID
FROM Orders o
JOIN Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'Germany';
```

``` sql
/* productID ordered the most in Germany */

CREATE VIEW prod_bought_in_germany_view AS 

SELECT ProductID
FROM OrderDetails
WHERE orderID IN (SELECT orderID from german_orders_view)
GROUP BY ProductID
ORDER BY COUNT(orderID) DESC
LIMIT 1;
```

``` sql
/* productName ordered the most in Germany */

SELECT p.ProductName
FROM Products p, prod_bought_in_germany_view pbg
WHERE pbg.ProductID = p.ProductID;
```

**Query Result : Gorgonzola Telino**
