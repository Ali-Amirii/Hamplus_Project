CREATE DATABASE hamplus_project;
USE hamplus_project;


    #Section 1 - DDL queries
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    brand_name VARCHAR(255) NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    price DECIMAL(12, 2) NOT NULL
);

CREATE TABLE Stores (
    store_id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    country VARCHAR(50),
    city VARCHAR(50),
    address TEXT
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(25),
    country VARCHAR(50),
    city VARCHAR(50),
    address TEXT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    store_id INT,
    product_id INT,
    date DATETIME NOT NULL,
    status ENUM('Pending', 'Processing', 'Completed', 'Rejected') NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers (customer_id),
    FOREIGN KEY (store_id) REFERENCES Stores (store_id),
    FOREIGN KEY (product_id) REFERENCES Products (product_id)
);

CREATE TABLE Stocks (
    store_id INT,
    product_id INT,
    quantity INT UNSIGNED NOT NULL,
    FOREIGN KEY (store_id) REFERENCES Stores (store_id),
    FOREIGN KEY (product_id) REFERENCES Products (product_id)
);


    #Section 2 - DML queries
INSERT INTO Hamplus_Project.Products (product_name, brand_name, category_name, price)
VALUES ('Aryan', 'Golrang', 'Health', 155000.23);

UPDATE Hamplus_Project.Products t SET t.product_id = 1 WHERE t.product_id = 2;

INSERT INTO Hamplus_Project.Stores (store_name, phone, country, city, address)
VALUES ('Daryan', '02144567613', 'Iran', 'Tehran', 'Unit 1, 1st Fl., No.204, Forsat Shirazi St., Tohid St.');

INSERT INTO Hamplus_Project.Customers (first_name, last_name, phone_number, country, city, address)
VALUES ('Mohammad', 'Aliababdi', '09335671023', 'Iran', 'Shiraz','End of Fakhteh St., 10th Km.of Amir Kabir Blvd.');

INSERT INTO Hamplus_Project.Orders (customer_id, store_id, product_id, date, status, quantity, total_price)
VALUES (1, 1, 1, '2019-05-11 13:23:44', 'Completed', 3, 465000.69);

INSERT INTO Hamplus_Project.Stocks (store_id, product_id, quantity)
VALUES (1, 1, 546);

 INSERT INTO Hamplus_Project.Products (product_name, brand_name, category_name, price)
 VALUES ('Bahar', 'Ave', 'Health', 420000.00);

INSERT INTO Hamplus_Project.Products (product_name, brand_name, category_name, price)
VALUES ('Air Conditioner', 'LG', 'Electronic', 22000000.00);
#Other data inserted manually

    #Also these two triggers will take care of the quantity in our stocks
DELIMITER $$
CREATE TRIGGER after_order_insert
    BEFORE INSERT ON Orders
    FOR EACH ROW
BEGIN
    IF NEW.status <> 'Rejected' OR 'Pending' THEN UPDATE Stocks
        SET Stocks.quantity = Stocks.quantity - NEW.quantity
        WHERE Stocks.product_id = NEW.product_id AND Stocks.store_id = NEW.store_id;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_order_update
    BEFORE UPDATE ON Orders
    FOR EACH ROW
BEGIN
    IF NEW.status <> 'Rejected' OR 'Pending' THEN UPDATE Stocks
        SET Stocks.quantity = Stocks.quantity - NEW.quantity
        WHERE Stocks.product_id = NEW.product_id AND Stocks.store_id = NEW.store_id;
    END IF;
END$$
DELIMITER ;

    #Section 3 - Part 1
