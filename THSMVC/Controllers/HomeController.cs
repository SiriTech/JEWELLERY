using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Models;
using System.Web.Routing;
using THSMVC.Views.Shared;
using THSMVC.Services.Logging.Log4Net;
using System.Linq.Dynamic;
using THSMVC.Models.Grid;
using THSMVC.Models.Helpers;
using THSMVC.App_Code;
using System.Net;
using System.IO;
using System.Text;


namespace THSMVC.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult Index()
        {
            DataStoreEntities dse = new DataStoreEntities();
            string ApplicationURL = Request.Url.AbsoluteUri;
            Instance objInstance = dse.Instances.Where(x => ApplicationURL.Contains(x.Domain)).FirstOrDefault();
            Session["InstanceId"] = objInstance.Id;
            GoldRatesManual objRates = dse.GoldRatesManuals.Where(x => x.InstanceId == objInstance.Id).FirstOrDefault();
            GoldRateModel model = new GoldRateModel();
            model.IsConnected = HasConnection();
            if (objRates != null)
            {
                DateTime dt = objRates.CreatedDate;
                if (dt.Date == DateTime.Now.Date)
                {
                    model.SelectedCity = objRates.City;
                    model.GoldWt = objRates.GoldWeight;
                    model.GoldPrice = objRates.GoldPrice;
                    model.SilverWt = objRates.SilverWeight;
                    model.SilverPrice = objRates.SilverPrice;
                }
            }
            return View(model);
        }
        public static bool HasConnection()
        {
            // CHECK IF SYSTEM HAS INTERNET CONNECTION
            try
            {
                System.Net.IPHostEntry i = System.Net.Dns.GetHostEntry("www.indiagoldrate.com");
                return true;
            }
            catch
            {
                return false;
            }
        }
        [LogsRequest]
        public ActionResult GetGoldRate(string Url)
        {
            try
            {
                string goldUrl = Url.Substring(0, Url.IndexOf("@"));
                string GoldRate = GetRates(goldUrl);
                string silverUrl = Url.Substring(Url.IndexOf("@")+1);
                string SilverRate = GetRates(silverUrl);
                return Json(new { success = true, GoldWt = GoldRate.Split('$')[0].ToString(), GoldRate = GoldRate.Split('$')[1].ToString().Trim(),SilverWt=SilverRate.Split('$')[0], SilverRate = SilverRate.Split('$')[1].ToString().Trim() });
            }
            catch (Exception) { return Json(new { success = false }); }
            
        }
        [LogsRequest]
        public ActionResult UpdateGoldRate(GoldRateModel obj)
        {
            int InstanceId = Convert.ToInt32(Session["InstanceId"]);
            DataStoreEntities dse = new DataStoreEntities();
            GoldRatesManual objRates = dse.GoldRatesManuals.Where(x => x.InstanceId == InstanceId).FirstOrDefault();
            if (objRates != null)
            {
                objRates.City = obj.SelectedCity;
                objRates.GoldWeight = obj.GoldWt;
                objRates.GoldPrice = obj.GoldPrice;
                objRates.SilverWeight = obj.SilverWt;
                objRates.SilverPrice = obj.SilverPrice;
                dse.SaveChanges();
            }
            else
            {
                GoldRatesManual Obj = new GoldRatesManual();
                Obj.City = obj.SelectedCity;
                Obj.GoldWeight = obj.GoldWt;
                Obj.GoldPrice = obj.GoldPrice;
                Obj.SilverWeight = obj.SilverWt;
                Obj.SilverPrice = obj.SilverPrice;
                dse.GoldRatesManuals.AddObject(Obj);
                dse.SaveChanges();
            }
            return Json(new { success = true });
        }
        private string GetRates(string Url)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url);
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            if (response.StatusCode == HttpStatusCode.OK)
            {
                Stream receiveStream = response.GetResponseStream();
                StreamReader readStream = null;
                if (response.CharacterSet == null)
                    readStream = new StreamReader(receiveStream);
                else
                    readStream = new StreamReader(receiveStream,
                                            Encoding.GetEncoding(response.CharacterSet));
                string data = readStream.ReadToEnd();
                response.Close();
                readStream.Close();
                string temp = string.Empty;
                temp = data.Substring(data.LastIndexOf("10g"), 30);
                temp = temp.Replace("<TD>", "$");
                temp = temp.Replace("</TD>", "");
                temp = temp.Replace("\t", "");
                temp = temp.Replace("\n", "");
                temp = temp.Replace("Rs.", "");
                return temp;
            }
            return "";
        }
        [LogsRequest]
        public ActionResult About()
        {
            return View();
        }
        [LogsRequest]
        public ActionResult ContactUS()
        {
            return View();
        }

        [LogsRequest]
        [HttpPost]
        public ActionResult ContactUS(string Name, string Email, string Phone, string Query)
        {
            if (EmailHelper.SendTemplateMail("dontreply@edubook.com", "kollisreekanth@gmail.com", "EDU BOOK", Url.Action("SubmitQueryEmail", "Admin", new { Name = Name, Email = Email, Phone = Phone, Query = Query }, "http")))
            {
                return Json(new { success = true, message = "Query submitted Successfully." });
            }
            else
                return Json(new { success = false, message = "Sorry! Please try again later." });
        }
        [LogsRequest]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult KeepAlive()
        {
            return new ContentResult { Content = "OK", ContentType = "text/plain" };
        }
    }
}
