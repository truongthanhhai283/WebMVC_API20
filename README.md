# WebMVC_API

# Lỗi và cách fix
	1. Data Diagram Error
		database -> properties -> file > browser sa -> ok
	2. The property 'Status' is not a String or Byte array. Length can only be configured for String and Byte array properties.
		fix: xóa maxlangth 
	3. Unable to determine composite primary key ordering for type: 2 key trong 1 bảng
		fix [Column(Order =1)]/[Column(Order =2)]
		
	4. One or more validation errors were detected during model generation:
	ShopOnline.Data.IdentityUserRole: : EntityType 'IdentityUserRole' has no key defined. Define the key for this EntityType.
	ShopOnline.Data.IdentityUserLogin: : EntityType 'IdentityUserLogin' has no key defined. Define the key for this EntityType.
	IdentityUserRoles: EntityType: EntitySet 'IdentityUserRoles' is based on type 'IdentityUserRole' that has no keys defined.
	IdentityUserLogins: EntityType: EntitySet 'IdentityUserLogins' is based on type 'IdentityUserLogin' that has no keys defined.
	
		fix: Cấu hình trong dbContext	
		protected override void OnModelCreating(DbModelBuilder builder)
        {
            builder.Entity<IdentityUserRole>().HasKey(i => new { i.UserId, i.RoleId });
            builder.Entity<IdentityUserLogin>().HasKey(i => i.UserId);
        }
		
	5. Solving Data Diagram Error
		Database -> Files -> Browser -> sa account
		
	6. Facebook.contact strong name type: delete facebook.contac.dll
	
	7. is not available! You either misspelled the module name or forgot to load it
		chuot phai browser -> restore package
		
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
	- 	install: autofac, autofac.mvc5, autofac.webapi2, system.owin.host
	ShopOnline.Web
		- 	App_Start
			+ Tạo Owin Startup class Startup

#	Bài 14: Sử dùng AutoMapper để map đối tượng. 
	Các bước thực hiện cài đặt DI Autofac 
		1. Cài đặt thư viện AutoMapper từ Nuget. 
		2. Thực hiện tạo các ViewModel tương ứng với Model 
		3. Tạo file MapperConfiguration để cấu hình  
		4. Tạo phần update từ viewmodel sang Model 
		5. Thực hiện mapping. 
	--------------------------------------------------------------
	ShopOnline.Web
		- Tạo foldel Mappings
			+ Tạo class AutoMapperConfiguration
		- Models: tạo các tầng viewmodel theo ShopOnline.Data.Models
		- Edit trong global
		- Infrastructure
			Folder Extensions
			+ Tạo class EntityExtensions
		- Edit PostCategoryController

#	Bài 15: Tích hợp ASP.NET Identity để chứng thực người dùng (login, logout)
	ASP.NET Identity 
		Là một cơ chế xác thực và quản lý người dùng mới nhất của Microsoft dành cho ứng dụng ASP.NET. 
		Tiền thân của ASP.NET Identity là ASP.NET Membership sau khi ra đời đã có nhiều điểm yếu. ASP.NET Identiy đã khắc phục và ra mắt với nhiều tính năng mạnh mẽ. 
		Được ra mắt lần đầu trong Project Template của Visual 2013 
	Cách đặc điểm 
		 Là cơ chế dùng chung cho tất cả các ứng dụng Web bao gồm ASP.NET MVC, Web API, WebForm và SignalR
		 Dễ dàng thêm mới các trường dữ liệu khác vào user 
		 Dễ dàng Unit test 
		 Quản lý quyền 
		 Hỗ trợ login với các Social dễ dàng 
		 Độc lập với Web vì sử dụng cơ chế OWIN 
		 Cài đặt dễ dàng từ Nuget 
	Các bước thực hiện cài đặt DI Autofac 
		1. Cài đặt 3 thư viện 
			1. Microsoft.AspNet.Identity.EntityFramework 
			2. Microsoft.AspNet.Identity.Core  
			3. Microsoft.AspNet.Identity.OWIN 
		2. Tạo mới class User kế thừa từ IdentityUser 
		3. Tạo mới Role kế thừa từ IdentityRole 
		4. Kế thừa lớp DbContext từ dentityDbContext<User> 
		5. Cấu hình authentication từ file Startup.cs 
		6. Thực hiện Migration vào database 
		7. Tạo class quản lý authen Microsoft
	--------------------------------------------------------------
	ShopOnline.Web, ShopOnline.Model
		1. Microsoft.AspNet.Identity.EntityFramework 
		2. Microsoft.AspNet.Identity.Core  
		3. Microsoft.AspNet.Identity.OWIN 
		
	ShopOnline.Data.Models
		tao class ApplicationUser
		
	ShopOnline.Data
		Edit ShopOnlineDbContext
	 
	ShopOnline.Web
		Tao class IdentityConfig
		Tao class Startup.Auth
		
	Package console manager
		add-migration Intergrate.Asp.netIdentity
	
	Edit ShopOnlineDbContext
		protected override void OnModelCreating(DbModelBuilder builder)
        {
            builder.Entity<IdentityUserRole>().HasKey(i => new { i.UserId, i.RoleId });
            builder.Entity<IdentityUserLogin>().HasKey(i => i.UserId);
        }
	
	ShopOnline.Web
		Edit startup
			 ConfigureAuth(app);
			
		Tạo api AccountController
		
	ShopOnline.Data.Migration.MigrationClass
		Edit MigrationClass
		
		update-database
		
