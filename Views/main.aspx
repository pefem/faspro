<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="FindAService_WebForm.MainPage" %>

<%
    var db = new FindAService_WebForm.FASDBEntities();
    var logged_in_usr = "";
    if (Session["user_account_email"] != null)
    {
        logged_in_usr = Session["user_account_email"].ToString();
    }

    //Session.RemoveAll();

    var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
                                    
%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width" />
    <title><% Response.Write(ConfigurationManager.AppSettings["site_title"].ToString()); %></title>
    <link rel="icon" href="/favicon.png" />
    <link rel="icon" href="/favicon.ico" />
    <%
        Response.AddHeader("Cache-control", "no-store, must-revalidate, private,no-cache");
        Response.AddHeader("Pragma", "no-cache");
        Response.AddHeader("Expires", "0");
    %>
</head>
<body>
    <link rel="stylesheet" href="Content/css/vendors/font.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/vendors/font-awesome.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/vendors/icon.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/widgets/form.element.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/widgets/banner.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.home.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.style.css" type="text/css" />

    <div page="layout">
        <div layout-obj="headr">
            <div headr-obj="headr-wrappr">
                <div wrappr-obj="left">
                    <div left-obj="logo" logo></div>
                </div>
                <div wrappr-obj="right">
                    <div right-obj="menu-btn">
                        <div btn-obj="shape"></div>
                        <%
                            if (Session["user_account_active"] == null || ((bool)Session["user_account_active"]) != true)
                            {
                        %>
                        <div btn-obj="menu-list">
                            <div menu-obj="item"><b><% Response.Write(Request.Cookies["page"]["location"]); %></b></div>
                            <%
                                //if (howitworks != null)
                                //{
                                //    var hwitwrk_cntnt = db.Contents.Where(x => x.Category_ID == howitworks.ID).OrderBy(x => x.Increment).FirstOrDefault();
                                //    if (hwitwrk_cntnt != null)
                                //    {
                            %>
                            <%--<div menu-obj="item"><a href="?p=content&category=<% Response.Write(howitworks.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(hwitwrk_cntnt.Increment); %>">How it works</a></div>--%>
                            <%
                                //    }
                                //}
                            %>
                            <%--<div menu-obj="item"><a href="?p=advertise">Advertise</a></div>--%>
                            <div menu-obj="item"><a href="?p=blog">Blog</a></div>
                            <div menu-obj="item"><a href="?p=login">Login</a></div>
                            <div menu-obj="item" aria-selected="true"><a href="?p=signup">Sign Up</a></div>
                        </div>
                        <%
                            }
                            else
                            {

                                var name = "";

                                var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
                                var iuser = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
                                {
                                    Email = logged_in_usr
                                });
                                if (iuser != null)
                                {
                                    name = iuser.FirstName;
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
                                    }
                                }
                        %>
                        <div btn-obj="menu-list">
                            <div menu-obj="item"><span text><a href="?p=account&u=<% Response.Write(logged_in_usr); %>"><% Response.Write("Welcome, " + name); %></a></span></div>
                            <div menu-obj="item"><span text><a href="?p=blog">Blog</a></span></div>
                            <div menu-obj="item"><span text><a href="?p=logout">Logout</a></span></div>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
            <div headr-obj="bannr">
                <div bannr-obj="search-wrappr">
                    <div srch-wrappr-obj="srch-hdr">
                        <div srch-hdr-obj="title">What are you looking for?</div>
                        <div srch-hdr-obj="hint">See who provides the service you require in your neighborhood...</div>
                    </div>
                    <div srch-wrappr-obj="srch-bdy">
                        <div srch-bdy-obj="tab">
                            <ul tab-obj="tab-btn-wrappr">
                                <li tab-obj="btn" form="iform" selected="true">Individual</li>
                                <li tab-obj="btn" form="cform">Corporate</li>
                            </ul>
                        </div>
                        <div srch-bdy-obj="tabpage">
                            <div tabpage-obj="pnl" ftype="iform">
                                <form method="post" action="?p=dosearch&t=<% Response.Write(FindAService_WebForm.UserType.Individual); %>" enctype="application/x-www-form-urlencoded" accept-charset="">
                                    <div pnl-obj="srch-itm">
                                        <div srch-itm="field">
                                            <input type="text" name="what_txt" id="what_txt" placeholder="What 're you looking for?..." />
                                        </div>
                                        <div srch-itm="dropdwn"></div>
                                    </div>
                                    <div pnl-obj="srch-loc">
                                        <div srch-loc="field">
                                            <input type="text" name="where_txt" id="where_txt" placeholder="Location..." />
                                        </div>
                                        <div srch-loc="dropdwn"></div>
                                    </div>
                                    <div pnl-obj="srch-btn">
                                        <input type="submit" id="find_btn" value="Find" />
                                    </div>
                                    <div clear></div>
                                </form>
                            </div>
                            <div tabpage-obj="pnl" ftype="cform" class="hide_form">
                                <form method="post" action="?p=dosearch&t=<% Response.Write(FindAService_WebForm.UserType.Business); %>" enctype="application/x-www-form-urlencoded" accept-charset="">
                                    <div pnl-obj="srch-itm">
                                        <div srch-itm="field">
                                            <select name="what_txt" id="what_txt">
                                                <%
                                                    var businesscategoriess = new FindAService_WebForm.Controllers.BusinessCategoryController().GetBusinessCategories();
                                                    if (businesscategoriess != null)
                                                    {
                                                        foreach (var category in businesscategoriess)
                                                        {
                                                %>
                                                <option><% Response.Write(category.BusinessCategoryTitle); %></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div srch-itm="dropdwn"></div>
                                    </div>
                                    <div pnl-obj="srch-loc">
                                        <div srch-loc="field">
                                            <input type="text" name="where_txt" id="where_txt" placeholder="Location" />
                                        </div>
                                        <div srch-loc="dropdwn"></div>
                                    </div>
                                    <div pnl-obj="srch-btn">
                                        <input type="submit" id="btnCS" text="Find" />
                                    </div>
                                    <div clear></div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <%--<div srch-wrappr-obj="srch-ftr">
                        <div srch-ftr-obj="lft-pane">
                            <div pane-obj="title">10K+</div>
                            <div pane-obj="hint">Businesses Nationwide</div>
                        </div>
                        <div srch-ftr-obj="splittr"></div>
                        <div srch-ftr-obj="rgt-pane">
                            <div pane-obj="title">1+</div>
                            <div pane-obj="hint">Million Subscribers</div>
                        </div>
                    </div>--%>
                </div>
                <div bannr-obj="bannr-wrappr">
                    <div wrappr-obj="bannr"></div>
                </div>
                <div bannr-obj="buttn-wrappr">
                    <div wrappr-obj="cntainr">
                        <div cntainr-obj="buttn"></div>
                    </div>
                </div>
            </div>
        </div>
        <div layout-obj="body">
            <%
                var app_dwnld_ads = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_apps_ads).FirstOrDefault();
                if (app_dwnld_ads != null)
                {
            %>
            <div body-obj="mobile-apps-pnl">
                <div pnl-obj="wrappr">
                    <%
                    var app_dwnld_ads_cntnt = db.Contents.Where(x => x.Category_ID == app_dwnld_ads.ID).OrderBy(x => x.Increment).FirstOrDefault();
                    if (app_dwnld_ads_cntnt != null)
                    {
                    %>
                    <div wrappr-obj="lft-pnl" style="background-image: url('?p=contentimage&url=<% Response.Write(app_dwnld_ads_cntnt.CoverImage); %>')"><a href="?p=content&category=<% Response.Write(app_dwnld_ads.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(app_dwnld_ads_cntnt.Increment); %>"></a></div>
                    <div wrappr-obj="rgt-pnl">
                        <div pnl-obj="hdr"><a href="?p=content&category=<% Response.Write(app_dwnld_ads.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(app_dwnld_ads_cntnt.Increment); %>"><% Response.Write(app_dwnld_ads.CategoryTitle); %></a></div>
                        <div pnl-obj="bdy">
                            <div bdy-obj="text"><% Response.Write(app_dwnld_ads.Description); %></div>
                        </div>
                        <div pnl-obj="store">
                            <div store-obj="store-itm" class="android_store_ico"></div>
                            <div store-obj="store-itm" class="apple_store_ico"></div>
                            <div store-obj="store-itm" class="bberry_store_ico"></div>
                            <div store-obj="store-itm" class="windows_store_ico"></div>
                        </div>
                    </div>
                    <%
                    }
                    %>
                </div>
            </div>
            <%
                }    
            %>
            <div body-obj="biz-catlg-pnl">
                <div biz-catlg-obj="top-wrappr">
                    <div top-wrappr-obj="topvw">
                        <div topvw-obj="lft-pane">
                            <div lft-pane-obj="hdr">
                                <div hdr-obj="title">Individual Services</div>
                            </div>
                            <div lft-pane-obj="lstvw">
                                <%
                                    var services = new FindAService_WebForm.Controllers.ServicesController().GetServices();
                                    foreach (var itm in services)
                                    {
                                %>
                                <div lstvw-obj="lst-itm">
                                    <div id="" lst-itm-obj="img"></div>
                                    <div lst-itm-obj="txt"><a href="?p=searchresult&t=iu&q=<% Response.Write(itm.ServiceTitle); %>"><% Response.Write(itm.ServiceTitle); %></a></div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <div lft-pane-obj="btm">
                                <div btm-obj="button">
                                    <a href="?p=searchresult&t=iu">See All</a>
                                </div>
                            </div>
                        </div>
                        <div topvw-obj="rgt-pane">
                            <div lft-pane-obj="hdr">
                                <ul>
                                    <li>Featured</li>
                                </ul>
                            </div>
                            <div lft-pane-obj="tilevw">
                                <div tilevw-obj="lft-tile">
                                    <div lft-tile-obj="wrappr">
                                        <%
                                            var m_adverts = new FindAService_WebForm.Controllers.AdsController().GetAds((int)FindAService_WebForm.AdsBannerDimension.Dimen_580x380);
                                            var m_advert = m_adverts.ElementAtOrDefault(new Random().Next(0, m_adverts.Count));
                                            if (m_advert != null)
                                            {
                                                var ownr_url = "";
                                                var iownr = db.UserIndividuals.Where(x => x.ID == m_advert.User_ID).FirstOrDefault();
                                                if (iownr != null)
                                                {
                                                    var iownr_service = db.Services.Find(iownr.Service_ID);
                                                    ownr_url = "?p=individual&s=" + iownr_service.Increment + "&u=" + iownr.Email.ToLower();
                                                }
                                                else
                                                {
                                                    var bownr = db.UserBusinesses.Where(x => x.ID == m_advert.User_ID).FirstOrDefault();
                                                    if (bownr != null)
                                                    {
                                                        var bownr_bizcateg = db.BusinessCategories.Find(bownr.BusinessCategory_ID);
                                                        ownr_url = "?p=business&s=" + bownr_bizcateg.Increment + "&u=" + bownr.Email.ToLower();
                                                    }
                                                }

                                                var m_ad_campaign = m_advert.AdsCampaigns.OrderBy(x => Guid.NewGuid()).FirstOrDefault();
                                                if (m_ad_campaign != null)
                                                {
                                                    foreach (var itm in m_ad_campaign.AdsCampaignBanners)
                                                    {
                                        %>
                                        <div wrappr-obj="itm" style="background-image: url('?p=adbanner&url=<% Response.Write(itm.ImageUrl); %>')">
                                            <a href="<% Response.Write(((m_ad_campaign != null) && (m_ad_campaign.URL != "")) ? m_ad_campaign.URL : ownr_url); %>" target="_blank"></a>
                                        </div>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </div>
                                </div>
                                <div tilevw-obj="rgt-tile">
                                    <%
                                        var _266_x_188 = new FindAService_WebForm.Controllers.AdsController().GetAds((int)FindAService_WebForm.AdsBannerDimension.Dimen_266x188).Take(2).ToList();
                                        if (_266_x_188 != null)
                                        {
                                            foreach (var ad in _266_x_188)
                                            {
                                                if (ad != null)
                                                {
                                                    var ownr_url = "";
                                                    var iownr = db.UserIndividuals.Where(x => x.ID == ad.User_ID).FirstOrDefault();
                                                    if (iownr != null)
                                                    {
                                                        var iownr_service = db.Services.Find(iownr.Service_ID);
                                                        ownr_url = "?p=individual&s=" + iownr_service.Increment + "&u=" + iownr.Email.ToLower();
                                                    }
                                                    else
                                                    {
                                                        var bownr = db.UserBusinesses.Where(x => x.ID == ad.User_ID).FirstOrDefault();
                                                        if (bownr != null)
                                                        {
                                                            var bownr_bizcateg = db.BusinessCategories.Find(bownr.BusinessCategory_ID);
                                                            ownr_url = "?p=business&s=" + bownr_bizcateg.Increment + "&u=" + bownr.Email.ToLower();
                                                        }
                                                    }

                                                    var rt_ad_cmpgns = ad.AdsCampaigns;
                                                    if (rt_ad_cmpgns != null)
                                                    {
                                                        var rt_ad_cmpgn = rt_ad_cmpgns.ElementAtOrDefault(new Random().Next(0, rt_ad_cmpgns.Count));
                                                        if (rt_ad_cmpgn != null)
                                                        {
                                                            var rt_ad_cmpgn_bnrs = rt_ad_cmpgn.AdsCampaignBanners.ToList();
                                                            var rt_ad_cmpgn_bnr = rt_ad_cmpgn_bnrs.ElementAtOrDefault(new Random().Next(0, rt_ad_cmpgn_bnrs.Count));
                                    %>
                                    <div rgt-tile-obj="top-tile" style="background-image: url('?p=adbanner&url=<% Response.Write(((rt_ad_cmpgn_bnr != null) && (rt_ad_cmpgn_bnr.ImageUrl != "")) ? rt_ad_cmpgn_bnr.ImageUrl : ""); %>')">
                                        <a href="<% Response.Write(((rt_ad_cmpgn != null) && (rt_ad_cmpgn.URL != "")) ? rt_ad_cmpgn.URL : ownr_url); %>" target="_blank"></a>
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
                    </div>
                </div>
                <div biz-catlg-obj="btm-wrappr">
                    <div btm-wrappr-obj="btmvw">
                        <div btmvw-obj="hdr">
                            <div hdr-obj="title">Service Providers</div>
                        </div>
                        <ul btmvw-obj="colsvw">
                            <%
                                var businessUsers = new FindAService_WebForm.Controllers.BusinessUserController().GetUsers();
                                var businessUser = (businessUsers.Count <= 0) ? null : businessUsers.FirstOrDefault();
                                if ((businessUser != null) && (businessUser.BusinessCategory_ID != null))
                                {
                                    var bizcategory_incr = "";
                                    var bizcategory_title = "";
                                    var bizcategory = db.BusinessCategories.Find(businessUser.BusinessCategory_ID);
                                    if (bizcategory != null)
                                    {
                                        bizcategory_incr = bizcategory.Increment.ToString();
                                        bizcategory_title = bizcategory.BusinessCategoryTitle;
                                    }
                            %>
                            <li colsvw-obj="col">
                                <div col-obj="advertvw">
                                    <div advertvw-obj="logo" style="background-image: url('?p=avatar&url=<% Response.Write((businessUser != null) ? businessUser.ImageUrl : ""); %>')"></div>
                                    <div advertvw-obj="bnr" style="background-image: url('?p=cover&url=<% Response.Write((businessUser != null) ? businessUser.CoverImageUrl : ""); %>')">
                                        <a href="?p=business&s=<% Response.Write(bizcategory_incr); %>&u=<% Response.Write(businessUser.Email.ToLower()); %>"></a>
                                    </div>
                                    <div advertvw-obj="pnl">
                                        <div pnl-obj="hdr"><% Response.Write(businessUser.BusinessName); %></div>
                                        <div pnl-obj="descr"><% Response.Write(bizcategory_title); %></div>
                                        <div pnl-obj="lnk"><a href="?p=business&s=<% Response.Write(bizcategory_incr); %>&u=<% Response.Write(businessUser.Email.ToLower()); %>">Contact</a></div>
                                    </div>
                                </div>
                            </li>
                            <%
                                }
                            %>
                            <%
                                businessUser = (businessUsers.Count <= 1) ? null : businessUsers.LastOrDefault();
                                if ((businessUser != null) && (businessUser.BusinessCategory_ID != null))
                                {
                                    var bizcategory_incr = "";
                                    var bizcategory_title = "";
                                    var bizcategory = db.BusinessCategories.Find(businessUser.BusinessCategory_ID);
                                    if (bizcategory != null)
                                    {
                                        bizcategory_incr = bizcategory.Increment.ToString();
                                        bizcategory_title = bizcategory.BusinessCategoryTitle;
                                    }
                            %>
                            <li colsvw-obj="col">
                                <div col-obj="advertvw">
                                    <div advertvw-obj="logo" style="background-image: url('?p=avatar&url=<% Response.Write((businessUser != null) ? businessUser.ImageUrl : ""); %>')"></div>
                                    <div advertvw-obj="bnr" style="background-image: url('?p=cover&url=<% Response.Write((businessUser != null) ? businessUser.CoverImageUrl : ""); %>')">
                                        <a href="?p=business&s=<% Response.Write(bizcategory_incr); %>&u=<% Response.Write(businessUser.Email.ToLower()); %>"></a>
                                    </div>
                                    <div advertvw-obj="pnl">
                                        <div pnl-obj="hdr"><% Response.Write(businessUser.BusinessName); %></div>
                                        <div pnl-obj="descr"><% Response.Write(bizcategory_title); %></div>
                                        <div pnl-obj="lnk"><a href="?p=business&s=<% Response.Write(bizcategory_incr); %>&u=<% Response.Write(businessUser.Email.ToLower()); %>">Contact</a></div>
                                    </div>
                                </div>
                            </li>
                            <%
                                }
                            %>
                            <li colsvw-obj="col">
                                <ul col-obj="advertvw">
                                    <%
                                        var individualUsers = new FindAService_WebForm.Controllers.IndividualUserController().GetUsers().Take(6).ToList();
                                        var usrLst = (individualUsers.Count > 3) ? individualUsers.GetRange(0, 3) : individualUsers;
                                        foreach (var user in usrLst)
                                        {
                                            var service_incr = "";
                                            var service_title = "";
                                            var service = db.Services.Find(user.Service_ID);
                                            if (service != null)
                                            {
                                                service_incr = service.Increment.ToString();
                                                service_title = service.ServiceTitle;
                                            }
                                    %>
                                    <li advertvw-obj="row">
                                        <div row-obj="img">
                                            <div info-obj="phldr"><i class="fa fa-user"></i></div>
                                            <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? user.ImageUrl : ""); %>')"></div>
                                            <a href="?p=individual&s=<% Response.Write(service_incr); %>&u=<% Response.Write(user.Email.ToLower()); %>"></a>
                                        </div>
                                        <div row-obj="pnl">
                                            <div pnl-obj="hdr"><% Response.Write(user.FirstName + " " + user.LastName); %></div>
                                            <div pnl-obj="descr"><% Response.Write(service_title); %></div>
                                            <div pnl-obj="lnk"><a href="?p=individual&s=<% Response.Write(service_incr); %>&u=<% Response.Write(user.Email.ToLower()); %>">Contact</a></div>
                                        </div>
                                    </li>
                                    <%
                                        }
                                    %>
                                </ul>
                            </li>
                            <%
                                usrLst = null;
                                if (individualUsers.Count > 0)
                                {
                                    if (individualUsers.Count > 6)
                                    {
                                        usrLst = individualUsers.GetRange(3, 6);
                                    }
                                    else
                                    {
                                        if (individualUsers.Count > 3)
                                        {
                                            usrLst = individualUsers.GetRange(3, individualUsers.Count - 3);
                                        }
                                    }

                                    if (usrLst != null)
                                    {
                            %>
                            <li colsvw-obj="col">
                                <ul col-obj="advertvw">
                                    <%
                                        foreach (var user in usrLst)
                                        {
                                            var service_incr = "";
                                            var service_title = "";
                                            var service = db.Services.Find(user.Service_ID);
                                            if (service != null)
                                            {
                                                service_incr = service.Increment.ToString();
                                                service_title = service.ServiceTitle;
                                            }
                                    %>
                                    <li advertvw-obj="row">
                                        <div row-obj="img">
                                            <div info-obj="phldr"><i class="fa fa-user"></i></div>
                                            <div info-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null) ? user.ImageUrl : ""); %>')"></div>
                                            <a href="?p=individual&s=<% Response.Write(service_incr); %>&u=<% Response.Write(user.Email.ToLower()); %>"></a>
                                        </div>
                                        <div row-obj="pnl">
                                            <div pnl-obj="hdr"><% Response.Write(user.FirstName + " " + user.LastName); %></div>
                                            <div pnl-obj="descr"><% Response.Write(service_title); %></div>
                                            <div pnl-obj="lnk"><a href="?p=individual&s=<% Response.Write(service_incr); %>&u=<% Response.Write(user.Email.ToLower()); %>">Contact</a></div>
                                        </div>
                                    </li>
                                    <%
                                        }
                                    %>
                                </ul>
                            </li>
                            <%
                                    }
                                }
                            %>
                        </ul>
                    </div>
                </div>
            </div>
            <div body-obj="howitworks-pnl">
                <%
                    if (howitworks != null)
                    {
                %>
                <div howitworks-obj="hdr-pnl"><% Response.Write(howitworks.CategoryTitle); %></div>
                <div howitworks-obj="bdy-pnl">
                    <ul>
                        <%
                                                 var howitworks_contents = db.Contents.Where(x => x.Category_ID == howitworks.ID).Take(3).OrderBy(x => x.DateCreated).ToList();
                                                 foreach (var itm in howitworks_contents)
                                                 {
                        %>
                        <li>
                            <div li-obj="img">
                                <div img-obj="img" style="background-image: url('?p=contentimage&url=<% Response.Write(itm.CoverImage); %>')"></div>
                                <div img-obj="phldr"><i class="fa fa-paint-brush"></i></div>
                                <a href="?p=content&category=<% Response.Write(howitworks.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(itm.Increment); %>"></a>
                            </div>
                            <div li-obj="descrptn">
                                <div descrptn-obj="title"><a href="?p=content&category=<% Response.Write(howitworks.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(itm.Increment); %>"><% Response.Write(itm.Title); %></a></div>
                                <div><% Response.Write(itm.MetaDescription); %></div>
                            </div>
                        </li>
                        <%
                                                 }
                        %>
                    </ul>
                </div>
                <% 
                    }
                %>
                <div howitworks-obj="ftr-pnl">
                    <div ftr-pnl-obj="ftr-btn">
                        <a href="?p=signup">Sign Up Today</a>
                    </div>
                </div>
            </div>
            <%
                var testimonies = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_revwd_usr).FirstOrDefault();
                if (testimonies != null)
                {
            %>
            <div body-obj="testimony-pnl">
                <div testimony-obj="hdr-pnl"><% Response.Write(testimonies.CategoryTitle); %></div>
                <div testimony-obj="bdy-pnl">
                    <ul>
                        <%
                                                var usrcmnts = new FindAService_WebForm.Controllers.ContentController().GetUserComments();
                                                foreach (var usrcmnt in usrcmnts)
                                                {
                                                    var who_cmmnt_name = (dynamic)null;
                                                    var who_cmmntd_avatr = (dynamic)null;
                                                    var who_cmmntd_url = (dynamic)null;
                                                    //
                                                    var prsn_cmmntd_fr_name = (dynamic)null;
                                                    var prsn_cmmntd_fr_avatr = (dynamic)null;
                                                    var prsn_cmmntd_fr_url = (dynamic)null;
                                                    //
                                                    var who_cmmnt_iusr = db.UserIndividuals.Where(x => x.ID == usrcmnt.Owner_ID).FirstOrDefault();
                                                    if (who_cmmnt_iusr != null)
                                                    {
                                                        who_cmmnt_name = who_cmmnt_iusr.FirstName + " " + who_cmmnt_iusr.LastName;
                                                        who_cmmntd_avatr = "?p=avatar&url=" + who_cmmnt_iusr.ImageUrl;
                                                        who_cmmntd_url = "?p=individual&u=" + who_cmmnt_iusr.Email.ToLower();

                                                        var prsn_cmmntd_fr_iusr = db.UserIndividuals.Where(x => x.ID == usrcmnt.User_ID).FirstOrDefault();
                                                        if (prsn_cmmntd_fr_iusr != null)
                                                        {
                                                            prsn_cmmntd_fr_avatr = "?p=avatar&url=" + prsn_cmmntd_fr_iusr.ImageUrl;
                                                            prsn_cmmntd_fr_url = "?p=individual&u=" + prsn_cmmntd_fr_iusr.Email.ToLower();
                                                        }
                                                        else
                                                        {
                                                            var prsn_cmmntd_fr_busr = db.UserBusinesses.Where(x => x.ID == usrcmnt.User_ID).FirstOrDefault();
                                                            if (prsn_cmmntd_fr_busr != null)
                                                            {
                                                                prsn_cmmntd_fr_avatr = "?p=avatar&url=" + prsn_cmmntd_fr_busr.ImageUrl;
                                                                prsn_cmmntd_fr_url = "?p=business&u=" + prsn_cmmntd_fr_busr.Email.ToLower();
                                                            }
                                                        }
                                                    }
                                                    else
                                                    {
                                                        var who_cmmnt_busr = db.UserBusinesses.Where(x => x.ID == usrcmnt.Owner_ID).FirstOrDefault();
                                                        if (who_cmmnt_busr != null)
                                                        {
                                                            who_cmmnt_name = who_cmmnt_busr.BusinessName;
                                                            who_cmmntd_avatr = "?p=avatar&url=" + who_cmmnt_busr.ImageUrl;
                                                            who_cmmntd_url = "?p=business&u=" + who_cmmnt_busr.Email.ToLower();

                                                            var prsn_cmmntd_fr_busr = db.UserBusinesses.Where(x => x.ID == usrcmnt.User_ID).FirstOrDefault();
                                                            if (prsn_cmmntd_fr_busr != null)
                                                            {
                                                                prsn_cmmntd_fr_avatr = "?p=avatar&url=" + prsn_cmmntd_fr_busr.ImageUrl;
                                                                prsn_cmmntd_fr_url = "?p=business&u=" + prsn_cmmntd_fr_busr.Email.ToLower();
                                                            }
                                                            else
                                                            {
                                                                var prsn_cmmntd_fr_iusr = db.UserIndividuals.Where(x => x.ID == usrcmnt.User_ID).FirstOrDefault();
                                                                if (prsn_cmmntd_fr_iusr != null)
                                                                {
                                                                    prsn_cmmntd_fr_avatr = "?p=avatar&url=" + prsn_cmmntd_fr_iusr.ImageUrl;
                                                                    prsn_cmmntd_fr_url = "?p=business&u=" + prsn_cmmntd_fr_iusr.Email.ToLower();
                                                                }
                                                            }
                                                        }
                                                    }
                        %>
                        <li>
                            <div li-obj="avatr">
                                <a href="<% Response.Write(prsn_cmmntd_fr_url); %>">
                                    <div avatr-obj="img" style="background-image: url('<% Response.Write(prsn_cmmntd_fr_avatr); %>')"></div>
                                    <div avatr-obj="phldr"><i class="fa fa-user"></i></div>
                                </a>
                            </div>
                            <div li-obj="descrptn">
                                <blockquote>
                                    <div descrptn-obj="quote"><% Response.Write(usrcmnt.Comment.Substring(0, ((usrcmnt.Comment.Length <= 200) ? usrcmnt.Comment.Length : 200))); %></div>
                                </blockquote>
                                <div descrptn-obj="name">
                                    <div name-obj="avatr">
                                        <div avatr-obj="img">
                                            <div avatr-obj="img" style="background-image: url('<% Response.Write(who_cmmntd_avatr); %>')"></div>
                                        </div>
                                    </div>
                                    <div name-obj="text"><a href="<% Response.Write(who_cmmntd_url); %>"><% Response.Write(who_cmmnt_name); %></a></div>
                                </div>
                            </div>
                        </li>
                        <%
                                                }
                        %>
                    </ul>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <div layout-obj="footr">
            <div footr-obj="footr-wrappr">
                <div wrappr-obj="top-layr">
                    <div top-layr-obj="lft-pane">
                        <div lft-pane-obj="nwslettr">
                            <div nwslettr-obj="nwslettr-hdr">
                                <%
                                    var newslettr = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.footr_newsltr).FirstOrDefault();
                                    if (newslettr != null)
                                    {
                                %>
                                <div nwslettr-hdr-obj="title"><% Response.Write(newslettr.CategoryTitle); %></div>
                                <div nwslettr-hdr-obj="hint"><% Response.Write(newslettr.Description); %></div>
                                <%
                                    }
                                %>
                            </div>
                            <div nwslettr-obj="nwslettr-bdy">
                                <form method="post" action="?p=donewslettersignup">
                                    <div nwslettr-bdy-obj="field">
                                        <input type="text" name="txtEmailAddr" placeholder="Your email address..." />
                                    </div>
                                    <div nwslettr-bdy-obj="btn">
                                        <input type="submit" value="Subscribe" />
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div lft-pane-obj="social">
                            <div social-obj="soc-itm"><a href="https://www.facebook.com/uvindafrica/"><i class="fa fa-facebook"></i></a></div>
                            <div social-obj="soc-itm"><a href="https://twitter.com/uvind_?lang=en"><i class="fa fa-twitter"></i></a></div>
                            <div social-obj="soc-itm"><a href="https://www.instagram.com/uvind_/"><i class="fa fa-instagram"></i></a></div>
                        </div>
                    </div>
                    <div top-layr-obj="rgt-pane">
                        <div rgt-pane-obj="top">
                            <ul top-obj="colsvw">
                                <%
                                    var menulist = new FindAService_WebForm.Controllers.ContentController().GetCategoriesByPageSection(FindAService_WebForm.PageSection.footr_mnulst).OrderBy(x => x.Increment);
                                    foreach (var categry in menulist)
                                    {
                                        var categ_id = categry.Increment;
                                %>
                                <li colsvw-obj="col">
                                    <ul col-obj="rowsvw">
                                        <li rowsvw-obj="row" type="headr"><% Response.Write(categry.CategoryTitle); %></li>
                                    </ul>
                                    <ul col-obj="rowsvw">
                                        <%
                                        foreach (var cntent in categry.Contents)
                                        {
                                        %>
                                        <li rowsvw-obj="row"><a href="?p=content&category=<% Response.Write(categ_id); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(cntent.Increment); %>"><% Response.Write(cntent.Title); %></a></li>
                                        <%
                                        }
                                        %>
                                    </ul>
                                </li>
                                <%
                                    }  
                                %>
                                <li colsvw-obj="col">
                                    <ul col-obj="rowsvw">
                                        <li rowsvw-obj="row" type="headr">Mobile Apps</li>
                                        <li rowsvw-obj="row">
                                            <div row-obj="img"><i class="fa fa-android"></i></div>
                                            <div row-obj="text">Google Android</div>
                                        </li>
                                        <li rowsvw-obj="row">
                                            <div row-obj="img"><i class="fa fa-apple"></i></div>
                                            <div row-obj="text">Apple iOS</div>
                                        </li>
                                        <li rowsvw-obj="row">
                                            <div row-obj="img"><i class="fa fa-windows"></i></div>
                                            <div row-obj="text">Windows Phone</div>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <div rgt-pane-obj="bottom">
                            <ul bottom-obj="colsvw">
                                <li colsvw-obj="col">
                                    <ul col-obj="rowsvw">
                                        <li rowsvw-obj="row" type="headr">Contact Us:</li>
                                    </ul>
                                </li>
                                <li colsvw-obj="col">
                                    <ul col-obj="rowsvw">
                                        <li rowsvw-obj="row">
                                            <div row-obj="img"><i class="fa fa-envelope"></i></div>
                                            <div row-obj="text">Email Address:</div>
                                        </li>
                                        <li rowsvw-obj="row">
                                            <div row-obj="img"><i class="fa fa-phone"></i></div>
                                            <div row-obj="text">Phone. No</div>
                                        </li>
                                    </ul>
                                </li>
                                <li colsvw-obj="col">
                                    <ul col-obj="rowsvw">
                                        <li rowsvw-obj="row">
                                            <%
                                                var cntact_email = new FindAService_WebForm.Controllers.ContentController().GetCategoriesByPageSection(FindAService_WebForm.PageSection.footr_cntact_email).OrderBy(x => x.Increment).FirstOrDefault();
                                                if (cntact_email != null)
                                                    Response.Write(cntact_email.Description);
                                            %>
                                        </li>
                                        <li rowsvw-obj="row">
                                            <%
                                                var cntact_phone = new FindAService_WebForm.Controllers.ContentController().GetCategoriesByPageSection(FindAService_WebForm.PageSection.footr_cntact_phone).OrderBy(x => x.Increment).FirstOrDefault();
                                                if (cntact_phone != null)
                                                    Response.Write(cntact_phone.Description);
                                            %></li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div wrappr-obj="btm-layr">
                    <div layr-obj="copyright">Copyright &copy; 2016. All rights reserved.</div>
                    <div layr-obj="terms">
                        <ul>
                            <%
                                var menuopts_categ = new FindAService_WebForm.Controllers.ContentController().GetCategoriesByPageSection(FindAService_WebForm.PageSection.footr_menu).OrderBy(x => x.Increment).FirstOrDefault();
                                if (menuopts_categ != null)
                                {
                                    var cntents = menuopts_categ.Contents;
                                    foreach (var cntent in cntents)
                                    {
                                        
                            %>
                            <li><a href="?p=content&category=<% Response.Write(menuopts_categ.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(cntent.Increment); %>"><% Response.Write(cntent.Title); %></a></li>
                            <%
                                    }
                                }
                            %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/initializer.banner.script.js" type="text/javascript"></script>
    <script src="/Scripts/initializer.adsbanner.script.js" type="text/javascript"></script>
    <script src="/Scripts/initializer.script.js" type="text/javascript"></script>
    <script src="/Scripts/home.search.script.js" type="text/javascript"></script>
</body>
</html>
