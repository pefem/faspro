using System;
using System.Collections.Generic;
//using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using FindAService_WebForm.Models;
using FindAService_WebForm.Controllers;

namespace FindAService_WebForm
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        //string uEmail;
        //string uPassword;
        //int userType;
        //protected void Page_Load(object sender, EventArgs e)
        //{

        //}

        //protected void btnSubmit_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        var getLoginUser = new UserAuthenticationHelper().Login(txtEmail.Text, txtPassword.Text);
        //        if (getLoginUser != null)
        //        {
        //            uEmail = getLoginUser.Email.ToString();
        //            uPassword = getLoginUser.Password.ToString();
        //            //userType = getLoginUser.UserType;

        //            if (userType == 1 && uEmail == txtEmail.Text && uPassword == txtPassword.Text)
        //            {
        //                Session["email"] = uEmail.ToString();
        //                Response.Redirect("~/IProfile.aspx");
        //            }
        //            else if (userType == 2 && uEmail == txtEmail.Text && uPassword == txtPassword.Text)
        //            {
        //                Session["email"] = uEmail.ToString();
        //                Response.Redirect("~/CProfile.aspx");
        //            }
        //            else
        //            {
        //                string script = "<script>alert('Invalid Login credential!')</script>";
        //                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
        //            }
        //        }
        //        else
        //        {
        //            string script = "<script>alert('Invalid Login credential!')</script>";
        //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
        //        }
        //    }
        //    catch (Exception ex)
        //    { }
        //}
        //public void GetLogin(string email, string password)
        //{
        //    var getLoginUser = new UserAuthenticationHelper().Login(email, password);
        //    uEmail = getLoginUser.Email.ToString();
        //    uPassword = getLoginUser.Password.ToString();
        //    //userType = getLoginUser.UserType;
        //}

        //protected void btnSenPassword_Click(object sender, EventArgs e)
        //{
        //    if (txtREmail.Text == "")
        //    {
        //        string script = "<script>alert('Please enter your email address!')</script>";
        //        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
        //    }
        //}
    }
}