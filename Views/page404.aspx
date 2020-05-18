<%@ Page Language="C#" MasterPageFile="Shared/Page404.Master" AutoEventWireup="true" CodeBehind="page404.aspx.cs" Inherits="FindAService_WebForm.Views.page404" %>

<asp:Content ID="script" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/package.selection.script.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.reader.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.selectionview.style.css" type="text/css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="menu_area" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main_body" runat="server">
    <div layout-obj="reader-headr" style="border:none; padding:20px;">
        <div headr-obj="hdr" style="padding:0px;">
            <div hdr-obj="lft-pane" style="width:700px; padding:0px;">
                <div pane-obj="title">Website Suspended!</div>
                <div pane-obj="description">Sorry, this website has been temporarily suspended. Please contact administrator</div>
            </div>
        </div>
    </div>
</asp:Content>
