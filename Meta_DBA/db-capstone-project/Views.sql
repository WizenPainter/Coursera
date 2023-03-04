/*Use the project database*/
USE LittleLemonDB;

/*Check the column names of the target table. Can also be done in MySQL Workbench*/
SHOW COLUMNS FROM Orders;

/* Make a virtual table that retrieves the OrderID, Quantity and totalcost from orders table*/
CREATE VIEW OrdersView AS SELECT OrderID, Quantity, TotalCost FROM Orders;

/*Call virtual table to check for any errors.*/
SELECT * FROM OrdersView;

/* Create second virtual table that contains customer id, customer full name, order id, order cost,
the menu name, the course name and starter items. Also show only orders where the cost was $15-
or more.*/

CREATE VIEW OrderDetails AS
SELECT Orders.CustomerID, CONCAT(Customers.FirstName, ' ', Customers.Lastname) AS 'FullName', 
Orders.OrderID, Orders.TotalCost, Menu.Cuisine, Menu.Courses, Menu.Starters FROM Orders
INNER JOIN Customers ON
Orders.CustomerID = Customer.CustomerID
INNER JOIN Customers ON
Orders.CustomerID = Customers.CustomerID
INNER JOIN Menus ON
Orders.MenuID = Menus.MunuID
WHERE Orders.TotalCost > 150;

/*Virtual table that shows menu items that have 2 or more orders utilizing the ANY operator*/
CREATE VIEW PopularItem AS 
SELECT Cuisine FROM Menu
WHERE COUNT(Starters) > ANY(
	SELECT COUNT(Menu.Starters) FROM MENU
    INNER JOIN Orders ON
    Menu.MunuID = Orders.MenuID
    WHERE COUNT(Menu.Starters) >= 2);

