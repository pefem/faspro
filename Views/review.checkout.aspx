<%@ Page Title="" Language="C#" MasterPageFile="Shared/Register.Master" AutoEventWireup="true" CodeBehind="review.checkout.aspx.cs" Inherits="FindAService_WebForm.ReviewCheckout" %>

<asp:Content ID="script_area" ContentPlaceHolderID="script_area" runat="server">
    <script type="text/javascript" src="/Scripts/prototype.script.js"></script>
    <script type="text/javascript" src="Scripts/checkout.script.js"></script>
    <script type="text/javascript" src="Scripts/xhr.script.js"></script>
</asp:Content>

<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
    <link rel="stylesheet" href="Content/css/layouts/layout.reader.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.selectionview.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.review.gridview.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.invoice.gridview.style.css" type="text/css" />
    <link rel="stylesheet" href="Content/css/layouts/layout.personal.details.style.css" type="text/css" />
</asp:Content>

<asp:Content ID="menu_area" ContentPlaceHolderID="menu_area" runat="server">
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
<asp:Content ID="signup" ContentPlaceHolderID="main_body" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();

        var pckge_id = int.Parse(Request["pckge"]);
        var pckage = db.AdsPackages.Where(x => x.Increment == pckge_id).FirstOrDefault();
        if ((Request["p"] != null) && (Request["p"] == "reviewcheckout"))
        {
    %>
    <div layout-obj="reader-headr">
        <div headr-obj="hdr">
            <div hdr-obj="lft-pane" style="width: 600px;">
                <div pane-obj="title">Review & Checkout</div>
                <div pane-obj="description">Kindly review your selection below before you continue to checkout</div>
            </div>
        </div>
    </div>
    <div layout-obj="reader">
        <div pane-obj="review-gridview">
            <div review-obj="gridvw">
                <div gridvw-obj="col" col-1>
                    <div col-obj="hdr">Package Title</div>
                    <div col-obj="row"><% Response.Write(pckage.Title); %></div>
                    <div col-obj="ftr" style="text-align: right;">Total Amount:</div>
                </div>
                <div gridvw-obj="col" col-2>
                    <div col-obj="hdr">Amount</div>
                    <div col-obj="row"><% Response.Write("NGN" + pckage.Amount); %></div>
                    <div col-obj="ftr"><% Response.Write("NGN" + pckage.Amount); %></div>
                </div>
            </div>
            <div review-obj="btn-wrappr">
                <div wrappr-obj="btn" checkout selected url="?p=personaldetails&pckge=<% Response.Write(Request["pckge"]); %>&sess=<% Response.Write(Request["sess"]); %>">Continue to Checkout</div>
                <div wrappr-obj="btn" cancel>Go Back</div>
            </div>
        </div>
    </div>
    <%
        }
        else if ((Request["p"] != null) && (Request["p"] == "personaldetails"))
        {
    %>
    <div layout-obj="reader-headr">
        <div headr-obj="hdr" style="height: 50px;">
            <div hdr-obj="lft-pane" style="width: 600px;">
                <div pane-obj="title">Complete Process</div>
            </div>
        </div>
    </div>
    <div layout-obj="personal-details">
        <div personal-details-obj="hdr"></div>
        <div personal-details-obj="bdy">
            <div id="cooperate-form" ftype="cform">
                <form method="post" action="?p=completeorder&r=<% Response.Write(Request["p"]); %>&pckge=<% Response.Write(Request["pckge"]); %>&sess=<% Response.Write(Request["sess"]); %>&t=1" enctype="application/x-www-form-urlencoded">
                    <div bdy-obj="form">
                        <input type="hidden" name="pckge" value="<% Response.Write(Request["pckge"]); %>" />
                        <div form-obj="row" float="true" headr>
                            <div row-obj="column"><span>Please login to continue your ordering process.</span></div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Email Address:</span></div>
                            <div row-obj="column">
                                <input type="text" id="txtEmail" name="txtEmail" placeholder="me@website.com" style="width: 300px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Password:</span></div>
                            <div row-obj="column">
                                <input type="password" id="txtPwd" name="txtPwd" placeholder="Please enter your password" style="width: 300px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true" class="spacer"></div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column">
                                <input type="submit" id="Submit1" value="Sign In to Continue" />
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div id="individual-form" ftype="iform">
                <%
            if (Session["error"] != null)
            {
                var sess_respnse = Session["error"];
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
                %>
                <div bdy-obj="hintbox">
                    <div hintbox-obj="title"><% Response.Write(title); %></div>
                    <div hintbox-obj="descr"><% Response.Write(descr); %></div>
                </div>
                <%
            }    
                %>
                <%--<form method="post" action="?p=completeorder&r=<% Response.Write(Request["p"]); %>&pckge=<% Response.Write(Request["pckge"]); %>&sess=<% Response.Write(Request["sess"]); %>" enctype="application/x-www-form-urlencoded">--%>
                    <div bdy-obj="form">
                        <input type="hidden" name="pckge" value="<% Response.Write(Request["pckge"]); %>" />
                        <%--<div form-obj="row" float="true" headr>
                            <div row-obj="column"></div>
                            <div row-obj="column" style="text-align: center;"><span>New Customers</span></div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Email:</span></div>
                            <div row-obj="column">
                                <input type="text" name="txtEmail" placeholder="Email" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Phone Number:</span></div>
                            <div row-obj="column">
                                <input type="text" name="txtPhoneNo" placeholder="Phone number" style="width: 310px;" />
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>Country:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="countryCmb">
                                    <%
                                                                    var countries = db.Countries.ToList();
                                                                    var selectd_cntry = countries.FirstOrDefault();
                                                                    var states = db.States.Where(x => x.Country_ID == selectd_cntry.ID).ToList();
                                                                    var selectd_state = states.FirstOrDefault();
                                                                    var cities = db.Cities.Where(x => x.State_ID == selectd_state.ID).ToList();
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
                            <div row-obj="column"><span>State:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="stateCmb">
                                    <%
            foreach (var state in states)
            {
                                    %>
                                    <option value="<% Response.Write(state.ID); %>"><% Response.Write(state.StateName); %></option>
                                    <%
            }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div form-obj="row" float="true">
                            <div row-obj="column"><span>City:</span></div>
                            <div row-obj="column">
                                <select style="width: 324px;" name="cityCmb">
                                    <%
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
                        <div form-obj="row" float="true" class="spacer"></div>--%>
                        <div form-obj="row" float="true">
                            <div row-obj="column"></div>
                            <div row-obj="column" style="font-size: 14px;">
                                Don't have an account? <a href="?p=completeorder&r=<% Response.Write(Request["p"]); %>&pckge=<% Response.Write(Request["pckge"]); %>&sess=<% Response.Write(Request["sess"]); %>">Sign up now</a>.
                                <%--<input type="submit" id="bntSubmit1" value="Complete Order With a New Account" style="width: 324px;" />--%>
                            </div>
                        </div>

                    </div>
                <%--</form>--%>
            </div>
        </div>
    </div>
    <%
        }
        else if ((Request["p"] != null) && (Request["p"] == "viewinvoice"))
        {
            var receipt_no = Request["invoice"];

            var ads = (dynamic)null;
            var tck = (dynamic)null;

            var usr_id = "";
            var ads_id = "";
            var adsPckg_id = "";
            var tickno = "";
            var datecreated = "";
            var datexpired = "";

            var invoice = (from ad in db.Ads
                           join tckt in db.AdsHistories on ad.ID equals tckt.Ads_ID
                           where tckt.TicketNo == receipt_no || ad.ReceiptNo == receipt_no
                           select new
                           {
                               ads = ad,
                               ticket = tckt
                           }).FirstOrDefault();

            if (invoice != null)
            {
                var ticket = invoice.ticket;
                var tckt_no = (ticket.TicketNo != null) ? ticket.TicketNo : invoice.ads.ReceiptNo;
    %>
    <div layout-obj="reader-headr" style="padding: 30px 0px;">
        <div headr-obj="hdr">
            <div hdr-obj="lft-pane" style="width: 600px;">
                <div pane-obj="title">Invoice - #<% Response.Write(tckt_no); %></div>
                <div pane-obj="date-descr">
                    <div>Invoice Date: <% Response.Write(ticket.DateCreated); %></div>
                    <div>Due Date: <% Response.Write(ticket.DateExpired); %></div>
                </div>
            </div>
            <div pane-obj="buttn"><a href="#"></a></div>
        </div>
    </div>
    <div layout-obj="reader">
        <div pane-obj="invoice">
            <div invoice-obj="hint">If you choose to make payment directly to our bank account by visiting a bank physically or via online transfer, do ensure to send a mail to billing@uvind.com stating the details of your payment.</div>
            <div invoice-obj="owner">
                <%
                                      var name = "";
                                      var addr = "";
                                      var city = "";
                                      var state = "";
                                      var cntry = "";

                                      var iusr = db.UserIndividuals.Where(x => x.ID == invoice.ads.User_ID).FirstOrDefault();
                                      if (iusr != null)
                                      {                                          
                                          name = iusr.FirstName + " " + iusr.LastName;
                                          addr = iusr.ContactAddress;
                                          city = db.Cities.Find(iusr.City_ID).CityName;
                                          state = db.States.Find(iusr.State_ID).StateName;
                                          cntry = db.Countries.Find(iusr.Country_ID).CountryName;
                                      }
                                      else
                                      {
                                          var busr = db.UserBusinesses.Where(x => x.ID == invoice.ads.User_ID).FirstOrDefault();
                                          if (busr != null)
                                          {
                                              name = busr.BusinessName;
                                              addr = busr.ContactAddress;
                                              city = db.Cities.Find(busr.City_ID).CityName;
                                              state = db.States.Find(busr.State_ID).StateName;
                                              cntry = db.Countries.Find(busr.Country_ID).CountryName;
                                          }
                                      }

                                      var package = db.AdsPackages.Where(x => x.ID == invoice.ads.AdsPackage_ID).FirstOrDefault();
                %>
                <div owner-obj="hdr">Invoice To</div>
                <div owner-obj="bdy">
                    <div bdy-obj="rw">
                        <div rw-obj="lft">Name:</div>
                        <div rw-obj="rgt"><% Response.Write(name); %></div>
                    </div>
                    <div bdy-obj="rw">
                        <div rw-obj="lft">Contact Address:</div>
                        <div rw-obj="rgt">
                            <% Response.Write(addr); %>, 
                            <br />
                            <% Response.Write(city + ", " + state); %><br />
                            <% Response.Write(cntry); %>
                        </div>
                    </div>
                </div>
            </div>
            <div invoice-obj="gridvw">
                <div gridvw-obj="col-2">
                    <div col-obj="hdr">Amount</div>
                    <div col-obj="row"><% Response.Write("NGN" + package.Amount); %></div>
                    <div col-obj="ftr"><% Response.Write("NGN" + package.Amount); %></div>
                </div>
                <div gridvw-obj="col-1">
                    <div col-obj="hdr">Description</div>
                    <div col-obj="row"><% Response.Write(package.Title); %></div>
                    <div col-obj="ftr" style="text-align: right;">Total Amount:</div>
                </div>
            </div>
        </div>
    </div>
    <%
            }
            else
            {
                // Response.Redirect("?p=nopage");
            }
        }
    %>
</asp:Content>
