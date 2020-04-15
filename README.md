# WebMVC_API

# Lỗi và cách fix
	1. Data Diagram Error
		database -> properties -> file > browser sa -> ok
	2. The property 'Status' is not a String or Byte array. Length can only be configured for String and Byte array properties.
		fix: xóa maxlangth 
	3. Unable to determine composite primary key ordering for type: 2 key trong 1 bảng
		fix [Column(Order =1)]/[Column(Order =2)]
		
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
			
#	Bài 3 	Dựng cấu trúc solution cho dự án
	*	Các thành phần của Solution 
			Class Library  - ShopOnline.Common: Chứa các lớp tiện ích dùng chung cho dự án 
			Class Library  - ShopOnline.Model: Chứa các lớp Domain Entities của dự án 
			Class Library  - ShopOnline.Data: Chứa tầng truy cập dữ liệu sủ dụng Entity Framework Codefirst 
			Class Library  - ShopOnline.Service: Chứa các service xử lý Business logic 
			AspNetMVC-API  - ShopOnline.Web: Project chính dùng để hiển thị giao diện và tương tác người dùng. 
			Class UnitTest - ShopOnline.UnitTest: Chứa các class Text sử dụng cho việc Unit Test 
		
		REFERENCES:
			Web : Trừ unit test
			Data: Common, model
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
#	Bài 4: Cách sử dụng Git để quản lý Source code trong dự án thực tế 
	Giới thiệu về Git 
		Git là một hệ thống quản lý version được sử dụng rộng rãi trong ngành phát triển phần mềm. 		
		Được phát triển năm 2005 bởi Linus Torvalds 
		Có nhiều ưu điểm so với các Source control management (SCM) khác như SVN hay TFS. 
	
	Một số dịch vụ Git Server: 
			Github 
			Bitbucket 
			GitLab 
	Dịch vụ 
		Các bạn có thể dùng một trong 2 dịch vụ free sau đây để lưu trữ source code sử dụng Git để quản lý: Github: Project được lưu miễn phí nhưng phải ở chế độ public còn nếu private phải nâng cấp lên gói Micro giá là 7USD/tháng. 
		Bitbucket: Được sử dụng chế độ private free nhưng giới hạn member là 5. Thao tác với Git thông qua Source Tree của Atlassian Có thể dùng lệnh nếu cần thiết. 
	
	Các bước thực hiện 
	1. Cài đặt git client lên máy cài đặt Git Extension lên Visual Studio 
	2. Tạo tài khoản Git 
	3. Tạo repository 
	4. Cài đặt source tree để quản lý qua giao diện 
	5. Check out code 
	6. Commit và push code 
	7. Tách nhánh code 

#	Bài 5: Dựng phần Domain Entities cho dự án 
	*	Tổng quan bài học 
			Tạo ra danh sách các class tương ứng với danh sách các bảng cần tạo trong SQL Server 
			Sử dụng các attribute có sẵn trong namespace: 
				using System.ComponentModel.DataAnnotations; 
				using System.ComponentModel.DataAnnotations.Schema; 
				Sau khi migration sẽ generate ra database theo cấu trúc class. Đó chính là codefirst. 
	
	*	Thực hiện:
		- ShopOnline.model 
			Tạo folder Models & Abstract
			+ Models: Tạo class tương ứng với các table trong SQL
			+ Abstract: 
				Tạo các class triển khai interface cho các thành phần dùng chung
				+ Auditable
				+ IAuditable

