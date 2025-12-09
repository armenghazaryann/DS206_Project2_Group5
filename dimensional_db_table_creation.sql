-- Drop tables if they exist

-- Drop DimCategories if exists
IF OBJECT_ID('dbo.DimCategories', 'U') IS NOT NULL
    DROP TABLE dbo.DimCategories;


-- Drop DimProducts if exists
IF OBJECT_ID('dbo.DimProducts', 'U') IS NOT NULL
    DROP TABLE dbo.DimProducts;

-- Drop DimRegion if exists
IF OBJECT_ID('dbo.DimRegion', 'U') IS NOT NULL
    DROP TABLE dbo.DimRegion;

-- Drop DimShippers if exists
IF OBJECT_ID('dbo.DimShippers', 'U') IS NOT NULL
    DROP TABLE dbo.DimShippers;

-- Drop DimSuppliers if exists
IF OBJECT_ID('dbo.DimSuppliers', 'U') IS NOT NULL
    DROP TABLE dbo.DimSuppliers;

-- Drop DimTerritories if exists
IF OBJECT_ID('dbo.DimTerritories', 'U') IS NOT NULL
    DROP TABLE dbo.DimTerritories;

-- Drop FactOrders if exists
IF OBJECT_ID('dbo.FactOrders', 'U') IS NOT NULL
    DROP TABLE dbo.FactOrders;

-- Drop Dim_SOR if exists
IF OBJECT_ID('dbo.Dim_SOR', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_SOR;

    -- Drop DimCustomers if exists
IF OBJECT_ID('dbo.DimCustomers', 'U') IS NOT NULL
    DROP TABLE dbo.DimCustomers;

-- Drop DimEmployees if exists
IF OBJECT_ID('dbo.DimEmployees', 'U') IS NOT NULL
    DROP TABLE dbo.DimEmployees;

-- DimCategories (SCD1)
CREATE TABLE dbo.DimCategories (
    CategorySK INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate Key
    CategoryID INT,                            -- Business Key
    CategoryName NVARCHAR(255),                 -- Dimension Attribute
    Description NVARCHAR(MAX),                  -- Dimension Attribute
    CreatedAt DATETIME DEFAULT GETDATE(),       -- Created At Timestamp
    StagingRawID INT                            -- StagingRawID (from Dim_SOR)
);
GO

-- DimCustomers (SCD2)
CREATE TABLE dbo.DimCustomers (
    CustomerSK INT IDENTITY(1,1) PRIMARY KEY,      -- Surrogate Key
    CustomerID NVARCHAR(20) UNIQUE,                 -- Business Key
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
    StartDate DATETIME DEFAULT GETDATE(),          -- Start Date (SCD Type 2)
    EndDate DATETIME,                               -- End Date (SCD Type 2)
    IsCurrent BIT DEFAULT 1,                        -- IsCurrent flag (SCD Type 2)
    CreatedAt DATETIME DEFAULT GETDATE(),           -- Created At Timestamp
    StagingRawID INT                                -- StagingRawID (from Dim_SOR)
);
GO

-- DimEmployees (SCD1 with delete)
CREATE TABLE dbo.DimEmployees (
    EmployeeSK INT IDENTITY(1,1) PRIMARY KEY,      -- Surrogate Key
    EmployeeID INT,                                -- Business Key
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
    ReportsTo INT,                                 -- Self-Referencing Foreign Key (Employee)
    IsActive BIT DEFAULT 1,                        -- Track if Employee is Active (SCD1 with delete)
    CreatedAt DATETIME DEFAULT GETDATE(),           -- Created At Timestamp
    StagingRawID INT                                -- StagingRawID (from Dim_SOR)
);
GO

-- DimProducts (SCD2 with delete (closing))
CREATE TABLE dbo.DimProducts (
    ProductSK INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key
    ProductID INT,                                 -- Business Key
    ProductName NVARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(255),
    UnitPrice DECIMAL(18,4),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT,
    StartDate DATETIME DEFAULT GETDATE(),          -- Start Date (SCD Type 2)
    EndDate DATETIME,                               -- End Date (SCD Type 2)
    IsCurrent BIT DEFAULT 1,                        -- IsCurrent flag (SCD Type 2)
    CreatedAt DATETIME DEFAULT GETDATE(),           -- Created At Timestamp
    StagingRawID INT                                -- StagingRawID (from Dim_SOR)
);
GO

-- DimRegion (SCD4)
CREATE TABLE dbo.DimRegion (
    RegionSK INT IDENTITY(1,1) PRIMARY KEY,        -- Surrogate Key
    RegionID INT,                                  -- Business Key
    RegionDescription NVARCHAR(255),
    StartDate DATETIME DEFAULT GETDATE(),          -- Start Date (SCD Type 4)
    EndDate DATETIME,                               -- End Date (SCD Type 4)
    IsCurrent BIT DEFAULT 1,                        -- IsCurrent flag (SCD Type 4)
    CreatedAt DATETIME DEFAULT GETDATE(),           -- Created At Timestamp
    StagingRawID INT                                -- StagingRawID (from Dim_SOR)
);
GO

-- DimShippers (SCD1 with delete)
CREATE TABLE dbo.DimShippers (
    ShipperSK INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key
    ShipperID INT,                                 -- Business Key
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50),
    IsActive BIT DEFAULT 1,                        -- IsActive flag (SCD1 with delete)
    CreatedAt DATETIME DEFAULT GETDATE(),           -- Created At Timestamp
    StagingRawID INT                                -- StagingRawID (from Dim_SOR)
);
GO