#	Bài 16: Giới thiệu tổng quan về AngularJS và cài đặt với Browser
		Khái niệm 
			AngularJS là một JavaScript Framework mạnh mẽ được phát triển bởi Google giúp xây dựng một ứng dụng web SPA hoàn chỉnh. 
			Được phát triển từ năm 2009 và phiên bản 1.0 ra đời tháng 6 năm 2012 
			Thời điểm hiện tại là version 1.5.5, đã có angular 2 beta. 
			Web site: https://angularjs.org 
		Nguồn học tập: 
			https://docs.angularjs.org/guide/concepts 
			http://www.w3schools.com/angular/angular_intro.asp 
			 
	 
		So sánh với JQuery 
			Jquery là một thư viện chứa các phương thức giúp bạn duyệt qua DOM,thao tác với các phần tử DOM, bắt sự kiện hay tạo hiệu ứng... AngularJS là một framework hoàn chỉnh dùng để xây dựng ứng dụng Web. Jquery làm việc với tư duy selector DOM ra đối tượng rồi thao tác, sau đó gán ngược trở lại DOM AngularJS với tư duy mở rộng các cú pháp HTML, các thẻ, các thuộc tính để thao tác hướng đến native HTML. 
			Các thành phần của AngularJS 
		
		Giải thích các khái niệm 
			Data-binding – Đó là tự động đồng bộ dữ liệu giữa model và view. Scope – Đây là đối tượng có khả năng truy cập các model. Scope như một chất keo giữa controller và view, nó giúp controller và view có thể liên kết với nhau. Controller – Đây là những chức năng Javascript được liên kết với một view cụ thể. Services – AngularJS đi kèm với một số dịch vụ được xây dựng ví dụ: $http để thực hiện một XMLHttpRequests. Đây là những đối tượng singleton mà được khởi tạo một lần duy nhất trong ứng dụng. Filters – Filters giống như một bộ lọc, format lại dữ liệu gốc sau đó hiển thị ra ngoài view người dùng. Directives – Cho phép mở rộng HTML theo ý của bạn và bạn có thể tùy chỉnh lại các thuộc tính, phần tử, … (elements,) Templates – Là một file xây dựng bằng html. Nó được gọi từ thông tin của controller và model. Templates có thể là một file giống như index.html hoặc là nhiều file khác nhau sửa dụng cho một page , chúng ta vẫn thường gọi là “partials”. 
		 
		Giải thích các khái niệm (tiếp) 
			Routing – Quá quen thuộc rồi phải không. Routing giúp chuyển đổi giữa các view hoặc luồng xử lý trong project của bạn. Model View Whatever − MVC – là một mẫu thiết kế để phân chia ứng dụng ra thành các phần khác nhau (gọi là Model, View và Controller), đều có trách nhiệm riêng biệt. AngularJS không thực hiện MVC trong ý nghĩa truyền thống, mà là một cái gì đó gần gũi hơn với MVVM (Model-View-View-Model). AngularJS đề cập nó với một cách hài hước là Model View Whatever. Deep Linking – Liên kết sâu, cho phép bạn mã hóa trạng thái của ứng dụng  trong các URL  để nó có thể đánh dấu được với công cụ tìm kiếm như google,Bing, … Giúp ứng dụng của bạn tốt hơn cho SEO. Dependency Injection – Dependency Injection trong Angular giúp các nhà phát triển tạo ứng dụng  dễ dàng hơn để phát triển và thử nghiệm dễ dàng. 
		 
		Ưu và nhược điểm 
		Ưu điểm 
			AngularJS được phát triển bởi google, và là mã nguồn mở viết theo mô hình MVC. 
			AngularJS cho phép tạo ra các ứng dụng một cách đơn giản, code sạch, dễ dàng hơn trong việc kiểm thử. Tương thích với hầu hết các trình duyệt trên các điện thoại thông minh. AngularJS sử dụng cơ chế data-binding từ là khi model thay đổi thì view cũng thay đổi và ngược lại. 
		Nhược điểm 
				Không an toàn: Được phát triển từ javascript nên nó không an toàn, phía máy chủ phải thường xuyên xác nhận quyền để hệ thống chạy trơn tru. 
				Phụ thuộc: Nếu người dùng vô hiệu hóa javascript thì coi vứt đi. 
		Download và cài đặt 
			Để download bạn lên trang chủ AngularJS bấm vào nút mầu xanh để download file angulajs.min.js phiên bản mới nhất về (đây chính là bộ thư viện của AngularJS) và include vào phần header: <script src="/js/angularjs.min.js"></script> Hoặc bạn cũng có thể copy CDN sau khi bấm vào download từ trang chủ và gọi: <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular.min.js"></script> 
	---------------------------------------------------------------------------------------
		Download và cài đặt
			angulajs.org
	ShopOnline.Web
		Tạo file bower.json & .bowerrc
	
#	Phần 2: Frontend  - Bài 17: Cách sử dụng Controller và View trong AngularJS 
		Nội dung bài học 
			Khái niệm module và cách tạo một module 
			Khái niệm controller và cách tạo một controller 
			Cách register một controller với một module 
			Cách sử dụng module trong ứng dụng. 
			Chú ý: 
				Chúng ta sẽ học lý thuyết từ bài 16-20 còn lại bài 21 sẽ bắt đầu đi vào dự án thật trong quá trình đó mình sẽ đan xen lý thuyết 
				Bài 16 mình đã giới thiệu tổng quan Angular, các bạn có thể tìm thêm các tài nguyên học tập và đọc thêm lý thuyết trên mạng hoặc trang http://angularjs.org 
				Trong quá trình làm dự án mình sẽ hoàn thành các API còn lại khi cần. 
	Khái niệm Module và Controller 
	Module là gì? 
		Một module là một container cho các thành phần khác nhau của ứng dụng như filters, controllers, services, directives... 
		Bạn tưởng tượng  một module như một hàm Main của các loai ứng dụng khác. 
		Cách tạo một module 
		Sử dụng phương thức module() của đối tượng angular để tạo một module 
	 
	Controller là gì? 
		Trong angular thì controller là một hàm JavaScript. Tác dụng của nó là xây dựng lên model để cho view hiển thị. 
		Cách tạo một controller 
	
	Lỗi thường gặp  
		Điều gì sảy ra nếu tên controller trong view bị sai? Xuất hiện 1 lỗi và bạn xem bằng Developer Tool  Console Expression trong view sẽ không thể hiển thị 
		Nếu bạn đang dùng bản min của Angular bạn không thể đọc lỗi trực tiếp mà phải click vào link lỗi để chuyển đến trang đọc lỗi của angular 
		Cách khác là bạn nên dùng bản không phải min trên môi trường develop. 
		Khi tên thuộc tính trong view bị sai? 
		Không nhận được lỗi nào vì tên biến bị undefined. 
	-------------------------------------------------------------------------
	ng-app: Khởi tạo module

