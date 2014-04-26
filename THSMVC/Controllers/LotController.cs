﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Views.Shared;
using THSMVC.Models;
using THSMVC.App_Code;
using THSMVC.Models.Grid;
using THSMVC.Services.Logging.Log4Net;
using THSMVC.Classes;

namespace THSMVC.Controllers
{
    public class LotController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();

        [LogsRequest]
        public ActionResult LotMaster(string Id, string MenuId)
        {
            LotMasterModel model = new LotMasterModel();
            using (MenuLogic logic = new MenuLogic())
            {
                var context = logic.GetRightsBasedMenuId(MenuId);
                if (context.Count() > 0)
                {
                    foreach (UserBasedRights obj in context)
                    {
                        if (obj.RightName == "Create")
                        {
                            if (obj.Flag)
                                model.Create = true;
                            else
                                model.Create = false;
                        }
                        if (obj.RightName == "Update")
                        {
                            if (obj.Flag)
                                model.Update = true;
                            else
                                model.Update = false;
                        }
                    }
                }
            }
            return View(model);
        }
        [LogsRequest]
        public ActionResult CreateLot()
        {
            LotMasterModel model = new LotMasterModel();

            List<ProductGroup> PGList = GetProductGroupList();

            List<Dealer> DList = GetDealersList();

            model.ProductGroupList = PGList;
            model.DealerList = DList;

            return View(model);
        }
        [HttpPost]
        public ActionResult CreateLot(LotMasterModel objLotMasterModel)
        {
            bool result = false;
            Lot lot = new Lot
            {
                InstanceId = Convert.ToInt32(Session["InstanceId"]),
                DealerId = objLotMasterModel.DealerId,
                LotId = objLotMasterModel.LotId,
                LotName = objLotMasterModel.LotName,
                NoOfPieces = (int)objLotMasterModel.Qty,
                ProductGroupId = objLotMasterModel.ProductGroupId,
                Weight = (int)objLotMasterModel.Weight
            };
            using (LotLogic logicLayer = new LotLogic())
            {
                result = logicLayer.CreateLot(lot);
            }
            if (result)
                return Json(new { success = true, msg = "Successfully Lot is created." });
            else
                return Json(new { success = false, msg = "Error while creating Lot. Please try again." });
        }

        [HttpPost]
        public ActionResult UpdateLot(LotMasterModel objLotMasterModel)
        {
            bool result = false;
            Lot lot = new Lot
            {
                DealerId = objLotMasterModel.DealerId,
                LotId = objLotMasterModel.LotId,
                LotName = objLotMasterModel.LotName,
                NoOfPieces = (int)objLotMasterModel.Qty,
                ProductGroupId = objLotMasterModel.ProductGroupId,
                Weight = (int)objLotMasterModel.Weight
            };
            using (LotLogic logicLayer = new LotLogic())
            {
                result = logicLayer.UpdateLot(lot);
            }
            if (result)
                return Json(new { success = true, msg = "Successfully Lot is Updated." });
            else
                return Json(new { success = false, msg = "Error while updating Lot. Please try again." });
        }

