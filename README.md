# WebMVC_API

# Lỗi và cách fix
	1. Data Diagram Error
		database -> properties -> file > browser sa -> ok
		
#	Bài 1: Giới thiệu tổng quan về dự án và công nghệ sử dụng 
	*	Đây là một dự án website bán hàng trực tuyến có các chức năng sau:  
			Admin quản trị sản phẩm, đơn hàng và tin bài  
			Khách hàng xem, tìm kiếm và mua sản phẩm  
			Khách hàng có thể đăng nhập và xem danh sách đơn hàng đã mua  
			Khách hàng có thể gửi liên hệ và xem thông tin công ty.  
			Có 2 view cho khách hàng và cho quản trị, quản trị yêu cầu đăng nhập còn khách hàng thì mặc định là không. 

	*	Tại sao lại là bán hàng? 
			Kiểu này không mới ai cũng làm được.
			Khóa nào cũng dạy cái này.
			Nhưng điều quan trọng:
				Nắm được cách tư duy giải quyết vấn đề.
				Khi hệ thống phình to thì quản lý ra sao?
				Tối ưu perforamance thế nào?
				Khi có issue thì làm sao?
				Khi khách muốn mở rộng chức năng thì thế nào? 
		
	*	Cấu trúc dự án 
			Dự án được xây dựng theo sự kết hợp của mô hình 3 lớp và MVC.  
			Mục đích là để có thể sử dụng lại được toàn bộ code ở phần server side.  
			Một số khái niệm:  
				Backend  
				Frontend  
				Trang admin  Trang customer 
		
			Database
			Repository
			Service
			WebAPI
			AngularJS/AspNetMVC
			
	*	Yêu cầu cài đặt 
			Microsoft SQL Server 2008 R2:  https://www.microsoft.com/en-us/download/details.aspx?id=30438
			Visual Studio 2015 Community: https://www.visualstudio.com/downloads/download-visual-studio-vs
			Node Package Manage: https://nodejs.org/en/
			Bower: http://bower.io/ 
 
	*	Công nghệ sử dụng 
			Truy xuất dữ liệu: Entity Framework  
			Resfull API: Web API  
			Hiển thị cho khách hàng: ASP.NET MVC thuần  
			Phần quản trị: AngularJS  Phần chứng thực: ASP.NET Identity 
		
	*	Tại sao dùng Entity Framework?
			Ưu điểm:   
				Hỗ trợ ảo hóa cho việc xây dựng tầng truy xuât dữ liệu, không cần biết nhiều SQL cũng không cần quản lý đóng mở kết nối  
				Truy xuất và thêm sửa xóa nhanh code ít hơn.  
				Dễ sử dụng cho người mới bắt đầu  Là sản phẩm của MS nên sẽ tương thích tốt vơi SQL Server  
			Nhược điểm:  
				Chậm khi có nhiều câu lệnh truy vấn phức tạp, đông người sử dụng  
				Khó control được câu lệnh gen ra  
			Khắc phục:  
				Kết hợp vói việc sử dụng Store procedures khi có các câu lệnh phức tạp, hiểu sâu hơn về cơ chế tối ưu hóa cho SQL Server 
	*	Định hướng công nghệ 
			Các bạn có thể sử dụng ADO.NET nếu cần tốc độ nhưng lại vất vả trong khi code và cần có kỹ năng quản lý code tốt. 
			Có thể dùng Dapper hỗ trợ bạn quản lý kết nối và mapping data. 
			Ngoài ra có thể dùng các thư viện khác. 
			Tất cả các thư viện này đều phải base trên ADO.NET Provider. Nên ADO.NET tốc độ vẫn là vô địch vì nó nằm gần SQL nhất. 

#	Bài 2 Thiết kế cơ sở dữ liệu cho dự án 
	*	Các tiêu chí để thiết kế 
			Theo chức năng dự án 
			Các bảng các cột theo yêu cầu 
			Theo yêu cầu khách hàng 
			Các tính năng theo yêu cầu khách hàng 
			Theo yêu cầu kỹ thuật 
				Có thể SEO 
				Có thể bật tắt 
				Đảm bảo toàn vẹn Có thể truy xuất dễ dàng và tối ưu 
				
	*	Một số kiến thức SQL Server cần biết 
			Khóa 
				Khóa chính 
				Khóa ngoại 
			Indexing 
				Clustered Index 
				Non Clustered Index 
			Kiểu dữ liệu null 
				Mapping sang kiểu Nullable của C# 
			Join 
	*	Các bảng dự kiến 
		-	Users 
		
		-	Roles 
		
		-	User Roles 
		
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
			
#	Bai 3 	Dựng cấu trúc solution cho dự án
	*	Các thành phần của Solution 
			Class Library  - ShopOnline.Common: Chứa các lớp tiện ích dùng chung cho dự án 
			Class Library  - ShopOnline.Model: Chứa các lớp Domain Entities của dự án 
			Class Library  - ShopOnline.Data: Chứa tầng truy cập dữ liệu sủ dụng Entity Framework Codefirst 
			Class Library  - ShopOnline.Service: Chứa các service xử lý Business logic 
			AspNetMVC-API  - ShopOnline.Web: Project chính dùng để hiển thị giao diện và tương tác người dùng. 
			Class UnitTest - ShopOnline.UnitTest: Chứa các class Text sử dụng cho việc Unit Test 
		
		REFERENCES:
			Web : Trừ unit test
			Data: Common
			Unit Test: All
			Service: Common, data, model
			
			
	*	Các package cần cài đặt  
			- ShopOnline.Common 
			- ShopOnlineShop.Model 
				Entity Framework 
				Microsoft.AspNet.Identity.Core 
				Microsoft.AspNet.Identity.EntityFramework 
			- ShopOnline.Data 
				Entity Framework 
			- ShopOnlineShop.Service 
			- ShopOnlineShop.Web 
				Autofac, 
				AutoMapper, 
				Entity Framework... 
			- ShopOnlineShop.UnitTest 
				Moq, 
				Entity Framwork 
	
	*	Các bước thực hiện 
			Cài đặt git client lên máy cài đặt Git Extension lên Visual Studio 
			Tạo tài khoản Git 
			Tạo repository 
			Cài đặt source tree để quản lý qua giao diện 
			Check out code 
			Commit và push code 
			Tách nhánh code 