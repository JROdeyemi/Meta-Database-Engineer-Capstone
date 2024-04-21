-- Insert 4 new records into the bookings table
START TRANSACTION;

SET foreign_key_checks = 0;

INSERT INTO Bookings
VALUES(1, '2022-10-10', 5, 1), (2, '2022-11-12', 3, 3), (3, '2022-10-11', 2, 2), (4, '2022-10-13', 2, 1);

SET foreign_key_checks = 1;

COMMIT;

-- Create a stored procedure that takes in two parameters to check whether a table has been booked.
DELIMITER //

CREATE PROCEDURE CheckBooking(IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE is_booked INT;

    -- Check if the table is booked on the given date
    SELECT COUNT(*) INTO is_booked
    FROM Bookings
    WHERE BookingDate = booking_date AND TableNumber = table_number;

    -- Return the result
    IF is_booked > 0 THEN
        SELECT CONCAT('Table ', table_number, ' is already booked on ', booking_date) AS Result;
    ELSE
        SELECT CONCAT('Table ', table_number, ' is available on ', booking_date) AS Result;
    END IF;
END//

DELIMITER ;

CALL CheckBooking("2022-11-12", 3);

-- Create a stored procedure that helps LittleLemon verify a booking and decline any reservations for table that are 
-- already booked under another name.
DELIMITER //

CREATE PROCEDURE AddValidBooking(IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE is_booked INT;
    DECLARE new_booking_id INT;

    -- Start the transaction
    START TRANSACTION;

    -- Find the maximum BookingID and add one to it
    SELECT IFNULL(MAX(BookingID), 0) + 1 INTO new_booking_id FROM Bookings;

    -- Check if the table is already booked on the given date
    SELECT COUNT(*) INTO is_booked
    FROM Bookings
    WHERE BookingDate = booking_date AND TableNumber = table_number;

    -- If the table is already booked, rollback the transaction
    IF is_booked > 0 THEN
        ROLLBACK;
        SELECT CONCAT('Booking failed. Table ', CAST(table_number AS CHAR), ' is already booked on ', CAST(booking_date AS CHAR)) AS Result;
    ELSE
        -- Insert the new booking record
        INSERT INTO Bookings (BookingID, CustomerID, BookingDate, TableNumber)
        VALUES (new_booking_id, 6, booking_date, table_number);

        -- Commit the transaction
        COMMIT;
        SELECT CONCAT('Booking successful. Table ', CAST(table_number AS CHAR), ' has been reserved for ', CAST(booking_date AS CHAR)) AS Result;
    END IF;
END//

DELIMITER ;

CALL AddValidBooking('2022-12-17', 6);

-- Create a new procedure to add a new table booking record
DELIMITER //

CREATE PROCEDURE AddBooking(
    IN booking_id INT,
    IN customer_id INT,
    IN booking_date DATE,
    IN table_number INT
)
BEGIN
    -- Insert the new booking record
    INSERT INTO Bookings (BookingID, CustomerID, BookingDate, TableNumber)
    VALUES (booking_id, customer_id, booking_date, table_number);
    
    SELECT 'Booking added successfully' AS Result;
END//

DELIMITER ;

CALL AddBooking(9, 3, "2022-12-30", 4);

-- Create a Procedure LittleLemon can use to update existing bookings in the booking table
DELIMITER //

CREATE PROCEDURE UpdateBooking(
    IN booking_id INT,
    IN booking_date DATE
)
BEGIN
    -- Update the booking record
    UPDATE Bookings
    SET BookingDate = booking_date
    WHERE BookingID = booking_id;
    
    SELECT 'Booking updated successfully' AS Result;
END//

DELIMITER ;

CALL UpdateBooking(9, "2022-12-17");

-- Create a new procedure that can be used to cancel or remove a booking
DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN booking_id INT
)
BEGIN
    -- Delete the booking record
    DELETE FROM Bookings
    WHERE BookingID = booking_id;
    
    SELECT 'Booking canceled successfully' AS Result;
END//

DELIMITER ;

CALL CancelBooking(9);