
create procedure #A
	@N smallint = 0, 
	@K int OUTPUT
as
begin
	select * from authors as A where (select count(*) from titleauthor as ta where a.author_id = ta.au_ord) = @N;
	set @K = @@ROWCOUNT;
	return 0;
END
GO

declare @KA int, @RETURN_STATUS int;
exec @RETURN_STATUS = #A 2, @KA output;
select 'RETURN_STATUS' = @RETURN_STATUS, @KA;