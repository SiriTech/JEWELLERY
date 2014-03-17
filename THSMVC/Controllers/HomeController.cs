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


namespace THSMVC.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult Index()
        {
            return View();
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
