<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Shared/IndividualAccountPage.Master" CodeBehind="individual.account.portfolio.aspx.cs" Inherits="FindAService_WebForm.Views.individual_account_portfolio" %>

<asp:Content ID="script_area" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/artisan.portfolio.script.js" type="text/javascript"></script>
    <script src="/Scripts/artisan.script.js" type="text/javascript"></script>
    <script src="/Scripts/xhr.script.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.artisan.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.account.portfolio.style.css" type="text/css" />
    <%
        var user_obj = new FindAService_WebForm.Controllers.IndividualUserController().GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = (Session["user_account_email"] != null) ? Session["user_account_email"].ToString() : Request["u"]
        });
    %>
</asp:Content>
<asp:Content ID="menu_area" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var individualCntrllr = new FindAService_WebForm.Controllers.IndividualUserController();
        var user = individualCntrllr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = (Session["user_account_email"] != null) ? Session["user_account_email"].ToString() : Request["u"]
        });

        if (user == null)
        {
            Response.Redirect("?p=login");
        }
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><span text><a href="?p=account&u=<% Response.Write(Request["u"]); %>"><% Response.Write(user.FirstName); %></a></span></div>
        <div menu-obj="item"><span text><a href="?p=account&tb=3&mode=cinf&u=<% Response.Write(Request["u"].ToString()); %>">Settings</a></span></div>
        <div menu-obj="item"><span text><a href="?p=blog">Blog</a></span></div>
        <div menu-obj="item"><span text><a href="?p=logout">Logout</a></span></div>
    </div>
