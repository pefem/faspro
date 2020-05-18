<%@ Page Title="" Language="C#" MasterPageFile="Shared/Search.Master" AutoEventWireup="true" CodeBehind="searchresult.aspx.cs" Inherits="FindAService_WebForm.SearchResult" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="script_area" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="style_area" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var logged_in_usr = "";
        if (Session["user_account_email"] != null)
        {
            logged_in_usr = Session["user_account_email"].ToString();
        }

        if (Session["user_account_active"] == null || ((bool)Session["user_account_active"]) != true)
        {
            var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><a href=".">Home</a></div>
        <%
                                //if (howitworks != null)
                                //{
                                //    var hwitwrk_cntnt = db.Contents.Where(x => x.Category_ID == howitworks.ID).OrderBy(x => x.Increment).FirstOrDefault();
                                //    if(hwitwrk_cntnt != null) {
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

            var name = "";
            var email = "";

            var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
            var iuser = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
            {
                Email = logged_in_usr
            });
            if (iuser != null)
            {
                name = iuser.FirstName;
                email = iuser.Email.ToLower();
            }
            else
            {
                var businessCntr = new FindAService_WebForm.Controllers.BusinessUserController();
                var buser = businessCntr.GetUser(new FindAService_WebForm.UserBusiness
                {
                    Email = logged_in_usr
                });
                if (buser != null)
                {
                    name = buser.BusinessName;
                    email = buser.Email.ToLower();
                }
            }
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><span text><a href="?p=account&u=<% Response.Write(email); %>"><% Response.Write("Welcome, " + name); %></a></span></div>
        <div menu-obj="item"><span text><a href="?p=blog">Blog</a></span></div>
        <div menu-obj="item"><span text><a href="?p=logout">Logout</a></span></div>
    </div>
    <%
        }
    %>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="main_body_lft" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var UsrType = Request["t"];
    %>

    <div layout-obj="search">
        <div search-obj="search-wrappr">
            <div srch-wrappr-obj="srch-bdy">
                <%
                    var criteria = (string)Session["what_txt"];
                    var location = (string)Session["where_txt"];
                    
                    var serv_srch = db.Services.Where(x => criteria.Contains(x.ServiceTitle)).FirstOrDefault();
                    var bcatg_srch = db.BusinessCategories.Where(x => criteria.Contains(x.BusinessCategoryTitle)).FirstOrDefault();
                    
                    var ic = (serv_srch != null)?"&c=" + serv_srch.Increment.ToString() : "";
                    var iloc = (Request["loc"] != null)?"&loc=" + Request["loc"] : "";
                    var it = "&t=iu";
                    var iurl = "?p=searchresult" + ic + iloc + it;

                    var bc = (bcatg_srch != null) ? "&c=" + bcatg_srch.Increment.ToString() : "";
                    var bloc = (Request["loc"] != null) ? "&loc=" + Request["loc"] : "";
                    var bt = "&t=bu";
                    var burl = "?p=searchresult" + bc + bloc + bt;
                %>
                <div srch-bdy-obj="tab">
                    <ul tab-obj="tab-btn-wrappr">
                        <li tab-obj="btn" form="iform" <% Response.Write((UsrType != "bu") ? "selected=\"true\"" : ""); %>><a href="<% Response.Write(iurl); %>">Individual</a></li>
                        <li tab-obj="btn" form="cform" <% Response.Write((UsrType == "bu") ? "selected=\"true\"" : ""); %>><a href="<% Response.Write(burl); %>">Corporate</a></li>
                    </ul>
                </div>
                <div srch-bdy-obj="tabpage">
                    <% 
                        if (UsrType != "bu")
                        {
                            var c = (Request["c"] != null) ? int.Parse(Request["c"]) : 0;
                            var serv = db.Services.Where(x => x.Increment == c).FirstOrDefault();
                            //
                            var cntry_code = Request.Cookies["page"]["location"];
                            var cntry = db.Countries.Where(x => x.WebCode == cntry_code).FirstOrDefault();
                    %>
                        <form method="post" action="?p=dosearch&t=<% Response.Write(FindAService_WebForm.UserType.Individual); %>" enctype="application/x-www-form-urlencoded" accept-charset="">
                    <div tabpage-obj="pnl" ftype="iform">
                            <div pnl-obj="srch-itm">
                                <div srch-itm="field">
                                    <input type="text" name="what_txt" id="what_txt" placeholder="What 're you looking for?" value="<% Response.Write((Request["q"] != null && Request["q"] != "") ? Request["q"] : ""); %>" />
                                </div>
                                <div srch-itm="dropdwn"></div>
                            </div>
                            <div pnl-obj="srch-loc">
                                <div srch-loc="field">
                                    <input type="text" name="where_txt" id="where_txt" placeholder="Your location..." value="<% Response.Write((Request["loc"] != null && Request["loc"] != "") ? Request["loc"] : (cntry != null ? cntry.CountryName : "")); %>" />
                                </div>
                                <div srch-loc="dropdwn"></div>
                            </div>
                            <div pnl-obj="srch-btn">
                                <input type="submit" id="btnFind" value="Find It" />
                            </div>
                            <div clear></div>
                    </div>
                        </form>
                    <% 
                        }
                        else
                        {
                            var q = (Request["q"] != null) ? Request["q"] : "";
                            var bcateg = db.BusinessCategories.Where(x => x.BusinessCategoryTitle == q).FirstOrDefault();

                            var cntry_code = Request.Cookies["page"]["location"];
                            var cntry = db.Countries.Where(x => x.WebCode == cntry_code).FirstOrDefault();
                    %>
                        <form method="post" action="?p=dosearch&t=<% Response.Write(FindAService_WebForm.UserType.Business); %>" enctype="application/x-www-form-urlencoded" accept-charset="">
                    <div tabpage-obj="pnl" ftype="cform">
                            <div pnl-obj="srch-itm">
                                <div srch-itm="field">
                                    <select name="what_txt" id="what_txt">
                                        <%
                                            if(bcateg == null) {
                                        %>
                                        <option selected="selected" value="0">Available Companies</option>
                                        <%
                                        }
                                                                     var businesscategoriess = new FindAService_WebForm.Controllers.BusinessCategoryController().GetBusinessCategories();
                                                                     foreach (var category in businesscategoriess)
                                                                     {
                                        %>
                                        <option <% Response.Write(((bcateg != null) && (bcateg.Increment == category.Increment)) ? "selected=\"selected\"" : ""); %>><% Response.Write(category.BusinessCategoryTitle); %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                                <div srch-itm="dropdwn"></div>
                            </div>
                            <div pnl-obj="srch-loc">
                                <div srch-loc="field">
                                    <input type="text" name="where_txt" id="where_txt" placeholder="City, state or country..." value="<% Response.Write((Request["loc"] != null && Request["loc"] != "") ? Request["loc"] : (cntry != null ? cntry.CountryName : "")); %>" />
                                </div>
                                <div srch-loc="dropdwn"></div>
                            </div>
                            <div pnl-obj="srch-btn">
                                <input type="submit" value="Find It" />
                            </div>
                            <div clear></div>
                    </div>
                        </form>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>        

        <%
            var page = 0;
            int.TryParse(Request["page"], out page);

            var iadsresults = (dynamic)null;
            var badsresults = (dynamic)null;
            var iresults = (dynamic)null;
            var bresults = (dynamic)null;
            var result_count = 0;
            var total_results = 0;

            if (UsrType == "iu")
            {
                var c = (Request["c"] != null) ? int.Parse(Request["c"]) : 0;
                var serv = db.Services.Where(x => x.Increment == c).FirstOrDefault();
                iadsresults = new FindAService_WebForm.Controllers.IndividualUserController().AdsSearchFor(Request["q"], Request["loc"], (Request["page"] != null ? page : 1));
                iresults = new FindAService_WebForm.Controllers.IndividualUserController().SearchFor(Request["q"], Request["loc"], (Request["page"] != null ? page : 1));
                result_count = (iresults != null) ? ((List<FindAService_WebForm.UserIndividual>)iresults).Count : 0;
            }
            else
            {
                var c = (Request["c"] != null) ? int.Parse(Request["c"]) : 0;
                var bcatg = db.BusinessCategories.Where(x => x.Increment == c).FirstOrDefault();
                badsresults = new FindAService_WebForm.Controllers.BusinessUserController().AdsSearchFor(Request["q"], Request["loc"], (Request["page"] != null ? page : 1));
                bresults = new FindAService_WebForm.Controllers.BusinessUserController().SearchFor(Request["q"], Request["loc"], (Request["page"] != null ? page : 1));
                result_count = (bresults != null) ? ((List<FindAService_WebForm.UserBusiness>)bresults).Count : 0;
            }

            if (Session["totalResults"] != null)
            {
                total_results = (int)Session["totalResults"];
            }
        %>
        <div search-obj="search-list">
            <div search-list-obj="response-hint"><% Response.Write(total_results + " " + ((total_results > 1) ? "results" : "result")); %> found for <b><% Response.Write(Request["q"]); %></b> <b><% Response.Write((Request["loc"] != null && Request["loc"] != "") ? "in " + Request["loc"] : ""); %></b></div>
        </div>
        

        <%
            if ((UsrType == "iu") && (iadsresults != null) && ((((List<FindAService_WebForm.UserIndividual>)iadsresults)).Count > 0))
            {
        %>
        <div search-obj="search-list" highlighted>
            <%
                var adsresults = ((List<FindAService_WebForm.UserIndividual>)iadsresults);
                if (adsresults != null)
                {
                    foreach (var result in adsresults)
                    {
                        var name = result.FirstName + " " + result.LastName;
                        var service = db.Services.Find(result.Service_ID);
                        var city = db.Cities.Find(result.City_ID);
                        var state = db.States.Find(result.State_ID);
                        var country = db.Countries.Find(result.Country_ID);
                        
                        var rating = db.UserRatings.Where(x => x.User_ID == result.ID).ToList();
                        
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
            <div search-list-obj="result">
                <div result-obj="itm">
                    <div itm-obj="cntact">
                        <div><% Response.Write(result.ContactAddress); %></div>
                        <div><% Response.Write(city.CityName + ", " + state.StateName + ". " + country.CountryName); %></div>
                        <div><% Response.Write(result.ContactNumber); %></div>
                    </div>
                    <div itm-obj="image">
                        <div image-obj="phldr">
                            <i class="fa fa-user"></i>
                        </div>
                        <div image-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? result.ImageUrl : ""); %>')"></div>
                    </div>
                    <div itm-obj="info">
                        <div info-obj="hdr"><a href="?p=individual&s=<% Response.Write(service.Increment); %>&u=<% Response.Write(result.Email.ToLower()); %>"><% Response.Write(name); %></a></div>
                        <div info-obj="bdy">
                            <div bdy-obj="mtr">
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
                            <div bdy-obj="job-descr"><% Response.Write(((result != null) && (result.AboutMe != "") && (result.AboutMe != null)) ? result.AboutMe.Substring(0, ((result.AboutMe.Length > 150) ? 150 : result.AboutMe.Length)) : ""); %></div>
                        </div>
                    </div>
                </div>
                <%
                    var usrComments = db.UserComments.Where(x => x.User_ID == result.ID).ToList();
                    if (usrComments != null)
                    {
                        var cmment = usrComments.FirstOrDefault();
                        if (cmment != null)
                        {
                            var imageurl = "";
                            var url = "";
                            var iusr = db.UserIndividuals.Find(cmment.Owner_ID);
                            if (iusr != null)
                            {
                                service = new FindAService_WebForm.FASDBEntities().Services.Find(iusr.Service_ID);
                                imageurl = iusr.ImageUrl;
                                url = "?p=individual&s=" + service + "&u=" + iusr.Email.ToLower();
                            }
                            else
                            {
                                var busr = db.UserBusinesses.Find(cmment.Owner_ID);
                                if (busr != null)
                                {
                                    var busCategry = new FindAService_WebForm.FASDBEntities().BusinessCategories.Find(busr.BusinessCategory_ID).BusinessCategoryTitle;
                                    imageurl = busr.ImageUrl;
                                    url = "?p=business&s=" + busCategry.ToLower() + "&u=" + busr.Email.ToLower();
                                }
                            }
                %>
                <div result-obj="cmments">
                    <div cmment-obj="image" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? imageurl : ""); %>')">
                        <a href="<% Response.Write(url); %>"></a>
                    </div>
                    <div cmment-obj="cmment"><% Response.Write(cmment != null ? cmment.Comment : ""); %></div>
                </div>
                <%
                                }
                            }
                %>
            </div>
            <%
                    }
                }
            %>
        </div>
        <%
            }
            
            if ((UsrType == "bu") && ((((List<FindAService_WebForm.UserBusiness>)badsresults)).Count > 0))
            {
        %>
        <div search-obj="search-list" highlighted>
            <%
                    var adsresults = ((List<FindAService_WebForm.UserBusiness>)badsresults);
                    if (adsresults != null)
                    {
                        foreach (var result in adsresults)
                        {
                            var name = result.BusinessName;
                            var category = db.BusinessCategories.Find(result.BusinessCategory_ID);
                            var city = db.Cities.Find(result.City_ID);
                            var state = db.States.Find(result.State_ID);
                            var country = db.Countries.Find(result.Country_ID);

                            var rating = db.UserRatings.Where(x => x.User_ID == result.ID).ToList();

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
            <div search-list-obj="result">
                <div result-obj="itm">
                    <div itm-obj="cntact">
                        <div><% Response.Write(result.ContactAddress); %></div>
                        <div><% Response.Write(city.CityName + ", " + state.StateName + ". " + country.CountryName); %></div>
                        <div><% Response.Write(result.ContactNumber); %></div>
                    </div>
                    <div itm-obj="image">
                        <div image-obj="phldr">
                            <i class="fa fa-user"></i>
                        </div>
                        <div image-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? result.ImageUrl : ""); %>')"></div>
                    </div>
                    <div itm-obj="info">
                        <div info-obj="hdr"><a href="?p=business&s=<% Response.Write(category.Increment); %>&u=<% Response.Write(result.Email.ToLower()); %>"><% Response.Write(name); %></a></div>
                        <div info-obj="bdy">
                            <div bdy-obj="mtr">
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
                            <div bdy-obj="job-descr"><% Response.Write(result.BusinessDescription.Substring(0, ((result.BusinessDescription.Length > 150) ? 150 : result.BusinessDescription.Length))); %></div>
                        </div>
                    </div>
                </div>
                <%
                                                        var usrComments = db.UserComments.Where(x => x.User_ID == result.ID).ToList();
                                                        if (usrComments != null)
                                                        {
                                                            var cmment = usrComments.FirstOrDefault();
                                                            if (cmment != null)
                                                            {
                                                                var imageurl = "";
                                                                var iusr = db.UserIndividuals.Find(cmment.Owner_ID);
                                                                if (iusr != null)
                                                                {
                                                                    imageurl = iusr.ImageUrl;
                                                                }
                                                                else
                                                                {
                                                                    var busr = db.UserBusinesses.Find(cmment.Owner_ID);
                                                                    if (busr != null)
                                                                    {
                                                                        imageurl = busr.ImageUrl;
                                                                    }
                                                                }
                %>
                <div result-obj="cmments">
                    <div cmment-obj="image" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? imageurl : ""); %>')"></div>
                    <div cmment-obj="cmment"><% Response.Write(cmment != null ? cmment.Comment : ""); %></div>
                </div>
                <%
                                                            }
                                                        }
                %>
            </div>
            <%
                    }
                }
            %>
        </div>
        <%
            }
        %>


        <div search-obj="search-list">
            <%                
                if (UsrType == "iu")
                {

                    var results = ((List<FindAService_WebForm.UserIndividual>)iresults);
                    if (results != null)
                    {
                        foreach (var result in results)
                        {
                            var name = result.FirstName + " " + result.LastName;
                            var service = db.Services.Find(result.Service_ID);
                            var city = db.Cities.Find(result.City_ID);
                            var state = db.States.Find(result.State_ID);
                            var country = db.Countries.Find(result.Country_ID);
                            
                            var rating = db.UserRatings.Where(x => x.User_ID == result.ID).ToList();

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
            <div search-list-obj="result">
                <div result-obj="itm">
                    <div itm-obj="cntact">
                        <div><% Response.Write(result.ContactAddress); %></div>
                        <div><% Response.Write(city.CityName + ", " + state.StateName + ". " + country.CountryName); %></div>
                        <div><% Response.Write(result.ContactNumber); %></div>
                    </div>
                    <div itm-obj="image">
                        <div image-obj="phldr">
                            <i class="fa fa-user"></i>
                        </div>
                        <div image-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? result.ImageUrl : ""); %>')"></div>
                    </div>
                    <div itm-obj="info">
                        <div info-obj="hdr"><a href="?p=individual&s=<% Response.Write(service.Increment); %>&u=<% Response.Write(result.Email.ToLower()); %>"><% Response.Write(name); %></a></div>
                        <div info-obj="bdy">
                            <div bdy-obj="mtr">
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
                            <div bdy-obj="job-descr"><% Response.Write(((result != null) && (result.AboutMe != "") && (result.AboutMe != null)) ? result.AboutMe.Substring(0, ((result.AboutMe.Length > 150) ? 150 : result.AboutMe.Length)) : ""); %></div>
                        </div>
                    </div>
                </div>
                <%
                    var usrComments = db.UserComments.Where(x => x.User_ID == result.ID).ToList();
                    if (usrComments != null)
                    {
                        var cmment = usrComments.FirstOrDefault();
                        if (cmment != null)
                        {
                            var imageurl = "";
                            var url = "";
                            var iusr = db.UserIndividuals.Find(cmment.Owner_ID);
                            if (iusr != null)
                            {
                                service = new FindAService_WebForm.FASDBEntities().Services.Find(iusr.Service_ID);
                                imageurl = iusr.ImageUrl;
                                url = "?p=individual&s=" + service + "&u=" + iusr.Email.ToLower();
                            }
                            else
                            {
                                var busr = db.UserBusinesses.Find(cmment.Owner_ID);
                                if (busr != null)
                                {
                                    var busCategry = new FindAService_WebForm.FASDBEntities().BusinessCategories.Find(busr.BusinessCategory_ID).BusinessCategoryTitle;
                                    imageurl = busr.ImageUrl;
                                    url = "?p=business&s=" + busCategry.ToLower() + "&u=" + busr.Email.ToLower();
                                }
                            }
                %>
                <div result-obj="cmments">
                    <div cmment-obj="image" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? imageurl : ""); %>')">
                        <a href="<% Response.Write(url); %>"></a>
                    </div>
                    <div cmment-obj="cmment"><% Response.Write(cmment != null ? cmment.Comment : ""); %></div>
                </div>
                <%
                                }
                            }
                %>
            </div>
            <%
                        }
                    }
                }
                else
                {
                    var results = ((List<FindAService_WebForm.UserBusiness>)bresults);
                    if (results != null) {
                        foreach (var result in results)
                        {
                            var name = result.BusinessName;
                            var category = db.BusinessCategories.Find(result.BusinessCategory_ID);
                            var city = db.Cities.Find(result.City_ID);
                            var state = db.States.Find(result.State_ID);
                            var country = db.Countries.Find(result.Country_ID);

                            var rating = db.UserRatings.Where(x => x.User_ID == result.ID).ToList();

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
            <div search-list-obj="result">
                <div result-obj="itm">
                    <div itm-obj="cntact">
                        <div><% Response.Write(result.ContactAddress); %></div>
                        <div><% Response.Write(city.CityName + ", " + state.StateName + ". " + country.CountryName); %></div>
                        <div><% Response.Write(result.ContactNumber); %></div>
                    </div>
                    <div itm-obj="image">
                        <div image-obj="phldr">
                            <i class="fa fa-user"></i>
                        </div>
                        <div image-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? result.ImageUrl : ""); %>')"></div>
                    </div>
                    <div itm-obj="info">
                        <div info-obj="hdr"><a href="?p=business&s=<% Response.Write(category.Increment); %>&u=<% Response.Write(result.Email.ToLower()); %>"><% Response.Write(name); %></a></div>
                        <div info-obj="bdy">
                            <div bdy-obj="mtr">
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
                            <div bdy-obj="job-descr"><% Response.Write(result.BusinessDescription.Substring(0, ((result.BusinessDescription.Length > 150) ? 150 : result.BusinessDescription.Length))); %></div>
                        </div>
                    </div>
                </div>
                <%
                                                        var usrComments = db.UserComments.Where(x => x.User_ID == result.ID).ToList();
                                                        if (usrComments != null)
                                                        {
                                                            var cmment = usrComments.FirstOrDefault();
                                                            if (cmment != null)
                                                            {
                                                                var imageurl = "";
                                                                var iusr = db.UserIndividuals.Find(cmment.Owner_ID);
                                                                if (iusr != null)
                                                                {
                                                                    imageurl = iusr.ImageUrl;
                                                                }
                                                                else
                                                                {
                                                                    var busr = db.UserBusinesses.Find(cmment.Owner_ID);
                                                                    if (busr != null)
                                                                    {
                                                                        imageurl = busr.ImageUrl;
                                                                    }
                                                                }
                %>
                <div result-obj="cmments">
                    <div cmment-obj="image" style="background-image: url('?p=avatar&url=<% Response.Write((result != null) ? imageurl : ""); %>')"></div>
                    <div cmment-obj="cmment"><% Response.Write(cmment != null ? cmment.Comment : ""); %></div>
                </div>
                <%
                                                            }
                                                        }
                %>
            </div>
            <%
                        }
                    }
                }
            %>

            <%
                if ((Session["totalPages"] != null) && ((int)Session["totalPages"] > 1))
                {
            %>
            <div search-list-obj="paging">
                <div paging-obj="pages">
                    <%                 
                    var pages = new FindAService_WebForm.Controllers.PagingController().ShowPages();
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
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="main_body_rgt" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
    %>

    <%
        var city = new FindAService_WebForm.Controllers.LocationController().GetCity(Request["loc"]);
    %>
    <input type="hidden" id="txtLati" value="<% Response.Write((city != null) ? city.Latitude : ""); %>" />
    <input type="hidden" id="txtLong" value="<% Response.Write((city != null) ? city.Longitude : ""); %>" />
    <div layout-obj="rgt-pnl">
        <div rgt-pnl-obj="map-area" id="divMap"></div>
    </div>
</asp:Content>
