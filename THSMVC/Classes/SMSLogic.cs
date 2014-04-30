using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Models;
using System.Net;
using System.IO;

namespace THSMVC.Classes
{
    public class SMSLogic
    {
        public bool SendPSMS(string message, string numbers)
        {
            try
            {
                int InstanceId = Convert.ToInt32(HttpContext.Current.Session["InstanceId"]);
                using (DataStoreEntities entities = new DataStoreEntities())
                {
                    var context = (from a in entities.SMSApis where a.InstanceId == InstanceId select a);
                    var first = context.First();
                    string apiURL = first.APIURL;
                    if (numbers.Trim().Contains(','))
                    {
                        string[] strArray = new string[numbers.Trim().Split(',').Count()];
                        strArray = numbers.Trim().Split(',');
                        foreach (string strNumber in strArray)
                        {
                            apiURL = apiURL.Replace("[SENDERID]", "TEST SMS").Replace("[MOBILE]", strNumber).Replace("[MSGTXT]", message.Trim()).Replace("[STATE]", "4");
                            WebRequest request = HttpWebRequest.Create(apiURL);
                            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                            Stream s = (Stream)response.GetResponseStream();
                            StreamReader readStream = new StreamReader(s);
                            string dataString = readStream.ReadToEnd();
                            response.Close();
                            s.Close();
                            readStream.Close();
                            using (DataStoreEntities dse = new DataStoreEntities())
                            {
                                int GroupId = 0;
                                var maxValue = dse.SMSLogs.Max(x => x.GroupId);
                                if (maxValue != null)
                                {
                                    var contextSL = (from sl in dse.SMSLogs where sl.GroupId == maxValue select sl);
                                    GroupId = Convert.ToInt32(contextSL.First().GroupId) + 1;
                                }
                                SMSLog smslog = new SMSLog();
                                smslog.InstanceId = InstanceId;
                                smslog.Category = "Promotional";
                                smslog.GroupId = GroupId;
                                smslog.Message = message.Trim();
                                smslog.Numbers = strNumber;
                                smslog.Response = dataString;
                                smslog.CreatedBy = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
                                smslog.CreatedDate = DateTime.Now;
                                dse.AddToSMSLogs(smslog);
                                dse.SaveChanges();
                            }
                        }

                    }
                    else
                    {
                        apiURL = apiURL.Replace("[SENDERID]", "TEST SMS").Replace("[MOBILE]", numbers.Trim()).Replace("[MSGTXT]", message.Trim()).Replace("[STATE]", "4");
                        WebRequest request = HttpWebRequest.Create(apiURL);
                        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                        Stream s = (Stream)response.GetResponseStream();
                        StreamReader readStream = new StreamReader(s);
                        string dataString = readStream.ReadToEnd();
                        response.Close();
                        s.Close();
                        readStream.Close();
                        using (DataStoreEntities dse = new DataStoreEntities())
                        {
                            int GroupId = 0;
                            var maxValue = dse.SMSLogs.Max(x => x.GroupId);
                            if (maxValue != null)
                            {
                                var contextSL = (from sl in dse.SMSLogs where sl.GroupId == maxValue select sl);
                                GroupId = Convert.ToInt32(contextSL.First().GroupId) + 1;
                            }
                            SMSLog smslog = new SMSLog();
                            smslog.InstanceId = InstanceId;
                            smslog.Category = "Promotional";
                            smslog.GroupId = GroupId;
                            smslog.Message = message.Trim();
                            smslog.Numbers = numbers.Trim();
                            smslog.Response = dataString;
                            smslog.CreatedBy = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
                            smslog.CreatedDate = DateTime.Now;
                            dse.AddToSMSLogs(smslog);
                            dse.SaveChanges();
                        }
                    }

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}