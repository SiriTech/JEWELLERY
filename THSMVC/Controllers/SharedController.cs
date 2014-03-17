using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Models;
using THSMVC.App_Code;
using THSMVC.Views.Shared;
using THSMVC.Services.Logging.Log4Net;
using System.Web.Routing;
using System.IO;

namespace THSMVC.Controllers
{
    [HandleError]
    public class SharedController : Controller
    {

        Log4NetLogger logger = new Log4NetLogger();
        public IFormsAuthenticationService FormsService { get; set; }
        public IMembershipService MembershipService { get; set; }
        private static readonly IEncryptString _encrypter = new ConfigurationBasedStringEncrypter();
        protected override void Initialize(RequestContext requestContext)
        {
            if (FormsService == null) { FormsService = new FormsAuthenticationService(); }
            if (MembershipService == null) { MembershipService = new AccountMembershipService(); }

            base.Initialize(requestContext);
        }
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (Session["InstanceId"] == null)
            {
                if (Session["UserId"] == null)
                {
                    if (filterContext.ActionDescriptor.ActionName != "TimeoutExpired" && filterContext.ActionDescriptor.ActionName != "SessionExpire")
                    {
                        filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary {
                            { "Controller", "Shared" },
                            { "Action", "TimeoutExpired" }
                    });
                    }
                }

            }
            base.OnActionExecuting(filterContext);
        }
        [LogsRequest]
        public ActionResult TimeoutExpired()
        {
            return View();
        }
        [LogsRequest]
        public ActionResult SessionExpire()
        {
            Session["UserMode"] = null;
            Session["UserID"] = null;
            Session["MenuId"] = null;
            Session["InstanceId"] = null;
            FormsService.SignOut();
            return View();
        }
        [LogsRequest]
        public ActionResult Empty(string Id, string MenuId)
        {
            MainMenuModel model = new MainMenuModel();
            model.Menu = Id;
            model.MenuId = MenuId;
            return View(model);
        }
        [LogsRequest]
        public ActionResult UnAuthorized()
        {
            return View();
        }
        [LogsRequest]
        public ActionResult EmptyContent()
        {
            return View();
        }
        [LogsRequest]
        public ActionResult ChangePwd(string Id,string MenuId)
        {
            ChangePwdModel model = new ChangePwdModel();
           
           
            return View(model);
        }
        [LogsRequest]
        [HttpPost]
        public ActionResult ChangePassword(string OldPwd, string NewPwd)
        {
            try
            {
                if (MembershipService.ChangePassword(User.Identity.Name, OldPwd, NewPwd))
                {
                    return Json(new { success = true, message = "Password changed successfully." });
                }
                else
                {
                    return Json(new { success = false, message = "The current password is incorrect or the new password is invalid." });
                }
            }
            catch (Exception ex)
            {
                logger.Error("ChangePassword", ex);
                return Json(new { success = false, message = "Sorry, Please try again later." });
            }
        }
        
        public ActionResult MainMenu()
        {
            using (MenuLogic logicLayer = new MenuLogic())
            {
                string InstanceId = "";
                if (Session["InstanceId"] == null)
                    InstanceId = "";
                else
                    InstanceId = Session["InstanceId"].ToString();
                var context = logicLayer.GetMenus(InstanceId).ToList();
               
                return PartialView("MainMenu", context);
            }
        }
        
        public ActionResult LeftMenu(string MenuId)
        {
            using (MenuLogic logicLayer = new MenuLogic())
            {
                string InstanceId = "";
                if (Session["InstanceId"] == null)
                    InstanceId = "";
                else
                    InstanceId = Session["InstanceId"].ToString();
                var context = logicLayer.GetLeftMenu(InstanceId,MenuId).ToList();

                return PartialView("LeftMenu", context);
            }
        }
        public ActionResult JsonLeftMenu(string MenuId)
        {
            using (MenuLogic logicLayer = new MenuLogic())
            {
                string InstanceId = "";
                if (Session["InstanceId"] == null)
                    InstanceId = "";
                else
                    InstanceId = Session["InstanceId"].ToString();
                var context = logicLayer.GetLeftMenu(InstanceId, MenuId).ToList();

                return Json(PartialView("LeftMenu", context));
            }
        }
        public ActionResult JsonView(string MenuId) 
        {
            using (MenuLogic logicLayer = new MenuLogic())
            {
                string InstanceId = "";
                if (Session["InstanceId"] == null)
                    InstanceId = "";
                else
                    InstanceId = Session["InstanceId"].ToString();
                var context = logicLayer.GetFirstMenuByMenuId(InstanceId, MenuId).ToList();
                if (context.Count > 0)
                {
                    var first = context.First();
                    if (first.flag == null)
                    {
                        if (first.Action != null && first.Controller != null)
                        {
                            return RedirectToAction(first.Action.ToString(), first.Controller.ToString(), new { Id = first.MenuName.ToString(), MenuId = first.MenuId.ToString() });
                        }
                        else
                        {
                            return RedirectToAction("EmptyContent", "Shared");
                        }
                    }
                    else if (first.flag == false)
                    {
                        return RedirectToAction("UnAuthorized", "Shared");
                    }
                }
                return RedirectToAction("UnAuthorized", "Shared");
               
            }
        }
        public ActionResult JsonViewByActionAndController(string Action,string Controller) 
        {
            return RedirectToAction(Action, Controller);
        }
        public ActionResult JsonViewByActionAndControllerForEdit(string Action, string Controller, string Id)
        {
            return RedirectToAction(Action, Controller, new { id=Id });
        }
        public ActionResult JsonViewByActionAndControllerForEditMultipleParams(string Action, string Controller, string Id, string Id1)
        {
            return RedirectToAction(Action, Controller, new { id = Id,id1=Id1 }); 
        }
        public ActionResult JsonViewByActionAndControllerForEditMultipleParamsWithMenuId(string Action, string Controller, string Id, string Id1,string MenuId)
        {
            return RedirectToAction(Action, Controller, new { id = Id, id1 = Id1, Menuid=MenuId });
        }
        public ActionResult JsonViewByActionAndControllerForEditWithMenuId(string Action, string Controller, string Id, string MenuId)
        {
            return RedirectToAction(Action, Controller, new { id = Id,Menuid=MenuId });
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult ErrorLog(ErrorClass obj)
        {
            string name = Server.MapPath("~/Logs/Exceptions/Error_" + DateTime.Now.ToString().Replace("/","_").Replace(" ","_").Replace(":","_") + ".html");
            //System.IO.File.Create(name);
            FileInfo info = new FileInfo(name);
            if (!info.Exists)
            {
                using (StreamWriter writer = info.CreateText())
                {
                    writer.WriteLine("<html>");
                    writer.WriteLine(obj.ErrorHead);
                    writer.WriteLine(obj.ErrorBody);
                    writer.WriteLine(obj.ErrorBody1);
                    writer.WriteLine(obj.ErrorScript);
                    writer.WriteLine("</html>");

                }
            }
            return Json(new { success = true, message = "Error Logged" });

        }
        
    }
    public class ErrorClass
    {
        public string ErrorHead { get; set; }
        public string ErrorBody { get; set; }
        public string ErrorBody1 { get; set; }
        public string ErrorScript { get; set; }
    }
}