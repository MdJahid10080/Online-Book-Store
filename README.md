# Online Book Store SQL Project

A PostgreSQL project that analyzes an online bookstore's books, customers, orders, sales, and inventory using basic and advanced SQL queries.

## Repository Structure

```text
Online-Book-Store/
├── Books.csv
├── Customers.csv
├── Orders.csv
├── Online_Book_Store_Project.sql
└── README.md
```

## Dataset Overview

The project uses three CSV files:

| File | Description |
|---|---|
| `Books.csv` | Book ID, title, author, genre, publication year, price, and stock |
| `Customers.csv` | Customer ID, name, email, phone, city, and country |
| `Orders.csv` | Order ID, customer ID, book ID, order date, quantity, and total amount |

## Tools and Technologies

- PostgreSQL
- SQL
- CSV datasets

## Database Schema

The database contains three related tables:

- **Books** — stores book details and inventory.
- **Customers** — stores customer information.
- **Orders** — stores purchases and links customers to books through foreign keys.

## SQL Concepts Demonstrated

- Database and table creation
- Primary keys, foreign keys, and serial ID sequences
- Data import from CSV files
- Filtering, sorting, and distinct values
- Aggregate functions: `SUM`, `AVG`, and `COUNT`
- Joins: `JOIN` and `LEFT JOIN`
- Grouping and filtering groups with `GROUP BY` and `HAVING`
- Sales, customer, genre, and inventory analysis

## How to Run the Project

**Requirement:** PostgreSQL with the `psql` command-line tool.

1. Download or clone this repository.
2. Open a terminal in the repository folder so the three CSV files are in the current working directory.
3. Run the script:

   ```bash
   psql -U postgres -f Online_Book_Store_Project.sql
   ```

4. Enter your PostgreSQL password when prompted.
5. The script creates the database, creates the tables, imports the CSV files, and runs the analysis queries.

The import commands use PostgreSQL's client-side `\\copy` command, so the CSV files are read from your computer. Run the script from the repository folder. If you use pgAdmin, create/connect to the `onlinebookstore` database separately and use pgAdmin's Import/Export feature for each CSV; the `psql` commands beginning with a backslash are not ordinary SQL.

## Analysis Questions

The queries cover:

- Fiction books and books published after 1950
- Customers from Canada and orders placed in November 2023
- Total inventory, highest-priced book, and lowest-stock book
- Total sales revenue and orders with quantities or amounts above specified values
- Books sold by genre and author
- Average price of Fantasy books and the three most expensive Fantasy books
- Customers with at least two orders
- Most frequently ordered book by quantity
- Cities with individual orders above 30
- Highest-spending customer
- Estimated remaining stock after recorded orders

## Important Notes

- **Data reset:** The SQL script drops and recreates the `Orders`, `Customers`, and `Books` tables. Back up any data you need before running it again.
- **CSV files:** Keep all three CSV files in the repository folder when running the script with `psql`.
- **Inventory estimate:** The remaining-stock query subtracts recorded order quantities from the stock values in the Books table. Treat it as an estimate unless the stock values represent the starting inventory.
- **Currency:** The script uses the amounts as provided in the dataset and does not assume a currency.

## Author

**MD Jahid**

- GitHub: https://github.com/MdJahid10080
- Project repository: https://github.com/MdJahid10080/Online-Book-Store
