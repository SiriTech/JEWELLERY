using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.App_Code;
using THSMVC.Models;

namespace THSMVC.Classes
{
    public class UserLogic : IDisposable
    {
        private static readonly IEncryptString _encrypter = new ConfigurationBasedStringEncrypter();
        // Track whether Dispose has been called.
        private bool disposed = false;

        DataStoreEntities dse = new DataStoreEntities();
        int inststanceId = Convert.ToInt32(HttpContext.Current.Session["InstanceId"]);
        public IQueryable<UserModel> GetUsers()
        {
            List<UserModel> Users = (from d in dse.UserDetails
                                     join u in dse.Users on d.UserId equals u.Id
                                     join r in dse.Roles on u.RoleId equals r.Id
                                     where u.InstanceId == inststanceId
                                       select new UserModel
                                                    {
                                                        Id = u.Id,
                                                        Name = "<a style='color:gray;font-weight:bold;' title='Click to Edit' **** onclick=$$$$; >" + d.Name + "</a>",
                                                        Address=d.Address,
                                                        City=d.City,
                                                        State=d.State,
                                                        PinCode=d.PinCode,
                                                        Mobile=d.Mobile,
                                                        Phone=d.Phone,
                                                        Email=u.Email,
                                                        Username=u.UserName,
                                                        Password=u.Password,
                                                        RoleId=u.RoleId,
                                                        RoleName = r.Role1,
                                                        Active = u.IsLockedOut == true ? "<img src='../../images/remove.png' />" : "<img src='../../images/tick.png' />"
                                                    }).ToList<UserModel>();
            return Users.AsQueryable();
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
        ~UserLogic()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }
    }
}