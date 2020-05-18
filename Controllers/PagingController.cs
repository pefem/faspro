using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Serialization;

using FindAService_WebForm.Models;

namespace FindAService_WebForm.Controllers
{
    public class PagingController
    {
        private string CreateLinks(int start, int end, string text)
        {
            try
            {
                var q = (HttpContext.Current.Request["q"] != null) ? "&q=" + HttpContext.Current.Request["q"] : "";
                var loc = (HttpContext.Current.Request["loc"] != null) ? "&loc=" + HttpContext.Current.Request["loc"] : "";
                var t = (HttpContext.Current.Request["t"] != null) ? "&t=" + HttpContext.Current.Request["t"] : "";

                var urlPathAndQuery = HttpContext.Current.Request.Url.PathAndQuery;
                var url = HttpContext.Current.Request.Url.AbsoluteUri.Replace(urlPathAndQuery, "/");
                url += "?p=searchresult" + loc + t + q;
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

                throw;
            }
        }

        public string ShowPages()
        {
            try
            {
                var str = "";
                const int maxPages = 11;
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

                if (pagesAfter <= 4)
                {
                    str = CreateLinks(1, 1, null);  // Show 1st page

                    int pageSubset = totalPages - maxPages - 1 > 1 ? totalPages - maxPages - 1 : 2;
                    str += CreateLinks(pageSubset, pageSubset, "...");   // Show page subset (...)
                    str += CreateLinks(totalPages - maxPages + 3, totalPages, null); // Show last pages

                    return str;
                }

                if (pagesBefore <= 4)
                {
                    str = CreateLinks(1, maxPages - 2, null); // Show 1st pages

                    int pageSubset = maxPages + 2 < totalPages ? maxPages + 2 : totalPages - 1;
                    str += CreateLinks(pageSubset, pageSubset, "...");    // Show page subset (...)
                    str += CreateLinks(totalPages, totalPages, null); // Show last page 

                    return str;
                }

                if (pagesAfter > 4)
                {
                    str = CreateLinks(1, 1, null); // Show 1st pages

                    int pageSubset1 = currentPage - 7 > 1 ? currentPage - 7 : 2;
                    int pageSubset2 = currentPage + 7 < totalPages ? currentPage + 7 : totalPages - 1;

                    str += CreateLinks(pageSubset1, pageSubset1, pageSubset1 == currentPage - 4 ? null : "..."); // Show 1st page subset (...)

                    str += CreateLinks(currentPage - 3, currentPage + 3, null); // Show middle pages

                    // Show 2nd page subset (...)
                    // only show ... if page is contigous to the previous one.
                    str += CreateLinks(pageSubset2, pageSubset2, pageSubset2 == currentPage + 4 ? null : "...");
                    str += CreateLinks(totalPages, totalPages, null); // Show last page

                    return str;
                }

                return str;
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}
