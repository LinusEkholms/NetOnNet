USE master
GO
 
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'NetOnNetSS')
BEGIN
    ALTER DATABASE NetOnNetSS SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE NetOnNetSS
END;
 
CREATE DATABASE NetOnNetSS
GO
 
USE NetOnNetSS
GO


-- STAR SCHEMA


CREATE TABLE Dim_Store (
    StoreID INT PRIMARY KEY,
    StoreName NVARCHAR(50),
    Address NVARCHAR(50)
);
GO


CREATE TABLE Dim_Product (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    UnitPrice DECIMAL(18,2),
	SupplierName NVARCHAR(50),
    CategoryName NVARCHAR(50)
);
GO


CREATE TABLE Dim_Warehouse (
    WarehouseID INT PRIMARY KEY,
    WarehouseName NVARCHAR(50),
    Address NVARCHAR(50)
);
GO


CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY,
    Date DATE NOT NULL,
    Day INT NOT NULL,
    Month INT NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Week INT NOT NULL,
    WeekdayName NVARCHAR(10) NOT NULL
);
GO


CREATE TABLE Fact_Stock (
    StockID INT PRIMARY KEY,
    WarehouseID INT,
    StoreID INT,
    ProductID INT,
    QuantityInStore INT,
    QuantityInWarehouse INT,
	DateKey INT,
    LastUpdated DATE,
    CONSTRAINT FK_Stock_Warehouse FOREIGN KEY (WarehouseID) REFERENCES Dim_Warehouse(WarehouseID),
    CONSTRAINT FK_Stock_Store FOREIGN KEY (StoreID) REFERENCES Dim_Store(StoreID),
    CONSTRAINT FK_Stock_Product FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID),
    CONSTRAINT FK_Stock_DateKey FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey)
);
GO


-- SNOWFLAKE SCHEMA


CREATE TABLE Dim_Country (
    CountryID INT PRIMARY KEY,
    CountryName NVARCHAR(30)
);
GO


CREATE TABLE Dim_City (
    CityID INT PRIMARY KEY,
    CityName NVARCHAR(30),
    CountryID INT,
    CONSTRAINT FK_City_Country FOREIGN KEY (CountryID) REFERENCES Dim_Country(CountryID)
);
GO


CREATE TABLE Dim_PostalCode (
    PostalCodeID INT PRIMARY KEY,
    PostalCode NVARCHAR(5),
    CityID INT,
    CONSTRAINT FK_PostalCode_City FOREIGN KEY (CityID) REFERENCES Dim_City(CityID)
);
GO


CREATE TABLE Dim_Address (
    AddressID INT PRIMARY KEY,
    StreetName NVARCHAR(50),
    PostalCodeID INT,
    CONSTRAINT FK_Address_PostalCode FOREIGN KEY (PostalCodeID) REFERENCES Dim_PostalCode(PostalCodeID)
);
GO


CREATE TABLE Dim_ProductCategory (
    ProductCategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(30)
);
GO


CREATE TABLE Dim_Supplier (
	SupplierID INT PRIMARY KEY,
	SupplierName NVARCHAR(50),
	ContactName NVARCHAR(50),
	ContactPhone NVARCHAR(20),
	AddressID INT,
	CONSTRAINT FK_Supplier_Address FOREIGN KEY (AddressID) REFERENCES Dim_Address(AddressID)
);
GO


-- UPDATE STAR SCHEMA TO SNOFLAKE SCHEMA


DECLARE @StartDate DATE = '2020-01-01';  
DECLARE @EndDate DATE = '2026-12-31';  

WHILE @StartDate <= @EndDate  
BEGIN  
    INSERT INTO Dim_Date (DateKey, Date, Day, Month, Year, Quarter, Week, WeekdayName)  
    VALUES (
        CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT),
        @StartDate,  
        DAY(@StartDate),  
        MONTH(@StartDate),  
        YEAR(@StartDate),  
        DATEPART(QUARTER, @StartDate),  
        DATEPART(WEEK, @StartDate),  
        DATENAME(WEEKDAY, @StartDate)  
    );  

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;  
GO


