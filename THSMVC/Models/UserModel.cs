using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.App_Code;
using THSMVC.Classes;

namespace THSMVC.Models
{
    public class UserModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PinCode { get; set; }
        public string Mobile { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public int? RoleId { get; set; }
        public string RoleName { get; set; }
        public string Active { get; set; }
        public string BtnText { get; set; }
        public IEnumerable<SelectListItem> Roles { get; set; }
        public UserModel()
        {
            using (RoleLogic RoleLogic = new RoleLogic())
                Roles = SelectListItemCls.ToSelectListItemsRoles(RoleLogic.GetRoles().AsEnumerable(), RoleId);
        }
    }
}