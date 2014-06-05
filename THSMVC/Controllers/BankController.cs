using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Views.Shared;

namespace THSMVC.Controllers
{
    public class BankController : Controller
    {
        [LogsRequest]
        public ActionResult BankDetails(string Id, string MenuId)
        {
            return View();
        }
    }
}