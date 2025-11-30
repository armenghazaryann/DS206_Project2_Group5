
USE ORDER_DDS;
GO


IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
CREATE TABLE dbo.Categories (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    CategoryID INT,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
CREATE TABLE dbo.Customers (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    CustomerID NCHAR(5),
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50)
);

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
CREATE TABLE dbo.Employees (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    EmployeeID INT,
    LastName NVARCHAR(100),
    FirstName NVARCHAR(100),
    Title NVARCHAR(100),
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
    Notes NVARCHAR(MAX),
    ReportsTo INT,
    PhotoPath NVARCHAR(MAX)
);

IF OBJECT_ID('dbo.Order Details', 'U') IS NOT NULL DROP TABLE dbo.[Order Details];
CREATE TABLE dbo.[Order Details] (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(4, 2)
);

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
CREATE TABLE dbo.Orders (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    OrderID INT,
    CustomerID NCHAR(5),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight DECIMAL(10, 2),
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(255),
    ShipCity NVARCHAR(100),
    ShipRegion NVARCHAR(100),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(100),
    TerritoryID NVARCHAR(20)
);


IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
CREATE TABLE dbo.Products (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    ProductID INT,
    ProductName NVARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(100),
    UnitPrice DECIMAL(10, 2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);

IF OBJECT_ID('dbo.Region', 'U') IS NOT NULL DROP TABLE dbo.Region;
CREATE TABLE dbo.Region (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    RegionID INT,
    RegionDescription NVARCHAR(100),
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50)
);

IF OBJECT_ID('dbo.Shippers', 'U') IS NOT NULL DROP TABLE dbo.Shippers;
CREATE TABLE dbo.Shippers (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    ShipperID INT,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50)
);

IF OBJECT_ID('dbo.Suppliers', 'U') IS NOT NULL DROP TABLE dbo.Suppliers;
CREATE TABLE dbo.Suppliers (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
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
    HomePage NVARCHAR(MAX)
);

IF OBJECT_ID('dbo.Territories', 'U') IS NOT NULL DROP TABLE dbo.Territories;
CREATE TABLE dbo.Territories (
    staging_raw_id_sk INT IDENTITY(1,1) NOT NULL,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(100),
    TerritoryCode NVARCHAR(10),
    RegionID INT
);
GO

