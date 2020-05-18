<%@ Page Title="" Language="C#" MasterPageFile="Shared/Register.Master" AutoEventWireup="true" CodeBehind="signup.aspx.cs" Inherits="FindAService_WebForm.Signup" %>

<asp:Content ID="script_area" ContentPlaceHolderID="script_area" runat="server">
    <script type="text/javascript" src="Scripts/signup.script.js"></script>
    <script type="text/javascript" src="Scripts/xhr.script.js"></script>
    <script type="text/javascript" src="Scripts/prototype.script.js"></script>


</asp:Content>

<asp:Content ID="menu_area" ContentPlaceHolderID="menu_area" runat="server">
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
            //    if(hwitwrk_cntnt != null) {
        %>
        <%--<div menu-obj="item"><a href="?p=content&title=<% Response.Write(hwitwrk_cntnt.Title.ToLower()); %>&category=<% Response.Write(howitworks.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(hwitwrk_cntnt.Increment); %>">How it works</a></div>--%>
        <%
            //    }
            //}
        %>
        <%--<div menu-obj="item"><a href="?p=advertise">Advertise</a></div>--%>
        <div menu-obj="item"><a href="?p=blog">Blog</a></div>
        <div menu-obj="item"><a href="?p=login">Login</a></div>
    </div>
