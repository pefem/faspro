using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

using System.Data.SqlClient;
using FindAService_WebForm.Models;

namespace FindAService_WebForm.DataAccessLayer
{
    //public class FASDALContext : DbContext
    //{
    //    public FASDALContext()
    //        : base("FASDALContext")
    //    {}

    //    public DbSet<UserAuthentication> UserAuthentications { get; set; }
    //    public DbSet<UserIndividual> Users { get; set; }
    //    public DbSet<UserBusiness> UserBusinesses { get; set; }
    //    public DbSet<UserPortfolioItem> UserPortfolioItems { get; set; }
    //    public DbSet<UserReview> UserReviews { get; set; }

    //    public DbSet<Country> Countries { get; set; }
    //    public DbSet<State> States { get; set; }
    //    public DbSet<City> Cities { get; set; }

    //    public DbSet<Ads> Ads { get; set; }
    //    public DbSet<AdsCampaign> AdsCampaigns { get; set; }
    //    public DbSet<AdsCampaignBanner> AdsCampaignBanners { get; set; }
    //    public DbSet<AdsPackage> AdsPackages { get; set; }
    //    public DbSet<AccountListing> AccountListings { get; set; }
    //    public DbSet<AccountListingPackage> AccountListingPackages { get; set; }

    //    public DbSet<Service> Services { get; set; }
    //    public DbSet<BusinessCategory> BusinessCategories { get; set; }

    //    public DbSet<Content> Contents { get; set; }
    //}
}
