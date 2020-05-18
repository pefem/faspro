using System;
using System.Collections.Generic;
using System.IO;
//using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using FindAService_WebForm.Models;
using FindAService_WebForm.Controllers;

namespace FindAService_WebForm
{
    public partial class IProjectPhotos : System.Web.UI.Page
    {
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    //try
        //    //{
        //    //    //Display profile Image
        //    //    ddlIprofileImage.DataSource = new IndividualUserHelper().getUserImage(Session["email"].ToString());
        //    //    ddlIprofileImage.DataBind();

        //    //    LoadProjectPhotos();
        //    //}
        //    //catch (Exception ex)
        //    //{ }

        //}

        //private void LoadProjectPhotos()
        //{
        //    //try
        //    //{
        //    //    ddlIProjectPhotos.DataSource = new IndividualUserHelper().getUserProjectImages(Session["email"].ToString());
        //    //    ddlIProjectPhotos.DataBind();
        //    //}
        //    //catch (Exception ex)
        //    //{ }
        //}

        //protected void btnAddPhoto_Click(object sender, EventArgs e)
        //{
        //    //try
        //    //{
        //    //    if (fupImage.FileName != "")
        //    //    {
        //    //        string extension = Path.GetExtension(fupImage.PostedFile.FileName);
        //    //        if (((extension == ".JPG" || extension == ".jpg") || ((extension == ".GIF" || extension == ".gif") || ((extension == ".JPEG" || extension == ".jpeg")) || (extension == ".PNG" || extension == ".png"))))
        //    //        {
        //    //            new IndividualUserHelper().AddUserProjectPhotos(Session["email"].ToString(), fupImage.FileName);
        //    //            LoadProjectPhotos();
        //    //            String filePath = "~/IProjectPhotos/" + fupImage.FileName;
        //    //            fupImage.SaveAs(MapPath(filePath));
        //    //            string script2 = "<script>alert('Project photo added successfully')</script>";
        //    //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script2);
        //    //        }
        //    //        else
        //    //        {
        //    //            string script = "<script>alert('Invalid image upload! Please try again')</script>";
        //    //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
        //    //            return;
        //    //        }
        //    //    }
        //    //}
        //    //catch (Exception ex)
        //    //{ }
        //}

        //protected void ddlIProjectPhotos_DeleteCommand(object source, DataListCommandEventArgs e)
        //{
        //    //Get the Identity Primary DataKey value when user click delete button 
        //    //int id = Convert.ToInt32(ddlIProjectPhotos.DataKeys[e.Item.ItemIndex]);
        //    //new IndividualUserHelper().DeleteUserProjectImage(id);
        //    //string script = "<script>alert('image deleted successfuly')</script>";
        //    //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Added", script);
        //    //LoadProjectPhotos();
        //}

        ////This method deletes image from folder. This will be called after deleting imageurl from db
        //public void DeleteIProjectPhotoFromFolder(string fileName)
        //{
        //    //System.IO.File.Delete(Request.PhysicalApplicationPath + "IProjectPhotos/" + fileName);
        //}

        //protected void lnkDelete_Command(object sender, CommandEventArgs e)
        //{
        //    //Calling the CommandArgument of the delete button to get the imageurl and assign it to the below method
        //    //string imageUrl = e.CommandArgument.ToString();
        //    //DeleteIProjectPhotoFromFolder(imageUrl);
        //}
    }
}