#	Bài 18: Tìm hiểu về biến $scope và $rootScope trong AngularJS 
	Nội dung bài học 
		Khái niệm Scope 
		Phạm vi ảnh hưởng của biến Scope 
		Tìm hiểu về rootScope 
		Scope lồng nhau 
	
	Khái niệm Scope 
		$scope là một đối tượng có nhiệm vụ giao tiếp dữ liệu giữa controller và view. Scope chứa thông tin là các dữ liệu model, bao gồm các thuộc tính và phương thức. Trong controller, dữ liệu model có thể được truy cập qua đối tượng $scope. 
		Bản chất: Chúng ta hiểu rằng ứng dụng AngularJS bao gồm: 
			1. View - lớp code HTML. 
			2. Model - là dữ liệu ứng dụng trên View. 
			3. Controller - là các hàm javascript có khả năng tạo/thay đổi/xóa/điều khiển dữ liệu. 
	
	Phạm vi của biến Scope 
		Trong một ứng dụng có thể có nhiều Controller và nhiều $scope khác nhau Khi một controller được sử dụng ngoài view, angular sẽ tạo một thể hiện của 1 controller đồng thời cũng tạo một biến scope cho controller đó. 
		Ví dụ 
	
	Tìm hiểu về rootScope 
		Biến rootScope là một biến tổng quát bao hàm toàn bộ các controller của ứng dụng. 
		Tất cả các ứng dụng đều có một $rootScope, nó được tạo khi khai báo một phần tử HTML có thuộc tính là ng-app. 
		
	Scope lồng nhau 
		Trong AngularJS hỗ trợ các controller lồng nhau nên cũng sẽ có scope lồng nhau 
		Biến được khai báo ở scope của controller bên ngoài cũng sẽ được gán cho biến cùng tên ở scope của controller bên trong. 
		Tuy nhiên giá trị của biến ở controller bên trong hoàn toàn có thể ghi đè của controller bên ngoài. 
		Khi thực thi sẽ thực thi controller bên ngoài trước. 
	------------------------------------------------------------
	rootScope: Biến toàn cục
	scope lồng nhau: scope bao đóng sẽ được thực thi nếu không gán values nào: Kế thừa

#	Bai 19 Cach su dung directive trong AngularJS 1
	Nội dung bài học 
		Service trong AngularJS Khái niệm 
		Các loại service có sẵn 
		Cách tạo mới 1 custom service 
	
	Khái niệm Service là gì? 
		Service nói chung là những hàm được tập hợp lại để xử lý một tác vụ nào đó có thể là dùng chung hoặc dùng riêng, trong ASP.NET có Web API, Web Service... 
		Trong AngularJS có nhiều các service được xây dựng sẵn giúp xây dựng hệ thống, nhưng chúng ta cũng có thể tự định nghĩa thêm các service theo nhu cầu của riêng dự án. 
		
	Một số service sẵn có của AngularJS 
		$anchorScroll 	$animate 			$cacheFactory 	$compile 		$controller 
		$document 		$exceptionHandler 	$filter 		$http 			$httpBackend 		
		$interval 		$locale 			$location 		$log 			$parse 		
		$rootElement 	$rootScope 			$sce 			$sceDelegate 	$q 	
		$templateCache 	$templateRequest 	$timeout 		$window 		$interpolate 
	
	Service tự định nghĩa 
		Có hai cách để định nghĩa một service: 
		Sử dụng Factory method 
		Sử dụng Service method 
		Cú pháp khai báo service: 
	-------------------------------------------------------------------------
	Khai báo service
	
#	Bài 20: Directives trong AngularJS 
	Khái niệm Directive 
		Directive là một thành phân tính năng của AngularJS, nó giúp xây dựng các thẻ mở rộng của cho HTML nhằm một mục đích nào đó. 
		Các directive của Angular thường có tiền tố là ng-directive.
	
	Các directive chính  
		Trong AngularJS, chúng ta khai báo directive với tiếp đầu ng-, có 3 directive chính: 
		ng-app: khởi tạo ứng dụng AngularJS. ng-init: khởi tạo dữ liệu ứng dụng giống constructor trong OOP. 
		ng-model: gắn kết dữ liệu ứng dụng với các đối tượng HTML(input, select, textarea). 
	
	Tự định nghĩa một custom directive 
		Ngoài các Directive mà AngularJS hỗ trợ sẵn, chúng ta có thể tao mới Directive sử dụng hàm .directive(). Khai báo một directive phải tạo một thẻ HTML có tên giống với tên của directive chúng ta cần tạo. 
		Tên của thẻ phải phân tách bằng dấu "-", chẳng hạn là tedu-directive. Nhưng tên directive mới sẽ bỏ dấu "-" và viết hoa chữ đầu của mỗi từ, như vậy tên đúng là teduDirective Cách định nghĩa custom directive: 
	Hạn chế truy cập cho Directive 
		Chúng ta có thể giới hạn chỉ một số phương thức nào đó được gọi directive. Chẳng hạn chúng ta hạn chế chỉ thuộc tính(attribute) có thể gọi directive Lưu ý: Các giá trị định nghĩa để hạn chế đối với các thành phần như sau: 
		restrict: "E" - cho Element 
		restrict: "A" - "A" cho Attribute 
		restrict: "C" - "C" cho Class 
		restrict: "M" - "M" cho Comment
		Mặc định, giá trị "EA" sẽ hạn chế cho cả Element và Attribute 
	--------------------------------------------------------------

