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
using FindAService_WebForm.Extensions;

namespace FindAService_WebForm.Controllers
{
    public class NotificationController
    {
        FASDBEntities db = new FASDBEntities();

        public List<UserJobBoxNotification> GetIndividualNotifications(UserIndividual usr, int page = 1)
        {
            try
            {
                page = page <= 0 ? 1 : page;
                var rowsPerPage = 15;

                var deleted = (new HashSet<string>(db.UserJobBoxNotificationStatus.Where(x => x.User_ID == usr.ID && x.Status == (int)JobBoxNotificationStatus.Delete).Select(x => x.Notification_ID)));
                //var resultset_obj = db.UserJobBoxNotifications.Where(n => !deleted.Contains(n.ID) && n.Sender != usr.ID && usr.Country_ID == n.SenderLocation
                //                                                        &&
                //                                                     ((n.Recepient == usr.ID && n.IsGroupMessage != true) || (n.Recepient == usr.Service_ID && n.IsGroupMessage != false))).ToList();

                var resultset_obj = db.UserJobBoxNotifications.Where(n => !deleted.Contains(n.ID) && n.Sender != usr.ID && usr.City_ID == n.RecepientLocation
                                                                        &&
                                                                        usr.RegistrationDate.CompareTo(n.DateSent) < 0
                                                                        &&
                                                                     ((n.Recepient == usr.ID && n.IsGroupMessage != true) || (n.Recepient == usr.Service_ID && n.IsGroupMessage != false))).ToList();

                var resultset = resultset_obj.OrderBy(x => x.Increment)
                                             .Skip((page - 1) * rowsPerPage)
                                             .Take(rowsPerPage)
                                             .OrderByDescending(x => x.DateSent).ToList();

                var totalPages = (int)Math.Ceiling((double)resultset_obj.Count() / rowsPerPage);

                HttpContext.Current.Session["currentPage"] = page;
                HttpContext.Current.Session["rowsPerPage"] = rowsPerPage;
                HttpContext.Current.Session["totalPages"] = totalPages;
                HttpContext.Current.Session["totalResults"] = resultset_obj.Count;

                foreach (var m in resultset)
                {
                    if (db.UserJobBoxNotificationStatus.Where(x => x.Notification_ID == m.ID && x.User_ID == usr.ID).Count() <= 0)
                    {
                        db.UserJobBoxNotificationStatus.Add(new UserJobBoxNotificationStatu
                        {
                            Status = (int)JobBoxNotificationStatus.Unread,
                            User_ID = usr.ID,
                            Group_ID = m.Recepient,
                            Notification_ID = m.ID,
                            ID = Guid.NewGuid().ToString()
                        });
                        db.SaveChanges();
                    }
                }

                return resultset;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public UserJobBoxNotification GetIndividualNotification(UserIndividual usr, int id)
        {
            var msg = db.UserJobBoxNotifications.Where(x => (x.Increment == id && x.Recepient == usr.ID) || (x.Increment == id && x.Recepient == usr.Service_ID)).FirstOrDefault();

            //
            // Mark as read
            //
            var notifStatus = db.UserJobBoxNotificationStatus.Where(x => x.Notification_ID == msg.ID && x.User_ID == usr.ID).FirstOrDefault();
            if (notifStatus != null)
            {
                notifStatus.Status = (int)JobBoxNotificationStatus.Read;
                db.Entry(notifStatus).State = EntityState.Modified;
                db.SaveChanges();
            }

            //
            // Return Notification
            //
            return msg;
        }

        public List<UserJobBoxNotification> GetCompanyNotifications(UserBusiness usr, int page = 1)
        {
            try
            {
                page = page <= 0 ? 1 : page;
                var rowsPerPage = 15;

                var deleted = (new HashSet<string>(db.UserJobBoxNotificationStatus.Where(x => x.User_ID == usr.ID && x.Status == (int)JobBoxNotificationStatus.Delete).Select(x => x.Notification_ID)));
                //var resultset_obj = db.UserJobBoxNotifications.Where(n => !deleted.Contains(n.ID) && n.Sender != usr.ID && usr.Country_ID == n.SenderLocation
                //                                                        &&
                //                                                     ((n.Recepient == usr.ID && n.IsGroupMessage != true) || (n.Recepient == usr.BusinessCategory_ID && n.IsGroupMessage != false))).ToList();

                var resultset_obj = db.UserJobBoxNotifications.Where(n => !deleted.Contains(n.ID) && n.Sender != usr.ID && usr.City_ID == n.RecepientLocation
                                                                        &&
                                                                        usr.RegistrationDate.CompareTo(n.DateSent) < 0
                                                                        &&
                                                                     ((n.Recepient == usr.ID && n.IsGroupMessage != true) || (n.Recepient == usr.BusinessCategory_ID && n.IsGroupMessage != false))).ToList();

                var resultset = resultset_obj.OrderBy(x => x.Increment)
                                             .Skip((page - 1) * rowsPerPage)
                                             .Take(rowsPerPage)
                                             .OrderByDescending(x => x.DateSent).ToList();

                var totalPages = (int)Math.Ceiling((double)resultset_obj.Count() / rowsPerPage);

                HttpContext.Current.Session["currentPage"] = page;
                HttpContext.Current.Session["rowsPerPage"] = rowsPerPage;
                HttpContext.Current.Session["totalPages"] = totalPages;
                HttpContext.Current.Session["totalResults"] = resultset_obj.Count;

                foreach (var m in resultset)
                {
                    if (db.UserJobBoxNotificationStatus.Where(x => x.Notification_ID == m.ID && x.User_ID == usr.ID).Count() <= 0)
                    {
                        db.UserJobBoxNotificationStatus.Add(new UserJobBoxNotificationStatu
                        {
                            Status = (int)JobBoxNotificationStatus.Unread,
                            User_ID = usr.ID,
                            Group_ID = m.Recepient,
                            Notification_ID = m.ID,
                            ID = Guid.NewGuid().ToString()
                        });
                        db.SaveChanges();
                    }
                }

                return resultset;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public UserJobBoxNotification GetCompanyNotification(UserBusiness usr, int id)
        {
            var msg = db.UserJobBoxNotifications.Where(x => (x.Increment == id && x.Recepient == usr.ID) || (x.Increment == id && x.Recepient == usr.BusinessCategory_ID)).FirstOrDefault();

            //
            // Mark as read
            //
            var notifStatus = db.UserJobBoxNotificationStatus.Where(x => x.Notification_ID == msg.ID && x.User_ID == usr.ID).FirstOrDefault();
            if (notifStatus != null)
            {
                notifStatus.Status = (int)JobBoxNotificationStatus.Read;
                db.Entry(notifStatus).State = EntityState.Modified;
                db.SaveChanges();
            }

            //
            // Return Notification
            //
            return msg;
        }

        public int GetRecentIndividualNotificationCount(UserIndividual usr)
        {
            try
            {
                var results = (from n in db.UserJobBoxNotifications
                               where
                                   n.Sender != usr.ID && usr.City_ID == n.RecepientLocation
                                   &&
                                   usr.RegistrationDate.CompareTo(n.DateSent) < 0
                                   &&
                                   ((n.Recepient == usr.ID && n.IsGroupMessage != true) || (n.Recepient == usr.Service_ID && n.IsGroupMessage != false))
                               select n).ToList();

                var count = 0;
                foreach (var n in results)
                {
                    var instatus = (from s in db.UserJobBoxNotificationStatus
                                    where
                                        s.User_ID == usr.ID
                                        &&
                                        s.Group_ID == n.Recepient
                                        &&
                                        s.Notification_ID == n.ID
                                        &&
                                        (s.Status == (int)JobBoxNotificationStatus.Unread || s.Status == (int)JobBoxNotificationStatus.Read || s.Status == (int)JobBoxNotificationStatus.Delete)
                                    select s).FirstOrDefault();
                    if (instatus == null)
                    {
                        count += 1;
                    }
                }
                return count;
            }
            catch (Exception)
            {
                return 0;
            }
        }

        public int GetRecentBusinessNotificationCount(UserBusiness usr)
        {
            try
            {
                var results = (from n in db.UserJobBoxNotifications
                               where
                                   n.Sender != usr.ID && usr.City_ID == n.RecepientLocation
                                   &&
                                   usr.RegistrationDate.CompareTo(n.DateSent) < 0
                                   &&
                                   ((n.Recepient == usr.ID && n.IsGroupMessage != true) || (n.Recepient == usr.BusinessCategory_ID && n.IsGroupMessage != false))
                               select n).ToList();

                var count = 0;
                foreach (var n in results)
                {
                    var instatus = (from s in db.UserJobBoxNotificationStatus
                                    where
                                        s.User_ID == usr.ID
                                        &&
                                        s.Group_ID == n.Recepient
                                        &&
                                        s.Notification_ID == n.ID
                                        &&
                                        (s.Status == (int)JobBoxNotificationStatus.Unread || s.Status == (int)JobBoxNotificationStatus.Read || s.Status == (int)JobBoxNotificationStatus.Delete)
                                    select s).FirstOrDefault();
                    if (instatus == null)
                    {
                        count += 1;
                    }
                }
                return count;
            }
            catch (Exception)
            {
                return 0;
            }
        }

        private string CreateLinks(int start, int end, string text)
        {
            try
            {
                var s = HttpContext.Current.Request["s"];
                var u = HttpContext.Current.Request["u"];

                var urlPathAndQuery = HttpContext.Current.Request.Url.PathAndQuery;
                var url = HttpContext.Current.Request.Url.AbsoluteUri.Replace(urlPathAndQuery, "/");
                url += "?p=individual&s=" + s + "&u=" + u;
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

        public void DeleteNotification(UserJobBoxNotificationStatu n)
        {
            var m = db.UserJobBoxNotificationStatus.Where(x => x.Notification_ID == n.Notification_ID && x.User_ID == n.User_ID && x.Group_ID == n.Group_ID).FirstOrDefault();
            if (null != m)
            {
                m.Status = (int)JobBoxNotificationStatus.Delete;
                db.Entry(m).State = EntityState.Modified;
                db.SaveChanges();
            }
        }

    }
}
