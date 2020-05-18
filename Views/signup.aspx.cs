using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using FindAService_WebForm.Models;
using FindAService_WebForm.Controllers;

namespace FindAService_WebForm
{
    public partial class Signup : System.Web.UI.Page
    {
//        protected void Page_Load(object sender, EventArgs e)
//        {

//        }

//        protected void bntSubmit1_Click(object sender, EventArgs e)
//        {
////            //Custom validation begins here

////            string password, confirmPassword, firstName, lastName, email, phoneNo, service, gender;
////            password = txtPassword.Text;
////            confirmPassword = txtConfirmPassword.Text;
////            firstName = txtFirstName.Text;
////            lastName = txtLastName.Text;
////            email = txtEmail.Text;
////            phoneNo = txtIndividualPhone.Text;
////            service = ddlService.SelectedItem.Value;
////            gender = ddlGender.SelectedItem.Value;


////            //validating email address using regular expression pattern. You will need to import using System.Text.RegularExpressions.

////            string MatchEmailPattern =
////            @"^(([\w-]+\.)+[\w-]+|([a-zA-Z]{1}|[\w-]{2,}))@"
////            + @"((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.([0-1]?
////				[0-9]{1,2}|25[0-5]|2[0-4][0-9])\."
////            + @"([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.([0-1]?
////			    [0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|"
////            + @"([a-zA-Z0-9]+[\w-]+\.)+[a-zA-Z]{1}[a-zA-Z0-9-]{1,23})$";

////            //Checking validation condition

////            if (password == "")
////            {
////                string script = "<script>alert('Password field is required!.')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }
////            if (confirmPassword == "")
////            {
////                string script = "<script>alert('Confirm Password field is required!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }

////            if (password != confirmPassword)
////            {
////                string script = "<script>alert('Password confirmation mismatch. Please ensure that confirm password is the same with the password field!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }
////            if (firstName == "")
////            {
////                string script = "<script>alert('First name field is required!!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }

////            if (lastName == "")
////            {
////                string script = "<script>alert('Last name field is required!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }

////            if (gender == "0")
////            {
////                string script = "<script>alert('Please select your sex!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }
////            if (email == "")
////            {
////                string script = "<script>alert('Email address field is required!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }

////            //Validating email address regular expression using the above pattern

////            if (!Regex.IsMatch(txtEmail.Text, MatchEmailPattern))
////            {
////                string script = "<script>alert('Invalid amail address! Please enter a valid email address!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }


////            if (phoneNo == "")
////            {
////                string script = "<script>alert('phone number field is required!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }

////            if (service == "0")
////            {
////                string script = "<script>alert('Please select your service!')</script>";
////                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                return;
////            }


////            try
////            {
////                // Submiting Individual user's information to the database

////                if (txtCaptcha.Text == this.Session["CaptchaImageText"].ToString())
////                {
////                    if (chkTerms.Checked == true)
////                    {

////                        Guid UserId = Guid.NewGuid();
////                        new IndividualUserHelper().addUsers(new UserIndividual());
////                        new UserAuthenticationHelper().AddAuthentication(UserId, txtEmail.Text, password, 1);

////                        //Send sms and inform findaservice developers of new registration

////                        OziomaApiImpl smsApi = new OziomaApiImpl();
////                        smsApi.Message = "New user registered on findaservice.com.ng at " + DateTime.Now.ToShortTimeString() + " on " + DateTime.Now.ToLongDateString() + " Email :  " + txtEmail.Text + " Phone Number : " + txtIndividualPhone.Text + "Name : " + txtFirstName.Text + " " + txtLastName.Text;
////                        smsApi.Sender = "FAS Alert";
////                        smsApi.Recipient = "2349095271910, 2348075153258, 2348077634258";
////                        smsApi.Send();


////                        //Send email to the user about his or her registration on findaservice.com.ng

////                        MailMessage mm = new MailMessage("findaservice.ng@gmail.com", txtEmail.Text);

////                        mm.Subject = "Account Registration Confirmation";
////                        mm.Body = "Dear " + txtFirstName.Text + " " + txtLastName.Text + ", Welcome to findaservice.ng. Your account will be activated shortly thank you ";
////                        mm.IsBodyHtml = false;
////                        SmtpClient smtp = new SmtpClient();
////                        smtp.Host = "smtp.gmail.com";
////                        smtp.EnableSsl = true;
////                        NetworkCredential NetworkCred = new NetworkCredential("findaservice.ng@gmail.com", "july2015");
////                        smtp.UseDefaultCredentials = true;
////                        smtp.Credentials = NetworkCred;
////                        smtp.Port = 587;
////                        smtp.Send(mm);

////                        Response.Redirect("~/RegistrationConfirmation.aspx");
////                    }
////                    else
////                    {
////                        string script = "<script>alert('To continue, you must agree to terms and condition!')</script>";
////                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                    }

////                }
////                else
////                {
////                    string script = "<script>alert('Invalid captcha!')</script>";
////                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
////                }

////            }
////            catch (Exception ex)
////            {

////            }
//        }
    }
}