MERGE {db_name}.{schema_name}.DimCategories AS Target
USING {db_name}.{schema_name}.Categories AS Source
ON Target.CategoryID_NK = Source.CategoryID
WHEN MATCHED AND (Target.CategoryName <> Source.CategoryName OR Target.Description <> Source.Description) THEN
    UPDATE SET
        Target.CategoryName = Source.CategoryName,
        Target.Description = Source.Description,
        Target.staging_raw_id = Source.staging_raw_id_sk
WHEN NOT MATCHED THEN
    INSERT (CategoryID_NK, CategoryName, Description, SOR_SK, staging_raw_id)
    VALUES (Source.CategoryID, Source.CategoryName, Source.Description,
           (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Categories'),
           Source.staging_raw_id_sk);