</asp:Content>
<asp:Content ID="signup" ContentPlaceHolderID="main_body" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
    %>
    <div layout-obj="signup">
        <div signup-obj="hdr">Sign Up</div>
        <div signup-obj="tab">
            <ul>
                <li selected="true"><span label="1">Account Signup</span></li>
            </ul>
        </div>
        <div signup-obj="bdy">
            <%
                var is_individual = true;
                
                if (Request["t"] != null && Request["t"].ToLower() == "individual")
                {
                    is_individual = true;
                }
                else
                {
                    if (Request["t"] != null && Request["t"].ToLower() == "business")
                    {
                        is_individual = false;
                    }
                }
            %>

            <ul bdy-obj="tab">
                <li tab-obj="btn" form="iform" <% Response.Write(is_individual ? "selected=\"true\"" : ""); %>>Individual</li>
                <li tab-obj="btn" form="cform" <% Response.Write(!is_individual ? "selected=\"true\"" : ""); %>>Corporate</li>
            </ul>

            <div id="individual-form" ftype="iform" <% Response.Write(is_individual ? "" : "class=\"hide_form\""); %> style="margin: auto;">
                <%
                    if (Session["signup_error"] != null)
                    {
                        var sess_respnse = Session["signup_error"];
                        var title = "";
                        var descr = "";
                        if (sess_respnse == "BadPwd")
                        {
                            title = "Invalid password!";
                            descr = "Your password must contain at least one digit, one lower case letter, one uppercase letter, and must not exceed 15 characters long";
                        }
                        if (sess_respnse == "PwdMismatch")
                        {
                            title = "Password mismatch!";
                            descr = "Please retype your password in the 'Retype Password' field below";
                        }
                        if (sess_respnse == "InvalidEmail")
                        {
                            title = "Invalid email!";
                            descr = "You entered an invalid email in the 'Email Address' field below";
                        }
                        if (sess_respnse == "Exist")
                        {
                            title = "Email already used";
                            descr = "Sorry, an account created with this email already exist.";
                        }
                %>
                <div bdy-obj="hintbox" id="hintbox">
                    <div hintbox-obj="title"><% Response.Write(title); %></div>
                    <div hintbox-obj="descr"><% Response.Write(descr); %></div>
                </div>
                <%
                    }    
                %>
                <form type="individual" id="frm" method="post" action="?p=dosignup&t=<% Response.Write(FindAService_WebForm.UserType.Individual); %>" enctype="application/x-www-form-urlencoded">
                    <div bdy-obj="form">

                        <%--<div form-obj="row" float="true">
                            <div row-obj="column" class="password-generator-label"><span>&nbsp;</span></div>
                            <div row-obj="column" class="password-generator-field">
                                <div class="pwd-genrtor">
                                    <div>
                                        <input id="igenbtn" type="button" value="Generate Password" selected />
                                    </div>
                                    <div>
                                        <input id="ishwbtn" type="button" value="Show Password" />
                                    </div>
                                </div>
                            </div>
                        </div>--%>

                        <div form-obj="row" float="true" headr>
                            <div row-obj="column"><span>Personal information</span></div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>First name:</span></div>
                            <div row-obj="column">
                                <input type="text" name="txtFirstName" placeholder="First name" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Last name:</span></div>
                            <div row-obj="column">
                                <input type="text" name="txtLastName" placeholder="Last name" style="width: 310px" />
                            </div>
                        </div>

                        <%--<div form-obj="row" float="true">
                            <div row-obj="column"><span>Gender:</span></div>
                            <div row-obj="column">
                                <select id="ddlGender" style="width: 324px;" name="sexCmb">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                </select>
                            </div>
                        </div>--%>

                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Contact Address:</span></div>
                            <div row-obj="column">
                                <input type="text" name="txtContactAddress" placeholder="Contact Address" style="width: 310px;" />
                            </div>
                        </div>
                        <%
                            //var cookie_cntry_code = Request.Cookies["page"]["location"];
                            //var cookie_cntry = db.Countries.Where(x => x.WebCode == cookie_cntry_code).FirstOrDefault();
                            var cookie_cntry = db.Countries.FirstOrDefault();
                        %>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Country:</span></div>
                            <div row-obj="column">
                                <%--<select style="width: 324px;" name="countryCmb" id="<% Response.Write((Session["co_cntry"] != null) ? Session["co_cntry"] : ((cookie_cntry != null) ? cookie_cntry.ID : "")); %>">--%>
                                <select style="width: 324px;" name="countryCmb" id="<% Response.Write(cookie_cntry.ID); %>">
                                    <%
                                        var countries = db.Countries.ToList();
                                        var selectd_cntry = countries.FirstOrDefault();
                                        foreach (var country in countries)
                                        {
                                    %>
                                    <option value="<% Response.Write(country.ID); %>"><% Response.Write(country.CountryName); %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>State/Province:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="stateCmb" id="<% Response.Write((Session["co_state"] != null) ? Session["co_state"] : ""); %>">
                                    <%
                                        var selectd_state = "";
                                        if(selectd_cntry != null)
                                        {
                                            var states_obj = db.States.Where(x => x.Country_ID == selectd_cntry.ID);
                                            var states = states_obj.ToList();
                                            selectd_state = ((states != null) && (states.FirstOrDefault() != null)) ? states.FirstOrDefault().ID : "";                                        
                                            foreach (var state in states)
                                            {
                                    %>
                                    <option value="<% Response.Write(state.ID); %>"><% Response.Write(state.StateName); %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>City:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="cityCmb" id="<% Response.Write((Session["co_city"] != null) ? Session["co_city"] : ""); %>">
                                    <%
                                        var cities = db.Cities.Where(x => x.State_ID == selectd_state).ToList();
                                        foreach (var city in cities)
                                        {
                                    %>
                                    <option value="<% Response.Write(city.ID); %>"><% Response.Write(city.CityName); %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Phone Number:</span></div>
                            <div row-obj="column">
                                <input type="text" value="<% Response.Write((Session["co_phone"] != null) ? Session["co_phone"] : ""); %>" name="txtPhoneNo" placeholder="Phone number" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Email:</span></div>
                            <div row-obj="column">
                                <input type="text" value="<% Response.Write((Session["co_email"] != null) ? Session["co_email"] : ""); %>" name="txtEmail" placeholder="Email" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Service Description:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="serviceCmb">
                                    <%
                                        var services = db.Services.ToList();
                                        foreach (var itm in services)
                                        {
                                    %>
                                    <option value="<% Response.Write(itm.ID); %>"><% Response.Write(itm.ServiceTitle); %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        
                        <div form-obj="row" float="true" headr style="margin-top: 30px;">
                            <div row-obj="column"><span>Set your password</span></div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Choose a password:</span></div>
                            <div row-obj="column">
                                <input type="password" id="itxtPwd" name="txtPwd" placeholder="Please enter your password" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true" class="spacer">
                            <div row-obj="column"><span>Retype password:</span></div>
                            <div row-obj="column">
                                <input type="password" id="itxtCPwd" name="txtCPwd" placeholder="Retype your password" style="width: 310px" />
                            </div>
                        </div>

                        <div form-obj="row" float="true" style="margin-top: 10px;">
                            <div row-obj="column"><span></span></div>
                            <div row-obj="column">
                                <div row-obj="column" style="font-family: Verdana, Geneva, Tahoma, sans-serif; width: 300px;">
                                    Upon creating my account, I agree to the uvind terms and conditions.
                                </div>
                            </div>
                        </div>

                        <div form-obj="row" float="true" class="spacer"></div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column">
                                <input type="submit" id="submt-btn" value="Create Account" />
                            </div>
                        </div>

                    </div>
                </form>
            </div>
            <div id="cooperate-form" ftype="cform" <% Response.Write(!is_individual ? "" : "class=\"hide_form\""); %> style="margin: auto;">
                <%
                    if (Session["signup_error"] != null)
                    {
                        var sess_respnse = Session["signup_error"];
                        var title = "";
                        var descr = "";
                        if (sess_respnse == "BadPwd")
                        {
                            title = "Invalid password!";
                            descr = "Your password must contain at least one digit, one lower case letter, one uppercase letter, and must not exceed 15 characters long";
                        }
                        if (sess_respnse == "PwdMismatch")
                        {
                            title = "Password mismatch!";
                            descr = "Please retype your password in the 'Retype Password' field below";
                        }
                        if (sess_respnse == "InvalidEmail")
                        {
                            title = "Invalid email!";
                            descr = "You entered an invalid email in the 'Email Address' field below";
                        }
                        if (sess_respnse == "Exist")
                        {
                            title = "Email already used";
                            descr = "Sorry, an account created with this email already exist.";
                        }
                %>
                <div bdy-obj="hintbox" id="hintbox">
                    <div hintbox-obj="title"><% Response.Write(title); %></div>
                    <div hintbox-obj="descr"><% Response.Write(descr); %></div>
                </div>
                <%
                    }    
                %>
                <form type="cooperate" id="frm" method="post" action="?p=dosignup&t=<% Response.Write(FindAService_WebForm.UserType.Business); %>" enctype="application/x-www-form-urlencoded">
                    <div bdy-obj="form">
                        <div form-obj="row" float="true" headr>
                            <div row-obj="column"><span>Cooperate information</span></div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Business category:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" id="bizCategryCmb" name="bizCategryCmb">
                                    <%
                                        var bizcategries = db.BusinessCategories.ToList();
                                        foreach (var itm in bizcategries)
                                        {
                                    %>
                                    <option value="<% Response.Write(itm.ID); %>"><% Response.Write(itm.BusinessCategoryTitle); %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Business name:</span></div>
                            <div row-obj="column">
                                <input type="text" id="txtName" name="txtName" placeholder="Enter your company name" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Description:</span></div>
                            <div row-obj="column">
                                <textarea id="txtDescr" name="txtDescr" placeholder="Tell us about your business" style="width: 310px;" rows="5"></textarea>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Contact Address:</span></div>
                            <div row-obj="column">
                                <input type="text" id="txtContactAddress" name="txtContactAddress" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Country:</span></div>
                            <div row-obj="column">
                                <%--<select style="width: 324px;" name="countryCmb" id="<% Response.Write((Session["co_cntry"] != null) ? Session["co_cntry"] : ((cookie_cntry != null) ? cookie_cntry.ID : "")); %>">--%>
                                <select style="width: 324px;" name="countryCmb" id="<% Response.Write(cookie_cntry.ID); %>">
                                    <%
                                        var b_countries = db.Countries.ToList();
                                        var b_selectd_cntry = countries.FirstOrDefault();
                                        foreach (var country in b_countries)
                                        {
                                    %>
                                    <option value="<% Response.Write(country.ID); %>"><% Response.Write(country.CountryName); %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>State/Province:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="stateCmb" id="<% Response.Write((Session["co_state"] != null) ? Session["co_state"] : ""); %>">
                                    <%
                                        var b_selectd_state = "";
                                        if(selectd_cntry != null)
                                        {
                                            var states_obj = db.States.Where(x => x.Country_ID == selectd_cntry.ID);
                                            var b_states = states_obj.ToList();
                                            b_selectd_state = ((b_states != null) && (b_states.FirstOrDefault() != null)) ? b_states.FirstOrDefault().ID : ""; 
                                            
                                            foreach (var state in b_states)
                                            {
                                    %>
                                    <option value="<% Response.Write(state.ID); %>"><% Response.Write(state.StateName); %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>City:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="cityCmb" id="<% Response.Write((Session["co_city"] != null) ? Session["co_city"] : ""); %>">
                                    <%
                                        // countries = db.Countries.ToList();
                                        // selectd_cntry = countries.FirstOrDefault();
                                        // states = db.States.Where(x => x.Country_ID == selectd_cntry.ID);
                                        // selectd_state = states.ToList().FirstOrDefault();
                                        cities = db.Cities.Where(x => x.State_ID == b_selectd_state).ToList();
                                        foreach (var city in cities)
                                        {
                                    %>
                                    <option value="<% Response.Write(city.ID); %>"><% Response.Write(city.CityName); %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Phone Number:</span></div>
                            <div row-obj="column">
                                <input type="text" value="<% Response.Write((Session["co_phone"] != null) ? Session["co_phone"] : ""); %>" id="txtPhoneNo" name="txtPhoneNo" placeholder="Phone number" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Email:</span></div>
                            <div row-obj="column">
                                <input type="text" value="<% Response.Write((Session["co_email"] != null) ? Session["co_email"] : ""); %>" id="txtEmail" name="txtEmail" placeholder="me@website.com" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Website:</span></div>
                            <div row-obj="column">
                                <input type="text" id="Text1" name="txtWebsite" placeholder="http://" style="width: 310px;" />
                            </div>
                        </div>

                        <div form-obj="row" float="true" headr style="margin-top: 30px;">
                            <div row-obj="column"><span>Set your password</span></div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Choose a password:</span></div>
                            <div row-obj="column">
                                <input type="password" id="btxtPwd" name="txtPwd" placeholder="Please enter your password" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true" class="spacer">
                            <div row-obj="column"><span>Retype password:</span></div>
                            <div row-obj="column">
                                <input type="password" id="btxtCPwd" name="txtCPwd" placeholder="Retype your password" style="width: 310px;" />
                            </div>
                        </div>

                        <div form-obj="row" float="true" style="margin-top: 10px;">
                            <div row-obj="column"><span></span></div>
                            <div row-obj="column">
                                <div row-obj="column" style="font-family: Verdana, Geneva, Tahoma, sans-serif; width: 300px;">
                                    Upon creating my account, I agree to the uvind terms and conditions.
                                </div>
                            </div>
                        </div>

                        <div form-obj="row" float="true" class="spacer"></div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column">
                                <input type="submit" id="submt-btn" value="Create Account" />
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div wnd-obj="diag">
        <div diag-obj="chrome">
            <div chrome-obj="msag"></div>
            <div chrome-obj="bttn">
                <div bttn-obj="yes">Okay!</div>
            </div>
        </div>
    </div>
    <%
        Session.RemoveAll();
    %>
</asp:Content>