#	Bài 21: Dựng cấu trúc cho SPA(Single Part Application) sử dụng AngularJS 
	Ý tưởng? 
		Đầu tư vào thiết kế với best practices sẽ lâu hơn lúc đầu nhưng sau này dự án lớn lên sẽ dễ dàng hơn nhiều. 
		Làm sao để khi có nhiều module thì ứng dụng dễ dàng tìm kiếm và quản lý source code 
	Cấu trúc cơ bản 
	Phân loại theo từng loại, controllers, directives, views. 
	Ưu điểm: 
		Dễ nhìn 
		Gần với mô hình MVC 
	Nhược điểm: 
		Phù hợp ứng dụng nhỏ 
		Khi có nhiều view hay controller sẽ khó tìm 
	
	Mục tiêu đạt được 
		Có khả năng sửa chữa nhanh chóng và dễ dàng
		Có thể mở rộng 
		Dễ dàng debug 
		Dễ dàng testing 
	Các best practices 
		Tách header, footer ra thành module riêng 
		Tách phần routing ra thành file riêng 
		Viết code để có thể minify code 
		Đặt tên thống nhất ví dụ: blogView.html, blogServices.js, blogController.js. 
	-----------------------------------------------------------------------------
	ShopOnline.Web
	+ 	Tạo folder app
	+	Xóa folder script
	+	Foldel app:
		Tạo folder shared & components folder
	+ 	Assets/Admin folder:
		Tạo folder css, js, libs, img
	+	app/components
		Tạo folder users, products, product_categories, oders, roles
	+	Edit bowerrc url
	+	app/shared
		Tạo folder directive, footer, navigation
	+	app	
		Tạo file app.js, app.routes.js
	+	app/components/products
		Tạo 3 file html: productListView - productEditView - productAddView
		Tạo 3 file controller.js tương ứng: productListController - productEditController - productAddController
		tạo .routes.js để tách thành module (các module khác cũng như vậy)
	+	shared folder
		Tạo folder servies

#	Bài 22: Triển khai routing cho sử dụng Angular UI Router 
	Giới thiệu vể Router 
		Router là một cơ chế rất quan trọng trong ứng dụng SPA. 
		Nó độc lập với cơ chế điều hướng của ASP.NET MVC 
		Nó tự động sử dụng view tương ứng với URL 
		Trong AngularJS: 
			ngRoute: Là một module core của AngularJS giúp điều hướng trong các kịch bản đơn giản. 
			Ui-router: Được phát triển bởi cộng đồng, khắc phục và thêm các tính năng mạnh mẽ cho ng-Route 
	Tại sao nên sử dụng ui-router 
		ui-router cho phép view lồng nhau. Điều này là rất hữu ích với ứng dụng lớn, nơi bạn có thể có các trang mà kế thừa từ các phần khác. 
		ui-router cho phép bạn có kiểu liên kết mạnh mẽ giữa các state dựa trên tên của state. Thay đổi địa chỉ ở một nơi sẽ cập nhật tất cả các liên kết đến state mà khi bạn xây dựng các liên kết của bạn với ui-sref. Rất hữu dụng cho các dự án lớn, nơi các URL có thể thay đổi. 
		tiểu bang cho phép bạn bản đồ và truy cập thông tin khác nhau về những trạng thái khác nhau và bạn có thể dễ dàng chuyển thông tin giữa các quốc gia thông qua $ stateParams. 
	----------------------------------------------------------------------------
	ShopOnline.Web
	+	Edit .bowerrc
	+	assets/admin/libs
		copy & paste angular & angular-ui-router
	+	Download template adminlte & extract
	+	paste img, js, css vào assets folder
	+	coppy paste index admin
	+	copy & paste bootstrap, jquery, fastclick, slimScroll vào assets/admin/libs
	+	edit bower.json
		
#	Bài 23: Đọc danh sách dữ liệu từ Web API bằng AngularJS 
	Các bước xây dựng trang danh sách 
	1. Tạo API danh sách cho product category 
	2. Tạo service common cho việc call API 
	3. Đọc web API trong Angular Controller 
	4. Sử dụng directive ng-repeat để hiển thị dữ liệu 
	
#	Bài 24: Định dạng dữ hiển thị sử dụng Filter trong AngularJS 
	Nội dung bài học 
		Khái niệm filter 
		Các filter có sẵn 
		Cách tự định nghĩa filter 
	
	Các filter thông dụng 
		currency: định dạng số thành kiểu tiền tệ 
		date: định dạng ngày tháng theo định dạng đã cho. 
		filter: trả về tập con từ mảng dữ liệu. 
		json: định dạng đối tượng thành JSON. 
		limitTo: giới hạn một mảng/chuỗi thành một số phần tử/ký tự đã cho. 
		lowercase: chuyển chuỗi sang chữ thường. 
		number: chuyển số sang chữ. 
		orderBy: sắp xếp mảng theo thứ tự. 
		uppercase: chuyển chuỗi sang chữ hoa
		
	Cách sử dụng Filter 
		Để sử dụng filter, chúng ta chỉ cần thêm filter đó vào biểu thức theo cú pháp như sau: 
			{{myString | filter}} Ví dụ: <p>Tên đầy đủ {{ lastName | uppercase }}</p> hoặc  
		Hoặc: <h1>Price: {{ price | currency }}</h1> 
	 
	Filter tự định nghĩa 
		Ngoài các filter có sẵn trong angularjs chúng ta cũng có thể định nghĩa thêm các filter của riêng mình giống như directive, service. 
	--------------------------------------------------------------
		
	SQL: update productCategories set CreatedDate = getdate()

#	Bài 25: Phân trang danh sách dữ liệu sử dụng custom directive. 
	Các bước thực hiện 
	1. Backend 
		1. Tạo class generic chứa thông tin paging trả về 
		2. Áp dụng vào phân trang cho web API sử dụng LINQ Entity Framework 
	
	2. Frontend 
		1. Viết mới một pager directive để phân trang 
		2. Áp dụng didrrective vào để phân trang 
	-------------------------------------------------
	
#	Bài 26: Tìm kiếm dữ liệu với Angular 
	Các bước thực hiện 
	1. Backend 
		1. Thêm một tham số filter keyword vào phương thức của API 
		2. Test sử dụng Post man extension của Chrome 
	
	2. Frontend 
		1. Chỉnh sửa controller để thêm tham số 
		2. Call lên hàm sử dụng binding sự kiện trong Angular 
	
#	Bài 27: Triển khai service thông báo cho người dùng 
	Các bước thực hiện 
 
	1. Sử dụng bower để cài đặt toastr 
	2. Tạo custom service có tên là notificationService gắn vào module shoponline.common 
	3. Nhúng service vào file index 
	4. Inject vào controller cần dùng 
	5. Gọi notification thông báo mỗi khi cần 
	-------------------------------------------------
	https://codeseven.github.io/toastr/demo.html
	
