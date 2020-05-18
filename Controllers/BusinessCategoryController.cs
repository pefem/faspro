using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FindAService_WebForm.Controllers
{
    public class BusinessCategoryController
    {
        FASDBEntities db = new FASDBEntities();
        public List<BusinessCategory> GetBusinessCategories()
        {
            try
            {
                return db.BusinessCategories.ToList();
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
