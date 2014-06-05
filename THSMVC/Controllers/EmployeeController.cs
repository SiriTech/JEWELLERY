using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Views.Shared;

namespace THSMVC.Controllers
{
    public class EmployeeController : Controller
    {
        [LogsRequest]
        public ActionResult EmployeeMaster(string Id, string MenuId)
        {
            return View();
        }
    }
}