-- DimSuppliers (SCD3)
CREATE TABLE dbo.DimSuppliers (
    SupplierSK INT IDENTITY(1,1) PRIMARY KEY,      -- Surrogate Key
    SupplierID INT,                                -- Business Key
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
    CurrentValue NVARCHAR(255),                    -- Track current value
    PriorValue NVARCHAR(255),                      -- Track prior value (SCD3)
    StartDate DATETIME DEFAULT GETDATE(),          -- Start Date (SCD3)
    EndDate DATETIME,                               -- End Date (SCD3)
    IsCurrent BIT DEFAULT 1,                        -- IsCurrent flag (SCD3)
    CreatedAt DATETIME DEFAULT GETDATE(),           -- Created At Timestamp
    StagingRawID INT                                -- StagingRawID (from Dim_SOR)
);
GO

-- DimTerritories (SCD4)
CREATE TABLE dbo.DimTerritories (
    TerritorySK INT IDENTITY(1,1) PRIMARY KEY,     -- Surrogate Key
    TerritoryID NVARCHAR(20),                      -- Business Key
    TerritoryDescription NVARCHAR(255),
    StartDate DATETIME DEFAULT GETDATE(),          -- Start Date (SCD Type 4)
    EndDate DATETIME,                               -- End Date (SCD Type 4)
    IsCurrent BIT DEFAULT 1,                        -- IsCurrent flag (SCD Type 4)
    CreatedAt DATETIME DEFAULT GETDATE(),           -- Created At Timestamp
    StagingRawID INT                                -- StagingRawID (from Dim_SOR)
);
GO

-- FactOrders (Fact Table)
CREATE TABLE dbo.FactOrders (
    OrderSK INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key
    OrderID INT,                                 -- Business Key (from Orders)
    CustomerSK INT,                              -- Foreign Key (from DimCustomers)
    EmployeeSK INT,                              -- Foreign Key (from DimEmployees)
    OrderDate DATETIME,
    ShippedDate DATETIME,
    Freight DECIMAL(18, 4),
    ShipName NVARCHAR(255),
    ShipCity NVARCHAR(100),
    ShipCountry NVARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE(),        -- Created At Timestamp
    StagingRawID INT,                            -- StagingRawID (from Dim_SOR)
    FOREIGN KEY (CustomerSK) REFERENCES dbo.DimCustomers(CustomerSK),
    FOREIGN KEY (EmployeeSK) REFERENCES dbo.DimEmployees(EmployeeSK)
);
GO

-- Dim_SOR (Staging Raw Table Reference Dimension Table)
CREATE TABLE dbo.Dim_SOR (
    SOR_SK INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate Key
    StagingRawTableName NVARCHAR(255) NOT NULL,  -- Staging Table Name
    StagingRawID INT                            -- StagingRawID for tracking
);
GO

