using System;

namespace ShopOnline.Data.Infrastructure
{
    public interface IDbFactory : IDisposable
    {
        ShopOnlineDbContext Init();
    }
}