namespace ShopOnline.Data.Infrastructure
{
    public interface IUnitOfWork
    {
        void Commit();
    }
}