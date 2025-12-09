MERGE {db_name}.{schema_name}.DimSuppliers AS Target
USING {db_name}.{schema_name}.Suppliers AS Source
ON Target.SupplierID_NK = Source.SupplierID
WHEN MATCHED AND Target.ContactName <> Source.ContactName THEN
    UPDATE SET
        Target.Previous_ContactName = Target.ContactName,
        Target.ContactName = Source.ContactName,
        Target.CompanyName = Source.CompanyName,
        Target.ContactTitle = Source.ContactTitle,
        Target.Country = Source.Country,
        Target.staging_raw_id = Source.staging_raw_id_sk
WHEN NOT MATCHED THEN
    INSERT (SupplierID_NK, CompanyName, ContactName, Previous_ContactName, ContactTitle, Country, SOR_SK, staging_raw_id)
    VALUES (Source.SupplierID, Source.CompanyName, Source.ContactName, NULL, Source.ContactTitle, Source.Country,
           (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Suppliers'), Source.staging_raw_id_sk);