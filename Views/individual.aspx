﻿<%@ Page Title="" Language="C#" MasterPageFile="Shared/IndividualPage.Master" AutoEventWireup="true" CodeBehind="individual.aspx.cs" Inherits="FindAService_WebForm.individual" %>

<asp:Content ID="script_area" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/artisan.script.js" type="text/javascript"></script>
    <script src="/Scripts/xhr.script.js" type="text/javascript"></script>
    <script charset="UTF-8" type="text/javascript" src="http://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=7.0"></script>
    <script type="text/javascript">
        function getLocationDetailsFormLatLongPoints(_lat, _lng) {
            $.ajax({
                url: "http://dev.virtualearth.net/REST/v1/Locations/" + _lat + "," + _lng,
                dataType: "jsonp",
                data: {
                    key: "Avq-Bu7txfjdPhlmqvjgSsLhe3WGQTG0qPBFcfLipaq6Kf7YZas_nEEfeRv1dMC4",
                    includeEntityTypes: "Address",
                    includeNeighborhood: "1",
                    include: "ciso2"
                },
                jsonp: "jsonp",
                success: function (data) {
                    var result = data.resourceSets[0];
                    if (result) {
                        if (result.estimatedTotal > 0) {
                            var _msg = "Latitude:- " + _lat;
                            _msg += " and " + "Longitude:- " + _lng;
                            _msg += " Location:- " + result.resources[0].address.addressLine;
                            alert(_msg);
                        }
                        else {
                            alert("Location is not present.");
                        }
                    }
                }
            });
        }
        function initialize(mapDiv, _zoom) {

            var lati = document.getElementById("txtLati").value,
                long = document.getElementById("txtLong").value;

            var mapOptions = {
                credentials: "Avq-Bu7txfjdPhlmqvjgSsLhe3WGQTG0qPBFcfLipaq6Kf7YZas_nEEfeRv1dMC4",
                center: new Microsoft.Maps.Location(lati, long),
                mapTypeId: Microsoft.Maps.MapTypeId.road,
                zoom: _zoom,
                showScalebar: false,
                enableSearchLogo: false,
                disableBirdseye: false,
                disableKeyboardInput: true,
                disableMouseInput: false,
                disablePanning: false,
                disableTouchInput: true,
                disableUserInput: true,
                disableZooming: false,
                enableClickableLogo: false,
                enableHighDpi: false,
                enableSearchLogo: false,
                fixedMapPosition: false,
                showBreadcrumb: false,
                showCopyright: true,
                showMapTypeSelector: false,
                showScalebar: false,
                customizeOverlays: false,
                useInertia: true
            }
            map = new Microsoft.Maps.Map(mapDiv, mapOptions);
            Microsoft.Maps.Events.addHandler(map, 'click', function (e) {
                if (e.targetType == "map") {
                    map.entities.clear();
                    var point = new Microsoft.Maps.Point(e.getX(), e.getY());
                    latlng = e.target.tryPixelToLocation(point);
                    var marker = new Microsoft.Maps.Pushpin(latlng, { visible: true });
                    map.entities.push(marker);
                    getLocationDetailsFormLatLongPoints(latlng.latitude, latlng.longitude);
                }
            });
        };
    </script>
</asp:Content>
<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.artisan.style.css" type="text/css" />
    <%
        var user_obj = new FindAService_WebForm.Controllers.IndividualUserController().GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = Request["u"]
        });
    %>
