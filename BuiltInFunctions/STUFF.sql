/**  DATA SETUP  ***************************************************************************/
DECLARE @People TABLE (Id int,Name varchar(55))
DECLARE @Jobs TABLE (Id int identity(1,1), FKID int, Active BIT, Job VARCHAR(55))

INSERT INTO @People
(Id, Name)
VALUES
(1,'Joe'),(2,'Justin'),(3,'Phil'),(4,'John'),(5,'LaWanda')

INSERT INTO @Jobs
    (FKID, Active, Job)
VALUES
    (1,1,'SQL Developer'),
    (1,0,'.NET Developer'),
    (1,1,'Android Developer'),
    (3,1,'SQL Developer'),
    (3,0,'.NET Developer'),
    (3,1,'Android Developer'),
    (4,1,'SQL Developer'),
    (5,0,'.NET Developer'),
    (5,1,'Android Developer'),
    (5,1,'SQL Developer')

/**  END DATA SETUP  ***********************************************************************/

SELECT
    Name,
    (SELECT 
        STUFF(
                (
                    SELECT ', ' + Job 
                    FROM @Jobs j 
                    WHERE j.FKID = peeps.id
                    ORDER BY Job 
                    FOR XML PATH ('')
                ), 1, 1, ''
             )
    ) AS [All Jobs],
    (SELECT 
        STUFF(
                (
                    SELECT ', ' + Job 
                    FROM @Jobs j 
                    WHERE j.FKID = peeps.id AND Active = 1
                    ORDER BY Job 
                    FOR XML PATH ('')
                ), 1, 1, ''
             )
    ) AS [Active Jobs],
    (SELECT 
        STUFF(
                (
                    SELECT ', ' + Job 
                    FROM @Jobs j 
                    WHERE j.FKID = peeps.id AND Active = 0
                    ORDER BY Job 
                    FOR XML PATH ('')
                ), 1, 1, ''
             )
    ) AS [Inactive Jobs]
FROM @People peeps


SELECT  
    Name,
    STUFF(jerbs.Job, 5, 0, '{GABBANANANA!}')
FROM @People peeps
    INNER JOIN @Jobs jerbs ON jerbs.FKID = peeps.Id

    