#	Bai 6 Xay dung tang Data Access Layer voi Entity Framwork CodeFirst
	*	Tổng quan bài học 
	*	Một số lưu ý ở bài trước về tạo model cho entity framework 
			Chú ý đặt thuộc tính hợp lý cho primary key, foreign key. 
			Đặt độ dài cho các trường là string nếu không mặc định sẽ là nvachar(max) 
			Hoàn thành việc tạo entity cho các bảng còn lại. 
			Commit code lên Git 
			Tách nhánh sang bài 6 
	*	Dựng tầng data ở project ShopOnline.Data với việc sử dụng Repository, Unit Of Work và Factory 
	*	Cách Migration project C# vào database SQL Server 
	----------------------------------------------------------------
	
	*	ShopOnline.Data: Hạ tầng
		UnitOfWork: Đảm bảo có nhiều thao tác trên cùng 1 giao dịch, đảm bảo sự toàn vẹn giữa nhiều thao tác
			chỉ đảm bảo 1 connection. Đảm dảo toàn vẹn
		Repository: lớp ảo hóa, nằm giữa phần truy cập dữ liệu DB và business. Giúp tối ưu câu lệnh logic
		chung: thêm/sửa/xóa -> Không cần viết lại -> Giảm lượng code, dễ bảo trì, quản lý soure code dễ dàng
	
		
	* 	Thực hiện:
	ShopOnline.Data: 
		- Tạo 2 folder Repositories(chuyên chứa repository) & Infrastructure(Truy cập dữ liệu và model)
		- Infrastructure:
			Tạo 3 interface: IRepository & IDbFactory & IUnitOfWork: Định nghĩa các giao tiếp cho các class
			Cho public vào tất cả các interface
			
			+ IUnitOfWork: 
					void Commit();
					
				
			+ IDbFactory:IDisposable Giao tiếp để khởi tạo đói tượng trong entity
				public interface IDbFactory:IDisposable
				{
					//Init dbcontext
					 ShopOnlineDbContext Init();
				}
				
			+ IRepository: định nghĩa các p/thức có sẵn
					public interface IRepository<T> where T : class
					{
						// Marks an entity as new
						void Add(T entity);

						// Marks an entity as modified
						void Update(T entity);

						// Marks an entity to be removed
						void Delete(T entity);

						void Delete(int id);
						//Delete multi records
						void DeleteMulti(Expression<Func<T, bool>> where);

						// Get an entity by int id
						T GetSingleById(int id);

						T GetSingleByCondition(Expression<Func<T, bool>> expression, string[] includes = null);

						IQueryable<T> GetAll(string[] includes = null);

						IQueryable<T> GetMulti(Expression<Func<T, bool>> predicate, string[] includes = null);

						IQueryable<T> GetMultiPaging(Expression<Func<T, bool>> filter, out int total, int index = 0, int size = 50, string[] includes = null);

						int Count(Expression<Func<T, bool>> where);

						bool CheckContains(Expression<Func<T, bool>> predicate);
					}
					
			
			+ Tạo class Disposable : IDisposable
				public class Disposable : IDisposable
				{
					//Cài đặt các phương thức tự động hủy
					private bool isDisposed;

					~Disposable()
					{
						Dispose(false);
					}

					public void Dispose()
					{
						Dispose(true);
						GC.SuppressFinalize(this);
					}
					private void Dispose(bool disposing)
					{
						if (!isDisposed && disposing)
						{
							DisposeCore();
						}

						isDisposed = true;
					}

					// Ovveride this to dispose custom objects
					protected virtual void DisposeCore()
					{
					}
				}
				
			+ Tạo public class DbFactory : Disposable, IDbFactory
				{
					private ShopOnlineDbContext dbContext;

					public ShopOnlineDbContext Init()
					{
						return dbContext ?? (dbContext = new ShopOnlineDbContext());
					}


					protected override void DisposeCore()
					{
						if (dbContext != null)
							dbContext.Dispose();
					}
				}
				
			+ Tạo public class UnitOfWork : IUnitOfWork
				{
					private readonly IDbFactory dbFactory;
					private ShopOnlineDbContext dbContext;

					public UnitOfWork(IDbFactory dbFactory)
					{
						this.dbFactory = dbFactory;
					}

					public ShopOnlineDbContext DbContext
					{
						get { return dbContext ?? (dbContext = dbFactory.Init()); }
					}

					public void Commit()
					{
						DbContext.SaveChanges();
					}

				}
				
				
			Thực thi các class đã định nghĩa trong IRepository
			+  Tạo public abstract class RepositoryBase<T> where T : class
				{
					#region Properties
					private ShopOnlineDbContext dataContext;
					private readonly IDbSet<T> dbSet;

					protected IDbFactory DbFactory
					{
						get;
						private set;
					}

					protected ShopOnlineDbContext DbContext
					{
						get { return dataContext ?? (dataContext = DbFactory.Init()); }
					}
					#endregion

					protected RepositoryBase(IDbFactory dbFactory)
					{
						DbFactory = dbFactory;
						dbSet = DbContext.Set<T>();
					}

					#region Implementation
					public virtual void Add(T entity)
					{
						dbSet.Add(entity);
					}

					public virtual void Update(T entity)
					{
						dbSet.Attach(entity);
						dataContext.Entry(entity).State = EntityState.Modified;
					}

					public virtual void Delete(T entity)
					{
						dbSet.Remove(entity);
					}

					public virtual void DeleteMulti(Expression<Func<T, bool>> where)
					{
						IEnumerable<T> objects = dbSet.Where<T>(where).AsEnumerable();
						foreach (T obj in objects)
							dbSet.Remove(obj);
					}

					public virtual T GetSingleById(int id)
					{
						return dbSet.Find(id);
					}

					public virtual IEnumerable<T> GetMany(Expression<Func<T, bool>> where, string includes)
					{
						return dbSet.Where(where).ToList();
					}


					public virtual int Count(Expression<Func<T, bool>> where)
					{
						return dbSet.Count(where);
					}

					public IQueryable<T> GetAll(string[] includes = null)
					{
						//HANDLE INCLUDES FOR ASSOCIATED OBJECTS IF APPLICABLE
						if (includes != null && includes.Count() > 0)
						{
							var query = dataContext.Set<T>().Include(includes.First());
							foreach (var include in includes.Skip(1))
								query = query.Include(include);
							return query.AsQueryable();
						}

						return dataContext.Set<T>().AsQueryable();
					}

					public T GetSingleByCondition(Expression<Func<T, bool>> expression, string[] includes = null)
					{
						return GetAll(includes).FirstOrDefault(expression);
					}

					public virtual IQueryable<T> GetMulti(Expression<Func<T, bool>> predicate, string[] includes = null)
					{
						//HANDLE INCLUDES FOR ASSOCIATED OBJECTS IF APPLICABLE
						if (includes != null && includes.Count() > 0)
						{
							var query = dataContext.Set<T>().Include(includes.First());
							foreach (var include in includes.Skip(1))
								query = query.Include(include);
							return query.Where<T>(predicate).AsQueryable<T>();
						}

						return dataContext.Set<T>().Where<T>(predicate).AsQueryable<T>();
					}

					public virtual IQueryable<T> GetMultiPaging(Expression<Func<T, bool>> predicate, out int total, int index = 0, int size = 20, string[] includes = null)
					{
						int skipCount = index * size;
						IQueryable<T> _resetSet;

						//HANDLE INCLUDES FOR ASSOCIATED OBJECTS IF APPLICABLE
						if (includes != null && includes.Count() > 0)
						{
							var query = dataContext.Set<T>().Include(includes.First());
							foreach (var include in includes.Skip(1))
								query = query.Include(include);
							_resetSet = predicate != null ? query.Where<T>(predicate).AsQueryable() : query.AsQueryable();
						}
						else
						{
							_resetSet = predicate != null ? dataContext.Set<T>().Where<T>(predicate).AsQueryable() : dataContext.Set<T>().AsQueryable();
						}

						_resetSet = skipCount == 0 ? _resetSet.Take(size) : _resetSet.Skip(skipCount).Take(size);
						total = _resetSet.Count();
						return _resetSet.AsQueryable();
					}

					public bool CheckContains(Expression<Func<T, bool>> predicate)
					{
						return dataContext.Set<T>().Count<T>(predicate) > 0;
					}
					#endregion
				}
				
				
		+ Tạo class public DBContext: DBContext 
				  public ShopOnlineDbContext():base("ShopOnline") //ShopOnline: key của connection
				  {
						//Load 1 bẳng cha thì không tự động include thêm bảng con
						this.Configuration.LazyLoadingEnabled = false;
				  }
				  
				   //Set DbSet cho tất cả các bảng có trong Database
				   public DbSet<Footer> Footers { set; get; }
				   ...
				   
				   //Ghi đè p/thức dbcontext, sẽ chạy khi khởi tạo entity framework
					protected override void OnModelCreating(DbModelBuilder builder)
					{

					}
			
		+ Add connectstring App.config
		  <connectionStrings>
			<clear/>
			<add name="ShopOnlineConnection" connectionString="Data Source=.;Initial Catalog=ShopOnline;Integrated Security=True; MultipleActiveResultSets=True"/>
		  </connectionStrings>
		  
			MultipleActiveResultSets: cho phép thực thi nhiều get trong cùng 1 connection đơn lẻ
			Integrated Security=True: Không sử dụng authen của windows
			
