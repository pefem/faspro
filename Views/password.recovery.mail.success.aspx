<%@ Page Language="C#" MasterPageFile="Shared/ContentReaderPage.Master" AutoEventWireup="true" CodeBehind="password.recovery.mail.success.aspx.cs" Inherits="FindAService_WebForm.Views.password_recovery_success" %>

<asp:Content ID="script" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/package.selection.script.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.reader.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.selectionview.style.css" type="text/css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="menu_area" runat="server">
    <div btn-obj="menu-list">
        <div menu-obj="item"><a href=".">Home</a></div>
        <%
            //var db = new FindAService_WebForm.FASDBEntities();
            //var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
            //if (howitworks != null)
            //{
            //    var hwitwrk_cntnt = db.Contents.Where(x => x.Category_ID == howitworks.ID).OrderBy(x => x.Increment).FirstOrDefault();
        %>
        <%--<div menu-obj="item"><a href="?p=content&title=<% Response.Write(hwitwrk_cntnt.Title.ToLower()); %>&category=<% Response.Write(howitworks.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(hwitwrk_cntnt.Increment); %>">How it works</a></div>--%>
        <%
                                    //}
        %>
        <!--<div menu-obj="item"><a href="?p=advertise">Advertise</a></div>-->
        <div menu-obj="item"><a href="?p=blog">Blog</a></div>
        <div menu-obj="item"><a href="?p=login">Login</a></div>
        <div menu-obj="item" aria-selected="true"><a href="?p=signup">Sign Up</a></div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main_body" runat="server">
    <div layout-obj="reader-headr" style="border:none;">
        <div headr-obj="hdr">
            <div hdr-obj="lft-pane" style="width:700px;">
                <div pane-obj="title">Recovery email sent to your mailbox</div>
                <div pane-obj="description">If you don't see this email in your inbox within 15 minutes, look for it in your junk mail folder. If you find it there, please mark it as "Not Junk"..</div>
            </div>
        </div>
    </div>
</asp:Content>
