-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\\c OnlineBookstore;

-- Create Tables

-- Books Table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

-- Customers Table
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

--Orders Table
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\\Users\\Md Jahid\\OneDrive\\Desktop\\sql\\ST - SQL ALL PRACTICE FILES SD61\\ST - SQL ALL PRACTICE FILES-2\\All Excel Practice Files\\Books.csv'
delimiter','
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\\Users\\Md Jahid\\OneDrive\\Desktop\\sql\\ST - SQL ALL PRACTICE FILES SD61\\ST - SQL ALL PRACTICE FILES-2\\All Excel Practice Files\\Customers.csv'
delimiter','
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\\Users\\Md Jahid\\OneDrive\\Desktop\\sql\\ST - SQL ALL PRACTICE FILES SD61\\ST - SQL ALL PRACTICE FILES-2\\All Excel Practice Files\\Orders.csv'
delimiter','
CSV HEADER;

-- Basic Queries

-- 1) Retrieve all books in the Fiction genre:
SELECT * FROM Books WHERE Genre='Fiction';

-- 2) Find books published after 1950:
SELECT * FROM Books WHERE Published_year>1950;

-- 3) List customers from Canada:
SELECT * FROM Customers WHERE country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve total stock:
SELECT SUM(stock) AS Total_Stock FROM Books;

-- 6) Find the most expensive book:
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- 7) Show orders with quantity greater than 1:
SELECT * FROM Orders WHERE quantity>1;

-- 8) Retrieve orders where total amount exceeds $20:
SELECT * FROM Orders WHERE total_amount>20;

-- 9) List all genres:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books ORDER BY stock LIMIT 1;

-- 11) Calculate total revenue:
SELECT SUM(total_amount) AS Revenue FROM Orders;

-- Advanced Queries

-- 1) Total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;

-- 2) Average price of Fantasy books:
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) Customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;

-- 4) Most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Top 3 most expensive Fantasy books:
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6) Total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;

-- 7) Cities associated with orders over $30:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

-- 8) Customer who spent the most:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent DESC LIMIT 1;

-- 9) Estimated stock remaining after fulfilling orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
       b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
