USE ORDER_DDS;
GO

IF OBJECT_ID('dbo.Dim_SOR', 'U') IS NOT NULL DROP TABLE dbo.Dim_SOR;
CREATE TABLE dbo.Dim_SOR (
    SOR_SK INT IDENTITY(1,1) PRIMARY KEY,
    StagingTableName NVARCHAR(100) NOT NULL
);

INSERT INTO dbo.Dim_SOR (StagingTableName) VALUES
('Categories'),('Customers'),('Employees'),('Order Details'),('Orders'),
('Products'),('Region'),('Shippers'),('Suppliers'),('Territories');

IF OBJECT_ID('dbo.DimCategories', 'U') IS NOT NULL DROP TABLE dbo.DimCategories;
CREATE TABLE dbo.DimCategories (
    CategorySK INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID_NK INT NOT NULL,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX),
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimCustomers', 'U') IS NOT NULL DROP TABLE dbo.DimCustomers;
CREATE TABLE dbo.DimCustomers (
    CustomerSK INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID_NK NCHAR(5) NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    Country NVARCHAR(100),
    ValidFrom DATETIME,
    ValidTo DATETIME,
    IsCurrent BIT,
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimEmployees', 'U') IS NOT NULL DROP TABLE dbo.DimEmployees;
CREATE TABLE dbo.DimEmployees (
    EmployeeSK INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID_NK INT NOT NULL,
    LastName NVARCHAR(100),
    FirstName NVARCHAR(100),
    Title NVARCHAR(100),
    BirthDate DATETIME,
    HireDate DATETIME,
    ReportsTo INT,
    IsDeleted BIT DEFAULT 0,
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimProducts', 'U') IS NOT NULL DROP TABLE dbo.DimProducts;
CREATE TABLE dbo.DimProducts (
    ProductSK INT IDENTITY(1,1) PRIMARY KEY,
    ProductID_NK INT NOT NULL,
    ProductName NVARCHAR(255),
    QuantityPerUnit NVARCHAR(100),
    UnitPrice DECIMAL(10, 2),
    Discontinued BIT,
    ValidFrom DATETIME,
    ValidTo DATETIME,
    IsCurrent BIT,
    IsDeleted BIT DEFAULT 0,
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimRegion', 'U') IS NOT NULL DROP TABLE dbo.DimRegion;
CREATE TABLE dbo.DimRegion (
    RegionSK INT IDENTITY(1,1) PRIMARY KEY,
    RegionID_NK INT NOT NULL,
    RegionDescription NVARCHAR(100),
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50),
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimRegion_History', 'U') IS NOT NULL DROP TABLE dbo.DimRegion_History;
CREATE TABLE dbo.DimRegion_History (
    RegionHistorySK INT IDENTITY(1,1) PRIMARY KEY,
    RegionSK INT,
    RegionDescription NVARCHAR(100),
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50),
    ValidFrom DATETIME,
    ValidTo DATETIME
);

IF OBJECT_ID('dbo.DimShippers', 'U') IS NOT NULL DROP TABLE dbo.DimShippers;
CREATE TABLE dbo.DimShippers (
    ShipperSK INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID_NK INT NOT NULL,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50),
    IsDeleted BIT DEFAULT 0,
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimSuppliers', 'U') IS NOT NULL DROP TABLE dbo.DimSuppliers;
CREATE TABLE dbo.DimSuppliers (
    SupplierSK INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID_NK INT NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    Previous_ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Country NVARCHAR(100),
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimTerritories', 'U') IS NOT NULL DROP TABLE dbo.DimTerritories;
CREATE TABLE dbo.DimTerritories (
    TerritorySK INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID_NK NVARCHAR(20) NOT NULL,
    TerritoryDescription NVARCHAR(100),
    RegionID_NK INT,
    SOR_SK INT,
    staging_raw_id INT
);

IF OBJECT_ID('dbo.DimTerritories_History', 'U') IS NOT NULL DROP TABLE dbo.DimTerritories_History;
CREATE TABLE dbo.DimTerritories_History (
    TerritoryHistorySK INT IDENTITY(1,1) PRIMARY KEY,
    TerritorySK INT,
    TerritoryDescription NVARCHAR(100),
    ValidFrom DATETIME,
    ValidTo DATETIME
);

IF OBJECT_ID('dbo.FactOrders', 'U') IS NOT NULL DROP TABLE dbo.FactOrders;
CREATE TABLE dbo.FactOrders (
    FactOrderSK INT IDENTITY(1,1) PRIMARY KEY,
    OrderID_NK INT NOT NULL,

    ProductSK INT,
    CustomerSK INT,
    EmployeeSK INT,
    TerritorySK INT,
    ShipperSK INT,
    SupplierSK INT,

    UnitPrice DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(4, 2),
    Freight DECIMAL(10, 2),

    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,

    SOR_SK INT,
    staging_raw_id INT,
    InsertedDate DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.Fact_Error', 'U') IS NOT NULL DROP TABLE dbo.Fact_Error;
CREATE TABLE dbo.Fact_Error (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID_NK INT,
    ProductID_NK INT,
    ErrorMessage NVARCHAR(MAX),
    SOR_SK INT,
    staging_raw_id INT,
    ErrorDate DATETIME DEFAULT GETDATE()
);
GO

