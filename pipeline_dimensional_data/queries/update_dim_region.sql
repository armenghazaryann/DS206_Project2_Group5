INSERT INTO {db_name}.{schema_name}.DimRegion_History (
    RegionSK, RegionDescription, RegionCategory, RegionImportance, ValidFrom, ValidTo
)
SELECT
    D.RegionSK, D.RegionDescription, D.RegionCategory, D.RegionImportance,
    GETDATE(), GETDATE()
FROM {db_name}.{schema_name}.DimRegion D
JOIN {db_name}.{schema_name}.Region S ON D.RegionID_NK = S.RegionID
WHERE D.RegionDescription <> S.RegionDescription
   OR D.RegionCategory <> S.RegionCategory
   OR D.RegionImportance <> S.RegionImportance;

MERGE {db_name}.{schema_name}.DimRegion AS Target
USING {db_name}.{schema_name}.Region AS Source
ON Target.RegionID_NK = Source.RegionID
WHEN MATCHED THEN
    UPDATE SET
        Target.RegionDescription = Source.RegionDescription,
        Target.RegionCategory = Source.RegionCategory,
        Target.RegionImportance = Source.RegionImportance,
        Target.staging_raw_id = Source.staging_raw_id_sk
WHEN NOT MATCHED THEN
    INSERT (RegionID_NK, RegionDescription, RegionCategory, RegionImportance, SOR_SK, staging_raw_id)
    VALUES (Source.RegionID, Source.RegionDescription, Source.RegionCategory, Source.RegionImportance,
           (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Region'), Source.staging_raw_id_sk);