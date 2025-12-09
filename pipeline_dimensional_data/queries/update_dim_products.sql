UPDATE D
SET D.ValidTo = GETDATE(), D.IsCurrent = 0
FROM {db_name}.{schema_name}.DimProducts D
JOIN {db_name}.{schema_name}.Products S ON D.ProductID_NK = S.ProductID
WHERE D.IsCurrent = 1
  AND (D.ProductName <> S.ProductName OR D.UnitPrice <> S.UnitPrice OR D.Discontinued <> S.Discontinued);

INSERT INTO {db_name}.{schema_name}.DimProducts (
    ProductID_NK, ProductName, QuantityPerUnit, UnitPrice, Discontinued,
    ValidFrom, ValidTo, IsCurrent, IsDeleted, SOR_SK, staging_raw_id
)
SELECT
    S.ProductID, S.ProductName, S.QuantityPerUnit, S.UnitPrice, S.Discontinued,
    GETDATE(), '9999-12-31', 1, 0,
    (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Products'),
    S.staging_raw_id_sk
FROM {db_name}.{schema_name}.Products S
WHERE S.ProductID IN (SELECT ProductID_NK FROM {db_name}.{schema_name}.DimProducts WHERE IsCurrent=0 AND ValidTo > DATEADD(minute, -1, GETDATE()));

INSERT INTO {db_name}.{schema_name}.DimProducts (
    ProductID_NK, ProductName, QuantityPerUnit, UnitPrice, Discontinued,
    ValidFrom, ValidTo, IsCurrent, IsDeleted, SOR_SK, staging_raw_id
)
SELECT
    S.ProductID, S.ProductName, S.QuantityPerUnit, S.UnitPrice, S.Discontinued,
    GETDATE(), '9999-12-31', 1, 0,
    (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Products'),
    S.staging_raw_id_sk
FROM {db_name}.{schema_name}.Products S
WHERE NOT EXISTS (SELECT 1 FROM {db_name}.{schema_name}.DimProducts D WHERE D.ProductID_NK = S.ProductID);

UPDATE {db_name}.{schema_name}.DimProducts
SET IsDeleted = 1, IsCurrent = 0, ValidTo = GETDATE()
WHERE ProductID_NK NOT IN (SELECT ProductID FROM {db_name}.{schema_name}.Products) AND IsCurrent = 1;