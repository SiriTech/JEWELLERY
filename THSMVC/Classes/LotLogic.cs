using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Models;

using System.Data.Objects.SqlClient;

using THSMVC.Classes;


namespace THSMVC.App_Code
{
    public class LotLogic : IDisposable
    {
        // Track whether Dispose has been called.
        private bool disposed = false;
        DataStoreEntities dse = new DataStoreEntities();

        #region Lot
        int inststanceId = Convert.ToInt32(HttpContext.Current.Session["InstanceId"]);
        public IQueryable<LotMasterModel> GetLots()
        {
            

            List<LotMasterModel> Userinfo = (from d in dse.Lots
                                             where d.InstanceId == inststanceId
                                             select new LotMasterModel()
                                             {
                                                DealerId = (int)d.DealerId,
                                                LotId = d.LotId,
                                                LotName = "<a style='color:gray;font-weight:bold;' title='Click to Edit' **** onclick=$$$$; >" + d.LotName + "</a>",
                                                ProductGroupId = d.ProductGroupId,
                                                Qty = (double) d.NoOfPieces,
                                                Weight = (double) d.Weight
                                             }).ToList<LotMasterModel>();
            return Userinfo.AsQueryable();
        }

        public List<Lot> GetAllLots()
        {
            List<int> lotMappings = dse.LotUserMappings.Select(x=>x.LotId).ToList();
            return (from pg in dse.Lots
                    join lm in dse.LotUserMappings on pg.LotId equals lm.LotId into lj
                    from lm in lj.DefaultIfEmpty()
                    where !lotMappings.Contains(pg.LotId) && pg.InstanceId == inststanceId
                    select pg).ToList();
        }