        public ActionResult JsonLotCollection(GridSettings grid)
        {
            try
            {
                int instanceId = Convert.ToInt32(Session["InstanceId"]);
                var context = GetLots();

                //sorting
                //  context = context.OrderBy<LotMasterModel>(grid.SortColumn, grid.SortOrder);

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
                              i = s.LotId,
                              cell = new string[] {
                            s.LotId.ToString(), //s.LotName,
                            s.LotName.ToString().Replace("$$$$","'UpdateLot("+s.LotId.ToString()+")'").Replace("****","href='#'"),
                            s.ProductGroupId.ToString(),
                            s.Qty.ToString(),
                            s.Weight.ToString(),
                            s.DealerId.ToString()
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

        public ActionResult JsonAssignedLotCollection(GridSettings grid)
        {
            try
            {
                int instanceId = Convert.ToInt32(Session["InstanceId"]);
                var context = GetAssignedLots();

                //sorting
                //  context = context.OrderBy<LotMasterModel>(grid.SortColumn, grid.SortOrder);

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
                              Id = s.LotId,
                              cell = new string[] {
                                  s.LotId.ToString(),
                            s.LotName,
                            s.UserName,
                            s.Status
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

        public ActionResult JsonCompletedLotCollection(GridSettings grid)
        {
            try
            {
                int instanceId = Convert.ToInt32(Session["InstanceId"]);
                var context = GetAssignedLots();

                //sorting
                //  context = context.OrderBy<LotMasterModel>(grid.SortColumn, grid.SortOrder);

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
                              Id = s.LotId,
                              cell = new string[] {
                                  s.LotId.ToString(),
                            s.LotName,
                            s.UserName,
                            s.Status
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
        public ActionResult DelLotAssignment(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    LotUserMapping lm = db.LotUserMappings.Where(x => x.LotId == id).FirstOrDefault();
                    db.LotUserMappings.DeleteObject(lm);
                    db.SaveChanges();
                    return Json(new { success = true, message = "Lot deleted successfully" });
                }
            }
            catch (Exception ex)
            {
                logger.Error("DelUser", ex);
                return Json(false);
            }
        }
        public ActionResult EditLot(int Id)
        {
            LotMasterModel lot = new LotMasterModel();

            using (LotLogic logicLayer = new LotLogic())
            {
                lot = logicLayer.GetLotModelById(Id);
            }

            List<ProductGroup> PGList = GetProductGroupList();
            List<Dealer> DList = GetDealersList();
            lot.ProductGroupList = PGList;
            lot.DealerList = DList;

            return View("CreateLot", lot);
        }

        public IQueryable<LotMasterModel> GetLots()
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetLots();
            }
        }

        public List<Lot> GetAllLots()
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetAllLots();
            }
        }

        public IQueryable<User> GetUsers()
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetUsers();
            }
        }

        public ActionResult AssignLot(string Id, string MenuId)
        {
            List<Lot> LotList = GetAllLots();

            List<User> UserList = GetUsers().ToList();

            LotAssignModel model = new LotAssignModel
            {
                LotList = LotList,
                UserList = UserList
            };

            return View(model);
        }
        public ActionResult LotDropdown()
        {
            List<Lot> LotList = GetAllLots();
            List<LotDropdownModel> model = new List<LotDropdownModel>();
            foreach (Lot l in LotList)
            {
                LotDropdownModel mdl = new LotDropdownModel();
                mdl.LotId = l.LotId;
                mdl.LotName = l.LotName;
                model.Add(mdl);
            }
            return Json(new { result=model});
        }
        [HttpPost]
        public ActionResult AssignLot(int LotId, int UserId)
        {
            bool Result = false;
            using (LotLogic logicLayer = new LotLogic())
            {
                Result = logicLayer.AssignLot(LotId, UserId, 2);
            }
            if (Result)
                return Json(new { success = true, msg = "Successfully Lot Assinged." });
            else
                return Json(new { success = false, msg = "Error while Assinging the Lot. Please try again." });
        }

        public ActionResult LotsAssigned(string Id, string MenuId)
        {
            return View("LotsAssignedToUser");
        }

        [HttpPost]
        public ActionResult AcceptLot(int lotId)
        {
            bool Result = false;
            using (LotLogic logicLayer = new LotLogic())
            {
                Result = logicLayer.AcceptLot(lotId);
            }
            if (Result)
                return Json(new { success = true, msg = "Successfully Lot Accpeted." });
            else
                return Json(new { success = false, msg = "Error while Accepting the Lot. Please try again." });
        }

        public ActionResult GetLotDetails(int lotId)
        {
            LotDetailsModel model = GetLotDetailsByLotId(lotId);
            return View("LotDetails", model);
        }

        public ActionResult JsonAssignedLotsToUserCollection(GridSettings grid)
        {
            int userId = 0;
            int.TryParse(Session["UserID"].ToString(), out userId); 

            try
            {
                int instanceId = Convert.ToInt32(Session["InstanceId"]);
                var context = GetAssignedLotsToUser(userId);

                //sorting
                //  context = context.OrderBy<LotMasterModel>(grid.SortColumn, grid.SortOrder);

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
                              Id = s.LotId,
                              cell = new string[] {
                                  s.LotId.ToString(),
                            s.LotName,
                            s.UserName,
                            s.Status,
                            s.AcceptLink
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

        [HttpPost]
        public ActionResult CheckIsStonedOrNot(int productId)
        {
            bool isStoned = false;
            Product product = new Product();
            List<StoneModel> model = new List<StoneModel>();

            product = GetProduct(productId);
            if (product != null)
            {
                isStoned = product.IsStone;
            }

            if (isStoned)
            {
                model = GetStoneList();
            }

            StoneModel dummy = new StoneModel
            {
                StoneId =0,
                StoneName = "Select Stone"
            };
            model.Insert(0, dummy);

            if (isStoned)
                return Json(new { success = true, stoneList = model });
            else
                return Json(new { success = false });
        }

        public ActionResult PrintBarcode(int productId, int lotId, int stoneId, double Weight, double stoneWeight, double stonePrice, int noOfStones, string notes)
        {
            //Todo Generate Barode Sequence.]
            List<CompletedBarcodeModel> CompletedList = new List<CompletedBarcodeModel>();
            Barcode barcode = new Barcode
            {
                BarcodeNumber = 1000,
                IsSubmitted = false,
                LotId = lotId,
                NoOfPieces = 1,
                Notes = notes,
                Price = 100, //Need to Calculate
                ProductId = productId,
                GrossWeight = (decimal)Weight, //ToDo: need to calculate
                WeightMeasure = ""
            };
            bool result = false;
            LotLogic logicLayer = new LotLogic();
            result = logicLayer.InsertBarcode(barcode);

            //Todo: Orint barcode
            if (result)
            {
                CompletedList =GetCompletedProducts(lotId);
            }

            if (result)
                return Json(new { success = true, model = CompletedList });
            else
                return Json(new { success = false });
        }

        private List<StoneModel> GetStoneList()
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetStoneList();
            }
        }
        private Product GetProduct(int productId)
        {
            Product product = new Product();
            using (ProductLogic logicLayer = new ProductLogic())
            {
                product =  logicLayer.GetProductById(productId);
            }

            return product;
        }

        private List<ProductGroup> GetProductGroupList()
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetAllProductGroups();
            }
        }

