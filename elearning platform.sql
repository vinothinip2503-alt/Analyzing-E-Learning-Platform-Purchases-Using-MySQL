CREATE DATABASE if not exists elearning_db;
USE elearning_db;

CREATE TABLE learners
(
learner_id INT PRIMARY KEY,
full_name VARCHAR(100),
country VARCHAR(50)
);

CREATE TABLE courses(
course_id INT PRIMARY KEY,
course_name VARCHAR(100),
category VARCHAR(50),
unit_price DECIMAL(10,2)
);

CREATE TABLE purchases(
purchase_id INT PRIMARY KEY,
learner_id INT,
course_id INT,
quantity INT,
purchase_date DATE,
FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO learners VALUES
(1, 'Vinothini', 'India'),
(2, 'Parthiban', 'USA'),
(3, 'Vignesh', 'Australia'),
(4, 'Anitha', 'UK'),
(5, 'Lincy', 'Canada'),
(6, 'Veronica', 'USA');

SELECT * FROM learners;

INSERT INTO courses VALUES
(101, 'Business Intelligence', 'Finance', 1500.00),
(102, 'SQL', 'Data Analytics', 1800.00),
(103, 'Marketing', 'Finance', 1000.00),
(104, 'Python', 'Data Analytics', 2000.00),
(105, 'Excel', 'Data Analytics', 1200.00),
(106, 'Java', 'Mobile Application', 1500);

SELECT * FROM courses;

INSERT INTO purchases VALUES
(1,1,101,1,'2024-01-10'),
(2,1,102,2,'2024-01-15'),
(3,2,103,1,'2024-02-01'),
(4,3,106,1,'2024-02-10'),
(5,3,104,2,'2024-02-12'),
(6,4,102,1,'2024-03-05'),
(7,4,103,1,'2024-03-08'),
(8,5,105,2,'2024-03-15');

SELECT * FROM purchases;

-- Data Exploration – INNER JOIN

SELECT l.full_name AS learner_name,
c.course_name,
c.category,
p.quantity,
FORMAT(p.quantity * c.unit_price, 2) AS Total_Amount,
p.purchase_date
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
ORDER BY Total_Amount DESC;

-- LEFT JOIN

SELECT l.full_name,
c.course_name,
p.quantity
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON c.course_id = p.course_id;

-- RIGHT JOIN
SELECT c.course_name, l.full_name, p.quantity
FROM purchases p
RIGHT JOIN courses c ON p.course_id = c.course_id
LEFT JOIN leaners l ON p.learner_id = l.learner_id;

-- Total spending per learner

SELECT l.full_name, l.country,
FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name, l.country
ORDER BY total_spent DESC;

-- Top 3 most purchased courses

SELECT c.course_name,
SUM(p.quantity) AS Total_Quantity
FROM purchases p
JOIN  courses c ON p.course_id = c.course_id
GROUP BY c.course_name
ORDER BY Total_Quantity DESC
LIMIT 3;

-- Category-wise revenue & unique learners

SELECT c.category,
FORMAT(SUM(p.quantity * Unit_price), 2) AS Total_Revenue,
COUNT(DISTINCT p.learner_id) AS Unique_Learners
FROM purchases p
JOIN courses c ON p.course_id = c.course_id
GROUP BY c.category;

-- Learners buying from multiple categories

SELECT l.full_name,
COUNT(DISTINCT c.category) AS Category_Count
From learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

-- Courses not purchased

SELECT c.course_name
From courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
WHERE p.course_id IS NULL;

-- Which country generates the highest revenue

SELECT l.country,
FORMAT(SUM(p.quantity * c.unit_price),2) AS total_revenue
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.country
ORDER BY total_revenue DESC;

-- Learners who spent more than average

SELECT l.full_name,
FORMAT(SUM(p.quantity * c.unit_price),2) AS total_spent
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name
HAVING SUM(p.quantity * c.unit_price) >
(SELECT AVG(quantity * unit_price) FROM purchases p2
JOIN courses c2 ON p2.course_id = c2.course_id);

-- Number of purchases per learner

SELECT l.full_name,
COUNT(p.purchase_id) AS total_purchases
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
GROUP BY l.full_name
ORDER BY total_purchases DESC;


