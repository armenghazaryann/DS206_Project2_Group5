-- staging_raw_table_creation.sql
USE ORDER_DDS;
GO

-- =======================
-- stg_Categories
-- =======================
CREATE TABLE dbo.stg_Categories (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Customers
-- =======================
CREATE TABLE dbo.stg_Customers (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(20),
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Employees
-- =======================
CREATE TABLE dbo.stg_Employees (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LastName NVARCHAR(255),
    FirstName NVARCHAR(255),
    Title NVARCHAR(255),
    TitleOfCourtesy NVARCHAR(50),
    BirthDate DATETIME,
    HireDate DATETIME,
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    HomePhone NVARCHAR(50),
    Extension NVARCHAR(10),
    ReportsTo INT,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Products
-- =======================
CREATE TABLE dbo.stg_Products (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(255),
    UnitPrice DECIMAL(18,4),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Region
-- =======================
CREATE TABLE dbo.stg_Region (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Shippers
-- =======================
CREATE TABLE dbo.stg_Shippers (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Suppliers
-- =======================
CREATE TABLE dbo.stg_Suppliers (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50),
    HomePage NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Territories
-- =======================
CREATE TABLE dbo.stg_Territories (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(255),
    RegionID INT,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Orders
-- =======================
CREATE TABLE dbo.stg_Orders (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerID NVARCHAR(20),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight DECIMAL(18,4),
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(255),
    ShipCity NVARCHAR(100),
    ShipRegion NVARCHAR(100),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(100),
    TerritoryID NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =======================
-- stg_Order_Details
-- =======================
CREATE TABLE dbo.stg_Order_Details (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(18,4),
    Quantity INT,
    Discount FLOAT,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO


SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG = 'ORDER_DDS';