#	Bài 28: Tạo form thêm mới dữ liệu 
	Các bước thực hiện 
		1. Tạo phương thức API thêm mới dữ liệu 
		2. Tạo form thêm dữ liệu sử dụng bootstrap 
		3. Valid dữ liệu đầu vào bằng AngularJS 
		4. Tạo mới controller thêm mới 
		5. Nhúng controller vào index 
		6. Binding sự kiện 
	---------------------------------------------------------
	
#	Bài 29: Tạo form cập nhật dữ liệu thông qua method PUT 
	Các bước thực hiện 
	1. Backend 
		1. Thêm API cập nhật dữ liệu 
		2. Frontend 
	1. Tạo form cập nhật dữ liệu và loading dữ liệu sẵn 
	2. Tạo thêm phương thức cho apiService 
	3. Tạo controller edit 
	4. Validate dữ liệu đầu vào 
	5. Binding sự kiện cập nhật
	6. Thông báo cho người dùng

#	Bài 30: Validate form trong AngularJS 
	Những điểm cần nhớ 
	Property Class Description 
		$valid ng-valid Boolean Tells whether an item is currently valid based on the rules you placed. 
		$invalid ng-invalid Boolean Tells whether an item is currently invalid based on the rules you placed.
		$pristine ng-pristine Boolean True if the form/input has not been used yet. 
		$dirty ng-dirty Boolean True if the form/input has been used. 
		$touched ng-touched Boolean True if the input has been blurred. 
	Truy cập vào form 
		Để truy cập vào form: <form name>.<angular property> 
		Để truy cập vào input: <form name>.<input name>.<angular property> 
	Một số điểm cần nhớ 
		Thuộc tính novalidate cho form sẽ disable cơ chế validate mặc định của HTML, chúng ta sẽ dùng của AngularJS Áp dụng directive ng-model cho các input để liên kết với model Sử dụng ng-minlength và ng-maxlength để giới hạn độ dài ngắn nhất và dài nhất cho input Thuộc tính bắt buộc là required Nếu cần valid email chỉ cần cho type=“email” Các bạn có thể tham khảo thêm các thuộc tính tại: https://docs.angularjs.org/api/ng/directive/input 
 
#	Bài 31: Xóa dữ liệu với Confirm bootbox trong AngularJS 
	
	Các bước thực hiện 
	1. Backend 
		1. Thêm phương thức xóa cho API 
	2. Frontend 	
		1. Cài đặt bootbox và ngBootbox trên bower 
		2. Sử dụng confirm của bootbox 
		3. Gọi phương thức xóa 
		4. Thông báo thành công 
		
#	Bài 32: Xóa nhiều bản ghi trong AngularJS 
	Các bước thực hiện 
	1. Backend 
		1. Thêm phương thức xóa nhiều bản ghi cho API
		2. Frontend 
	1. Tạo checkbox cho mỗi dòng 
	2. Sử dụng $watch để check sự tay đổi của các checkbox 
	3. Submit các dòng đã check lên server để xóa 
	
#	Bài 33: Tạo form thêm sản phẩm nhúng CK Editor 
	Các bước thực hiện 
	1. Tạo view productAddView.html và controller productAddController.js 
	2. Nhúng controller vào index 
	3. Tạo route cho add product view trong product.module.js 
	4. Tạo nội dung form HTML 
	5. Dùng bower để nhúng CK Editor 
	6. Nhúng CK Editor 

#	Bài 34: Nhúng CK Finder và kết nối với CK Editor 
	Các bước thực hiện 
	1. Download và nhúng CK Finder 
	2. Nhúng CK Finder  
	3. Cấu hình CK Finder trỏ đến thư mục muốn quản lý 
	4. Trỏ CK Editor vào Ck Finder 
	
#	Bài 35: Quản lý tag cho sản phẩm 
	Các bước thực hiện 
	1. Tạo trường soạn thảo tag cho sản phẩm 
	2. Xử lý logic để thêm vào bảng Tag và ProductTag
	3. Nhân sang form edit sản phẩm 
	4. Xử lý logic edit tag cho sản phẩm 
	-------------------------
	add-migration addTagField
	update-database
	
#	Bài 36: Quản lý nhiều ảnh cho sản phẩm 
	Các bước thực hiện 
	1. Tạo phần upload nhiều ảnh cho form sản phẩm 
	2. Đọc danh sách ảnh rỗng và tạo 1 button thêm ảnh
	3. Mỗi lần thêm ảnh bằng CKFinder lại thêm 1 ảnh vào list trong controller 
	4. Thêm sản phẩm cũng xử lý để đưa list ảnh lên 
	5. Lưu danh sách ảnh từ C#  vào DB với dạng JSON để quản lý ảnh 
	6. Cập nhật cũng tương tự nhưng phải đọc danh sách ảnh có sẵn 
	
#	Bài 37: Tạo form đăng nhập quản trị và điều hướng	
	Các bước thực hiện 
	1. Tạo form đăng nhập 
	2. Cấu hình routing với parent view 
	3. Điều hướng qua lại giữa các view 

#	Bài 38: Đăng nhập quản trị sử dụng ASP.NET Identity 
	Đặt vấn đề 
		Tạo ra cơ chế đăng nhập khi đăng nhập thành công sẽ tạo ra 1 token gửi về cho client Angular 
		Mỗi lần đăng nhập lại một token khác nhau 
		Mỗi request gửi lên phải kèm theo token này vào header của request 
		Token sẽ dc lưu sử dụng localStorageModule 
		Logout sẽ xóa token này đi. 
		Nếu không có token xem như user chưa đăng nhập 
	Các bước thực hiện 
	1. Tạo authentication service 
	2. Cấu hình trong Startup
	3. Tạo login service 
	4. Tạo login controller
	5. Hiển thị thông tin đăng nhập
	6. Validate đăng nhập 
	
#	Bài 40: Ghép giao diện trang khách hàng sử dụng ASP.NET MVC 
	Các bước thực hiện 
		Download template 
		Copy vào project các resource như images, css, js... 
		Copy HTML và tạo trang Layouts.cshtml 
		Chỉnh đường dẫn các file resource 
		Tạo RenderBody
		Tạo các partial 
		Chạy thử trang web 
	Các tiêu chí 
	1. Phải tối đa hóa việc giảm thiểu trùng lặp code
	2. Dễ dàng tùy biến sau này 
	3. Dễ dàng đọc code 
	
