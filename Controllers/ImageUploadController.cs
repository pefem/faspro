using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.Helpers;
using System.Web.Script.Serialization;
using System.Net;
using System.Net.Http;
using System.Net.Configuration;
using System.IO;

namespace FindAService_WebForm.Controllers
{
    public class ImageUploadController
    {
        public string CreateFormDataBoundary()
        {
            return "------------------------------" + DateTime.Now.Ticks.ToString("x");
        }

        public void Upload(string url, HttpFileCollection files)
        {

        }
    }
}
