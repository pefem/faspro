using System;
using System.Collections.Generic;
//using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FindAService_WebForm
{
    public partial class business : System.Web.UI.Page
    {
        //double getLongitude;
        //double getLatitude;
        //string email;
        //string category;
        //string city;

        protected void Page_Load(object sender, EventArgs e)
        {
            //try
            //{
            //    var getBusinessUser = fasBusinessUsers.getBusinessUsersByEmail(Session["email"].ToString());
            //    lblName.Text = getBusinessUser.BusinessName.ToString();
            //    lblAboutCompany.Text = getBusinessUser.BuisnessDescription.ToString();
            //    lblWebsite.Text = getBusinessUser.WebsiteAddress.ToString();
            //    lblPhone.Text = getBusinessUser.ContactNumber.ToString();
            //    lblEmail.Text = getBusinessUser.Email.ToString();
            //    lblClient.Text = getBusinessUser.Client.ToString();
            //    lblService.Text = getBusinessUser.Service.ToString();
            //    lblBCity.Text = getBusinessUser.City.ToString();
            //    lblBCity2.Text = getBusinessUser.City.ToString();

            //    email = getBusinessUser.Email.ToString();
            //    category = getBusinessUser.BusinessCategory.ToString();
            //    city = getBusinessUser.City.ToString();

            //    var getBusinessMap = fasBusinessUsers.getUserlatitudeAndlongitudeByCity(getBusinessUser.City.ToString());
            //    getLatitude = (double)getBusinessMap.Latitude;
            //    getLongitude = (double)getBusinessMap.Longitude;

            //    txtLati.Value = getLatitude.ToString();
            //    txtLong.Value = getLongitude.ToString();
            
            //    ddlRelatedBusiness.DataSource = fasBusinessUsers.getRelatedBusinessCategory(getBusinessUser.BusinessCategory.ToString());
            //    ddlRelatedBusiness.DataBind();

            //    ddlILogoImage.DataSource = fasBusinessUsers.getBusinessLogoByEmail(getBusinessUser.Email.ToString());
            //    ddlILogoImage.DataBind();

            //    ddlCPortfolio.DataSource = fasBusinessUsers.getBusinessUserPortFolioImagesByEmail(getBusinessUser.Email.ToString());
            //    ddlCPortfolio.DataBind();

            //    ddlOtherBusiness.DataSource = fasBusinessUsers.getBusinessUsersByLocationWithContents(getBusinessUser.City.ToString());
            //    ddlOtherBusiness.DataBind();
            //}
            //catch (Exception ex)
            //{
            //    throw ex;
            //}
        }

        protected void ddlRelatedBusiness_ItemCommand(object source, DataListCommandEventArgs e)
        {
            string email = e.CommandArgument.ToString();
            string cmd = e.CommandName;


            if (cmd.Equals("View"))
            {
                Session["email"] = email;
                Response.Redirect("~/coporate.aspx");
            }
        }

        protected void ddlOtherBusiness_ItemCommand(object source, DataListCommandEventArgs e)
        {
            string email = e.CommandArgument.ToString();
            string cmd = e.CommandName;


            if (cmd.Equals("View"))
            {
                Session["email"] = email;
                Response.Redirect("~/coporate.aspx");
            }
        }
    }
}