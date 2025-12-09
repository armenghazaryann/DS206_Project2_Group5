INSERT INTO {db_name}.{schema_name}.Fact_Error (
    OrderID_NK, ProductID_NK, ErrorMessage, SOR_SK, staging_raw_id
)
SELECT
    O.OrderID,
    OD.ProductID,
    'Missing Dimension Key: ' +
    CASE WHEN DP.ProductSK IS NULL THEN 'Product ' ELSE '' END +
    CASE WHEN DC.CustomerSK IS NULL THEN 'Customer ' ELSE '' END +
    CASE WHEN DE.EmployeeSK IS NULL THEN 'Employee ' ELSE '' END,
    (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Order Details'),
    OD.staging_raw_id_sk
FROM {db_name}.{schema_name}.Orders O
JOIN {db_name}.{schema_name}.[Order Details] OD ON O.OrderID = OD.OrderID
LEFT JOIN {db_name}.{schema_name}.DimProducts DP ON OD.ProductID = DP.ProductID_NK AND DP.IsCurrent = 1
LEFT JOIN {db_name}.{schema_name}.DimCustomers DC ON O.CustomerID = DC.CustomerID_NK AND DC.IsCurrent = 1
LEFT JOIN {db_name}.{schema_name}.DimEmployees DE ON O.EmployeeID = DE.EmployeeID_NK
WHERE
    (DP.ProductSK IS NULL OR DC.CustomerSK IS NULL OR DE.EmployeeSK IS NULL)
    AND O.OrderDate >= '{start_date}' AND O.OrderDate <= '{end_date}';