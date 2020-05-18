using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FindAService_WebForm.Controllers
{
    public class ContentController
    {

        FASDBEntities db = new FindAService_WebForm.FASDBEntities();

        public List<ContentCategory> GetCategoriesByPageSection(FindAService_WebForm.PageSection sectn)
        {
            try
            {
                var categories = (from cc in db.ContentCategories
                                  where cc.PageSection == (int)sectn
                                  select cc).AsEnumerable().Select(x => new ContentCategory
                                  {
                                      ID = x.ID,
                                      CategoryTitle = x.CategoryTitle,
                                      Description = x.Description,
                                      PageSection = x.PageSection,
                                      Increment = x.Increment
                                  }).ToList();

                foreach (var categry in categories)
                {
                    categry.Contents = db.Contents.Where(c => c.Category_ID == categry.ID).OrderBy(o => o.DateCreated).ThenByDescending(o => o.DateCreated).ToList();
                }
                return categories;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<UserComment> GetUserComments()
        {
            var sql = "";
            sql += "SELECT c.ID, User_ID, Owner_ID, Comment, DatetCommented, c.Increment ";
            sql += "FROM UserComments c ";
            sql += "RIGHT JOIN UserIndividuals i ON c.Owner_ID = i.ID ";

            sql += "UNION ";

            sql += "SELECT c.ID, User_ID, Owner_ID, Comment, DatetCommented, c.Increment ";
            sql += "FROM UserComments c ";
            sql += "RIGHT JOIN UserBusinesses b ON c.Owner_ID = b.ID ";

            var resultset_obj = (db.Database.SqlQuery<UserComment>(sql)).Where(x => x != null).ToList();
            var resultset = resultset_obj.OrderBy(x => Guid.NewGuid()).Take(2).ToList();
            return resultset;
        }
    }
}
