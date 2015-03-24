DECLARE @CompletedForms TABLE (
    CompletedFormId INT IDENTITY,
    PersonId VARCHAR(50),
    FormId INT,
    CompletionDate DATE
)
DECLARE @Persons TABLE (
    PersonId INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
)
DECLARE @Forms TABLE (
    FormId INT PRIMARY KEY,
    FormName VARCHAR(50)
)
INSERT INTO @Forms (FormId, FormName)
VALUES (1,'Billing Information'),(2,'Shipping Information'),(3,'Business Information')

INSERT INTO @Persons (PersonId, FirstName, LastName)
VALUES (1,'Moe','Howard'),(2,'Larry','Fine'),(3,'Shemp','Howard')

INSERT INTO @CompletedForms (PersonId, FormId, CompletionDate)
VALUES  (1,1,'1/5/2015'),
        (1,1,'2/2/2015'),
        (1,1,'2/2/2015'), -- Duplicate date for demonstration of the difference between RANK & DENSE_RANK
        (1,2,'3/21/2015'),
        (1,2,'3/22/2015'),
        (1,3,'3/14/2015'),
        (2,1,'1/1/2015'),
        (2,1,'2/1/2015'),
        (2,3,'1/1/2015'),
        (2,3,'2/1/2015'),
        (3,1,'1/1/2015'),
        (3,2,'2/1/2015'),
        (3,3,'3/1/2015')

/*Row Number Function - RAW*/
SELECT
    ROW_NUMBER() OVER (PARTITION BY CF.PersonId, CF.FormId ORDER BY CompletionDate DESC) AS [Row #],
    P.FirstName + ' ' + P.LastName AS [Full Name],
    F.FormName AS [Form Name],
    CF.CompletionDate AS [Completion Date]
FROM @CompletedForms CF
    JOIN @Forms F ON F.FormId = CF.FormId
    JOIN @Persons P ON P.PersonId = CF.PersonId

/*Row Number Function - Row # Search Condition*/
;WITH CTE_RowNumberRaw AS (
SELECT
    ROW_NUMBER() OVER (PARTITION BY CF.PersonId, CF.FormId ORDER BY CompletionDate DESC) AS [Row #],
    P.FirstName + ' ' + P.LastName AS [Full Name],
    F.FormName AS [Form Name],
    CF.CompletionDate AS [Completion Date]
FROM @CompletedForms CF
    JOIN @Forms F ON F.FormId = CF.FormId
    JOIN @Persons P ON P.PersonId = CF.PersonId)
SELECT *
FROM CTE_RowNumberRaw
WHERE [Row #] = 1

/*Rank Function - Like PGA scores*/
SELECT
    RANK() OVER (PARTITION BY CF.PersonId, CF.FormId ORDER BY CompletionDate DESC) AS [Rank],
    P.FirstName + ' ' + P.LastName AS [Full Name],
    F.FormName AS [Form Name],
    CF.CompletionDate AS [Completion Date]
FROM @CompletedForms CF
    JOIN @Forms F ON F.FormId = CF.FormId
    JOIN @Persons P ON P.PersonId = CF.PersonId

/*Dense Rank Function*/
SELECT
    DENSE_RANK() OVER (PARTITION BY CF.PersonId, CF.FormId ORDER BY CompletionDate DESC) AS [Dense Rank],
    P.FirstName + ' ' + P.LastName AS [Full Name],
    F.FormName AS [Form Name],
    CF.CompletionDate AS [Completion Date]
FROM @CompletedForms CF
    JOIN @Forms F ON F.FormId = CF.FormId
    JOIN @Persons P ON P.PersonId = CF.PersonId