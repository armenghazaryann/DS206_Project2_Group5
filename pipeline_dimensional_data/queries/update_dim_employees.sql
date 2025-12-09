MERGE {db_name}.{schema_name}.DimEmployees AS Target
USING {db_name}.{schema_name}.Employees AS Source
ON Target.EmployeeID_NK = Source.EmployeeID
WHEN MATCHED AND (Target.LastName <> Source.LastName OR Target.Title <> Source.Title) THEN
    UPDATE SET
        Target.LastName = Source.LastName, Target.FirstName = Source.FirstName, Target.Title = Source.Title,
        Target.staging_raw_id = Source.staging_raw_id_sk, Target.IsDeleted = 0
WHEN NOT MATCHED THEN
    INSERT (EmployeeID_NK, LastName, FirstName, Title, BirthDate, HireDate, ReportsTo, IsDeleted, SOR_SK, staging_raw_id)
    VALUES (Source.EmployeeID, Source.LastName, Source.FirstName, Source.Title, Source.BirthDate, Source.HireDate, Source.ReportsTo, 0,
           (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Employees'), Source.staging_raw_id_sk);

UPDATE Target
SET IsDeleted = 1
FROM {db_name}.{schema_name}.DimEmployees Target
WHERE NOT EXISTS (SELECT 1 FROM {db_name}.{schema_name}.Employees Source WHERE Source.EmployeeID = Target.EmployeeID_NK);