using Microsoft.VisualStudio.TestTools.UnitTesting;
using ShopOnline.Data.Infrastructure;
using ShopOnline.Data.Repositories;
using ShopOnline.Model.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ShopOnline.UnitTest.RepositoryTest
{
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
}