ALTER TABLE Dim_Product
DROP COLUMN CategoryName;

ALTER TABLE Dim_Product
ADD ProductCategoryID INT;

ALTER TABLE Dim_Product
ADD CONSTRAINT FK_Product_ProductCategory FOREIGN KEY (ProductCategoryID) REFERENCES Dim_ProductCategory(ProductCategoryID);

ALTER TABLE Dim_Product
DROP COLUMN SupplierName;

ALTER TABLE Dim_Product
ADD SupplierID INT;

ALTER TABLE Dim_Product
ADD CONSTRAINT FK_Product_Supplier FOREIGN KEY (SupplierID) REFERENCES Dim_Supplier(SupplierID);


ALTER TABLE Dim_Store
DROP COLUMN Address;

ALTER TABLE Dim_Store
ADD AddressID INT;

ALTER TABLE Dim_Store
ADD CONSTRAINT FK_Store_AddressID FOREIGN KEY (AddressID) REFERENCES Dim_Address(AddressID);


ALTER TABLE Dim_Warehouse
DROP COLUMN Address;

ALTER TABLE Dim_Warehouse
ADD AddressID INT;

ALTER TABLE Dim_Warehouse
ADD CONSTRAINT FK_Warehouse_AddressID FOREIGN KEY (AddressID) REFERENCES Dim_Address(AddressID);
GO


-- INSERT DATA TO SNOWFLAKE TABLES


INSERT INTO Dim_Country (CountryID, CountryName)
SELECT DISTINCT CountryID, CountryName
FROM NetOnNet.dbo.Country;
GO


INSERT INTO Dim_City (CityID, CityName, CountryID)
SELECT DISTINCT CityID, CityName, CountryID 
FROM NetOnNet.dbo.City;
GO


INSERT INTO Dim_PostalCode (PostalCodeID, PostalCode, CityID)
SELECT DISTINCT PostalCodeID, PostalCode, CityID
FROM NetOnNet.dbo.PostalCode;
GO


INSERT INTO Dim_Address (AddressID, StreetName, PostalCodeID)
SELECT DISTINCT AddressID, StreetName, PostalCodeID 
FROM NetOnNet.dbo.Address;
GO


INSERT INTO Dim_ProductCategory (ProductCategoryID, CategoryName)
SELECT DISTINCT ProductCategoryID, CategoryName
FROM NetOnNet.dbo.ProductCategory;
GO


INSERT INTO Dim_Supplier (SupplierID, SupplierName, ContactName, ContactPhone, AddressID)
SELECT DISTINCT SupplierID, SupplierName, ContactName, ContactPhone, AddressID
FROM NetOnNet.dbo.Supplier;
GO


INSERT INTO Dim_Product (ProductID, ProductName, UnitPrice, SupplierID, ProductCategoryID)
SELECT DISTINCT ProductID, ProductName, UnitPrice, SupplierID, ProductCategoryID
FROM NetOnNet.dbo.Product;
GO


INSERT INTO Dim_Warehouse (WarehouseID, WarehouseName, AddressID)
SELECT w.WarehouseID, w.WarehouseName, a.AddressID
FROM NetOnNet.dbo.Warehouse w
LEFT JOIN Dim_Address a ON w.AddressID = a.AddressID;
GO


INSERT INTO Dim_Store (StoreID, StoreName, AddressID)
SELECT s.StoreID, s.StoreName, a.AddressID
FROM NetOnNet.dbo.Store s
LEFT JOIN Dim_Address a ON s.AddressID = a.AddressID;
GO


INSERT INTO Fact_Stock (StockID, WarehouseID, StoreID, ProductID, QuantityInStore, QuantityInWarehouse, DateKey, LastUpdated)
SELECT 
    s.StockID, 
    s.WarehouseID, 
    s.StoreID, 
    s.ProductID, 
    s.QuantityInStore, 
    s.QuantityInWarehouse,
	d.DateKey,
    s.LastUpdated
FROM NetOnNet.dbo.Stock s
JOIN Dim_Date d ON d.Date = CAST(s.LastUpdated AS DATE)
WHERE s.LastUpdated IS NOT NULL;
GO