#	Bai 41 Binding cac thanh phan dung chung
	Các bước thực hiện 
		Tạo các service cho các bảng như Footers, Menu, Danh mục sản phẩm... 
		Inject service vào controller vào controller 
		Đọc dữ liệu và hiển thị ra view 
	Các cách truyền dữ liệu từ Controller-View 
		ViewModel
		ViewBag 
		ViewData
		TempData
		Session 
	ViewModel 
		Có thể truyền dữ liệu từ Controller
		View và ngược lại dùng Form để submit từ View
		 Controller. 
			Tồn tại chỉ trong 1 request giữa View và Controller
			Được gọi thông qua thuộc tính Model của class WebViewPage
			Được truyền về thông qua lệnh return View hoặc PartialView 
	ViewBag 
		ViewBag là một thuộc tính động lưu giá trị dưới dạng Key/Value theo đặc tính kiểu dynamic của C# 4.0 Nó là Wrapper của ViewData dùng để truyền dữ liệu 1 chiều từ Controller 
		 View 
		ViewBag là một thuộc tính của lớp ControllerBase trong namespace System.Web.Mvc
		Chỉ có tác dụng trong 1 request 
		Nếu redirect thì giá trị sẽ trả về null 
		Không đòi hỏi phải chuyển đổi kiểu khi lấy giá trị 
	ViewData 
		Là một đối tượng dictionary kế thừa từ ViewDataDictionary class
		ViewData là một thuộc tính của ControllerBase class
		Dùng để truyền dữ liệu từ Controller về View tương ứng
		Chỉ có phạm vi trong 1 request
		Nếu có redirect sẽ trở về null
		Yêu cầu chuyển đổi sang kiểu tương ứng khi lấy giá trị ở view, phải check null để tránh lỗi. 
	TempData 
		Là một đối tượng dictionary dẫn xuất từ TempDataDictionary class được lưu trữ trong session ngắn hạn. TempData cũng là một thuộc tính của ControllerBase class TempData được dùng để  truyền dữ liệu từ request hiện thời đến các request tiếp theo (nghĩa là trang này sang trang khác) 
		Nó có vòng đời rất ngắn đến khi view tiếp theo load xong. 
		Đòi hỏi phải chuyển đổi kiểu khi lấy giá trị và check null để tránh lỗi 
		Được dùng để lưu những message dùng 1 lần như lỗi hoặc message validation, có thể giữ lâu hơn với phương thức Keep() 
	 
	Session 
		Session là một thuộc tính của class Controller nó thuộc kiểu HttpSessionStateBase
		Cũng được sử dụng để truyền dữ liệu trong ứng dụng ASP.NET nhưng không giống các loại khác. Nó tồn tại trong toàn bộ phiên làm việc. 
		Mặc định cấu hình của ASP.NET Application cho session là 20 phút. 
		Nó có phạm vi toàn bộ phiên làm việc ở tất cả các controller.
		Cũng đòi hỏi phải chuyển đổi kiểu khi get giá trị 

#	Bài 42: Binding slide và sản phẩm ra trang chủ 		
	add content slice: add-migration addContentForSlice
	
#	Bài 43: Rewrite URL để tạo Friendly URL trong ASP.NET MVC 
	Các điểm cần nhớ 
		Route đóng vai trò quan trọng trong ASP.NET MVC Framework. Route ánh xạ một URL đến Controller trong MVC. Route chứa Url partern và điểu khiển url. Url partern được bắt đầu sau tên miền web (domain name). Route được cấu hình trong class RouteConfig. 
		Route Constrants được dùng để hạn chế giá trị của tham số truyền vào. 
		Route phải được đăng ký trong sự kiện Application_Start trong file Global.asax.cs. 
	Sơ đồ xử lý 
	Cấu hình Route 
	Mẫu URL 
	URL Controller Action Id http://domain/home HomeController Index null http://domain/account/add AccountController Add null http://domain/cart/edit/0727 CartController Edit 0727 
	Cách đăng ký route 
	Các bước thực hiện 
		Định nghĩa mẫu URL mapping với Controller và ActionMethod thông qua file RouteConfig.cs 
		Cách mapping có sử dụng ID truyền qua QueryString 
		Lưu ý khi đặt tên biến id mặc định và các biến khác. 
		Lưu ý thứ tự các cấu hình routing 
	
#	Bài 44: Tạo trang danh sách sản phẩm và phân trang danh sách
	Các bước thực hiện 
		Tạo mới trang danh sách sản phẩm
		Thực viện phân trang tại Controller sử dụng Skip và Take
		Hiển thị phân trang tại View 
		Phải hiển thị số trang theo mong muốn khi có nhiều hơn số trang cần thiết. 
		
#	Bài 45: Sắp xếp danh sách sản phẩm theo điều kiện 

#	Bài 46: Tìm kiếm với auto implement

#	Bài 47: Tạo trang chi tiết sản phẩm và sản phẩm liên quan 
	add-migration addQuantityField
	update-database
	
#	Bai 48 Danh sách tag và danh sách sản phẩm theo tag

#	Bài 49: Xây dựng và quản lý các trang nội dung riêng lẻ 
		
#	Bài 50: Sử dụng Output Cache trong ASP.NET
	Các tiêu chí để cache 
		Nội dung ít thay đổi Lượng truy xuất thường xuyên 
		Có nhiều loại cache khác nhau nhưng trong ASP.NET MVC thì OutputCache là dễ sử dụng nhất. 
	Các thuộc tính của [OutputCache] 
		Duration: thời gian tồn tại của Cache trước khi refresh, đơn vị giây 
		Location: Vị trí lưu cache, mặc định là Any
		VaryByParam: Các tham số của một method muốn cache
		Ngoài ra có thể setting cache ở webconfig: 

