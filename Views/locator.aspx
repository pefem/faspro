<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="locator.aspx.cs" Inherits="FindAService_WebForm.Locator" %>

<%
    var db = new FindAService_WebForm.FASDBEntities();
                                   
%>

<%--<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width" />
    <title><% Response.Write(ConfigurationManager.AppSettings["site_title"].ToString()); %></title>
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
    <link rel="stylesheet" href="Content/css/layouts/layout.locator.style.css" type="text/css" />

    <div page="layout">
        <div layout-obj="headr">
            <div headr-obj="headr-wrappr">
                <div wrappr-obj="left">
                    <div left-obj="logo" logo></div>
                </div>
            </div>
            <div headr-obj="bannr">
                
            </div>
        </div>
        <div layout-obj="body">

        </div>        
    </div>
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
</body>
</html>--%>







<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta name="viewport" content="width=device-width" />
    <title><% Response.Write(ConfigurationManager.AppSettings["site_title"].ToString()); %></title>
</head>
<body>
    <link rel="stylesheet" href="Content/css/vendors/font.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/vendors/font-awesome.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/vendors/icon.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/widgets/form.element.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.master.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.signup.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.locator.style.css" type="text/css" />

    <div page="layout">
        <div layout-obj="headr">
            <div headr-obj="headr-wrappr">
                <div wrappr-obj="left">
                    <a href=".">
                        <div left-obj="logo" logo style="height: 70px; margin-top: 0px;"></div>
                    </a>
                </div>
                <div wrappr-obj="right">
                    <div right-obj="menu-btn"></div>
                </div>
            </div>

        </div>
        <div layout-obj="body" id="main_body">
            <div body-obj="wrappr">
                <div layout-obj="signup">
                    <div signup-obj="tab">
                        <ul style="width: 250px;">
                            <li style="width: 250px;" selected="true"><span label="1">Choose a Location</span></li>
                        </ul>
                    </div>
                    <div signup-obj="bdy">

                        <div bannr-obj="search-wrappr">
                    <div srch-wrappr-obj="srch-bdy">
                        <div srch-bdy-obj="tabpage">
                            <div tabpage-obj="pnl">
                                <form method="post" action="?p=selectionloactn" enctype="application/x-www-form-urlencoded" accept-charset="">
                                    <div pnl-obj="srch-btn">
                                        <input type="submit" id="btnCS" text="Find" />
                                    </div>
                                    <div pnl-obj="srch-itm">
                                        <div srch-itm="field">
                                            <select name="locatnCmb" id="locatnCmb">
                                                <%
                                                    var countries = db.Countries.ToList();
                                                    if (countries != null)
                                                    {
                                                        foreach (var country in countries)
                                                        {
                                                %>
                                                <option value="<% Response.Write(country.WebCode); %>"><% Response.Write(country.CountryName + " (" + country.WebCode + ")"); %></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div srch-itm="dropdwn"></div>
                                    </div>
                                    <div clear></div>
                                </form>
                            </div>
                        </div>
                    </div>                    
                </div>
                    </div>
                </div>
            </div>
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
                                <%--<li colsvw-obj="col">
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
                                            <div row-obj="img" style="margin: 3px 10px 0px 0px;" class="bberry_white_24_ico"><i class="fa fa-blackberry"></i></div>
                                            <div row-obj="text">BlackBerry</div>
                                        </li>
                                        <li rowsvw-obj="row">
                                            <div row-obj="img"><i class="fa fa-windows"></i></div>
                                            <div row-obj="text">Windows Phone</div>
                                        </li>
                                    </ul>
                                </li>--%>
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
</body>
</html>