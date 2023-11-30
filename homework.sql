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
(N'Шильдики', N'Поп', N'Иванов И.И.', '20020101', '20020901'),
(N'Игнатики', N'Джаз', N'Сергеев С.С.', '20030212', '20051012'),
(N'Некроманы', N'Поп', N'Матвеев М.М.', '20010721', '20050529'),
(N'Романтики', N'Рок', N'Попич П.П.', '20050106', '20110324'),
(N'Паразиты', N'Рок', N'Романов Р.Р.', '20070821', '20121012')

insert Players (idGroup, FIO, birthday, gender, education, roleInGroup)
values
(4, N'Трубин Олег Евгеньевич', '19750202', 'Мужчина', 'УРФУ', 'Гитарист'),
(3, N'Попов Рамзан Ахматович', '19820324', 'Мужчина', 'УРГЭУ', 'Пианист'),
(2, N'Рамзова Вера Васильевна', '19890803', 'Женщина', 'Политех', 'Басист'),
(1, N'Иванов Иван Иванович', '19630513', 'Мужчина', 'МГУ', 'Лидер'),
(4, N'Мосякина Софья Вячеславовна', '19890404', 'Женщина', 'МГИМО', 'Гитарист'),
(2, N'Сергеев Сергей Сергеевич', '19710520', 'Мужчина', 'Лесотехнический', 'Лидер'),
(3, N'Матвеев Матвей Матвеевич', '19800901', 'Мужчина', 'УРФУ', 'Лидер'),
(4, N'Алексеев Алексей Никитич', '19550616', 'Мужчина', 'ВШЭ', 'Басист'),
(4, N'Попич Поп Попов', '19900112', 'Мужчина', 'УРФУ', 'Лидер'),
(5, N'Романов Роман Романович', '19630423', 'Мужчина', 'ВШЭ', 'Лидер')

insert ChangesGroup (idGroup, idPlayer, dateEntrance, dateExit, reasonExit)
values
(2, 4, '20040425', '20040909', N'Плохо кормили'),
(4, 10, '20070919', '20100117', N'Ссора с лидером')

drop table ChangesGroup
drop table Players
drop table Groups

-- 1 в алфавитном порядке исполнителей

DECLARE @searchDirection NVARCHAR(50) = 'Рок' -- замените на нужное направление поиска

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
    PRINT 'Количество соответствующих игроков: ' + CAST(@count AS NVARCHAR)
END
ELSE
BEGIN
    PRINT 'Не найдено соответствующих музыкальных направлений.'
END

-- 2 фио исполнителя, с наибольшими и наименьшим участием

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

-- 3 изменение первичного ключа

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

-- 4 удаление пользователя, получившего новый номер

DECLARE @PlayerId INT;
SET @PlayerId = 7-- id которое надо удалить
DELETE FROM ChangesGroup WHERE idPlayer = @PlayerId;
DELETE FROM Players WHERE idPlayer = @PlayerId;

-- 5 средний возраст исполнителя

CREATE PROCEDURE CalculateAverageAgeByRole
  @roleInGroup nvarchar(100)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @totalAge int;
  DECLARE @totalCount int;

  -- считает общий возраст и суммирует
  SELECT @totalAge = SUM(DATEDIFF(YEAR, birthday, GETDATE())),
         @totalCount = COUNT(*)
  FROM Players
  WHERE roleInGroup COLLATE SQL_Latin1_General_CP1_CI_AS = @roleInGroup
    AND idPlayer NOT IN (SELECT idPlayer FROM ChangesGroup WHERE dateExit IS NULL);

  -- проверяет если человек вышел
  IF @totalAge IS NULL OR @totalCount IS NULL
  BEGIN
    SELECT NULL AS AverageAge, NULL AS GroupName;
    RETURN;
  END;

  -- считает средний возраст
  DECLARE @averageAge float;
  SET @averageAge = CAST(@totalAge AS float) / @totalCount;

  -- получает топ3 группы с наибольшим кол-вом исполнителей
  SELECT TOP 3 G.nameGroup AS GroupName, COUNT(*) AS PerformerCount
  FROM Groups G
  INNER JOIN Players P ON G.idGroup = P.idGroup
  WHERE P.idPlayer NOT IN (SELECT idPlayer FROM ChangesGroup WHERE dateExit IS NULL)
  GROUP BY G.nameGroup
  ORDER BY PerformerCount DESC;

  SELECT @averageAge AS AverageAge, NULL AS GroupName;
END;

-- 8 лабораторная

-- создание копии исходной таблицы
SELECT *
INTO GroupsCopy
FROM Groups

SELECT *
INTO PlayersCopy
FROM Players

SELECT *
INTO ChangesGroupCopy
FROM ChangesGroup

-- создание справочной таблицы музыкальных направлений
CREATE TABLE MusicDirections
(
  idDirection int identity primary key,
  nameDirection nvarchar(50) not null
)

-- заполнение справочной таблицы значениями из столбца direction Groups
INSERT INTO MusicDirections (nameDirection)
SELECT DISTINCT direction
FROM Groups
select * from MusicDirections
-- модификация структуры и данных исходной таблицы Groups
ALTER TABLE Groups
DROP COLUMN direction

ALTER TABLE Groups
ADD directionID int

UPDATE G
SET directionID = MD.idDirection
FROM Groups G
JOIN MusicDirections MD ON G.direction = MD.nameDirection

-- Демонстрация
SELECT G.idGroup, G.nameGroup, MD.nameDirection AS direction, G.director, G.creature, G.decay
FROM Groups G
JOIN MusicDirections MD ON G.directionID = MD.idDirection
select * from Groups


drop table ChangesGroupCopy
drop table GroupsCopy
drop table PlayersCopy
drop table MusicDirections
drop table Groups
drop table ChangesGroup
drop table Players