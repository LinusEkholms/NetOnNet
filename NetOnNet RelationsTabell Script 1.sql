USE master
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'NetOnNet')
BEGIN
    ALTER DATABASE NetOnNet SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE NetOnNet
END

CREATE DATABASE NetOnNet;
GO

USE NetOnNet;
GO

CREATE TABLE Country (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName NVARCHAR(30)
);
GO

INSERT INTO
	Country (CountryName)
VALUES	
	('Sverige'), 
	('Norge');
GO

CREATE TABLE City (
    CityID INT IDENTITY(1,1) PRIMARY KEY,
    CountryID INT,
    CityName NVARCHAR(30),
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);
GO

INSERT INTO 
	City (CountryID, CityName)
VALUES
	(1, 'Stockholm'),
	(1, 'Göteborg'),
	(1, 'Malmö'),
	(1, 'Uppsala'),
	(1, 'Örebro'),
	(2, 'Oslo'),
	(2, 'Stavanger'),
	(2, 'Trondheim'),
	(2, 'Drammen'),
	(2, 'Bergen');
GO

CREATE TABLE PostalCode (
    PostalCodeID INT IDENTITY(1,1) PRIMARY KEY,
    CityID INT,
    PostalCode NVARCHAR(10),
    FOREIGN KEY (CityID) REFERENCES City(CityID)
);
GO

INSERT INTO 
	PostalCode (CityID, PostalCode)
VALUES
	(3, '26613'),
	(4, '30340'),
	(6, '65432'),
	(1, '77983'),
	(2, '51854'),
	(6, '65332'),
	(6, '42157'),
	(7, '46720'),
	(6, '61637'),
	(9, '82313'),
	(3, '46354'),
	(4, '67477'),
	(7, '10747'),
	(6, '85734'),
	(5, '34844'),
	(2, '91682'),
	(9, '19627'),
	(1, '65460'),
	(2, '32862'),
	(2, '77644'),
	(3, '54969'),
	(3, '93969'),
	(4, '18563'),
	(4, '23162'),
	(5, '42762'),
	(6, '50767'),
	(1, '54265'),
	(1, '14937'),
	(3, '28635'),
	(8, '56030'),
	(10, '44202'),
	(2, '37723'),
	(1, '43225'),
	(10, '84722');
GO

CREATE TABLE Address (
    AddressID INT IDENTITY(1,1) PRIMARY KEY,
    PostalCodeID INT,
    StreetName NVARCHAR(30),
    FOREIGN KEY (PostalCodeID) REFERENCES PostalCode(PostalCodeID)
);
GO

INSERT INTO Address 
	(PostalCodeID, StreetName)
VALUES
	(1, 'Storgatan 1'),
	(2, 'Hovedgaten 5'),
	(3, 'Parkveien 10'),
	(4, 'Fjordveien 23'),
	(5, 'Kirkegata 12'),
	(6, 'Torggata 3'),
	(7, 'Skolegata 15'),
	(8, 'Bakkegata 22'),
	(9, 'Industriveien 30'),
	(10, 'Vesterveien 9'),
	(11, 'Rådhusgata 14'),
	(12, 'Holmenkollveien 17'),
	(13, 'Gata 20'),
	(14, 'Havnegata 4'),
	(15, 'Bygata 7'),
	(16, 'Sjögata 18'),
	(17, 'Solheimveien 5'),
	(18, 'Skogveien 8'),
	(19, 'Elveveien 16'),
	(20, 'Grønland 10'),
	(21, 'Kongsveien 21'),
	(22, 'Klimaveien 25'),
	(23, 'Bergenhusveien 12'),
	(24, 'Nordmarkveien 6'),
	(25, 'Lillehammergata 2'),
	(26, 'Radveien 3'),
	(27, 'Skogkanten 7'),
	(28, 'Slependveien 4'),
	(29, 'Trolldalsveien 11'),
	(30, 'Torgplassen 19'),
	(31, 'Holmenkollen 13'),
	(32, 'Oslofjordveien 20'),
	(33, 'Drottninggatan 9'),
	(34, 'Hestemyrveien 24');
GO

