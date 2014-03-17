using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using THSMVC.Models;
using THSMVC.Views.Shared;
using THSMVC.App_Code;

namespace THSMVC.Controllers
{

    [HandleError]
    public class AccountController : Controller
    {

        public IFormsAuthenticationService FormsService { get; set; }
        public IMembershipService MembershipService { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            if (FormsService == null) { FormsService = new FormsAuthenticationService(); }
            if (MembershipService == null) { MembershipService = new AccountMembershipService(); }

            base.Initialize(requestContext);
        }
        
        // **************************************
        // URL: /Account/LogOn
        // **************************************
        [LogsRequest]
        public ActionResult LogOn()
        {
            Session["UserMode"] = null;
            Session["UserID"] = null;
            Session["MenuId"] = null;
            Session["InstanceId"] = null;
            FormsService.SignOut();
            return View();
        }

        [HttpPost]
        [LogsRequest]
        public ActionResult LogOn(LogOnModel model, string returnUrl)
        {
            if (ModelState.IsValid)
            {
                if (MembershipService.ValidateUser(model.UserName, model.Password))
                {
                    UserCreateStatus createStatus;
                    using (SecurityProvider securityProvider = new SecurityProvider())
                        createStatus = securityProvider.UpdateLastLoginDate(model.UserName);
                    if (createStatus == UserCreateStatus.Success)
                    {
                        if (!String.IsNullOrEmpty(returnUrl))
                        {
                            return Redirect(returnUrl);
                        }
                        else
                        {
                            if (Session["ChangePwd"] != null)
                            {
                                FormsService.SignIn(model.UserName, model.RememberMe);
                                using (MenuLogic logicLayer = new MenuLogic())
                                {
                                    string InstanceId = "";
                                    if (Session["InstanceId"] == null)
                                        InstanceId = "";
                                    else
                                        InstanceId = Session["InstanceId"].ToString();
                                    var context = logicLayer.GetFirstMenu(InstanceId).ToList();
                                    if (context.Count > 0)
                                    {
                                        var first = context.First();
                                        Session["MenuId"] = first.Id.ToString();
                                        if (first.Action != null && first.Controller != null)
                                        {
                                            return RedirectToAction("Empty", "Shared", new { Id = first.Name.ToString(),MenuId=first.Id.ToString() });
                                        }
                                        else
                                        {
                                            return RedirectToAction("Empty", "Shared", new { id = first.Name.ToString(),MenuId=string.Empty });
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        ModelState.AddModelError("", "Service Unavailable.");
                    }
                }
                else
                {
                    ModelState.AddModelError("", "Invalid user name or password.");
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        // **************************************
        // URL: /Account/LogOff
        // **************************************
        [LogsRequest]
        public ActionResult LogOff()
        {
            Session["UserMode"] = null;
            Session["UserID"] = null;
            Session["MenuId"] = null;
            Session["InstanceId"] = null;
            FormsService.SignOut();
            
            return RedirectToAction("Index", "Home");
        }

        // **************************************
        // URL: /Account/Register
        // **************************************

        public ActionResult Register()
        {
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }

        [HttpPost]
        public ActionResult Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                UserCreateStatus createStatus;

                // Attempt to register the user
                using (SecurityProvider securityProvider = new SecurityProvider())
                    createStatus = securityProvider.CreateUser(model.UserName, model.Password, model.Email);

                if (createStatus == UserCreateStatus.Success)
                {
                    return RedirectToAction("Success", "Account");
                }
                else
                    ModelState.AddModelError("", AccountValidation.ErrorCodeToString(createStatus));
            }
            // If we got this far, something failed, redisplay form
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View(model);
        }

        // **************************************
        // URL: /Account/ChangePassword
        // **************************************
        
        [Authorize]
        [LogsRequest]
        public ActionResult ChangePassword()
        {
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }

        [Authorize]
        [HttpPost]
        [LogsRequest]
        public ActionResult ChangePassword(ChangePasswordModel model)
        {
            if (ModelState.IsValid)
            {
                if (MembershipService.ChangePassword(User.Identity.Name, model.OldPassword, model.NewPassword))
                {
                    return RedirectToAction("ChangePasswordSuccess");
                }
                else
                {
                    ModelState.AddModelError("", "The current password is incorrect or the new password is invalid.");
                }
            }

            // If we got this far, something failed, redisplay form
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View(model);
        }

        // **************************************
        // URL: /Account/ChangePasswordSuccess
        // **************************************
        [LogsRequest]
        public ActionResult ChangePasswordSuccess()
        {
            return View();
        }
        [LogsRequest]
        public ActionResult ForgotPassword()
        {
            //ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }
        [HttpPost]
        [LogsRequest]
        public ActionResult ForgotPassword(ForgotPasswordModel model)
        {
            if (ModelState.IsValid)
            {
                if (MembershipService.GetPassword(model.UserName))
                {
                    if (EmailHelper.SendTemplateMail("donotreply@corporatefirms.org", Session["Email"].ToString(), "Welcome to Corporate Firms", Url.Action("ForgotPwdEmail", "Administration", new { Pwd = Session["Pwd"] }, "http")))
                    {
                        ViewData["Password"] = "Password sent to your Mail ";
                    }
                }
                else
                {
                    ModelState.AddModelError("", "User doesn't exist.");
                }
            }
            //ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }

    }
}
