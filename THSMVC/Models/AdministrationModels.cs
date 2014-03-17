using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using THSMVC.App_Code;

namespace THSMVC.Models
{
    #region Models
    public class CreateInstanceModel
    {
        public string formaction { get; set; }
        public int Id { get; set; }
        [DisplayName("Instance Name")]
        public string InstanceName { get; set; }

        [DisplayName("Parent Instance")]
        public int? ParentInstance { get; set; }

        [DisplayName("Country")]
        public int Country { get; set; }

        [DisplayName("State")]
        public int State { get; set; }

        [DisplayName("City")]
        public int? City { get; set; }

        [DisplayName("Sector")]
        public int? Sector { get; set; }

        public IEnumerable<SelectListItem> Countries { get; set; }
        public IEnumerable<SelectListItem> States { get; set; }
        public IEnumerable<SelectListItem> Cities { get; set; }
        public IEnumerable<SelectListItem> Sectors { get; set; }
        public IEnumerable<SelectListItem> Instances { get; set; }

        [DisplayName("Location")]
        public string Location { get; set; }

        [DisplayName("PIN")]
        public string PIN { get; set; }

        [DisplayName("Phone")]
        public string Phone { get; set; }

        [DisplayName("Mobile")]
        public string Mobile { get; set; }

        [DisplayName("License StartDate")]
        public DateTime? LicenseFrom { get; set; }
        public string LicenseFromString { get; set; }

        [DisplayName("License EndDate")]
        public DateTime? LicenseTo { get; set; }
        public string LicenseToString { get; set; }

        public CreateInstanceModel()
        {
            using (InstanceLogic instanceLogic = new InstanceLogic())
                Instances = SelectListItemCls.ToSelectListItemsInstance(instanceLogic.GetAllInstances().AsEnumerable(), ParentInstance);
        }


    }
    public class CreateMenuModel
    {
        public int InstanceId { get; set; }
        public IEnumerable<SelectListItem> Instances { get; set; }
        public int MenuId { get; set; }
        public IEnumerable<SelectListItem> Menus { get; set; }
        public string Name { get; set; }
        public string ActionName { get; set; }
        public string ControllerName { get; set; }
        public int GroupId { get; set; }
        public IEnumerable<SelectListItem> Groups { get; set; }
        public int Order { get; set; }
        public int Level { get; set; }
        public CreateMenuModel()
        {
            using (InstanceLogic instanceLogic = new InstanceLogic())
                Instances = SelectListItemCls.ToSelectListItemsInstance(instanceLogic.GetAllInstances().AsEnumerable(), InstanceId);
            using (MenuLogic menuLogic = new MenuLogic())
                Menus = SelectListItemCls.ToSelectListItemsMenu(menuLogic.GetMenus("0").AsEnumerable(), MenuId);
            using (GroupLogic groupLogic = new GroupLogic())
                Groups = SelectListItemCls.ToSelectListItemsGroup(groupLogic.GetGroups().AsEnumerable(), GroupId);
        }


    }
    public class RegisterAdminModel
    {
        [DisplayName("User name")]
        public string UserName { get; set; }

        [DisplayName("Email address")]
        public string Email { get; set; }

        [DataType(DataType.Password)]
        [DisplayName("Password")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [DisplayName("Confirm password")]
        public string ConfirmPassword { get; set; }

        public IEnumerable<SelectListItem> Instances { get; set; }

        [DisplayName("Instance")]
        public int? Instance { get; set; }

        public RegisterAdminModel()
        {
            using (InstanceLogic instanceLogic = new InstanceLogic())
                Instances = SelectListItemCls.ToSelectListItemsInstance(instanceLogic.GetAllInstances().AsEnumerable(), Instance);
        }

    }
    public class CreateUserModel
    {
        public string selection { get; set; }
    }
    public class UserParentInfoGridModel
    {
        public bool EnableActiveButton { get; set; }
    }

    public class ManageRole
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }
    }
    public class MenuItems
    {
        public List<stp_Get_Menuitems_By_Role_Id_Result> AllMenuItems { get; set; }
        public List<stp_Get_Menuitems_By_Role_Id_Result> ParentMenuItems { get; set; }
        public int RoleId { get; set; }
    }
    #endregion
    #region Services
    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property, AllowMultiple = false)]

    public class EmailAddressAttribute : DataTypeAttribute
    {
        private readonly Regex regex = new Regex(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*", RegexOptions.Compiled);

        public EmailAddressAttribute()
            : base(DataType.EmailAddress)
        {

        }

        public override bool IsValid(object value)
        {
            string str = Convert.ToString(value, CultureInfo.CurrentCulture);
            if (string.IsNullOrEmpty(str))
                return true;

            Match match = regex.Match(str);
            return ((match.Success && (match.Index == 0)) && (match.Length == str.Length));

        }

    }

    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property, AllowMultiple = false)]
    public class EmailAddressRequiredAttribute : DataTypeAttribute
    {
        private readonly Regex regex = new Regex(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*", RegexOptions.Compiled);

        public EmailAddressRequiredAttribute()
            : base(DataType.EmailAddress)
        {

        }

        public override bool IsValid(object value)
        {
            string str = Convert.ToString(value, CultureInfo.CurrentCulture);
            if (string.IsNullOrEmpty(str))
                return false;

            Match match = regex.Match(str);
            return ((match.Success && (match.Index == 0)) && (match.Length == str.Length));

        }

    }

    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property, AllowMultiple = false)]
    public class PhoneNumberAttribute : DataTypeAttribute
    {
        private readonly int _minCharacters = 3;
        private readonly int _maxCharacters = 12;
        public PhoneNumberAttribute()
            : base(DataType.PhoneNumber)
        {

        }

        public override bool IsValid(object value)
        {
            string str = Convert.ToString(value, CultureInfo.CurrentCulture);
            if (string.IsNullOrEmpty(str))
                return true;

            return (str.Length >= _minCharacters && str.Length <= _maxCharacters);

        }

    }


    #endregion
}