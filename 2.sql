CREATE DATABASE books
use books

CREATE TABLE authors (
	author_id VARCHAR(11) CHECK (author_id like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]') 
	CONSTRAINT PR_au_id PRIMARY KEY CLUSTERED,
	au_lname varchar(40) NOT NULL,
	au_fname varchar(20) NOT NULL,
	phone char(12) NOT NULL DEFAULT ('UNKNOWN'),
	address varchar(40) NULL,
	city varchar(20) NULL,
	state char(2) NULL,
	zip char(5) NULL CHECK (zip like '[0-9][0-9][0-9][0-9][0-9]'),
	contract bit NOT NULL
)

CREATE TABLE titles (
	title_id VARCHAR(20) CONSTRAINT PR_title_id PRIMARY KEY CLUSTERED,
	title varchar(80) NOT NULL,
	type char(12) NOT NULL DEFAULT ('UNDECIDED'),
	pub_id char(4) NULL,
	price money NULL,
	advance money NULL,
	royalty int NULL,
	ytd_sales int NULL,
	notes varchar(200) NULL,
	pubdate varchar(15) NOT NULL
)

CREATE TABLE titleauthor (
	author_id VARCHAR(11) REFERENCES authors(author_id),
	title_id VARCHAR(20) REFERENCES titles(title_id),
	au_ord tinyint NULL,
	royaltyper int NULL,
	CONSTRAINT PK_titleauthor PRIMARY KEY CLUSTERED (author_id, title_id)
)

CREATE TABLE [dbo].[sales] (
	[stor_id] [char] (4) NOT NULL,
	[ord_num] [varchar] (20) NOT NULL,
	[ord_date] [varchar] (15) NOT NULL,
	[qty] [smallint] NOT NULL,
	[payterms] [varchar] (12) NOT NULL,
	[title_id] [varchar] (20) NOT NULL,
	CONSTRAINT PK_sales PRIMARY KEY CLUSTERED ([stor_id], [ord_num], [title_id]), 
	FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
)

DROP TABLE authors
DROP TABLE [dbo].[sales]
DROP TABLE titles
DROP TABLE titleauthor
