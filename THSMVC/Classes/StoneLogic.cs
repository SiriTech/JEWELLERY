using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Models;

namespace THSMVC.Classes
{
    public class StoneLogic: IDisposable
    {
        // Track whether Dispose has been called.
        private bool disposed = false;

        DataStoreEntities dse = new DataStoreEntities();
        int inststanceId = Convert.ToInt32(HttpContext.Current.Session["InstanceId"]);
        public IQueryable<StoneModel> GetStones()
        {
            List<StoneModel> ProductGroup = (from d in dse.Stones
                                                    where ((d.Status) == null || (bool)d.Status == false) && d.InstanceId == inststanceId
                                             select new StoneModel
                                                    {
                                                        Id = d.StoneId,
                                                        StoneName = "<a style='color:gray;font-weight:bold;' title='Click to Edit' **** onclick=$$$$; >" + d.StoneName + "</a>",
                                                        StoneShortForm=d.StoneShortForm,
                                                        StonePerCarat=d.StonePerCarat,
                                                        ChkStoneWeightless = d.IsStoneWeightless == true ? "<img src='../../images/tick.png' />" : "<img src='../../images/remove.png' />"
                                                    }).ToList<StoneModel>();
            return ProductGroup.AsQueryable();
        }
        public IQueryable<StoneModel> GetProductGroupsList()
        {
            List<StoneModel> ProductGroup = (from d in dse.Stones
                                                    where ((d.Status) == null || (bool)d.Status == false) && d.InstanceId == inststanceId
                                             select new StoneModel
                                                    {
                                                        Id = d.StoneId,
                                                        StoneName = d.StoneName
                                                    }).ToList<StoneModel>();
            return ProductGroup.AsQueryable();
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

        // Use C# destructor syntax for finalization code.
        // This destructor will run only if the Dispose method
        // does not get called.
        // It gives your base class the opportunity to finalize.
        // Do not provide destructors in types derived from this class.
        ~StoneLogic()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }
    }
}