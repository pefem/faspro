using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using FindAService_WebForm.Models;
using FindAService_WebForm.Controllers;

namespace FindAService_WebForm
{
    public partial class MainPage : System.Web.UI.Page
    {
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        ddlFeaturedUsers.DataSource = new IndividualUserHelper().getFeaturedUsers1();
        //        ddlFeaturedUsers.DataBind();

        //        ddlFeaturedBusiness.DataSource = new BusinessUserHelper().getFeaturedBusinessUsers();
        //        ddlFeaturedBusiness.DataBind();
        //    }
        //    catch (Exception ex)
        //    { }
        //}

        //protected void btnCS_Click(object sender, EventArgs e)
        //{
        //    if (txtCity.Text == "")
        //    { }
        //    else
        //    {
        //        Session["city"] = txtCity.Text;
        //        Response.Redirect("~/CSearchResults.aspx");
        //    }
        //}

        //protected void btnIS_Click(object sender, EventArgs e)
        //{
        //    if (txtIS.Text == "" || txtWhere.Text == "")
        //    {

        //    }
        //    else
        //    {
        //        Session["service"] = txtIS.Text;
        //        Session["city"] = txtWhere.Text;
        //        Response.Redirect("~/ISearchResults.aspx");
        //    }
        //}

        //protected void ddlFeaturedBusiness_ItemCommand(object source, DataListCommandEventArgs e)
        //{
        //    string email = e.CommandArgument.ToString();
        //    string cmd = e.CommandName;

        //    if (cmd.Equals("View"))
        //    {
        //        Session["email"] = email;
        //        Response.Redirect("~/coporate.aspx");
        //    }
        //}

        //protected void ddlFeaturedUsers_ItemCommand(object source, DataListCommandEventArgs e)
        //{
        //    string email = e.CommandArgument.ToString();
        //    string cmd = e.CommandName;

        //    if (cmd.Equals("View"))
        //    {
        //        Session["email"] = email;
        //        Response.Redirect("~/artisan.aspx");
        //    }
        //}
    }
}