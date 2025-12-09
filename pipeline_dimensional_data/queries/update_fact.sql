INSERT INTO {db_name}.{schema_name}.FactOrders (
    OrderID_NK, ProductSK, CustomerSK, EmployeeSK, TerritorySK, ShipperSK, SupplierSK,
    UnitPrice, Quantity, Discount, Freight,
    OrderDate, RequiredDate, ShippedDate,
    SOR_SK, staging_raw_id, InsertedDate
)
SELECT
    O.OrderID,
    DP.ProductSK,
    DC.CustomerSK,
    DE.EmployeeSK,
    DT.TerritorySK,
    DS.ShipperSK,
    DSupp.SupplierSK,
    OD.UnitPrice,
    OD.Quantity,
    OD.Discount,
    O.Freight,
    O.OrderDate,
    O.RequiredDate,
    O.ShippedDate,
    (SELECT SOR_SK FROM {db_name}.{schema_name}.Dim_SOR WHERE StagingTableName = 'Order Details'),
    OD.staging_raw_id_sk,
    GETDATE()
FROM {db_name}.{schema_name}.Orders O
JOIN {db_name}.{schema_name}.[Order Details] OD ON O.OrderID = OD.OrderID
LEFT JOIN {db_name}.{schema_name}.DimProducts DP ON OD.ProductID = DP.ProductID_NK AND DP.IsCurrent = 1
LEFT JOIN {db_name}.{schema_name}.DimCustomers DC ON O.CustomerID = DC.CustomerID_NK AND DC.IsCurrent = 1
LEFT JOIN {db_name}.{schema_name}.DimEmployees DE ON O.EmployeeID = DE.EmployeeID_NK
LEFT JOIN {db_name}.{schema_name}.DimTerritories DT ON O.TerritoryID = DT.TerritoryID_NK
LEFT JOIN {db_name}.{schema_name}.DimShippers DS ON O.ShipVia = DS.ShipperID_NK
LEFT JOIN {db_name}.{schema_name}.DimSuppliers DSupp ON DP.ProductID_NK = DP.ProductID_NK AND DSupp.SupplierID_NK = (SELECT SupplierID FROM {db_name}.{schema_name}.Products WHERE ProductID = DP.ProductID_NK)
WHERE O.OrderDate >= '{start_date}' AND O.OrderDate <= '{end_date}'
AND NOT EXISTS (
    SELECT 1 FROM {db_name}.{schema_name}.FactOrders F
    WHERE F.OrderID_NK = O.OrderID AND F.ProductSK = DP.ProductSK
);