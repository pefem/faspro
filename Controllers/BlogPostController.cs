using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

using FindAService_WebForm.Models;
using FindAService_WebForm.DataAccessLayer;

namespace FindAService_WebForm.Controllers
{
    public class BlogPostController
    {
        FASDBEntities db = new FASDBEntities();

        public List<BlogPost> GetPosts(string srch, int page = 1)
        {
            try
            {
                page = page <= 0 ? 1 : page;
                var rowsPerPage = 10;

                var sql = "";

                if ((srch != null) && (srch != ""))
                {
                    sql += "SELECT * ";
                    sql += "FROM BlogPosts c ";
                    sql += "WHERE IsPublished = 1 AND IsArchived = 0 AND (CONTAINS((Title, Article, MetaDescription, MetaKeyword), 'FORMSOF(INFLECTIONAL, \"" + srch + "\")') OR FREETEXT((Title, Article, MetaDescription, MetaKeyword), 'FORMSOF(INFLECTIONAL, \"" + srch + "\")'))";
                }
                else
                {
                    sql += "SELECT * ";
                    sql += "FROM BlogPosts c ";
                    sql += "WHERE IsPublished = 1 AND IsArchived = 0";
                }
                var resultset_obj = (db.Database.SqlQuery<BlogPost>(sql)).ToList();

                var resultset = (resultset_obj).ToList()
                                             .OrderByDescending(x => x.Increment)
                                             .ThenBy(x => x.DateCreated.Date)
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

        public BlogPost GetPost(string post_id)
        {
            try
            {
                var sql = "";
                sql += "SELECT * ";
                sql += "FROM BlogPosts ";
                sql += "WHERE increment = " + int.Parse(post_id);

                var result = (db.Database.SqlQuery<BlogPost>(sql)).FirstOrDefault();
                return result;
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
