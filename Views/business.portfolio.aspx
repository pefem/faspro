﻿<%@ Page Title="" Language="C#" MasterPageFile="Shared/BusinessPage.Master" AutoEventWireup="true" CodeBehind="business.portfolio.aspx.cs" Inherits="FindAService_WebForm.CProjectPhotos" EnableEventValidation="false" %>

<asp:Content ID="script_area" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/business.script.js" type="text/javascript"></script>
    <script src="/Scripts/business.portfolio.script.js" type="text/javascript"></script>
    <script src="/Scripts/xhr.script.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.business.portfolio.account.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.business.style.css" type="text/css" />
</asp:Content>
<asp:Content ID="menu_area" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var businessCntr = new FindAService_WebForm.Controllers.BusinessUserController();
        var adsCntr = new FindAService_WebForm.Controllers.AdsController();
        var user = businessCntr.GetUser(new FindAService_WebForm.UserBusiness
        {
            Email = Request["u"]
        });

        var user_city = db.Cities.Find(user.City_ID);
        var user_state = db.States.Find(user.State_ID);
        var user_country = db.Countries.Find(user.Country_ID);
        var user_businesscategory = db.Services.Find(user.BusinessCategory_ID);

        var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
        if (Session["user_account_active"] == null || ((bool)Session["user_account_active"]) != true)
        {
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><a href=".">Home</a></div>
        <!--<div menu-obj="item"><a href="?p=advertise">Advertise</a></div>-->
        <div menu-obj="item"><a href="?p=blog">Blog</a></div>
        <div menu-obj="item"><a href="?p=login">Login</a></div>
        <div menu-obj="item" aria-selected="true"><a href="?p=signup">Sign Up</a></div>
    </div>
    <%
        }
        else
        {
            var email = "";
            var name = "";

            var iusr = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
            {
                Email = Session["user_account_email"].ToString()
            });
            if (iusr == null)
            {
                var busr = businessCntr.GetUser(new FindAService_WebForm.UserBusiness
                {
                    Email = Session["user_account_email"].ToString()
                });
                if (busr != null)
                {
                    email = busr.Email.ToString();
                    name = busr.BusinessName.ToString();
                }
            }
            else
            {
                email = iusr.Email.ToString();
                name = iusr.FirstName.ToString();
            }
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><span text><a href="?p=account&u=<% Response.Write(email); %>"><% Response.Write(name); %></a></span></div>
        <div menu-obj="item"><span text><a href="?p=account&tb=3&mode=cinf&u=<% Response.Write(email); %>">Settings</a></span></div>
        <div menu-obj="item"><span text><a href="?p=blog">Blog</a></span></div>
        <div menu-obj="item"><span text><a href="?p=logout">Logout</a></span></div>
    </div>
    <%
        }
    %>
