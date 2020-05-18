using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Web;
using System.Web.Helpers;
using System.Web.Script;
using System.Web.Script.Serialization;

using FindAService_WebForm;

namespace FindAService_WebForm.Controllers
{
    public class LocationController
    {
        FASDBEntities db = new FindAService_WebForm.FASDBEntities();

        public City GetCity(string loc_name)
        {
            try
            {
                var city = (from c in db.Cities
                            join s in db.States on c.State_ID equals s.ID
                            join cn in db.Countries on s.Country_ID equals cn.ID
                            where c.CityName == loc_name || s.StateName == loc_name || cn.CountryName == loc_name
                            select c).FirstOrDefault();

                if (city == null)
                {
                    city = db.Cities.FirstOrDefault();
                }

                return city;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public string GetStatesByCountry(Country c)
        {
            db.Configuration.ProxyCreationEnabled = false;
            var serializer = new JavaScriptSerializer();
            var query = db.States.Where(x => x.Country_ID == c.ID).ToList();
            var states = serializer.Serialize(query);
            return states;
        }

        public string GetCitiesByState(State s)
        {
            db.Configuration.ProxyCreationEnabled = false;
            var serializer = new JavaScriptSerializer();
            var query = db.Cities.Where(x => x.State_ID == s.ID).ToList();
            var cities = serializer.Serialize(query);
            return cities;
        }
    }
}
