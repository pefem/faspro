using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.IO;
using System.Drawing;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.Helpers;
using System.Web.Script.Serialization;
using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security;
using System.Security.Cryptography;

using FindAService_WebForm.Models;
using FindAService_WebForm.Controllers;

using Chibex.Ozioma.DotNet.API;

namespace FindAService_WebForm
{
    public partial class Default : System.Web.UI.Page
    {
        FASDBEntities db = new FASDBEntities();
        NotificationController notifCntr = new NotificationController();

        protected void Page_Load(object sender, EventArgs e)
        {
            var url = "";
            var url_addr = ConfigurationManager.AppSettings["webservice_url"];
            HttpWebRequest wreq = null;
            HttpWebResponse wres = null;

            //if ((ConfigurationManager.AppSettings["public_key"] != null) && (File.Exists(AppDomain.CurrentDomain.BaseDirectory + @"\key.lic")) && (((File.Exists(AppDomain.CurrentDomain.BaseDirectory + @"\key.lic")) ? File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + @"\key.lic") : "") == ConfigurationManager.AppSettings["public_key"]))
            //{
            switch (Request.QueryString["p"])
            {
                default:
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/main.aspx", true);
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "nopage":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/nopage.aspx", true);
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "selectionloactn":
                    Response.Cookies["page"]["isDefault"] = "true";
                    Response.Cookies["page"]["location"] = Request["locatnCmb"];
                    Response.Cookies["page"].Expires = DateTime.Now.AddMonths(1);
                    Response.Redirect(".");
                    break;
                case "avatar":
                    try
                    {
                        url = Request.QueryString["url"];
                        url = url.Substring(0, url.LastIndexOf('.'));
                        url = url_addr + "/image/avatar/" + url;

                        wreq = (HttpWebRequest)WebRequest.Create(url);
                        wreq.ContentType = "image/jpg";
                        wreq.Method = "GET";
                        wres = (HttpWebResponse)wreq.GetResponse();
                        using (Stream stream = wres.GetResponseStream())
                        {
                            stream.CopyTo(Response.OutputStream);
                            Response.Flush();
                            Response.End();
                            stream.Close();
                        }
                        wres.Close();
                    }
                    catch (Exception)
                    {
                        Response.Write("File not found!");
                    }
                    break;
                case "doavatarupld":
                    if ((string)Session["usr_type"] != "business")
                    {
                        Session["txtFirstName"] = Request["txtFirstName"];
                        Session["txtLastName"] = Request["txtLastName"];
                        Session["cmbSex"] = Request["cmbSex"];
                        Session["txtPhoneNo"] = Request["txtPhoneNo"];
                        Session["txtAboutUs"] = Request["txtAboutUs"];
                        Session["cmbServ"] = Request["cmbServ"];
                    }
                    else
                    {
                        Session["txtCompanyName"] = Request["txtCompanyName"];
                        Session["txtAboutCompany"] = Request["txtAboutCompany"];
                        Session["cmbCategory"] = Request["cmbCategory"];
                        Session["txtPhoneNo"] = Request["txtPhoneNo"];
                        Session["txtWebsite"] = Request["txtWebsite"];
                        Session["txtCompanyBgImg"] = Request["txtCompanyBgImg"];
                    }

                    var file = Request.Files["upldFile"];
                    if ((file != null))
                    {
                        var fileContentType = file.ContentType;
                        var paramName = "file";
                        var fileName = file.FileName;
                        var id = DateTime.Now.Ticks.ToString();
                        var uploadUrl = url_addr + "/image/avatar";

                        var fileMimeType = fileContentType.Substring(0, fileContentType.IndexOf('/'));
                        if ((file.ContentLength > 0) && (fileMimeType == "image"))
                        {

                            var nvc = new NameValueCollection();
                            nvc.Add("usr", Request["txtUsrID"]);

                            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");

                            byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

                            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(uploadUrl);
                            wr.ContentType = "multipart/form-data; boundary=" + boundary;
                            wr.Method = "POST";
                            wr.KeepAlive = true;
                            wr.Credentials = System.Net.CredentialCache.DefaultCredentials;

                            using (Stream rs = wr.GetRequestStream())
                            {
                                string formdataTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
                                foreach (string key in nvc.Keys)
                                {
                                    rs.Write(boundarybytes, 0, boundarybytes.Length);
                                    string formitem = string.Format(formdataTemplate, key, nvc[key]);
                                    byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
                                    rs.Write(formitembytes, 0, formitembytes.Length);
                                }
                                rs.Write(boundarybytes, 0, boundarybytes.Length);

                                string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n";
                                string header = string.Format(headerTemplate, paramName, fileName, fileContentType);
                                byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);
                                rs.Write(headerbytes, 0, headerbytes.Length);

                                byte[] buffer = new byte[4096];
                                int bytesRead = 0;
                                while ((bytesRead = file.InputStream.Read(buffer, 0, buffer.Length)) != 0)
                                {
                                    rs.Write(buffer, 0, bytesRead);
                                }
                                file.InputStream.Close();

                                byte[] trailer = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
                                rs.Write(trailer, 0, trailer.Length);
                                rs.Close();

                                using (WebResponse wresp = wr.GetResponse())
                                {
                                    using (Stream stream2 = wresp.GetResponseStream())
                                    {
                                        StreamReader reader2 = new StreamReader(stream2);
                                        var response = reader2.ReadToEnd();

                                        if ((string)Session["usr_type"] != "business")
                                        {
                                            UserIndividual usersaccount = Json.Decode<UserIndividual>(response);
                                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                                            Session["useraccount"] = usersaccount;
                                        }
                                        else
                                        {
                                            UserBusiness usersaccount = Json.Decode<UserBusiness>(response);
                                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                                            Session["useraccount"] = usersaccount;

                                            Session["txtCompanyAvatrImg"] = usersaccount.ImageUrl;
                                        }
                                    }
                                }

                            }

                        }
                    }

                    //
                    Session["notifier"] = "Uploaded successfully!";
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + Request["u"]);
                    break;
                case "cover":
                    try
                    {
                        url = Request.QueryString["url"];
                        url = url.Substring(0, url.LastIndexOf('.'));
                        url = url_addr + "/image/coverimage/" + url;
                        wreq = (HttpWebRequest)WebRequest.Create(url);
                        wreq.ContentType = "image/jpg";
                        wreq.Method = "GET";
                        wres = (HttpWebResponse)wreq.GetResponse();
                        using (Stream stream = wres.GetResponseStream())
                        {
                            stream.CopyTo(Response.OutputStream);
                            Response.Flush();
                            Response.End();
                            stream.Close();
                        }
                        wres.Close();
                    }
                    catch (Exception)
                    {
                        Response.Write("File not found!");
                    }
                    break;
                case "docoverupld":

                    Session["txtCompanyName"] = Request["txtCompanyName"];
                    Session["txtAboutCompany"] = Request["txtAboutCompany"];
                    Session["cmbCategory"] = Request["cmbCategory"];
                    Session["txtPhoneNo"] = Request["txtPhoneNo"];
                    Session["txtWebsite"] = Request["txtWebsite"];
                    Session["txtCompanyAvatrImg"] = Request["txtCompanyAvatrImg"];

                    var c_file = Request.Files["upldFile"];
                    if ((c_file != null))
                    {
                        var fileContentType = c_file.ContentType;
                        var paramName = "file";
                        var fileName = c_file.FileName;
                        var id = DateTime.Now.Ticks.ToString();
                        var uploadUrl = url_addr + "/image/coverimage";

                        var fileMimeType = fileContentType.Substring(0, fileContentType.IndexOf('/'));
                        if ((c_file.ContentLength > 0) && (fileMimeType == "image"))
                        {

                            var nvc = new NameValueCollection();
                            nvc.Add("usr", Request["txtUsrID"]);

                            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");

                            byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

                            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(uploadUrl);
                            wr.ContentType = "multipart/form-data; boundary=" + boundary;
                            wr.Method = "POST";
                            wr.KeepAlive = true;
                            wr.Credentials = System.Net.CredentialCache.DefaultCredentials;

                            using (Stream rs = wr.GetRequestStream())
                            {
                                string formdataTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
                                foreach (string key in nvc.Keys)
                                {
                                    rs.Write(boundarybytes, 0, boundarybytes.Length);
                                    string formitem = string.Format(formdataTemplate, key, nvc[key]);
                                    byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
                                    rs.Write(formitembytes, 0, formitembytes.Length);
                                }
                                rs.Write(boundarybytes, 0, boundarybytes.Length);

                                string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n";
                                string header = string.Format(headerTemplate, paramName, fileName, fileContentType);
                                byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);
                                rs.Write(headerbytes, 0, headerbytes.Length);

                                byte[] buffer = new byte[4096];
                                int bytesRead = 0;
                                while ((bytesRead = c_file.InputStream.Read(buffer, 0, buffer.Length)) != 0)
                                {
                                    rs.Write(buffer, 0, bytesRead);
                                }
                                c_file.InputStream.Close();

                                byte[] trailer = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
                                rs.Write(trailer, 0, trailer.Length);
                                rs.Close();

                                using (WebResponse wresp = wr.GetResponse())
                                {
                                    using (Stream stream2 = wresp.GetResponseStream())
                                    {
                                        StreamReader reader2 = new StreamReader(stream2);
                                        var response = reader2.ReadToEnd();

                                        UserBusiness useraccount = Json.Decode<UserBusiness>(response);
                                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                                        Session["useraccount"] = useraccount;

                                        Session["txtCompanyBgImg"] = useraccount.CoverImageUrl;
                                    }
                                }

                            }

                        }
                    }

