select author_id, au_lname, au_fname from authors
select ������������� =author_id, ������� = au_lname, ���=au_fname from authors

select ������������� =author_id, '������� ������'=au_lname, ���=au_fname from authors
select '���� ($) = ', price from titles
select id=author_id, name=au_lname, fullname=au_fname from authors where city='Oakland'
select id=authors.author_id, �������=authors.au_lname, ���=authors.au_fname from authors where city='Oakland'
select title_id, price, new_price=price*1.15 from books..titles where advance !< $5000
/* ��������� NULL */
select title_id, ytd_sales, '2*ytd'=2*ytd_sales from titles
select title_id, ytd_sales, price*ytd_sales from titles

select '�������������'=a.author_id, name=a.au_lname, fullname=a.au_fname from authors a

/* ��������� ���-���� ��������� �������� */
select * from titles
select * from sales

/* �������� � ��������� ���-���� ��������� ������ �������� */
select * from titles, sales
select * from titles, sales where titles.title_id=sales.title_id and titles.title_id = 'PS2106'
select titles.title_id, stor_id, qty*price from titles inner join sales on titles.title_id=sales.title_id where titles.title_id = 'PS2106'

/* �������� � ��������� ���������� ���� ��������� �������� */
select titles.title_id, stor_id, qty*price from titles inner join sales on titles.title_id = sales.title_id
select titles.title_id, stor_id, qty*price from titles left outer join sales on titles.title_id=sales.title_id
select titles.title_id, stor_id, qty*price from titles full outer join sales on titles.title_id = sales.title_id

/* ��������� � ������������� ��������� ������� ������� */
select * from authors inner join titleauthor inner join titles on titleauthor.title_id = titles.title_id on authors.author_id = titleauthor.author_id where titles.title_id = 'PS2106'

/* ��������� � ��������� ���������� ��������� �������� */
select author_id from titleauthor
select distinct author_id from titleauthor
select count(*) from titleauthor
select distinct count(*) from titleauthor
select count(distinct author_id) from titleauthor

/* ������� � ��������� �������� � �������������� */
/* ��� ���������� ��������� �������? */
select syscolumns.name, sysobjects.name from syscolumns, sysobjects where sysobjects.id = syscolumns.id and sysobjects.type = 'U'
select sys.columns.name, sys.tables.name from sys.columns inner join sys.tables on sys.columns.object_id = sys.tables.object_id
select * from INFORMATION_SCHEMA.COLUMNS
select * from sysusers

/* ��������� �������� ��� ������ ����� � ������ �� ��������� �������� */
select ytd_sales, 'advance*2'=advance*2, 'price*ytd_sales'=price*ytd_sales from titles where advance*2 > ytd_sales*price
select title_id, ytd_sales, price*ytd_sales from titles where ytd_sales between 4095 and 12000
select id=author_id, name=au_lname, '����/������'=state from authors where state between 'CA' and 'IN'
select id=author_id, name=au_lname, state=state from authors where state not between 'CA' and 'IN'
select id=author_id, name=au_lname, state=state from authors where state in ('CA', 'IN', 'MD')
select au_lname �������, au_fname ���, �������=phone from authors where phone like '415%'
select id=author_id, name=au_lname, phone=phone from authors where phone not like '415%'
select id=author_id, name=au_lname, phone=phone from authors where phone like '4_5%'
select id=author_id, name=au_lname, phone=phone from authors where phone like '[2-7]1[2-9]%'
select id=author_id, name=au_lname, phone=phone from authors where phone like '[^2-7]1[2-9]%'
select title_id, type, advance from titles where advance is NULL
select title_id, type, advance from titles where advance is not NULL
select title_id, type, advance from titles where advance > 0

/* ��������� � ��� ������� ���� �������� */
select title_id, title from titles
select title_id, title INTO NEW_TITLES from titles
select title_id, title INTO #NEW_TITLES from titles
select * from NEW_TITLES
select * from #NEW_TITLES
drop table NEW_TITLES

select count(*) from titles
select count(*) from authors
select * from titles where type='business'
select * from authors inner join titleauthor inner join titles on titleauthor.title_id = titles.title_id on authors.author_id = titleauthor.author_id where titles.type = 'business'