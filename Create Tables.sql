USE ElGiganto26
GO

CREATE TABLE [Products] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [ArticleID] varchar(10),
  [Name] varchar(50),
  [Info] varchar(MAX),
  [Price] int,
  [Size] varchar(10),
  [Colour] varchar(50),
  [Popularity] int DEFAULT (0),
  [InStock] bit DEFAULT (0)
)
GO

Create Table Brands(
	ID int Primary Key Identity (1, 1),
	BrandName varchar (50)
	)
GO

CREATE TABLE [Product_Category] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [Product_ID] int,
  [Category_ID] int
)
GO

CREATE TABLE [Categories] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [Category] nvarchar(255)
)
GO

CREATE TABLE [Cart] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [CustomerID] int,
  [ProductID] int,
  [ProductName] varchar(50),
  [Price] int,
  [Colour] varchar(50),
  [Size] varchar(10),
  [Quantity] int
)
GO

CREATE TABLE [Customer] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [FirstName] varchar(50),
  [LastName] varchar(50),
  [Adress] varchar(MAX),
  [PhoneNumber] varchar(20),
  [Email] varchar(30)
)
GO

CREATE TABLE [OrderLines] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [OrderID] int,
  [ProductID] int,
  [Size] varchar(10),
  [Colour] varchar(25),
  [Price] int,
  [Quantity] int
)
GO

CREATE TABLE [Orders] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [CustomerID] int,
  [Date] Date DEFAULT(GETDATE()),
  [Processed] bit DEFAULT (0)
)
GO


CREATE TABLE [StockTransaction] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [ProductID] int,
  [Date] Date DEFAULT(GETDATE()),
  [MarkID] int,
  [Quantity] int
)
GO

CREATE TABLE [Mark] (
  [ID] int PRIMARY KEY IDENTITY(1, 1),
  [Mark] varchar(30)
)
GO

Alter Table Products
	add BrandID int
GO

Alter table OrderLines
	Add Returned int default 0
GO

alter table products add foreign key (brandid) references brands (id)
GO

ALTER TABLE [StockTransaction] ADD FOREIGN KEY ([MarkID]) REFERENCES [Mark] ([ID])
GO

ALTER TABLE [StockTransaction] ADD FOREIGN KEY ([ProductID]) REFERENCES [Products] ([ID])
GO

ALTER TABLE [OrderLines] ADD FOREIGN KEY ([ProductID]) REFERENCES [Products] ([ID])
GO

ALTER TABLE [OrderLines] ADD FOREIGN KEY ([OrderID]) REFERENCES [Orders] ([ID])
GO

ALTER TABLE [Orders] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([ID])
GO

ALTER TABLE [Product_Category] ADD FOREIGN KEY ([Product_ID]) REFERENCES [Products] ([ID])
GO

ALTER TABLE [Product_Category] ADD FOREIGN KEY ([Category_ID]) REFERENCES [Categories] ([ID])
GO

ALTER TABLE [Cart] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([ID])
GO

ALTER TABLE [Cart] ADD FOREIGN KEY ([ProductID]) REFERENCES [Products] ([ID])
GO

Alter Table Cart
Drop Column ProductName
GO

Alter Table Cart
Drop Column Price
GO

Alter Table Cart
Drop Column Colour
GO

Alter Table Cart
Drop Column Size
GO