#	Bài 7: Triển khai Repository Pattern và Generate ra cơ sở dữ liệu SQL Server từ Code First 
	* 	Hoàn thành các repository và fix lỗi 
	* 	Hoàn thành các lớp repository trong hệ thống 
	* 	Migration database vào SQL 
	* 	Một số lỗi thường gặp 
			Chỉ định khóa chính cho 2 trường phải có thuộc tính [Column] 
			Đặt MaxLength cho trường status bool 
			Thiếu Connection string trong web.config vì nó nhận ở project web 
			Kiểu dữ liệu của 2 cột reference phải cùng kiểu 
			Thiếu provider name trong connection string 
	----------------------------------------------------------------------
	ShopOnline.Data
		Repositories
			+ Tạo class ..Repository: 
				 public interface IProductCategoryRepository
					{
						//Định nghĩa các phương thức để sử dụng thêm 
						IEnumerable<ProductCategory> GetByAlias(string alias);
					}

					public class ProductCategoryRepository : RepositoryBase<ProductCategory>, IProductCategoryRepository
					{
						//Truyền vào dbfactory -> RepositoryBase phương thức phải có dbfactory truyền vào
						public ProductCategoryRepository(IDbFactory dbFactory)
							: base(dbFactory)
						{
						}

						public IEnumerable<ProductCategory> GetByAlias(string alias)
						{
							return this.DbContext.ProductCategories.Where(x => x.Alias == alias);
						}
					}
	* 	migration DB
			console.packagemanaget - > default -> shoponline.data
			enable-migrations
			add-migration initial
			update-database
			
		Lỗi khi update-database: thiếu providerName="system.Data.sqlClient"
	
