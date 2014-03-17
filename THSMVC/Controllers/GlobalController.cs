using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace THSMVC.Controllers
{
    public class GlobalController : AsyncController
    {
        //
        // GET: /Global/

        public void testGlobalAsync(string Name)
        {
            System.Threading.Thread.Sleep(100000);
            
        }
        public ActionResult testGlobalCompleted()
        {
            return Json(new { success = true, message = "Settings saved successfully." });
        }


    }
}
