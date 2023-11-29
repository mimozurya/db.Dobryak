select * into Test.dbo.titles from books.dbo.titles
select * into Test.dbo.sales from books.dbo.sales
select * into Test.dbo.authors from books.dbo.authors

ALTER TABLE sales
ADD CONSTRAINT fk_sales_titles
FOREIGN KEY (title_id)
REFERENCES titles(title_id);

select * from titles
select * from sales
select * from authors

delete from titles where title_id = 'PC8888'
delete from sales where title_id = 'PC8888'

SELECT Titles.title, Sales.qty /* название книги, кол-во продаж */
FROM Sales
INNER JOIN Titles ON Sales.title_id = Titles.title_id

UPDATE Sales
SET ord_date = '05/30/07'
WHERE title_id = 'TC4203'

UPDATE Sales
SET ord_date = '06/01/07'
WHERE title_id = 'TC4203'

DELETE FROM Sales
WHERE ord_date = '06/01/07'

UPDATE authors
SET city = (SELECT city FROM authors WHERE au_lname = 'Сергей' AND au_fname = 'Каратыгин')
WHERE au_lname = 'Bennet' AND au_fname = 'Abraham';