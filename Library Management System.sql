-- Telling SQL code for library management system
-- preparing database
-- Creating a new database named 'jiban' if it does not already exist.
CREATE DATABASE IF NOT EXISTS jiban;
USE jiban; 
-- Drop tables first to ensure we start fresh and prevent duplicate data.
DROP TABLE IF EXISTS BorrowRecords;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Books;
-- creating tables
-- Create the 'Books' table to store book information
CREATE TABLE Books ( 
    -- 'book_id' is a unique number for each book. It increases automatically (+1) with every new book.
    book_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- 'title' is the name of the book. It cannot be empty (NOT NULL).
    title VARCHAR(255) NOT NULL,
    -- 'author' is the person who wrote the book.
    author VARCHAR(255),
    -- 'genre' is the category of the book (e.g., Sci-Fi, Drama).
    genre VARCHAR(100),
    -- 'is_available' shows if the book is in the library. 1 means Yes, 0 means No. Default is 1 (Yes).
    is_available TINYINT DEFAULT 1
);

-- Creating the 'Members' table to store user information
CREATE TABLE Members ( 
    -- 'member_id' is a unique number for each library member. It increases automatically.
    member_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- 'name' is the member's name. It cannot be empty.
    name VARCHAR(255) NOT NULL,
    -- 'email' is the member's email. 'UNIQUE' means two members cannot use the same email.
    email VARCHAR(255) UNIQUE,
    -- 'join_date' is the date when the member registered in the library.
    join_date DATE
);

-- Creating the 'BorrowRecords' table to track which member borrowed which book
CREATE TABLE BorrowRecords ( 
    -- 'record_id' is a unique number for each borrow transaction.
    record_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- 'book_id' stores which book was borrowed. It connects to the 'Books' table.
    book_id INTEGER,
    -- 'member_id' stores which member borrowed it. It connects to the 'Members' table.
    member_id INTEGER,
    -- 'borrow_date' is the date the book was taken.
    borrow_date DATE,
    -- 'return_date' is the date the book was returned. It can be empty (NULL) if the book is not returned yet.
    return_date DATE,
    -- This line connects 'book_id' of this table to the 'book_id' of the 'Books' table.
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    -- This line connects 'member_id' of this table to the 'member_id' of the 'Members' table.
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
-- inserting sample data
-- Inserting 3 books into the 'Books' table
-- not inserting 'book_id' because it increases automatically.
INSERT INTO Books (title, author, genre, is_available) VALUES 
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1),
('1984', 'George Orwell', 'Dystopian', 1),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 1);

-- Inserting 3 members into the 'Members' table
INSERT INTO Members (name, email, join_date) VALUES 
('Rahim Ali', 'rahim@email.com', '2026-01-10'),
('Karim Chowdhury', 'karim@email.com', '2026-02-15'),
('Sadia Islam', 'sadia@email.com', '2026-03-01');

-- Inserting 2 borrow records (Rahim borrowed book 1, Karim borrowed book 2)
INSERT INTO BorrowRecords (book_id, member_id, borrow_date, return_date) VALUES 
(1, 1, '2026-06-01', '2026-06-10'), -- Rahim borrowed 'The Hobbit' and returned it.
(2, 2, '2026-06-12', NULL);          -- Karim borrowed '1984' and has NOT returned it yet.
-- Query 1: See all books in the library
SELECT * FROM Books;
-- Query 2: Find all books written by 'George Orwell'
SELECT * FROM Books WHERE author = 'George Orwell';
-- Query 3: Find which books are currently borrowed and not returned yet (return_date is empty)
SELECT * FROM BorrowRecords WHERE return_date IS NULL;
-- Query 4: Connect tables to see Member Name and Book Title together (using JOIN)
SELECT 
    Members.name AS MemberName, 
    Books.title AS BookTitle, 
    BorrowRecords.borrow_date 
FROM BorrowRecords
-- Joining 'Members' table to get the member's name
INNER JOIN Members ON BorrowRecords.member_id = Members.member_id
-- Joining 'Books' table to get the book's title
INNER JOIN Books ON BorrowRecords.book_id = Books.book_id;