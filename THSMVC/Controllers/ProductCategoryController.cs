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
    public class ProductCategoryController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult ProductCategoryMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditProductCategory()
        {
            ProductCategoryModel model = new ProductCategoryModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditProductCategory(int Id)
        {
            ProductCategoryModel model = new ProductCategoryModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.ProductCategories
                         where p.Id == Id
                         select new ProductCategoryModel
                         {
                             Id = p.Id,
                             ProductCategory1 = p.ProductCategory1
                         }).FirstOrDefault();
            }
            model.BtnText = "Update";
            return View("AddEditProductCategory", model);
        }
        [LogsRequest]
        public ActionResult DelProductCategory(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.ProductCategories
                                where s.Id.Equals(id)
                                select s;
                    if (query.Count() > 0)
                    {
                        var ProductCategory = query.First();
                        ProductCategory.Status = true;
                        db.SaveChanges();
                        return Json(new { success = true, message = "Product Category deleted successfully" });
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }


            }
            catch (Exception ex)
            {
                logger.Error("DelProductCategory", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitProductCategory(ProductCategoryModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    if (model.Id == 0)
                    {
                        var ch = dse.ProductCategories.Where(p => p.ProductCategory1 == model.ProductCategory1).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Product Category with the same name already exists." });
                        ProductCategory group = new ProductCategory();
                        group.InstanceId = inststanceId;
                        group.ProductCategory1 = model.ProductCategory1;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
                        dse.AddToProductCategories(group);
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Product Category created successfuly" });
                    }
                    else
                    {
                        var ch = dse.ProductCategories.Where(p => p.ProductCategory1 == model.ProductCategory1 && p.Id != model.Id).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Product Category with the same name already exists." });
                        ProductCategory group = dse.ProductCategories.Where(p => p.Id == model.Id).FirstOrDefault();
                        group.ProductCategory1 = model.ProductCategory1;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Product Category updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitProductCategory", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<ProductCategoryModel> getProductCategorys()
        {
            using (ProductCategoryLogic logicLayer = new ProductCategoryLogic())
                return logicLayer.GetProductCategories();
        }
        public ActionResult JsonProductCategoryCollection(GridSettings grid)
        {
            try
            {

                var context = this.getProductCategorys();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<ProductCategoryModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<ProductCategoryModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<ProductCategoryModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<ProductCategoryModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<ProductCategoryModel>();
                    }
                }

                //sorting
                context = context.OrderBy<ProductCategoryModel>(grid.SortColumn, grid.SortOrder);

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
                            s.ProductCategory1.ToString().Replace("$$$$","'UpdateProductCategory("+s.Id.ToString()+")'").Replace("****","href='#'")
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonProductCategoryCollection", ex);
                return Json(false);
            }
        }
    }
}