</asp:Content>
<asp:Content ID="main_body_lft" ContentPlaceHolderID="main_body_lft" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var notifCntrllr = new FindAService_WebForm.Controllers.NotificationController();
        var businessCntr = new FindAService_WebForm.Controllers.BusinessUserController();
        var user = businessCntr.GetUser(new FindAService_WebForm.UserBusiness
        {
            Email = Request["u"]
        });
        if (user != null)
        {
            var bizcategory = db.BusinessCategories.Find(user.BusinessCategory_ID).BusinessCategoryTitle;

            var user_city = db.Cities.Find(user.City_ID);
            var user_state = db.States.Find(user.State_ID);
            var user_country = db.Countries.Find(user.Country_ID);
            var user_businesscategory = db.Services.Find(user.BusinessCategory_ID);
    %>
    <input type="hidden" id="txtLati" value="<% Response.Write((user != null) ? user_city.Latitude : ""); %>" />
    <input type="hidden" id="txtLong" value="<% Response.Write((user != null) ? user_city.Longitude : ""); %>" />
    <div layout-obj="coporate">
        <div coporate-obj="hdr" style="background-image: url('?p=cover&url=<% Response.Write(user.CoverImageUrl); %>');">
            <div hdr-obj="logo">
                <div info-obj="phldr"><i class="fa fa-user"></i></div>
                <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? user.ImageUrl : ""); %>')"></div>
            </div>
            <div hdr-obj="title">
                <% Response.Write((user != null) ? (user.BusinessName) : ""); %>
            <%
            if (user.IsCertified)
            {
            %>
            <div title-obj="certify">
                <div certify-obj="ok"></div>
            </div>
            <%
                }
            %>
            </div>

            <div hdr-obj="rating">
                <form action="?p=dorating&t=business&s=<% Response.Write(Request["s"]); %>&u=<% Response.Write(Request["u"]); %>" method="post" enctype="application/x-www-form-urlencoded">
                    <%
                        for (var i = 1; i <= 5; i++)
                        {
                    %>
                    <div rating-obj="star" indx="<% Response.Write(i); %>">
                        <i class="fa fa-star"></i>
                        <input type="hidden" name="<% Response.Write("star" + i + "_txt"); %>" />
                    </div>
                    <% 
                        }
                    %>
                    <div>
                        <input type="hidden" name="fname_txt" />
                        <input type="hidden" name="lname_txt" />
                        <input type="hidden" name="email_txt" />
                        <input type="hidden" name="owner_txt" />
                        <input type="hidden" name="usrid_txt" value="<% Response.Write(user.ID); %>" />
                    </div>
                </form>
            </div>

        </div>
        <div coporate-obj="bdy">
            <div bdy-obj="left-pane">
                <ul>
                    <li>
                        <div type="hdr"><span>About Company</span></header></div>
                        <div type="lst">
                            <ul>
                                <li abt>
                                    <div><span><% Response.Write(user.BusinessDescription); %></span></div>
                                </li>
                            </ul>
                        </div>
                    </li>
                    <li>
                        <div type="rating-mtr">
                            <%
                                var rating = db.UserRatings.Where(x => x.User_ID == user.ID).ToList();

                                var star_1 = 0;
                                var star_2 = 0;
                                var star_3 = 0;
                                var star_4 = 0;
                                var star_5 = 0;

                                if (rating != null)
                                {
                                    foreach (var r in rating)
                                    {
                                        star_1 += ((rating != null) && (int.Parse(r.Star1) == 1)) ? 1 : 0;
                                        star_2 += ((rating != null) && (int.Parse(r.Star2) == 1)) ? 1 : 0;
                                        star_3 += ((rating != null) && (int.Parse(r.Star3) == 1)) ? 1 : 0;
                                        star_4 += ((rating != null) && (int.Parse(r.Star4) == 1)) ? 1 : 0;
                                        star_5 += ((rating != null) && (int.Parse(r.Star5) == 1)) ? 1 : 0;
                                    }
                                }

                                var ttal_rate_sum = ((star_1 * 1) + (star_2 * 2) + (star_3 * 3) + (star_4 * 4) + (star_5 * 5));
                                var ttal_rate_cnt = (star_1 + star_2 + star_3 + star_4 + star_5);
                                double ttal_rate = (ttal_rate_sum > 0) ? Math.Round((double)((double)ttal_rate_sum / (double)ttal_rate_cnt), 1) : 0;
                                Math.Ceiling(ttal_rate);
                            %>
                            <div hdr-obj="title"><% Response.Write((ttal_rate.ToString().Length <= 1) ? (ttal_rate.ToString() + ".0") : ttal_rate.ToString()); %></div>
                            <div hdr-obj="rating-wrappr">
                                <div wrappr-obj="rating">
                                    <%
                                        var whole_part = (int)Math.Truncate(ttal_rate);
                                        var decimal_prt = ttal_rate - Math.Truncate(ttal_rate);
                                        //
                                        for (var i = 1; i <= 5; i++)
                                        {
                                            var percent = 0.0;
                                            if (i <= Math.Ceiling(ttal_rate))
                                            {
                                                percent = (i <= whole_part) ? 100 : (decimal_prt * 100);
                                            }
                                    %>
                                    <div rating-obj="star" indx="<% Response.Write(i); %>">
                                        <i class="fa fa-star"></i>
                                        <div star-obj="percent" style="width: <% Response.Write(percent); %>%"></div>
                                    </div>
                                    <%
                                        }
                                    %>
                                </div>
                                <div wrappr-obj="hint"><% Response.Write(((int)ttal_rate_sum > 1) ? ttal_rate_sum + " ratings" : ttal_rate_sum + " rating"); %></div>
                            </div>
                        </div>
                    </li>
                    <li separatr></li>
                    <li>
                        <div type="hdr"><span>Services</span></header></div>
                        <div type="lst">
                            <%
                                                  var solutns = db.UserSolutions.Where(x => x.User_ID == user.ID).ToList();
                                                  foreach (var solutn in solutns)
                                                  {
                            %>
                            <ul>
                                <li>
                                    <div>- <% Response.Write(solutn.Title); %></div>
                                </li>
                            </ul>
                            <%
                                }
                            %>
                        </div>
                        <div type="hdr"><span>Contact Info</span></header></div>
                        <div type="lst">
                            <ul>
                                <li>
                                    <div lst-obj="hdr">Contact Address:</div>
                                </li>
                                <li>
                                    <div><% Response.Write((user != null) ? user.ContactAddress : ""); %></div>
                                    <div><% Response.Write((user != null) ? (user_city.CityName + ", " + user_state.StateName + ". " + user_country.CountryName) : ""); %></div>
                                </li>
                                <li>
                                    <div lst-obj="hdr">Website:</div>
                                </li>
                                <li>
                                    <div><% Response.Write((user != null) ? user.Website : ""); %></div>
                                </li>
                                <li>
                                    <div lst-obj="hdr">Email Address:</div>
                                </li>
                                <li>
                                    <div><% Response.Write((user != null) ? user.Email : ""); %></div>
                                </li>
                                <li>
                                    <div lst-obj="hdr">Phone Number:</div>
                                </li>
                                <li>
                                    <div><% Response.Write((user != null) ? user.ContactNumber : ""); %></div>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>
            <div bdy-obj="right-pane">
                <div layout-obj="tab">
                    <div tab-obj="btn" class="info" form="iform" selected="false"><a href="?p=business&s=<% Response.Write(Request["s"]); %>&u=<% Response.Write(Request["u"]); %>">Info</a></div>
                    <div tab-obj="btn" class="portfolio" form="iform" selected="true"><span><a href="?p=business&s=<% Response.Write(Request["s"]); %>&u=<% Response.Write(Request["u"]); %>&t=1">Portfolio</a></span></div>
                </div>
                <div layout-obj="brd">
                    <div brd-obj="row" class="mansory-lstvw">
                        <div row-obj="mansory-lstvw">
                            <div mansory-lstvw-obj="mansory">
                                <%
                                                                                                                                     var wrkexprs = db.UserWorkExperiences.Where(x => x.User_ID == user.ID).ToList();
                                                                                                                                     foreach (var expr in wrkexprs)
                                                                                                                                     {
                                %>
                                <div lstvw-obj="itm" port-title="<% Response.Write(expr.Title); %>" port-descr="<% Response.Write(expr.Description); %>" port-image-url="?p=portfolioimage&url=<% Response.Write((expr != null) ? expr.ImageUrl : ""); %>">
                                    <div itm-obj="avatar" style="background-image: url('?p=portfolioimage&url=<% Response.Write((expr != null) ? expr.ImageUrl : ""); %>')"></div>
                                    <div itm-obj="info">
                                        <div info-obj="title"><% Response.Write(expr.Title); %></div>
                                        <div info-obj="descr"><% Response.Write(expr.Description); %></div>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
        }
    %>
