-- Online Book Store SQL Project
-- Database: PostgreSQL
-- Run this script using psql from the repository folder.
-- Keep Books.csv, Customers.csv, and Orders.csv in the current working directory.
--
-- WARNING: This script drops and recreates the three project tables.
-- Back up any data you need before running it again.

\set ON_ERROR_STOP on

-- Create the database only if it does not already exist.
SELECT 'CREATE DATABASE onlinebookstore'
WHERE NOT EXISTS (
    SELECT 1 FROM pg_database WHERE datname = 'onlinebookstore'
)
\gexec

-- Connect to the project database.
\connect onlinebookstore

-- Drop child tables before parent tables because of foreign-key relationships.
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

-- Create Books table.
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

-- Create Customers table.
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

-- Create Orders table.
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

-- Import CSV files from the repository folder.
-- These are psql client-side commands, not standard SQL.
\copy Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) FROM 'Books.csv' WITH (FORMAT csv, HEADER true)
\copy Customers(Customer_ID, Name, Email, Phone, City, Country) FROM 'Customers.csv' WITH (FORMAT csv, HEADER true)
\copy Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) FROM 'Orders.csv' WITH (FORMAT csv, HEADER true)

-- Reset SERIAL sequences because IDs were imported explicitly from CSV files.
SELECT setval(
    pg_get_serial_sequence('books', 'book_id'),
    COALESCE((SELECT MAX(Book_ID) FROM Books), 1),
    EXISTS (SELECT 1 FROM Books)
);
SELECT setval(
    pg_get_serial_sequence('customers', 'customer_id'),
    COALESCE((SELECT MAX(Customer_ID) FROM Customers), 1),
    EXISTS (SELECT 1 FROM Customers)
);
SELECT setval(
    pg_get_serial_sequence('orders', 'order_id'),
    COALESCE((SELECT MAX(Order_ID) FROM Orders), 1),
    EXISTS (SELECT 1 FROM Orders)
);

-- Verify imported data.
SELECT COUNT(*) AS Books_Rows FROM Books;
SELECT COUNT(*) AS Customers_Rows FROM Customers;
SELECT COUNT(*) AS Orders_Rows FROM Orders;

-- Basic Queries

-- 1. Retrieve all books in the Fiction genre.
SELECT *
FROM Books
WHERE Genre = 'Fiction';

-- 2. Find books published after 1950.
SELECT *
FROM Books
WHERE Published_Year > 1950;

-- 3. List customers from Canada.
SELECT *
FROM Customers
WHERE Country = 'Canada';

-- 4. Show orders placed in November 2023.
SELECT *
FROM Orders
WHERE Order_Date >= DATE '2023-11-01'
  AND Order_Date < DATE '2023-12-01';

-- 5. Calculate total stock across all books.
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6. Find the most expensive book.
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7. Show orders with a quantity greater than 1.
SELECT *
FROM Orders
WHERE Quantity > 1;

-- 8. Retrieve orders where the total amount exceeds 20.
SELECT *
FROM Orders
WHERE Total_Amount > 20;

-- 9. List all available genres.
SELECT DISTINCT Genre
FROM Books
ORDER BY Genre;

-- 10. Find the book with the lowest stock.
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11. Calculate total sales revenue from recorded orders.
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;

-- Advanced Queries

-- 1. Calculate the total quantity of books sold in each genre.
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY Total_Books_Sold DESC;

-- 2. Calculate the average price of Fantasy books.
SELECT AVG(Price) AS Average_Fantasy_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3. Find customers who have placed at least two orders.
SELECT c.Customer_ID, c.Name, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2
ORDER BY Order_Count DESC;

-- 4. Find the most frequently ordered book by total quantity.
SELECT b.Book_ID, b.Title, SUM(o.Quantity) AS Total_Quantity_Ordered
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY Total_Quantity_Ordered DESC
LIMIT 1;

-- 5. Find the three most expensive Fantasy books.
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6. Calculate the total quantity of books sold by each author.
SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author
ORDER BY Total_Books_Sold DESC;

-- 7. List cities with individual orders above 30.
SELECT DISTINCT c.City
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30
ORDER BY c.City;

-- 8. Find the customer who spent the most across all recorded orders.
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9. Estimate remaining stock after subtracting recorded order quantities.
-- This is an estimate; it assumes Books.Stock represents starting stock.
SELECT
    b.Book_ID,
    b.Title,
    b.Stock AS Recorded_Stock,
    COALESCE(SUM(o.Quantity), 0) AS Ordered_Quantity,
    b.Stock - COALESCE(SUM(o.Quantity), 0) AS Estimated_Remaining_Stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;
