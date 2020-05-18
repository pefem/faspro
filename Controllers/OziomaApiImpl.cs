using System;
using System.Net;
using System.IO;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Chibex.Ozioma.DotNet.API
{
   public class OziomaApiImpl
    {
        private string userName = "uvine"; //set your user name here 
        private string password = "sunday123"; //set your password here
        private float balance = 0.0F;
        private string message = "";
        private string sender = "";
        private string recipient = "";
        private string messageId  = "";
        private string statusMessage = "";
        private string statusCode = "";
        private string scheduleDate = ""; //YYYY-MM-DD HH:MM format
        private float totalCharged = 0.0F;
        private int totalSent = 0;
        private int totalFailed = 0;
        private string failedNos = "";
	    private int channelId = 3;

        private string remoteOp = "";

        private string apiUrl ="";

        public string UserName { get; set; }
        public string Password { get; set; }

        public float Balance { get; set; }

        public string Message { get; set; }

        public string Sender { get; set; }

        public string Recipient { get; set; }

        public string MessageId { get; set; }

        public string StatusMessage { get; set; }

        public string StatusCode { get; set; }

        public string ScheduleDate { get; set; }

        public float TotalCharged { get; set; }

        public float TotalFailed { get; set; }

        public string FailedNos { get; set; }

        public string ChannelId { get; set; }

        public string ApiUrl { get; set; }

        public string RemoteOp { get; set; }

        public OziomaApiImpl()
        {
            this.ApiUrl = "http://ozioma.chibex.net/api/sms_handler.php";
            this.UserName = "uvine";
            this.Password = "sunday123";
        }

        private string PrepareSmsParams()
        {
            return "username=" + EncodeFieldData(UserName)
                        + "&password=" + EncodeFieldData(Password)
                        + "&sender=" + EncodeFieldData(Sender)
                        + "&message=" + EncodeFieldData(Message)
                        + "&recipient=" + EncodeFieldData(Recipient)
                        + "&remoteOp=" + EncodeFieldData(RemoteOp);
        }

        public void CheckBalance()
        {
            RemoteOp = "bal";
            string fieldParams = "username=" + EncodeFieldData(UserName)
                        + "&password=" + EncodeFieldData(Password)
                        + "&balance=" + EncodeFieldData("true")
                        + "&remoteOp=" + EncodeFieldData(RemoteOp);

            //send sms and retrieve response
            string response = DoRemotePost(fieldParams);

            //process response
            ParseResponse(response);
        }

        public void Send()
        {
            RemoteOp = "snd";
            //encode each parameter value and present array
            string dataParams = PrepareSmsParams();

            //send sms and retrieve response
            string response = DoRemotePost(dataParams);

            //process response
            ParseResponse(response);
        }

        public void Schedule()
        {
            RemoteOp = "sdl";
            //encode each parameter value and present array
            string dataParams = PrepareSmsParams();

            //add schedule variable to the request
            dataParams += "&schedule=" + EncodeFieldData(scheduleDate);

            //send sms and retrieve response
            string response = DoRemotePost(dataParams);

            //process response
            ParseResponse(response);
        }

        private void ParseResponse(string response)
        {
            //convert response from json to instance variables
            try
            {
                JObject jOb = JObject.Parse(response);

                if (jOb.Count > 0)
                {
                    //get status code and status message from response json and set local variable
                    StatusCode = (string)jOb["statusCode"];
                    StatusMessage = (string)jOb["statusMessage"];

                    if (StatusCode.Equals("000010") || StatusCode.Equals("000020"))
                        return;

                    //parameters were complete and login was successful 

                    //is user checking account balance	
                    if (RemoteOp.Equals("bal"))
                    {
                        Balance = (float)jOb["balance"];
                    }
                    else if (RemoteOp.Equals("snd")) //test for send operation
                    {
                        if (StatusCode.Equals("000040"))//sent successful
                        {
                            this.TotalCharged = (float)jOb["charged"];
                            this.TotalFailed = (float)jOb["failed"];
                            this.FailedNos = (string)jOb["failedNos"];
                            this.MessageId = (string)jOb["messageId"];
                        }
                    }
                    else if (RemoteOp.Equals("msg")) //fetch message by id
                    {
                        if (StatusCode.Equals("000100"))//is message id correct
                        {
                            this.TotalCharged = (float)jOb["charged"];
                            this.TotalFailed = (float)jOb["failed"];
                            this.FailedNos = (string)jOb["failedNos"];
                            this.MessageId = (string)jOb["messageId"];
                            this.Message = (string)jOb["message"];
                            this.Recipient = (string)jOb["recipient"];
                            this.Sender = (string)jOb["sender"];
                        }
                    }
                }
                else
                {
                    StatusCode = "000060";
                    StatusMessage = "Server Error";
                }
            }
            catch (JsonReaderException jre) { 
                Console.WriteLine(jre.Message); 
            }
            catch (JsonException je) { Console.WriteLine(je.Message); }
        }

        public void FetchMessage(int id)
        {
            RemoteOp = "msg";
            string fieldParams = "username=" + EncodeFieldData(UserName)
                        + "&password=" + EncodeFieldData(Password)
                        + "&messageId=" + EncodeFieldData(id+"")
                        + "&op=" + EncodeFieldData(RemoteOp);

            //retrieve message by id
            string response = DoRemotePost(fieldParams);

            //process response
            ParseResponse(response);
        }

        public void ResendFailedNos()
        {
            //set failed numbers as recipients
            Recipient = FailedNos;

            //send back the message
            Send();
        }

        private string DoRemotePost(string postData)
        {
            string responseData = string.Empty;

            try
            {
                // create the POST request
                HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(ApiUrl);
                webRequest.Method = "POST";
                webRequest.ContentType = "application/x-www-form-urlencoded";
                webRequest.ContentLength = postData.Length;
                // POST the data
                using (StreamWriter requestWriter2 = new StreamWriter(webRequest.GetRequestStream()))
                {
                    requestWriter2.Write(postData);
                    requestWriter2.Close();
                }

                //  This actually does the request and gets the response back
                HttpWebResponse resp = (HttpWebResponse)webRequest.GetResponse();
                
                using (StreamReader responseReader = new StreamReader(resp.GetResponseStream()))
                {
                    // dumps the HTML from the response into a string variable
                    responseData = responseReader.ReadToEnd();
                    responseReader.Close();
                }
            }
            catch (WebException we)
            {
                Console.WriteLine(we.Message);
            }
            catch (UriFormatException ue)
            {
                Console.WriteLine(ue.Message);
            }
            catch (ArgumentNullException ae)
            {
                Console.WriteLine(ae.Message);
            }

            return responseData;
        }

        private string EncodeFieldData(string fieldData)
        {
            return HttpUtility.UrlPathEncode(fieldData);
        }
    }
}