using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Web;

//using FindAService_WebForm.Models;
using FindAService_WebForm.Controllers;

namespace FindAService_WebForm.Controllers
{
    public class BusinessUserController
    {
        FASDBEntities db = new FASDBEntities();

        public List<UserBusiness> GetUsers()
        {
            try
            {
                var randm = new Random();
                var cntry_code = HttpContext.Current.Request.Cookies["page"]["location"];
                var usrs = (from u in db.UserBusinesses
                            join c in db.Countries on u.Country_ID equals c.ID
                            where c.WebCode == cntry_code && u.BusinessCategory_ID != null && u.IsQuarantined != true
                            select u).ToList();
                usrs = usrs.OrderBy(x => randm.Next(0, usrs.Count)).Take(25).ToList();
                return usrs;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<UserBusiness> GetRelatedUsers(UserBusiness usr)
        {
            try
            {
                var randm = new Random();
                var cntry_code = HttpContext.Current.Request.Cookies["page"]["location"];
                var usrs = (from u in db.UserBusinesses
                            join c in db.Countries on u.Country_ID equals c.ID
                            where c.WebCode == cntry_code
                            && u.BusinessCategory_ID == usr.BusinessCategory_ID && u.ID != usr.ID
                            && u.BusinessCategory_ID != null && u.IsQuarantined != true
                            select u).ToList();
                usrs = usrs.OrderBy(x => Guid.NewGuid()).Take(5).ToList();
                return usrs;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<UserBusiness> GetSuggestedUsers(UserBusiness usr)
        {
            try
            {
                var randm = new Random();
                var cntry_code = HttpContext.Current.Request.Cookies["page"]["location"];
                var usrs = (from u in db.UserBusinesses
                            join c in db.Countries on u.Country_ID equals c.ID
                            where c.WebCode == cntry_code && u.ID != usr.ID && u.BusinessCategory_ID != null && u.IsQuarantined != true
                            select u).ToList();
                usrs = usrs.OrderBy(x => Guid.NewGuid()).Take(5).ToList();
                return usrs;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public UserBusiness GetUser(UserBusiness user)
        {
            try
            {
                var usr = (from u in db.UserBusinesses
                           join cntry in db.Countries on u.Country_ID equals cntry.ID
                           join stat in db.States on cntry.ID equals stat.Country_ID
                           join city in db.Cities on stat.ID equals city.State_ID
                           where u.Email == user.Email && u.IsQuarantined != true
                           select u).FirstOrDefault();

                return usr;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<UserBusiness> GetPagedUsers(BusinessCategory bcatgry, string country, string state, string city, int page = 1)
        {
            try
            {
                page = page <= 0 ? 1 : page;
                var rowsPerPage = 10;


                var resultset_obj = (dynamic)null;

                if (bcatgry.ID != null)
                {
                    resultset_obj = (from u in db.UserBusinesses
                                     join s in db.BusinessCategories on u.BusinessCategory_ID equals s.ID
                                     join ci in db.Cities on u.City_ID equals ci.ID
                                     join st in db.States on u.State_ID equals st.ID
                                     join co in db.Countries on u.Country_ID equals co.ID
                                     where s.ID == bcatgry.ID && (ci.ID == city && st.ID == state && co.ID == country) && u.BusinessCategory_ID != null && u.IsQuarantined != true
                                     select u).ToList();
                }
                else
                {
                    resultset_obj = (from u in db.UserBusinesses
                                     join s in db.BusinessCategories on u.BusinessCategory_ID equals s.ID
                                     join ci in db.Cities on u.City_ID equals ci.ID
                                     join st in db.States on u.State_ID equals st.ID
                                     join co in db.Countries on u.Country_ID equals co.ID
                                     where (ci.ID == city && st.ID == state && co.ID == country) && u.BusinessCategory_ID != null && u.IsQuarantined != true
                                     select u).ToList();
                }

                var resultset = ((List<UserBusiness>)resultset_obj).OrderBy(x => x.Increment)
                                             .Skip((page - 1) * rowsPerPage)
                                             .Take(rowsPerPage)
                                             .ToList();

                var totalResults = ((List<UserBusiness>)resultset_obj).Count;
                var totalPages = (int)Math.Ceiling((double)totalResults / rowsPerPage);

                HttpContext.Current.Session["currentPage"] = page;
                HttpContext.Current.Session["rowsPerPage"] = rowsPerPage;
                HttpContext.Current.Session["totalPages"] = totalPages;
                HttpContext.Current.Session["totalResults"] = totalResults;

                return resultset;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<UserBusiness> SearchFor(string categry, string location, int page = 1)
        {
            try
            {
                page = page <= 0 ? 1 : page;
                var rowsPerPage = 10;

                var resultset_obj = (dynamic)null;
                var cntry_code = HttpContext.Current.Request.Cookies["page"]["location"];

                if (location != null && location != "")
                {
                    if (categry != null && categry != "")
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND FREETEXT(bc.BusinessCategoryTitle, '" + categry + "') AND (FREETEXT(ci.CityName, '" + location + "') OR FREETEXT(st.StateName, '" + location + "') OR FREETEXT(cn.CountryName, '" + location + "'))";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                    else
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND (FREETEXT(ci.CityName, '" + location + "') OR FREETEXT(st.StateName, '" + location + "') OR FREETEXT(cn.CountryName, '" + location + "'))";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                }
                else
                {
                    if ((location == null || location == "") && categry == null)
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND cn.WebCode = '" + cntry_code + "'";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                    else
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND FREETEXT(bc.BusinessCategoryTitle, '" + categry + "') AND cn.WebCode = '" + cntry_code + "'";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                }

                var resultset = ((List<UserBusiness>)resultset_obj).OrderBy(x => x.Increment)
                                             .Skip((page - 1) * rowsPerPage)
                                             .Take(rowsPerPage)
                                             .ToList();

                var totalPages = (int)Math.Ceiling((double)resultset_obj.Count / rowsPerPage);

                HttpContext.Current.Session["currentPage"] = page;
                HttpContext.Current.Session["rowsPerPage"] = rowsPerPage;
                HttpContext.Current.Session["totalPages"] = totalPages;
                HttpContext.Current.Session["totalResults"] = resultset_obj.Count;

                return resultset;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<UserBusiness> AdsSearchFor(string categry, string location, int page = 1)
        {
            try
            {
                page = page <= 0 ? 1 : page;
                var rowsPerPage = 5;

                var resultset_obj = (dynamic)null;
                var cntry_code = HttpContext.Current.Request.Cookies["page"]["location"];

                if (location != null && location != "")
                {
                    if (categry != null && categry != "")
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "INNER JOIN Ads ads ON u.ID = ads.User_ID ";
                        sql += "INNER JOIN AdsPackages pckg ON ads.AdsPackage_ID = pckg.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND FREETEXT(bc.BusinessCategoryTitle, '" + categry + "') AND (FREETEXT(ci.CityName, '" + location + "') OR FREETEXT(st.StateName, '" + location + "') OR FREETEXT(cn.CountryName, '" + location + "')) AND pckg.BannerDimension = '" + ((int)AdsBannerDimension.Dimen_580x380) + "' AND ads.status = '" + ((int)AdsStatus.Published) + "'";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                    else
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "INNER JOIN Ads ads ON u.ID = ads.User_ID ";
                        sql += "INNER JOIN AdsPackages pckg ON ads.AdsPackage_ID = pckg.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND (FREETEXT(ci.CityName, '" + location + "') OR FREETEXT(st.StateName, '" + location + "') OR FREETEXT(cn.CountryName, '" + location + "')) AND pckg.BannerDimension = '" + ((int)AdsBannerDimension.Dimen_580x380) + "' AND ads.status = '" + ((int)AdsStatus.Published) + "'";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                }
                else
                {
                    if ((location == null || location == "") && categry == null)
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "INNER JOIN Ads ads ON u.ID = ads.User_ID ";
                        sql += "INNER JOIN AdsPackages pckg ON ads.AdsPackage_ID = pckg.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND cn.WebCode = '" + cntry_code + "' AND pckg.BannerDimension = '" + ((int)AdsBannerDimension.Dimen_580x380) + "' AND ads.status = '" + ((int)AdsStatus.Published) + "'";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                    else
                    {
                        var sql = "";
                        sql += "SELECT * ";
                        sql += "FROM UserBusinesses u ";
                        sql += "INNER JOIN BusinessCategories bc ON u.BusinessCategory_ID = bc.ID ";
                        sql += "INNER JOIN Cities ci ON u.City_ID = ci.ID ";
                        sql += "INNER JOIN States st ON ci.State_ID = st.ID ";
                        sql += "INNER JOIN Countries cn ON st.Country_ID = cn.ID ";
                        sql += "INNER JOIN Ads ads ON u.ID = ads.User_ID ";
                        sql += "INNER JOIN AdsPackages pckg ON ads.AdsPackage_ID = pckg.ID ";
                        sql += "WHERE u.BusinessCategory_ID IS NOT NULL AND u.IsQuarantined = 0 AND FREETEXT(bc.BusinessCategoryTitle, '" + categry + "') AND cn.WebCode = '" + cntry_code + "' AND pckg.BannerDimension = '" + ((int)AdsBannerDimension.Dimen_580x380) + "' AND ads.status = '" + ((int)AdsStatus.Published) + "'";
                        resultset_obj = (db.Database.SqlQuery<UserBusiness>(sql)).ToList();
                    }
                }

                var resultset = ((List<UserBusiness>)resultset_obj).OrderBy(x => Guid.NewGuid()).ToList()
                                             .Take(rowsPerPage)
                                             .ToList();

                var totalPages = (int)Math.Ceiling((double)resultset_obj.Count / rowsPerPage);

                HttpContext.Current.Session["currentPage"] = page;
                HttpContext.Current.Session["rowsPerPage"] = rowsPerPage;
                HttpContext.Current.Session["totalPages"] = totalPages;
                HttpContext.Current.Session["totalResults"] = resultset_obj.Count;

                return resultset;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<UserComment> GetUserComments(UserBusiness usr, int page = 1)
        {
            try
            {
                page = page <= 0 ? 1 : page;
                var rowsPerPage = 5;

                var sql = "";
                sql += "SELECT c.ID, User_ID, Owner_ID, Comment, DatetCommented, c.Increment ";
                sql += "FROM UserComments c ";
                sql += "RIGHT JOIN UserIndividuals i ON c.Owner_ID = i.ID ";
                sql += "WHERE c.User_ID = '" + usr.ID + "' AND i.IsQuarantined = 0 ";

                sql += "UNION ";

                sql += "SELECT c.ID, User_ID, Owner_ID, Comment, DatetCommented, c.Increment ";
                sql += "FROM UserComments c ";
                sql += "RIGHT JOIN UserBusinesses b ON c.Owner_ID = b.ID ";
                sql += "WHERE c.User_ID = '" + usr.ID + "' AND b.IsQuarantined = 0";

                var resultset_obj = (db.Database.SqlQuery<UserComment>(sql)).ToList();

                var resultset = resultset_obj.ToList()
                                             .OrderByDescending(x => x.DatetCommented.Date)
                                             .ThenBy(x => x.DatetCommented.TimeOfDay)
                                             .Skip((page - 1) * rowsPerPage)
                                             .Take(rowsPerPage)
                                             .ToList();

                var totalPages = (int)Math.Ceiling((double)resultset_obj.Count() / rowsPerPage);

                HttpContext.Current.Session["currentPage"] = page;
                HttpContext.Current.Session["rowsPerPage"] = rowsPerPage;
                HttpContext.Current.Session["totalPages"] = totalPages;
                HttpContext.Current.Session["totalResults"] = resultset_obj.Count;

                return resultset;
            }
            catch (Exception)
            {
                return null;
            }
        }

        private string CreateLinks(int start, int end, string text)
        {
            try
            {
                var s = (null != HttpContext.Current.Request["s"]) ? "&s=" + HttpContext.Current.Request["s"] : "";
                var u = (null != HttpContext.Current.Request["u"]) ? "&u=" + HttpContext.Current.Request["u"] : "";
                var m = (null != HttpContext.Current.Request["m"]) ? "&m=" + HttpContext.Current.Request["m"] : "";
                var t = (null != HttpContext.Current.Request["t"]) ? "&t=" + HttpContext.Current.Request["t"] : "";
                var c = (null != HttpContext.Current.Request["c"]) ? "&c=" + HttpContext.Current.Request["c"] : "";
                var tb = (null != HttpContext.Current.Request["tb"]) ? "&tb=" + HttpContext.Current.Request["tb"] : "";
                var p = (null != HttpContext.Current.Request["p"]) ? "?p=" + HttpContext.Current.Request["p"] : "";

                var urlPathAndQuery = HttpContext.Current.Request.Url.PathAndQuery;
                var url = HttpContext.Current.Request.Url.AbsoluteUri.Replace(urlPathAndQuery, "/");
                url += p + tb + s + u + m + t + c;
                var currentPage = (int)HttpContext.Current.Session["currentPage"];
                var str = "";
                for (int i = start; i <= end; i++)
                {
                    str += "<a " + ((i == currentPage) ? "current" : "") + " href=\"" + url + "&page=" + i.ToString() + "\">" + (text ?? i.ToString()) + "</a>";
                }
                return str;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public string ShowPages()
        {
            try
            {
                var str = "";
                const int maxPages = 7;
                int currentPage = (int)HttpContext.Current.Session["currentPage"];
                int totalPages = (int)HttpContext.Current.Session["totalPages"];
                int rowsPerPage = (int)HttpContext.Current.Session["rowsPerPage"];

                if (totalPages <= maxPages)
                {
                    str = CreateLinks(1, (int)totalPages, null);
                    return str;
                }

                int pagesBefore = currentPage - 1;
                int pagesAfter = totalPages - currentPage;

                if (pagesAfter <= 3)
                {
                    str = CreateLinks(1, 1, null);  // Show 1st page

                    int pageSubset = totalPages - maxPages - 1 > 1 ? totalPages - maxPages - 1 : 2;
                    str += CreateLinks(pageSubset, pageSubset, "...");   // Show page subset (...)
                    str += CreateLinks(totalPages - maxPages + 3, totalPages, null); // Show last pages

                    return str;
                }

                if (pagesBefore <= 3)
                {
                    str = CreateLinks(1, maxPages - 2, null); // Show 1st pages

                    int pageSubset = maxPages + 2 < totalPages ? maxPages + 2 : totalPages - 1;
                    str += CreateLinks(pageSubset, pageSubset, "...");    // Show page subset (...)
                    str += CreateLinks(totalPages, totalPages, null); // Show last page 

                    return str;
                }

                if (pagesAfter > 3)
                {
                    str = CreateLinks(1, 1, null); // Show 1st pages

                    int pageSubset1 = currentPage - 5 > 1 ? currentPage - 5 : 2;
                    int pageSubset2 = currentPage + 5 < totalPages ? currentPage + 5 : totalPages - 1;

                    str += CreateLinks(pageSubset1, pageSubset1, pageSubset1 == currentPage - 3 ? null : "..."); // Show 1st page subset (...)

                    str += CreateLinks(currentPage - 2, currentPage + 2, null); // Show middle pages

                    // Show 2nd page subset (...)
                    // only show ... if page is contigous to the previous one.
                    str += CreateLinks(pageSubset2, pageSubset2, pageSubset2 == currentPage + 3 ? null : "...");
                    str += CreateLinks(totalPages, totalPages, null); // Show last page

                    return str;
                }

                return str;
            }
            catch (Exception)
            {
                return null;
            }
        }

    }
}
