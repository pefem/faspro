using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Web;
using System.Data;

using FindAService_WebForm.Models;
using FindAService_WebForm.DataAccessLayer;

namespace FindAService_WebForm.Controllers
{
    public class ServicesController
    {
        FASDBEntities db = new FASDBEntities();

        public List<Service> GetServices()
        {
            var randm = new Random();
            return db.Services.ToList().OrderBy(x => randm.Next(0, db.Services.ToList().Count)).Take(25).ToList();
        }
    }
}
