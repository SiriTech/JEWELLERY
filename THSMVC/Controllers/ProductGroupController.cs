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
    public class ProductGroupController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult ProductGroupMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditProductGroup()
        {
            ProductGroupModel model = new ProductGroupModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditProductGroup(int Id)
        {
            ProductGroupModel model = new ProductGroupModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.ProductGroups
                                           where p.Id == Id
                                           select new ProductGroupModel { 
                                            Id=p.Id,
                                            ProductGroup1 = p.ProductGroup1
                                           }).FirstOrDefault();
            }
            model.BtnText = "Update";
            return View("AddEditProductGroup",model);
        }
        [LogsRequest]
        public ActionResult DelProductGroup(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.ProductGroups
                                where s.Id.Equals(id)
                                select s;
                    if (query.Count() > 0)
                    {
                        var ProductGroup = query.First();
                        ProductGroup.Status = true;
                        db.SaveChanges();
                        return Json(new { success=true,message="Product Group deleted successfully"});
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }


            }
            catch (Exception ex)
            {
                logger.Error("DelProductGroup", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitProductGroup(ProductGroupModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    if (model.Id == 0)
                    {
                        ProductGroup group = new ProductGroup();
                        group.InstanceId = inststanceId;
                        group.ProductGroup1 = model.ProductGroup1;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
                        dse.AddToProductGroups(group);
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Product Group created successfuly" });
                    }
                    else
                    {
                        ProductGroup group = dse.ProductGroups.Where(p => p.Id == model.Id).FirstOrDefault();
                        group.ProductGroup1 = model.ProductGroup1;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Product Group updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitProductGroup", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<ProductGroupModel> getProductGroups()
        {
            using (ProductGroupLogic logicLayer = new ProductGroupLogic())
                return logicLayer.GetProductGroups();
        }
        public ActionResult JsonProductGroupCollection(GridSettings grid)
        {
            try
            {

                var context = this.getProductGroups();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<ProductGroupModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<ProductGroupModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<ProductGroupModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<ProductGroupModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<ProductGroupModel>();
                    }
                }

                //sorting
                context = context.OrderBy<ProductGroupModel>(grid.SortColumn, grid.SortOrder);

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
                            s.ProductGroup1.ToString().Replace("$$$$","'UpdateProductGroup("+s.Id.ToString()+")'").Replace("****","href='#'")
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonProductGroupCollection", ex);
                return Json(false);
            }
        }
    }
}