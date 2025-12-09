UPDATE D
SET D.ValidTo = GETDATE(), D.IsCurrent = 0
FROM {db_name}.{schema_name}.DimCustomers D
JOIN {db_name}.{schema_name}.Customers S ON D.CustomerID_NK = S.CustomerID
WHERE D.IsCurrent = 1
  AND (D.CompanyName <> S.CompanyName OR D.ContactName <> S.ContactName OR D.Address <> S.Address);

INSERT INTO {db_name}.{schema_name}.DimCustomers (
    CustomerID_NK, CompanyName, ContactName, Address, City, Region, Country,
    ValidFrom, ValidTo, IsCurrent, SOR_SK, staging_raw_id
)
SELECT
    S.CustomerID, S.CompanyName, S.ContactName, S.Address, S.City, S.Region, S.Country,
    GETDATE(), '9999-12-31', 1,
    (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Customers'),
    S.staging_raw_id_sk
FROM {db_name}.{schema_name}.Customers S
JOIN {db_name}.{schema_name}.DimCustomers D ON S.CustomerID = D.CustomerID_NK
WHERE D.IsCurrent = 0
  AND D.ValidTo > DATEADD(second, -5, GETDATE());

INSERT INTO {db_name}.{schema_name}.DimCustomers (
    CustomerID_NK, CompanyName, ContactName, Address, City, Region, Country,
    ValidFrom, ValidTo, IsCurrent, SOR_SK, staging_raw_id
)
SELECT
    S.CustomerID, S.CompanyName, S.ContactName, S.Address, S.City, S.Region, S.Country,
    GETDATE(), '9999-12-31', 1,
    (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Customers'),
    S.staging_raw_id_sk
FROM {db_name}.{schema_name}.Customers S
WHERE NOT EXISTS (SELECT 1 FROM {db_name}.{schema_name}.DimCustomers D WHERE D.CustomerID_NK = S.CustomerID);