#	Bài 51: Xây dựng trang liên hệ và làm việc với Google Map AP
	Các bước thực hiện 
		Tạo bảng ContactDetail trong DB thông qua Codefist bao gồm: ID, Code, Tên cty, Địa chỉ, Điện thoại, Email, Website, Thông tin thêm.
		Tạo quản trị để thêm sửa xóa cho contact detail
		Đọc dữ liệu ra trang liên hệ 
		Đọc thông tin liên hệ mark vào Google Map thông qua API 
	-----------------------------------
	add migration adđetailContact / update-database
	
	https://developers.google.com/maps/documentation/javascript/tutorial
	
	https://developers.google.com/maps/documentation/javascript/infowindows
	
	https://developers.google.com/maps/documentation/javascript/examples/infowindow-simple
	
	https://console.cloud.google.com/apis/library/maps-backend.googleapis.com?q=Google%20Maps%20JavaScript%20API&id=fd73ab50-9916-4cde-a0f6-dc8be0a0d425&project=windy-furnace-180806
	
#	Bài 52: Gửi phản hồi và gửi mail trong ASP.NET MVC 
	Các bước thực hiện 
		Tạo bảng Feedbacks và Service 
		Submit thông tin liên hệ đến quản trị 
		Lắp captcha cho form
		Cấu hình gửi mail 
		Gửi email về cho tài khoản quản trị được cấu hình trong system config 
	------------------------------------------
	add-migration/update-database addFeedbackTable
	add-migration/update-database addFeedbackTable2
	
	install BotDetect, sendgrid
	
	https://myaccount.google.com/lesssecureapps
	
#	Bài 53: Tạo trang đăng ký thành viên 
	Các bước thực hiện 
		Submit thông tin liên hệ đến quản trị 
		Kiểm tra trùng thông tin user name
		Lắp captcha cho form
		Cấu hình gửi mail Gửi email về cho user 
		
#	Bài 54: Đăng nhập hệ thống với ASP.NET Identity 
	Các bước thực hiện 
		Đăng nhập bằng cơ chế sẵn có của ASP.NET Identity 
		Thêm cơ chế lọc 2 loại authen của admin và client 
		Đối với webAPI thì sẽ sử dụng based token
		Đối với ASP.NET MVC sẽ sử dụng Cookie Authen 
		Submit thông tin tư form lên 
		Sau đó validate thông tin và cho phép đăng nhập nếu thành công.
		Hiển thị thông tin đăng nhập. 
		
#	Bài 55: Tạo giỏ hàng trong ASP.NET 
	Các bước thực hiện 
		Thêm mới sản phẩm vào giỏ hàng
		Hiển thị danh sách sản phẩm trong giỏ hàng
		Cập nhật số lượng sản phẩm
		Xóa sản phẩm và xóa tất cả đơn hàng
		Thanh toán đơn hàng 
		
#	Bài 56: Tạo giỏ hàng trong ASP.NET – Phần 2
	Các bước thực hiện 
		Cập nhật số lượng sản phẩm 
		Xóa tất cả đơn hàng 
		Thanh toán đơn hàng 
	--------------------
	add-migration addCustomerID
	
	jqueryvalitation.org
	
#	Bài 57: Quản lý user, phân quyền cho user sử dụng ASP.NET Identity 
	Các bước thực hiện 
		Chỉnh sửa cơ sở dữ liệu của các bảng trong phần Identity
		Tạo phần Repository cho các bảng cần thiết
		Tạo trang quản lý nhóm người dùng 
		Tạo trang quản lý quyền 
		Tạo trang quản lý người dùng 
		Phân quyền cho từng nhóm
		Áp dụng validate quyền vào method
	-----------------------------
	add-migration RenameTablesIdentity/ update-database
	add-migration addGroupUser/ update-database
	
	install nuget asp.net.identity.ef

#	Bài 58: Thống kê doanh thu sử dụng Store Procedure trong SQL 
	Các bước thực hiện 
		Tạo SQL Store Procedure trong SQL từ Entity Framework CodeFirst
		Thực thi store procedure từ Entity Framework
		Đọc thông tin ra bảng sử dụng AngularJS 
		Vẽ biểu đồ thống kê theo số liệu 
	----------------------------------------
	add-migration/update-database changeOrderDetail
	

	Thống kê theo ngày
		select CreatedDate, sum(od.quantity * od.price) as Revenues	from Orders as o
		inner join OrderDetails as od
		on o.ID=od.OrderID
		group by o.createdDate
	
	Thống kê theo tháng	
	select datepart(mm,o.CreatedDate), sum(od.quantity * od.price) as Revenues	from Orders as o
		inner join OrderDetails as od
		on o.ID=od.OrderID
		group by datepart(mm,o.CreatedDate)
	
	Thống kê theo năm		
	select datepart(yy,o.CreatedDate), sum(od.quantity * od.price) as Revenues	from Orders as o
		inner join OrderDetails as od
		on o.ID=od.OrderID
		group by datepart(yy,o.CreatedDate)
		
	Thống kê doanh thu
	select
		o.CreatedDate as Date, 
		sum(od.quantity * od.price) as Revenues,
		sum((od.quantity * od.price) - (od.quantity * p.originalPrice)) as benefit
		from Orders as o
		inner join OrderDetails as od
		on o.ID=od.OrderID
		inner join Products p
		on od.ProductID=p.ID
		group by o.CreatedDate

