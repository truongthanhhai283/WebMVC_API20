using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ShopOnline.Common;
using ShopOnline.Data.Infrastructure;
using ShopOnline.Data.Repositories;
using ShopOnline.Model.Models;

namespace ShopOnline.Service
{
    public interface ICommonService
    {
        Footer GetFooter();
        IEnumerable<Slide> GetSlides();
    }
    public class CommonService : ICommonService
    {
        IFooterRepository _footerRepository;
        IUnitOfWork _unitOfWork;
        ISlideRepository _slideRepository;
        public CommonService(IFooterRepository footerRepository,IUnitOfWork unitOfWork,ISlideRepository slideRepository)
        {
            _footerRepository = footerRepository;
            _unitOfWork = unitOfWork;
            _slideRepository = slideRepository;
        }
        public Footer GetFooter()
        {
            return _footerRepository.GetSingleByCondition(x => x.ID == CommonConstants.DefaultFooterId);
        }

        public IEnumerable<Slide> GetSlides()
        {
            return _slideRepository.GetMulti(x=>x.Status);
        }
    }
}