        private List<Dealer> GetDealersList()
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetAllDealers();
            }
        }

        private LotDetailsModel GetLotDetailsByLotId(int lotId)
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetLotDetailsById(lotId);
            }
        }

        private IQueryable<LotUserMappingView> GetAssignedLots()
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetAssignedLots().AsQueryable();
            }
        }

        private List<CompletedBarcodeModel> GetCompletedProducts(int lotId)
        {
            using (LotLogic logicLayer = new LotLogic())
            {
                return logicLayer.GetCompletedProductsList(lotId); 
            }
        }

        private IQueryable<LotAssignModel> GetAssignedLotsToUser(int userId)
        {
            List<LotUserMappingView> List = new List<LotUserMappingView>();
            List<LotAssignModel> NewList = new List<LotAssignModel>();
            using (LotLogic logicLayer = new LotLogic())
            {
                List = logicLayer.GetAssignedLots();
            }

            if (List.Count > 0)
            {
                NewList = (from l in List where l.UserId == userId && (l.StatusId == 2 || l.StatusId == 3)
                           select new LotAssignModel 
                           {
                               LotId = l.LotId,
                               LotName = "<a style='color:gray;font-weight:bold;' href='#' title='Click to see lot details' onclick='GotoLotDetails(" + l.LotId + ")'>" + l.LotName + "</a>", // l.LotName, 
                               StatusId = l.StatusId, 
                               userId = l.UserId, 
                               UserName = l.UserName, 
                               Status = l.Status ,
                               AcceptLink = l.StatusId == 3 ? "Accepted" : "<input type='button' value='Accept' class='rg_button_red' onclick='AcceptLot("+l.LotId+"); return false;' />"
                           }).ToList();
            }

            return NewList.AsQueryable();
        }
    }
}