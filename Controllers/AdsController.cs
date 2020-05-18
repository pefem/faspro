using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FindAService_WebForm.Controllers
{
    public class AdsController
    {
        FASDBEntities db = new FASDBEntities();

        public List<Ad> GetAds(int bnnr_dimen)
        {
            try
            {
                var ads = (from ad in db.Ads
                           join pckage in db.AdsPackages on ad.AdsPackage_ID equals pckage.ID
                           where 
                            pckage.BannerDimension == bnnr_dimen && ad.Status == (int)AdsStatus.Published
                           select new
                           {
                               Ads = ad,
                               Package = pckage
                           }).AsEnumerable().Select(x => new Ad
                       {
                           ID = x.Ads.ID,
                           AdsPackage = x.Package,
                           User_ID = x.Ads.User_ID
                       }).ToList();
                foreach (var ad in ads)
                {
                    var campgns = (from cmpgn in db.AdsCampaigns
                                   where cmpgn.Ads_ID == ad.ID
                                   select cmpgn).OrderBy(x => Guid.NewGuid()).Take(1).ToList();

                    foreach (var c in campgns)
                    {
                        var bnrs = db.AdsCampaignBanners.Where(b => b.AdsCampaign_ID == c.ID).ToList();
                        c.AdsCampaignBanners = bnrs.OrderBy(x => Guid.NewGuid()).Take(5).ToList();
                    }
                    ad.AdsCampaigns = campgns;
                }

                if (ads != null)
                {
                    ads = ads.OrderBy(x => Guid.NewGuid()).ToList();
                    return ads.Take(5).ToList();
                }
                else
                {
                    return null;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<Ad> GetOnBoardingAds(int bnnr_dimen)
        {
            try
            {
                var ads = (from ad in db.Ads
                           join pckage in db.AdsPackages on ad.AdsPackage_ID equals pckage.ID
                           where
                            pckage.BannerDimension != bnnr_dimen && ad.Status == (int)AdsStatus.Published
                           select new
                           {
                               Ads = ad,
                               Package = pckage
                           }).AsEnumerable().Select(x => new Ad
                           {
                               ID = x.Ads.ID,
                               AdsPackage = x.Package,
                               User_ID = x.Ads.User_ID
                           }).ToList();
                foreach (var ad in ads)
                {
                    var campgns = (from cmpgn in db.AdsCampaigns
                                   where cmpgn.Ads_ID == ad.ID
                                   select cmpgn).OrderBy(x => Guid.NewGuid()).Take(1).ToList();

                    foreach (var c in campgns)
                    {
                        var bnrs = db.AdsCampaignBanners.Where(b => b.AdsCampaign_ID == c.ID).ToList();
                        c.AdsCampaignBanners = bnrs.OrderBy(x => Guid.NewGuid()).Take(5).ToList();
                    }
                    ad.AdsCampaigns = campgns;
                }

                if (ads != null)
                {
                    ads = ads.OrderBy(x => Guid.NewGuid()).ToList();
                    return ads.Take(5).ToList();
                }
                else
                {
                    return null;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