                    //
                    Session["notifier"] = "Uploaded successfully!";
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + Request["u"]);
                    break;
                case "individual":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        switch (Request["t"])
                        {
                            case "1":
                                Server.Execute("Views/individual.portfolio.aspx", true);
                                break;
                            default:
                                Server.Execute("Views/individual.aspx", true);
                                break;
                        }
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "business":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        switch (Request["t"])
                        {
                            case "1":
                                Server.Execute("Views/business.portfolio.aspx", true);
                                break;
                            default:
                                Server.Execute("Views/business.aspx", true);
                                break;
                        }
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "contentimage":
                    try
                    {
                        url = Request.QueryString["url"];
                        url = url.Substring(0, url.LastIndexOf('.'));
                        url = url_addr + "/image/contentimage/" + url;
                        wreq = (HttpWebRequest)WebRequest.Create(url);
                        wreq.ContentType = "image/jpg";
                        wreq.Method = "GET";
                        wres = (HttpWebResponse)wreq.GetResponse();
                        using (Stream stream = wres.GetResponseStream())
                        {
                            stream.CopyTo(Response.OutputStream);
                            Response.Flush();
                            Response.End();
                            stream.Close();
                        }
                        wres.Close();
                    }
                    catch (Exception)
                    {
                        Response.Write("File not found!");
                    }
                    break;
                case "blogpostimage":
                    try
                    {
                        url = Request.QueryString["url"];
                        url = url.Substring(0, url.LastIndexOf('.'));
                        url = url_addr + "/image/blogpostimage/" + url;
                        wreq = (HttpWebRequest)WebRequest.Create(url);
                        wreq.ContentType = "image/jpg";
                        wreq.Method = "GET";
                        wres = (HttpWebResponse)wreq.GetResponse();
                        using (Stream stream = wres.GetResponseStream())
                        {
                            stream.CopyTo(Response.OutputStream);
                            Response.Flush();
                            Response.End();
                            stream.Close();
                        }
                        wres.Close();
                    }
                    catch (Exception)
                    {
                        Response.Write("File not found!");
                    }
                    break;
                case "dosearch":
                    var t = Request["t"];
                    var q = Request["what_txt"];
                    var srch_loc = Request["where_txt"];

                    if (t == UserType.Individual.ToString())
                    {
                        Response.Redirect("?p=searchresult&loc=" + srch_loc + "&t=iu&q=" + q);
                    }
                    else
                    {
                        Response.Redirect("?p=searchresult&loc=" + srch_loc + "&t=bu" + ((q != "0") ? "&q=" + q : ""));
                    }
                    break;
                case "searchresult":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/searchresult.aspx", true);
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "signup":
                    // if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    // {
                    Server.Execute("Views/signup.aspx");
                    // }
                    // else
                    // {
                    //    Server.Execute("Views/locator.aspx", true);
                    // }
                    break;
                case "dosignup":
                    t = Request["t"].ToUpper();
                    var txtPwd = Request["txtPwd"];
                    var txtCPwd = Request["txtCPwd"];

                    //if (!Regex.IsMatch(txtPwd, @"^(?=.*[a-zA-Z]+[a-zA-Z0-9]).{8,15}$"))
                    //{
                    //    Session["signup_error"] = "BadPwd";
                    //    Response.Redirect("?p=signup&t=" + t);
                    //}

                    if (txtCPwd != txtPwd)
                    {
                        Session["signup_error"] = "PwdMismatch";
                        Response.Redirect("?p=signup&t=" + t);
                    }

                    if (!Regex.IsMatch(Request["txtEmail"], @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$"))
                    {
                        Session["signup_error"] = "InvalidEmail";
                        Response.Redirect("?p=signup&t=" + t);
                    }

                    if (t == UserType.Individual.ToString().ToUpper())
                    {
                        var txtFName = UtilController.CleanString(Request["txtFirstName"]);
                        var txtLName = UtilController.CleanString(Request["txtLastName"]);
                        var txtCAddr = UtilController.CleanString(Request["txtContactAddress"]);
                        var txtEmail = Request["txtEmail"];
                        var txtPhoneNo = Request["txtPhoneNo"];
                        var serviceCmb = Request["serviceCmb"];
                        var cityCmb = Request["cityCmb"];
                        var stateCmb = Request["stateCmb"];
                        var countryCmb = Request["countryCmb"];

                        var check_usr = db.UserIndividuals.Where(x => x.Email == txtEmail)
                                                          .FirstOrDefault();
                        if (check_usr == null)
                        {
                            var usr_id = Guid.NewGuid().ToString();

                            //
                            // Save user password info

                            // Generate password salt
                            //
                            string pwdSalt = UtilController.GenerateRandomSalt();

                            db.UserAuthentications.Add(new UserAuthentication
                            {
                                ID = Guid.NewGuid().ToString(),
                                User_ID = usr_id,
                                UserType = (int)UserType.Individual,
                                Password = UtilController.EncodePassword(txtPwd, usr_id),
                                Salt = pwdSalt
                            });
                            db.SaveChanges();


                            //
                            // Save user details

                            db.UserIndividuals.Add(new UserIndividual
                            {
                                ID = usr_id,
                                FirstName = txtFName,
                                LastName = txtLName,
                                Email = txtEmail,
                                ContactAddress = txtCAddr,
                                ContactNumber = txtPhoneNo,
                                AboutMe = "",
                                Service_ID = serviceCmb,
                                City_ID = cityCmb,
                                State_ID = stateCmb,
                                Country_ID = countryCmb,
                                LastUpdateDate = DateTime.Now,
                                RegistrationDate = DateTime.Now,
                                IsQuarantined = false,
                                IsAgreedToTerms = true,
                                IsApproved = true,
                                IsCertified = false,
                                IsFeatured = false,
                                ImageUrl = ""
                            });
                            db.SaveChanges();

                            //
                            // Send SMS
                            try
                            {
                                OziomaApiImpl smsApi = new OziomaApiImpl();
                                smsApi.Message = "Your Uvind account password is " + txtPwd + ". Visit http://www.uvind.com to login.";
                                smsApi.Sender = "Uvind";
                                smsApi.Recipient = txtPhoneNo;
                                smsApi.Send();
                            }
                            catch (Exception) { }

                            //
                            // Clear error hint

                            // Session.Remove("signup_error");


                            //
                            // Store some data in session for me

                            Session["user_account_active"] = true;
                            Session["user_account_email"] = txtEmail.ToLower();
                            Session["usr_type"] = "individual";

                            //
                            // Redirect me asap

                            if (Session["frm_ads_order"] == null)
                            {
                                Response.Redirect("?p=account&u=" + txtEmail.ToLower());
                            }
                            else
                            {
                                var receiptNo = Session["invoice"].ToString();

                                var pckage_id = int.Parse(Session["package"].ToString());
                                var pckage = db.AdsPackages.Where(x => x.Increment == pckage_id).FirstOrDefault();
                                var guid = Guid.NewGuid().ToString();
                                var date_created = DateTime.Now;
                                var status = AdsStatus.Pending;

                                db.Ads.Add(new Ad
                                {
                                    ID = guid,
                                    User_ID = usr_id,
                                    AdsPackage_ID = pckage.ID,
                                    ReceiptNo = receiptNo,
                                    Status = (int)status
                                });
                                db.SaveChanges();

                                //
                                // Add Duration
                                db.AdsHistories.Add(new AdsHistory
                                {
                                    ID = Guid.NewGuid().ToString(),
                                    Ads_ID = guid,
                                    DateCreated = date_created,
                                    DateExpired = date_created.AddMonths(pckage.Duration)
                                });
                                db.SaveChanges();

                                Response.Redirect("?p=viewinvoice&pckge=" + Session["package"] + "&invoice=" + Session["invoice"]);
                            }
                        }
                        else
                        {
                            Session["signup_error"] = "Exist";
                            Response.Redirect("?p=signup&t=" + t);
                        }
                    }
                    else
                    {
                        var bizCategryCmb = Request["bizCategryCmb"];
                        var txtName = UtilController.CleanString(Request["txtName"]);
                        var txtDescr = UtilController.CleanString(Request["txtDescr"]);
                        var txtWebsite = Request["txtWebsite"];
                        var txtContactAddress = UtilController.CleanString(Request["txtContactAddress"]);
                        var txtEmail = Request["txtEmail"];
                        var txtPhoneNo = Request["txtPhoneNo"];
                        var cityCmb = Request["cityCmb"];
                        var stateCmb = Request["stateCmb"];
                        var countryCmb = Request["countryCmb"];

                        var check_usr = db.UserBusinesses.Where(x => x.Email == txtEmail)
                                                          .FirstOrDefault();
                        if (check_usr == null)
                        {
                            var usr_id = Guid.NewGuid().ToString();
                            string pwdSalt = UtilController.GenerateRandomSalt();

                            db.UserAuthentications.Add(new UserAuthentication
                            {
                                ID = Guid.NewGuid().ToString(),
                                User_ID = usr_id,
                                UserType = (int)UserType.Business,
                                Password = UtilController.EncodePassword(txtPwd, usr_id),
                                Salt = pwdSalt
                            });
                            db.SaveChanges();
                            //
                            db.UserBusinesses.Add(new UserBusiness
                            {
                                ID = usr_id,
                                BusinessName = txtName,
                                BusinessCategory_ID = bizCategryCmb,
                                BusinessDescription = txtDescr,
                                Email = txtEmail,
                                ContactAddress = txtContactAddress,
                                ContactNumber = txtPhoneNo,
                                City_ID = cityCmb,
                                State_ID = stateCmb,
                                Country_ID = countryCmb,
                                LastUpdateDate = DateTime.Now,
                                RegistrationDate = DateTime.Now,
                                IsQuarantined = false,
                                IsAgreedToTerms = true,
                                IsApproved = true,
                                IsCertified = false,
                                IsFeatured = false,
                                ImageUrl = ""
                            });
                            db.SaveChanges();

                            //
                            // Send SMS
                            try
                            {
                                OziomaApiImpl smsApi = new OziomaApiImpl();
                                smsApi.Message = "Your Uvind account password is " + txtPwd + ". Visit http://www.uvind.com to login.";
                                smsApi.Sender = "Uvind";
                                smsApi.Recipient = txtPhoneNo;
                                smsApi.Send();
                            }
                            catch (Exception) { }

                            Session.Remove("signup_error");
                            Session["user_account_active"] = true;
                            Session["user_account_email"] = txtEmail.ToLower();
                            Session["usr_type"] = "business";


                            // Redirect me asap

                            if (Session["frm_ads_order"] == null)
                            {
                                Response.Redirect("?p=account&u=" + txtEmail.ToLower());
                            }
                            else
                            {
                                var receiptNo = Session["invoice"].ToString();
                                var pckage_id = int.Parse(Session["package"].ToString());
                                var pckage = db.AdsPackages.Where(x => x.Increment == pckage_id).FirstOrDefault();
                                var guid = Guid.NewGuid().ToString();
                                var date_created = DateTime.Now;
                                var status = AdsStatus.Pending;

                                db.Ads.Add(new Ad
                                {
                                    ID = guid,
                                    User_ID = usr_id,
                                    AdsPackage_ID = pckage.ID,
                                    ReceiptNo = receiptNo,
                                    Status = (int)status
                                });
                                db.SaveChanges();

                                //
                                // Add Duration
                                db.AdsHistories.Add(new AdsHistory
                                {
                                    ID = Guid.NewGuid().ToString(),
                                    Ads_ID = guid,
                                    DateCreated = date_created,
                                    DateExpired = date_created.AddMonths(pckage.Duration)
                                });
                                db.SaveChanges();

                                Response.Redirect("?p=viewinvoice&pckge=" + Session["package"] + "&invoice=" + Session["invoice"]);
                            }
                        }
                        else
                        {
                            Session["signup_error"] = "Exist";
                            Response.Redirect("?p=signup&t=" + t.ToLower());
                        }
                    }
                    break;
                case "login":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/login.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "dologin":
                    var usr_txt = Request["email_txt"];
                    var pwd_txt = Request["pwd_txt"];

                    var iuserAccnt = (from usr in db.UserIndividuals
                                      join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                      where usr.Email == usr_txt
                                      select auth).FirstOrDefault();

                    if (iuserAccnt != null)
                    {
                        var hashed_pwd = UtilController.EncodePassword(pwd_txt, iuserAccnt.User_ID);
                        var iuser = (from usr in db.UserIndividuals
                                     join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                     where usr.Email == usr_txt && auth.Password == hashed_pwd
                                     select usr).FirstOrDefault();

                        if (iuser != null)
                        {
                            var usr_type = "";
                            var usr_serv = "";
                            var usr_email = "";

                            Session["user_account_active"] = true;
                            Session["user_account_email"] = usr_txt.ToLower();

                            Session.Remove("login_error");
                            if (Session["user_cmment_obj"] != null)
                            {
                                var cmmnt = (UserComment)Session["user_cmment_obj"];
                                usr_type = Session["utype"].ToString();
                                usr_serv = Session["service"].ToString();
                                usr_email = Session["uemail"].ToString();

                                Response.Write(cmmnt.User_ID + " -=- " + iuser.ID);

                                // Post comment
                                db.UserComments.Add(new UserComment
                                {
                                    ID = Guid.NewGuid().ToString(),
                                    User_ID = cmmnt.User_ID,
                                    Owner_ID = iuser.ID,
                                    Comment = cmmnt.Comment,
                                    DatetCommented = DateTime.Now
                                });
                                db.SaveChanges();

                                Session.Remove("user_cmment_obj");
                                Session["usr_type"] = "individual";
                                Response.Redirect("?p=" + usr_type + "&s=" + usr_serv + "&u=" + usr_email);
                            }
                            else
                            {
                                Session["usr_type"] = "individual";
                                Response.Redirect("?p=account&u=" + iuser.Email.ToLower());
                            }
                        }
                        else
                        {
                            Session["login_error"] = "NOTFOUND";
                            Response.Redirect("?p=login");
                        }
                    }
                    else
                    {

                        var buserAccnt = (from usr in db.UserBusinesses
                                          join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                          where usr.Email == usr_txt
                                          select auth).FirstOrDefault();

                        if (buserAccnt != null)
                        {
                            var hashed_pwd = UtilController.EncodePassword(pwd_txt, buserAccnt.User_ID);
                            var buser = (from usr in db.UserBusinesses
                                         join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                         where usr.Email == usr_txt && auth.Password == hashed_pwd
                                         select usr).FirstOrDefault();
                            if (buser != null)
                            {
                                var usr_type = "";
                                var usr_serv = "";
                                var usr_email = "";

                                Session["user_account_active"] = true;
                                Session["user_account_email"] = usr_txt.ToLower();

                                Session.Remove("login_error");
                                if (Session["user_cmment_obj"] != null)
                                {
                                    var cmmnt = (UserComment)Session["user_cmment_obj"];
                                    usr_type = Session["utype"].ToString();
                                    usr_serv = Session["service"].ToString();
                                    usr_email = Session["uemail"].ToString();

                                    // Post comment
                                    db.UserComments.Add(new UserComment
                                    {
                                        ID = Guid.NewGuid().ToString(),
                                        User_ID = cmmnt.User_ID,
                                        Owner_ID = buser.ID,
                                        Comment = cmmnt.Comment,
                                        DatetCommented = DateTime.Now
                                    });
                                    db.SaveChanges();

                                    Session.Remove("user_cmment_obj");
                                    Session["usr_type"] = "business";
                                    Response.Redirect("?p=" + usr_type + "&s=" + usr_serv + "&u=" + usr_email);
                                }
                                else
                                {
                                    Session["usr_type"] = "business";
                                    Response.Redirect("?p=account&u=" + buser.Email.ToLower());
                                }
                            }
                            else
                            {
                                Session["login_error"] = "NOTFOUND";
                                Response.Redirect("?p=login");
                            }
                        }
                        else
                        {
                            Session["login_error"] = "NOTFOUND";
                            Response.Redirect("?p=login");
                        }
                    }
                    break;
                case "forgotpassword":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/forgotpassword.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "doforgotpassword":
                    var usr_email_txt = Request["email_txt"];

                    var fp_iuser = (from usr in db.UserIndividuals
                                    join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                    where usr.Email == usr_email_txt
                                    select usr).FirstOrDefault();
                    if (fp_iuser != null)
                    {
                        //
                        // Generate new password

                        var newPassowrd = "";

                        if (fp_iuser.Email == "")
                        {
                            //
                            // Send password via sms

                            try
                            {
                                OziomaApiImpl smsApi = new OziomaApiImpl();
                                smsApi.Message = "Code: " + newPassowrd;
                                smsApi.Sender = "Uvind";
                                smsApi.Recipient = fp_iuser.ContactNumber;
                                smsApi.Send();
                            }
                            catch (Exception) { }

                            Session.Remove("forgot_error");
                            Response.Redirect("?p=pwdrecoverycode");
                        }
                        else
                        {
                            //
                            // Send password via mail
                            try
                            {
                                var redirUrl = "httP://" + (new Uri(Request.Url.ToString())).Host.ToString() + "/?p=updatepassword&email=" + fp_iuser.Email;
                                var message = "<html><body><div style=\"color:#444444;border-collapse:collapse;font-size:11pt;font-family:'Open Sans', 'Lucida Grande', 'Segoe UI', Arial, Verdana, 'Lucida Sans Unicode', Tahoma, 'Sans Serif';overflow-x:auto;max-width:650px;\"><div>Hello " + fp_iuser.FirstName + "</div><br/><div>You have requested to change your uvind account password.</div><div>Please click <a href=\"" + redirUrl + "\">here</a> to change your existing password to a new one.</div><br/><div>Please ignore this message if you didn't request to change your existing password.</div><br/></div></body></html>";

                                MailMessage pwdMailMsg = new System.Net.Mail.MailMessage();
                                pwdMailMsg.Subject = "Please confirm your password update request";
                                pwdMailMsg.From = new MailAddress("noreply@uvind.com", "Uvind");
                                pwdMailMsg.To.Add(new MailAddress(fp_iuser.Email, ""));
                                pwdMailMsg.IsBodyHtml = true;
                                pwdMailMsg.Body = message;

                                //SmtpClient SmtpClient = new SmtpClient("smptout.secureserver.net", 25);
                                SmtpClient SmtpClient = new SmtpClient("relay-hosting.secureserver.net", 25);
                                SmtpClient.UseDefaultCredentials = true;
                                SmtpClient.Send(pwdMailMsg);
                            }
                            catch (Exception ex)
                            {
                                // throw ex;
                            }

                            Session.Remove("forgot_error");
                            Response.Redirect("?p=pwdrecoverymailsent");

                            Response.Write((new Uri(Request.Url.ToString())).Host.ToString());
                        }
                    }
                    else
                    {
                        var fp_buser = (from usr in db.UserBusinesses
                                        join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                        where usr.Email == usr_email_txt
                                        select usr).FirstOrDefault();
                        if (fp_buser != null)
                        {
                            //
                            // Generate new password

                            var newPassowrd = "";

                            if (fp_buser.Email == "")
                            {
                                //
                                // Send password via sms

                                try
                                {
                                    OziomaApiImpl smsApi = new OziomaApiImpl();
                                    smsApi.Message = "Code: " + newPassowrd;
                                    smsApi.Sender = "Uvind";
                                    smsApi.Recipient = fp_iuser.ContactNumber;
                                    smsApi.Send();
                                }
                                catch (Exception) { }

                                Session.Remove("forgot_error");
                                Response.Redirect("?p=pwdrecoverycode");
                            }
                            else
                            {
                                //
                                // Send password via mail
                                try
                                {
                                    var redirUrl = "httP://" + (new Uri(Request.Url.ToString())).Host.ToString() + "/?p=updatepassword&email=" + fp_iuser.Email;
                                    var message = "<html><body><div style=\"color:#444444;border-collapse:collapse;font-size:11pt;font-family:'Open Sans', 'Lucida Grande', 'Segoe UI', Arial, Verdana, 'Lucida Sans Unicode', Tahoma, 'Sans Serif';overflow-x:auto;max-width:650px;\"><div>Hello " + fp_buser.BusinessName + "</div><br/><div>You have requested to change your uvind account password.</div><div>Please click <a href=\"" + redirUrl + "\">\"here\"</a> to change your existing password to a new one.</div><br/><div>Please ignore this message if you didn't request to change your existing password.</div><br/></div></body></html>";

                                    MailMessage pwdMailMsg = new System.Net.Mail.MailMessage();
                                    pwdMailMsg.Subject = "Please confirm your password update request";
                                    pwdMailMsg.From = new MailAddress("noreply@uvind.com", "Uvind");
                                    pwdMailMsg.To.Add(new MailAddress(fp_buser.Email, ""));
                                    pwdMailMsg.IsBodyHtml = true;
                                    pwdMailMsg.Body = message;

                                    //SmtpClient SmtpClient = new SmtpClient("relay-hosting.secureserver.net", 25);
                                    SmtpClient SmtpClient = new SmtpClient("smptout.secureserver.net", 25);
                                    SmtpClient.UseDefaultCredentials = true;
                                    SmtpClient.Send(pwdMailMsg);
                                }
                                catch (Exception ex)
                                {
                                    // throw ex;
                                }

                                Session.Remove("forgot_error");
                                Response.Redirect("?p=pwdrecoverymailsent");

                                Response.Write((new Uri(Request.Url.ToString())).Host.ToString());
                            }
                        }
                        else
                        {
                            Session["forgot_error"] = "NOTFOUND";
                            Response.Redirect("?p=forgotpassword");
                        }
                    }
                    break;
                case "pwdrecoverycode":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/password.recovery.code.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "dopwdrecoverycode":
                    break;
                case "pwdrecoverymailsent":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/password.recovery.mail.success.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "updatepassword":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/password.update.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "doupdatepassword":

                    var txtForgotEmail = Request["txtEmail"];
                    var txtForgotPassword = Request["txtPassword"];

                    if (!Regex.IsMatch(txtForgotEmail, @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$"))
                    {
                        Session["pwd_update_error"] = "InvalidEmail";
                        Response.Redirect("?p=updatepassword&email=" + txtForgotEmail);
                    }


                    var check_iusr = db.UserIndividuals.Where(x => x.Email == txtForgotEmail)
                                                      .FirstOrDefault();
                    if (check_iusr != null)
                    {
                        var salt = UtilController.GenerateRandomSalt();
                        var hashedPwd = UtilController.EncodePassword(txtForgotPassword, check_iusr.ID);
                        var sql = "UPDATE UserAuthentications SET Password='" + hashedPwd + "', Salt='" + salt + "'";
                        sql += "WHERE User_ID = '" + check_iusr.ID + "'";
                        var queryObj = db.Database.ExecuteSqlCommand(sql);


                        //
                        // Send SMS
                        try
                        {
                            OziomaApiImpl smsApi = new OziomaApiImpl();
                            smsApi.Message = "Your new Uvind account password is " + txtForgotPassword + ". Visit http://www.uvind.com to login.";
                            smsApi.Sender = "Uvind";
                            smsApi.Recipient = check_iusr.ContactNumber;
                            smsApi.Send();
                        }
                        catch (Exception) { }
                    }
                    else
                    {
                        var check_busr = db.UserIndividuals.Where(x => x.Email == txtForgotEmail)
                                                      .FirstOrDefault();
                        if (check_busr != null)
                        {
                            var salt = UtilController.GenerateRandomSalt();
                            var hashedPwd = UtilController.EncodePassword(txtForgotPassword, check_busr.ID);
                            var sql = "UPDATE UserAuthentications SET Password='" + hashedPwd + "', Salt='" + salt + "'";
                            sql += "WHERE User_ID = '" + check_busr.ID + "'";
                            var queryObj = db.Database.ExecuteSqlCommand(sql);

                            //
                            // Send SMS
                            try
                            {
                                OziomaApiImpl smsApi = new OziomaApiImpl();
                                smsApi.Message = "Your new Uvind account password is " + txtForgotEmail + ". Visit http://www.uvind.com to login.";
                                smsApi.Sender = "Uvind";
                                smsApi.Recipient = check_busr.ContactNumber;
                                smsApi.Send();
                            }
                            catch (Exception) { }

                            Session.Remove("signup_error");
                        }
                        else
                        {
                            Response.Redirect(".");
                        }
                    }

                    Response.Redirect("?p=updatepasswordsuccess");
                    break;
                case "updatepasswordsuccess":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/password.update.success.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "logout":
                    Session.Remove("user_account_active");
                    Session.Remove("error_title");
                    Session.Remove("error_descr");
                    Session.RemoveAll();
                    Response.Redirect("?p=login");
                    break;
                case "account":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        switch (Request["tb"])
                        {
                            default:
                                if ((string)Session["usr_type"] != "business")
                                {
                                    Server.Execute("Views/individual.account.aspx");
                                }
                                else
                                {
                                    Server.Execute("Views/business.account.aspx");
                                }
                                break;
                            case "1":
                                if ((string)Session["usr_type"] != "business")
                                {
                                    Server.Execute("Views/individual.account.portfolio.aspx");
                                }
                                else
                                {
                                    Server.Execute("Views/business.account.portfolio.aspx");
                                }
                                break;
                            case "2":
                                if ((string)Session["usr_type"] != "business")
                                {
                                    Server.Execute("Views/individual.account.notification.aspx");
                                }
                                else
                                {
                                    Server.Execute("Views/business.account.notification.aspx");
                                }
                                break;
                            case "3":
                                if ((string)Session["usr_type"] != "business")
                                {
                                    Server.Execute("Views/individual.account.settings.aspx");
                                }
                                else
                                {
                                    Server.Execute("Views/business.account.settings.aspx");
                                }
                                break;
                        }
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "content":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/content.reader.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "blog":
                    //if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    //{
                    Server.Execute("Views/blogpost.aspx");
                    //}
                    //else
                    //{
                    //Server.Execute("Views/locator.aspx", true);
                    //}
                    break;
                case "doblogsearch":
                    var blogq = Request["what_txt"];
                    if ((blogq != null) && (blogq != ""))
                    {
                        Response.Redirect("?p=blog&q=" + blogq);
                    }
                    else
                    {
                        Response.Redirect("?p=blog");
                    }
                    break;
                case "advertise":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/advertise.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "chosepackge":
                    var packge = Request["package"];
                    Session["locatn"] = new { location = "package selection", package = packge };
                    Response.Redirect("?p=reviewcheckout&pckge=" + packge + "&sess=" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower());
                    break;
                case "reviewcheckout":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/review.checkout.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "personaldetails":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        if (Session["user_account_active"] == null)
                        {
                            Server.Execute("Views/review.checkout.aspx");
                        }
                        else
                        {
                            var receiptNo = Guid.NewGuid().ToString();
                            receiptNo = receiptNo.Substring(0, receiptNo.IndexOf('-')).ToUpper();

                            var pckage_id = int.Parse(Request["pckge"]);
                            var pckage = db.AdsPackages.Where(x => x.Increment == pckage_id).FirstOrDefault();
                            var guid = Guid.NewGuid().ToString();
                            var date_created = DateTime.Now;
                            var status = AdsStatus.Pending;
                            var usr_id = "";
                            var co_email = Session["user_account_email"].ToString();

                            var co_nw_isur = db.UserIndividuals.Where(x => x.Email == co_email).FirstOrDefault();
                            if (co_nw_isur != null)
                            {
                                usr_id = co_nw_isur.ID;
                            }
                            else
                            {
                                var co_nw_bsur = db.UserBusinesses.Where(x => x.Email == co_email).FirstOrDefault();
                                if (co_nw_bsur != null)
                                {
                                    usr_id = co_nw_bsur.ID;
                                }
                            }

                            //
                            // Add ads
                            db.Ads.Add(new Ad
                            {
                                ID = guid,
                                User_ID = usr_id,
                                AdsPackage_ID = pckage.ID,
                                ReceiptNo = receiptNo,
                                Status = (int)status
                            });
                            db.SaveChanges();

                            //
                            // Add Duration
                            db.AdsHistories.Add(new AdsHistory
                            {
                                ID = Guid.NewGuid().ToString(),
                                Ads_ID = guid,
                                TicketNo = receiptNo,
                                Task = (int)AdsStatus.Pending,
                                DateCreated = date_created,
                                DateExpired = date_created.AddMonths(pckage.Duration)
                            });
                            db.SaveChanges();

                            //
                            Response.Redirect("?p=viewinvoice&pckge=" + Request["pckge"] + "&invoice=" + receiptNo);
                        }
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "completeorder":
                    switch (Request["t"])
                    {
                        default:
                            var co_nw_email_txt = Request["txtEmail"];
                            var co_nw_phone_txt = Request["txtPhoneNo"];
                            var co_nw_cntry_txt = Request["countryCmb"];
                            var co_nw_state_txt = Request["stateCmb"];
                            var co_nw_city_txt = Request["cityCmb"];

                            var receiptNo = Guid.NewGuid().ToString();
                            receiptNo = receiptNo.Substring(0, receiptNo.IndexOf('-')).ToUpper();

                            var co_nw_isur = db.UserIndividuals.Where(x => x.Email == co_nw_email_txt || x.ContactNumber == co_nw_phone_txt).FirstOrDefault();
                            if (co_nw_isur != null)
                            {
                                var pckage_id = int.Parse(Request["pckge"]);
                                var pckage = db.AdsPackages.Where(x => x.Increment == pckage_id).FirstOrDefault();
                                var guid = Guid.NewGuid().ToString();
                                var usr_id = co_nw_isur.ID;
                                var date_created = DateTime.Now;
                                var status = AdsStatus.Pending;

                                db.Ads.Add(new Ad
                                {
                                    ID = guid,
                                    User_ID = usr_id,
                                    AdsPackage_ID = pckage.ID,
                                    ReceiptNo = receiptNo,
                                    Status = (int)status
                                });
                                db.SaveChanges();

                                //
                                // Add Duration
                                db.AdsHistories.Add(new AdsHistory
                                {
                                    ID = Guid.NewGuid().ToString(),
                                    Ads_ID = guid,
                                    DateCreated = date_created,
                                    DateExpired = date_created.AddMonths(pckage.Duration)
                                });

                                //
                                // Set Session Value

                                Session["user_account_active"] = true;
                                Session["user_account_email"] = co_nw_isur.Email.ToLower();
                                Session["usr_type"] = "individual";

                                //
                                Response.Redirect("?p=viewinvoice&pckge=" + Request["pckge"] + "&invoice=" + receiptNo);
                            }
                            else
                            {
                                var co_nw_bsur = db.UserBusinesses.Where(x => x.Email == co_nw_email_txt || x.ContactNumber == co_nw_phone_txt).FirstOrDefault();
                                if (co_nw_bsur != null)
                                {
                                    var pckage_id = int.Parse(Request["pckge"]);
                                    var pckage = db.AdsPackages.Where(x => x.Increment == pckage_id).FirstOrDefault();
                                    var guid = Guid.NewGuid().ToString();
                                    var usr_id = co_nw_bsur.ID;
                                    var date_created = DateTime.Now;
                                    var status = AdsStatus.Pending;

                                    db.Ads.Add(new Ad
                                    {
                                        ID = guid,
                                        User_ID = usr_id,
                                        AdsPackage_ID = pckage.ID,
                                        ReceiptNo = receiptNo,
                                        Status = (int)status
                                    });
                                    db.SaveChanges();

                                    //
                                    // Add Duration
                                    db.AdsHistories.Add(new AdsHistory
                                    {
                                        ID = Guid.NewGuid().ToString(),
                                        Ads_ID = guid,
                                        DateCreated = date_created,
                                        DateExpired = date_created.AddMonths(pckage.Duration)
                                    });

                                    //
                                    // Set Session Value

                                    Session["user_account_active"] = true;
                                    Session["user_account_email"] = co_nw_bsur.Email.ToLower();
                                    Session["usr_type"] = "individual";

                                    //
                                    Response.Redirect("?p=viewinvoice&pckge=" + Request["pckge"] + "&invoice=" + receiptNo);
                                }
                                else
                                {
                                    Session["co_email"] = co_nw_email_txt;
                                    Session["co_phone"] = co_nw_phone_txt;
                                    Session["co_cntry"] = co_nw_cntry_txt;
                                    Session["co_state"] = co_nw_state_txt;
                                    Session["co_city"] = co_nw_city_txt;
                                    Session["invoice"] = receiptNo;
                                    Session["package"] = Request["pckge"];
                                    Session["frm_ads_order"] = true;

                                    Response.Redirect("?p=signup");
                                }
                            }

                            break;
                        case "1":
                            var co_ex_email_txt = Request["txtEmail"];
                            var co_ex_paswrd_txt = Request["txtPwd"];

                            receiptNo = Guid.NewGuid().ToString();
                            receiptNo = receiptNo.Substring(0, receiptNo.IndexOf('-')).ToUpper();

                            var co_ex_isur = (from usr in db.UserIndividuals
                                              join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                              where usr.Email == co_ex_email_txt && auth.Password == co_ex_paswrd_txt
                                              select usr).FirstOrDefault();
                            if (co_ex_isur != null)
                            {
                                var pckage_id = int.Parse(Request["pckge"]);
                                var pckage = db.AdsPackages.Where(x => x.Increment == pckage_id).FirstOrDefault();
                                var guid = Guid.NewGuid().ToString();
                                var usr_id = co_ex_isur.ID;
                                var date_created = DateTime.Now;
                                var status = AdsStatus.Pending;

                                db.Ads.Add(new Ad
                                {
                                    ID = guid,
                                    User_ID = co_ex_isur.ID,
                                    AdsPackage_ID = pckage.ID,
                                    ReceiptNo = receiptNo,
                                    Status = (int)status
                                });
                                db.SaveChanges();

                                //
                                // Add Duration
                                db.AdsHistories.Add(new AdsHistory
                                {
                                    ID = Guid.NewGuid().ToString(),
                                    Ads_ID = guid,
                                    DateCreated = date_created,
                                    DateExpired = date_created.AddMonths(pckage.Duration)
                                });
                                db.SaveChanges();

                                //
                                // Set Session Value

                                Session["user_account_active"] = true;
                                Session["user_account_email"] = co_ex_isur.Email.ToLower();
                                Session["usr_type"] = "individual";

                                //
                                Response.Redirect("?p=viewinvoice&pckge=" + Request["pckge"] + "&invoice=" + receiptNo);
                            }
                            else
                            {

                                var co_ex_bsur = (from usr in db.UserBusinesses
                                                  join auth in db.UserAuthentications on usr.ID equals auth.User_ID
                                                  where usr.Email == co_ex_email_txt && auth.Password == co_ex_paswrd_txt
                                                  select usr).FirstOrDefault();

                                if (co_ex_bsur != null)
                                {
                                    var pckage_id = int.Parse(Request["pckge"]);
                                    var pckage = db.AdsPackages.Where(x => x.Increment == pckage_id).FirstOrDefault();
                                    var guid = Guid.NewGuid().ToString();
                                    var usr_id = co_ex_bsur.ID;
                                    var invoice_no = receiptNo;
                                    var date_created = DateTime.Now;
                                    var status = AdsStatus.Pending;

                                    db.Ads.Add(new Ad
                                    {
                                        ID = guid,
                                        User_ID = co_ex_bsur.ID,
                                        AdsPackage_ID = pckage.ID,
                                        ReceiptNo = receiptNo,
                                        Status = (int)status
                                    });
                                    db.SaveChanges();

                                    //
                                    // Add Duration
                                    db.AdsHistories.Add(new AdsHistory
                                    {
                                        ID = Guid.NewGuid().ToString(),
                                        Ads_ID = guid,
                                        DateCreated = date_created,
                                        DateExpired = date_created.AddMonths(pckage.Duration)
                                    });
                                    db.SaveChanges();

                                    //
                                    // Set Session Value

                                    Session["user_account_active"] = true;
                                    Session["user_account_email"] = co_ex_bsur.Email.ToLower();
                                    Session["usr_type"] = "individual";

                                    //
                                    Response.Redirect("?p=viewinvoice&pckge=" + Request["pckge"] + "&invoice=" + receiptNo);
                                }
                                else
                                {
                                    Response.Redirect("?p=" + Request["r"] + "&pckge=" + Request["pckge"] + "&sess=" + Request["sess"] + ((Request["t"] != null) ? "&t=" + Request["t"] : ""));
                                }
                            }
                            break;
                    }
                    break;
                case "viewinvoice":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/review.checkout.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "renewads":
                    var date_renwd = DateTime.Now;
                    Ad rnw_ads = Json.Decode<Ad>(Request["data"]);
                    var rnwd_ads = db.Ads.Where(x => x.ReceiptNo == rnw_ads.ReceiptNo).FirstOrDefault();
                    var ticketNo = Guid.NewGuid().ToString();
                    ticketNo = ticketNo.Substring(0, ticketNo.IndexOf('-')).ToUpper();

                    //
                    //
                    rnwd_ads.Status = (int)AdsStatus.Published;
                    db.Entry(rnwd_ads).State = System.Data.EntityState.Modified;
                    db.SaveChanges();

                    //
                    // Add Duration
                    db.AdsHistories.Add(new AdsHistory
                    {
                        ID = Guid.NewGuid().ToString(),
                        TicketNo = ticketNo,
                        Ads_ID = rnwd_ads.ID,
                        Task = (int)AdsStatus.Renewed,
                        DateCreated = date_renwd,
                        DateExpired = date_renwd.AddMonths(rnwd_ads.AdsPackage.Duration)
                    });
                    db.SaveChanges();

                    db.Configuration.ProxyCreationEnabled = false;
                    var rnewd_ads = Json.Encode(new { package = rnwd_ads.AdsPackage.Increment, invoice = ticketNo });

                    Response.Write(rnewd_ads);
                    Response.End();
                    break;
                case "dopostcomment":
                    var comment_txt = Request["comment-txt"];
                    var account_txt = Request["page-txt"];
                    t = Request["t"];
                    var s = Request["s"];
                    var u = Request["u"];

                    var page_user = "";
                    var comment_user = "";

                    var page_iuser = db.UserIndividuals.Where(x => x.Email == u).FirstOrDefault();
                    if (page_iuser != null)
                    {
                        page_user = page_iuser.ID;
                        //comment_user = comment_iuser.ID;
                    }
                    else
                    {
                        page_user = db.UserBusinesses.Where(x => x.Email == u).FirstOrDefault().ID;
                        //comment_user = db.UserBusinesses.Where(x => x.Email == account_txt).FirstOrDefault().ID;
                    }

                    //Response.Write(page_user + " :: " + u);

                    if (Session["user_account_active"] != null && ((bool)Session["user_account_active"] != false))
                    {
                        account_txt = Session["user_account_email"].ToString();
                        var comment_iuser = db.UserIndividuals.Where(x => x.Email == account_txt).FirstOrDefault();
                        if (comment_iuser != null)
                        {
                            comment_user = comment_iuser.ID;
                        }
                        else
                        {
                            comment_user = db.UserBusinesses.Where(x => x.Email == account_txt).FirstOrDefault().ID;
                        }

                        //Response.Write(page_user + " :: " + u + "<br/>");
                        //Response.Write(comment_user + " :: " + account_txt);

                        try
                        {
                            db.UserComments.Add(new UserComment
                            {
                                ID = Guid.NewGuid().ToString(),
                                User_ID = page_user,
                                Owner_ID = comment_user,
                                Comment = comment_txt,
                                DatetCommented = DateTime.Now
                            });
                            db.SaveChanges();
                            Response.Write(page_user + " - " + account_txt + " - " + comment_txt);
                        }
                        finally
                        {
                            Response.Redirect("?p=" + t + "&s=" + s + "&u=" + u);
                        }
                    }
                    else
                    {
                        Session["user_cmment_obj"] = new UserComment
                        {
                            User_ID = page_user,
                            Owner_ID = "",
                            Comment = comment_txt,
                        };
                        Session["utype"] = t;
                        Session["service"] = s;
                        Session["uemail"] = u;
                        Response.Redirect("?p=login");
                    }
                    break;
                case "getstates":
                    Country c_data = Json.Decode<Country>(HttpContext.Current.Request["data"]);
                    Response.ContentType = "application/json";
                    Response.Write(new LocationController().GetStatesByCountry(c_data));
                    Response.End();
                    break;
                case "getcities":
                    State s_data = Json.Decode<State>(HttpContext.Current.Request["data"]);
                    Response.ContentType = "application/json";
                    Response.Write(new LocationController().GetCitiesByState(s_data));
                    Response.End();
                    break;
                case "dorating":
                    var star_1 = Request["star1_txt"];
                    var star_2 = Request["star2_txt"];
                    var star_3 = Request["star3_txt"];
                    var star_4 = Request["star4_txt"];
                    var star_5 = Request["star5_txt"];
                    //
                    var fname_txt = Request["fname_txt"];
                    var lname_txt = Request["lname_txt"];
                    var email_txt = Request["email_txt"];
                    var owner_txt = Request["owner_txt"];
                    var usrid_txt = Request["usrid_txt"];
                    //

                    t = Request["t"].ToUpper();
                    if (t == UserType.Individual.ToString().ToUpper())
                    {
                        Response.Write("First Name: " + fname_txt + "<br/>");
                        Response.Write("Last Name: " + lname_txt + "<br/>");
                        Response.Write("Email Addr: " + email_txt + "<br/>");
                        Response.Write("Owner: " + owner_txt + "<br/>");
                        Response.Write("User: " + usrid_txt + "<br/>");

                        //
                        // Check if user has rated the above account before

                        var ratng = db.UserRatings.Where(x => x.Owner_ID == owner_txt && x.User_ID == usrid_txt).FirstOrDefault();
                        if (ratng != null)
                        {
                            ratng.Star1 = star_1;
                            ratng.Star2 = star_2;
                            ratng.Star3 = star_3;
                            ratng.Star4 = star_4;
                            ratng.Star5 = star_5;
                            db.Entry(ratng).State = System.Data.EntityState.Modified;
                            db.SaveChanges();
                        }
                        else
                        {
                            db.UserRatings.Add(new UserRating
                            {
                                ID = Guid.NewGuid().ToString(),
                                FirstName = fname_txt,
                                LastName = lname_txt,
                                Email = email_txt,
                                User_ID = usrid_txt,
                                Owner_ID = owner_txt,
                                Star1 = star_1,
                                Star2 = star_2,
                                Star3 = star_3,
                                Star4 = star_4,
                                Star5 = star_5
                            });
                            db.SaveChanges();
                        }
                        Response.Redirect("?p=individual&s=" + Request["s"] + "&u=" + Request["u"]);
                    }
                    else
                    {
                        var ratng = db.UserRatings.Where(x => x.Owner_ID == owner_txt && x.User_ID == usrid_txt).FirstOrDefault();
                        if (ratng != null)
                        {
                            ratng.Star1 = star_1;
                            ratng.Star2 = star_2;
                            ratng.Star3 = star_3;
                            ratng.Star4 = star_4;
                            ratng.Star5 = star_5;
                            db.Entry(ratng).State = System.Data.EntityState.Modified;
                            db.SaveChanges();
                        }
                        else
                        {
                            db.UserRatings.Add(new UserRating
                            {
                                ID = Guid.NewGuid().ToString(),
                                FirstName = fname_txt,
                                LastName = lname_txt,
                                Email = email_txt,
                                User_ID = usrid_txt,
                                Owner_ID = owner_txt,
                                Star1 = star_1,
                                Star2 = star_2,
                                Star3 = star_3,
                                Star4 = star_4,
                                Star5 = star_5,
                            });
                            db.SaveChanges();
                        }
                        Response.Redirect("?p=business&s=" + Request["s"] + "&u=" + Request["u"]);
                    }
                    break;
                case "getrating":
                    db.Configuration.ProxyCreationEnabled = false;
                    UserRating rdata = Json.Decode<UserRating>(HttpContext.Current.Request["data"]);
                    var rated = db.UserRatings.Where(x => x.Owner_ID == rdata.Owner_ID && x.User_ID == rdata.User_ID).FirstOrDefault();
                    if (rated != null)
                    {
                        var serializer = new JavaScriptSerializer();
                        var usr_rating = serializer.Serialize(rated);
                        //
                        Response.ContentType = "application/json";
                        Response.Write(usr_rating);
                        Response.End();
                    }
                    else
                    {
                        var serializer = new JavaScriptSerializer();
                        var usr_rating = serializer.Serialize(new UserRating());
                        //
                        Response.ContentType = "application/json";
                        Response.Write(usr_rating);
                        Response.End();
                    }
                    break;
                case "doeditprofile":
                    var sectn = Request["sectn"];
                    var mod = Request["mode"];
                    var txtUserID = Request["txtUsrID"];

                    if (sectn == "info")
                    {
                        var txtPFName = Request["txtFirstName"];
                        var txtPLName = Request["txtLastName"];
                        var cmbPSex = Request["cmbSex"];
                        var txtPEmail = Request["txtEmail"];
                        var txtPPhoneNo = Request["txtPhoneNo"];
                        var txtPAbout = Request["txtAboutUs"];
                        var cmbServ = Request["cmbServ"];
                        var txtUsrImg = Request["txtUsrImg"];

                        var iusr_prof = db.UserIndividuals.Find(txtUserID);
                        if (iusr_prof != null)
                        {
                            iusr_prof.FirstName = txtPFName;
                            iusr_prof.LastName = txtPLName;
                            iusr_prof.Sex = cmbPSex;
                            iusr_prof.ContactNumber = txtPPhoneNo;
                            iusr_prof.AboutMe = txtPAbout;
                            iusr_prof.ImageUrl = txtUsrImg;
                            iusr_prof.Service_ID = cmbServ;
                            //
                            db.Entry(iusr_prof).State = System.Data.EntityState.Modified;
                            db.SaveChanges();

                            Session.Remove("txtFirstName");
                            Session.Remove("txtLastName");
                            Session.Remove("cmbSex");
                            Session.Remove("txtPhoneNo");
                            Session.Remove("txtAboutUs");
                            Session.Remove("cmbServ");

                            Session["notifier"] = "Changes made successfully!";
                            Session.Remove("useraccount");
                            Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + iusr_prof.Email.ToLower());
                        }
                        else
                        {

                            var txtCompanyName = Request["txtCompanyName"];
                            var txtAboutCompany = Request["txtAboutCompany"];
                            var cmbCategory = Request["cmbCategory"];
                            var txtCompanyPhoneNo = Request["txtPhoneNo"];
                            var txtWebsite = Request["txtWebsite"];
                            var txtCompanyAvatrImg = Request["txtCompanyAvatrImg"];
                            var txtCompanyBgImg = Request["txtCompanyBgImg"];

                            var busr_prof = db.UserBusinesses.Find(txtUserID);
                            if (busr_prof != null)
                            {
                                busr_prof.BusinessName = txtCompanyName;
                                busr_prof.BusinessDescription = txtAboutCompany;
                                busr_prof.BusinessCategory_ID = cmbCategory;
                                busr_prof.ContactNumber = txtCompanyPhoneNo;
                                busr_prof.Website = txtWebsite;
                                busr_prof.ImageUrl = txtCompanyAvatrImg;
                                busr_prof.CoverImageUrl = txtCompanyBgImg;
                                //
                                db.Entry(busr_prof).State = System.Data.EntityState.Modified;
                                db.SaveChanges();

                                Session["notifier"] = "Changes made successfully!";
                                Session.Remove("useraccount");
                                Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + busr_prof.Email.ToLower());
                            }
                        }
                    }

                    if (sectn == "serv")
                    {
                        var txtPServ = Request["servCmb"];
                        var iusr_prof = db.UserIndividuals.Find(txtUserID);
                        if (iusr_prof != null)
                        {
                            iusr_prof.Service_ID = txtPServ;
                            //
                            db.Entry(iusr_prof).State = System.Data.EntityState.Modified;
                            db.SaveChanges();

                            Session["notifier"] = "Changes made successfully!";
                            Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + iusr_prof.Email.ToLower());
                        }
                    }

                    if (sectn == "accnt")
                    {
                        var txtPEmail = Request["txtEmail"];
                        var txtPPwd = Request["txtPwd"];
                        var txtPNPwd = Request["txtNPwd"];
                        var txtPRPwd = Request["txtRPwd"];

                        if (txtPPwd.Trim() == "")
                        {
                            Session["notifier"] = "Empty Password Field";
                            Session["error_descr"] = "Please enter your old password to continue";
                            Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + txtPEmail.ToLower());
                        }

                        if (txtPNPwd.Trim() == "")
                        {
                            Session["notifier"] = "Empty Password Field";
                            Session["error_descr"] = "Please enter your new password to continue";
                            Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + txtPEmail.ToLower());
                        }

                        if (txtPNPwd.Trim() != txtPRPwd.Trim())
                        {
                            Session["notifier"] = "Password Mismatch!";
                            Session["error_descr"] = "Please enter your new password to continue";
                            Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + txtPEmail.ToLower());
                        }

                        if (!Regex.IsMatch(txtPNPwd, @"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$"))
                        {
                            Session["notifier"] = "Invalid Password!";
                            Session["error_descr"] = "Your password must contain at least a digit, a lower case letter, an uppercase letter, and must not exceed 15 characters.";
                            Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + txtPEmail.ToLower());
                        }

                        var usr_accnt = db.UserAuthentications
                                           .Where(x => x.User_ID == txtUserID && x.Password == txtPPwd)
                                           .FirstOrDefault();

                        if (usr_accnt != null)
                        {
                            Session["notifier"] = "Password Update Successful!";
                            Session["error_descr"] = "Congratulations, you have successfully changed your old password to a new one.";
                            usr_accnt.Password = txtPNPwd;
                            db.Entry(usr_accnt).State = System.Data.EntityState.Modified;
                            db.SaveChanges();
                        }
                        else
                        {
                            Session["notifier"] = "Incorrect Password!";
                            Session["error_descr"] = "your password is incorrect, please type in the correct password to continue";
                        }
                        Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + txtPEmail.ToLower());
                    }

                    if (sectn == "locn")
                    {
                        var txtPCAddr = Request["txtCAddr"];
                        var txtPCity = Request["cmbCity"];
                        var cmbPState = Request["cmbState"];
                        var txtPCntry = Request["cmbCntry"];

                        var iusr_prof = db.UserIndividuals.Find(txtUserID);
                        if (iusr_prof != null)
                        {
                            iusr_prof.ContactAddress = txtPCAddr;
                            iusr_prof.City_ID = txtPCity;
                            iusr_prof.State_ID = cmbPState;
                            iusr_prof.Country_ID = txtPCntry;
                            //
                            db.Entry(iusr_prof).State = System.Data.EntityState.Modified;
                            db.SaveChanges();

                            Session["notifier"] = "Changes made successfully!";
                            Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + iusr_prof.Email.ToLower());
                        }
                        else
                        {
                            var busr_prof = db.UserBusinesses.Find(txtUserID);
                            if (busr_prof != null)
                            {
                                busr_prof.ContactAddress = txtPCAddr;
                                busr_prof.City_ID = txtPCity;
                                busr_prof.State_ID = cmbPState;
                                busr_prof.Country_ID = txtPCntry;
                                //
                                db.Entry(busr_prof).State = System.Data.EntityState.Modified;
                                db.SaveChanges();

                                Session["notifier"] = "Changes made successfully!";
                                Response.Redirect("?p=account&tb=3&mode=" + mod + "&u=" + busr_prof.Email.ToLower());
                            }
                        }
                    }

                    break;
                case "dormvwrkexpr":
                    int expr = int.Parse(Request["expr"]);
                    var result = (dynamic)null;
                    if ((string)Session["usr_type"] != "business")
                    {
                        result = db.UserWorkExperiences
                                       .Where(x => x.Increment == expr)
                                       .Join(db.UserIndividuals,
                                             exper => exper.User_ID,
                                             usr => usr.ID,
                                             (exper, usr) => new
                                             {
                                                 User = usr,
                                                 WorkExperience = exper
                                             }
                                       )
                                       .FirstOrDefault();
                    }
                    else
                    {
                        result = db.UserWorkExperiences
                                   .Where(x => x.Increment == expr)
                                   .Join(db.UserBusinesses,
                                        exper => exper.User_ID,
                                        usr => usr.ID,
                                        (exper, usr) => new
                                        {
                                            User = usr,
                                            WorkExperience = exper
                                        }
                                   )
                                   .FirstOrDefault();
                    }

                    if (result != null)
                    {
                        db.UserWorkExperiences.Remove(result.WorkExperience);
                        db.SaveChanges();
                    }

                    Session["notifier"] = "Successfully deleted";
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + result.User.Email.ToLower());
                    break;
                case "docrudexpr":
                    var tsk = Request["actn"];
                    var expr_title = Request["txtJobTitle"];
                    var expr_client = Request["txtJobClient"];
                    var expr_descr = Request["txtJobDescr"];
                    var expr_id = Request["txtJobID"];
                    var expr_job_img = Request["txtJobImg"];
                    var expr_usr_id = Request["txtUsrID"];

                    var email = "";

                    if (tsk == "add")
                    {
                        var usr = (dynamic)null;

                        if ((string)Session["usr_type"] != "business")
                        {
                            usr = db.UserIndividuals
                                    .Where(x => x.ID == expr_usr_id)
                                    .FirstOrDefault();
                        }
                        else
                        {
                            usr = db.UserBusinesses
                                    .Where(x => x.ID == expr_usr_id)
                                    .FirstOrDefault();
                        }

                        if (usr != null)
                        {
                            var new_expr_id = "";

                            if (expr_job_img.Length > 0)
                            {
                                new_expr_id = expr_job_img.Substring(0, expr_job_img.LastIndexOf('.'));
                            }
                            else
                            {
                                new_expr_id = Guid.NewGuid().ToString();
                            }
                            //
                            email = usr.Email;
                            //
                            db.UserWorkExperiences.Add(new UserWorkExperience
                            {
                                ID = new_expr_id,
                                Title = expr_title,
                                Client = expr_client,
                                Description = expr_descr,
                                ImageUrl = expr_job_img,
                                DateCompleted = DateTime.Now,
                                User_ID = expr_usr_id
                            });
                            db.SaveChanges();
                        }
                        Session["notifier"] = "Created successfully";
                    }
                    else
                    {
                        var w_expr = (dynamic)null;

                        if ((string)Session["usr_type"] != "business")
                        {
                            w_expr = db.UserWorkExperiences
                                           .Where(x => x.User_ID == expr_usr_id && x.ID == expr_id)
                                           .Join(db.UserIndividuals,
                                                 exper => exper.User_ID,
                                                 usr => usr.ID,
                                                 (exper, usr) => new
                                                 {
                                                     User = usr,
                                                     WorkExperience = exper
                                                 }
                                           )
                                           .FirstOrDefault();
                        }
                        else
                        {
                            w_expr = db.UserWorkExperiences
                                       .Where(x => x.User_ID == expr_usr_id && x.ID == expr_id)
                                       .Join(db.UserBusinesses,
                                            exper => exper.User_ID,
                                            usr => usr.ID,
                                            (exper, usr) => new
                                            {
                                                User = usr,
                                                WorkExperience = exper
                                            }
                                       )
                                       .FirstOrDefault();
                        }

                        if (w_expr != null)
                        {
                            email = w_expr.User.Email;
                            //
                            w_expr.WorkExperience.Title = expr_title;
                            w_expr.WorkExperience.Description = expr_descr;
                            w_expr.WorkExperience.Client = expr_client;
                            w_expr.WorkExperience.ImageUrl = expr_job_img;
                            w_expr.WorkExperience.DateCompleted = DateTime.Now;
                            db.Entry(w_expr.WorkExperience).State = System.Data.EntityState.Modified;
                            db.SaveChanges();
                        }
                        Session["notifier"] = "Changes made successfully";
                    }

                    Session.Remove("userwrkexp");
                    Session.Remove("txtJobTitle");
                    Session.Remove("txtJobClient");
                    Session.Remove("txtJobDescr");

                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + email.ToLower());
                    break;
                case "portfolioimage":
                    try
                    {
                        url = Request.QueryString["url"];
                        url = url.Substring(0, url.LastIndexOf('.'));
                        url = url_addr + "/image/portfolioimage/" + url;
                        wreq = (HttpWebRequest)WebRequest.Create(url);
                        wreq.ContentType = "image/jpg";
                        wreq.Method = "GET";
                        wres = (HttpWebResponse)wreq.GetResponse();
                        using (Stream stream = wres.GetResponseStream())
                        {
                            stream.CopyTo(Response.OutputStream);
                            Response.Flush();
                            Response.End();
                            stream.Close();
                        }
                        wres.Close();
                    }
                    catch (Exception)
                    {
                        Response.Write("File not found!");
                    }
                    break;
                case "doportfolioimageupld":
                    var p_file = Request.Files["upldFile"];
                    var txtJobTitle = Request["txtJobTitle"];
                    var txtJobClient = Request["txtJobClient"];
                    var txtJobDescr = Request["txtJobDescr"];

                    Session["txtJobTitle"] = txtJobTitle;
                    Session["txtJobClient"] = txtJobClient;
                    Session["txtJobDescr"] = txtJobDescr;

                    if ((p_file != null))
                    {
                        var fileContentType = p_file.ContentType;
                        var paramName = "file";
                        var fileName = p_file.FileName;
                        var id = DateTime.Now.Ticks.ToString();
                        var uploadUrl = url_addr + "/image/portfolioimage";

                        var fileMimeType = fileContentType.Substring(0, fileContentType.IndexOf('/'));
                        if ((p_file.ContentLength > 0) && (fileMimeType == "image"))
                        {
                            var usr_id = Request["txtUsrID"];
                            var job_id = Request["txtJobID"];

                            var nvc = new NameValueCollection();
                            nvc.Add("usr", usr_id);
                            nvc.Add("wrkdone", job_id);

                            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");

                            byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

                            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(uploadUrl);
                            wr.ContentType = "multipart/form-data; boundary=" + boundary;
                            wr.Method = "POST";
                            wr.KeepAlive = true;
                            wr.Credentials = System.Net.CredentialCache.DefaultCredentials;

                            using (Stream rs = wr.GetRequestStream())
                            {
                                string formdataTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
                                foreach (string key in nvc.Keys)
                                {
                                    rs.Write(boundarybytes, 0, boundarybytes.Length);
                                    string formitem = string.Format(formdataTemplate, key, nvc[key]);
                                    byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
                                    rs.Write(formitembytes, 0, formitembytes.Length);
                                }
                                rs.Write(boundarybytes, 0, boundarybytes.Length);

                                string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n";
                                string header = string.Format(headerTemplate, paramName, fileName, fileContentType);
                                byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);
                                rs.Write(headerbytes, 0, headerbytes.Length);

                                byte[] buffer = new byte[4096];
                                int bytesRead = 0;
                                while ((bytesRead = p_file.InputStream.Read(buffer, 0, buffer.Length)) != 0)
                                {
                                    rs.Write(buffer, 0, bytesRead);
                                }
                                p_file.InputStream.Close();

                                byte[] trailer = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
                                rs.Write(trailer, 0, trailer.Length);
                                rs.Close();

                                using (WebResponse wresp = wr.GetResponse())
                                {
                                    using (Stream stream2 = wresp.GetResponseStream())
                                    {
                                        StreamReader reader2 = new StreamReader(stream2);
                                        var response = reader2.ReadToEnd();

                                        UserWorkExperience userwrkexp = Json.Decode<UserWorkExperience>(response);
                                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                                        Session["userwrkexp"] = userwrkexp;
                                    }
                                }

                            }

                        }
                    }

                    //
                    var expr_key = ((Request["expr"] != null) && (Request["expr"] != "")) ? "&expr=" + Request["expr"] : "";

                    Session["notifier"] = "Uploaded successfully!";
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + Request["u"] + expr_key);
                    break;


                case "dormveduqua":
                    int qua = int.Parse(Request["qua"]);
                    var qua_result = db.UserEducationalQualifications
                                       .Where(x => x.Increment == qua)
                                       .Join(db.UserIndividuals,
                                             qual => qual.User_ID,
                                             usr => usr.ID,
                                             (qual, usr) => new
                                             {
                                                 User = usr,
                                                 Qualification = qual
                                             }
                                       )
                                       .FirstOrDefault();
                    if (qua_result != null)
                    {
                        db.UserEducationalQualifications.Remove(qua_result.Qualification);
                        db.SaveChanges();
                        Session["notifier"] = "Successfully deleted.";
                        Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + qua_result.User.Email.ToLower());
                    }
                    break;
                case "docrudqua":
                    tsk = Request["actn"];
                    var qua_schname = Request["txtSchName"];
                    var qua_awrd = Request["txtAwrdObtaind"];
                    var qua_yr = Request["cmbYrGrad"];
                    var qua_id = Request["txtQuaID"];
                    var qua_usr_id = Request["txtUsrID"];

                    email = "";

                    if (tsk == "add")
                    {
                        var usr = db.UserIndividuals
                                       .Where(x => x.ID == qua_usr_id)
                                       .FirstOrDefault();

                        if (usr != null)
                        {
                            email = usr.Email;
                            //
                            db.UserEducationalQualifications.Add(new UserEducationalQualification
                            {
                                ID = Guid.NewGuid().ToString(),
                                SchoolName = qua_schname,
                                YearGraduated = qua_yr,
                                AwardAcquired = qua_awrd,
                                User_ID = qua_usr_id
                            });
                            db.SaveChanges();
                        }
                        Session["notifier"] = "Created successfully";
                    }
                    else
                    {
                        var e_qua = db.UserEducationalQualifications
                                       .Where(x => x.User_ID == qua_usr_id && x.ID == qua_id)
                                       .Join(db.UserIndividuals,
                                             qual => qual.User_ID,
                                             usr => usr.ID,
                                             (qual, usr) => new
                                             {
                                                 User = usr,
                                                 Qualification = qual
                                             }
                                       )
                                       .FirstOrDefault();

                        if (e_qua != null)
                        {
                            email = e_qua.User.Email;
                            //
                            e_qua.Qualification.SchoolName = qua_schname;
                            e_qua.Qualification.AwardAcquired = qua_awrd;
                            e_qua.Qualification.YearGraduated = qua_yr;
                            db.Entry(e_qua.Qualification).State = System.Data.EntityState.Modified;
                            db.SaveChanges();
                        }
                        Session["notifier"] = "Changes made successfully";
                    }
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + email.ToLower());
                    break;


                case "dormvserv":
                    int serv = int.Parse(Request["serv"]);
                    var serv_result = db.UserSolutions
                                       .Where(x => x.Increment == serv)
                                       .Join(db.UserBusinesses,
                                             service => service.User_ID,
                                             usr => usr.ID,
                                             (service, usr) => new
                                             {
                                                 User = usr,
                                                 Service = service
                                             }
                                       )
                                       .FirstOrDefault();
                    if (serv_result != null)
                    {
                        db.UserSolutions.Remove(serv_result.Service);
                        db.SaveChanges();
                        Session["notifier"] = "Successfully deleted.";
                        Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + serv_result.User.Email.ToLower());
                    }
                    break;
                case "docrudserv":
                    tsk = Request["actn"];
                    var serv_title = Request["txtServTitle"];
                    var serv_id = Request["txtServID"];
                    var serv_usr_id = Request["txtUsrID"];

                    email = "";

                    if (tsk == "add")
                    {
                        var usr = db.UserBusinesses
                                       .Where(x => x.ID == serv_usr_id)
                                       .FirstOrDefault();

                        if (usr != null)
                        {
                            db.UserSolutions.Add(new UserSolution
                            {
                                ID = Guid.NewGuid().ToString(),
                                Title = serv_title,
                                User_ID = serv_usr_id
                            });
                            db.SaveChanges();
                        }
                        Session["notifier"] = "Created successfully";
                    }
                    else
                    {
                        var solu = db.UserSolutions
                                      .Where(x => x.User_ID == serv_usr_id && x.ID == serv_id)
                                      .Join(db.UserBusinesses,
                                             servi => servi.User_ID,
                                             usr => usr.ID,
                                             (servi, usr) => new
                                             {
                                                 User = usr,
                                                 Solution = servi
                                             }
                                       )
                                       .FirstOrDefault();

                        if (solu != null)
                        {
                            solu.Solution.Title = serv_title;
                            solu.Solution.User_ID = serv_usr_id;
                            db.Entry(solu.Solution).State = System.Data.EntityState.Modified;
                            db.SaveChanges();
                        }
                        Session["notifier"] = "Changes made successfully";
                    }
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + email.ToLower());
                    break;



                case "dopostjobmsg":
                    var msgTxt = Request["msg-txt"];
                    var pgeTxt = Request["page-txt"];
                    var rtypeCmb = Request["rtype-cmb"];

                    Session["msgTxt"] = msgTxt;
                    Session["pgeTxt"] = pgeTxt;
                    Session["rtypeCmb"] = rtypeCmb;

                    //
                    Response.Redirect("?p=account&tb=2&u=" + Request["u"] + "&m=opt" + "&t=" + rtypeCmb);
                    break;
                case "dosendjobreqtogrp":
                    var msg = Request["msg-txt"];
                    pgeTxt = Request["page-txt"];
                    rtypeCmb = Request["t"];
                    var loctn = Request["city-txt"];
                    var sendr = Request["sndr-txt"];
                    var rcpnt = (dynamic)null;

                    Session["msgTxt"] = msg;
                    Session["pgeTxt"] = pgeTxt;
                    Session["rtypeCmb"] = rtypeCmb;
                    Session["cityTxt"] = loctn;

                    if (rtypeCmb == "0")
                    {
                        var servCmb = int.Parse(Request["serv-cmb"]);
                        rcpnt = db.Services.Where(x => x.Increment == servCmb).FirstOrDefault();

                        var srvce_id = ((Service)rcpnt).ID;

                        var sndrLoc = "";
                        var isndr = db.UserIndividuals.Find(sendr);
                        if (isndr != null)
                        {
                            sndrLoc = isndr.Country_ID;
                        }
                        else
                        {
                            var bsndr = db.UserBusinesses.Find(sendr);
                            if (bsndr != null)
                            {
                                sndrLoc = bsndr.Country_ID;
                            }
                        }


                        //
                        // Save to database

                        db.UserJobBoxNotifications.Add(new UserJobBoxNotification
                        {
                            ID = Guid.NewGuid().ToString(),
                            Message = msg,
                            Recepient = srvce_id,
                            RecepientLocation = loctn,
                            Sender = sendr,
                            SenderLocation = sndrLoc,
                            DateSent = DateTime.Now,
                            IsGroupMessage = true
                        });

                        //
                        // Save item to database

                        db.SaveChanges();


                        var srvice_usrs = (from usr in db.UserIndividuals
                                           join srv in db.Services on usr.Service_ID equals srv.ID
                                           join city in db.Cities on usr.City_ID equals city.ID
                                           where srv.ID == srvce_id && usr.ID != sendr && usr.City_ID == loctn
                                           select usr).ToList();
                        if (srvice_usrs != null)
                        {
                            var no_arr = new List<string>();
                            foreach (var usr in srvice_usrs)
                            {
                                no_arr.Add(usr.ContactNumber);
                            }

                            var no_str = string.Join(",", no_arr);

                            //
                            // Send SMS

                            var jbox_msg = "You have 1 new job request. Please visit http://www.uvind.com for more info.";

                            OziomaApiImpl smsApi = new OziomaApiImpl();
                            smsApi.Message = jbox_msg;
                            smsApi.Sender = "Uvind";
                            smsApi.Recipient = no_str;
                            smsApi.Send();

                        }

                    }
                    else
                    {
                        try
                        {
                            var bizCategCmb = int.Parse(Request["bizcateg-cmb"]);

                            rcpnt = db.BusinessCategories.Where(x => x.Increment == bizCategCmb).FirstOrDefault();

                            var bizCateg_id = ((BusinessCategory)rcpnt).ID;

                            var sndrLoc = "";
                            var isndr = db.UserIndividuals.Find(sendr);
                            if (isndr != null)
                            {
                                sndrLoc = isndr.Country_ID;
                            }
                            else
                            {
                                var bsndr = db.UserBusinesses.Find(sendr);
                                if (bsndr != null)
                                {
                                    sndrLoc = bsndr.Country_ID;
                                }
                            }

                            //
                            // Add item to collection

                            db.UserJobBoxNotifications.Add(new UserJobBoxNotification
                            {
                                ID = Guid.NewGuid().ToString(),
                                Message = msg,
                                Recepient = bizCateg_id,
                                RecepientLocation = loctn,
                                Sender = sendr,
                                SenderLocation = sndrLoc,
                                DateSent = DateTime.Now,
                                IsGroupMessage = true
                            });

                            //
                            // Save item to database

                            db.SaveChanges();


                            var bzcateg_usrs = (from usr in db.UserBusinesses
                                                join categ in db.BusinessCategories on usr.BusinessCategory_ID equals categ.ID
                                                join city in db.Cities on usr.City_ID equals city.ID
                                                where categ.ID == bizCateg_id && usr.ID != sendr && usr.City_ID == loctn
                                                select usr).ToList();
                            if (bzcateg_usrs != null)
                            {
                                var no_arr = new List<string>();
                                foreach (var usr in bzcateg_usrs)
                                {
                                    no_arr.Add(usr.ContactNumber);
                                }

                                var no_str = string.Join(",", no_arr);

                                //
                                // Send SMS

                                var jbox_msg = "You have 1 new job request. Please visit http://www.uvind.com for more info.";

                                OziomaApiImpl smsApi = new OziomaApiImpl();
                                smsApi.Message = jbox_msg;
                                smsApi.Sender = "Uvind";
                                smsApi.Recipient = no_str;
                                smsApi.Send();

                            }
                        }
                        catch (Exception)
                        {
                        }
                    }
                    //
                    Session["state"] = "done";
                    Session["categ"] = Request["t"];
                    Session["rcpient"] = rcpnt;
                    Session["group-msg"] = "";

                    Response.Redirect("?p=account&tb=2&u=" + Request["u"] + "&m=opt&s=done&t=" + Request["t"]);
                    break;
                case "dosendjobreqtosng":

                    Session.Remove("state");
                    Session.Remove("categ");
                    Session.Remove("rcpient");
                    Session.Remove("group-msg");

                    var s_msg = Request["msg-txt"];
                    var s_sendr_id = Request["sndr-txt"];
                    var s_rcpnt_id = Request["rcpnt-txt"];
                    var s_loctn = Request["city-txt"];
                    var s_rtype = Request["t"];


                    var sndrLoc_sng = "";
                    var isndr_sng = db.UserIndividuals.Find(s_sendr_id);
                    if (isndr_sng != null)
                    {
                        sndrLoc_sng = isndr_sng.Country_ID;
                    }
                    else
                    {
                        var bsndr = db.UserBusinesses.Find(s_sendr_id);
                        if (bsndr != null)
                        {
                            sndrLoc_sng = bsndr.Country_ID;
                        }
                    }

                    //
                    // Add item to collection

                    db.UserJobBoxNotifications.Add(new UserJobBoxNotification
                    {
                        ID = Guid.NewGuid().ToString(),
                        Message = s_msg,
                        Recepient = s_rcpnt_id,
                        RecepientLocation = s_loctn,
                        Sender = s_sendr_id,
                        SenderLocation = sndrLoc_sng,
                        DateSent = DateTime.Now,
                        IsGroupMessage = false
                    });

                    //
                    // Save item to database

                    db.SaveChanges();

                    //
                    // Send SMS

                    var iusr_msg_recp = db.UserIndividuals.Where(x => x.ID == s_rcpnt_id).FirstOrDefault();
                    if (iusr_msg_recp != null)
                    {
                        OziomaApiImpl _jbox_msg_smsApi = new OziomaApiImpl();
                        _jbox_msg_smsApi.Message = "You have 1 new job request. Please visit http://www.uvind.com for more info.";
                        _jbox_msg_smsApi.Sender = "Uvind";
                        _jbox_msg_smsApi.Recipient = iusr_msg_recp.ContactNumber;
                        _jbox_msg_smsApi.Send();
                    }
                    else
                    {
                        var busr_msg_recp = db.UserBusinesses.Where(x => x.ID == s_rcpnt_id).FirstOrDefault();
                        if (busr_msg_recp != null)
                        {
                            OziomaApiImpl _jbox_msg_smsApi = new OziomaApiImpl();
                            _jbox_msg_smsApi.Message = "You have 1 new job request. Please visit http://www.uvind.com for more info.";
                            _jbox_msg_smsApi.Sender = "Uvind";
                            _jbox_msg_smsApi.Recipient = busr_msg_recp.ContactNumber;
                            _jbox_msg_smsApi.Send();
                        }
                    }


                    var s_rcpnt = (dynamic)null;

                    if (s_rtype == "0")
                    {
                        s_rcpnt = db.UserIndividuals.Where(x => x.ID == s_rcpnt_id).FirstOrDefault();
                    }
                    else
                    {
                        s_rcpnt = db.UserBusinesses.Where(x => x.ID == s_rcpnt_id).FirstOrDefault();
                    }

                    //
                    Session["state"] = "done";
                    Session["rcpient"] = s_rcpnt;

                    //
                    Response.Redirect("?p=account&tb=2&u=" + Request["u"] + "&m=opt&s=done&t=" + Request["t"]);
                    break;
                case "doremovejobposting":
                    var jb_usr_id = Request["usr_txt"].ToString();
                    var jb_grp_id = Request["grp_txt"].ToString();
                    var jb_notfcn_id = Request["notfcn_txt"].ToString();

                    notifCntr.DeleteNotification(new UserJobBoxNotificationStatu
                    {
                        User_ID = jb_usr_id,
                        Notification_ID = jb_notfcn_id,
                        Group_ID = jb_grp_id,
                    });

                    Response.Redirect("?p=account&tb=2&u=" + Request["u"]);
                    break;




                case "docrudcmpgn":
                    var cmpgn_tsk = Request["actn"];
                    var cmpgn_title = Request["txtCmpgnTitle"];
                    var cmpgn_descr = Request["txtCmpgnDescr"];
                    var cmpgn_url = Request["txtCmpgnURL"];
                    var cmpgn_id = Request["txtCmpgnID"];
                    var cmpgn_ads_id = Request["txtCmpgnAdsID"];
                    var cmpgn_usr_id = Request["txtUsrID"];

                    if (cmpgn_tsk == "add")
                    {
                        var ads_incr = int.Parse(Request["ads"]);
                        var ads = db.Ads.Where(x => x.Increment == ads_incr).FirstOrDefault();

                        if (ads != null)
                        {
                            cmpgn_ads_id = ads.ID;
                            db.AdsCampaigns.Add(new AdsCampaign
                            {
                                ID = cmpgn_id,
                                Title = cmpgn_title,
                                Description = cmpgn_descr,
                                URL = cmpgn_url,
                                DateCreated = DateTime.Now,
                                Ads_ID = cmpgn_ads_id
                            });
                            db.SaveChanges();


                            //
                            // Save uploaded banners

                            var bannrs = (List<AdsCampaignBanner>)Session["campgn_bnrs"];
                            if (bannrs != null)
                            {
                                foreach (var s_bnr in bannrs)
                                {
                                    var bnr_res = db.AdsCampaignBanners.Find(s_bnr.ID);
                                    if (bnr_res == null)
                                    {
                                        s_bnr.AdsCampaign_ID = cmpgn_id;
                                        db.AdsCampaignBanners.Add(s_bnr);
                                        db.SaveChanges();
                                    }
                                }
                            }
                        }
                        Session["notifier"] = "Created successfully";
                    }
                    else
                    {
                        var campgn = db.AdsCampaigns
                                       .Where(x => x.Ads_ID == cmpgn_ads_id && x.ID == cmpgn_id)
                                       .FirstOrDefault();

                        if (campgn != null)
                        {
                            campgn.Title = cmpgn_title;
                            campgn.Description = cmpgn_descr;
                            campgn.URL = cmpgn_url;
                            campgn.DateCreated = DateTime.Now;
                            db.Entry(campgn).State = System.Data.EntityState.Modified;
                            db.SaveChanges();

                            //
                            // Save uploaded banners

                            var bannrs = (List<AdsCampaignBanner>)Session["campgn_bnrs"];
                            if (bannrs != null)
                            {
                                foreach (var s_bnr in bannrs)
                                {
                                    var bnr_res = db.AdsCampaignBanners.Find(s_bnr.ID);
                                    if (bnr_res == null)
                                    {
                                        s_bnr.AdsCampaign_ID = campgn.ID;
                                        db.AdsCampaignBanners.Add(s_bnr);
                                        db.SaveChanges();
                                    }
                                }
                            }
                        }
                        Session["notifier"] = "Changes made successfully";
                    }
                    Session.Remove("campgn_bnrs");
                    Session.Remove("txtCmpgnTitle");
                    Session.Remove("txtCmpgnDescr");
                    Session.Remove("txtCmpgnURL");
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + Request["u"] + "&ads=" + Request["ads"] + "&brd=" + Request["brd"]);
                    break;
                case "dormvcmpgn":
                    int cmpgn = int.Parse(Request["cmpgn"]);
                    var cmpgn_result = db.AdsCampaigns
                                         .Where(x => x.Increment == cmpgn)
                                         .FirstOrDefault();
                    if (cmpgn_result != null)
                    {
                        //
                        // Remove campaign banners if any
                        var cmpgn_bnrs_result = db.AdsCampaignBanners
                                                  .Where(x => x.AdsCampaign_ID == cmpgn_result.ID)
                                                  .ToList();
                        if (cmpgn_bnrs_result != null)
                        {
                            foreach (var cmpgn_bnr in cmpgn_bnrs_result)
                            {
                                db.AdsCampaignBanners.Remove(cmpgn_bnr);
                                db.SaveChanges();
                            }
                        }

                        //
                        // Remove actual campaign
                        db.AdsCampaigns.Remove(cmpgn_result);
                        db.SaveChanges();

                        Session["notifier"] = "Successfully deleted";

                        //
                        // Re-route me
                        Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + Request["u"] + "&ads=" + Request["ads"] + "&brd=" + Request["brd"]);
                    }
                    break;
                case "adbanner":
                    try
                    {
                        url = Request.QueryString["url"];
                        url = url.Substring(0, url.LastIndexOf('.'));
                        url = url_addr + "/image/advertimage/" + url;
                        wreq = (HttpWebRequest)WebRequest.Create(url);
                        wreq.ContentType = "image/jpg";
                        wreq.Method = "GET";
                        wres = (HttpWebResponse)wreq.GetResponse();
                        using (Stream stream = wres.GetResponseStream())
                        {
                            stream.CopyTo(Response.OutputStream);
                            Response.Flush();
                            Response.End();
                            stream.Close();
                        }
                        wres.Close();
                    }
                    catch (Exception)
                    {
                        Response.Write("File not found!");
                    }
                    break;
                case "doadbannerupld":
                    var ad_file = Request.Files["upldFile"];

                    var txtCmpgnTitle = Request["txtCmpgnTitle"];
                    var txtCmpgnDescr = Request["txtCmpgnDescr"];
                    var txtCmpgnURL = Request["txtCmpgnURL"];
                    var ads_cmpgn_id = Request["txtCmpgnID"];
                    var ads_dimension = Enum.GetValues(typeof(AdsBannerDimension)).GetValue(int.Parse(Request["txtDimension"])).ToString();

                    Session["txtCmpgnTitle"] = txtCmpgnTitle;
                    Session["txtCmpgnDescr"] = txtCmpgnDescr;
                    Session["txtCmpgnURL"] = txtCmpgnURL;

                    var wdth_x = ads_dimension.IndexOf('_') + 1;
                    var hght_x = ads_dimension.IndexOf('x') + 1;
                    var wdth = ads_dimension.Substring(wdth_x, 3);
                    var hght = ads_dimension.Substring(hght_x, 3);

                    if ((ad_file != null))
                    {
                        var fileContentType = ad_file.ContentType;
                        var paramName = "file";
                        var fileName = ad_file.FileName;
                        var id = DateTime.Now.Ticks.ToString();
                        var uploadUrl = url_addr + "/image/advertimage";

                        var fileMimeType = fileContentType.Substring(0, fileContentType.IndexOf('/'));
                        if ((ad_file.ContentLength > 0) && (fileMimeType == "image"))
                        {


                            var nvc = new NameValueCollection();
                            nvc.Add("bnnr", Guid.NewGuid().ToString());
                            nvc.Add("width", wdth);
                            nvc.Add("height", hght);

                            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");

                            byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

                            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(uploadUrl);
                            wr.ContentType = "multipart/form-data; boundary=" + boundary;
                            wr.Method = "POST";
                            wr.KeepAlive = true;
                            wr.Credentials = System.Net.CredentialCache.DefaultCredentials;

                            using (Stream rs = wr.GetRequestStream())
                            {
                                string formdataTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
                                foreach (string key in nvc.Keys)
                                {
                                    rs.Write(boundarybytes, 0, boundarybytes.Length);
                                    string formitem = string.Format(formdataTemplate, key, nvc[key]);
                                    byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
                                    rs.Write(formitembytes, 0, formitembytes.Length);
                                }
                                rs.Write(boundarybytes, 0, boundarybytes.Length);

                                string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n";
                                string header = string.Format(headerTemplate, paramName, fileName, fileContentType);
                                byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);
                                rs.Write(headerbytes, 0, headerbytes.Length);

                                byte[] buffer = new byte[4096];
                                int bytesRead = 0;
                                while ((bytesRead = ad_file.InputStream.Read(buffer, 0, buffer.Length)) != 0)
                                {
                                    rs.Write(buffer, 0, bytesRead);
                                }
                                ad_file.InputStream.Close();

                                byte[] trailer = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
                                rs.Write(trailer, 0, trailer.Length);
                                rs.Close();

                                using (WebResponse wresp = wr.GetResponse())
                                {
                                    using (Stream stream2 = wresp.GetResponseStream())
                                    {
                                        StreamReader reader2 = new StreamReader(stream2);
                                        var response = reader2.ReadToEnd();

                                        Response.Write(response);

                                        AdsCampaignBanner cmpgn_bnr = Json.Decode<AdsCampaignBanner>(response);
                                        JavaScriptSerializer serializer = new JavaScriptSerializer();

                                        if (Session["campgn_bnrs"] == null)
                                        {
                                            List<AdsCampaignBanner> bnrs = new List<AdsCampaignBanner>();
                                            bnrs.Add(cmpgn_bnr);
                                            Session["campgn_bnrs"] = bnrs;
                                        }
                                        else
                                        {
                                            List<AdsCampaignBanner> bnrs = (List<AdsCampaignBanner>)Session["campgn_bnrs"];
                                            bnrs.Add(cmpgn_bnr);
                                            Session["campgn_bnrs"] = bnrs;
                                        }
                                    }
                                }

                            }

                        }
                    }

                    Session["notifier"] = "Uploaded successfully";

                    //
                    var url_cmpgn_id = ((Request["cmpgn"] != null) && (Request["cmpgn"] != "")) ? "&cmpgn=" + Request["cmpgn"] : "";
                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + Request["u"] + "&ads=" + Request["ads"] + "&brd=" + Request["brd"] + "&actn=" + Request["actn"] + url_cmpgn_id);
                    break;
                case "dormvadsbnr":
                    int bnr = int.Parse(Request["bnr"]);
                    int bnr_cmpgn = ((Request["cmpgn"] != null) && (Request["cmpgn"] != "")) ? int.Parse(Request["cmpgn"]) : 0;
                    var bnr_result = db.AdsCampaignBanners
                                         .Where(x => x.Increment == bnr)
                                         .FirstOrDefault();

                    var adsBannerUrl = url_addr + "/image/removeadvertimage";
                    var data = (dynamic)null;

                    if (bnr_result != null)
                    {
                        //
                        // Remove banner image

                        var postData = "bnnr=" + bnr_result.ImageUrl;
                        data = Encoding.ASCII.GetBytes(postData);

                        db.AdsCampaignBanners.Remove(bnr_result);
                        db.SaveChanges();
                    }
                    else
                    {
                        //
                        // Remove banner image

                        var bnr_url = Request["url"];

                        var postData = "bnnr=" + bnr_url;
                        data = Encoding.ASCII.GetBytes(postData);

                        if (Session["campgn_bnrs"] != null)
                        {
                            List<AdsCampaignBanner> bnrs = (List<AdsCampaignBanner>)Session["campgn_bnrs"];
                            AdsCampaignBanner selctd_bnr = null;
                            foreach (var s_bnr in (List<AdsCampaignBanner>)Session["campgn_bnrs"])
                            {
                                if (s_bnr.ImageUrl == bnr_url)
                                {
                                    selctd_bnr = s_bnr;
                                }
                            }
                            bnrs.Remove(selctd_bnr);
                        }
                    }

                    HttpWebRequest ads_wr = (HttpWebRequest)WebRequest.Create(adsBannerUrl);
                    ads_wr.ContentType = "application/x-www-form-urlencoded";
                    ads_wr.Method = "POST";
                    ads_wr.KeepAlive = true;
                    ads_wr.Credentials = System.Net.CredentialCache.DefaultCredentials;

                    using (Stream rs = ads_wr.GetRequestStream())
                    {
                        rs.Write(data, 0, data.Length);
                        rs.Close();

                        using (WebResponse wresp = ads_wr.GetResponse())
                        {
                            using (Stream strm = wresp.GetResponseStream())
                            {
                                StreamReader readr = new StreamReader(strm);
                                var respns = readr.ReadToEnd();

                                AdsCampaignBanner cmpgn_bnr = Json.Decode<AdsCampaignBanner>(respns);
                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                            }
                        }
                    }

                    Session["notifier"] = "Successfully deleted";

                    Response.Redirect("?p=account&tb=3&mode=" + Request["mode"] + "&u=" + Request["u"] + "&ads=" + Request["ads"] + "&brd=" + Request["brd"] + "&actn=" + Request["actn"] + "&cmpgn=" + Request["cmpgn"]);
                    break;
                case "dochangeloctn":
                    var cntry_cmb = Request["cmbCntry"];
                    var state_cmb = Request["cmbState"];
                    var city_cmb = Request["cmbCity"];

                    var loc = (from cty in db.Cities
                               join stt in db.States on cty.State_ID equals stt.ID
                               join cny in db.Countries on stt.Country_ID equals cny.ID
                               where cty.ID == city_cmb && stt.ID == state_cmb && cny.ID == cntry_cmb
                               select new
                               {
                                   city = cty,
                                   state = stt,
                                   country = cny
                               }).FirstOrDefault();

                    Session["current_loc"] = loc;

                    Response.Redirect("?p=" + Request["r"] + "&tb=" + Request["tb"] + "&u=" + Request["u"] + "&m=" + Request["m"] + "&t=" + Request["t"] + "&c=" + Request["c"]);
                    break;
                case "donewslettersignup":
                    //
                    // Save subscription to database

                    db.NewsletterSubscribers.Add(new NewsletterSubscriber
                    {
                        ID = Guid.NewGuid().ToString(),
                        Email = Request["txtEmailAddr"],
                        DateSubscribed = DateTime.Now
                    });
                    db.SaveChanges();

                    //
                    // Redirect to successful page

                    Response.Redirect("?p=subscribesuccessful");
                    break;
                case "subscribesuccessful":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/newsletter.subscribe.successful.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "docontactus":
                    var your_fname_txt = Request["full-name-txt"];
                    var your_email_txt = Request["email-add-txt"];
                    var subject_txt = Request["subject-txt"];
                    var message_txt = Request["message-txt"];

                    db.Contacts.Add(new Contact
                    {
                        ID = Guid.NewGuid().ToString(),
                        Name = your_fname_txt,
                        Email = your_email_txt,
                        Subject = subject_txt,
                        Message = message_txt,
                        DateSent = DateTime.Now,
                        Seen = false,
                        Read = false
                    });
                    db.SaveChanges();

                    //
                    // Redirect to successful page

                    Response.Redirect("?p=contactusuccessful");
                    break;
                case "contactusuccessful":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/contactus.successful.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;
                case "error":
                    if ((Request.Cookies["page"] != null) && (bool.Parse(Request.Cookies["page"]["isDefault"]) != false))
                    {
                        Server.Execute("Views/error.aspx");
                    }
                    else
                    {
                        Server.Execute("Views/locator.aspx", true);
                    }
                    break;

                case "geo":
                    WebClient webClient = new WebClient();
                    webClient.UseDefaultCredentials = true;
                    Stream geoip_strm = webClient.OpenRead("http://ip-api.com/xml/41.190.3.114");
                    var sReader = new StreamReader(geoip_strm);
                    var content = sReader.ReadToEnd();
                    Response.Write(content + " - " + Context.Request.ServerVariables["REMOTE_ADDR"]);
                    break;

                case "sms":
                    OziomaApiImpl _smsApi = new OziomaApiImpl();
                    _smsApi.Message = "Hello Campilax!";
                    _smsApi.Sender = "Uvind";
                    _smsApi.Recipient = "09080064082";
                    _smsApi.Send();
                    Response.Write("Successful!");
                    break;

                case "on":
                    if (Request["password"] != null)
                    {
                        var new_license_key = Guid.NewGuid().ToString().ToUpper();
                        var base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(Request["password"]));
                        var license = LicenseCypherController.Encrypt(new_license_key, base64);

                        Configuration generate_myWebConfig = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");
                        generate_myWebConfig.AppSettings.Settings.Remove("public_key");
                        generate_myWebConfig.Save();
                        //
                        generate_myWebConfig.AppSettings.Settings.Add("public_key", license);
                        generate_myWebConfig.Save();

                        File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + @"\key.lic", license);

                        Server.Execute("Views/page404.activate.success.aspx", true);
                    }
                    else
                    {
                        Server.Execute("Views/page404.choosepassword.aspx", true);
                    }
                    break;
                case "off":
                    if (Request["password"] != null)
                    {
                        var dact_license_key = Guid.NewGuid().ToString().ToUpper();
                        var dact_base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(Request["password"]));
                        var dact_license = LicenseCypherController.Encrypt(dact_license_key, dact_base64);

                        Configuration dact_myWebConfig = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");
                        dact_myWebConfig.AppSettings.Settings.Remove("public_key");
                        dact_myWebConfig.Save();
                        //
                        dact_myWebConfig.AppSettings.Settings.Add("public_key", dact_license);
                        dact_myWebConfig.Save();

                        Server.Execute("Views/page404.deactivate.success.aspx", true);
                    }
                    else
                    {
                        Server.Execute("Views/page404.choosepassword.aspx", true);
                    }
                    break;
                case "clearnotifier":
                    Session.Remove("notifier");
                    Session.Remove("login_error");
                    Session.Remove("signup_error");
                    // Session.RemoveAll();
                    break;
            }
        }
    }
}