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
    public class DealerController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult DealerMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditDealer()
        {
            DealerModel model = new DealerModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditDealer(int Id)
        {
            DealerModel model = new DealerModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.Dealers
                         where p.DealerId == Id
                         select new DealerModel
                         {
                             Id = p.DealerId,
                             DealerName = p.DealerName,
                             Address = p.Address,
                             City = p.City,
                             State = p.State,
                             PinCode = p.PinCode,
                             CompanyName = p.CompanyName,
                             CompanyShortForm = p.CompanyShortForm,
                             TinNo = p.CompanyVATOrTinNo
                         }).FirstOrDefault();
            }
            model.BtnText = "Update";
            return View("AddEditDealer", model);
        }
        [LogsRequest]
        public ActionResult DelDealer(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.Dealers
                                where s.DealerId.Equals(id)
                                select s;
                    if (query.Count() > 0)
                    {
                        var Dealer = query.First();
                        Dealer.Status = true;
                        db.SaveChanges();
                        return Json(new { success = true, message = "Dealer deleted successfully" });
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }


            }
            catch (Exception ex)
            {
                logger.Error("DelDealer", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitDealer(DealerModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    if (model.Id == 0)
                    {
                        var ch = dse.Dealers.Where(p => p.DealerName == model.DealerName).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Dealer with the same name already exists." });
                        Dealer group = new Dealer();
                        group.InstanceId = inststanceId;
                        group.DealerName = model.DealerName;
                        group.CompanyName = model.CompanyName;
                        group.CompanyShortForm = model.CompanyShortForm;
                        group.Address = model.Address;
                        group.City = model.City;
                        group.State = model.State;
                        group.PinCode = model.PinCode;
                        group.CompanyVATOrTinNo = model.TinNo;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
                        dse.AddToDealers(group);
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Dealer created successfuly" });
                    }
                    else
                    {
                        var ch = dse.Dealers.Where(p => p.DealerName == model.DealerName && p.DealerId != model.Id).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Dealer with the same name already exists." });
                        Dealer group = dse.Dealers.Where(p => p.DealerId == model.Id).FirstOrDefault();
                        group.DealerName = model.DealerName;
                        group.CompanyName = model.CompanyName;
                        group.CompanyShortForm = model.CompanyShortForm;
                        group.Address = model.Address;
                        group.City = model.City;
                        group.State = model.State;
                        group.PinCode = model.PinCode;
                        group.CompanyVATOrTinNo = model.TinNo;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Dealer updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitDealer", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<DealerModel> getDealers()
        {
            using (DealerLogic logicLayer = new DealerLogic())
                return logicLayer.GetDealers();
        }
        public ActionResult JsonDealerCollection(GridSettings grid)
        {
            try
            {

                var context = this.getDealers();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<DealerModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<DealerModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<DealerModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<DealerModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<DealerModel>();
                    }
                }

                //sorting
                context = context.OrderBy<DealerModel>(grid.SortColumn, grid.SortOrder);

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
                            s.CompanyName.ToString(),
                            s.DealerName.ToString().Replace("$$$$","'UpdateDealer("+s.Id.ToString()+")'").Replace("****","href='#'"),
                            s.CompanyShortForm==null?"":s.CompanyShortForm,
                            s.Address==null?"":s.Address,
                            s.City==null?"":s.City,
                            s.State==null?"":s.State,
                            s.PinCode==null?"":s.PinCode,
                            s.TinNo==null?"":s.TinNo
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonDealerCollection", ex);
                return Json(false);
            }
        }
    }
}