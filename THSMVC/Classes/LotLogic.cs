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
                                             join pg in dse.ProductGroups on d.ProductGroupId equals pg.Id
                                             join de in dse.Dealers on d.DealerId equals de.DealerId into lj
                                             from lm in lj.DefaultIfEmpty()
                                             where d.InstanceId == inststanceId
                                             select new LotMasterModel()
                                             {
                                                DealerId = (int)d.DealerId,
                                                LotId = d.LotId,
                                                LotName = "<a style='color:gray;font-weight:bold;' title='Click to Edit' **** onclick=$$$$; >" + d.LotName + "</a>",
                                                ProductGroupId = d.ProductGroupId,
                                                Qty = (double) d.NoOfPieces,
                                                Weight = (double) d.Weight,
                                                IsMRP=d.IsMRP,
                                                MRP=d.MRP,
                                                DiffAllowed=d.DiffAllowed,
                                                ProductGroup = pg.ProductGroup1,
                                                Dealer=lm.DealerName
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
                lot.IsMRP = objLot.IsMRP;
                lot.MRP = objLot.MRP;
                lot.DiffAllowed = objLot.DiffAllowed;

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
                         DiffAllowed = lot.DiffAllowed == null ?0: (decimal)lot.DiffAllowed,
                         IsMRP = lot.IsMRP == null ? false : (bool)lot.IsMRP,
                         LotId = lot.LotId,
                         LotName = lot.LotName,
                         MRP = lot.MRP == null ? 0 : (decimal)lot.MRP,
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
            return (from lotMapping in dse.LotUserMappingViews where lotMapping.InstanceId == inststanceId select lotMapping).ToList();
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

        public bool InsertBarcode(Barcode objBarcode, out string respMsg, out int assignedCount, out int completedCount)
        {
            respMsg = string.Empty;
            assignedCount = 0;
            completedCount = 0;
            //int AssignedNoOfPieces = 0;
            try
            {
                Lot lot = dse.Lots.Where(x=>x.LotId == objBarcode.LotId).FirstOrDefault();
                if(lot != null)
                    assignedCount = (int)lot.NoOfPieces;

                List<Barcode> CompletedBarcodes = dse.Barcodes.Where(x=>x.LotId == objBarcode.LotId).ToList();
                completedCount = CompletedBarcodes.Count;

                if (CompletedBarcodes.Count >= assignedCount)
                {
                    respMsg = "No Of pieces Count has been exceeded. Assigned Count : " + assignedCount + " , Completed products so far : " + CompletedBarcodes.Count;
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

                Lot lot = dse.Lots.Where(x => x.LotId == lotId).FirstOrDefault();
                if (lot != null)
                    assignedCount = (int)lot.NoOfPieces;

                List<Barcode> CompletedBarcodes = dse.Barcodes.Where(x => x.LotId == lotId).ToList();
                completedCount = CompletedBarcodes.Count;

                if (CompletedBarcodes.Count <= assignedCount)
                {
                    foreach (Barcode b in CompletedBarcodes)
                    {
                        b.IsSubmitted = true;
                    }

                    LotUserMapping lu = dse.LotUserMappings.Where(x => x.LotId == lotId).FirstOrDefault();
                    lu.StatusId = 4;
                    dse.SaveChanges();
                    result = true;
                }
                else
                {
                    respMsg = "Completed Products count is greater than Assigned Product Count. Please verify.";
                    result = false;
                }
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }

        public Barcode GetBarcodeById(int id)
        {
            return dse.Barcodes.Where(x => x.BarcodeId == id).FirstOrDefault();
        }

        public void GetAssinedAndCompletedCount(int lotId, out int assignedCount, out int completedCount)
        {
            assignedCount = 0;
            completedCount = 0;
            //int AssignedNoOfPieces = 0;
            try
            {
                Lot lot = dse.Lots.Where(x => x.LotId == lotId).FirstOrDefault();
                if (lot != null)
                    assignedCount = (int)lot.NoOfPieces;

                List<Barcode> CompletedBarcodes = dse.Barcodes.Where(x => x.LotId == lotId).ToList();
                completedCount = CompletedBarcodes.Count;
            }
            catch (Exception ex)
            {
            }
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