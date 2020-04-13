using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ShopOnline.Data.Infrastructure
{
    public interface IDbFactory:IDisposable
    {
        //Init dbcontext
         ShopOnlineDbContext Init();
    }
}
