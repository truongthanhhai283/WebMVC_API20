using System.Collections.Generic;
using System.Linq;
using ShopOnline.Data.Infrastructure;
using ShopOnline.Model.Models;

namespace ShopOnline.Data.Repositories
{
    public interface IProductCategoryRepository
    {
        //Định nghĩa các phương thức để sử dụng
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
}