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
    public class StoneController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult StoneMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditStone()
        {
            StoneModel model = new StoneModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditStone(int Id)
        {
            StoneModel model = new StoneModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.Stones
                         where p.StoneId == Id
                         select new StoneModel
                         {
                             Id = p.StoneId,
                             StoneName = p.StoneName,
                             StoneShortForm=p.StoneShortForm,
                             StonePerCarat=p.StonePerCarat,
                             IsStoneWeightless=p.IsStoneWeightless
                         }).FirstOrDefault();
            }
            model.BtnText = "Update";
            return View("AddEditStone", model);
        }
        [LogsRequest]
        public ActionResult DelStone(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.Stones
                                where s.StoneId.Equals(id)
                                select s;
                    if (query.Count() > 0)
                    {
                        var Stone = query.First();
                        Stone.Status = true;
                        db.SaveChanges();
                        return Json(new { success = true, message = "Stone deleted successfully" });
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }


            }
            catch (Exception ex)
            {
                logger.Error("DelStone", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitStone(StoneModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    if (model.Id == 0)
                    {
                        Stone group = new Stone();
                        group.InstanceId = inststanceId;
                        group.StoneName = model.StoneName;
                        group.StoneShortForm = model.StoneShortForm;
                        group.StonePerCarat = model.StonePerCarat;
                        group.IsStoneWeightless = model.IsStoneWeightless;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
                        dse.AddToStones(group);
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Stone created successfuly" });
                    }
                    else
                    {
                        Stone group = dse.Stones.Where(p => p.StoneId == model.Id).FirstOrDefault();
                        group.StoneName = model.StoneName;
                        group.StoneShortForm = model.StoneShortForm;
                        group.StonePerCarat = model.StonePerCarat;
                        group.IsStoneWeightless = model.IsStoneWeightless;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Stone updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitStone", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<StoneModel> getStones()
        {
            using (StoneLogic logicLayer = new StoneLogic())
                return logicLayer.GetStones();
        }
        public ActionResult JsonStoneCollection(GridSettings grid)
        {
            try
            {

                var context = this.getStones();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<StoneModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<StoneModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<StoneModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<StoneModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<StoneModel>();
                    }
                }

                //sorting
                context = context.OrderBy<StoneModel>(grid.SortColumn, grid.SortOrder);

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
                            s.StoneName.ToString().Replace("$$$$","'UpdateStone("+s.Id.ToString()+")'").Replace("****","href='#'"),
                            s.StoneShortForm,
                            s.StonePerCarat==null?"":s.StonePerCarat.ToString(),
                            s.ChkStoneWeightless
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonStoneCollection", ex);
                return Json(false);
            }
        }
    }
}