MERGE {db_name}.{schema_name}.DimShippers AS Target
USING {db_name}.{schema_name}.Shippers AS Source
ON Target.ShipperID_NK = Source.ShipperID
WHEN MATCHED THEN
    UPDATE SET Target.CompanyName = Source.CompanyName, Target.Phone = Source.Phone, Target.IsDeleted = 0
WHEN NOT MATCHED THEN
    INSERT (ShipperID_NK, CompanyName, Phone, IsDeleted, SOR_SK, staging_raw_id)
    VALUES (Source.ShipperID, Source.CompanyName, Source.Phone, 0,
           (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Shippers'), Source.staging_raw_id_sk);

UPDATE Target SET IsDeleted = 1
FROM {db_name}.{schema_name}.DimShippers Target
WHERE NOT EXISTS (SELECT 1 FROM {db_name}.{schema_name}.Shippers S WHERE S.ShipperID = Target.ShipperID_NK);