#	Bài 8: Dựng tầng Service để xử lý logic 
	Nội dung bài học 
	* 	Tại sao không gọi luôn repository luôn trong Controller hoặc ApiController mà lại đi qua servcie? 
			Tầng servcie thực thi nhiệm vụ xử lý logic
			Tầng repository thực thi các câu lệnh common : thêm/sửa/xóa
			Tạo tầng service gọi đến nhiều repository khác nhau -> độc lập module nghiệp vụ vào service
			Giúp API chỉ gọi tập trung ở service
		
	* 	Tác dụng của nó là gì? 
	* 	Cách triển khai nó ra sao? 
	* 	Nguyên tắc SOLID 
		Single responsibility principle: Mỗi class chỉ nên giữ một trách nhiệm duy nhất (mô tả riêng lẻ giữa các tác vụ)
		Open/closed principle: Open với extend và close với modify (
		Liskov substitution principle: Các object của class con có thể thay thế class cha mà không làm thay đổi tính đúng đắn 
		Interface segregation principle: Tách interface lớn thành nhiều interface nhỏ 
		Dependency inversion principle: Giảm sự phụ thuộc giữa các module, module cấp cao không phụ thuộc module cấp thấp, phải cùng phụ thuộc vào abstraction. 
	-----------------------------------------------------------------------------
	Tạo .repository còn lại
	Tầng ShopOnline.Service
	+	Tạo class PostsService
		 //Triển khai: Khai báo interface
		public interface IPostService
		{
			void Add(Post post);

			void Update(Post post);

			void Delete(int id);

			IEnumerable<Post> GetAll();

			//Lấy all trang
			IEnumerable<Post> GetAllPaging(int page, int pageSize, out int totalRow);

			//Lấy ra 1 bản ghi
			Post GetById(int id);

			//Lấy ra theo tag
			IEnumerable<Post> GetAllByTagPaging(string tag, int page, int pageSize, out int totalRow);

			void SaveChanges();
		}
		public class PostService : IPostService
		{
			//Các repository cần gọi 
			IPostRepository _postRepository;
			IUnitOfWork _unitOfWork;

			public PostService(IPostRepository postRepository, IUnitOfWork unitOfWork)
			{
				this._postRepository = postRepository;
				this._unitOfWork = unitOfWork;
			}

			public void Add(Post post)
			{
				_postRepository.Add(post);
			}

			public void Delete(int id)
			{
				_postRepository.Delete(id);
			}

			//Select được post và category
			public IEnumerable<Post> GetAll()
			{
				return _postRepository.GetAll(new string[] { "PostCategory" });
			}

			public IEnumerable<Post> GetAllByTagPaging(string tag, int page, int pageSize, out int totalRow)
			{
				//TODO: Select all post by tag
				return _postRepository.GetMultiPaging(x => x.Status, out totalRow, page, pageSize);

			}

			public IEnumerable<Post> GetAllPaging(int page, int pageSize, out int totalRow)
			{
				return _postRepository.GetMultiPaging(x => x.Status, out totalRow, page, pageSize);
			}

			public Post GetById(int id)
			{
				return _postRepository.GetSingleById(id);
			}

			public void SaveChanges()
			{
				_unitOfWork.Commit();
			}

			public void Update(Post post)
			{
				_postRepository.Update(post);
			}
	
	+ 	Edit trong IRepository
			//Delete 1 record
			void Delete(int id);
	
	+ 	Triển khai lại trong RepositoryBase
			public virtual void Delete(int id)
			{
				var entity = dbSet.Find(id);
				dbSet.Remove(entity);
			}
		
	+ 	Edit models post
		    public virtual IEnumerable<PostTag> PostTags { set; get; }

#	Bài 9: Hoàn thiện tầng Service và viết custom method ngoài Repository 
	+ 	Tạo class PostCategoryService
		public interface IPostCategoryService
		{
			void Add(PostCategory postCategory);

			void Update(PostCategory postCategory);

			void Delete(int id);

			IEnumerable<PostCategory> GetAll();

			IEnumerable<PostCategory> GetAllByParentId(int parentId);

			PostCategory GetById(int id);
		}

		public class PostCategoryService : IPostCategoryService
		{
			private IPostCategoryRepository _postCategoryRepository;
			private IUnitOfWork _unitOfWork;

			public PostCategoryService(IPostCategoryRepository postCategoryRepository, IUnitOfWork unitOfWork)
			{
				this._postCategoryRepository = postCategoryRepository;
				this._unitOfWork = unitOfWork;
			}

			public void Add(PostCategory postCategory)
			{
				_postCategoryRepository.Add(postCategory);
			}

			public void Delete(int id)
			{
				_postCategoryRepository.Delete(id);
			}

			public IEnumerable<PostCategory> GetAll()
			{
				return _postCategoryRepository.GetAll();
			}

			public IEnumerable<PostCategory> GetAllByParentId(int parentId)
			{
				return _postCategoryRepository.GetMulti(x => x.Status && x.ParentID == parentId);
			}

			public PostCategory GetById(int id)
			{
				return _postCategoryRepository.GetSingleById(id);
			}

			public void Update(PostCategory postCategory)
			{
				_postCategoryRepository.Update(postCategory);
			}
	
	+	Tạo class PostServices
		//Triển khai: Khai báo interface
		public interface IPostService
		{
			void Add(Post post);

			void Update(Post post);

			void Delete(int id);

			IEnumerable<Post> GetAll();

			//Lấy all trang
			IEnumerable<Post> GetAllPaging(int page, int pageSize, out int totalRow);

			//Lấy ra 1 bản ghi
			Post GetById(int id);

			//Lấy ra theo tag
			IEnumerable<Post> GetAllByTagPaging(string tag, int page, int pageSize, out int totalRow);

			void SaveChanges();
		}
		public class PostService : IPostService
		{
			//Các repository cần gọi 
			IPostRepository _postRepository;
			IUnitOfWork _unitOfWork;

			public PostService(IPostRepository postRepository, IUnitOfWork unitOfWork)
			{
				this._postRepository = postRepository;
				this._unitOfWork = unitOfWork;
			}

			public void Add(Post post)
			{
				_postRepository.Add(post);
			}

			public void Delete(int id)
			{
				_postRepository.Delete(id);
			}

			//Select được post và category
			public IEnumerable<Post> GetAll()
			{
				return _postRepository.GetAll(new string[] { "PostCategory" });
			}

			public IEnumerable<Post> GetAllByTagPaging(string tag, int page, int pageSize, out int totalRow)
			{
				//TODO: Select all post by tag
				return _postRepository.GetMultiPaging(x => x.Status, out totalRow, page, pageSize);
			}

			public IEnumerable<Post> GetAllPaging(int page, int pageSize, out int totalRow)
			{
				return _postRepository.GetMultiPaging(x => x.Status, out totalRow, page, pageSize);
			}

			public Post GetById(int id)
			{
				return _postRepository.GetSingleById(id);
			}

			public void SaveChanges()
			{
				_unitOfWork.Commit();
			}

			public void Update(Post post)
			{
				_postRepository.Update(post);
			}
		}
		
#	Bài 10: Unit testing cho Repository và service 
	*	Nội dung bài học 
			Giới thiệu về Unit test 
			Lợi ích của việc sử dụng Unit test 
			Cách tạo Test Project và viết Unit Test method 
			
	*	Giới thiệu về Unit Test 
		+	Là một kỹ thuật quan trọng (UT) giúp nâng cao chất lượng phần mềm ngay từ những dòng code và chức năng nhỏ nhất được làm bởi chính dev. 
		+	Kiểm thử những đơn vị code nhỏ nhất như phương thức hay class. 
		+	Mỗi test case sẽ có một giá trị trả về thực tế và giá trị mong đợi, case được pass khi hai giá trị bằng nhau. 
		+	Đối với một số chức năng chúng ta cần dùng đối tượng ảo để test gọi là  Mock Object. 
		+	Trong phát triển phần mềm hiện đại có mô hình TDD (Test driven development) 
		+	Tromg Visual Studio có sẵn thư viện gọi là MS Unit Test, ngoài ra một thư viện nổi tiếng khác là Nunit. 
	*	Lợi ích của việc sử dụng Unit Test 
			Kiểm thử phần mềm ngay từ những đơn vị nhỏ có thể loại bỏ được các lỗi tiềm tàng của hệ thống. 
			Giảm thời gian phát triển và fix lỗi khi làm việc vì loại bỏ tối đa được các lỗi không đáng có.
			Có thể sử dụng lại test case đã viết và phục vục ho việc test lại các chức năng sau khi sửa lại có còn đúng đắn mà không mất công test lại nhiều. 
	----------------------------------------------------------------
	ShopOnline.UnitTest
		Install nuget moq,EF
		Copy chuỗi connectionString từ ShopOnline.Data -> ShopOnline.unitTesst
		
	- 	Tạo 2 thư mục ServiceTest & RepositoryTest
		RepositoryTest
		+ Tạo class PostCategoryRepositoryTest
			[TestClass]
			public class PostCategoryRepositoryTest
			{
				IDbFactory dbFactory;
				IPostCategoryRepository objRepository;
				IUnitOfWork unitOfWork;

				//Initialize: Chạy đầu tiên để thiết lập tham số: Chạy xong sẽ tạo ra 3 đối tượng
				[TestInitialize]
				public void Initialize()
				{
					dbFactory = new DbFactory();

					//Truyền vào DBfactory
					objRepository = new PostCategoryRepository(dbFactory);
					unitOfWork = new UnitOfWork(dbFactory);
				}

				[TestMethod]
				public void PostCategory_Repository_GetAll()
				{
					var list = objRepository.GetAll().ToList();
					Assert.AreEqual(3, list.Count);
				}

				[TestMethod]
				public void PostCategory_Repository_Create()
				{
					PostCategory category = new PostCategory();

					//Gán cho các trường not null
					category.Name = "Test category";
					category.Alias = "Test-category";
					category.Status = true;

					var result = objRepository.Add(category);
					unitOfWork.Commit();

					//Assert: Giá trị muốn so sánh giữa 2 đối tượng 
					Assert.IsNotNull(result);
					Assert.AreEqual(3, result.ID);
				}

			}
			
		+ Edit class IPostRepository :
			T Add(T entity);
			T Delete(T entity);
			T Delete(int id);
			
			IEnumerable<T> GetAll(string[] includes = null);
			IEnumerable<T> GetMulti(Expression<Func<T, bool>> predicate, string[] includes = null);
			IEnumerable<T> GetMultiPaging(Expression<Func<T, bool>> filter, out int total, int index = 0, int size = 50, string[] includes = null);
		
		+ Edit RepositoryBase:
	
			public virtual T Add(T entity)
			{
				dbSet.Add(entity);
				return dbSet.Add(entity);
			}

			public virtual T Delete(T entity)
			{				
				return dbSet.Remove(entity);
			}
			
			public virtual T Delete(int id)
			{
				var entity = dbSet.Find(id);
				
				return dbSet.Remove(entity);
			}
			
			
			public IEnumerable<T> GetAll(string[] includes = null)
			
			public T GetSingleByCondition(Expression<Func<T, bool>> expression, string[] includes = null)
			{				
				if (includes != null && includes.Count() > 0)
				{
					var query = dataContext.Set<T>().Include(includes.First());
					foreach (var include in includes.Skip(1))
						query = query.Include(include);
					return query.FirstOrDefault(expression);
				}
				return dataContext.Set<T>().FirstOrDefault(expression);
			}
			
			 
			public virtual IEnumerable<T> GetMulti(Expression<Func<T, bool>> predicate, string[] includes = null)
			
			
			public virtual IEnumerable<T> GetMultiPaging(Expression<Func<T, bool>> predicate, out int total, int index = 0, int size = 20, string[] includes = null)
	
	
		+ Tạo class PostCategoryServiceTest
			[TestClass]
			public class PostCategoryServiceTest
			{
				//Tạo đ/tượng giả
				private Mock<IPostCategoryRepository> _mockRepository;
				private Mock<IUnitOfWork> _mockUnitOfWork;
				private IPostCategoryService _categoryService;
				private List<PostCategory> _listCategory;

				[TestInitialize]
				public void Initialize()
				{
					_mockRepository = new Mock<IPostCategoryRepository>();
					_mockUnitOfWork = new Mock<IUnitOfWork>();
					_categoryService = new PostCategoryService(_mockRepository.Object, _mockUnitOfWork.Object);
					_listCategory = new List<PostCategory>()
					{
						new PostCategory() {ID =1 ,Name="DM1",Status=true },
						new PostCategory() {ID =2 ,Name="DM2",Status=true },
						new PostCategory() {ID =3 ,Name="DM3",Status=true },
					};
				}

				[TestMethod]
				public void PostCategory_Service_GetAll()
				{
					//setup method
					_mockRepository.Setup(m => m.GetAll(null)).Returns(_listCategory);

					//call action
					var result = _categoryService.GetAll() as List<PostCategory>;

					//compare
					Assert.IsNotNull(result);
					Assert.AreEqual(3, result.Count);
				}

				[TestMethod]
				public void PostCategory_Service_Create()
				{
					PostCategory category = new PostCategory();
					int id = 1;
					category.Name = "Test";
					category.Alias = "test";
					category.Status = true;

					_mockRepository.Setup(m => m.Add(category)).Returns((PostCategory p) =>
					{
						p.ID = 1;
						return p;
					});

					var result = _categoryService.Add(category);

					Assert.IsNotNull(result);
					Assert.AreEqual(1, result.ID);
				}
			}
				
		+ Thêm connectionString trong appconfig
			 <connectionStrings>
			<clear/>
			<add name="ShopOnlineConnection"  providerName="System.Data.SqlClient" connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=ShopOnline;Integrated Security=True; MultipleActiveResultSets=True"/>
			</connectionStrings>
		
	ShopOnline.Service
		+ Edit PostCategoryService
			PostCategory Add(PostCategory postCategory);
			PostCategory Delete(int id);
			
			public PostCategory Add(PostCategory postCategory)
			{				
				return _postCategoryRepository.Add(postCategory);
			}
			
			public PostCategory Delete(int id)
			{				
			   return _postCategoryRepository.Delete(id);
			}
			
#	Bài 11: Triển khai Web API trên Web layer
	Nội dung bài học 
		Giới thiệu về Resfull API và WebAPI Các công nghệ sử dụng để tạo ra HTTP Service 
		Giới thiệu về RESTful API 
		Một RESTful API là một giao diện lập trình ứng dụng (Application Programming Interface) sử dụng giao thức HTTP để GET, POST, PUT và DELETE dữ liệu. REST viết tắt của Representational state tranfer (REST) được sử dụng bởi trình duyệt cho phép client có thể tương tác với server hoặc cloud service. REST là phi trạng thái, client-server, có thể cache, sử dụng đầy đủ các phương thức tách biệt ngoài GET, POST ra còn có PUT, DELETE.. 
		
		Giới thiệu về WebAPI 
			Web API là API trên nền web (http) và ASP.NET Web API chính là framework giúp chúng ta tạo ra các api này. Web API là các service được xây dựng dựa trên http sử dụng mô hình lập trình convention như ASP.NET MVC 
		Ưu điểm: 
			Cấu hình hết sức đơn giản so với WCF 
			Performance cao Hỗ trợ RESTful đầy đủ 
			Hỗ trợ đầy đủ các thành phần MVC như: routing, controller, action result, filter, model binder, IoC container, dependency injection, unit test 
			Open Source Có thể sử dụng cho hầu hết các loại ứng dụng từ Desktop đến Mobile. 
		
		Các công nghệ tạo ra HTTP Servi ce 
			Web service (ASMX) W
			CF service 
			WCF REST service 
			Web API service 
		
		Webservice 
			Đây là công nghệ cũ nhất của .NET Framework 
			Nó dựa trên SOAP (Simple Object Access protocol) dữ liệu trả về dạng XML 
			Chỉ hỗ trợ giao thức HTTP 
			Không phải Open Source nhưng có thể sử dụng được với bất cứ client nào hỗ trợ XML 
			Chỉ có thể host trên IIS 
			Ưu điểm: 
				Code và Test đơn giản 
				Nhược điểm: Chỉ hỗ trợ giao thức SOAP để truyền nhận dữ liệu nên performance không cao 
				Không thể tạo ra service dạng REST hỗ trợ định dạng dữ liệu JSON 
		 
		WCF (.NET 3.0 trở lên) 
			Cũng dựa trên SOAP và trả về dữ liệu dạng XML 
			Phát triển dựa trên Web service và hỗ trợ thêm rất nhiều giao thức khác nhau như: TCP, HTTP, HTTPS, Named Pipes, MSMQ. 
			Giống Web service không phải Open Source nhưng có thể sử dụng bởi các client hỗ trợ XML Có thể host được trong ứng dụng, trên IIS hoặc Windows Service 
			Ưu điểm: 
				Hỗ trợ nhiều giao thức với nhiều kiểu binding khác nhau đặc biệt là HTTPS 
				Hỗ trợ nhiều định dạng dữ liệu XML, ATOM… 
			
			Nhược điểm: 
				Cấu hình rất phức tạp và rối rắm, chắc chắn các lập trình viên mới dùng không thể cấu hình được nếu không sử dụng Configuration Tool & Google 
				Kiến trúc rất phức tạp và cồng kềnh 
		 
		WCF REST (.NET 3.5 trở lên) 
			Là bản nâng cấp đáng giá của WCF với việc trên .NET 3.5 Microsoft bổ sung webHttpBinding để hỗ trợ RESTful service 
			Hỗ trợ 2 HTTP verb GET, POST để truyền nhận dữ liệu với 2 thuộc tính tương ứng là WebGet và WebInvoke 
			Muốn sử dụng các HTTP verb khác như PUT, DELETE cần cấu hình thêm trên IIS Hỗ trợ các định dạng dữ liệu XML, ATOM, JSON 
			Ưu điểm: 
				Bổ sung hỗ trợ RESTful service với định dạng dữ liệu JSON nhẹ hơn SOAP với dữ liệu XML rất nhiều 
				Cho phép cấu hình tham số WebGet qua URI sử dụng UriTemplate 
			Nhược điểm: 
				Chưa hoàn toàn phải là RESTful service, mới chỉ hỗ trợ mặc định GET, POST 
				Cấu hình khó nhớ (cố hữu của WCF) 
		 
		Web API (.NET 4 trở lên) 
			Đây là một framework mới giúp cho việc xây dựng các HTTP service rất đơn giản và nhanh chóng
			Open Source và có thể được sử dụng bởi bất kì client nào hỗ trợ XML, JSON 
			Hỗ trợ đầy đủ các thành phần HTTP: URI, request/response headers, caching, versioning, content formats 
			Có thể host trong ứng dụng hoặc trên IIS 
			Kiến trúc lý tưởng cho các thiết bị có băng thông giới hạn như smartphone, tablet 
			Định dạng dữ liệu có thể là JSON, XML hoặc một kiểu dữ liệu bất kỳ 
		
		Web API (.NET 4 trở lên) 
			Ưu điểm: 
				Cấu hình hết sức đơn giản khi so với WCF 
				Performance cao 
				Hỗ trợ RESTful đầy đủ Hỗ trợ đầy đủ các thành phần MVC như: routing, controller, action result, filter, model binder, IoC container, dependency injection, unit test 
				Open Source 
			Nhược điểm: Còn rất mới nên chưa có nhiều đánh giá về nhược điểm của Web API 
		 
		Vậy tôi nên lựa chọn framework nào để phát triển HTTP Service? 
			Web Service: Lựa chọn khi bạn chỉ cần xây dựng một service đơn giản 
			WCF là lựa chọn số một khi xây dựng: 
				Service cần hỗ trợ những ngữ cảnh đặc biệt như: message queue, duplex communication… 
				Service sử dụng những kênh truyền dữ liệu ở tầng thấp cho nhanh như: TCP, Named Pipes, UDP… 
			WCF Rest, Web API được sử dụng khi xây dựng: 
				Service RESTful hỗ trợ đầy đủ các thành phần HTTP: URI, request/response headers, caching, versioning, content formats 
				Service cung cấp dữ liệu cho nhiều client khác nhau với băng thông giới hạn như: browser, mobile, tablet… 
	-------------------------------------------------------------------------
	
	ShopOnline.Web:
		+ Tạo area Admin
			+ Tạo webAPI -> TestController
		+ Tạo folder API
				
# 	Bài 12: Cách tổ chức ứng dụng Web
	- 	Tạo folder Assets
	- 	Xóa favicon, item trong script, views(Trừ web.config), content, Areas
	- 	Scripts folder -> Tạo 2 folder spa && plugins
	-	Assets folder -> Tạo 2 folder admin && client
	- 	Tạo folder Infrastructure: Chức class dùng chung cho website	
		+ 	Tạo 2 folder Core & Extensions
		+ 	folder Core -> tạo WebAPIController (ApiControllerBase): bất cứ container nào cũng đều kế thừa ApiControllerBase
	- 	ApiControllerBase: Các phương thức dùng chung	
		- ShopOnline.Model.Models: Tạo class Error 
		- ShopOnline.Data: Class shopOnlineDBContext : Add dbset
		- migration db: 
			add-migration AddErrorTable
		- Tạo repository cho Error
		- Tao service cho Error
		
		
		- ApiControllerBase: Viết các phương thức chung
		- Edit trong postCategoryServices
		
#	Bài 13: Áp dụng Dependency Injection vào dự án sử dụng thư viện Autofac. 
		Các bước thực hiện cài đặt DI Autofac 
		Cài đặt các gói Autofac, Autofac.Mvc5, Autofac.WebApi2 
		Tạo file Startup.cs để register 
		Cài đăt gói Microsoft.Owin.Host.SystemWeb để chạy file Startup 
		Register startup cả controller và API 
		Chạy thử 
	-----------------------------------------------------------------------
	- 	install: autofac, autofac.mvc5, autofac.webapi2 
	ShopOnline.Web
		- 	App_Start
			+ Tạo Owin Startup class Startup
			