SELECT (SELECT SUM(IF(MONTH(Orders.date) = 1, Orders.total_price, 0))) AS Jan,
       (SELECT SUM(IF(MONTH(Orders.date) = 2, Orders.total_price, 0))) AS Feb,
       (SELECT SUM(IF(MONTH(Orders.date) = 3, Orders.total_price, 0))) AS Mar,
       (SELECT SUM(IF(MONTH(Orders.date) = 4, Orders.total_price, 0))) AS Apr,
       (SELECT SUM(IF(MONTH(Orders.date) = 5, Orders.total_price, 0))) AS May,
       (SELECT SUM(IF(MONTH(Orders.date) = 6, Orders.total_price, 0))) AS Jun,
       (SELECT SUM(IF(MONTH(Orders.date) = 7, Orders.total_price, 0))) AS Jul,
       (SELECT SUM(IF(MONTH(Orders.date) = 8, Orders.total_price, 0))) AS Aug,
       (SELECT SUM(IF(MONTH(Orders.date) = 9, Orders.total_price, 0))) AS Sep,
       (SELECT SUM(IF(MONTH(Orders.date) = 10, Orders.total_price, 0))) AS Oct,
       (SELECT SUM(IF(MONTH(Orders.date) = 11, Orders.total_price, 0))) AS Nov,
       (SELECT SUM(IF(MONTH(Orders.date) = 12, Orders.total_price, 0))) AS Dcm
FROM Orders
WHERE Orders.status = 'Completed'
GROUP BY YEAR(Orders.date);

    #Section 3 - Part 3
SELECT (CASE WHEN MONTH(Orders.date) = 1 THEN SUM(Orders.total_price) END) AS Jan,
       (CASE WHEN MONTH(Orders.date) = 2 THEN SUM(Orders.total_price) END) AS Feb,
       (CASE WHEN MONTH(Orders.date) = 3 THEN SUM(Orders.total_price) END) AS Mar,
       (CASE WHEN MONTH(Orders.date) = 4 THEN SUM(Orders.total_price) END) AS Apr,
       (CASE WHEN MONTH(Orders.date) = 5 THEN SUM(Orders.total_price) END) AS May,
       (CASE WHEN MONTH(Orders.date) = 6 THEN SUM(Orders.total_price) END) AS Jun,
       (CASE WHEN MONTH(Orders.date) = 7 THEN SUM(Orders.total_price) END) AS Jul,
       (CASE WHEN MONTH(Orders.date) = 8 THEN SUM(Orders.total_price) END) AS Aug,
       (CASE WHEN MONTH(Orders.date) = 9 THEN SUM(Orders.total_price) END) AS Sep,
       (CASE WHEN MONTH(Orders.date) = 10 THEN SUM(Orders.total_price) END) AS Oct,
       (CASE WHEN MONTH(Orders.date) = 11 THEN SUM(Orders.total_price) END) AS Nov,
       (CASE WHEN MONTH(Orders.date) = 12 THEN SUM(Orders.total_price) END) AS Dcm
FROM Orders
WHERE Orders.status = 'Completed'
GROUP BY YEAR(Orders.date);

    #Section 4
SELECT (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 1) AND MONTH(Orders.date) = 1) AS Jan,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 2) AND MONTH(Orders.date) = 2) AS Feb,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 3) AND MONTH(Orders.date) = 3) AS Mar,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 4) AND MONTH(Orders.date) = 4) AS Apr,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 5) AND MONTH(Orders.date) = 5) AS May,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 6) AND MONTH(Orders.date) = 6) AS Jun,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 7) AND MONTH(Orders.date) = 7) AS Jul,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 8) AND MONTH(Orders.date) = 8) AS Aug,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 9) AND MONTH(Orders.date) = 9) AS Sep,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 10) AND MONTH(Orders.date) = 10) AS Oct,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 11) AND MONTH(Orders.date) = 11) AS Nov,
       (SELECT Products.product_name
        FROM Products
        JOIN Orders ON Orders.product_id = Products.product_id
        WHERE Orders.total_price = (SELECT MAX(total_price)
        FROM Orders
            WHERE MONTH(Orders.date) = 12) AND MONTH(Orders.date) = 12) AS Dcm
FROM Products
JOIN Orders ON Orders.product_id = Products.product_id
LIMIT 2;