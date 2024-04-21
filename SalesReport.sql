-- Create a virtual table called OrdersView that focuses on OrderID, Quantity and Cost columns within the Orders table 
-- for all orders with a quantity greater than 2.
select `little_lemon_db`.`orders`.`OrderID` AS `OrderID`,`little_lemon_db`.`orders`.`Quantity` AS `Quantity`,`little_lemon_db`.`orders`.`TotalCost` AS `TotalCost` 
from `little_lemon_db`.`orders` 
where (`little_lemon_db`.`orders`.`Quantity` > 2);


-- Write a query to get information of all customers with orders that cost more than $150. Return CustomerID, FullName,
-- OrderID, TotalCost, ItemName, and StaffName. Result should be sorted by the lowest cost amount. 
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.TotalCost, m.ItemName, s.StaffName
FROM Customers AS c
INNER JOIN Bookings AS b
	ON c.CustomerID = b.CustomerID 
INNER JOIN Orders AS o
	ON b.BookingID = o.BookingID
INNER JOIN Menu AS m
	ON o.ItemID = m.ItemID
INNER JOIN Staff AS s
	ON o.StaffID = s.StaffID
WHERE TotalCost > 150
ORDER BY o.TotalCost ASC;

-- Write a query to find all menu items for which the quantity in the order table is more than 2. Return only the Menuname
SELECT m.ItemName
FROM Menu AS m
WHERE m.ItemID = ANY(SELECT o.ItemID
					FROM Orders AS o
					WHERE o.quantity > 2);

-- Create a stored procedure that displays the maximum ordered quantity in the Orders table
CREATE PROCEDURE GetMaxQuantity()
SELECT MAX(Quantity)
FROM Orders;

CALL GetMaxQuantity();

--  Create a Prepared statement that produces the OrderID, Quantity, and Cost of orders made by a particular table booking
PREPARE GetOrderDetails FROM "SELECT OrderID, Quantity, TotalCost FROM Orders WHERE BookingID =?";

SET @bookingid = 1;
EXECUTE GetOrderDetails USING @bookingid;

-- Create a Stored Procedure that cancels any order by specifying the order id. The stored procedure should output a success message
DELIMITER $$

CREATE PROCEDURE CancelOrder(IN Order_ID INT)
BEGIN
    DELETE FROM Orders 
    WHERE OrderID = Order_ID;
    
    SELECT CONCAT('Order', ' ', Order_ID, ' ', 'is Cancelled.') AS message;


END $$

DELIMITER ;

CALL CancelOrder(4);



    
    
    


	
    
    

