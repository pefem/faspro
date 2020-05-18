<%@ Page Language="C#" MasterPageFile="Shared/IndividualAccountPage.Master" AutoEventWireup="true" CodeBehind="individual.account.notification.aspx.cs" Inherits="FindAService_WebForm.Views.individual_account_notification" %>

<asp:Content ID="script_area" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/artisan.account.notification.script.js" type="text/javascript"></script>
    <script src="/Scripts/artisan.script.js" type="text/javascript"></script>
    <script src="/Scripts/xhr.script.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.artisan.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.account.notification.style.css" type="text/css" />
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

        var user_city = db.Cities.Find(user.City_ID);
        var user_state = db.States.Find(user.State_ID);
        var user_country = db.Countries.Find(user.Country_ID);
        var user_service = db.Services.Find(user.Service_ID);

        if (user == null)
        {
            Response.Redirect("?p=login");
        }

        var s_city = (dynamic)null;
        var s_state = (dynamic)null;
        var s_country = (dynamic)null;

        if (Session["current_loc"] != null)
        {
            object sess_obj = Session["current_loc"];
            Type t = sess_obj.GetType();
            System.Reflection.PropertyInfo city_pi = t.GetProperty("city");
            System.Reflection.PropertyInfo state_pi = t.GetProperty("state");
            System.Reflection.PropertyInfo country_pi = t.GetProperty("country");
            s_city = (FindAService_WebForm.City)city_pi.GetValue(sess_obj, null);
            s_state = (FindAService_WebForm.State)state_pi.GetValue(sess_obj, null);
            s_country = (FindAService_WebForm.Country)country_pi.GetValue(sess_obj, null);
        }

        var c = "";
        if ((Request["t"] != null) && (Request["t"] == "0"))
        {
            var servces = db.Services.ToList();
            c = servces.FirstOrDefault().Increment.ToString();
        }
        else
        {
            var bcateg = db.BusinessCategories.ToList();
            if (bcateg.FirstOrDefault() != null)
                c = bcateg.FirstOrDefault().Increment.ToString();
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
        var businessCntrllr = new FindAService_WebForm.Controllers.BusinessUserController();
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

        var city = (dynamic)null;
        var state = (dynamic)null;
        var country = (dynamic)null;

        if (Session["current_loc"] != null)
        {
            object sess_obj = Session["current_loc"];
            Type t = sess_obj.GetType();
            System.Reflection.PropertyInfo city_pi = t.GetProperty("city");
            System.Reflection.PropertyInfo state_pi = t.GetProperty("state");
            System.Reflection.PropertyInfo country_pi = t.GetProperty("country");
            city = (FindAService_WebForm.City)city_pi.GetValue(sess_obj, null);
            state = (FindAService_WebForm.State)state_pi.GetValue(sess_obj, null);
            country = (FindAService_WebForm.Country)country_pi.GetValue(sess_obj, null);
        }
    %>
    <div layout-obj="accnt-notif">
        <input type="hidden" id="txtUserID" value="<% Response.Write((user != null) ? user.ID : ""); %>" />
        <div accnt-notif-obj="hdr">
            <div hdr-obj="title">
                <span><i class="fa fa-cube"></i></span><span>Job Box</span>
            </div>
        </div>
        <div accnt-notif-obj="bdy">
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
                    <div tab-obj="btn" class="portfolio" form="iform" selected="false"><a href="?p=account&tb=1&u=<% Response.Write(Request["u"]); %>">Portfolio</a></div>
                    <div tab-obj="btn" class="jobbox" form="iform" selected="true"><span><a href="?p=account&tb=2&u=<% Response.Write(Request["u"]); %>">Job Box <% Response.Write((numOfUnseenRequst > 0) ? "(" + numOfUnseenRequst + ")" : ""); %></a></span></div>
                </div>
                <div layout-obj="brd">
                    <%
                        if ((Request != null) && (Request["s"] != "done"))
                        {
                    %>
                    <div brd-obj="row" class="comment-lstvw">
                        <div row-obj="cmmnt-lstvw">
                            <%
                            if ((Request != null) && (Request["m"] == "opt"))
                            {
                            %>
                            <div cmmnt-lstvw-obj="hdr">
                                <div>
                                    <form id="post-msg-frm" action="?p=dosendjobreqtogrp&t=<% Response.Write(Request["t"]); %>&u=<% Response.Write(Request["u"]); %>" method="post">
                                        <div hdr-obj="frm">
                                            <div frm-obj="rw">
                                                <%
                                                                                                                                    var servces = db.Services.ToList();
                                                                                                                                    if ((Request["t"] != null) && (Request["t"] == "0"))
                                                                                                                                    {
                                                %>
                                                <div rw-obj="label">Choose a Service:</div>
                                                <div rw-obj="field-hndl">
                                                    <div field-hndl-obj="field">
                                                        <select style="width: 457px;" name="serv-cmb" p="<% Response.Write(Request["p"]); %>" u="<% Response.Write(Request["u"]); %>" m="<% Response.Write(Request["m"]); %>&tb=<% Response.Write(Request["tb"]); %>" t="<% Response.Write(Request["t"]); %>">
                                                            <%
                                                        if (servces != null)
                                                        {
                                                            foreach (var serv in servces)
                                                            {   
                                                            %>
                                                            <option <% Response.Write((Request["c"] != null && int.Parse(Request["c"]) == serv.Increment) ? "selected=\"selected\"" : ""); %> value="<% Response.Write(serv.Increment); %>"><% Response.Write(serv.ServiceTitle); %></option>
                                                            <%
                                                                    }
                                                                }
                                                            %>
                                                        </select>
                                                    </div>
                                                </div>
                                                <%
                                                    }
                                                    else
                                                    {
                                                %>
                                                <div rw-obj="label">Choose a Business Category:</div>
                                                <div rw-obj="field-hndl">
                                                    <div field-hndl-obj="field">
                                                        <select style="width: 457px;" name="bizcateg-cmb" p="<% Response.Write(Request["p"]); %>" u="<% Response.Write(Request["u"]); %>" m="<% Response.Write(Request["m"]); %>&tb=<% Response.Write(Request["tb"]); %>" t="<% Response.Write(Request["t"]); %>">
                                                            <%
                                                                                                                                                                                                                                                                                var bizCategries = db.BusinessCategories.ToList();
                                                                                                                                                                                                                                                                                if (bizCategries != null)
                                                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                                                    foreach (var bizCateg in bizCategries)
                                                                                                                                                                                                                                                                                    {   
                                                            %>
                                                            <option <% Response.Write((Request["c"] != null && int.Parse(Request["c"]) == bizCateg.Increment) ? "selected=\"selected\"" : ""); %> value="<% Response.Write(bizCateg.Increment); %>"><% Response.Write(bizCateg.BusinessCategoryTitle); %></option>
                                                            <%
                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                        }
                                                            %>
                                                        </select>
                                                    </div>
                                                </div>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </div>
                                        <input type="hidden" name="msg-txt" value="<% Response.Write((Session["msgTxt"] != null) ? Session["msgTxt"].ToString() : ""); %>" />
                                        <input type="hidden" name="sndr-txt" value="<% Response.Write(user.ID); %>" />
                                        <div hdr-obj="btn-pad">
                                            <div btn-pad-obj="cmb">
                                                <div cmb-obj="btn">
                                                    <i class="fa fa-map-marker"></i>
                                                    <input type="hidden" name="cityTxt" value="<% Response.Write(user_city); %>" />
                                                </div>
                                                <div cmb-obj="lbl">
                                                    <%
                                if (Session["current_loc"] != null)
                                {
                                    Response.Write(city.CityName + ", " + state.StateName + ". " + country.CountryName);
                                }
                                else
                                {
                                    Response.Write(user_city.CityName + ", " + user_state.StateName + ". " + user_country.CountryName);
                                }
                                                    %>
                                                </div>
                                                <input type="hidden" id="cntry_txt" name="cntry-txt" value="<% Response.Write((country != null) ? ((FindAService_WebForm.Country)country).ID : user_country.ID); %>" />
                                                <input type="hidden" id="state_txt" name="state-txt" value="<% Response.Write((state != null) ? ((FindAService_WebForm.State)state).ID : user_state.ID); %>" />
                                                <input type="hidden" id="city_txt" name="city-txt" value="<% Response.Write((city != null) ? ((FindAService_WebForm.City)city).ID : user_city.ID); %>" />
                                            </div>
                                            <div btn-pad-obj="btn" id="send-btn" selected page-user-id="<% Response.Write(user.Email); %>">Send to All</div>
                                            <div btn-pad-obj="btn" id="cancel-btn" page-user-id="<% Response.Write(user.Email); %>">Cancel</div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div cmmnt-lstvw-obj="lstvw">
                                <%
                                                                                                    var page = 0;
                                                                                                    int.TryParse(Request["page"], out page);

                                                                                                    var c = (Request["c"] != null) ? int.Parse(Request["c"]) : 0;

                                                                                                    var s_city = ((city != null) ? ((FindAService_WebForm.City)city).ID : user.City_ID);
                                                                                                    var s_state = ((state != null) ? ((FindAService_WebForm.State)state).ID : user.State_ID);
                                                                                                    var s_country = ((country != null) ? ((FindAService_WebForm.Country)country).ID : user.Country_ID);

                                                                                                    var results = (dynamic)null;
                                                                                                    if ((Request["t"] != null) && (Request["t"] == "0"))
                                                                                                    {
                                                                                                        var serv_id = (Request["c"] != null) ? db.Services.Where(x => x.Increment == c).FirstOrDefault().ID : servces.FirstOrDefault().ID;
                                                                                                        results = individualCntrllr.GetPagedUsers(new FindAService_WebForm.Service
                                                                                                        {
                                                                                                            ID = serv_id
                                                                                                        }, s_country, s_state, s_city, (Request["page"] != null ? page : 1));
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        var bcatgry_id = (Request["c"] != null) ? db.BusinessCategories.Where(x => x.Increment == c).FirstOrDefault().ID : db.BusinessCategories.FirstOrDefault().ID;
                                                                                                        results = businessCntrllr.GetPagedUsers(new FindAService_WebForm.BusinessCategory
                                                                                                        {
                                                                                                            ID = bcatgry_id
                                                                                                        }, s_country, s_state, s_city, (Request["page"] != null ? page : 1));
                                                                                                    }

                                                                                                    if (results.Count > 0)
                                                                                                    {   
                                %>

                                <div lstvw-obj="title">Search Results:</div>
                                <%
                                        foreach (var p in results)
                                        {
                                            var image = "";
                                            var email = "";
                                            var usrid = "";
                                            var name = "";
                                            var fname = "";
                                            var me = "";
                                            var r_city = "";
                                            var r_state = "";
                                            var r_cntry = "";
                                            var url = "";

                                            if ((Request["t"] != null) && (Request["t"] == "0"))
                                            {
                                                var usr = (FindAService_WebForm.UserIndividual)p;
                                                image = usr.ImageUrl;
                                                email = usr.Email;
                                                usrid = usr.ID;
                                                name = usr.FirstName + " " + usr.LastName;
                                                fname = usr.FirstName;
                                                me = usr.AboutMe;
                                                r_city = usr.City_ID;
                                                r_state = usr.State_ID;
                                                r_cntry = usr.Country_ID;
                                                var usr_service = db.Services.Find(usr.Service_ID);
                                                url = "?p=individual&s=" + usr_service.Increment + "&u=" + email;
                                            }
                                            else
                                            {
                                                var usr = (FindAService_WebForm.UserBusiness)p;
                                                image = usr.ImageUrl;
                                                email = usr.Email;
                                                usrid = usr.ID;
                                                name = usr.BusinessName;
                                                fname = usr.BusinessName;
                                                me = usr.BusinessDescription;
                                                r_city = usr.City_ID;
                                                r_state = usr.State_ID;
                                                r_cntry = usr.Country_ID;
                                                var usr_bizcateg = db.BusinessCategories.Find(usr.BusinessCategory_ID);
                                                url = "?p=business&s=" + usr_bizcateg.Increment + "&u=" + email;
                                            }

                                            var _rating = db.UserRatings.Where(x => x.User_ID == usrid).ToList();

                                            var _star_1 = 0;
                                            var _star_2 = 0;
                                            var _star_3 = 0;
                                            var _star_4 = 0;
                                            var _star_5 = 0;

                                            if (_rating != null)
                                            {
                                                foreach (var r in _rating)
                                                {
                                                    _star_1 += ((_rating != null) && (int.Parse(r.Star1) == 1)) ? 1 : 0;
                                                    _star_2 += ((_rating != null) && (int.Parse(r.Star2) == 1)) ? 1 : 0;
                                                    _star_3 += ((_rating != null) && (int.Parse(r.Star3) == 1)) ? 1 : 0;
                                                    _star_4 += ((_rating != null) && (int.Parse(r.Star4) == 1)) ? 1 : 0;
                                                    _star_5 += ((_rating != null) && (int.Parse(r.Star5) == 1)) ? 1 : 0;
                                                }
                                            }

                                            var _ttal_rate_sum = ((_star_1 * 1) + (_star_2 * 2) + (_star_3 * 3) + (_star_4 * 4) + (_star_5 * 5));
                                            var _ttal_rate_cnt = (_star_1 + _star_2 + _star_3 + _star_4 + _star_5);
                                            double _ttal_rate = (_ttal_rate_sum > 0) ? Math.Round((double)((double)_ttal_rate_sum / (double)_ttal_rate_cnt), 1) : 0;
                                            Math.Ceiling(_ttal_rate);
                                %>
                                <div lstvw-obj="itm">
                                    <div itm-obj="avatar">
                                        <div info-obj="phldr"><i class="fa fa-user"></i></div>
                                        <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? image : ""); %>')"></div>
                                    </div>
                                    <div itm-obj="cmment">
                                        <div cmment-obj="name"><a href="<% Response.Write(url); %>"><% Response.Write(name); %></a></div>
                                        <div cmment-obj="rating">
                                            <div type="rating-mtr">
                                                <div hdr-obj="rating-wrappr">
                                                    <div wrappr-obj="rating">
                                                        <%
                                                                                                       var _whole_part = (int)Math.Truncate(_ttal_rate);
                                                                                                       var _decimal_prt = _ttal_rate - Math.Truncate(_ttal_rate);
                                                                                                       //
                                                                                                       for (var i = 1; i <= 5; i++)
                                                                                                       {
                                                                                                           var percent = 0.0;
                                                                                                           if (i <= Math.Ceiling(_ttal_rate))
                                                                                                           {
                                                                                                               percent = (i <= _whole_part) ? 100 : (_decimal_prt * 100);
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
                                        <%--<div cmment-obj="text"><% Response.Write((me.Trim() != "") ? me : "It seem " + name + " has not written anything about " + (p.Sex == "Male" ? "himself" : "herself") + ". Why not ask"); %></div>--%>
                                    </div>
                                    <form action="?p=dosendjobreqtosng&t=<% Response.Write(Request["t"]); %>&u=<% Response.Write(Request["u"]); %>" method="post">
                                        <input type="hidden" name="city-txt" value="<% Response.Write(r_city); %>" />
                                        <input type="hidden" name="state-txt" value="<% Response.Write(r_state); %>" />
                                        <input type="hidden" name="cntry-txt" value="<% Response.Write(r_cntry); %>" />
                                        <input type="hidden" name="rcpnt-txt" value="<% Response.Write(usrid); %>" />
                                        <input type="hidden" name="msg-txt" value="<% Response.Write((Session["msgTxt"] != null) ? Session["msgTxt"].ToString() : ""); %>" />
                                        <input type="hidden" name="sndr-txt" value="<% Response.Write(user.ID); %>" />
                                    </form>
                                    <div itm-obj="btn" name="<% Response.Write(fname); %>">Send</div>
                                </div>
                                <%
                                    }
                                    }
                                    else
                                    {
                                        var str = "";
                                        if ((Request["t"] != null) && (Request["t"] == "0"))
                                        {
                                            str = (Request["c"] != null) ? db.Services.Where(x => x.Increment == c).FirstOrDefault().ServiceTitle : servces.FirstOrDefault().ServiceTitle;
                                        }
                                        else
                                        {
                                            str = (Request["c"] != null) ? db.BusinessCategories.Where(x => x.Increment == c).FirstOrDefault().BusinessCategoryTitle : db.BusinessCategories.FirstOrDefault().BusinessCategoryTitle;
                                        }
                                %>
                                <div lstvw-obj="srch-pnl">
                                    <div srch-pnl-obj="hdr">Search Complete!</div>
                                    <div srch-pnl-obj="bdy">No service agent was found under "<b><% Response.Write(str); %></b>". Please choose another service to continue.</div>
                                </div>
                                <%   
                                    }

                                    if ((Session["totalPages"] != null) && ((int)Session["totalPages"] > 1))
                                    {
                                %>
                                <div lstvw-obj="paging">
                                    <div paging-obj="pages">
                                        <%
                                        var pages = individualCntrllr.ShowPages();
                                        Response.Write(pages);                                                  
                                        %>
                                    </div>
                                    <div paging-obj="title"><% Response.Write("Page " + Session["currentPage"] + " of " + Session["totalPages"]); %></div>
                                </div>
                                <%
                                    }    
                                %>
                            </div>
                            <%
                            }
                            else if ((Request != null) && (Request["m"] == "vw"))
                            {
                                var msg = notifCntrllr.GetIndividualNotification(new FindAService_WebForm.UserIndividual
                                {
                                    ID = user.ID,
                                    Service_ID = user.Service_ID
                                }, int.Parse(Request["i"]));
                                var msg_str = msg.Message.Replace("\r\n", "<br />");

                                var usrid = "";
                                var image = "";
                                var email = "";
                                var name = "";
                                var about = "";
                                var url = "";
                                var cntact = "";

                                var iusr = db.UserIndividuals.Where(x => x.ID == msg.Sender).FirstOrDefault();
                                if (iusr != null)
                                {
                                    usrid = iusr.ID;
                                    image = iusr.ImageUrl;
                                    email = iusr.Email;
                                    name = iusr.FirstName + " " + iusr.LastName;
                                    about = iusr.AboutMe;
                                    var iusr_service = db.Services.Find(iusr.Service_ID);
                                    url = "?p=individual&s=" + iusr_service.Increment + "&u=" + email;
                                    cntact = "Agent";
                                }
                                else
                                {
                                    var busr = db.UserBusinesses.Where(x => x.ID == msg.Sender).FirstOrDefault();
                                    if (busr != null)
                                    {
                                        usrid = busr.ID;
                                        image = busr.ImageUrl;
                                        email = busr.Email;
                                        name = busr.BusinessName;
                                        about = busr.BusinessDescription;
                                        var busr_bizcateg = db.BusinessCategories.Find(busr.BusinessCategory_ID);
                                        url = "?p=business&s=" + busr_bizcateg.Increment + "&u=" + email;
                                        cntact = "Company";
                                    }
                                }

                                var _rating = db.UserRatings.Where(x => x.User_ID == usrid).ToList();

                                var _star_1 = 0;
                                var _star_2 = 0;
                                var _star_3 = 0;
                                var _star_4 = 0;
                                var _star_5 = 0;

                                if (_rating != null)
                                {
                                    foreach (var r in _rating)
                                    {
                                        _star_1 += ((_rating != null) && (int.Parse(r.Star1) == 1)) ? 1 : 0;
                                        _star_2 += ((_rating != null) && (int.Parse(r.Star2) == 1)) ? 1 : 0;
                                        _star_3 += ((_rating != null) && (int.Parse(r.Star3) == 1)) ? 1 : 0;
                                        _star_4 += ((_rating != null) && (int.Parse(r.Star4) == 1)) ? 1 : 0;
                                        _star_5 += ((_rating != null) && (int.Parse(r.Star5) == 1)) ? 1 : 0;
                                    }
                                }

                                var _ttal_rate_sum = ((_star_1 * 1) + (_star_2 * 2) + (_star_3 * 3) + (_star_4 * 4) + (_star_5 * 5));
                                var _ttal_rate_cnt = (_star_1 + _star_2 + _star_3 + _star_4 + _star_5);
                                double _ttal_rate = (_ttal_rate_sum > 0) ? Math.Round((double)((double)_ttal_rate_sum / (double)_ttal_rate_cnt), 1) : 0;
                                Math.Ceiling(_ttal_rate);
                            %>
                            <div cmmnt-lstvw-obj="readervw">
                                <div readervw-obj="hdr">
                                    <div hdr-obj="pnl">
                                        <div pnl-obj="avatar">
                                            <div info-obj="phldr"><i class="fa fa-user"></i></div>
                                            <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? image : ""); %>')"></div>
                                        </div>
                                        <div pnl-obj="info">
                                            <div info-obj="name"><a href="<% Response.Write(url); %>"><% Response.Write(name); %></a></div>
                                            <div cmment-obj="rating">
                                                <div type="rating-mtr">
                                                    <div hdr-obj="rating-wrappr">
                                                        <div wrappr-obj="rating">
                                                            <%
                                                                                                         var _whole_part = (int)Math.Truncate(_ttal_rate);
                                                                                                         var _decimal_prt = _ttal_rate - Math.Truncate(_ttal_rate);
                                                                                                         //
                                                                                                         for (var i = 1; i <= 5; i++)
                                                                                                         {
                                                                                                             var percent = 0.0;
                                                                                                             if (i <= Math.Ceiling(_ttal_rate))
                                                                                                             {
                                                                                                                 percent = (i <= _whole_part) ? 100 : (_decimal_prt * 100);
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
                                            <div info-obj="about"><% Response.Write(about); %></div>
                                            <div info-obj="buttn">
                                                <div buttn-obj="btn"><a href="<% Response.Write(url); %>">Contact <% Response.Write(cntact); %></a></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div readervw-obj="bdy"><% Response.Write(msg_str); %></div>
                            </div>
                            <%
                            }
                            else
                            {
                            %>
                            <div cmmnt-lstvw-obj="hdr">
                                <div>
                                    <form id="post-msg-frm" action="?p=dopostjobmsg&t=<% Response.Write(Request["p"]); %>&u=<% Response.Write(Request["u"]); %>" method="post">
                                        <textarea hdr-obj="txt-pad" id="msg-txt" name="msg-txt"></textarea>
                                        <div hdr-obj="btn-pad">
                                            <div btn-pad-obj="cmb">
                                                <input type="hidden" id="page-txt" name="page-txt" value="<% Response.Write(user.ID); %>" />
                                                <select name="rtype-cmb">
                                                    <option value="0" selected="selected">Individual Services</option>
                                                    <option value="1">Companies</option>
                                                </select>
                                            </div>
                                            <div btn-pad-obj="btn" selected id="continue-btn" page-user-id="<% Response.Write(user.Email); %>">Continue</div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div cmmnt-lstvw-obj="lstvw">
                                <div lstvw-obj="title">Available Request:</div>
                                <%
                                                                                                               var page = 0;
                                                                                                               int.TryParse(Request["page"], out page);
                                                                                                               var msgs = notifCntrllr.GetIndividualNotifications(new FindAService_WebForm.UserIndividual
                                                                                                               {
                                                                                                                   ID = user.ID,
                                                                                                                   Country_ID = user.Country_ID,
                                                                                                                   State_ID = user.State_ID,
                                                                                                                   City_ID = user.City_ID,
                                                                                                                   Service_ID = user.Service_ID,
                                                                                                                   RegistrationDate = user.RegistrationDate
                                                                                                               }, (Request["page"] != null ? page : 1));

                                                                                                               foreach (var msg in msgs)
                                                                                                               {
                                                                                                                   var name = "";
                                                                                                                   var image = "";
                                                                                                                   var email = "";
                                                                                                                   var url = "";
                                                                                                                   var count = db.UserJobBoxNotificationStatus.Where(x => (x.User_ID == user.ID || x.User_ID == user.Service_ID) && x.Notification_ID == msg.ID && x.Status != (int)FindAService_WebForm.JobBoxNotificationStatus.Read).Count();
                                                                                                                   var status = (count > 0) ? "mark" : "";

                                                                                                                   var iusr = db.UserIndividuals.Where(x => x.ID == msg.Sender).FirstOrDefault();
                                                                                                                   if (iusr != null)
                                                                                                                   {
                                                                                                                       name = iusr.FirstName + " " + iusr.LastName;
                                                                                                                       image = iusr.ImageUrl;
                                                                                                                       email = iusr.Email.ToLower();
                                                                                                                       var iusr_service = db.Services.Find(iusr.Service_ID);
                                                                                                                       url = "?p=individual&s=" + iusr_service.Increment + "&u=" + email;
                                                                                                                   }
                                                                                                                   else
                                                                                                                   {
                                                                                                                       var busr = db.UserBusinesses.Where(x => x.ID == msg.Sender).FirstOrDefault();
                                                                                                                       name = busr.BusinessName;
                                                                                                                       image = busr.ImageUrl;
                                                                                                                       email = busr.Email.ToLower();
                                                                                                                       var busr_bizcateg = db.BusinessCategories.Find(busr.BusinessCategory_ID);
                                                                                                                       url = "?p=business&s=" + busr_bizcateg.Increment + "&u=" + email;
                                                                                                                   }
                                %>
                                <div lstvw-obj="itm" <% Response.Write(status); %> url="?p=account&tb=2&t=<% Response.Write(Request["p"]); %>&u=<% Response.Write(Request["u"]); %>&m=vw&i=<% Response.Write(msg.Increment); %>&<% Response.Write(DateTime.Now.Ticks.ToString("x")); %>">
                                    <div itm-obj="avatar">
                                        <div info-obj="phldr"><i class="fa fa-user"></i></div>
                                        <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? image : ""); %>')"></div>
                                    </div>
                                    <div itm-obj="cmment">
                                        <div cmment-obj="name"><a href="<% Response.Write(url); %>"><% Response.Write(name); %></a></div>
                                        <div cmment-obj="date"><% Response.Write(msg.DateSent.ToShortDateString()); %></div>
                                        <div cmment-obj="text"><% Response.Write(msg.Message); %></div>
                                    </div>
                                    <div itm-obj="buttn">
                                        <i class="fa fa-trash"></i>
                                        <form action="?p=doremovejobposting&u=<% Response.Write(Request["u"]); %>" method="post" enctype="application/x-www-form-urlencoded">
                                            <input name="usr_txt" type="hidden" value="<% Response.Write(user.ID); %>" />
                                            <input name="grp_txt" type="hidden" value="<% Response.Write(msg.Recepient); %>" />
                                            <input name="notfcn_txt" type="hidden" value="<% Response.Write(msg.ID); %>" />
                                        </form>
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
                                        var pages = individualCntrllr.ShowPages();
                                        Response.Write(pages);                                                  
                                        %>
                                    </div>
                                    <div paging-obj="title"><% Response.Write("Page " + Session["currentPage"] + " of " + Session["totalPages"]); %></div>
                                </div>
                                <%
                                    }    
                                %>
                            </div>
                            <%
                            }
                            %>
                        </div>
                    </div>
                    <%
                        }
                        else
                        {
                    %>
                    <div brd-obj="row" class="comment-lstvw">
                        <div row-obj="cmmnt-lstvw">
                            <div cmmnt-lstvw-obj="hdr">
                                <div hdr-obj="noticebrd">
                                    <div noticebrd-obj="hdr">
                                        <span icon><i class="fa fa-check"></i></span>
                                        <span>Successfully Sent</span>
                                    </div>
                                    <%
                            var msg = "";
                            var categ = "";
                            if ((Request["t"] != null) && (Request["t"] == "0"))
                            {
                                if (Session["group-msg"] != null)
                                {
                                    var rcpient = (FindAService_WebForm.Service)Session["rcpient"];
                                    var serv = db.Services.Where(x => x.Increment == rcpient.Increment).FirstOrDefault();
                                    msg = "Your request for qualified <b>\"" + serv.ServiceTitle.ToLower() + "\"</b> was sent successfully.";
                                }
                                else
                                {
                                    var rcpient = (FindAService_WebForm.UserIndividual)Session["rcpient"];
                                    msg = "Your request to <b>\"" + rcpient.FirstName + " " + rcpient.LastName + "\"</b> was sent successfully.";
                                }
                            }
                            else
                            {
                                if (Session["group-msg"] != null)
                                {
                                    var rcpient = (FindAService_WebForm.BusinessCategory)Session["rcpient"];
                                    var bcateg = db.BusinessCategories.Where(x => x.Increment == rcpient.Increment).FirstOrDefault();
                                    msg = "Your request for qualified <b>\"" + bcateg.BusinessCategoryTitle + "\"</b> companies was sent successfully.";
                                }
                                else
                                {
                                    var rcpient = (FindAService_WebForm.UserBusiness)Session["rcpient"];
                                    msg = "Your request to <b>\"" + rcpient.BusinessName + "\"</b> was sent successfully.";
                                }
                            }   
                                    %>
                                    <div noticebrd-obj="hint"><% Response.Write(msg); %></div>
                                </div>
                            </div>
                            <div cmmnt-lstvw-obj="lstvw">
                                <%
                                                                 var class_of_peopl = "";
                                                                 var class_of_city = "";
                                                                 if ((Request["t"] != null) && (Request["t"] == "0"))
                                                                 {
                                                                     class_of_peopl = "Services";
                                                                     class_of_city = System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase((city != null) ? ((FindAService_WebForm.City)city).CityName : user_city.CityName);
                                                                 }
                                                                 else
                                                                 {
                                                                     class_of_peopl = "Companies";
                                                                     class_of_city = System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase((city != null) ? ((FindAService_WebForm.City)city).CityName : user_city.CityName);
                                                                 }
                                %>
                                <div lstvw-obj="title">Other <% Response.Write(class_of_peopl); %> You May Like</div>
                                <%
                                                                var page = 0;
                                                                int.TryParse(Request["page"], out page);

                                                                var c = (Request["c"] != null) ? int.Parse(Request["c"]) : 0;

                                                                var s_city = ((city != null) ? ((FindAService_WebForm.City)city).ID : user.City_ID);
                                                                var s_state = ((state != null) ? ((FindAService_WebForm.State)state).ID : user.State_ID);
                                                                var s_country = ((country != null) ? ((FindAService_WebForm.Country)country).ID : user.Country_ID);

                                                                var results = (dynamic)null;
                                                                if ((Request["t"] != null) && (Request["t"] == "0"))
                                                                {
                                                                    results = individualCntrllr.GetPagedUsers(new FindAService_WebForm.Service
                                                                    {
                                                                        ID = null
                                                                    }, s_country, s_state, s_city, (Request["page"] != null ? page : 1));
                                                                }
                                                                else
                                                                {
                                                                    results = businessCntrllr.GetPagedUsers(new FindAService_WebForm.BusinessCategory
                                                                    {
                                                                        ID = null
                                                                    }, s_country, s_state, s_city, (Request["page"] != null ? page : 1));
                                                                }

                                                                foreach (var p in results)
                                                                {
                                                                    var image = "";
                                                                    var email = "";
                                                                    var usrid = "";
                                                                    var name = "";
                                                                    var fname = "";
                                                                    var me = "";
                                                                    var r_city = "";
                                                                    var url = "";

                                                                    if ((Request["t"] != null) && (Request["t"] == "0"))
                                                                    {
                                                                        var usr = (FindAService_WebForm.UserIndividual)p;
                                                                        image = usr.ImageUrl;
                                                                        email = usr.Email;
                                                                        usrid = usr.ID;
                                                                        name = usr.FirstName + " " + usr.LastName;
                                                                        fname = usr.FirstName;
                                                                        me = ((usr.AboutMe != null)) ? usr.AboutMe : "It seem " + name + " has not written anything about " + (usr.Sex == "Male" ? "himself" : "herself") + ". Why not ask";
                                                                        r_city = usr.City_ID;
                                                                        var usr_service = db.Services.Find(usr.Service_ID);
                                                                        url = "?p=individual&s=" + usr_service.Increment + "&u=" + email;
                                                                    }
                                                                    else
                                                                    {
                                                                        var usr = (FindAService_WebForm.UserBusiness)p;
                                                                        image = usr.ImageUrl;
                                                                        email = usr.Email;
                                                                        usrid = usr.ID;
                                                                        name = usr.BusinessName;
                                                                        fname = usr.BusinessName;
                                                                        me = (usr.BusinessDescription.Trim() != "") ? usr.BusinessDescription : "It seem " + name + " has not written anything about itself. Why not ask";
                                                                        r_city = usr.City_ID;
                                                                        var usr_bizcateg = db.BusinessCategories.Find(usr.BusinessCategory_ID);
                                                                        url = "?p=business&s=" + usr_bizcateg.Increment + "&u=" + email;
                                                                    }

                                                                    var _rating = db.UserRatings.Where(x => x.User_ID == usrid).ToList();

                                                                    var _star_1 = 0;
                                                                    var _star_2 = 0;
                                                                    var _star_3 = 0;
                                                                    var _star_4 = 0;
                                                                    var _star_5 = 0;

                                                                    if (_rating != null)
                                                                    {
                                                                        foreach (var r in _rating)
                                                                        {
                                                                            _star_1 += ((_rating != null) && (int.Parse(r.Star1) == 1)) ? 1 : 0;
                                                                            _star_2 += ((_rating != null) && (int.Parse(r.Star2) == 1)) ? 1 : 0;
                                                                            _star_3 += ((_rating != null) && (int.Parse(r.Star3) == 1)) ? 1 : 0;
                                                                            _star_4 += ((_rating != null) && (int.Parse(r.Star4) == 1)) ? 1 : 0;
                                                                            _star_5 += ((_rating != null) && (int.Parse(r.Star5) == 1)) ? 1 : 0;
                                                                        }
                                                                    }

                                                                    var _ttal_rate_sum = ((_star_1 * 1) + (_star_2 * 2) + (_star_3 * 3) + (_star_4 * 4) + (_star_5 * 5));
                                                                    var _ttal_rate_cnt = (_star_1 + _star_2 + _star_3 + _star_4 + _star_5);
                                                                    double _ttal_rate = (_ttal_rate_sum > 0) ? Math.Round((double)((double)_ttal_rate_sum / (double)_ttal_rate_cnt), 1) : 0;
                                                                    Math.Ceiling(_ttal_rate);
                                %>
                                <div lstvw-obj="itm">
                                    <div itm-obj="avatar">
                                        <div info-obj="phldr"><i class="fa fa-user"></i></div>
                                        <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? image : ""); %>')"></div>
                                    </div>
                                    <div itm-obj="cmment">
                                        <div cmment-obj="name"><a href="<% Response.Write(url); %>"><% Response.Write(name); %></a></div>
                                        <div cmment-obj="rating">
                                            <div type="rating-mtr">
                                                <div hdr-obj="rating-wrappr">
                                                    <div wrappr-obj="rating">
                                                        <%
                                                                                                       var _whole_part = (int)Math.Truncate(_ttal_rate);
                                                                                                       var _decimal_prt = _ttal_rate - Math.Truncate(_ttal_rate);
                                                                                                       //
                                                                                                       for (var i = 1; i <= 5; i++)
                                                                                                       {
                                                                                                           var percent = 0.0;
                                                                                                           if (i <= Math.Ceiling(_ttal_rate))
                                                                                                           {
                                                                                                               percent = (i <= _whole_part) ? 100 : (_decimal_prt * 100);
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
                                        <div cmment-obj="text"><% Response.Write(me); %></div>
                                    </div>
                                    <form action="?p=dosendjobreqtosng&t=<% Response.Write(Request["t"]); %>&u=<% Response.Write(Request["u"]); %>" method="post">
                                        <input type="hidden" name="city-txt" value="<% Response.Write(r_city); %>" />
                                        <input type="hidden" name="rcpnt-txt" value="<% Response.Write(usrid); %>" />
                                        <input type="hidden" name="msg-txt" value="<% Response.Write((Session["msgTxt"] != null) ? Session["msgTxt"].ToString() : ""); %>" />
                                        <input type="hidden" name="sndr-txt" value="<% Response.Write(user.ID); %>" />
                                    </form>
                                </div>
                                <%
                                    }

                                    if ((Session["totalPages"] != null) && ((int)Session["totalPages"] > 1))
                                    {
                                %>
                                <div lstvw-obj="paging">
                                    <div paging-obj="pages">
                                        <%
                                    if ((Request["t"] != null) && (Request["t"] == "0"))
                                    {
                                        var pages = individualCntrllr.ShowPages();
                                        Response.Write(pages);
                                    }
                                    else
                                    {
                                        var pages = businessCntrllr.ShowPages();
                                        Response.Write(pages);
                                    }                                                 
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
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    
    <%--<div wnd-obj="diag">
        <div diag-obj="chrome">
            <div chrome-obj="msag"></div>
            <div chrome-obj="bttn">
                <div bttn-obj="no">Cancel</div>
                <div bttn-obj="yes">Yes, Proceed</div>
            </div>
        </div>
    </div>--%>

</asp:Content>
<asp:Content ID="location_dialog" ContentPlaceHolderID="location_dialog" runat="server">
    <%
        var businessCntrllr = new FindAService_WebForm.Controllers.BusinessUserController();
        var individualCntrllr = new FindAService_WebForm.Controllers.IndividualUserController();
        var notifCntrllr = new FindAService_WebForm.Controllers.NotificationController();
        var user = individualCntrllr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = (Session["user_account_email"] != null) ? Session["user_account_email"].ToString() : Request["u"]
        });
        var db = new FindAService_WebForm.FASDBEntities();

        var city = (dynamic)null;
        var state = (dynamic)null;
        var country = (dynamic)null;

        if (Session["current_loc"] != null)
        {
            object sess_obj = Session["current_loc"];
            Type t = sess_obj.GetType();
            System.Reflection.PropertyInfo city_pi = t.GetProperty("city");
            System.Reflection.PropertyInfo state_pi = t.GetProperty("state");
            System.Reflection.PropertyInfo country_pi = t.GetProperty("country");
            city = (FindAService_WebForm.City)city_pi.GetValue(sess_obj, null);
            state = (FindAService_WebForm.State)state_pi.GetValue(sess_obj, null);
            country = (FindAService_WebForm.Country)country_pi.GetValue(sess_obj, null);
        }


        var s_c = "";
        if ((Request["t"] != null) && (Request["t"] == "0"))
        {
            var servces = db.Services.ToList();
            if(servces.FirstOrDefault() != null)
                s_c = servces.FirstOrDefault().Increment.ToString();
        }
        else
        {
            var bcateg = db.BusinessCategories.ToList();
            if(bcateg.FirstOrDefault() != null)
                s_c = bcateg.FirstOrDefault().Increment.ToString();
        }
    %>
    <form id="changeloctnfrm" action="?p=dochangeloctn&r=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&u=<% Response.Write(Request["u"]); %>&m=<% Response.Write(Request["m"]); %>&t=<% Response.Write(Request["t"]); %>&c=<% Response.Write(Request["c"] != null ? Request["c"] : s_c); %>" method="post" enctype="application/x-www-form-urlencoded">
        <div frm-obj="rw">
            <div rw-obj="label">Country:</div>
            <div rw-obj="field">
                <select name="cmbCntry" id="<% Response.Write((country != null) ? ((FindAService_WebForm.Country)country).ID : user.Country_ID); %>">
                    <%
                                    foreach (var cntry in db.Countries.ToList())
                                    {    
                    %>
                    <option value="<% Response.Write(cntry.ID); %>" <% Response.Write((user != null && user.Country_ID == cntry.ID) ? "selected=\"selected\"" : ""); %>><% Response.Write(cntry.CountryName); %></option>
                    <%
                                    }
                    %>
                </select>
            </div>
        </div>
        <div frm-obj="rw">
            <div rw-obj="label">State:</div>
            <div rw-obj="field">
                <select name="cmbState" id="<% Response.Write((state != null) ? ((FindAService_WebForm.State)state).ID : user.State_ID); %>">
                    <%
                                    var states = db.States.Where(x => x.Country_ID == user.Country_ID).ToList();
                                    foreach (var c_state in states)
                                    {    
                    %>
                    <option value="<% Response.Write(c_state.ID); %>" <% Response.Write((user != null && user.State_ID == c_state.ID) ? "selected=\"selected\"" : ""); %>><% Response.Write(c_state.StateName); %></option>
                    <%
                                    }
                    %>
                </select>
            </div>
        </div>
        <div frm-obj="rw">
            <div rw-obj="label">City:</div>
            <div rw-obj="field">
                <select name="cmbCity" id="<% Response.Write((city != null) ? ((FindAService_WebForm.City)city).ID : user.City_ID); %>">
                    <%
                                    var cities = db.Cities.Where(x => x.State_ID == user.State_ID).ToList();
                                    foreach (var s_city in cities)
                                    {    
                    %>
                    <option value="<% Response.Write(s_city.ID); %>" <% Response.Write((user != null && user.City_ID == s_city.ID) ? "selected=\"selected\"" : ""); %>><% Response.Write(s_city.CityName); %></option>
                    <%
                                    }
                    %>
                </select>
            </div>
        </div>
    </form>
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

