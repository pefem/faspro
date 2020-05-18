<%@ Page Title="" Language="C#" MasterPageFile="Shared/IndividualAccountSettingsPage.Master" AutoEventWireup="true" CodeBehind="individual.account.settings.aspx.cs" Inherits="FindAService_WebForm.individual_account" %>

<asp:Content ID="script_area" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
    <script src="/Scripts/artisan.settings.script.js" type="text/javascript"></script>
    <script src="/Scripts/xhr.script.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server"></asp:Content>
<asp:Content ID="menu_area" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var user = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = Request["u"]
        });

        if (user == null)
        {
            Response.Redirect("?p=login");
        }
        
        var db = new FindAService_WebForm.FASDBEntities();
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
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var user = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = Request["u"]
        });
        var db = new FindAService_WebForm.FASDBEntities();
        FindAService_WebForm.UserIndividual usraccnt = (FindAService_WebForm.UserIndividual)Session["useraccount"];
        FindAService_WebForm.UserWorkExperience wrk_exp_sess = (FindAService_WebForm.UserWorkExperience)Session["userwrkexp"];
    %>

    <div layout-obj="settings">
        <div settings-obj="hdr">
            <div hdr-obj="title">Settings</div>
            <%
                if (Session["notifier"] != null)
                {
            %>
            <div hdr-obj="notifier" id="infoNotifierPnl" aria-hidden="false"><% Response.Write(Session["notifier"]); %></div>
            <%
                }
            %>
        </div>
        <div settings-obj="bdy">
            <div bdy-obj="tab">
                <div tab-obj="btn" <% Response.Write((Request["mode"] != null & Request["mode"] == "cinf") ? "selected" : ""); %>><a href="?p=account&tb=3&mode=cinf&u=<% Response.Write(Request["u"].ToString()); %>">Basic Info</a></div>
                <div tab-obj="btn" <% Response.Write((Request["mode"] != null & Request["mode"] == "aset") ? "selected" : ""); %>><a href="?p=account&tb=3&mode=aset&u=<% Response.Write(Request["u"].ToString()); %>">Account Settings</a></div>
                <div tab-obj="btn" <% Response.Write((Request["mode"] != null & Request["mode"] == "cloc") ? "selected" : ""); %>><a href="?p=account&tb=3&mode=cloc&u=<% Response.Write(Request["u"].ToString()); %>">Current Location</a></div>
                <div tab-obj="btn" <% Response.Write((Request["mode"] != null & Request["mode"] == "exp") ? "selected" : ""); %>><a href="?p=account&tb=3&mode=exp&u=<% Response.Write(Request["u"].ToString()); %>">Portfolio</a></div>
                <div tab-obj="btn" <% Response.Write((Request["mode"] != null & Request["mode"] == "edq") ? "selected" : ""); %>><a href="?p=account&tb=3&mode=edq&u=<% Response.Write(Request["u"].ToString()); %>">Educational Qualifications</a></div>
                <%--<div tab-obj="btn" <% Response.Write((Request["mode"] != null & Request["mode"] == "ads") ? "selected" : ""); %>><a href="?p=account&tb=3&mode=ads&u=<% Response.Write(Request["u"].ToString()); %>">Ads Dashboard</a></div>--%>
            </div>
            <div bdy-obj="panel">
                <div layout-obj="brd">
                    <%
                        if (Request["mode"] != null & Request["mode"] == "cinf")
                        {    
                    %>
                    <div brd-obj="row" mode="cinf" float="true">
                        <div row-obj="bdy">
                            <div bdy-obj="frm">
                                <form id="profileupdate" method="post" action="?p=doeditprofile&mode=<% Response.Write(Request["mode"]); %>&sectn=info" enctype="application/x-www-form-urlencoded">
                                    <div frm-obj="rw">
                                        <div rw-obj="label">First name:</div>
                                        <div rw-obj="field">
                                            <input type="text" id="txtFirstName" name="txtFirstName" value="<% Response.Write((user != null) ? ((Session["txtFirstName"] != null) ? Session["txtFirstName"] : user.FirstName) : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Last name:</div>
                                        <div rw-obj="field">
                                            <input type="text" id="txtLastName" name="txtLastName" value="<% Response.Write((user != null) ? ((Session["txtLastName"] != null) ? Session["txtLastName"] : user.LastName) : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Gender:</div>
                                        <div rw-obj="field">
                                            <select name="cmbSex" id="cmbSex">
                                                <option <% Response.Write(((Session["cmbSex"] != null) && (Session["cmbSex"] == "Male")) ? "selected=\"selected\"" : ((user != null && user.Sex == "Male") ? "selected=\"selected\"" : "")); %>>Male</option>
                                                <option <% Response.Write(((Session["cmbSex"] != null) && (Session["cmbSex"] == "Female")) ? "selected=\"selected\"" : ((user != null && user.Sex == "Female") ? "selected=\"selected\"" : "")); %>>Female</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Phone Number:</div>
                                        <div rw-obj="field">
                                            <input type="text" id="txtPhoneNo" name="txtPhoneNo" value="<% Response.Write((user != null) ? ((Session["txtPhoneNo"] != null) ? Session["txtPhoneNo"] : user.ContactNumber) : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">About me:</div>
                                        <div rw-obj="field">
                                            <textarea rows="4" id="txtAboutUs" name="txtAboutUs"><% Response.Write((user != null) ? ((Session["txtAboutUs"] != null) ? Session["txtAboutUs"] : user.AboutMe) : ""); %></textarea>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">I' m a/an:</div>
                                        <div rw-obj="field">
                                            <select id="cmbServ" name="cmbServ">
                                                <%
                                                    var service = db.Services.ToList();
                                                    var selected_id = "";
                                                    if (Session["cmbServ"] != null)
                                                    {
                                                        selected_id = Session["cmbServ"].ToString();
                                                    }
                                                    else
                                                    {
                                                        if (user != null)
                                                        {
                                                            selected_id = user.Service_ID;
                                                        }
                                                    }
                                                    
                                                    foreach (var servc in service)
                                                    {
                                                        var selected = "";
                                                        if (selected_id == servc.ID)
                                                        {
                                                            selected = "selected=\"selected\"";
                                                        }
                                                %>
                                                <option value="<% Response.Write(servc.ID); %>" <% Response.Write(selected); %>><% Response.Write(servc.ServiceTitle); %></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                    <input type="hidden" name="txtUsrImg" value="<% Response.Write((user != null && usraccnt == null) ? user.ImageUrl : usraccnt.ImageUrl); %>" />
                                </form>
                                <form id="profilephotoupldr" method="post" action="?p=doavatarupld&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&sectn=info" enctype="multipart/form-data">
                                    <div frm-obj="rw" spaced>
                                        <div rw-obj="label">Choose an Image:</div>
                                        <div rw-obj="field">
                                            <div upload-button>
                                                <span>Choose File</span>
                                                <input type="file" name="upldFile" accept="image/*" />
                                            </div>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label"></div>
                                        <div rw-obj="field">
                                            <div field-obj="avatar">
                                                <div avatar-obj="phldr"><i class="fa fa-user"></i></div>
                                                <div avatar-obj="img" style="background-image: url('?p=avatar&url=<% Response.Write((user != null && usraccnt == null) ? user.ImageUrl : usraccnt.ImageUrl); %>')"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="hidden" id="tmpTxtUsrID" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                    <input type="hidden" id="tmpTxtFirstName" name="txtFirstName" value="Yeah" />
                                    <input type="hidden" id="tmpTxtLastName" name="txtLastName" value="" />
                                    <input type="hidden" id="tmpCmbSex" name="cmbSex" value="" />
                                    <input type="hidden" id="tmpTxtPhoneNo" name="txtPhoneNo" value="" />
                                    <input type="hidden" id="tmpTxtAboutUs" name="txtAboutUs" value="" />
                                    <input type="hidden" id="tmpcmbServ" name="cmbServ" value="" />
                                </form>
                                <div frm-obj="rw">
                                    <div rw-obj="label"></div>
                                    <div rw-obj="field">
                                        <input type="submit" id="saveChngesBtn" value="Save Changes" />
                                        <!--<input type="button" value="Cancel" />-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }    
                    %>

                    <%
                        if (Request["mode"] != null & Request["mode"] == "aset")
                        {    
                    %>
                    <div brd-obj="row" mode="aset" float="true">
                        <div row-obj="bdy">
                            <div bdy-obj="frm">
                                <form method="post" action="?p=doeditprofile&mode=<% Response.Write(Request["mode"]); %>&sectn=accnt" enctype="application/x-www-form-urlencoded">
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Email:</div>
                                        <div rw-obj="field">
                                            <input type="text" name="txtEmail" readonly="readonly" value="<% Response.Write((user != null) ? user.Email : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Old Password:</div>
                                        <div rw-obj="field">
                                            <input type="password" name="txtPwd" value="" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">New Password:</div>
                                        <div rw-obj="field">
                                            <input type="password" name="txtNPwd" value="" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label"></div>
                                        <div rw-obj="field">
                                            <input id="genbtn" type="button" value="Generate Password" />
                                            <input id="shwbtn" type="button" value="Show Password" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Retype Password:</div>
                                        <div rw-obj="field">
                                            <input type="password" name="txtRPwd" value="" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label"></div>
                                        <div rw-obj="field">
                                            <input type="submit" value="Save Changes" />
                                            <!--<input type="button" value="Cancel" />-->
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                </form>
                            </div>
                        </div>
                    </div>
                    <%
                        }    
                    %>

                    <%
                        if (Request["mode"] != null & Request["mode"] == "cloc")
                        {    
                    %>
                    <div brd-obj="row" mode="cloc" float="true">
                        <div row-obj="bdy">
                            <div bdy-obj="frm">
                                <form method="post" action="?p=doeditprofile&mode=<% Response.Write(Request["mode"]); %>&sectn=locn" enctype="application/x-www-form-urlencoded">
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Contact Address:</div>
                                        <div rw-obj="field">
                                            <input type="text" name="txtCAddr" value="<% Response.Write((user != null) ? user.ContactAddress : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Country:</div>
                                        <div rw-obj="field">
                                            <select name="cmbCntry" id="<% Response.Write(user.Country_ID); %>">
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
                                            <select name="cmbState" id="<% Response.Write(user.State_ID); %>">
                                                <%
                                                                           var states = db.States.Where(x => x.Country_ID == user.Country_ID).ToList();
                                                                           foreach (var state in states)
                                                                           {    
                                                %>
                                                <option value="<% Response.Write(state.ID); %>" <% Response.Write((user != null && user.State_ID == state.ID) ? "selected=\"selected\"" : ""); %>><% Response.Write(state.StateName); %></option>
                                                <%
                                                                           }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">City:</div>
                                        <div rw-obj="field">
                                            <select name="cmbCity" id="<% Response.Write(user.City_ID); %>">
                                                <%
                                                                          var cities = db.Cities.Where(x => x.State_ID == user.State_ID).ToList();
                                                                          foreach (var city in cities)
                                                                          {    
                                                %>
                                                <option value="<% Response.Write(city.ID); %>" <% Response.Write((user != null && user.City_ID == city.ID) ? "selected=\"selected\"" : ""); %>><% Response.Write(city.CityName); %></option>
                                                <%
                                                                          }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label"></div>
                                        <div rw-obj="field">
                                            <input type="submit" value="Save Changes" />
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                </form>
                            </div>
                        </div>
                    </div>
                    <%
                        }    
                    %>

                    <%
                        if (Request["mode"] != null & Request["mode"] == "exp")
                        {    
                    %>
                    <div brd-obj="row" mode="exp" float="true">
                        <div row-obj="bdy">
                            <div bdy-obj="frm">
                                <div frm-obj="hdr">
                                    <% 
                                        var action = "";
                                        if (Request["expr"] == null)
                                        {
                                            Response.Write("Add a New Portfolio");
                                            action = "add";
                                        }
                                        else
                                        {
                                            Response.Write("Edit Existing Portfolio");
                                            action = "edit";
                                        }
                                    %>
                                </div>
                                <form id="portfolioupdate" method="post" action="?p=docrudexpr&actn=<% Response.Write(action); %>&mode=<% Response.Write(Request["mode"]); %>&sectn=locn" enctype="application/x-www-form-urlencoded">
                                    <%
                                        FindAService_WebForm.UserWorkExperience wrk_exp = null;
                                        var wrk_exp_id = "";
                                        if ((Request["expr"] != null) && (Request["expr"] != ""))
                                        {
                                            int expr_id = int.Parse(Request["expr"]);
                                            if (Request["expr"] != null)
                                            {
                                                wrk_exp = db.UserWorkExperiences.Where(x => x.Increment == expr_id).FirstOrDefault();
                                            }
                                        }
                                        else
                                        {
                                            if ((Session["userwrkexp"] != null))
                                            {
                                                wrk_exp = ((FindAService_WebForm.UserWorkExperience)Session["userwrkexp"]);
                                                wrk_exp_id = wrk_exp.ID;
                                                wrk_exp.Title = ((Session["txtJobTitle"] != null) ? Session["txtJobTitle"].ToString() : "");
                                                wrk_exp.Client = ((Session["txtJobClient"] != null) ? Session["txtJobClient"].ToString() : "");
                                                wrk_exp.Description = ((Session["txtJobDescr"] != null) ? Session["txtJobDescr"].ToString() : "");
                                            }
                                            else
                                            {
                                                wrk_exp_id = Guid.NewGuid().ToString();
                                            }
                                        }
                                    %>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Job Title:</div>
                                        <div rw-obj="field">
                                            <input type="text" name="txtJobTitle" value="<% Response.Write((wrk_exp != null) ? ((Session["txtJobTitle"] != null) ? Session["txtJobTitle"] : wrk_exp.Title) : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Client Worked For:</div>
                                        <div rw-obj="field">
                                            <input type="text" name="txtJobClient" value="<% Response.Write((wrk_exp != null) ? ((Session["txtJobClient"] != null) ? Session["txtJobClient"] : wrk_exp.Client) : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Description:</div>
                                        <div rw-obj="field">
                                            <textarea name="txtJobDescr" rows="3"><% Response.Write((wrk_exp != null) ? ((Session["txtJobDescr"] != null) ? Session["txtJobDescr"] : wrk_exp.Description) : ""); %></textarea>
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtJobID" value="<% Response.Write((wrk_exp != null) ? wrk_exp.ID : wrk_exp_id); %>" />
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write((user != null)? user.ID : ""); %>" />
                                    <input type="hidden" name="txtJobImg" value="<% Response.Write((wrk_exp != null) ? ((wrk_exp_sess == null) ? wrk_exp.ImageUrl : wrk_exp_sess.ImageUrl) : ((Session["userwrkexp"] != null) ? wrk_exp.ImageUrl : "")); %>" />
                                </form>
                                <form id="portfolioimageupldr" method="post" action="?p=doportfolioimageupld&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&sectn=info&expr=<% Response.Write(Request["expr"]); %>" enctype="multipart/form-data">
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Choose an Image:</div>
                                        <div rw-obj="field">
                                            <div upload-button>
                                                <span>Choose File</span>
                                                <input type="file" name="upldFile" accept="image/*" />
                                            </div>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label"></div>
                                        <div rw-obj="field">
                                            <div field-obj="avatar">
                                                <div avatar-obj="phldr"><i class="fa fa-image"></i></div>
                                                <div avatar-obj="img" style="background-image: url('?p=portfolioimage&url=<% Response.Write((wrk_exp != null) ? ((wrk_exp_sess != null) ? wrk_exp_sess.ImageUrl : wrk_exp.ImageUrl) : ((Session["userwrkexp"] != null) ? wrk_exp.ImageUrl : "")); %>')"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtJobID" value="<% Response.Write((wrk_exp != null) ? wrk_exp.ID : wrk_exp_id); %>" />
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                    <input type="hidden" name="txtJobTitle" />
                                    <input type="hidden" name="txtJobClient" />
                                    <input type="hidden" name="txtJobDescr" />
                                </form>
                                <div frm-obj="rw">
                                    <div rw-obj="label"></div>
                                    <div rw-obj="field">
                                        <input id="saveChngesBtn" type="submit" value="Save Changes" />
                                    </div>
                                </div>
                            </div>
                            <div bdy-obj="grdvw">
                                <div grdvw-obj="hdr">Existing Portfolio</div>
                                <%
                                    var i = 1;
                                    var wrkexpr = db.UserWorkExperiences.Where(x => x.User_ID == user.ID).OrderByDescending(x => x.Increment).ToList();
                                    foreach (var expr in wrkexpr)
                                    {
                                %>
                                <div grdvw-obj="rw">
                                    <div rw-obj="field" class="indx" style="width: 5px;"><% Response.Write(i++); %></div>
                                    <div rw-obj="field">
                                        <span><% Response.Write(expr.Title); %></span>
                                    </div>
                                    <div rw-obj="field" class="buttn" right button remove><a href="?p=dormvwrkexpr&expr=<% Response.Write(expr.Increment); %>&mode=<% Response.Write(Request["mode"]); %>">Remove</a></div>
                                    <div rw-obj="field" class="buttn" right button edit><a href="?p=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&expr=<% Response.Write(expr.Increment); %>">Edit</a></div>
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

                    <%
                        if (Request["mode"] != null & Request["mode"] == "edq")
                        {    
                    %>
                    <div brd-obj="row" mode="edq" float="true">
                        <div row-obj="bdy">
                            <div bdy-obj="frm">
                                <div frm-obj="hdr">
                                    <% 
                            var action = "";
                            if (Request["qua"] == null)
                            {
                                Response.Write("Add a New Qualification");
                                action = "add";
                            }
                            else
                            {
                                Response.Write("Edit Existing Qualification");
                                action = "edit";
                            }
                                    %>
                                </div>
                                <form method="post" action="?p=docrudqua&actn=<% Response.Write(action); %>&mode=<% Response.Write(Request["mode"]); %>&sectn=locn" enctype="application/x-www-form-urlencoded">
                                    <%
                                                                                                                    FindAService_WebForm.UserEducationalQualification edu_qua = null;

                                                                                                                    if (Request["qua"] != null)
                                                                                                                    {
                                                                                                                        int expr_id = int.Parse(Request["qua"]);
                                                                                                                        if (Request["qua"] != null)
                                                                                                                        {
                                                                                                                            edu_qua = db.UserEducationalQualifications.Where(x => x.Increment == expr_id).FirstOrDefault();
                                                                                                                        }
                                                                                                                    }
                                    %>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Institution:</div>
                                        <div rw-obj="field">
                                            <input type="text" name="txtSchName" value="<% Response.Write((edu_qua != null) ? edu_qua.SchoolName : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Degree Obtained:</div>
                                        <div rw-obj="field">
                                            <input type="text" name="txtAwrdObtaind" value="<% Response.Write((edu_qua != null) ? edu_qua.AwardAcquired : ""); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Year of Graduation:</div>
                                        <div rw-obj="field">
                                            <select name="cmbYrGrad">
                                                <%
                                                                                               var start_yr = 1960;
                                                                                               var end_yr = DateTime.Now.Year;
                                                                                               while (start_yr <= end_yr)
                                                                                               {
                                                                                                   var yr = (end_yr - 1) + "/" + end_yr;
                                                %>
                                                <option <% Response.Write((edu_qua != null) ? ((edu_qua.YearGraduated == yr) ? "selected=\"selected\"" : "") : ""); %>><% Response.Write(yr); %></option>
                                                <%
                                                                                                                                                                          end_yr -= 1;
                                                                                               }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label"></div>
                                        <div rw-obj="field">
                                            <input type="submit" value="Save Changes" />
                                            <!--<input type="button" value="Cancel" />-->
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtQuaID" value="<% Response.Write((edu_qua != null) ? edu_qua.ID : ""); %>" />
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                </form>
                            </div>
                            <div bdy-obj="grdvw">
                                <div grdvw-obj="hdr">Educational Qualifications</div>
                                <%
                                                                                   var i = 1;
                                                                                   var eduquals = db.UserEducationalQualifications.Where(x => x.User_ID == user.ID).OrderByDescending(x => x.Increment).ToList();
                                                                                   foreach (var qual in eduquals)
                                                                                   {
                                %>
                                <div grdvw-obj="rw">
                                    <div rw-obj="field" class="indx" style="width: 5px;"><% Response.Write(i++); %></div>
                                    <div rw-obj="field">
                                        <span><% Response.Write(qual.SchoolName); %></span>
                                    </div>
                                    <div rw-obj="field" right class="buttn" button remove><a href="?p=dormveduqua&qua=<% Response.Write(qual.Increment); %>&mode=<% Response.Write(Request["mode"]); %>">Remove</a></div>
                                    <div rw-obj="field" right class="buttn" button edit><a href="?p=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&qua=<% Response.Write(qual.Increment); %>">Edit</a></div>
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

                    <%
                        if (Request["mode"] != null & Request["mode"] == "ads")
                        {
                    %>
                    <div brd-obj="row" mode="ads" float="true">
                        <div row-obj="bdy">
                            <%
                            if (Request["brd"] != null & Request["brd"] == "mnage")
                            {
                                var ad = int.Parse(Request["ads"]);
                                var ads = db.Ads.Where(x => x.Increment == ad).FirstOrDefault();

                                if (Request["actn"] != null & Request["actn"] == "crud")
                                {
                            %>
                            <div bdy-obj="navigatn">
                                <div>
                                    <a href="?p=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&mode=ads&u=<% Response.Write(Request["u"].ToString()); %>"><span><i class="fa fa-home"></i></span>&nbsp;<span>DashBoard</span></a> &raquo 
                                    <a href="?p=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&ads=<% Response.Write(ads.Increment); %>&brd=mnage"><span>Manage Ads</span></a> &raquo 
                                    <% 
                                    Response.Write((Request["cmpgn"] == null) ? "New Campaign" : "Edit Campaign");
                                    %>
                                </div>
                            </div>

                            <div bdy-obj="frm">
                                <div frm-obj="hdr">
                                    <% 
                                    var action = (Request["cmpgn"] == null) ? "add" : "edit";
                                    %>
                                </div>
                                <form method="post" id="campgnupdate" action="?p=docrudcmpgn&actn=<% Response.Write(action); %>&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&sectn=locn&ads=<% Response.Write(Request["ads"].ToString()); %>&brd=<% Response.Write(Request["brd"].ToString()); %>" enctype="application/x-www-form-urlencoded">
                                    <%
                                        FindAService_WebForm.AdsCampaign cmpgn = null;
                                        var usr_cmpgn_id = "";

                                        if ((Request["cmpgn"] != null) && (Request["cmpgn"] != ""))
                                        {
                                            var cmpgn_id = int.Parse(Request["cmpgn"]);
                                            if (Request["cmpgn"] != null)
                                            {
                                                cmpgn = db.AdsCampaigns.Where(x => x.Increment == cmpgn_id).FirstOrDefault();
                                            }
                                        }
                                        else
                                        {
                                            if ((Session["usercampgn"] != null))
                                            {
                                                cmpgn = ((FindAService_WebForm.AdsCampaign)Session["usercampgn"]);
                                                usr_cmpgn_id = cmpgn.ID;
                                                cmpgn.Title = ((Session["txtCmpgnTitle"] != null) ? Session["txtCmpgnTitle"].ToString() : "");
                                                cmpgn.Description = ((Session["txtCmpgnDescr"] != null) ? Session["txtCmpgnDescr"].ToString() : "");
                                            }
                                            else
                                            {
                                                usr_cmpgn_id = Guid.NewGuid().ToString();
                                            }
                                        }
                                    %>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Campaign Title:</div>
                                        <div rw-obj="field">
                                            <input style="width:400px;" type="text" name="txtCmpgnTitle" value="<% Response.Write((cmpgn != null) ? cmpgn.Title : ((Session["txtCmpgnTitle"] != null) ? Session["txtCmpgnTitle"] : "")); %>" />
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Description:</div>
                                        <div rw-obj="field">
                                            <textarea style="width:400px;" rows="8" name="txtCmpgnDescr"><% Response.Write((cmpgn != null) ? cmpgn.Description : ((Session["txtCmpgnDescr"] != null) ? Session["txtCmpgnDescr"] : "")); %></textarea>
                                        </div>
                                    </div>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Site URL:</div>
                                        <div rw-obj="field">
                                            <input type="text" style="width:400px;" name="txtCmpgnURL" value="<% Response.Write((cmpgn != null) ? cmpgn.URL : ((Session["txtCmpgnURL"] != null) ? Session["txtCmpgnURL"] : "")); %>" />
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtCmpgnID" value="<% Response.Write((cmpgn != null) ? cmpgn.ID : usr_cmpgn_id); %>" />
                                    <input type="hidden" name="txtCmpgnAdsID" value="<% Response.Write((cmpgn != null) ? cmpgn.Ads_ID : ""); %>" />
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                </form>
                                <form id="adbannerupldr" method="post" action="?p=doadbannerupld&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&sectn=info&ads=<% Response.Write(Request["ads"]); %>&brd=<% Response.Write(Request["brd"]); %>&actn=<% Response.Write(Request["actn"]); %>&cmpgn=<% Response.Write(Request["cmpgn"]); %>" enctype="multipart/form-data">
                                    <%
                                        var bannrs = (dynamic)null;
                                        if (cmpgn != null)
                                        {
                                            bannrs = db.AdsCampaignBanners.Where(x => x.AdsCampaign_ID == cmpgn.ID).ToList();
                                        }
                                        if (Session["campgn_bnrs"] != null)
                                        {
                                            if (bannrs == null)
                                            {
                                                bannrs = new List<FindAService_WebForm.AdsCampaignBanner>();
                                            }
                                            bannrs.AddRange((List<FindAService_WebForm.AdsCampaignBanner>)Session["campgn_bnrs"]);
                                        }

                                        if (bannrs == null)
                                        {
                                    %>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Choose an Image:</div>
                                        <div rw-obj="field">
                                            <div upload-button>
                                                <span>Choose File</span>
                                                <input type="file" name="upldFile" accept="image/*" />
                                            </div>
                                        </div>
                                    </div>
                                    <%
                                        }
                                        else if ((bannrs != null) && (((List<FindAService_WebForm.AdsCampaignBanner>)bannrs).Count < ads.AdsPackage.NumberOfAdsBanner))
                                        {
                                    %>
                                    <div frm-obj="rw">
                                        <div rw-obj="label">Choose an Image:</div>
                                        <div rw-obj="field">
                                            <div upload-button>
                                                <span>Choose File</span>
                                                <input type="file" name="upldFile" accept="image/*" />
                                            </div>
                                        </div>
                                    </div>
                                    <%
                                        }
                                    %>
                                    <div frm-obj="rw">
                                        <div rw-obj="label"></div>
                                        <div rw-obj="field">
                                            <div field-obj="mansory-lstvw">
                                                <div mansory-lstvw-obj="mansory">
                                                    <%
                                                        if(bannrs != null) {
                                                            foreach (var bnr in bannrs)
                                                            {
                                                    %>
                                                    <div lstvw-obj="itm">
                                                        <div itm-obj="phldr"><i class="fa fa-image"></i></div>
                                                        <div itm-obj="img" style="background-image: url('?p=adbanner&url=<% Response.Write((bnr != null) ? bnr.ImageUrl : ""); %>')"></div>
                                                        <div itm-obj="btn"><a href="?p=dormvadsbnr&mode=<% Response.Write(Request["mode"]); %>&bnr=<% Response.Write(bnr.Increment); %>&url=<% Response.Write((Session["campgn_bnrs"] != null)? bnr.ImageUrl : bnr.Increment.ToString()); %>&u=<% Response.Write(Request["u"]); %>&ads=<% Response.Write(Request["ads"]); %>&brd=<% Response.Write(Request["brd"]); %>&actn=<% Response.Write(Request["actn"]); %><% Response.Write(((Request["cmpgn"] != null) && (Request["cmpgn"] != "")) ? "&cmpgn=" + Request["cmpgn"] : ""); %>"><i class="fa fa-times"></i></a></div>
                                                    </div>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="hidden" name="txtCmpgnID" value="<% Response.Write((cmpgn != null) ? cmpgn.ID : usr_cmpgn_id); %>" />
                                    <input type="hidden" name="txtCmpgnAdsID" value="<% Response.Write((cmpgn != null) ? cmpgn.Ads_ID : ""); %>" />
                                    <input type="hidden" name="txtUsrID" value="<% Response.Write(user.ID); %>" />
                                    <input type="hidden" name="txtCmpgnTitle" />
                                    <input type="hidden" name="txtCmpgnDescr" />
                                    <input type="hidden" name="txtCmpgnURL" />
                                    <input type="hidden" name="txtDimension" value="<% Response.Write(ads.AdsPackage.BannerDimension); %>" />
                                </form>
                                <div frm-obj="rw">
                                    <div rw-obj="label"></div>
                                    <div rw-obj="field">
                                        <input id="saveChngesBtn" type="submit" value="Save Changes" />
                                    </div>
                                </div>
                            </div>
                            <%
                                }
                                else
                                {
                            %>
                            <div bdy-obj="navigatn">
                                <div><a href="?p=account&mode=ads&tb=<% Response.Write(Request["tb"]); %>&u=<% Response.Write(Request["u"].ToString()); %>"><span><i class="fa fa-home"></i></span>&nbsp;<span>DashBoard</span></a> &raquo Manage Ads</div>
                            </div>
                            <div bdy-obj="fltabl-pnl">
                                <div pnl-obj="lft">
                                    <div bdy-obj="frm" style="margin-bottom: 20px;">
                                        <div frm-obj="rw" style="margin-bottom: 5px;">
                                            <div rw-obj="label_big">Receipt Number:</div>
                                            <div rw-obj="field_big"><% Response.Write(ads.ReceiptNo); %></div>
                                        </div>
                                        <div frm-obj="rw" style="margin-bottom: 5px;">
                                            <div rw-obj="label_big">Package Type:</div>
                                            <div rw-obj="field_big"><% Response.Write(ads.AdsPackage.Title); %></div>
                                        </div>
                                        <div frm-obj="rw" style="margin-bottom: 5px;">
                                            <div rw-obj="label_big">Status:</div>
                                            <div rw-obj="field_big"><% Response.Write(Enum.GetValues(typeof(FindAService_WebForm.AdsStatus)).GetValue(ads.Status)); %></div>
                                        </div>
                                    </div>
                                </div>
                                <div pnl-obj="right">
                                    <div bdy-obj="frm" style="margin-bottom: 20px;">
                                        <%--<div frm-obj="rw" style="margin-bottom: 5px;">
                                            <div rw-obj="label_big">Date Setup:</div>
                                            <div rw-obj="field_big"><% Response.Write(ads.DateCreated); %></div>
                                        </div>
                                        <div frm-obj="rw" style="margin-bottom: 5px;">
                                            <div rw-obj="label_big">Expiration Date:</div>
                                            <div rw-obj="field_big"><% Response.Write(ads.DateCreated.AddMonths(ads.AdsPackage.Duration)); %></div>
                                        </div>--%>
                                        <div frm-obj="rw" style="margin-bottom: 5px;">
                                            <div rw-obj="label_big">No. of Campaign:</div>
                                            <div rw-obj="field_big"><% Response.Write(ads.AdsPackage.NumberOfAds); %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div bdy-obj="grdvw" style="margin-top: 0px; margin-bottom: 60px;">
                                <%
                                    var i = 1;
                                    var campaigns = db.AdsCampaigns.Where(x => x.Ads_ID == ads.ID).ToList();
                                %>
                                <div grdvw-obj="hdr">
                                    <div hdr-obj="fltbl-pnl">Manage Campaigns</div>
                                    <%
                                    if (campaigns.Count < ads.AdsPackage.NumberOfAds)
                                    {    
                                    %>
                                    <div hdr-obj="fltbl-pnl" buttn><a href="?p=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&ads=<% Response.Write(ads.Increment); %>&brd=mnage&actn=crud">New Campaign</a></div>
                                    <%
                                        }
                                    %>
                                </div>
                                <%
                                    foreach (var cmpaign in campaigns)
                                    {
                                %>
                                <div grdvw-obj="rw">
                                    <div rw-obj="field" right button remove><a href="?p=dormvcmpgn&mode=<% Response.Write(Request["mode"]); %>&tb=<% Response.Write(Request["tb"]); %>&cmpgn=<% Response.Write(cmpaign.Increment); %>&u=<% Response.Write(Request["u"]); %>&ads=<% Response.Write(Request["ads"]); %>&brd=<% Response.Write(Request["brd"]); %>">Delete</a></div>
                                    <div rw-obj="field" right button edit><a href="?p=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&ads=<% Response.Write(Request["ads"]); %>&brd=mnage&actn=crud&cmpgn=<% Response.Write(cmpaign.Increment); %>">Edit</a></div>
                                    <div rw-obj="field" style="width: 5px;"><% Response.Write(i++); %></div>
                                    <div rw-obj="field">
                                        <span><% Response.Write(cmpaign.Title); %></span>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <%
                                }
                            }
                            else
                            {    
                            %>
                            <div bdy-obj="navigatn">
                                <div><span><i class="fa fa-home"></i></span>&nbsp;<span>DashBoard</span>&nbsp;|&nbsp;<span><a href="?p=advertise">Buy Ads</a></span></div>
                            </div>
                            <div bdy-obj="grdvw" style="margin-top: 0px; margin-bottom: 60px;">
                                <div grdvw-obj="hdr">Ads DashBoard</div>
                                <%
                                var i = 1;
                                var ads = db.Ads.Where(x => x.User_ID == user.ID).ToList();
                                foreach (var ad in ads)
                                {
                                %>
                                <div grdvw-obj="rw">
                                    <%
                                    if (FindAService_WebForm.AdsStatus.Published == (FindAService_WebForm.AdsStatus)ad.Status)
                                    {
                                    %>
                                    <div rw-obj="field" right button><a href="?p=<% Response.Write(Request["p"]); %>&tb=<% Response.Write(Request["tb"]); %>&mode=<% Response.Write(Request["mode"]); %>&u=<% Response.Write(Request["u"]); %>&ads=<% Response.Write(ad.Increment); %>&brd=mnage">Manage</a></div>
                                    <%
                                    }

                                    if (FindAService_WebForm.AdsStatus.Expired == (FindAService_WebForm.AdsStatus)ad.Status)
                                    {
                                    %>
                                    <div rw-obj="field" right button renew><a href="?p=viewinvoice&pckge=<% Response.Write(ad.AdsPackage.Increment); %>&invoice=<% Response.Write(ad.ReceiptNo); %>" invoice=<% Response.Write(ad.ReceiptNo); %>>Renew</a></div>
                                    <%
                                    }
                                    %>
                                    <div rw-obj="field" style="width: 5px;"><% Response.Write(i++); %></div>
                                    <div rw-obj="field" style="width:50px;">
                                        <span><% Response.Write(ad.ReceiptNo); %></span>
                                    </div>
                                    <div rw-obj="field" style="width:60px;">
                                        <span><% Response.Write(((FindAService_WebForm.AdsStatus)ad.Status == FindAService_WebForm.AdsStatus.Renewed) ? "Pending" : Enum.GetValues(typeof(FindAService_WebForm.AdsStatus)).GetValue(ad.Status)); %></span>
                                    </div>
                                    <div rw-obj="field">
                                        <span><% Response.Write(ad.AdsPackage.Title); %></span>
                                    </div>
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
                    %>
                </div>
            </div>
        </div>
    </div>

    <div wnd-obj="diag">
        <div diag-obj="chrome">
            <div chrome-obj="msag"></div>
            <div chrome-obj="bttn">
                <div bttn-obj="no">Cancel</div>
                <div bttn-obj="yes">Yes, Proceed</div>
            </div>
        </div>
    </div>
</asp:Content>