</asp:Content>
<asp:Content ID="main_body_rgt" ContentPlaceHolderID="main_body_rgt" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var businessCntrllr = new FindAService_WebForm.Controllers.BusinessUserController();
        var adsCntr = new FindAService_WebForm.Controllers.AdsController();
        var user = businessCntrllr.GetUser(new FindAService_WebForm.UserBusiness
        {
            Email = Request["u"]
        });
    %>
    <div layout-obj="related-pnl">
        <%
            var rpeople = businessCntrllr.GetRelatedUsers(user);
            if (rpeople != null)
            {
                var relatd_people = rpeople.Take(3);
                if (relatd_people.Count() > 0)
                {
        %>
        <div related-pnl-obj="related-photo-preview">
            <div related-obj="hdr">Related Companies</div>
            <div related-obj="photo-preview">
                <div photo-preview-obj="photo-wrappr">
                    <%
                    foreach (var usr in relatd_people)
                    {

                        var rating = db.UserRatings.Where(x => x.User_ID == usr.ID).ToList();

                        var star_1 = 0;
                        var star_2 = 0;
                        var star_3 = 0;
                        var star_4 = 0;
                        var star_5 = 0;

                        if (rating != null)
                        {
                            foreach (var r in rating)
                            {
                                star_1 += ((rating != null) && (int.Parse(r.Star1) == 1)) ? 1 : 0;
                                star_2 += ((rating != null) && (int.Parse(r.Star2) == 1)) ? 1 : 0;
                                star_3 += ((rating != null) && (int.Parse(r.Star3) == 1)) ? 1 : 0;
                                star_4 += ((rating != null) && (int.Parse(r.Star4) == 1)) ? 1 : 0;
                                star_5 += ((rating != null) && (int.Parse(r.Star5) == 1)) ? 1 : 0;
                            }
                        }

                        var ttal_rate_sum = ((star_1 * 1) + (star_2 * 2) + (star_3 * 3) + (star_4 * 4) + (star_5 * 5));
                        var ttal_rate_cnt = (star_1 + star_2 + star_3 + star_4 + star_5);
                        double ttal_rate = (ttal_rate_sum > 0) ? Math.Round((double)((double)ttal_rate_sum / (double)ttal_rate_cnt), 1) : 0;
                        Math.Ceiling(ttal_rate);

                        var usr_businesscategory = db.BusinessCategories.Find(usr.BusinessCategory_ID);
                    %>
                    <div rating="<% Response.Write(ttal_rate); %>" photo-wrappr-obj="photo" email="<% Response.Write((user != null) ? usr.Email : ""); %>" name="<% Response.Write((user != null) ? usr.BusinessName : ""); %>">
                        <div info-obj="phldr"><i class="fa fa-user"></i></div>
                        <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? usr.ImageUrl : ""); %>')"></div>
                        <input type="hidden" value="<% Response.Write((user != null) ? usr.BusinessDescription : ""); %>" />
                        <a href="?p=business&s=<% Response.Write((usr_businesscategory != null) ? usr_businesscategory.Increment.ToString() : ""); %>&u=<% Response.Write(usr.Email.ToLower()); %>"></a>
                    </div>
                    <%
                    }
                    %>
                </div>
            </div>
            <%
                    var business = relatd_people.FirstOrDefault();
                    var business_businesscategory = db.BusinessCategories.Find(business.BusinessCategory_ID);
            %>
            <div related-obj="ftr">
                <div ftr-obj="hdr"><a href="?p=business&s=<% Response.Write(business_businesscategory.Increment); %>&u=<% Response.Write(business.Email.ToLower()); %>"><% Response.Write(business.BusinessName); %></a></div>
                <div ftr-obj="rating">
                    <div type="rating-mtr">
                        <div hdr-obj="rating-wrappr">
                            <div wrappr-obj="rating">
                                <%
                    for (var i = 1; i <= 5; i++)
                    {
                        var percent = 0.0;
                                %>
                                <div rating-obj="star" indx="<% Response.Write(i); %>">
                                    <i class="fa fa-star"></i>
                                    <div star-obj="percent" style="width: <% Response.Write(percent); %>%"></div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>

        <div related-pnl-obj="other-businesses">
            <div related-obj="hdr">Companies you may like</div>
            <div related-obj="bdy">
                <%
                    var speople = businessCntrllr.GetSuggestedUsers(user);
                    if (speople != null)
                    {
                        var suggstd_people = speople.Take(3);
                        foreach (var usr in suggstd_people)
                        {
                            var rating = db.UserRatings.Where(x => x.User_ID == usr.ID).ToList();

                            var star_1 = 0;
                            var star_2 = 0;
                            var star_3 = 0;
                            var star_4 = 0;
                            var star_5 = 0;

                            if (rating != null)
                            {
                                foreach (var r in rating)
                                {
                                    star_1 += ((rating != null) && (int.Parse(r.Star1) == 1)) ? 1 : 0;
                                    star_2 += ((rating != null) && (int.Parse(r.Star2) == 1)) ? 1 : 0;
                                    star_3 += ((rating != null) && (int.Parse(r.Star3) == 1)) ? 1 : 0;
                                    star_4 += ((rating != null) && (int.Parse(r.Star4) == 1)) ? 1 : 0;
                                    star_5 += ((rating != null) && (int.Parse(r.Star5) == 1)) ? 1 : 0;
                                }
                            }

                            var ttal_rate_sum = ((star_1 * 1) + (star_2 * 2) + (star_3 * 3) + (star_4 * 4) + (star_5 * 5));
                            var ttal_rate_cnt = (star_1 + star_2 + star_3 + star_4 + star_5);
                            double ttal_rate = (ttal_rate_sum > 0) ? Math.Round((double)((double)ttal_rate_sum / (double)ttal_rate_cnt), 1) : 0;
                            Math.Ceiling(ttal_rate);

                            var usr_businesscategory = db.BusinessCategories.Find(usr.BusinessCategory_ID);
                %>
                <div bdy-obj="artisan">
                    <div artisan-obj="img">
                        <div info-obj="phldr"><i class="fa fa-user"></i></div>
                        <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? usr.ImageUrl : ""); %>')"></div>
                        <a href="?p=business&s=<% Response.Write((usr_businesscategory != null) ? usr_businesscategory.Increment.ToString() : ""); %>&u=<% Response.Write(usr.Email.ToLower()); %>"></a>
                    </div>
                    <div artisan-obj="info">
                        <div info-obj="title"><a href="?p=business&s=<% Response.Write((usr_businesscategory != null) ? usr_businesscategory.Increment.ToString() : ""); %>&u=<% Response.Write(usr.Email.ToLower()); %>"><% Response.Write(usr.BusinessName); %></a></div>
                        <div info-obj="rating">
                            <div type="rating-mtr">
                                <div hdr-obj="rating-wrappr">
                                    <div wrappr-obj="rating">
                                        <%
                                            var whole_part = (int)Math.Truncate(ttal_rate);
                                            var decimal_prt = ttal_rate - Math.Truncate(ttal_rate);
                                            //
                                            for (var i = 1; i <= 5; i++)
                                            {
                                                var percent = 0.0;
                                                if (i <= Math.Ceiling(ttal_rate))
                                                {
                                                    percent = (i <= whole_part) ? 100 : (decimal_prt * 100);
                                                }
                                        %>
                                        <div rating-obj="star" indx="<% Response.Write(i); %>">
                                            <i class="fa fa-star"></i>
                                            <div star-obj="percent" style="width: <% Response.Write(percent); %>%"></div>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div info-obj="job"><% Response.Write((usr_businesscategory != null) ? usr_businesscategory.BusinessCategoryTitle : ""); %></div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <div related-pnl-obj="billbrd">
            <div billbrd-obj="hdr">Sponsored</div>
            <div billbrd-obj="bdy">
                <%
                    var aCntr = adsCntr.GetOnBoardingAds((int)FindAService_WebForm.AdsBannerDimension.Dimen_266x188);
                    if (aCntr != null)
                    {
                        var adverts = aCntr.Take(3);
                        if (adverts != null)
                        {
                            foreach (var advert in adverts)
                            {
                                var ownr_url = "";
                                var iownr = db.UserIndividuals.Where(x => x.ID == advert.User_ID).FirstOrDefault();
                                if (iownr != null)
                                {
                                    var iownr_service = db.Services.Find(iownr.Service_ID);
                                    ownr_url = "?p=individual&s=" + ((iownr_service != null) ? iownr_service.Increment.ToString() : "") + "&u=" + iownr.Email.ToLower();
                                }
                                else
                                {
                                    var bownr = db.UserBusinesses.Where(x => x.ID == advert.User_ID).FirstOrDefault();
                                    if (bownr != null)
                                    {
                                        var bownr_businesscategory = db.BusinessCategories.Find(bownr.BusinessCategory_ID);
                                        ownr_url = "?p=business&s=" + ((bownr_businesscategory != null) ? bownr_businesscategory.Increment.ToString() : "") + "&u=" + bownr.Email.ToLower();
                                    }
                                }

                                if (advert.AdsCampaigns != null)
                                {
                                    var campaign = advert.AdsCampaigns.FirstOrDefault();
                                    if ((campaign != null) && (campaign.AdsCampaignBanners != null))
                                    {
                                        var campagn_bannr = campaign.AdsCampaignBanners.FirstOrDefault();
                           
                %>
                <div bdy-obj="advrt">
                    <div advrt-obj="mdia" style="background-image: url('?p=adbanner&url=<% Response.Write((campagn_bannr != null) ? campagn_bannr.ImageUrl : ""); %>')">
                        <a href="<% Response.Write(((campaign != null) && (campaign.URL != "")) ? campaign.URL : ownr_url); %>"></a>
                    </div>
                    <div advrt-obj="smry">
                        <div smry-obj="hdr"><a href="<% Response.Write(((campaign != null) && (campaign.URL != "")) ? campaign.URL : ownr_url); %>"><% Response.Write((campaign != null) ? campaign.Title : ""); %></a></div>
                        <div smry-obj="abt"><% Response.Write((campaign != null) ? campaign.Description : ""); %></div>
                    </div>
                </div>
                <%
                                    }
                                }
                            }
                        }
                    }
                %>
            </div>
        </div>

    </div>
</asp:Content>




