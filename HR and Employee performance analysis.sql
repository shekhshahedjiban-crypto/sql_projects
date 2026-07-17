-- HR AND EMPLOYEE PERFORMANCE ANALYSIS SYSTEM
-- Creating a new database named 'hr_performance_db' if it does not already exist
CREATE DATABASE IF NOT EXISTS hr_performance_db;
-- Telling the system to use the database that just created
USE hr_performance_db;
-- Delete the 'Employees' table if it exists to prevent errors
DROP TABLE IF EXISTS Employees;
-- Delete the 'Departments' table if it exists to prevent errors
DROP TABLE IF EXISTS Departments;
-- Creating the 'Departments' table to store company department names
CREATE TABLE Departments (
    -- 'dept_id' is the primary key and increments automatically for each new department
    dept_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- 'dept_name' stores the department title (like IT or HR) and cannot be empty
    dept_name VARCHAR(255) NOT NULL
);
-- Creating the 'Employees' table to store employee details
CREATE TABLE Employees (
    -- 'emp_id' is the unique identifier for each employee
    emp_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- 'emp_name' stores the full name of the employee
    emp_name VARCHAR(255) NOT NULL,
    -- 'dept_id' links the employee to a specific department
    dept_id INTEGER,
    -- 'salary' stores the monthly pay (up to 10 digits, with 2 decimal places)
    salary DECIMAL(10, 2),
    -- 'hire_date' records when the employee joined the company
    hire_date DATE,
    -- Create a link (Foreign Key) to the Departments table
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);
-- Adding sample data into the 'Departments' table
INSERT INTO Departments (dept_name) VALUES 
('IT'),
('HR'),
('Sales');
-- Adding sample data into the 'Employees' table
INSERT INTO Employees (emp_name, dept_id, salary, hire_date) VALUES 
('Abir Hasan', 1, 6000.00, '2024-01-15'),
('Nusrat Jahan', 1, 4500.00, '2024-06-20'),
('Fahim Ahmed', 1, 7500.00, '2025-02-10'),
('Rina Begum', 2, 4000.00, '2023-11-01'),
('Sajid Khan', 2, 5000.00, '2024-08-05'),
('Mehedi Hasan', 3, 3500.00, '2025-01-20');
-- Query 1: Use a CTE to calculate the average salary and show those earning more than that average
WITH AvgSalaryCTE AS (
    -- Calculating the average of all salaries
    SELECT AVG(salary) AS overall_avg FROM Employees
)
-- Selecting employees whose salary is higher than the average calculated above
SELECT 
    e.emp_name, 
    e.salary, 
    ROUND(a.overall_avg, 2) AS CompanyAverage
FROM Employees e
CROSS JOIN AvgSalaryCTE a
WHERE e.salary > a.overall_avg;
-- Query 2: Assigning a rank to employees within their department based on salary
SELECT 
    e.emp_name,
    d.dept_name,
    e.salary,
    -- ROW_NUMBER() creates a unique sequence number for each row
    ROW_NUMBER() OVER(PARTITION BY e.dept_id ORDER BY e.salary DESC) AS SalaryRankInDept
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id;
-- Query 3: Ranking all employees globally based on salary
SELECT 
    emp_name,
    salary,
    -- RANK() gives the same rank for ties, but skips the next rank numbers
    RANK() OVER(ORDER BY salary DESC) AS StandardRank,
    -- DENSE_RANK() gives the same rank for ties without skipping numbers
    DENSE_RANK() OVER(ORDER BY salary DESC) AS DenseRank
FROM Employees;
-- Query 4: Comparing each employee's salary with the person hired before and after them
 SELECT 
    emp_name,
    dept_id,
    salary,
    -- LAG() fetches the salary of the previous employee based on hire date
    LAG(salary, 1) OVER(PARTITION BY dept_id ORDER BY hire_date) AS PreviousHiredSalary,
    -- LEAD() fetches the salary of the next employee based on hire date
    LEAD(salary, 1) OVER(PARTITION BY dept_id ORDER BY hire_date) AS NextHiredSalary
FROM Employees;