#	Bài 59: Bổ túc kiến thức về Entity Framework 
	Khái niệm 
		Entity Framework là một nền tảng được sử dụng để làm việc với database thông qua cơ chế ánh xạ Object/Relational Mapping (ORM). Nhờ đó, bạn có thể truy vấn, thao tác với database gián tiếp thông qua các đối tượng lập trình. 
	Các loại đối tượng trong EF 
		ObjectContext đại diện cho một database. ObjectContext có chức năng quản lý các kết nối, định nghĩa mô hình dữ liệu với metadata và thao tác với database. Lớp này cũng có thể thêm vào các phương thức đại diện cho các stored procedure trong database. ObjectSet<TEntity> là một  một tập hợp các entity. Mỗi đối tượng này tương ứng với một table. Có thể lấy được các đối tượng này thông qua các property tương ứng của ObjectContext. EntityObject, ComplexObject là các lớp tương ứng cho một dòng dữ liệu của table trong database. Khác biệt chính giữa hai loại này là ComplexObject không chứa primary key. EntityCollection<TEntity> và EntityReference<TEntity>: là các đối tượng thể hiện mối quan hệ (relationship) giữa hai entity class. Mỗi đối tượng này có thể được truy xuất thông qua các property của entity class. 
	Khái niệm Entity Framework Code First 
		Entity Framework Code First được giới thiệu từ Entity Framework 4.1. Trong cách tiếp cận Code First, bạn có thể tập trung vào việc thiết kế Domain và bắt đầu tạo ra các lớp theo yêu cầu của Domain của bạn chứ không phải thiết kế cơ sở dữ liệu trước rồi sau đó tạo ra các lớp phù hợp với thiết kế cơ sở dữ liệu đó. Code First API sẽ tạo ra cơ sở dữ liệu dựa trên các lớp thực thể và lớp cấu hình của bạn. Đầu tiên bạn bắt đầu viết các lớp thay vì tập trung vào thiết kế cơ sở dữ liệu, sau đó khi bạn chạy ứng dụng, Code First API sẽ tạo ra cơ sở dữ liệu mới hoặc ánh xạ các lớp của bạn vào cơ sở dữ liệu đã tồn tại trước khi chạy ứng dụng của bạn. 
	Các chiến lược khởi tạo DB 
		Bạn đã tạo database sau khi chạy ứng dụng lần đầu tiên, nhưng những lần chạy khác thì sao? Code First API có tạo database mới mỗi lần bạn chạy ứng dụng không? Làm thế nào để cập nhật database khi bạn thay đổi mô hình? Để xử lý các kịch bản trên, bạn có thể sử dụng các kịch bản khởi tạo database. 
		CreateDatabaseIfNotExists: Đây là giá trị mặc định. Như tên gọi, nó sẽ tạo database nếu chưa tồn tại. Tuy nhiên nếu bạn thay đổi mô hình và chạy ứng dụng với tùy chọn này thì sẽ xảy ra ngoại lệ. DropCreateDatabaseIfModelChanges: Tùy chọn này sẽ xóa database hiện tại và tạo mới database nếu mô hình của bạn thay đổi. DropCreateDatabaseAlways: Như tên gọi, tùy chọn này sẽ xóa database và tạo database mới mỗi khi bạn chạy ứng dụng bất kể mô hình của bạn có thay đổi hay không. Custom DB Initializer: Nếu 3 tùy chọn trên không đáp ứng được yêu cầu của bạn, bạn có thể tự viết khởi tạo database cho mình. 
	Các chiến lược khởi tạo DB 
	Tạo dữ liệu tự động (Seeding) 
	Các mô hình trong Entity Framework 
		Các thành phần chính trong Entity: 
		Code là mã lệnh tạo thành các lớp đối tượng dữ liệu cho phép thao tác với dữ liệu. 
		Model là sơ đồ gồm các hộp mô tả các thực thể và các đường nối kết mô tả các quan hệ. 
		Database là cơ sở dữ liệu (có thể là SQL Server, Compact SQL Server, Local database, MySQL, Oracle,…) 
		Có 3 cách sử dụng Entity Framework: Code First, Models First, Database First. 
	Các mô hình trong Entity Framework 
		Database first: là phương pháp chỉ nên dùng khi ta đã có sẵn CSDL (không phải tạo), EF Wizard sẽ tạo Model và Code cho ta. Models first: nên dùng khi ta bắt đầu thiết kế CSDL từ đầu (từ chưa có gì). Ta sẽ thiết kế mô hình CSDL (Model) EF sẽ tự tạo code cho ta, sau đó nhờ EF Wizard tạo CSDL.
		Code first: nên dùng khi đã có mô hình CSDL, ta sẽ chỉ viết code từ đó tạo Database. 
	So sánh LinQ to SQL và Entity FrameWork 
		LINQ to SQL Chỉ làm việc với CSDL của SQL Server Tạo ra file .dbml 
		Không hỗ trợ các kiểu phức tạp 
		Không thể tạo CSDL từ đối tượng
		Chỉ có kiểu ánh xạ 1-1 giữa đối tượng class với table/views
		Sử dụng DataContext
		Entity Framework
		Có thể làm việc với các CSDL: Oracle, DB2, MySQL, SQL Server... 
		Tạo ra file .edmx, .csdl, .msl, .ssdl hoặc các file class .cs thông thường
		Hỗ trợ các kiểu phức tạp
		Có thể tạo CSDL từ Model/Code đã thiết kế
		Có thể ánh xạ 1-1, 1-nhiều, nhiều-1, nhiều-nhiều giữa đối tượng entity với table/view
		Sử dụng DbContext, Entity SQL, ObjectContext. 
	 
	Cách migration trong EF Code First 
		Lệnh enable migration: Enable-Migrations
		Tự động hóa migration: AutomaticMigrationsEnabled  = true trong Configuration.cs
		Add-Migration Name 
		Update-database 
	----------------------------------------

#	Bài 60: Các kỹ thuật tăng cường SEO cho website của bạn 
	Các nguyên tắc tối ưu SEO cho website 
		1. Tất cả trang web được thiết kế tối ưu về HTML các thẻ heading, list... 
		2. Mỗi trang có một tiêu đề riêng, meta keywords và meta description. 
		3. Các trang nội dung nên có share facebook, google, các tin liên quan, tag... 
		4. Đường dẫn URL thân thiện dễ đọc và chứa từ khóa.
		5. Trong website các link dẫn ra ngoài cần chèn thuộc tính ref=“no-follow”.
		6. Hạn chế sử dụng ajax với các nội dung cần index vì spider khó crawl data.
		7. Tốc độ load website cần được đảm bảo. 
		8. Nên có sitemap và breadcrumb trong website 
		9. Tối ưu hóa file robots.txt 
		10.Khai báo website với các công cụ quản lý của Google. 

#	Bài 63 Cách đóng gói dự án và publish lên hosting
	ShopOnlineShop.web -> publish
	SQL -> DB -> Backup

#	Bài 65 Tích hợp thanh toán trực tuyến qua Ngân Lượng

#	Bài 66 Đăng nhập với Facebook và Google
	install package facebook, google

	