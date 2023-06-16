create database SecondTask;

use SecondTask;

create schema Orders;

create table Orders.City
(
    CityId INT IDENTITY PRIMARY KEY,
    Name   VARCHAR(100) NOT NULL
);

CREATE TABLE Orders.ShopDetails
(
    ShopId INT IDENTITY PRIMARY KEY,
    CityId INT NOT NULL,
    Location VARCHAR(200) NOT NULL,
    FOREIGN KEY (CityId) REFERENCES Orders.City(CityId)
);

CREATE TABLE Orders.Customers
(
    CustomerId INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(200) NOT NULL,
    Gender nchar(1) NOT NULL,
    CONSTRAINT chk_gender CHECK (Gender IN ('M', 'F'))
);

CREATE TABLE Orders.Products
(
    ProductId INT IDENTITY PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL
);

CREATE TABLE Orders.OrderDetails
(
    OrderId INT IDENTITY  PRIMARY KEY,
    ProductId INT NOT NULL,
    ShopId INT NOT NULL,
    Quantity INT NOT NULL,
    Price MONEY NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Orders.Products(ProductId),
    FOREIGN KEY (ShopId) REFERENCES  Orders.ShopDetails(ShopId),
);

CREATE TABLE Orders.CustomerPurchase
(
    PurchaseId INT IDENTITY  PRIMARY KEY,
    CustomerId INT NOT NULL,
    OrderId INT NOT NULL,
    TotalSum MONEY NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES  Orders.Customers(CustomerId),
    FOREIGN KEY (OrderId) REFERENCES Orders.OrderDetails(OrderId)
)