</asp:Content>
<asp:Content ID="menu_area" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var businessCntr = new FindAService_WebForm.Controllers.BusinessUserController();
        var adsCntr = new FindAService_WebForm.Controllers.AdsController();
        var user = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = Request["u"]
        });

        //if (user == null)
        //{
        //    Response.Redirect("?p=nopage");
        //}
        var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
        if (Session["user_account_active"] == null || ((bool)Session["user_account_active"]) != true)
        {
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><a href=".">Home</a></div>
        <%
            //if (howitworks != null)
            //{
            //    var hwitwrk_cntnt = db.Contents.Where(x => x.Category_ID == howitworks.ID).OrderBy(x => x.Increment).FirstOrDefault();
            //    if (hwitwrk_cntnt != null)
            //    {
        %>
        <%--<div menu-obj="item"><a href="?p=content&title=<% Response.Write(hwitwrk_cntnt.Title.ToLower()); %>&category=<% Response.Write(howitworks.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(hwitwrk_cntnt.Increment); %>">How it works</a></div>--%>
        <%
            //    }
            //}
        %>
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
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var adsCntr = new FindAService_WebForm.Controllers.AdsController();

        var user = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = Request["u"]
        });

        var user_city = db.Cities.Find(user.City_ID);
        var user_state = db.States.Find(user.State_ID);
        var user_country = db.Countries.Find(user.Country_ID);
        var user_service = db.Services.Find(user.Service_ID);

        //if (user == null)
        //{
        //    Response.Redirect("/");
        //}
    %>

    <div layout-obj="artisan">
        <input type="hidden" id="txtUserID" value="<% Response.Write((user != null) ? user.ID : ""); %>" />
        <input type="hidden" id="txtLati" value="<% Response.Write((user != null) ? user_city.Latitude : ""); %>" />
        <input type="hidden" id="txtLong" value="<% Response.Write((user != null) ? user_city.Longitude : ""); %>" />
        <div artisan-obj="hdr">
            <div hdr-obj="title">
                <% Response.Write((user != null) ? (user.FirstName + " " + user.LastName) : ""); %>
            </div>
            <%
                if (user.IsCertified)
                {
            %>
            <div hdr-obj="certify">
                <div certify-obj="ok"></div>
            </div>
            <%
            }
            %>
            <div hdr-obj="rating">
                <form action="?p=dorating&t=individual&s=<% Response.Write(Request["s"]); %>&u=<% Response.Write(Request["u"]); %>" method="post" enctype="application/x-www-form-urlencoded">
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
        <div artisan-obj="bdy">
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
                            <% 
                                if (user != null)
                                {
                                    Response.Write(user_service.ServiceTitle);
                                }
                            %>
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
                    <div tab-obj="btn" class="info" form="iform" selected="true"><a href="?p=individual&u=<% Response.Write(Request["u"]); %>">Info</a></div>
                    <div tab-obj="btn" class="portfolio" form="iform" selected="false"><a href="?p=individual&u=<% Response.Write(Request["u"]); %>&t=1">Portfolio</a></div>
                </div>
                <div layout-obj="brd">

                    <div brd-obj="row" float="true">
                        <div row-obj="hdr"></div>
                        <div row-obj="bdy">
                            <%
                                if (user != null)
                                {
                                    var usrportfolio = db.UserPortfolioItems.Where(x => x.User_ID == user.ID).ToList();
                                    if (usrportfolio.Count > 0)
                                    {
                            %>
                            <div row-obj="photo-preview">
                                <div photo-preview-obj="before"></div>
                                <div photo-preview-obj="photo-wrappr">
                                    <%
                                        foreach (var itm in usrportfolio)
                                        {
                                    %>
                                    <div photo-wrappr-obj="photo">
                                        <img src="?p=portfolioimage&url=<% Response.Write((user != null) ? itm.ImageUrl : ""); %>" />
                                    </div>
                                    <%
                                        }
                                    %>
                                </div>
                                <div photo-preview-obj="after"></div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <div brd-obj="row" float="true">
                        <div row-obj="hdr">Current Location:</div>
                        <div id="divMap" row-obj="bdy" style="width: 489px; height: 349px; position: relative;"></div>
                        <script type="text/javascript">
                            initialize(document.getElementById("divMap"), 14);
                        </script>
                    </div>

                    <div brd-obj="row" float="true">
                        <div row-obj="hdr">About Me:</div>
                        <div row-obj="bdy"><% Response.Write((user != null) ? user.AboutMe : ""); %></div>
                    </div>

                    <%--<div brd-obj="row" float="true">
                        <div row-obj="hdr">Portfolio:</div>
                        <div row-obj="bdy">
                            <%
                                var wrkexprs = db.UserWorkExperiences.Where(x => x.User_ID == user.ID).OrderByDescending(x => x.Increment).ToList();
                                foreach (var experience in wrkexprs)
                                {
                            %>
                            <div bdy-obj="cv">
                                <div cv-obj="headr"><% Response.Write(experience.Title); %></div>
                                <div cv-obj="sumry"><% Response.Write(experience.Description); %></div>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>--%>

                    <div brd-obj="row" float="true">
                        <div row-obj="hdr">Educational Qualification:</div>
                        <div row-obj="bdy">
                            <%
                                var eduqualifs = db.UserEducationalQualifications.Where(x => x.User_ID == user.ID).OrderByDescending(x => x.Increment).ToList();
                                foreach (var qualifcatn in eduqualifs)
                                {
                            %>
                            <div bdy-obj="cv">
                                <div cv-obj="headr"><% Response.Write(qualifcatn.SchoolName); %></div>
                                <div cv-obj="sumry"><% Response.Write(qualifcatn.AwardAcquired); %></div>
                                <div cv-obj="period"><% Response.Write(qualifcatn.YearGraduated); %></div>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <div brd-obj="row" class="comment-lstvw">
                        <div row-obj="cmmnt-lstvw">
                            <div cmmnt-lstvw-obj="title">All Comments(<% Response.Write(db.UserComments.Where(x => x.User_ID == user.ID).ToList().Count); %>)</div>
                            <div cmmnt-lstvw-obj="hdr">
                                <form id="comment-frm" action="?p=dopostcomment&t=<% Response.Write(Request["p"]); %>&s=<% Response.Write(Request["s"]); %>&u=<% Response.Write(Request["u"]); %>" method="post">
                                    <input type="hidden" id="comment-txt" name="comment-txt" />
                                    <input type="hidden" id="page-txt" name="page-txt" value="<% Response.Write(user.Email); %>" />
                                </form>
                                <div hdr-obj="txt-pad" id="comment-pad" contenteditable="true" placeholder="Write your comment here..."></div>
                                <div hdr-obj="post-btn" id="comment-btn" page-user-id="<% Response.Write(user.Email); %>">Post Comment</div>
                            </div>
                            <div cmmnt-lstvw-obj="lstvw">
                                <%
                                    var page = 0;
                                    int.TryParse(Request["page"], out page);

                                    var comments = new FindAService_WebForm.Controllers.IndividualUserController().GetUserComments(new FindAService_WebForm.UserIndividual
                                    {
                                        ID = user.ID
                                    }, (Request["page"] != null ? page : 1));

                                    foreach (var comment in comments)
                                    {
                                        var name = comment.Owner_ID;
                                        var image = "";
                                        var iusr = db.UserIndividuals.Find(comment.Owner_ID);
                                        if (iusr != null)
                                        {
                                            name = iusr.FirstName + " " + iusr.LastName;
                                            image = iusr.ImageUrl;
                                        }
                                        else
                                        {
                                            var busr = db.UserBusinesses.Find(comment.Owner_ID);
                                            if (busr != null)
                                            {
                                                name = busr.BusinessName;
                                                image = busr.ImageUrl;
                                            }
                                        }
                                %>
                                <div lstvw-obj="itm">
                                    <div itm-obj="avatar" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? image : ""); %>')"></div>
                                    <div itm-obj="cmment">
                                        <div cmment-obj="name"><% Response.Write(name); %></div>
                                        <div cmment-obj="date"><% Response.Write(comment.DatetCommented); %></div>
                                        <div cmment-obj="text"><% Response.Write(comment.Comment); %></div>
                                    </div>
                                </div>
                                <%
                                    }

                                    if ((int)Session["totalPages"] > 1)
                                    {
                                %>
                                <div lstvw-obj="paging">
                                    <div paging-obj="pages">
                                        <%                 
                                        var pages = individualCntr.ShowPages();
                                        Response.Write(pages);                                                  
                                        %>
                                    </div>
                                    <div paging-obj="title"><% Response.Write("Page " + Session["currentPage"] + " of " + Session["totalPages"]); %></div>
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

        if (user == null)
            Response.Redirect("/");

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

