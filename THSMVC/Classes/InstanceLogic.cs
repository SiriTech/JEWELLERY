using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Models;

namespace THSMVC.App_Code
{
    public class InstanceLogic : IDisposable
    {
        // Track whether Dispose has been called.
        private bool disposed = false;
        DataStoreEntities dse = new DataStoreEntities();
        public IQueryable<InstanceCls> GetInstances() 
        {
            List<InstanceCls> instances = (from e in dse.Instances
                                           //join p in dse.Instances on e.Id equals p.ParentInstance
                                               where (e.Status==null || e.Status==false)
                                           select new InstanceCls()
                                               {
                                                   Id = e.Id,
                                                   InstanceName = "<a style='color:gray;font-weight:bold;' title='Click to Edit' **** onclick=LoadContentByActionAndControllerForEdit($$$$); >" + e.Name + "</a>",
                                                   ParentInstanceName="",
                                                   From = e.LicenseStartDate,
                                                   To=e.LicenseEndDate
                                               }).ToList<InstanceCls>();
            return instances.AsQueryable();
        }
        public IQueryable<Instance> GetAllInstances()
        {
            List<Instance> instances = (from e in dse.Instances
                                           where (e.Status == null || e.Status == false)
                                        select e).ToList<Instance>();
            return instances.AsQueryable();
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
        ~InstanceLogic()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }
    }

    public class InstanceCls
    {
        public int Id { get; set; }
        public string InstanceName { get; set; }
        public string ParentInstanceName { get; set; }
        public string Country { get; set; }
        public string State { get; set; }
        public int? City { get; set; }
        public DateTime? From { get; set; }
        public DateTime? To { get; set; } 
    }
}