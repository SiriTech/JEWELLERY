using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Services.Logging.Log4Net;
using THSMVC.Views.Shared;
using THSMVC.Models;

namespace THSMVC.App_Code
{
    public class SecurityProvider : IDisposable
    {
        private bool disposed = false;
        private static readonly IEncryptString _encrypter = new ConfigurationBasedStringEncrypter();
        Log4NetLogger logger = new Log4NetLogger();
        DataStoreEntities dse = new DataStoreEntities();
      
        
        public UserCreateStatus CreateUser(string UserName, string Password, string Email)
        {
            try
            {
                UserCreateStatus status;
                status = ValidateUserName(UserName);
                if (status == UserCreateStatus.Success)
                {
                    status = ValidateEmail(Email);
                    if (status == UserCreateStatus.Success)
                    {
                        using (var dbDatastoreEntities = new DataStoreEntities())
                        {
                            User user = new User();

                            user.UserName = UserName;
                            user.Password = _encrypter.Encrypt(Password);
                            user.Email = Email;
                            user.CreatedDate = DateTime.Now;
                            user.CreatedBy = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                            user.IsApproved = true;
                            user.IsLockedOut = false;
                            user.ChangePwdonLogin = true;
                            dbDatastoreEntities.AddToUsers(user);
                            dbDatastoreEntities.SaveChanges(System.Data.Objects.SaveOptions.DetectChangesBeforeSave);
                        }
                        return status;
                    }
                    else
                        return status;
                }
                else
                    return status;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> CreateUser", ex);
                return UserCreateStatus.ProviderError;
            }
        }
      
        
        private UserCreateStatus ValidateUserName(string UserName)
        {
            try
            {
               
                    return UserCreateStatus.Success;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> ValidateUserName", ex);
                return UserCreateStatus.ProviderError;
            }
        }

       
        
        private UserCreateStatus ValidateEmail(string Email)
        {
            try
            {
                
                    return UserCreateStatus.Success;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> ValidateEmail", ex);
                return UserCreateStatus.ProviderError;
            }
        }

        public int MinRequiredPasswordLength { get; set; }

        internal bool ValidateUser(string userName, string password)
        {
            try
            {
                string uName = userName;
                string Pwd = _encrypter.Encrypt(password);
                User user = new User();
                user.LastLoginDate = DateTime.Now;
                var query = (from s in dse.Users
                             where s.UserName.Equals(uName)
                             & s.Password.Equals(Pwd)
                             & s.IsApproved
                             & s.IsLockedOut.Equals(false)
                             select s).ToList<User>();
                if (query.Count > 0)
                {
                    var first = query.First();
                    HttpContext.Current.Session["InstanceId"] = first.InstanceId;
                    HttpContext.Current.Session["UserID"] = first.Id;
                    HttpContext.Current.Session["ChangePwd"] = first.ChangePwdonLogin;
                    HttpContext.Current.Session["EmailId"] = first.Email;
                    HttpContext.Current.Session["RoleId"] = first.RoleId;

                    return true;
                }
                else
                    return false;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> ValidateUser", ex);
                return false;
            }
        }
        public bool GetPassword(string userName)
        {
            try
            {
                string uName = _encrypter.Decrypt("+ZQqEZYY07w=");
                string Pwd = _encrypter.Decrypt("WmZC2hY0yEA604185n48Lg==");
                    return false;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> GetPassword", ex);
                return false;
            }
        }
        public Boolean CreateLeaveTypes(string LeaveType, string ShortName, int?[] UserIds, string NoofLeaves)
        {
            try
            {
                
                return true;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> CreateLeaveTypes", ex);
                return false;
            }

        }
        public Boolean UpdateLeaveTypes(string LeaveType, string ShortName, int?[] UserIds, string NoofLeaves, string LeaveTypeId)
        {
            try
            {
                
                return true;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> UpdateLeaveTypes", ex);
                return false;
            }

        }
      
        internal UserCreateStatus GetUser(string userName, bool p)
        {
            try
            {

                string uName = userName;
                User user = new User();
                user.LastLoginDate = DateTime.Now;
                if (p)
                {
                    var query = (from s in dse.Users
                                 where s.UserName.Equals(uName)
                                 select s).ToList<User>();
                    if (query.Count > 0)
                    {
                        return UserCreateStatus.Success;
                    }
                    else
                        return UserCreateStatus.ProviderError;
                }
                else
                    return UserCreateStatus.ProviderError;
            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> GetUser", ex);
                return UserCreateStatus.ProviderError;
            }
        }

        
        public UserCreateStatus UpdateLastLoginDate(string userName)
        {
            try
            {
                string uName = userName;
                User user = new User();
                user.LastLoginDate = DateTime.Now;
                var query = (from s in dse.Users
                             where s.UserName.Equals(uName)
                             select s).ToList<User>();
                if (query.Count > 0)
                {
                    var first = query.First();
                    first.LastLoginDate = DateTime.Now;
                    dse.SaveChanges();
                    return UserCreateStatus.Success;
                }
                else
                    return UserCreateStatus.ProviderError;
            }
            catch (Exception ex)
            {

                logger.Error("SecurityProvider --> UpdateLastLoginDate", ex);
                return UserCreateStatus.ProviderError;
            }
        }

        internal bool ChangePassword(string userName, string oldPassword, string newPassword)
        {
            try
            {
                string uName = userName;
                string pwd = _encrypter.Encrypt(newPassword);
                string oldPwd = _encrypter.Encrypt(oldPassword);
                User user = new User();
                user.LastLoginDate = DateTime.Now;

                var query = (from s in dse.Users
                             where s.UserName.Equals(uName) && s.Password.Equals(oldPwd)
                             select s).ToList<User>();
                if (query.Count > 0)
                {
                    var first = query.First();
                    first.Password = pwd;
                    first.ChangePwdonLogin = false;
                    dse.SaveChanges();
                    HttpContext.Current.Session["ChangePwd"] = false;
                    return true;
                }
                else
                    return false;

            }
            catch (Exception ex)
            {
                logger.Error("SecurityProvider --> ChangePassword", ex);
                return false;
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

        // Use C# destructor syntax for finalization code.
        // This destructor will run only if the Dispose method
        // does not get called.
        // It gives your base class the opportunity to finalize.
        // Do not provide destructors in types derived from this class.
        ~SecurityProvider()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }
    }
}