# Online Book Store SQL Project

A PostgreSQL project for exploring an online bookstore's books, customers, orders, sales revenue, and inventory using basic and advanced SQL queries.

## Project Structure

```
Online-Book-Store/
├── Dataset/
│   ├── Books.csv
│   ├── Customers.csv
│   └── Orders.csv
├── Online_Book_Store_Project.sql
└── README.md
```

## Datasets

The project uses three CSV datasets:

- **Books.csv** — book ID, title, author, genre, publication year, price, and stock.
- **Customers.csv** — customer ID, name, email, phone, city, and country.
- **Orders.csv** — order ID, customer ID, book ID, order date, quantity, and total amount.

## Tools and Technologies

- PostgreSQL
- SQL
- CSV datasets

## SQL Concepts Covered

- Database and table creation
- Primary keys and foreign keys
- Filtering and sorting with `WHERE` and `ORDER BY`
- Aggregate functions: `SUM`, `AVG`, and `COUNT`
- Joins: `JOIN` and `LEFT JOIN`
- Grouping with `GROUP BY` and `HAVING`
- Inventory and sales analysis

## How to Run

1. Install PostgreSQL.
2. Clone or download this repository.
3. Create the three tables and import the CSV files.
4. Open `Online_Book_Store_Project.sql` in PostgreSQL's `psql` tool.
5. Update the CSV file paths in the import commands to match your computer before running them.

**Note:** The SQL script uses the `psql` meta-command `\\c OnlineBookstore`. If you use pgAdmin, connect to the database separately and omit that line. PostgreSQL server-side `COPY` paths must be accessible to the database server; client-side `\\copy` can be used from `psql` for local files.

## Analysis Questions

The queries explore Fiction books, publication years, customers by country, monthly orders, total stock, most and least expensive books, revenue, books sold by genre, average Fantasy book price, repeat customers, frequently ordered books, sales by author, high-value orders, top-spending customers, and estimated remaining stock.

## Important Notes

- Review the `DROP TABLE IF EXISTS` statements before running the script; they remove existing tables.
- The remaining-stock calculation is an estimate based on the stock values and recorded order quantities.
- Update local CSV paths before importing data.

## Author

**MD Jahid**  
GitHub: https://github.com/MdJahid10080
