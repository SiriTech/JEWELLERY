using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Views.Shared;
using THSMVC.Models;
using THSMVC.Models.Grid;
using THSMVC.Models.Helpers;
using THSMVC.App_Code;
using THSMVC.Services.Logging.Log4Net;
using System.Globalization;
using System.Data.Objects;
using System.IO;
using System.Web.Hosting;
using System.Web.Routing;
using THSMVC.App_Code;
using PagedList;

namespace THSMVC.Controllers
{
    public class AdminController : Controller
    {
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (Session == null)
            {
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary {
                            { "Controller", "Shared" },
                            { "Action", "TimeoutExpired" }
                    });

            }
            base.OnActionExecuting(filterContext);
        }
        private IFileStore _fileStore = new DiskFileStore();
        private static readonly IEncryptString _encrypter = new ConfigurationBasedStringEncrypter();
        Log4NetLogger logger = new Log4NetLogger();
        DataStoreEntities dbEntities = new DataStoreEntities();
        //
        // GET: /Admin/
        [LogsRequest]
        public ActionResult Welcome()
        {

            return View();
        }
        public ActionResult ErrorLogs()
        {
            return View();
        }
        public ActionResult SiteLog()
        {
            return View();
        }
        [LogsRequest]
        public ActionResult CreateUser()
        {
            CreateUserModel model = new CreateUserModel();
            return View(model);
        }
        public ActionResult ClearInternalUserSession()
        {
            Session["InternalUserId"] = null;
            return Json(new { success = true });

        }

       
        [LogsRequest]
        [HttpPost]
        public ActionResult CreateMenu(CreateMenuModel model)
        {
            try
            {
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    Menu menu = new Menu();
                    menu.InstanceId = model.InstanceId;
                    if (model.MenuId == 0)
                    {
                        menu.ParentId = model.MenuId;
                    }
                    menu.Name = model.Name;
                    menu.Action = model.ActionName;
                    menu.Controller = model.ControllerName;
                    if (model.GroupId == 0)
                    {
                        menu.GroupId = model.GroupId;
                    }
                    menu.Order = model.Order;
                    menu.Level = model.Level;
                    dse.AddToMenus(menu);
                    dse.SaveChanges();
                    return Json(new { success = true, message = "Menu Created Successfully." });
                }
            }
            catch (Exception ex)
            {
                logger.Error("Admin/CreateMenu", ex);
                return Json(new { success = false, message = "Menu creation failed." });
            }
        }

        public ActionResult GetOrder(CreateMenuModel model)
        {
            using (MenuLogic logic = new MenuLogic())
            {
                int order = logic.GetOrder(model);
                return Json(new { success = true, message = order + 1 });
            }
        }
        public ActionResult LoadParentMenus(string InstanceId)
        {
            try
            {
                using (MenuLogic menuLogic = new MenuLogic())
                {
                    var context = menuLogic.GetParentMenu(InstanceId);
                    return Json(new SelectList(
                                       context.ToArray(),
                                       "Id",
                                       "Name")
                                   );
                }
            }
            catch (Exception ex)
            {
                logger.Error("Admin/LoadParentMenus", ex);
                return Json(false);
            }
        }

        [LogsRequest]
        public ActionResult CreateMenu()
        {
            CreateMenuModel model = new CreateMenuModel();
            return View(model);
        }
        
        [LogsRequest]
        [HttpPost]
        public ActionResult RegisterAdmin(RegisterAdminModel model)
        {
            try
            {
                using (var dbEntities = new DataStoreEntities())
                {
                    Role role = new Role();
                    role.InstanceId = model.Instance;
                    role.Role1 = "Administrator";
                    role.RoleDesc = "Admin";
                    role.CreatedBy = Convert.ToInt32(Session["UserId"]);
                    role.CreatedDate = DateTime.Now;
                    dbEntities.AddToRoles(role);
                    dbEntities.SaveChanges();
                    //Getting the Administrator role identity value.
                    int identity = role.Id;
                    //Inserting user information with role id into user table.
                    User user = new User();
                    user.UserName = model.UserName;
                    user.Password = _encrypter.Encrypt(model.Password);
                    user.Email = model.Email;
                    user.CreatedDate = DateTime.Now;
                    user.CreatedBy = Convert.ToInt32(Session["UserID"]);
                    user.IsApproved = true;
                    user.IsLockedOut = false;
                    user.ChangePwdonLogin = true;
                    user.InstanceId = model.Instance;
                    user.RoleId = identity;
                    dbEntities.AddToUsers(user);
                    dbEntities.SaveChanges();

                    var instance = (from s in dbEntities.Instances where s.Id == model.Instance select s);
                    var first = instance.First();

                    dbEntities.stp_Intial_Menus_For_Admin(model.Instance,role.Id, user.Id, first.LicenseStartDate, first.LicenseEndDate);

                }
                //using (DataStoreEntities dse = new DataStoreEntities())
                //{
                //    Role studentrole = new Role();
                //    studentrole.InstanceId = model.Instance;
                //    studentrole.Role1 = "Student";
                //    studentrole.RoleDesc = "Student";
                //    studentrole.CreatedBy = Convert.ToInt32(Session["UserId"]);
                //    studentrole.CreatedDate = DateTime.Now;
                //    dse.AddToRoles(studentrole);
                //    dse.SaveChanges();
                //    Role Teacherrole = new Role();
                //    Teacherrole.InstanceId = model.Instance;
                //    Teacherrole.Role1 = "Teacher";
                //    Teacherrole.RoleDesc = "Teacher";
                //    Teacherrole.CreatedBy = Convert.ToInt32(Session["UserId"]);
                //    Teacherrole.CreatedDate = DateTime.Now;
                //    dse.AddToRoles(Teacherrole);
                //    dse.SaveChanges();
                //}
                return Json(new { success = true, message = "Employee created successfully." });
            }
            catch (Exception ex)
            {
                logger.Error("Admin/RegisterAdmin", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        [HttpGet]
        public ActionResult CreateInstance()
        {
            return View();
        }
        [LogsRequest]
        public ActionResult RegisterAdmin(string Id, string MenuId)
        {
            RegisterAdminModel model = new RegisterAdminModel();
            return View(model);
        }
        [LogsRequest]
        [HttpGet]
        public ActionResult UpdateInstance(string Id)
        {
            int InstanceId = Convert.ToInt32(Id);
            using (var dbEntities = new DataStoreEntities())
            {
                Instance instance = dbEntities.Instances.Single(i => i.Id == InstanceId);
                CreateInstanceModel model = new CreateInstanceModel();
                model.InstanceName = instance.Name;
                model.ParentInstance = instance.ParentInstance;
                model.PIN = instance.PIN;
                model.Phone = instance.Phone;
                model.Mobile = instance.Mobile;
                model.LicenseFromString = instance.LicenseStartDate.Value.ToShortDateString();
                model.LicenseToString = instance.LicenseEndDate.Value.ToShortDateString();
                return View(model);
            }
            //ViewData["UpdateInstanceId"] = Id;
            // return View();
        }
        [LogsRequest]
        public ActionResult ManageInstance()
        {
            return View();
        }
        
        [LogsRequest]
        public ActionResult InstanceList()
        {
            try
            {
                using (InstanceLogic city = new InstanceLogic())
                {
                    var cities = city.GetInstances();

                    return Json(new SelectList(
                                    cities.ToArray(),
                                    "Id",
                                    "InstanceName")
                                );
                }
            }
            catch (Exception ex)
            {
                logger.Error("Admin/InstanceList", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        [HttpPost]
        public ActionResult CreateInstance(string InstanceName, string ParentInstance, string Country, string State, string City, string Sector, string Location, string PIN, string Phone, string Mobile, string From, string To)
        {
            try
            {


                using (var dbEntities = new DataStoreEntities())
                {
                    Instance instance = new Instance();
                    instance.Name = InstanceName;
                    if (ParentInstance != string.Empty)
                    {
                        instance.ParentInstance = Convert.ToInt32(ParentInstance);
                    }
                    if (PIN != string.Empty)
                        instance.PIN = PIN;
                    if (Phone != string.Empty)
                        instance.Phone = Phone;
                    if (Mobile != string.Empty)
                        instance.Mobile = Mobile;
                    instance.CreatedDate = DateTime.Now;
                    instance.LicenseStartDate = Convert.ToDateTime(From);
                    instance.LicenseEndDate = Convert.ToDateTime(To);
                    dbEntities.AddToInstances(instance);
                    dbEntities.SaveChanges();
                }
                return Json(new { success = true, message = "Instance Created Successfully." });
            }
            catch (Exception ex)
            {
                logger.Error("Admin/CreateInstance", ex);
                return Json(false);
            }
        }
        
        [LogsRequest]
        [HttpPost]
        public ActionResult UpdateInstance(string InstanceName, string ParentInstance, string Country, string State, string City, string Sector, string Location, string PIN, string Phone, string Mobile, string From, string To, string Id)
        {
            try
            {
                int InstanceId = Convert.ToInt32(Id);

                using (var dbEntities = new DataStoreEntities())
                {

                    Instance instance = dbEntities.Instances.Single(i => i.Id == InstanceId);
                    instance.Name = InstanceName;
                    if (ParentInstance != string.Empty)
                    {
                        instance.ParentInstance = Convert.ToInt32(ParentInstance);
                    }
                    if (PIN != string.Empty)
                        instance.PIN = PIN;
                    if (Phone != string.Empty)
                        instance.Phone = Phone;
                    if (Mobile != string.Empty)
                        instance.Mobile = Mobile;
                    //instance.CreatedDate = DateTime.Now;
                    instance.LicenseStartDate = Convert.ToDateTime(From);
                    instance.LicenseEndDate = Convert.ToDateTime(To);
                    //dbEntities.AddToInstances(instance);
                    dbEntities.SaveChanges();
                }
                return Json(new { success = true, message = "Instance Updated Successfully." });
            }
            catch (Exception ex)
            {
                logger.Error("Admin/UpdateInstance", ex);
                return Json(false);
            }
        }
        
        [LogsRequest]
        public ActionResult JsonInstaneCollection(GridSettings grid)
        {
            try
            {

                var context = GetInstances();

                //sorting
                context = context.OrderBy<InstanceCls>(grid.SortColumn, grid.SortOrder);

                //count
                var count = context.Count();

                //paging
                context = context.Skip((grid.PageIndex - 1) * grid.PageSize).Take(grid.PageSize).ToArray().AsQueryable();


                // Format the data for the jqGrid
                var jsonData = new
                {
                    total = (int)Math.Ceiling((double)count / grid.PageSize),
                    page = grid.PageIndex,
                    records = count,
                    rows = (
                          from s in context
                          select new
                          {
                              i = s.Id,
                              cell = new string[] {
                            s.Id.ToString(),
                            s.InstanceName.ToString().Replace("$$$$","'UpdateInstance','Admin','Update&nbsp;Instance','" + s.Id.ToString() + "'").Replace("****","href='#'"),
                            s.From.ToString(),
                            s.To.ToString()
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                logger.Error("JsonInstaneCollection", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult BackToSearch()
        {
            Session["InternalUserID"] = null;
            return Json(true);
        }
        
        [LogsRequest]
        public IQueryable<InstanceCls> GetInstances()
        {
            using (InstanceLogic logicLayer = new InstanceLogic())
            {
                return logicLayer.GetInstances();
            }
        }
        
        [LogsRequest]
        public IQueryable<Instance> GetAllInstances()
        {
            using (InstanceLogic logicLayer = new InstanceLogic())
            {
                return logicLayer.GetAllInstances();
            }
        }
        [LogsRequest]
        public ActionResult GetInstanceById(string Id)
        {
            try
            {
                var context = GetAllInstances();
                if (Id != "")
                {
                    context = context.Where(e => e.Id.Equals(Convert.ToInt32(Id)));
                }
                return Json(context);
            }
            catch (Exception ex)
            {
                logger.Error("GetInstanceById", ex);
                return Json(false);
            }
        }
        public IQueryable<Log4Net_Error> getErrorLogs()
        {
            using (ErrorLogsLogic logicLayer = new ErrorLogsLogic())
                return logicLayer.GetErrorlogs();
        }

        public ActionResult JsonErrorLogsCollection(GridSettings grid)
        {

            var context = this.getErrorLogs();
            //filtring
            if (grid.IsSearch)
            {
                //And
                if (grid.Where.groupOp == "AND")
                    foreach (var rule in grid.Where.rules)
                        context = context.Where<Log4Net_Error>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                else
                {
                    //Or
                    var temp = (new List<Log4Net_Error>()).AsQueryable();
                    foreach (var rule in grid.Where.rules)
                    {
                        var t = context.Where<Log4Net_Error>(
                        rule.field, rule.data,
                        (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        temp = temp.Concat<Log4Net_Error>(t);
                    }
                    //remove repeating records
                    context = temp.Distinct<Log4Net_Error>();
                }
            }

            //sorting
            context = context.OrderBy<Log4Net_Error>(grid.SortColumn, grid.SortOrder);

            //count
            var count = context.Count();

            //paging
            context = context.Skip((grid.PageIndex - 1) * grid.PageSize).Take(grid.PageSize).ToArray().AsQueryable();

            // Format the data for the jqGrid
            var jsonData = new
            {
                total = (int)Math.Ceiling((double)count / grid.PageSize),
                page = grid.PageIndex,
                records = count,
                rows = (
                      from s in context
                      select new
                      {
                          i = s.Id,
                          cell = new string[] {
                            s.Date.ToString(),
                            s.Level,
                            s.Message,
                            s.Exception, 
                            s.UserID
                        }
                      }).ToArray()
            };

            // Return the result in json
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }
        public IQueryable<SiteLog> getSiteLogs()
        {
            using (SiteLogsLogic logicLayer = new SiteLogsLogic())
                return logicLayer.GetSitelogs();
        }
        public ActionResult JsonSiteLogsCollection(GridSettings grid)
        {

            var context = this.getSiteLogs();
            //filtring
            if (grid.IsSearch)
            {
                //And
                if (grid.Where.groupOp == "AND")
                    foreach (var rule in grid.Where.rules)
                        context = context.Where<SiteLog>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                else
                {
                    //Or
                    var temp = (new List<SiteLog>()).AsQueryable();
                    foreach (var rule in grid.Where.rules)
                    {
                        var t = context.Where<SiteLog>(
                        rule.field, rule.data,
                        (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        temp = temp.Concat<SiteLog>(t);
                    }
                    //remove repeating records
                    context = temp.Distinct<SiteLog>();
                }
            }

            //sorting
            context = context.OrderBy<SiteLog>(grid.SortColumn, grid.SortOrder);

            //count
            var count = context.Count();

            //paging
            context = context.Skip((grid.PageIndex - 1) * grid.PageSize).Take(grid.PageSize).ToArray().AsQueryable();

            // Format the data for the jqGrid
            var jsonData = new
            {
                total = (int)Math.Ceiling((double)count / grid.PageSize),
                page = grid.PageIndex,
                records = count,
                rows = (
                      from s in context
                      select new
                      {
                          i = s.ID,
                          cell = new string[] {
                            s.ID.ToString(),
                            s.TimeStamp.ToString(),
                            s.Action,
                            s.Controller,
                            s.IPAddress, 
                            s.URL,
                            s.HostAddress,
                            s.UserID
                        }
                      }).ToArray()
            };

            // Return the result in json
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }
        
        [LogsRequest]
        public ActionResult ManageRoles()
        {
            int InstanceId = Convert.ToInt32(Session["InstanceId"]);
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                List<ManageRole> lstRoles = (from r in dse.Roles where r.InstanceId == InstanceId && (r.Status == null || r.Status == false) select new ManageRole { RoleId = r.Id, RoleName = r.Role1 }).ToList<ManageRole>();
                return View(lstRoles);
            }

        }
        [LogsRequest]
        public ActionResult GetMenuItemsByRole(int RoleId)
        {
            int InstanceId = Convert.ToInt32(Session["InstanceId"]);
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                List<stp_Get_Menuitems_By_Role_Id_Result> lstMenuItems = (from s in dse.stp_Get_Menuitems_By_Role_Id(InstanceId, RoleId) select s).ToList<stp_Get_Menuitems_By_Role_Id_Result>();
                MenuItems model = new MenuItems();
                model.AllMenuItems = lstMenuItems;
                model.ParentMenuItems = lstMenuItems.Where(p => p.ParentId == null).ToList<stp_Get_Menuitems_By_Role_Id_Result>();
                model.RoleId = RoleId;
                return View("MenuItems", model);
            }
        }
        [LogsRequest]
        public ActionResult AssignRemoveMenuItems(string MenuItems, int RoleId)
        {
            try
            {
                if (MenuItems != string.Empty)
                {
                    int InstanceId = Convert.ToInt32(Session["InstanceId"]);
                    int CreatedBy = Convert.ToInt32(Session["UserId"]);
                    int? result = 0;
                    string FinalMenuitems = MenuItems.Remove(MenuItems.Length - 1, 1);
                    using (DataStoreEntities dse = new DataStoreEntities())
                    {
                        result = dse.stp_Assign_Remove_MenuItems_Role(InstanceId, RoleId, FinalMenuitems, CreatedBy).FirstOrDefault();
                    }
                    if (result > 0)
                        return Json(new { success = true, message = "Menu Items assigned successfully" });
                    else
                        return Json(new { success = false, message = "An error occured while assigning." });
                }
                else
                {
                    return Json(new { success = false, message = "Please select menu items to assign/remove." });
                }
            }
            catch (Exception ex)
            {
                logger.Error("AssignRemoveMenuItems", ex);
                return Json(new { success = false, message = "An error occured while assigning." });
            }
        }
        [LogsRequest]
        public ActionResult SubmitQueryEmail(string Name, string Email, string Phone, string Query)
        {
            ViewData["EmailQueryName"] = Name;
            ViewData["EmailQueryEmail"] = Email;
            ViewData["EmailQueryPhone"] = Phone;
            ViewData["EmailQuery"] = Query;
            return View();
        }
        public string AsyncUpload(string InstanceID)
        {
            int InstanceId = Convert.ToInt32(Session["InstanceId"]);
            return _fileStore.SaveUploadedFile(Request.Files[0], InstanceId);
        }
    }
}
