using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Reflection;

namespace FindAService_WebForm
{
    public enum PageSection
    {
        [Description("Header - Menu Section")]
        header_mnu,

        [Description("Homepage - Banner Footer Menu Section")]
        homepage_bnr_ftr_mnu,

        [Description("Homepage - Mobile Apps Advert Section")]
        homepage_apps_ads,

        [Description("Homepage - How It Works Section")]
        homepage_howitwrk,

        [Description("Homepage - Reviewed Users Section")]
        homepage_revwd_usr,

        [Description("Footer - MenuList Section")]
        footr_mnulst,

        [Description("Footer - Newsletter Section")]
        footr_newsltr,

        [Description("Footer - Contact Email Section")]
        footr_cntact_email,

        [Description("Footer - Contact Phone Number Section")]
        footr_cntact_phone,

        [Description("Footer - Menu Section")]
        footr_menu
    }

    public enum UserType
    {
        Individual,
        Business
    }

    public enum AdsStatus
    {
        Pending,
        Published,
        Expired,
        Renewed
    }

    public enum AdsBannerDimension
    {
        [Description("580 x 380 Campaign Banner")]
        Dimen_580x380,

        [Description("266 x 188 Campaign Banner")]
        Dimen_266x188,

        [Description("280x136 Campaign Banner")]
        Dimen_280x136
    }

    public enum JobBoxNotificationStatus
    {
        Unseen,
        Unread,
        Read,
        Delete
    }

    public enum PageTemplate
    {
        [Description("Contact Page Template")]
        ContactPage,

        [Description("Option Selection Template")]
        SelectionPage,

        [Description("Article Template")]
        ArticlePage,

        [Description("Info Template")]
        InfoPage,

        [Description("Info Template With Category")]
        InfoPageWithCategory
    }

    public static class Enums
    {
        public static string GetEnumDescription(Enum value)
        {
            FieldInfo fi = value.GetType().GetField(value.ToString());

            DescriptionAttribute[] attributes =
                (DescriptionAttribute[])fi.GetCustomAttributes(
                typeof(DescriptionAttribute),
                false);

            if (attributes != null &&
                attributes.Length > 0)
                return attributes[0].Description;
            else
                return value.ToString();
        }
    }
}