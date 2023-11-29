select pub_id, type from titles order by pub_id
select pub_id, type from titles order by pub_id, type desc
select pub_id, type from titles order by 1, 2 desc
select title, type from titles order by 2, 1
select title, type from titles order by 2, 1 desc

select au_fname from authors order by au_fname
select au_fname from authors where state like 'РФ' order by au_fname desc
select au_lname from authors where state like 'РФ' order by au_lname


select count(*), total = sum(ytd_sales) from titles
select count(*), pub_id, total = sum(ytd_sales) from titles group by pub_id
select count(*), pub_id, total = sum(ytd_sales) from titles group by pub_id having count(*) > 5

/* select type, price, advance from titles order by type compute sum(price) by type
select type, price, advance from titles order by type compute sum(price), sum(advance) by type
select type, pub_id, price from titles where type = 'psychology' order by type, pub_id, price compute sum(price) by type, pub_id compute sum(price) by type */


declare @a int, @b int, @c char(21)
select @b = 4
select @a = 2*@b
select @c = 'result = ' + CONVERT (char(2), @a)
print @c
go

declare @veryhigh money
select @veryhigh = max(price) from titles
if @veryhigh > $20 print 'Wow!'
select @veryhigh = sum(ytd_sales*price) from titles
select @veryhigh as 'Всего продано на сумму'

declare @c varchar(21), @d char(7)
select @c = 'Проживает в ', @d = 'Oakland'
select author_id, Фамилия = au_lname, Имя = au_fname, @c + @d as Штат from authors where city = @d
go

declare @pr decimal(7,2), @pr1 int, @pr2 int
select @pr = 1.20, @pr1 = 1.20, @pr2 = 0.80
select (ytd_sales), окр = Round(@pr*(ytd_sales), 1), @pr * (ytd_sales), @pr1 * (ytd_sales), @pr2 * (ytd_sales) from titles
go


select name = au_lname, au_fname from authors where author_id in (select author_id from titleauthor where royaltyper < 50)
select name = au_lname, au_fname from authors where author_id NOT in (select author_id from titleauthor where royaltyper < 50)

select count(*) from titles
select count(*) from titles where advance is NOT NULL
select count(*) from titles where advance > 0 or advance < 0

select title, price from titles where price = (select price from titles where CHARINDEX('Talk', title) > 0)

select au_lname, au_fname from authors, titleauthor where state = 'CA' and authors.author_id = titleauthor.author_id and royaltyper < 30 and au_ord = 2
select au_lname, au_fname from authors where state = 'CA' and author_id in (select author_id from titleauthor where royaltyper < 30 and au_ord = 2)

select au_lname, au_fname from authors where author_id in (select author_id from titleauthor where title_id in (select title_id from titles where type = 'popular_comp')) order by au_lname, au_fname
select distinct au_lname, au_fname from authors, titleauthor, titles where authors.author_id
= titleauthor.author_id and titles.title_id = titleauthor.title_id and type = 'popular_comp' order by au_lname, au_fname

select*from authors
select*from titleauthor
select*from titles

select distinct title, type from titles, titleauthor, authors where titles.title_id = titleauthor.title_id and 
titleauthor.author_id = authors.author_id and au_lname = 'Yokomoto' order by title, type
select count(*), total = sum(ytd_sales) from titles
select distinct title, type from titles, titleauthor where titles.title_id = titleauthor.title_id and titleauthor.royaltyper < 100
select count(*), total = sum(ytd_sales) from titles where pubdate > '01/01/91' and pubdate < '12/31/91'
