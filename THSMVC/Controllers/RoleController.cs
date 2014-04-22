using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using THSMVC.Classes;
using THSMVC.Models;
using THSMVC.Models.Grid;
using THSMVC.Models.Helpers;
using THSMVC.Services.Logging.Log4Net;
using THSMVC.Views.Shared;

namespace THSMVC.Controllers
{
    public class RoleController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult RoleMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditRole()
        {
            RoleModel model = new RoleModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditRole(int Id)
        {
            RoleModel model = new RoleModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.Roles
                         where p.Id == Id
                         select new RoleModel
                         {
                             Id = p.Id,
                             RoleName = p.Role1
                         }).FirstOrDefault();
            }
            model.BtnText = "Update";
            return View("AddEditRole", model);
        }
        [LogsRequest]
        public ActionResult DelRole(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.Roles
                                where s.Id.Equals(id)
                                select s;
                    if (query.Count() > 0)
                    {
                        var Role = query.First();
                        var chkQuery = from a in db.Users
                                       where a.RoleId== id
                                       select a;
                        if (chkQuery.Count() <= 0)
                        {
                            Role.Status = true;
                            db.SaveChanges();
                            return Json(new { success = true, message = "Role deleted successfully" });
                        }
                        else
                            return Json(new { success = false, message = "Role was assigned to user(s). Unable to delete." });
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }


            }
            catch (Exception ex)
            {
                logger.Error("DelRole", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitRole(RoleModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    if (model.Id == 0)
                    {
                        Role group = new Role();
                        group.InstanceId = inststanceId;
                        group.Role1 = model.RoleName;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
                        dse.AddToRoles(group);
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Role created successfuly" });
                    }
                    else
                    {
                        Role group = dse.Roles.Where(p => p.Id == model.Id).FirstOrDefault();
                        group.Role1 = model.RoleName;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Role updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitRole", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<RoleModel> getRoles()
        {
            using (RoleLogic logicLayer = new RoleLogic())
                return logicLayer.GetRolesList();
        }
        public ActionResult JsonRoleCollection(GridSettings grid)
        {
            try
            {

                var context = this.getRoles();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<RoleModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<RoleModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<RoleModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<RoleModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<RoleModel>();
                    }
                }

                //sorting
                context = context.OrderBy<RoleModel>(grid.SortColumn, grid.SortOrder);

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
                            s.RoleName.ToString().Replace("$$$$","'UpdateRole("+s.Id.ToString()+")'").Replace("****","href='#'")
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonRoleCollection", ex);
                return Json(false);
            }
        }
    }
}