create database SecondTask;

use SecondTask;

create schema Orders;

create table Orders.City
(
    CityId INT IDENTITY PRIMARY KEY,
    Name   VARCHAR(100) NOT NULL
);

CREATE TABLE Orders.Address
(
    AddressId INT IDENTITY PRIMARY KEY,
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
    ProductName VARCHAR(100) NOT NULL,
    ProductPrice MONEY NOT NULL
);

CREATE TABLE Orders.OrderDetails
(
    OrderId INT IDENTITY  PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerId INT NOT NULL,
    AddressId INT NOT NULL,
    Total MONEY NOT NULL,

    FOREIGN KEY (CustomerId) REFERENCES Orders.Customers(CustomerId),
    FOREIGN KEY (AddressId) REFERENCES  Orders.Address(AddressId),
);

CREATE TABLE Orders.Quantity
(
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderId, ProductId),
    FOREIGN KEY (OrderId) REFERENCES  Orders.OrderDetails(OrderId),
    FOREIGN KEY (ProductId) REFERENCES Orders.Products(ProductId)
)