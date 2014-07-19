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
        public string NameStr { get; set; }
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

        //New Properties for Employee details
        public int MappingId { get; set; }
        public int FatherPhone { get; set; }
        public int MotherPhone { get; set; }
        public int Mobile2 { get; set; }
        public int Mobile3 { get; set; }
        public int Mobile4 { get; set; }
        public string Email1 { get; set; }
        public string Email2 { get; set; }
        public string EducationQualiication { get; set; }
        public string Designation { get; set; }
        public string TempAddress { get; set; }
        public string TempCity { get; set; }
        public string TempState { get; set; }
        public int TempPin { get; set; }
        public string AdharNo { get; set; }
        public string PANNo { get; set; }
    }
}