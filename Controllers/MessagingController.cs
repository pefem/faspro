using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.Helpers;
using System.Web.Script.Serialization;
using System.Net;
using System.Net.Mail;
using System.IO;

using FindAService_WebForm.Models;
using System.Net.Http;
using System.Collections.Specialized;

namespace FindAService_WebForm.Controllers
{
    public static class MessagingController
    {
        public static void SendSMS(ShortMessage msg)
        {
            var api_url = "http://ozioma.chibex.net/api/sms_handler.php";
            var user_name = "uvine";
            var user_password = "sunday123";

            //var postData = "username=" + HttpUtility.UrlPathEncode(user_name) + "&password=" + HttpUtility.UrlPathEncode(user_password) + "&sender=" + HttpUtility.UrlPathEncode(msg.Sender) + "&message=" + HttpUtility.UrlPathEncode(msg.Message) + "&recipient=" + HttpUtility.UrlPathEncode(msg.PhoneNumber) + "&remoteOp=" + HttpUtility.UrlPathEncode("snd");
            // var postData = "username=" + user_name + "&password=" + user_password + "&sender=" + msg.Sender + "&message=" + msg.Message + "&recipient=" + msg.PhoneNumber + "&remoteOp=snd";



            var nvc = new NameValueCollection();
            nvc.Add("username", HttpUtility.UrlPathEncode(user_name));
            nvc.Add("password", HttpUtility.UrlPathEncode(user_password));
            nvc.Add("sender", HttpUtility.UrlPathEncode(msg.Sender));
            nvc.Add("recipient", HttpUtility.UrlPathEncode(msg.PhoneNumber));
            nvc.Add("message", HttpUtility.UrlPathEncode(msg.Message));
            nvc.Add("remoteOp", "snd");
            
            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(api_url);
            wr.ContentType = "application/x-www-form-urlencoded";
            wr.Method = "POST";
            wr.KeepAlive = true;
            wr.Credentials = System.Net.CredentialCache.DefaultCredentials;

            using (Stream rs = wr.GetRequestStream())
            {
                //foreach (string key in nvc.Keys)
                //{
                //    string formitem = string.Format(formdataTemplate, key, nvc[key]);
                //    byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
                //    rs.Write(formitembytes, 0, formitembytes.Length);
                //}

                using (WebResponse wresp = wr.GetResponse())
                {
                    using (Stream stream2 = wresp.GetResponseStream())
                    {
                        StreamReader reader2 = new StreamReader(stream2);
                        var response = reader2.ReadToEnd();

                    }
                }

            }














            //HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(api_url);
            //webRequest.Method = "POST";
            //webRequest.ContentType = "application/x-www-form-urlencoded";
            //webRequest.ContentLength = postData.Length;


            //// POST the data
            //using (StreamWriter rw = new StreamWriter(webRequest.GetRequestStream()))
            //{
            //    rw.Write(postData);
            //    rw.Close();
            //}

            //// Talk to sms gateway
            //HttpWebResponse webResponse = (HttpWebResponse)webRequest.GetResponse();
            //using (StreamReader readr = new StreamReader(webResponse.GetResponseStream()))
            //{
            //    // Get Response Data
            //    var rd = readr.ReadToEnd();
            //    readr.Close();
            //}
        }

        public static void SendEmail(EmailMessage msg)
        {

        }
    }
}
