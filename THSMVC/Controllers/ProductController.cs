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
    public class ProductController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult ProductMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditProduct()
        {
            ProductModel model = new ProductModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditProduct(int Id)
        {
            ProductModel model = new ProductModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.Products
                         where p.Id == Id
                         select new ProductModel
                         {
                             Id = p.Id,
                             ProductName = p.ProductName,
                              ShortForm=p.ShortForm,
                              ValueAddedByPerc=p.ValueAddedByPerc,
                              ValueAddedFixed=p.ValueAddedFixed,
                              MakingChargesPerGram=p.MakingChargesPerGram,
                              MakingChargesFixed=p.MakingChargesFixed,
                              IsStone=p.IsStone,
                              IsWeightless=p.IsWeightless,
                              ProductCategoryId=p.ProductCategoryId,
                              ProductGroupId=p.ProductGroupId
                         }).FirstOrDefault();
            }
            model.BtnText = "Update";
            return View("AddEditProduct", model);
        }
        [LogsRequest]
        public ActionResult DelProduct(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.Products
                                where s.Id.Equals(id)
                                select s;
                    if (query.Count() > 0)
                    {
                        var Product = query.First();
                        Product.Status = true;
                        db.SaveChanges();
                        return Json(new { success = true, message = "Product deleted successfully" });
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }


            }
            catch (Exception ex)
            {
                logger.Error("DelProduct", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitProduct(ProductModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    if (model.Id == 0)
                    {
                        var ch = dse.Products.Where(p => p.ProductName== model.ProductName).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Product with the same name already exists." });
                        Product group = new Product();
                        group.InstanceId = inststanceId;
                        group.ProductName = model.ProductName;
                        group.ShortForm = model.ShortForm;
                        group.ValueAddedByPerc = model.ValueAddedByPerc;
                        group.ValueAddedFixed = model.ValueAddedFixed;
                        group.MakingChargesPerGram = model.MakingChargesPerGram;
                        group.MakingChargesFixed = model.MakingChargesFixed;
                        group.IsStone = model.IsStone;
                        group.IsWeightless = model.IsWeightless;
                        group.ProductCategoryId = model.ProductCategoryId;
                        group.ProductGroupId = model.ProductGroupId;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
                        dse.AddToProducts(group);
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Product created successfuly" });
                    }
                    else
                    {
                        var ch = dse.Products.Where(p => p.ProductName == model.ProductName && p.Id != model.Id).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Product with the same name already exists." });
                        Product group = dse.Products.Where(p => p.Id == model.Id).FirstOrDefault();
                        group.ProductName = model.ProductName;
                        group.ShortForm = model.ShortForm;
                        group.ValueAddedByPerc = model.ValueAddedByPerc;
                        group.ValueAddedFixed = model.ValueAddedFixed;
                        group.MakingChargesPerGram = model.MakingChargesPerGram;
                        group.MakingChargesFixed = model.MakingChargesFixed;
                        group.IsStone = model.IsStone;
                        group.IsWeightless = model.IsWeightless;
                        group.ProductCategoryId = model.ProductCategoryId;
                        group.ProductGroupId = model.ProductGroupId;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Product updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitProduct", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<ProductModel> getProducts()
        {
            using (ProductLogic logicLayer = new ProductLogic())
                return logicLayer.GetProducts();
        }
        public ActionResult JsonProductCollection(GridSettings grid)
        {
            try
            {

                var context = this.getProducts();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<ProductModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<ProductModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<ProductModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<ProductModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<ProductModel>();
                    }
                }

                //sorting
                context = context.OrderBy<ProductModel>(grid.SortColumn, grid.SortOrder);

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
                            s.ProductName.ToString().Replace("$$$$","'UpdateProduct("+s.Id.ToString()+")'").Replace("****","href='#'"),
                            s.IsStoneStr,
                            s.MakingChargesFixed.ToString(),
                            s.MakingChargesPerGram.ToString(),
                            s.ShortForm,
                            s.ValueAddedByPerc.ToString(),
                            s.ValueAddedFixed.ToString()
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonProductCollection", ex);
                return Json(false);
            }
        }
    }
}