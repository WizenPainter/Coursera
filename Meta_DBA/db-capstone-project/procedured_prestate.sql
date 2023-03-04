/* This document create the different stored procedures and prepared statements to optimize the use
of the database. To begin with there is a stored procedure that displays the maximum ordered quantity 
in the orders table. This shall only return a number*/

/*We change the delimiter so that we can create the procedure without error.*/
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
	SELECT MAX(Quantity) FROM Orders;
END //
DELIMITER ;

CALL GetMaxQuantity();

/*Now we create a prepared statement that takes in the customer id value and returns the
OrderID, Quantity and Cost in the orders table.*/

-- For more information on prepared statements check https://dev.mysql.com/doc/refman/8.0/en/sql-prepared-statements.html
PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE CustomerID = ?';

SET @id = 1; -- We set the CustomerID we want to query.
EXECUTE GetOrderDetail USING @id;

/*Finally we want to create a stored procedure that takes in a order id and cancels (deletes) that order form the table.
This procedure should also display that the order has been canceled. */

DELIMITER //
CREATE PROCEDURE CancelOrder(IN order_id INT)
BEGIN
	DELETE FROM Orders WHERE OrderID = order_id;
    SELECT CONCAT('Order ', order_id, ' is canceled');
END//
DELIMITER ;
