/*Script to insert data into the tables*/

USE LittleLemonDB;
-- Bookings table
INSERT INTO Bookings(BookingID, Date, TableNo, CustomerID) VALUES (1, '2022-10-10',5, 1), 
(2, '2022-11-12', 3, 3), (3, '2022-10-11', 2, 2), (4, '2022-10-13',2, 1);

INSERT INTO Customers(CustomerID, FirstName, LastName) VALUES
(1, 'Manuel', 'Gomez'),(2, 'Maria', 'Scotch'),(3, 'Jessica', 'Windorf');

/*Stored procedure used to check wheter a table is booked on a certain day*/
DELIMITER //
CREATE PROCEDURE CheckBookings(IN checkDay DATE, checkTable INT)
BEGIN
	SELECT CASE
		WHEN checkTable = (SELECT TableNo FROM Bookings WHERE Date = checkDay) THEN CONCAT("Table ", checkTable, " is already booked")
        ELSE CONCAT("Table ", checkTable, " is not booked")
	END
    FROM Bookings;
END //
DELIMITER ;

CALL CheckBookings("2022-11-12", 3);

/*Stored procedure that check for availability of a table. It starts a transaction that is rollbacked when the table is already
booked on the same day. To check with the example from coursera it is necessary to insert a new data field*/

INSERT INTO Bookings(BookingID, Date, TableNo, CustomerID) VALUES(5, "2022-12-17",6, 3);

DELIMITER //
CREATE PROCEDURE AddValidBooking(IN bookDate DATE, IN bookTable INT)
BEGIN
	START TRANSACTION;
		SELECT @validity :=
        CASE
			WHEN bookTable = (SELECT TableNo FROM Bookings WHERE Date = bookDate) THEN CONCAT("Table ", bookTable, " is already booked")
			ELSE CONCAT("Table ", bookTable, " is not booked")
		END
        FROM Bookings;
		INSERT INTO Bookings(BookingID, Date, TableNo, CustomerID) VALUES (6, bookDate, bookTable, 3);
        IF @validity = CONCAT("Table ", bookTable, " is already booked") THEN 
			ROLLBACK;
            SELECT CONCAT("Table ", bookTable, " is already booked - booking cancelled");
        ELSE 
			COMMIT;
            SELECT CONCAT("Table ", bookTable, " is not booked");
		END IF;
END //
DELIMITER ;

DROP Procedure AddValidBooking;


CALL AddValidBooking("2022-12-17",6);
SELECT * FROM Bookings;

/*New Stored procedure used to add new data to the bookings table*/
DELIMITER //
CREATE PROCEDURE AddBooking(IN bookID INT, custID INT, bookDate DATE, bookTable INT)
BEGIN
	INSERT INTO Bookings (BookingID, CustomerID, Date, TableNo) VALUES (bookId, custID, bookDate, booktable);
    SELECT CONCAT("New booking added");
END//
DELIMITER ;

CALL AddBooking(9, 3, "2022-12-30", 4);

/*
Stored procedure that updates a booking. This procedure takes in the booking id and the date. This procedure updates the
date of the booking.
*/
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN bookID INT, IN bookDate DATE)
	BEGIN
		UPDATE Bookings
			SET Date = bookDate
            WHERE BookingID = bookID;
		SELECT CONCAT("Booking ", bookID, " has been updated.");
	END //
DELIMITER ;

CALL UpdateBooking(9, "2022-12-17");
-- SELECT * FROM Bookings;

/*
Stored Procedure used to cancel bookings by deleting them. The procedure thakes in the booking id to identify which
booking to cancel.
*/
DELIMITER //
CREATE PROCEDURE CancelBooking(IN bookID INT)
	BEGIN
		DELETE FROM Bookings WHERE BookingID = bookID;
        SELECT CONCAT("Booking ", bookID, " cancelled.");
    END //
DELIMITER ;

CALL CancelBooking(9);
-- SELECT * FROM Bookings;

