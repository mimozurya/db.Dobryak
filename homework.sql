create database Homework
GO
use Homework

create table Groups
(
  idGroup int identity primary key,
  nameGroup nvarchar(50) not null,
  direction nvarchar(50) not null,
  director nvarchar(50) not null,
  creature date not null,
  decay date not null
)
select * from Groups

create table Players 
(
  idPlayer int identity primary key,
  idGroup int,
  FIO nvarchar(50) not null,
  birthday date not null,
  gender nvarchar(30) not null,
  education nvarchar(100) not null,
  roleInGroup nvarchar(100) not null,
  foreign key(idGroup) references Groups(idGroup)
)
select * from Players

create table ChangesGroup
(
  idChanges int identity primary key,
  idGroup int not null,
  idPlayer int not null,
  dateEntrance date not null,
  dateExit date,
  reasonExit nvarchar(50) not null,
  foreign key(idGroup) references Groups(idGroup),
  foreign key(idPlayer) references Players(idPlayer)
)
select * from ChangesGroup

insert Groups (nameGroup, direction, director, creature, decay) 
values 
(N'��������', N'���', N'������ �.�.', '20020101', '20020901'),
(N'��������', N'����', N'������� �.�.', '20030212', '20051012'),
(N'���������', N'���', N'������� �.�.', '20010721', '20050529'),
(N'���������', N'���', N'����� �.�.', '20050106', '20110324'),
(N'��������', N'���', N'������� �.�.', '20070821', '20121012')

insert Players (idGroup, FIO, birthday, gender, education, roleInGroup)
values
(4, N'������ ���� ����������', '19750202', '�������', '����', '��������'),
(3, N'����� ������ ���������', '19820324', '�������', '�����', '�������'),
(2, N'������� ���� ����������', '19890803', '�������', '�������', '������'),
(1, N'������ ���� ��������', '19630513', '�������', '���', '�����'),
(4, N'�������� ����� ������������', '19890404', '�������', '�����', '��������'),
(2, N'������� ������ ���������', '19710520', '�������', '���������������', '�����'),
(3, N'������� ������ ���������', '19800901', '�������', '����', '�����'),
(4, N'�������� ������� �������', '19550616', '�������', '���', '������'),
(4, N'����� ��� �����', '19900112', '�������', '����', '�����'),
(5, N'������� ����� ���������', '19630423', '�������', '���', '�����')

insert ChangesGroup (idGroup, idPlayer, dateEntrance, dateExit, reasonExit)
values
(2, 4, '20040425', '20040909', N'����� �������'),
(4, 10, '20070919', '20100117', N'����� � �������')

drop table ChangesGroup
drop table Players
drop table Groups

-- 1

DECLARE @searchDirection NVARCHAR(50) = '���' -- �������� �� ������ ����������� ������

DECLARE @matchingGroups TABLE (
    idGroup int,
    nameGroup nvarchar(50),
    direction nvarchar(50),
    director nvarchar(50),
    creature date,
    decay date
)

INSERT INTO @matchingGroups
SELECT idGroup, nameGroup, direction, director, creature, decay FROM Groups
WHERE direction LIKE '%' + @searchDirection + '%'

IF EXISTS(SELECT * FROM @matchingGroups)
BEGIN
    DECLARE @matchingPlayers TABLE (
        FIO nvarchar(50)
    )

    INSERT INTO @matchingPlayers
    SELECT p.FIO
    FROM Players p
    INNER JOIN @matchingGroups mg ON p.idGroup = mg.idGroup

    SELECT *
    FROM @matchingPlayers
    ORDER BY FIO

    DECLARE @count INT
    SET @count = (SELECT COUNT(*) FROM @matchingPlayers)
    PRINT '���������� ��������������� �������: ' + CAST(@count AS NVARCHAR)
END
ELSE
BEGIN
    PRINT '�� ������� ��������������� ����������� �����������.'
END

-- 2

SELECT
    Players.FIO AS Performer,
    Groups.nameGroup AS GroupName,
    ChangesGroup.dateEntrance,
    ChangesGroup.dateExit
FROM
    ChangesGroup
JOIN Players ON ChangesGroup.idPlayer = Players.idPlayer
JOIN Groups ON ChangesGroup.idGroup = Groups.idGroup
WHERE
    ChangesGroup.dateExit IS NOT NULL
ORDER BY
    DATEDIFF(day, ChangesGroup.dateEntrance, ChangesGroup.dateExit) ASC;

-- 3

CREATE PROCEDURE UpdatePlayerId
  @oldId int,
  @newId int
AS
BEGIN
  UPDATE Players
  SET idPlayer = @newId
  WHERE idPlayer = @oldId
END

EXEC UpdatePlayerId @oldId = 3, @newId = 4

-- 4

DECLARE @PlayerId INT;
SET @PlayerId = -- id ������� ���� �������
DELETE FROM ChangesGroup WHERE idPlayer = @PlayerId;
DELETE FROM Players WHERE idPlayer = @PlayerId;

-- 5

CREATE PROCEDURE CalculateAverageAgeByRole
  @roleInGroup nvarchar(100)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @totalAge int;
  DECLARE @totalCount int;

  -- Calculate total age and count for the given role
  SELECT @totalAge = SUM(DATEDIFF(YEAR, birthday, GETDATE())),
         @totalCount = COUNT(*)
  FROM Players
  WHERE roleInGroup COLLATE SQL_Latin1_General_CP1_CI_AS = @roleInGroup
    AND idPlayer NOT IN (SELECT idPlayer FROM ChangesGroup WHERE dateExit IS NULL);

  -- Check if role exists
  IF @totalAge IS NULL OR @totalCount IS NULL
  BEGIN
    SELECT NULL AS AverageAge, NULL AS GroupName;
    RETURN;
  END;

  -- Calculate average age
  DECLARE @averageAge float;
  SET @averageAge = CAST(@totalAge AS float) / @totalCount;

  -- Get top 3 groups with highest performer count
  SELECT TOP 3 G.nameGroup AS GroupName, COUNT(*) AS PerformerCount
  FROM Groups G
  INNER JOIN Players P ON G.idGroup = P.idGroup
  WHERE P.idPlayer NOT IN (SELECT idPlayer FROM ChangesGroup WHERE dateExit IS NULL)
  GROUP BY G.nameGroup
  ORDER BY PerformerCount DESC;

  SELECT @averageAge AS AverageAge, NULL AS GroupName;
END;