CREATE TABLE DeliveryStatus (
    DeliveryStatusID INT IDENTITY(1,1) PRIMARY KEY,
    DeliveryStatusName NVARCHAR(30)
);
GO

INSERT INTO 
	DeliveryStatus (DeliveryStatusName)
Values 
	('Delivered'),
	('Awaiting Pickup'),
	('Shipped'),
	('Order Processing');
GO

CREATE TABLE Position (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    PositionName NVARCHAR(30) NOT NULL
);
GO

INSERT INTO 
	Position (PositionName)
VALUES 
	('Manager'),
	('Store Staff'),
	('Data Engineer');
GO

CREATE TABLE PaymentMethod (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentMethodName NVARCHAR(30) NOT NULL
);
GO

INSERT INTO 
	PaymentMethod (PaymentMethodName)
VALUES 
	('Cash'),
	('Card'),
	('Swish'), 
	('Transfer');
GO

CREATE TABLE PaymentStatus (
    PaymentStatusID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentStatusName NVARCHAR(30) NOT NULL
);
GO

INSERT INTO
	PaymentStatus (PaymentStatusName)
VALUES 
	('Completed'),
	('Pending'),
	('Delayed'), 
	('Expired');
GO

CREATE TABLE Currency (
    CurrencyID INT IDENTITY(1,1) PRIMARY KEY,
    CurrencyName NVARCHAR(30) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL
);
GO

INSERT INTO
	Currency (CurrencyName, CurrencyCode)
VALUES 
	('Svenska Kronor', 'SEK'), 
	('Norska Kronor', 'NOK');
GO

CREATE TABLE Shipper (
    ShipperID INT IDENTITY(1,1) PRIMARY KEY,
    ShipperName NVARCHAR(30) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL
);
GO

INSERT INTO 
	Shipper (ShipperName, PhoneNumber)
VALUES
	('DHL', '01022334455'),
	('Postnord', '07719292929');
GO

CREATE TABLE ProductCategory (
    ProductCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(30) NOT NULL
);
GO

INSERT INTO 
	ProductCategory (CategoryName)
VALUES 
	('TV'),
	('Gaming'), 
	('Kitchen'),
	('Mobile');
GO

CREATE TABLE Store (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    StoreName NVARCHAR(50) NOT NULL,
    AddressID INT NOT NULL,
    PhoneNumber NVARCHAR(20),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);
GO

INSERT INTO 
	Store (StoreName, AddressID, PhoneNumber)
VALUES	
	('NetonNet Sthlm', 33, '0892929292'),
	('NetonNet GBG', 32, '0771626262'),
	('NetonNe Malmö', 1, '010929292'),
	('NetonNet Oslo', 3, '020984727'),
	('NetonNet Bergen)', 31, '0204727727'),
	('NetonNet Trondheim)', 30, '0203628738');
GO

CREATE TABLE Supplier (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(50) NOT NULL,
    ContactName NVARCHAR(50) NOT NULL,
    ContactPhone NVARCHAR(20) NOT NULL,
    AddressID INT NOT NULL,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);
GO

INSERT INTO 
	Supplier (SupplierName, ContactName, ContactPhone, AddressID)
VALUES	
	('Samsung', 'Lee Hueng', '009074382284', 2),
	('Sony', 'Petter Nilsson', '08232323', 4),
	('Bosch', 'Ali Soleimani', '020073773', 5),
	('Apple', 'Roberto Gonzalo', '01093937763', 6);
GO

CREATE TABLE Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    SupplierID INT NOT NULL,
    ProductCategoryID INT NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID)
);
GO

INSERT INTO
	Product (ProductName, UnitPrice, SupplierID, ProductCategoryID)
VALUES	
	('Samsung QLED TV 40', 12999, 1, 1),
	('Samsung OLED TV 55', 14999, 1, 1),
	('Playstation 5', 5799, 2, 2),
	('Playstation 5 kontroll', 990, 2, 2),
	('Bosch Dishwasher', 7499, 3, 3),
	('CrazyX Mixer', 1490, 3, 3),
	('iPhone 14 Pro', 12999, 4, 4),
	('Ipad 15 pro', 14945, 4, 4),
	('Smooth HD LED 50', 8590, 2, 1),
	('A55 Microwave Oven', 3499, 3, 3);
