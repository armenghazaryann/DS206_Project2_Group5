INSERT INTO {db_name}.{schema_name}.DimTerritories_History (
    TerritorySK, TerritoryDescription, ValidFrom, ValidTo
)
SELECT
    D.TerritorySK, D.TerritoryDescription, GETDATE(), GETDATE()
FROM {db_name}.{schema_name}.DimTerritories D
JOIN {db_name}.{schema_name}.Territories S ON D.TerritoryID_NK = S.TerritoryID
WHERE D.TerritoryDescription <> S.TerritoryDescription;

MERGE {db_name}.{schema_name}.DimTerritories AS Target
USING {db_name}.{schema_name}.Territories AS Source
ON Target.TerritoryID_NK = Source.TerritoryID
WHEN MATCHED THEN
    UPDATE SET
        Target.TerritoryDescription = Source.TerritoryDescription,
        Target.RegionID_NK = Source.RegionID,
        Target.staging_raw_id = Source.staging_raw_id_sk
WHEN NOT MATCHED THEN
    INSERT (TerritoryID_NK, TerritoryDescription, RegionID_NK, SOR_SK, staging_raw_id)
    VALUES (Source.TerritoryID, Source.TerritoryDescription, Source.RegionID,
           (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Territories'), Source.staging_raw_id_sk);