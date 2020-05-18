<%@ Page Title="" Language="C#" MasterPageFile="Shared/AuthPage.Master" AutoEventWireup="true" CodeBehind="password.recovery.code.aspx.cs" Inherits="FindAService_WebForm.Login" %>

<asp:Content ID="script" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/login.script.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main_body" runat="server">
    <div layout-obj="login">
        <div login-obj="tab">
            <ul style="width:300px;">
                <li selected="true" style="width:250px;"><span label="1">Recovery Code</span></li>
            </ul>
        </div>
        <div login-obj="bdy">
            <div id="information-form" ftype>
                <div bdy-obj="form-layout">
                    <div form-layout-obj="left-pane">
                        <form method="post" action="?p=dopwdrecoverycode" enctype="application/x-www-form-urlencoded">
                            <div bdy-obj="form">
                                <%
                                    if (Session["code_error"] == "NOTFOUND")
                                    {
                                %>
                                <div form-obj="row" float="true">
                                    <div row-obj="column"></div>
                                    <div row-obj="column" style="color: rgb(255, 0, 0)">You entered an invalid code.</div>
                                </div>
                                <%
                                    }
                                %>
                                <div form-obj="row" float="true">
                                    <div row-obj="column"><span>Enter Code:</span></div>
                                    <div row-obj="column">
                                        <input type="text" name="email_txt" id="email_txt" />
                                    </div>
                                </div>
                                <div form-obj="row" float="true">
                                    <div row-obj="column"></div>
                                    <div row-obj="column">
                                        <div row-obj="column">
                                            <input type="submit" id="btnSubmit" value="Submit" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%
        Session.RemoveAll();
    %>
</asp:Content>
