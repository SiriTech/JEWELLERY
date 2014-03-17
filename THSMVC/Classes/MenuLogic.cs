using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Models;

namespace THSMVC.App_Code
{
    public class  MenuLogic : IDisposable
    {
        // Track whether Dispose has been called.
        private bool disposed = false;
        DataStoreEntities dse = new DataStoreEntities();
        public IQueryable<Menu> GetMenus(string InstanceId)
        {
            
            if (InstanceId == "")
            {
                List<Menu> menu = (from d in dse.Menus where (d.Status == null || d.Status == false) && d.Level == 0 && d.ParentId == null && d.InstanceId == null orderby d.Order ascending select d).ToList<Menu>();
                return menu.AsQueryable();
            }
            else
            {
                int instanceId = Convert.ToInt32(InstanceId);
                int roleId = Convert.ToInt32(HttpContext.Current.Session["RoleId"]);
                List<Menu> menu = (from d in dse.Menus join s in dse.RoleMenus on d.Id equals s.MenuId where (d.Status == null || d.Status == false) && (s.Status == null || s.Status == false) && d.Level == 0 && d.ParentId == null && d.InstanceId == instanceId && s.RoleId == roleId orderby d.Order ascending select d).ToList<Menu>();
                return menu.AsQueryable();
            }
        }
        public int GetOrder(CreateMenuModel model)
        {
                int instanceId = Convert.ToInt32(model.InstanceId);
                int menuId = Convert.ToInt32(model.MenuId);
                int groupId = Convert.ToInt32(model.GroupId);
                if (menuId == 0)
                {
                    var order = (from d in dse.Menus where (d.Status == null || d.Status == false) && d.ParentId == null && d.InstanceId == instanceId && d.GroupId == groupId select d.Order).Max();
                    return order;
                }
                else
                {
                    var order = (from d in dse.Menus where (d.Status == null || d.Status == false) && d.ParentId == menuId && d.InstanceId == instanceId && d.GroupId == groupId select d.Order).Max();
                    return order;
                }
        }
        internal IQueryable<Menu> GetFirstMenu(string InstanceId)
        {
            if (InstanceId == "")
            {
                List<Menu> menu = (from d in dse.Menus where (d.Status == null || d.Status == false) && d.Level == 0 && d.Order == 0 && d.ParentId == null && d.InstanceId == null orderby d.Order ascending select d).ToList<Menu>();
                return menu.AsQueryable();
            }
            else
            {
                int instanceId = Convert.ToInt32(InstanceId);
                List<Menu> menu = (from d in dse.Menus where (d.Status == null || d.Status == false) && d.Level == 0 && d.Order == 0 && d.ParentId == null && d.InstanceId == instanceId orderby d.Order ascending select d).ToList<Menu>();
                return menu.AsQueryable();
            }
        }
        internal IQueryable<LeftMenu> GetLeftMenu(string InstanceId, string MenuId)
        {
            int Id= Convert.ToInt32(MenuId);
            if (InstanceId == "")
            {
                List<LeftMenu> menu = (from d in dse.Menus join s in dse.MenuGroups on d.GroupId equals s.Id
                                   where (d.Status == null || d.Status == false) && d.Level == 1 && d.ParentId == Id && d.InstanceId == null 
                                   orderby d.GroupId ascending select new LeftMenu() { MenuId=d.Id, MenuName=d.Name, Action = d.Action, Controller=d.Controller, GroupName= s.GroupName }).ToList<LeftMenu>();
                return menu.AsQueryable();
            }
            else
            {
                int instanceId = Convert.ToInt32(InstanceId);
                int roleId = Convert.ToInt32(HttpContext.Current.Session["RoleId"]);
                List<LeftMenu> menu = (from d in dse.Menus
                                       join s in dse.MenuGroups on d.GroupId equals s.Id
                                       join r in dse.RoleMenus on d.Id equals r.MenuId
                                       where (d.Status == null || d.Status == false) && (r.Status == null || r.Status == false) && d.Level == 1 && d.ParentId == Id && d.InstanceId == instanceId && r.RoleId == roleId
                                       orderby d.GroupId ascending ,d.Order ascending
                                       select new LeftMenu() { MenuId = d.Id, MenuName = d.Name, Action = d.Action, Controller = d.Controller, GroupName = s.GroupName }).ToList<LeftMenu>();
                return menu.AsQueryable();
            }
        }
        internal IQueryable<UserBasedRights> GetRightsBasedMenuId(string MenuId)
        {
            int Menuid = Convert.ToInt32(MenuId);
            int InstanceId = Convert.ToInt32(HttpContext.Current.Session["InstanceId"]);
            int roleId = Convert.ToInt32(HttpContext.Current.Session["RoleId"]);
            int userId = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
            DataStoreEntities dse = new DataStoreEntities();
            List<UserBasedRights> right = (from d in dse.UserMenus
                                           join u in dse.Rights on d.Id equals u.UserMenuId
                                           join mr in dse.MenuRights on u.MenuRightId equals mr.Id
                                           where (d.Status == null || d.Status == false) && d.MenuId == Menuid && d.InstanceId == InstanceId && d.RoleId == roleId && d.UserId == userId
                                           select new UserBasedRights() { RightId = u.Id, RightName = mr.MenuRight1, Flag = u.Flag }).ToList<UserBasedRights>();
            return right.AsQueryable();
        }
        internal IQueryable<UserBasedMenu> GetFirstMenuByMenuId(string InstanceId, string MenuId)
        {
            int Id = Convert.ToInt32(MenuId);
            if (InstanceId == "")
            {
                List<UserBasedMenu> menu = (from d in dse.Menus
                                            where (d.Status == null || d.Status == false) && d.Id == Id && d.InstanceId == null
                                            orderby d.Order ascending
                                            select new UserBasedMenu() { MenuId = d.Id, MenuName = d.Name, Action = d.Action, Controller = d.Controller, GroupId = d.GroupId }).ToList<UserBasedMenu>();
                return menu.AsQueryable();
            }
            else
            {
                int instanceId = Convert.ToInt32(InstanceId);
                int roleId = Convert.ToInt32(HttpContext.Current.Session["RoleId"]);
                int userId = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
                DateTime dt = DateTime.Today;
                List<UserBasedMenu> menu = (from d in dse.Menus
                                            join u in dse.UserMenus on d.Id equals u.MenuId
                                            where (d.Status == null || d.Status == false) && d.Id == Id && d.InstanceId == instanceId && u.RoleId == roleId && u.UserId == userId && dt >= u.FromDate && dt < u.ToDate && u.Flag==true
                                            orderby d.Order ascending
                                            select new UserBasedMenu() { MenuId=d.Id,MenuName=d.Name,Action=d.Action,Controller=d.Controller,GroupId=d.GroupId }).ToList<UserBasedMenu>();
                if (menu.Count <= 0)
                {
                    List<UserBasedMenu> menuflag = (from d in dse.Menus
                                                    join u in dse.UserMenus on d.Id equals u.MenuId
                                                    where (d.Status == null || d.Status == false) && d.Id == Id && d.InstanceId == instanceId && u.RoleId == roleId && u.UserId == userId && dt >= u.FromDate && dt < u.ToDate
                                                    orderby d.Order ascending
                                                    select new UserBasedMenu() { MenuId=d.Id,MenuName=d.Name,Action=d.Action,Controller=d.Controller,GroupId=d.GroupId,flag=u.Flag,FromDate=u.FromDate,ToDate=u.ToDate }).ToList<UserBasedMenu>();
                    if (menuflag.Count <= 0)
                    {
                        List<UserBasedMenu> menuoutofdates = (from d in dse.Menus
                                                        join u in dse.UserMenus on d.Id equals u.MenuId
                                                        where (d.Status == null || d.Status == false) && d.Id == Id && d.InstanceId == instanceId && u.RoleId == roleId && u.UserId == userId 
                                                        orderby d.Order ascending
                                                        select new UserBasedMenu() { MenuId = d.Id, MenuName = d.Name, Action = d.Action, Controller = d.Controller, GroupId = d.GroupId, flag = u.Flag, FromDate = u.FromDate, ToDate = u.ToDate }).ToList<UserBasedMenu>();
                        if (menuoutofdates.Count > 0)
                        {
                            if (menuoutofdates.First().flag == false)
                                menuoutofdates.First().flag = null;
                            else
                                menuoutofdates.First().flag = false;

                            return menuoutofdates.AsQueryable();
                        }
                        else
                            return menuoutofdates.AsQueryable(); 
                    }
                    return menuflag.AsQueryable();
                }
                return menu.AsQueryable();
            }
        }
        internal IQueryable<Menu> GetParentMenu(string InstanceId)
        {
            if (InstanceId == "")
            {
                List<Menu> menu = (from d in dse.Menus where (d.Status == null || d.Status == false) && d.Level == 0 && d.Order == 0 && d.ParentId == null && d.InstanceId == null orderby d.Order ascending select d).ToList<Menu>();
                return menu.AsQueryable();
            }
            else
            {
                int instanceId = Convert.ToInt32(InstanceId);
                List<Menu> menu = (from d in dse.Menus where (d.Status == null || d.Status == false) && d.Level == 0 && d.ParentId == null && d.InstanceId == instanceId orderby d.Order ascending select d).ToList<Menu>();
                return menu.AsQueryable();
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
        ~MenuLogic()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }



       
    }
    public class LeftMenu
    { 
        public int MenuId { get; set; }
        public string MenuName { get; set; }
        public string Action { get; set; }
        public string Controller { get; set; }
        public string GroupName { get; set; }
    }
    public class UserBasedMenu
    {
        public int MenuId { get; set; }
        public string MenuName { get; set; }
        public string Action { get; set; }
        public string Controller { get; set; }
        public string GroupName { get; set; }
        public bool? flag { get; set; }
        public int? GroupId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }

    }
    public class UserBasedRights 
    {
        public int RightId { get; set; }
        public string RightName { get; set; }
        public bool Flag { get; set; }

    }
}