<%@ Page Title="" Language="C#" MasterPageFile="Shared/ContentReaderPage.Master" AutoEventWireup="true" CodeBehind="content.reader.aspx.cs" Inherits="FindAService_WebForm.ContentReader" %>

<asp:Content ID="script" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/package.selection.script.js" type="text/javascript"></script>
    <script src="/Scripts/contactus.script.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="menu_area" runat="server">
    <div btn-obj="menu-list">
        <%
            var db = new FindAService_WebForm.FASDBEntities();
            //var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
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
        <!--<div menu-obj="item"><a href="?p=advertise">Advertise</a></div>-->
        <div menu-obj="item"><a href="?p=blog">Blog</a></div>
        <div menu-obj="item"><a href="?p=login">Login</a></div>
        <div menu-obj="item" aria-selected="true"><a href="?p=signup">Sign Up</a></div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main_body" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var logged_in_usr = "";
        if (Session["user_account_email"] != null)
        {
            logged_in_usr = Session["user_account_email"].ToString();
        }

        var id = int.Parse(Request["category"]);
        var categry = db.ContentCategories.Where(x => x.Increment == id).FirstOrDefault();
        if (categry != null)
        {
            //
            // Selected content

            var s_cntent_id = int.Parse(Request["id"]);
            var s_cntent = db.Contents.Where(x => x.Increment == s_cntent_id).FirstOrDefault();
            var selectd_cntent = (FindAService_WebForm.Content)s_cntent;
    %>
    <div layout-obj="reader-nav">
        <div reader-obj="navigatn">
            <ul>
                <li><a href="/"><i class="fa fa-home"></i></a>&nbsp;&raquo&nbsp;</li>
                <li><% Response.Write(categry.CategoryTitle); %>&nbsp;&raquo&nbsp;</li>
                <li><b><% Response.Write(Regex.Replace(s_cntent.Title.ToLower(), @"<(.|\n)*?>", string.Empty)); %></b></li>
            </ul>
        </div>
    </div>
    <%
            if ((s_cntent != null) && (s_cntent.PageTemplate == (int)FindAService_WebForm.PageTemplate.SelectionPage))
            {
    %>
    <div layout-obj="reader-headr">
        <div headr-obj="hdr">
            <div hdr-obj="lft-pane">
                <div pane-obj="title"><% Response.Write(selectd_cntent.Title); %></div>
                <div pane-obj="description"><% Response.Write(selectd_cntent.MetaDescription); %></div>
            </div>
        </div>
    </div>
    <%
            }
    %>

    <%
            if ((s_cntent != null) && (s_cntent.PageTemplate == (int)FindAService_WebForm.PageTemplate.InfoPageWithCategory))
            {
    %>
    <div layout-obj="reader-headr">
        <div headr-obj="hdr" style="background-image: url('?p=contentimage&url=<% Response.Write(selectd_cntent.CoverImage); %>')">
            <div hdr-obj="lft-pane">
                <div pane-obj="title"><% Response.Write(categry.CategoryTitle); %></div>
                <div pane-obj="description"><% Response.Write(categry.Description); %></div>
            </div>
        </div>
    </div>
    <%
            }
    %>

    <div layout-obj="reader">
        <div reader-obj="panel">
            <%
            if (!s_cntent.SingletonApp && s_cntent.PageTemplate != (int)FindAService_WebForm.PageTemplate.ContactPage && s_cntent.PageTemplate != (int)FindAService_WebForm.PageTemplate.SelectionPage)
            {
            %>
            <div panel-obj="left-view">
                <div mnu-lst>
                    <ul>
                        <%
                var cntents = db.Contents.Where(x => x.Category_ID == categry.ID).OrderBy(x => x.Increment).ToList();
                foreach (var cntent in cntents)
                {
                    if (!cntent.SingletonApp)
                    {
                        %>
                        <li <% Response.Write((cntent.Increment == s_cntent_id) ? "selected" : ""); %>><a href="?p=content&category=<% Response.Write(categry.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(cntent.Increment); %>"><% Response.Write(cntent.Title); %></a></li>
                        <%
                    }
                }
                        %>
                    </ul>
                </div>
            </div>
            <% 
            }
            %>
            <div panel-obj="right-view">
                <%
            if (s_cntent.PageTemplate != (int)FindAService_WebForm.PageTemplate.SelectionPage)
            {
                %>
                <div view-obj="right-pane">&nbsp;</div>
                <%
            }
                %>
                <div view-obj="left-pane">
                    <%
            if (s_cntent.PageTemplate != (int)FindAService_WebForm.PageTemplate.SelectionPage)
            {
                if (s_cntent.PageTemplate != (int)FindAService_WebForm.PageTemplate.ContactPage)
                {
                    //
                    // Read Article Page
                    %>
                    <div pane-obj="content-reader">
                        <%
                    if ((s_cntent.PageTemplate != (int)FindAService_WebForm.PageTemplate.InfoPageWithCategory) && (selectd_cntent.CoverImage != null) && (selectd_cntent.CoverImage != "") && (selectd_cntent.ShowImage != false))
                    {
                        %>
                        <div content-reader-obj="cover" style="background-image: url('?p=contentimage&url=<% Response.Write(selectd_cntent.CoverImage); %>')"></div>
                        <%
                                }

                                if ((selectd_cntent.Title != null) && (selectd_cntent.Title != ""))
                                {
                        %>
                        <div content-reader-obj="title"><% Response.Write(selectd_cntent.Title.Substring(0, 1).ToUpper() + selectd_cntent.Title.Substring(1).ToLower()); %></div>
                        <%
                                }
                        %>
                        <div content-reader-obj="article"><% Response.Write(selectd_cntent.Body); %></div>
                    </div>
                    <%
                }
                else
                {
                    //
                    // Contact Page
                    %>
                    <div pane-obj="content-reader">
                        <%
                                if ((selectd_cntent.Title != null) && (selectd_cntent.Title != ""))
                                {
                        %>
                        <div content-reader-obj="title"><% Response.Write(selectd_cntent.Title.Substring(0, 1).ToUpper() + selectd_cntent.Title.Substring(1).ToLower()); %></div>
                        <%
                                }
                        %>
                        <div content-reader-obj="article"><% Response.Write(selectd_cntent.Body); %></div>
                        <form id="contactus" action="?p=docontactus" method="post" enctype="application/x-www-form-urlencoded">
                            <div cntact-frm>
                                <div frm-obj="rw">
                                    <input type="text" name="full-name-txt" placeholder="Your Full Name" />
                                </div>
                                <div frm-obj="rw">
                                    <input type="text" name="email-add-txt" placeholder="Your Email Address" />
                                </div>
                                <div frm-obj="rw">
                                    <input type="text" name="subject-txt" placeholder="Subject" />
                                </div>
                                <div frm-obj="rw">
                                    <textarea rows="12" name="message-txt"></textarea>
                                </div>
                                <div frm-obj="rw">
                                    <input type="submit" value="Post Message" focusable />
                                </div>
                            </div>
                        </form>
                    </div>
                    <%   
                            }
            }
            else
            {
                //
                // Ads Page Selection
                    %>
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
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
    <%
        }
        else
        {
    %>
    <div layout-obj="reader-headr" style="border: none;">
        <div headr-obj="hdr">
            <div hdr-obj="lft-pane">
                <div pane-obj="title">Sorry! page not found</div>
                <div pane-obj="description">The page you are trying to access does not exist.</div>
            </div>
        </div>
    </div>
    <%
        }
    %>
</asp:Content>