        public bool CreateLot(Lot objLot)
        {
            try
            {
                dse.Lots.AddObject(objLot);
                dse.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateLot(Lot objLot)
        {

            try
            {
                Lot lot = dse.Lots.Where(x => x.LotId == objLot.LotId).FirstOrDefault();
                lot.DealerId = objLot.DealerId;
                lot.LotName = objLot.LotName;
                lot.NoOfPieces = (int)objLot.NoOfPieces;
                lot.ProductGroupId = objLot.ProductGroupId;
                lot.Weight = (int)objLot.Weight;

                // dse.Lots.AddObject(objLot);
                dse.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public LotMasterModel GetLotModelById(int Id)
        {
            LotMasterModel model = new LotMasterModel();

            model = (from lot in dse.Lots
                     where lot.LotId == Id
                     select new LotMasterModel()
                     {
                         DealerId = lot.DealerId == null ? 0:  (int)lot.DealerId,
                         DiffAllowed = lot.DiffAllowed == null ?0: (double)lot.DiffAllowed,
                         IsMRP = lot.IsMRP == null ? false : (bool)lot.IsMRP,
                         LotId = lot.LotId,
                         LotName = lot.LotName,
                         MRP = lot.MRP == null ? 0 : (double)lot.MRP,
                         ProductGroupId = lot.ProductGroupId,
                         Qty = lot.NoOfPieces == null ? 0 : (double)lot.NoOfPieces,
                         Weight = lot.Weight == null ? 0 : (double)lot.Weight
                     }).FirstOrDefault();

            return model;
        }

        public bool AcceptLot(int lotId)
        {
            try
            {
                LotUserMapping lot = dse.LotUserMappings.Where(x => x.LotId == lotId).FirstOrDefault();
                lot.StatusId = 3;
                // dse.Lots.AddObject(objLot);
                dse.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public LotDetailsModel GetLotDetailsById(int lotId)
        {
            LotDetailsModel model = new LotDetailsModel();

            try
            {
                model = (from lot in dse.ViewLotDetails where lot.LotId == lotId
                         select new LotDetailsModel
                         {
                             LotId = lot.LotId,
                             DealerId = (int)lot.DealerId,
                             DiffAllowed = (double)lot.DiffAllowed,
                             IsMRP = (bool)lot.IsMRP,
                             LotName = lot.LotName,
                             //MRP = lot.MRP,
                             NoOfPcs = (double)lot.NoOfPieces,
                             ProductGroupId = lot.ProductGroupId,
                             ProductGroupName = lot.ProductGroup,
                             Weight = (double)(((bool)lot.IsMRP) ? lot.MRP : lot.Weight)
                         }).FirstOrDefault();

                Classes.ProductLogic productLogic = new Classes.ProductLogic();

                List<Product> productList = productLogic.GetProductsList();
                model.ProductList = productList.Where(x => x.ProductGroupId == model.ProductGroupId).ToList();
            }
            catch (Exception ex)
            {

            }
 
            return model;
        }

        #endregion

        public IQueryable<User> GetUsers()
        {
            List<User> Userinfo = (from u in dse.Users
                                   join ud in dse.UserDetails on u.Id equals ud.UserId
                                   where u.InstanceId==inststanceId
                                   select u).ToList<User>();
            return Userinfo.AsQueryable();
        }

        public List<ProductGroup> GetAllProductGroups()
        {
            return (from pg in dse.ProductGroups where (pg.Status == null || pg.Status == false) && pg.InstanceId == inststanceId select pg).ToList();
        }

        public List<Dealer> GetAllDealers()
        {
            return (from dealer in dse.Dealers where (dealer.Status == null || dealer.Status == false) && dealer.InstanceId == inststanceId select dealer).ToList();
        }

        public bool AssignLot(int LotId, int UserId, int StatusId,out string msg)
        {
            LotUserMapping obj = new LotUserMapping
            {
                LotId = LotId,
                UserId = UserId,
                StatusId = StatusId
            };
            int InstanceID = Convert.ToInt32(HttpContext.Current.Session["InstanceId"]);
            bool IsSms = dse.Settings.Where(x => x.InstanceId == inststanceId).Select(x => x.SMS).FirstOrDefault();
            string mesg = string.Empty;
            if (IsSms)
            {
                UserDetail userDetail = dse.UserDetails.Where(x => x.UserId == UserId).FirstOrDefault();
                string MobNumber = userDetail.Mobile==null?"":userDetail.Mobile;
                if (MobNumber != "")
                {
                    string LotName = dse.Lots.Where(x=>x.LotId == LotId).Select(x=>x.LotName).FirstOrDefault();
                    Random random = new Random();
                    int randomNumber = random.Next(1000, 9999);
                    obj.OTCode = randomNumber;
                    SMSLogic smsLogic = new SMSLogic();
                    smsLogic.SendPSMS("Lot(" + LotName + ") assigned to you. Please use one time password "+randomNumber.ToString()+" to accept Lot.", MobNumber);
                }
                else
                    mesg = "No Mobile Number";
            }
            try
            {
                dse.LotUserMappings.AddObject(obj);
                dse.SaveChanges();
                msg = mesg;
                return true;
            }
            catch (Exception ex)
            {
                msg = "";
                return false;
            }
        }

        public List<LotUserMappingView> GetAssignedLots()
        {
            return (from lotMapping in dse.LotUserMappingViews 
                    where lotMapping.InstanceId == inststanceId 
                    select lotMapping
                    ).ToList();
        }

        public List<LotUserMappingModel> GetAllAssignedLots()
        {
            return (from lotMapping in dse.LotUserMappingViews
                    where lotMapping.InstanceId == inststanceId
                    select new LotUserMappingModel
                    {
                        LotId = lotMapping.LotId,
                        LotName = (lotMapping.StatusId == 3 || lotMapping.StatusId == 4) ? "<a style='color:gray;font-weight:bold;text-decoration: underline; cursor: pointer;' title='Click to edit' onclick='CloseLot(" + SqlFunctions.StringConvert((decimal?)lotMapping.LotId) + ")'> " + lotMapping.LotName + " </a>" : lotMapping.LotName, //lotMapping.LotName,
                        Status = lotMapping.Status,
                        StatusId = lotMapping.StatusId,
                        UserId = lotMapping.UserId,
                        UserName = lotMapping.UserName
                    }
                    ).ToList();
        }

        public List<StoneModel> GetStoneList()
        {
            return (from s in dse.Stones
                    select new StoneModel
                    {
                        StoneId = s.StoneId,
                        StoneName = s.StoneName
                    }).ToList<StoneModel>();

        }

        public List<CompletedBarcodeModel> GetCompletedProductsList(int lotId)
        {
            List<CompletedBarcodeModel> list = new List<CompletedBarcodeModel>();
            try
            {
                list =(from d in dse.GetCompletedButNotSubmittedProducts
                        where d.IsSubmitted == false && d.LotId == lotId
                        select new CompletedBarcodeModel
                        {
                            BarcodeId = d.BarcodeId,
                            BarcodeNumber = d.BarcodeNumber,
                            GrossWeight = (double)d.GrossWeight,
                            IsSubmitted = d.IsSubmitted,
                            LotId = d.LotId,
                            NetWeight = (double)d.NetWeight,
                            NoOfPieces = d.NoOfPieces,
                            Notes = d.Notes,
                            Price = (double)d.Price,
                            ProductId = (int) d.ProductId,
                            ProductName = d.ProductName, //"<a style='color:gray;font-weight:bold;text-decoration: underline; cursor: pointer;' title='Click to edit' onclick='EditBarcode(" + SqlFunctions.StringConvert((decimal?)d.BarcodeId) + ")'> " + d.ProductName + " </a>", // l.LotName,  d.ProductName,
                            WeightMeasure = d.WeightMeasure,
                            Edit = "<a style='color:gray;font-weight:bold;' href='#' title='Click to edit' onclick='EditLot(" + SqlFunctions.StringConvert((decimal?)d.BarcodeId) + ")'> Edit </a>", // l.LotName, 
                            Delete = "<a style='color:gray;font-weight:bold;' href='#' title='Click to Delete' onclick='DeleteLot(" + SqlFunctions.StringConvert((decimal?)d.BarcodeId) + ")'> Delete </a>" // l.LotName, 
                        }).ToList();
            }
            catch (Exception ex)
            {

            }
            return list;
        }

        public bool InsertBarcode(Barcode objBarcode, out string respMsg, out int assignedCount, out int completedCount, out double assignedWeight, out double completedWeight, out double assignedMrp, out double completedMRP)
        {
            respMsg = string.Empty;
            assignedCount = 0;
            completedCount = 0;
            completedWeight = 0;
            assignedWeight = 0;
            double allowDiff = 0;
            assignedMrp = 0;
            completedMRP = 0;
            //int AssignedNoOfPieces = 0;
            try
            {
                Lot lot = dse.Lots.Where(x=>x.LotId == objBarcode.LotId).FirstOrDefault();
                if (lot != null)
                {
                    assignedCount = lot.NoOfPieces == null ? 0: (int)lot.NoOfPieces;
                    assignedWeight = lot.Weight == null ? 0 : (double)lot.Weight;
                    allowDiff = lot.DiffAllowed == null ? 0 : (double)lot.DiffAllowed;
                    assignedMrp = lot.MRP == null ? 0 : (double)lot.MRP;
                }

                List<Barcode> CompletedBarcodes = dse.Barcodes.Where(x=>x.LotId == objBarcode.LotId).ToList();
                completedCount = CompletedBarcodes.Count;

                foreach (Barcode b in CompletedBarcodes)
                {
                    completedWeight += (double)b.GrossWeight;
                    completedMRP += (double)b.Price;
                }

                //Checking with the Lot Count and Completed Product Count
                if (CompletedBarcodes.Count >= assignedCount)
                {
                    respMsg = "No Of pieces Count has been exceeded. Assigned Count : " + assignedCount + " , Completed products so far : " + CompletedBarcodes.Count;
                    return false;
                }

                //Checking with the Weight
                if ((assignedWeight + allowDiff < completedWeight) || (assignedWeight - allowDiff < completedWeight))
                {
                    respMsg = "Weight has been exceeded. Lot Weightt : " + assignedWeight + " , Completed Products Weight so far : " + completedWeight;
                    return false;
                }

                //Checking with Price
                if (assignedMrp < completedMRP)
                {
                    respMsg = "MRP has been exceeded. Lot MRP : " + assignedMrp + " , Completed Products MRP so far : " + completedMRP;
                    return false;
                }

                if ((assignedWeight + allowDiff < completedWeight + (double)objBarcode.GrossWeight) || (assignedWeight - allowDiff < completedWeight + (double)objBarcode.GrossWeight))
                {
                    respMsg = "Weight is going to be exceeded if you add this Product. Lot Weight : " + assignedWeight + " , Completed Products Weight so far : " + completedWeight;
                    return false;
                }

                if (assignedMrp < completedMRP + (double)objBarcode.Price)
                {
                    respMsg = "MRP is going to be exceeded if you add this Product. Lot MRP : " + assignedMrp + " , Completed Products MRP so far : " + completedMRP;
                    return false;
                }
                
                //Todo : Need to check Count of the Assigned Quantity and Completed Quantity
                dse.Barcodes.AddObject(objBarcode);
                dse.SaveChanges();
                CompletedBarcodes = dse.Barcodes.Where(x => x.LotId == objBarcode.LotId).ToList();
                completedCount = CompletedBarcodes.Count;
                return true;
            }
            catch (Exception ex)
            {
                respMsg = "Error while printing the barcode.";
                return false;
            }
        }

        public bool InsertBarcode(Barcode objBarcode)
        {
            try
            {
                Barcode barcodeToUpdate = dse.Barcodes.Where(x => x.BarcodeId == objBarcode.BarcodeId).FirstOrDefault();
                barcodeToUpdate.BarcodeNumber = objBarcode.BarcodeNumber;
                barcodeToUpdate.GrossWeight = objBarcode.GrossWeight;
                barcodeToUpdate.IsSubmitted = objBarcode.IsSubmitted;
                barcodeToUpdate.LotId = objBarcode.LotId;
                barcodeToUpdate.NetWeight = objBarcode.NetWeight;
                barcodeToUpdate.NoOfPieces = objBarcode.NoOfPieces;
                barcodeToUpdate.Notes = objBarcode.Notes;
                barcodeToUpdate.Price = objBarcode.Price;
                barcodeToUpdate.ProductId = objBarcode.ProductId;
                barcodeToUpdate.WeightMeasure = objBarcode.WeightMeasure;

                dse.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        public bool DeleteBarcode(int barcodeId)
        {
            try
            {
                Barcode delete = dse.Barcodes.Where(x => x.BarcodeId == barcodeId).FirstOrDefault();
                dse.Barcodes.DeleteObject(delete);
                dse.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SubmitLot(int lotId, out string respMsg)
        {
            respMsg = string.Empty;
            bool result = false;
            try
            {
                int assignedCount = 0;
                int completedCount = 0;
                double completedWeight = 0;
                double lotWeight = 0;
                double allowDiff = 0;
                double lotMRP = 0;
                double completedMRP = 0;

                Lot lot = dse.Lots.Where(x => x.LotId == lotId).FirstOrDefault();
                if (lot != null)
                {
                    assignedCount = lot.NoOfPieces == null ? 0 : (int)lot.NoOfPieces;
                    lotWeight = lot.Weight == null ? 0 : (double)lot.Weight;
                    allowDiff = lot.DiffAllowed == null ? 0 : (double)lot.DiffAllowed;
                    lotMRP = lot.MRP == null ? 0 : (double)lot.MRP;
                }

                List<Barcode> CompletedBarcodes = dse.Barcodes.Where(x => x.LotId == lotId).ToList();
                completedCount = CompletedBarcodes.Count;

                foreach (Barcode b in CompletedBarcodes)
                {
                    completedWeight += (double)b.GrossWeight;
                    completedMRP += (double)b.Price;
                    b.IsSubmitted = true;
                }

                //Checking with the Lot Count and Completed Product Count
                if (CompletedBarcodes.Count > assignedCount)
                {
                    respMsg = "No Of pieces Count has been exceeded. Assigned Count : " + assignedCount + " , Completed products so far : " + CompletedBarcodes.Count + "</br> Can not close the Lot";
                    return false;
                }

                //Checking with the Weight
                if ((lotWeight + allowDiff < completedWeight) || (lotWeight - allowDiff < completedWeight))
                {
                    respMsg = "Weight has been exceeded. Lot Weightt : " + lotWeight + " , Completed Products Weight so far : " + completedWeight + "</br> Can not close the Lot";
                    return false;
                }

                //Checking with Price
                if (lotMRP < completedMRP)
                {
                    respMsg = "MRP has been exceeded. Lot MRP : " + lotMRP + " , Completed Products MRP so far : " + completedMRP + "</br> Can not close the Lot";
                    return false;
                }

                LotUserMapping lu = dse.LotUserMappings.Where(x => x.LotId == lotId).FirstOrDefault();
                lu.StatusId = 4;
                dse.SaveChanges();
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
                respMsg = "An Error occured while Submitting the Lot";
            }
            return result;
        }

        public bool CloseLot(int lotId, out string respMsg)
        {
            respMsg = string.Empty;

            bool result = false;
            try
            {
                LotUserMapping lu = dse.LotUserMappings.Where(x => x.LotId == lotId).FirstOrDefault();
                if (lu != null && lu.StatusId == 5)
                {
                    respMsg = "This Lot is already Closed.";
                    return false;
                }
                lu.StatusId = 5;
                dse.SaveChanges();
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
                respMsg = "An Error occured while Closing the Lot";
            }
            return result;
        }

        public Barcode GetBarcodeById(int id)
        {
            return dse.Barcodes.Where(x => x.BarcodeId == id).FirstOrDefault();
        }

        public void GetAssinedAndCompletedCount(int lotId, out int assignedCount, out int completedCount, out double assignedWeight, out double completedWeight, out double assignedMrp, out double completedMRP)
        {
            assignedCount = 0;
            completedCount = 0;
            completedWeight = 0;
            assignedWeight = 0;
            assignedMrp = 0;
            completedMRP = 0;
            //int AssignedNoOfPieces = 0;
            try
            {
                Lot lot = dse.Lots.Where(x => x.LotId == lotId).FirstOrDefault();
                if (lot != null)
                {
                    assignedCount = lot.NoOfPieces == null ? 0 : (int)lot.NoOfPieces;
                    assignedWeight = lot.Weight == null ? 0 : (double)lot.Weight;
                    assignedMrp = lot.MRP == null ? 0 : (double)lot.MRP;
                }

                List<Barcode> CompletedBarcodes = dse.Barcodes.Where(x => x.LotId == lotId).ToList();
                completedCount = CompletedBarcodes.Count;

                foreach (Barcode b in CompletedBarcodes)
                {
                    completedWeight += (double)b.GrossWeight;
                    completedMRP += (double)b.Price;
                }
            }
            catch (Exception ex)
            {
            }
        }

        public LotCloseModel GetCloseLotDetails(int lotId)
        {
            LotCloseModel model = new LotCloseModel();

            double ActualWeight = 0;
            double WeightCompleted = 0;
            decimal MRPCompleted = 0;
            int NoOfPcsCompleted = 0;
            int NoOfPcsPending = 0;
            double WeightPending = 0;
            double DiffAllowedActual = 0;

            LotUserMappingView mapping = dse.LotUserMappingViews.Where(x=>x.LotId == lotId).FirstOrDefault();
            if (mapping != null)
            {
                model.LotStatisID = mapping.StatusId;
            }


            LotDetailsModel lotDetials = GetLotDetailsById(lotId);
            if (lotDetials != null)
            {
                model.DiffAllowed = lotDetials.DiffAllowed;
                model.IsMRP = lotDetials.IsMRP;
                model.LotId = lotDetials.LotId;
                model.LotName = lotDetials.LotName;
                model.MRP = lotDetials.MRP;
                model.NoOfPcs = (int)lotDetials.NoOfPcs;
                model.ProductGroupId = lotDetials.ProductGroupId;
                model.ProductGroupName = lotDetials.ProductGroupName;
                model.ProductId = lotDetials.ProductId;
                model.Weight = lotDetials.Weight;
            }

            List<Barcode> CompletedBarcodes = dse.Barcodes.Where(x => x.LotId == lotId).ToList();
           
            foreach (Barcode b in CompletedBarcodes)
            {
                WeightCompleted = WeightCompleted + (double)b.GrossWeight;
                MRPCompleted = MRPCompleted + b.Price;
            }
            NoOfPcsCompleted = CompletedBarcodes.Count;
            NoOfPcsPending = model.NoOfPcs - NoOfPcsCompleted;
            WeightPending = model.Weight - WeightCompleted;
            DiffAllowedActual = model.Weight - WeightCompleted;

            model.DiffAllowedActual = DiffAllowedActual;
            model.MRPCompleted = (double)MRPCompleted;
            model.NoOfPcsCompleted = NoOfPcsCompleted;
            model.NoOfPcsPending = NoOfPcsPending;
            model.WeightCompleted = WeightCompleted;
            model.WeightPending = WeightPending;

            return model;
        }

        public double GetCalculatedStonePrice(int stoneId, double weight)
        {
            
            double result = 0;
            int stonePerCarat = 0;

            try
            {
                Stone stone = dse.Stones.Where(x => x.StoneId == stoneId).FirstOrDefault();
                if (stone != null)
                    stonePerCarat = (int)stone.StonePerCarat;

                // 1grm = 5 carats
                result = weight * 5 * stonePerCarat;
            }
            catch (Exception ex)
            {
                //Todo: Log Error
                result = 0;
            }
            return result;
        }

        // Implement IDisposable.
        // Do not make this method virtual.
        // A derived class should not be able to override this method.
        public void Dispose()
        {
            Dispose(true);
            // This object will be cleaned up by the Dispose method.
            // Therefore, you should call GC.SupressFinalize to
            // take this object off the finalization queue
            // and prevent finalization code for this object
            // from executing a second time.
            GC.SuppressFinalize(this);
        }
        // Dispose(bool disposing) executes in two distinct scenarios.
        // If disposing equals true, the method has been called directly
        // or indirectly by a user's code. Managed and unmanaged resources
        // can be disposed.
        // If disposing equals false, the method has been called by the
        // runtime from inside the finalizer and you should not reference
        // other objects. Only unmanaged resources can be disposed.
        protected virtual void Dispose(bool disposing)
        {
            // Check to see if Dispose has already been called.
            if (!this.disposed)
            {
                // If disposing equals true, dispose all managed
                // and unmanaged resources.
                if (disposing)
                {
                    // Dispose managed resources.
                    dse.Dispose();
                }

                // Note disposing has been done.
                disposed = true;

            }
        }
    }
}