GO
		

CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NOT NULL,
    Email NVARCHAR(50) UNIQUE NOT NULL,
    PhoneNumber NVARCHAR(20),
    AddressID INT NOT NULL,
    IsMember BIT NOT NULL DEFAULT 0,
	RegistrationDate DATETIME,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);
GO

INSERT INTO 
	Customer ( FirstName, LastName, Email, PhoneNumber, AddressID, IsMember, RegistrationDate)
VALUES  
	('Branco', 'Saaid', 'BrZu@gmail.com', '0713287382',7 ,1, '2024-04-12'),
	('Oskar', 'Olofsson', 'ogge@gmail,se', '072362626',8 ,1, '2024-10-30'),
	('Saman', 'Rotselleri', 'Samo@gmail.com', '0736262623',9 ,0, NULL),
	('Linus', 'Ekholm', 'Linkan@gmail.com', '072424246',10 ,1, '2024-01-11'),
	('Ottilia', 'Pettersson', 'Snurre@gmail.se', '071727272',11 ,0, NULL),
	('Anders', 'Skog', 'Skogsmullen@gmail.com', '0716262654',12 ,1, '2025-01-02'),
	('Amigo', 'Corentias', 'Amme@hotmail.com', '0725252525',13 ,1, '2024-09-07'),
	('Furkan', 'Cengiz', 'Cengo@gmail.com', '076252623',14 ,0, NULL),
	('AbdAllah', 'Kursi', 'Kurre@gmail.com', '0735252525',15 ,1, '2024-03-23'),
	('Hueng', 'Mbappe', 'Hongo@gmail.com', '076262626',16 ,0, NULL);

CREATE TABLE Campaign (
    CampaignID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignName NVARCHAR(30) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL
);
GO

INSERT INTO 
	Campaign (CampaignName, StartDate, EndDate)
VALUES 
    ('Vårkampanj 2025', '2025-04-01', '2025-05-15'),
    ('Sommarrabatt', '2025-06-01', '2025-08-31'),
    ('Höstrea', '2025-09-15', '2025-10-31');
GO

