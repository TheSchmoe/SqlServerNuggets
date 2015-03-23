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

    SELECT *
    FROM @People AS peeps
	   LEFT JOIN @Jobs AS jerbs ON peeps.Id = jerbs.FKID

    SELECT *
    FROM @People AS peeps
	   LEFT JOIN @Jobs AS jerbs ON peeps.Id = jerbs.FKID AND jerbs.Active = 1

    SELECT *
    FROM @People AS peeps
	   LEFT JOIN @Jobs AS jerbs ON peeps.Id = jerbs.FKID 
    WHERE jerbs.Active = 1

    SELECT *
    FROM @People AS peeps
	   INNER JOIN @Jobs AS jerbs ON peeps.Id = jerbs.FKID 
    WHERE jerbs.Active = 1

    SELECT *
    FROM @People AS peeps
	   INNER JOIN @Jobs AS jerbs ON peeps.Id = jerbs.FKID AND jerbs.Active = 1
