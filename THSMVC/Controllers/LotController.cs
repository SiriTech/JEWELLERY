using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Views.Shared;
using THSMVC.Models;
using THSMVC.App_Code;

namespace THSMVC.Controllers
{
    public class LotController: Controller
    {
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
            return View(model);
        }
        [HttpPost]
        public ActionResult CreateLot(LotMasterModel objLotMasterModel)
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
                result = logicLayer.CreateLot(lot);
            }
            if (result)
                return Json(new { success = true, msg = "Successfully Lot is created." });
            else
                return Json(new { success = false, msg = "Error while creating Lot. Please try again." });
        }
    }
}