CREATE TABLE CampaignProduct (
    CampaignProductID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignID INT,
    ProductID INT,
    DiscountPercentage DECIMAL(18,2),
    FOREIGN KEY (CampaignID) REFERENCES Campaign(CampaignID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
GO

INSERT INTO
	CampaignProduct (CampaignID, ProductID, DiscountPercentage)
VALUES 
    (1, 3, 15.00),   
    (1, 1, 10.00),   
    (2, 6, 20.00),   
    (3, 8, 25.00);   
GO

CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NOT NULL,
    AddressID INT,
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(50),
    StoreID INT,
    PositionID INT,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
    FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);
GO

INSERT INTO	
	Employee (FirstName, LastName, AddressID, PhoneNumber, Email, StoreID, PositionID)
VALUES	
	('Ahmed', 'Mohamed', 27, '0731234567', 'ahmed.mohamed@email.com',1 , 2),
	('Elena', 'García', 28, '0729876543', 'elena.garcia@email.com',1 , 3),
	('Chen', 'Wei', 19, '0702345678', 'chen.wei@email.com', 2, 1),
	('Aisha', 'Hassan', 20, '0738765432', 'aisha.hassan@email.com', 2, 2),
	('Daniel', 'Andersson', 21, '0723456789', 'daniel.andersson@email.com', 3, 2),
	('Fatima', 'Rahman', 22, '0707654321', 'fatima.rahman@email.com', 3, 2),
	('Jamal', 'Omar', 23, '0732345678', 'jamal.omar@email.com', 4, 1),
	('Lucia', 'Fernandez', 24, '0725436789', 'lucia.fernandez@email.com', 4, 2),
	('Hiroshi', 'Tanaka', 25, '0709876543', 'hiroshi.tanaka@email.com', 5, 2),
	('Sofia', 'Petrov', 26, '0736547890', 'sofia.petrov@email.com', 6, 3);
GO

CREATE TABLE Warehouse (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName NVARCHAR(50) NOT NULL,
    AddressID INT,
    PhoneNumber NVARCHAR(20),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);
GO

INSERT INTO 
	Warehouse (WarehouseName, AddressID, PhoneNumber)
VALUES	
	('Drammen Lagret',17 ,'077162626'),
	('Sthlm Nord',18 ,'0110727272'),
	('Malmö Syd',29 ,'071727272'),
	('Bergen Dalen',34 ,'0318282882');
GO

CREATE TABLE Stock (
    StockID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT,
    StoreID INT,
    ProductID INT,
    QuantityInStore INT NOT NULL,
    QuantityInWarehouse INT NOT NULL,
    LastUpdated DATETIME NOT NULL,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
GO

INSERT INTO 
	Stock (WarehouseID, StoreID, ProductID, QuantityInStore, QuantityInWarehouse, LastUpdated)
VALUES	
	(1, 6, 1, 10, 20,'2025-03-28'),		
	(2, 1, 6, 14, 300,'2025-03-28'),		
	(3, 3, 10, 5, 50,'2025-03-28'),		
	(4, 4 ,4, 3, 25,'2025-03-28'),		
	(2, 1, 4, 18, 100,'2025-03-28'),		
	(3, 2, 4, 10, 30,'2025-03-28'),		
	(4, 5, 7, 9, 90,'2025-03-28'),		
	(1, 5, 8, 22, 40,'2025-03-28'),		
	(1, 6, 9, 7, 15,'2025-03-28'),		
	(2, 3, 9, 1, 0,'2025-03-28');
GO
		

CREATE TABLE StoreOrder (
    StoreOrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    StoreID INT,
    EmployeeID INT,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO

INSERT INTO
	StoreOrder (CustomerID, StoreID, EmployeeID, OrderDate, TotalAmount)
VALUES	
	(1, 4, 8, '2025-02-11', 50476),
	(4, 5, 9, '2025-01-03', 2480), 
	(3, 4, 8, '2025-03-10', 21387);
GO

CREATE TABLE StoreOrderDetail (
    StoreOrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    StoreOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(18,2) NOT NULL CHECK (UnitPrice >= 0),
    FOREIGN KEY (StoreOrderID) REFERENCES StoreOrder(StoreOrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
GO

INSERT INTO 
	StoreOrderDetail (StoreOrderID, ProductID, Quantity, UnitPrice)
VALUES 
    (1, 1, 2, 12999),  
    (1, 2, 1, 14999),   
    (1, 4, 2, 990),     
    (1, 5, 1, 7499),    
    (2, 4, 1, 990),     
    (2, 6, 1, 1490),    
	(3, 3, 1, 5799),    
    (3, 10, 2, 3499),   
    (3, 9, 1, 8590);    
GO

CREATE TABLE OnlineOrder (
    OnlineOrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ShipperID INT NOT NULL,
    ShippingAddressID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(18,2) NOT NULL CHECK (TotalAmount >= 0),
    DeliveryStatusID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ShipperID) REFERENCES Shipper(ShipperID),
    FOREIGN KEY (ShippingAddressID) REFERENCES Address(AddressID),
    FOREIGN KEY (DeliveryStatusID) REFERENCES DeliveryStatus(DeliveryStatusID)
);
GO

INSERT INTO 
	OnlineOrder (CustomerID, ShipperID, ShippingAddressID, OrderDate, TotalAmount, DeliveryStatusID)
VALUES 
    (1, 1, 7, '2025-03-01', 999, 1),
    (2, 2, 8, '2025-02-02', 1499, 2),
    (3, 1, 9, '2025-03-03', 5799, 3),
    (4, 2, 10, '2025-02-04', 3499, 4),
    (5, 1, 11, '2025-01-05', 2980, 1),
    (6, 2, 12, '2025-01-06', 12999, 2),
    (7, 1, 13, '2025-03-07', 990, 3),
    (8, 2, 14, '2025-02-08', 8590, 1),
    (9, 1, 15, '2025-01-09', 14999, 2),
    (10, 2, 16, '2025-02-10', 12999, 3);
GO

CREATE TABLE OnlineOrderDetail (
    OnlineOrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OnlineOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(18,2) NOT NULL CHECK (UnitPrice >= 0),
    FOREIGN KEY (OnlineOrderID) REFERENCES OnlineOrder(OnlineOrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
GO

INSERT INTO 
	OnlineOrderDetail (OnlineOrderID, ProductID, Quantity, UnitPrice)
VALUES 
    (1, 4, 1, 990),                     
    (2, 6, 1, 1490),                    
    (3, 3, 1, 5799),                    
    (4, 10, 1, 3499),                   
    (5, 6, 2, 1490),                    
    (6, 1, 1, 12999),                   
    (7, 4, 1, 990),                     
    (8, 9, 1, 8590),                    
    (9, 2, 1, 14999),                   
    (10, 7, 1, 12999);                  
GO

CREATE TABLE [Return] (
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    StoreOrderID INT,
    OnlineOrderID INT,
    ReturnDate DATETIME NOT NULL,
    CustomerID INT,
    TotalRefundAmount DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (StoreOrderID) REFERENCES StoreOrder(StoreOrderID),
    FOREIGN KEY (OnlineOrderID) REFERENCES OnlineOrder(OnlineOrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
GO

INSERT INTO
	[Return] (StoreOrderID, OnlineOrderID, ReturnDate, CustomerID, TotalRefundAmount)
VALUES 
    (1, NULL, '2025-02-15', 1, 13989),
    (NULL, 3, '2025-03-12', 3, 5799),
    (NULL, 5, '2025-03-13', 5, 1490),
    (2, NULL, '2025-03-15', 2, 59),
    (NULL, 8, '2025-02-18', 8, 8590);
GO

CREATE TABLE ReturnDetail (
    ReturnDetailID INT IDENTITY(1,1) PRIMARY KEY,
    ReturnID INT,
    StoreOrderDetailID INT,
    OnlineOrderDetailID INT,
    Quantity INT NOT NULL,
    ReturnReason NVARCHAR(50) NOT NULL,
    RefundAmount DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (ReturnID) REFERENCES [Return](ReturnID),
    FOREIGN KEY (StoreOrderDetailID) REFERENCES StoreOrderDetail(StoreOrderDetailID),
    FOREIGN KEY (OnlineOrderDetailID) REFERENCES OnlineOrderDetail(OnlineOrderDetailID)
);
GO

INSERT INTO 
	ReturnDetail (ReturnID, StoreOrderDetailID, OnlineOrderDetailID, Quantity, ReturnReason, RefundAmount)
VALUES 
    (1, 3, NULL, 1, 'Fick fel färg', 990),
    (1, 1, NULL, 1, 'Bytte mot annan modell', 12999),
    (2, NULL, 3, 1, 'Ej som förväntat', 5799),
    (3, NULL, 5, 1, 'Defekt vid leverans', 1490),
    (4, 4, NULL, 1, 'Köpt av misstag', 59),
    (5, NULL, 8, 1, 'För stor för utrymmet', 8590);
GO

CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    StoreOrderID INT,
    OnlineOrderID INT,
    CurrencyID INT,
    ReturnID INT,
    PaymentMethodID INT,
    PaymentStatusID INT,
    PaymentDate DATETIME,
    Amount DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (StoreOrderID) REFERENCES StoreOrder(StoreOrderID),
    FOREIGN KEY (OnlineOrderID) REFERENCES OnlineOrder(OnlineOrderID),
    FOREIGN KEY (CurrencyID) REFERENCES Currency(CurrencyID),
    FOREIGN KEY (ReturnID) REFERENCES [Return](ReturnID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID),
    FOREIGN KEY (PaymentStatusID) REFERENCES PaymentStatus(PaymentStatusID)
);
GO

INSERT INTO
	Payment (StoreOrderID, OnlineOrderID, CurrencyID, ReturnID, PaymentMethodID, PaymentStatusID, PaymentDate, Amount)
VALUES	
	(1, NULL, 1, NULL, 2, 1, '2025-02-14', 50476), 
	(1, NULL, 1, 1, 2, 1, '2025-02-16', 13989),
	(NULL, 8, 2, NULL, 3, 2, NULL, 8590),
	(NULL, 8, 2, 5, 4, 4, '2025-02-22', 8590);
GO

