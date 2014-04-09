using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Views.Shared;
using THSMVC.Models;
using THSMVC.Classes;
using System.Web.Mvc;
using THSMVC.Models.Grid;
using THSMVC.Models.Helpers;
using THSMVC.Services.Logging.Log4Net;

namespace THSMVC.Controllers
{
    public class ProductGroupController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        public ActionResult ProductGroupMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public IQueryable<ProductGroup> getProductGroups()
        {
            using (ProductGroupLogic logicLayer = new ProductGroupLogic())
                return logicLayer.GetProductGroups();
        }
        [LogsRequest]
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
                            context = context.Where<ProductGroup>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<ProductGroup>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<ProductGroup>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<ProductGroup>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<ProductGroup>();
                    }
                }

                //sorting
                context = context.OrderBy<ProductGroup>(grid.SortColumn, grid.SortOrder);

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
                            s.ProductGroup1.ToString()
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