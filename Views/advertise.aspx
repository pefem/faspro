<%@ Page Language="C#" MasterPageFile="Shared/ContentReaderPage.Master" AutoEventWireup="true" CodeBehind="advertise.aspx.cs" Inherits="FindAService_WebForm.Views.Shared.advertise" %>

<asp:Content ID="script" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/package.selection.script.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.reader.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.selectionview.style.css" type="text/css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var businessCntr = new FindAService_WebForm.Controllers.BusinessUserController();
        var adsCntr = new FindAService_WebForm.Controllers.AdsController();

        var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
        if (Session["user_account_active"] == null)
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
        <div menu-obj="item"><a href="?p=blog">Blog</a></div>
        <div menu-obj="item"><a href="?p=login">Login</a></div>
        <div menu-obj="item" aria-selected="true"><a href="?p=signup">Sign Up</a></div>
    </div>
    <%
        }
        else
        {
            if ((bool)Session["user_account_active"] != false)
            {
                var name = "";
                var email = "";

                var iusr = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
                {
                    Email = Session["user_account_email"].ToString()
                });

                if (iusr != null)
                {
                    name = iusr.FirstName;
                    email = iusr.Email.ToLower();
                }
                else
                {
                    var busr = businessCntr.GetUser(new FindAService_WebForm.UserBusiness
                    {
                        Email = Session["user_account_email"].ToString()
                    });

                    if (busr != null)
                    {
                        name = busr.BusinessName;
                        email = busr.Email.ToLower();
                    }
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
        }
    %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main_body" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var logged_in_usr = "";
        if (Session["user_account_email"] != null)
        {
            logged_in_usr = Session["user_account_email"].ToString();
        }
    %>
    <div layout-obj="reader-nav">
        <div reader-obj="navigatn">
            <ul>
                <li><a href="/"><i class="fa fa-home"></i></a>&nbsp;&raquo&nbsp;</li>
                <li><b>Advertise</b></li>
            </ul>
        </div>
    </div>
    <div layout-obj="reader-headr">
        <div headr-obj="hdr">
            <div hdr-obj="lft-pane">
                <div pane-obj="title">Advertise With Us</div>
                <div pane-obj="description">Get found by people easily when they're searching for the things that you offer.</div>
            </div>
        </div>
    </div>
    <div layout-obj="reader">
        <div reader-obj="panel">
            <div panel-obj="right-view">
                <div view-obj="left-pane">
                    <div pane-obj="selection-view">
                        <form method="post" action="?p=chosepackge&" enctype="application/x-www-form-urlencoded">
                            <input name="package" type="hidden" value="" />
                            <div view-obj="pricing-table-hdr">Choose a Package</div>
                            <div view-obj="pricing-table-hint">Select a package that best suit your business needs</div>
                            <div view-obj="pricing-table">
                                <%
                                    var pckages = db.AdsPackages.ToList();
                                    foreach (var itm in pckages)
                                    {
                                %>
                                <div pricing-table-obj="itm">
                                    <div itm-obj="hdr">
                                        <div hdr-obj="title"><% Response.Write(itm.Title); %></div>
                                        <div hdr-obj="description">NGN<% Response.Write(itm.Amount); %></div>
                                    </div>
                                    <div itm-obj="bdy">
                                        <div bdy-obj="itm"><% Response.Write(itm.NumberOfAds + " Ads Space"); %></div>
                                        <div bdy-obj="itm"><% Response.Write(itm.NumberOfAdsBanner + " Campaign Banners"); %></div>
                                        <div bdy-obj="itm"><% Response.Write(itm.Duration + " Months"); %></div>
                                        <div bdy-obj="itm"><% Response.Write(FindAService_WebForm.Enums.GetEnumDescription((FindAService_WebForm.AdsBannerDimension)itm.BannerDimension)); %></div>
                                        <div bdy-obj="btn" value="<% Response.Write(itm.Increment); %>">
                                            Choose Package
                                        </div>
                                    </div>
                                </div>
                                <%
                                }
                                %>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