</asp:Content>
<asp:Content ID="main_body_lft" ContentPlaceHolderID="main_body_lft" runat="server">
    <%
        var individualCntrllr = new FindAService_WebForm.Controllers.IndividualUserController();
        var notifCntrllr = new FindAService_WebForm.Controllers.NotificationController();
        var user = individualCntrllr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = (Session["user_account_email"] != null) ? Session["user_account_email"].ToString() : Request["u"]
        });
        var db = new FindAService_WebForm.FASDBEntities();

        var user_city = db.Cities.Find(user.City_ID);
        var user_state = db.States.Find(user.State_ID);
        var user_country = db.Countries.Find(user.Country_ID);
        var user_service = db.Services.Find(user.Service_ID);
    %>
    <div layout-obj="portfolio">
        <input type="hidden" id="txtUserID" value="<% Response.Write((user != null) ? user.ID : ""); %>" />
        <div portfolio-obj="hdr">
            <div hdr-obj="title">
                <span><i class="fa fa-briefcase"></i></span><span>Portfolio</span>
            </div>
        </div>
        <div portfolio-obj="bdy">
            <div bdy-obj="left-pane">
                <ul>
                    <li>
                        <div type="info">
                            <div info-obj="phldr"><i class="fa fa-user"></i></div>
                            <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? user.ImageUrl : ""); %>')"></div>
                        </div>
                    </li>
                    <li>
                        <div type="info-hdr" style="font-family: 'Open Sans Semibold'">
                            <% Response.Write(user_service.ServiceTitle); %>
                        </div>
                        <div type="hint"><% Response.Write(user_city.CityName + " (" + user_country.WebCode + ")"); %></div>
                    </li>
                    <li separatr></li>
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
                    <li>
                        <div type="hdr"><span>Contact Info</span></div>
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
                    <%
                        var numOfUnseenRequst = notifCntrllr.GetRecentIndividualNotificationCount(new FindAService_WebForm.UserIndividual
                        {
                            ID = user.ID,
                            Country_ID = user.Country_ID,
                            State_ID = user.State_ID,
                            City_ID = user.City_ID,
                            Service_ID = user.Service_ID,
                            RegistrationDate = user.RegistrationDate
                        });
                    %>
                    <div tab-obj="btn" class="info" form="iform" selected="false"><a href="?p=account&u=<% Response.Write(Request["u"]); %>">Info</a></div>
                    <div tab-obj="btn" class="portfolio" form="iform" selected="true"><a href="?p=account&tb=1&u=<% Response.Write(Request["u"]); %>">Portfolio</a></div>
                    <div tab-obj="btn" class="jobbox" form="iform" selected="false"><span><a href="?p=account&tb=2&u=<% Response.Write(Request["u"]); %>">Job Box <% Response.Write((numOfUnseenRequst > 0) ? "(" + numOfUnseenRequst + ")" : ""); %></a></span></div>
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
</asp:Content>
<asp:Content ID="main_body_rgt" ContentPlaceHolderID="main_body_rgt" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var adsCntr = new FindAService_WebForm.Controllers.AdsController();
        var user = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = Request["u"]
        });

        var user_city = db.Cities.Find(user.City_ID);
        var user_state = db.States.Find(user.State_ID);
        var user_country = db.Countries.Find(user.Country_ID);
    %>
    <div layout-obj="related-pnl">
        <%
            var relatd_people = individualCntr.GetRelatedUsers(user).Take(3);
            if (relatd_people.Count() > 0)
            {
        %>
        <div related-pnl-obj="related-photo-preview">
            <div related-obj="hdr">Related people</div>
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

                    var user_service = db.Services.Find(usr.Service_ID);
                        
                    %>
                    <div rating="<% Response.Write(ttal_rate); %>" photo-wrappr-obj="photo" url="?p=individual&s=<% Response.Write((user_service != null) ? user_service.Increment.ToString() : ""); %>&u=<% Response.Write(usr.Email.ToLower()); %>" email="<% Response.Write((usr != null) ? usr.Email : ""); %>" name="<% Response.Write((usr != null) ? (usr.FirstName + " " + usr.LastName) : ""); %>">
                        <div info-obj="phldr"><i class="fa fa-user"></i></div>
                        <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? usr.ImageUrl : ""); %>')"></div>
                        <input type="hidden" value="<% Response.Write((user_service != null) ? user_service.ServiceTitle : ""); %>" />
                        <a href="?p=individual&s=<% Response.Write((user_service != null) ? user_service.Increment.ToString() : ""); %>&u=<% Response.Write(usr.Email.ToLower()); %>"></a>
                    </div>
                    <%
                    }
                    %>
                </div>
            </div>
            <div related-obj="ftr">
                <div ftr-obj="hdr"><a href=""><% Response.Write(""); %></a></div>
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
        %>

        <div related-pnl-obj="other-businesses">
            <div related-obj="hdr">Skilled workers you may like</div>
            <div related-obj="bdy">
                <%
                    var speople = individualCntr.GetSuggestedUsers(user);
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

                            var user_service = db.Services.Find(usr.Service_ID);

                            var url = "?p=individual&s=" + ((user_service != null) ? user_service.Increment.ToString() : "") + "&u=" + usr.Email.ToLower();
                %>
                <div bdy-obj="artisan">
                    <div artisan-obj="img">
                        <div info-obj="phldr"><i class="fa fa-user"></i></div>
                        <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? usr.ImageUrl : ""); %>')"></div>
                        <a href="<% Response.Write(url); %>"></a>
                    </div>
                    <div artisan-obj="info">
                        <div info-obj="title"><a href="<% Response.Write(url); %>"><% Response.Write(usr.FirstName + " " + usr.LastName); %></a></div>
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
                        <div info-obj="job"><% Response.Write((user_service != null) ? user_service.ServiceTitle : ""); %></div>
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
                                    ownr_url = "?p=individual&s=" + iownr_service.Increment + "&u=" + iownr.Email.ToLower();
                                }
                                else
                                {
                                    var bownr = db.UserBusinesses.Where(x => x.ID == advert.User_ID).FirstOrDefault();
                                    if (bownr != null)
                                    {
                                        var bownr_bizcateg = db.BusinessCategories.Find(bownr.BusinessCategory_ID);
                                        ownr_url = "?p=business&s=" + bownr_bizcateg.Increment + "&u=" + bownr.Email.ToLower();
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


