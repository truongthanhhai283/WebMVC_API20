Create Database ShopOnlineDB
Go

Use ShopOnlineDB
Go

Create table ProductCategories
(
	ID int primary key,
	Name nvarchar(250) not null,
	Alias varchar(250) not null,
	ParentID int,
	Description nvarchar(500),
	Image nvarchar(250),
	DisplayOrder int, 
	MetaKeyWord nvarchar(250),
	MetaDescription nvarchar(250),
	CreatedDate DateTime,
	CreatedBy varchar(50),
	UpdateDate DateTime,
	UpdateBy varchar(50),
	Status bit not null,
	HomeFlag bit not null,
)	
Go

Create table Products
(
	ID int PRIMARY KEY,
	Name nvarchar(250) not null,
	Alias varchar(250) not null,
	CategoryID int FOREIGN KEY (CategoryID) REFERENCES ProductCategories(ID),
	Image nvarchar(500),	
	MoreImage nvarchar(250),
	Price Decimal(18,2),
	Promotion Decimal(18,2),
	Warranty int,
	Description nvarchar(500),
	Content nvarchar(Max),		
	MetaKeyWord nvarchar(250),
	MetaDescription nvarchar(250),
	CreatedDate DateTime,
	CreatedBy varchar(50),
	UpdatedDate DateTime,
	UpdatedBy varchar(50),
	Status bit not null,
	HomeFlag bit,
	HotFlag bit,
	ViewCount int
)
Go

Create Table PostCategories
(
	ID int primary key,
	Name nvarchar(250) not null,
	Alias varchar(250) not null,
	Description nvarchar(500),
	Image nvarchar(250),
	DisplayOrder int,
	MetaKeyWord nvarchar(250),
	MetaDescription nvarchar(250),
	CreatedDate DateTime,
	CreatedBy varchar(50),
	UpdatedDate DateTime,
	UpdatedBy varchar(50),
	Status bit not null,
	HomeFlag bit
)
Go

create table Posts
(
	ID int PRIMARY KEY,
	Name nvarchar(250) not null,
	Alias varchar(250) not null,
	CategoryID int FOREIGN KEY (CategoryID) REFERENCES PostCategories(ID),
	Image nvarchar(250),		
	Description nvarchar(500),
	Content nvarchar(Max),		
	MetaKeyWord nvarchar(250),
	MetaDescription nvarchar(250),
	CreatedDate DateTime,
	CreatedBy varchar(50),
	UpdateDate DateTime,
	UpdateBy varchar(50),
	Status bit not null,
	HomeFlag bit,
	HotFlag bit,
	ViewCount int
)
Go

Create Table Tags
(
	ID varchar(50) primary key,
	Name nvarchar(50),
	Type varchar(50),
)
Go

Create table ProductTags
(
	ProductID int FOREIGN KEY (ProductID) REFERENCES Products(ID), 
	TagID varchar(50) FOREIGN KEY (TagID) REFERENCES Tags(ID),

)
Go

Create table PostTags
(
	PostID int FOREIGN KEY (PostID) REFERENCES Posts(ID), 
	TagID varchar(50) FOREIGN KEY (TagID) REFERENCES Tags(ID),
)
Go

Create table Orders
(
	ID int primary key,
	CustomerName nvarchar(250),
	CustomerAddress nvarchar(250),	
	CustomerEmail varchar(100),	
	CustomerMobile varchar(30),
	CustomerMessage nvarchar(max),	
	CreatedDate Datetime,
	CreatedBy varchar(50),
	PaymentMethod nvarchar(250),
	PaymentStatus nvarchar(50),
	Status bit
)
Go

Create table OrderDetails
(
	OrderID int foreign key (OrderID) references Orders(ID),
	ProductID int foreign key (ProductID) references ProductCategories(ID),
	Quantity int
)
Go

Create table MenuGroups
(
	ID int primary key,
	Name nvarchar(500),
)
Go

Create table Menus
(
	ID int IDENTITY(1,1) primary key,
	Name nvarchar(500),
	URL nvarchar(500),
	DisplayOrder int, --Thứ tự hiển thị
	GroupID int foreign key (GroupID) references MenuGroups(ID),
	Target nvarchar(10), ---Sell or new windows
	Status bit
)
Go

Create table Slides
(
	ID int primary key,
	Name nvarchar(50) not null,
	Description nvarchar(500),
	Image nvarchar(500) not null,
	URL nvarchar(500) not null,
	DisplayOrder int,
	Status bit not null
)
Go

Create table Footers
(
	ID varchar(50) primary key,
	Content nvarchar(max),
)
Go

Create table Pages
(
	ID int primary key,
	Name nvarchar(250),
	Content nvarchar(max),
	MetaKeyWord nvarchar(250),
	MetaDescription nvarchar(250),
	Status bit
)
Go

Create table SupportOnlines
(
	ID int primary key,
	Name nvarchar(50),
	Department nvarchar(250),
	Skype nvarchar(250),
	Mobile varchar(50),
	Email varchar(50),
	Facebook varchar(250),
	Status bit
)
Go

Create table SystemConfigs
(
	ID int primary key,
	Code varchar(50),
	ValueString nvarchar(250),
	ValueInt nvarchar(250),
)
Go

Create table VisitorStatictis
(
	ID int IDENTITY(1,1) primary key,
	VisitedDate Datetime not null,
	IPAddress varchar(50) not null
)