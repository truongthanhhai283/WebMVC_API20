namespace ShopOnline.Data.Infrastructure
{
    public class DbFactory : Disposable, IDbFactory
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
}