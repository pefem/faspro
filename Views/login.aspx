<%@ Page Title="" Language="C#" MasterPageFile="Shared/AuthPage.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="FindAService_WebForm.Login" %>

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
        <div menu-obj="item" aria-selected="true"><a href="?p=signup">Sign Up</a></div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main_body" runat="server">
    <div layout-obj="login">
        <div login-obj="tab">
            <ul>
                <li selected="true"><span label="1">Account Login</span></li>
            </ul>
        </div>
        <div login-obj="bdy">
            <div id="information-form" ftype>
                <form method="post" action="?p=dologin" enctype="application/x-www-form-urlencoded">
                    <div bdy-obj="form">
                        <%
                            if (Session["login_error"] == "NOTFOUND")
                            {
                        %>
                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column" style="color: rgb(255, 0, 0)">Incorrect email address and password.</div>
                        </div>
                        <%
                            }
                        %>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Account:</span></div>
                            <div row-obj="column">
                                <input type="text" name="email_txt" id="email_txt" placeholder="Email " />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Password:</span></div>
                            <div row-obj="column">
                                <input type="password" name="pwd_txt" id="pwd_txt" placeholder="Your password" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span></span></div>
                            <div row-obj="column">
                                <div row-obj="column">
                                    <input type="checkbox" />
                                </div>
                                <div row-obj="column">
                                    Remember my account
                                </div>
                            </div>
                        </div>
                        <div form-obj="row" float="true" class="spacer"></div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column">
                                <div row-obj="column">
                                    <input type="submit" id="btnSubmit" value="Sign In" />
                                </div>
                            </div>
                        </div>

                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column" id="fgot_pwd"><a href="?p=forgotpassword">Did you forget your password?</a></div>
                        </div>
                        <div form-obj="row" float="true" class="spacer"></div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column" style="font-size: 14px;">Don't have an account? <a href="?p=signup">Sign up now</a></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%
        //Session.RemoveAll();
        Session.Remove("login_error");
        Session.Remove("usr_type");
        Session.Remove("user_account_active");
        Session.Remove("user_account_email");
        Session.Remove("forgot_error");
        Session.Remove("signup_error");
    %>
</asp:Content>
