using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using THSMVC.App_Code;
using THSMVC.Classes;
using THSMVC.Models;
using THSMVC.Models.Grid;
using THSMVC.Models.Helpers;
using THSMVC.Services.Logging.Log4Net;
using THSMVC.Views.Shared;

namespace THSMVC.Controllers
{
    public class UserController : Controller
    {
        private static readonly IEncryptString _encrypter = new ConfigurationBasedStringEncrypter();
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult UserMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditUser()
        {
            UserModel model = new UserModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditUser(int Id)
        {
            UserModel model = new UserModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.Users
                         join d in dse.UserDetails on p.Id equals d.UserId
                         join um in dse.UserMappings on p.Id equals um.UserId
                         join r in dse.Roles on p.RoleId equals r.Id
                         where p.Id == Id
                         select new UserModel
                         {
                             Id = p.Id,
                             Name = d.Name,
                             Address=d.Address,
                             City=d.City,
                             State=d.State,
                             PinCode=d.PinCode,
                             Email=p.Email,
                             Mobile=d.Mobile,
                             Phone= d.Phone,
                             Username=p.UserName,
                             Password = p.Password,
                             RoleId=r.Id,
                             RoleName=r.Role1,
                             AdharNo = um.AdharNumber,
                             Designation = um.Designation,
                             EducationQualiication = um.EducationQualification,
                             Email1 = um.Email1,
                             Email2 = um.Email2,
                             Mobile2 = um.Mobile2 == null ? 0 : (int) um.Mobile2,
                             Mobile3 = um.Mobile3 == null ? 0 : (int)um.Mobile3,
                             Mobile4 = um.Mobile4 == null ? 0 : (int)um.Mobile4,
                             FatherPhone = um.FatherPhonenumber == null ? 0: (int)um.FatherPhonenumber,
                             MotherPhone = um.MotherPhoneNumber == null ? 0 : (int) um.MotherPhoneNumber,
                             PANNo = um.PANNumber,
                             TempAddress = um.TempAddress,
                             TempCity = um.TempCity,
                             TempPin = um.TempPin == null ? 0 : (int)um.TempPin,
                             TempState = um.TempState


                         }).FirstOrDefault();
            }
            if (model.Password != "" && model.Password != null)
                model.Password = _encrypter.Decrypt(model.Password);
            else
                model.Password = "";
            model.BtnText = "Update";
            return View("AddEditUser", model);
        }
        [LogsRequest]
        public ActionResult DelUser(string id)
        {
            try
            {
               string seletedIds = id.TrimStart(',');
               List<int> idsList = seletedIds.Split(',').Select(int.Parse).ToList();
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.Users
                                where idsList.Contains(s.Id)
                                select s;
                    if (query.Count() > 0)
                    {
                        foreach (var u in query)
                        {
                            if (u.IsLockedOut)
                            {
                                u.IsLockedOut = false;
                                //db.SaveChanges();
                                //return Json(new { success = true, message = "User activated successfully" });
                            }
                            else
                            {
                                u.IsLockedOut = true;
                                u.LastLockedOutDate = DateTime.Now;
                                //db.SaveChanges();
                                
                            }
                            
                        }
                        db.SaveChanges();
                        return Json(new { success = true, message = "User(s) deactivated/Acivated successfully" });
                        //var User = query.First();
                        //if (User.IsLockedOut)
                        //{
                        //    User.IsLockedOut = false;
                        //    db.SaveChanges();
                        //    return Json(new { success = true, message = "User activated successfully" });
                        //}
                        //else
                        //{
                        //    User.IsLockedOut = true;
                        //    User.LastLockedOutDate = DateTime.Now;
                        //    db.SaveChanges();
                        //    return Json(new { success = true, message = "User deactivated successfully" });
                        //}
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }
            }
            catch (Exception ex)
            {
                logger.Error("DelUser", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitUser(UserModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    if (model.Id == 0)
                    {
                        var ch = dse.Users.Where(p => p.UserName == model.Username).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "User with the same Username already exists." });
                        User group = new User();
                        group.InstanceId = inststanceId;
                        group.UserName = model.Username;
                        group.Password = _encrypter.Encrypt(model.Password);
                        group.Email = model.Email;
                        group.RoleId = model.RoleId;
                        group.InstanceId = Convert.ToInt32(Session["InstanceId"]);
                        group.IsApproved = true;
                        group.IsLockedOut = false;
                        group.ChangePwdonLogin = false;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
                        dse.AddToUsers(group);
                        dse.SaveChanges();

                        UserDetail detail = new UserDetail();
                        detail.Name = model.Name;
                        detail.Address = model.Address;
                        detail.City = model.City;
                        detail.State = model.State;
                        detail.PinCode = model.PinCode;
                        detail.Mobile = model.Mobile;
                        detail.Phone = model.Phone;
                        detail.UserId = group.Id;
                        dse.AddToUserDetails(detail);
                        dse.SaveChanges();

                        UserMapping mapping = new UserMapping();

                        mapping.AdharNumber = model.AdharNo;
                        mapping.Designation = model.Designation;
                        mapping.EducationQualification = model.EducationQualiication;
                        mapping.Email1 = model.Email1;
                        mapping.Email2 = model.Email2;
                        mapping.Mobile2 = model.Mobile2;
                        mapping.Mobile3 = model.Mobile3;
                        mapping.Mobile4 = model.Mobile4;
                        mapping.FatherPhonenumber = model.FatherPhone;
                        mapping.MotherPhoneNumber = model.MotherPhone;
                        mapping.PANNumber = model.PANNo;
                        mapping.TempAddress = model.TempAddress;
                        mapping.TempCity = model.TempCity;
                        mapping.TempPin = model.TempPin;
                        mapping.TempState = model.TempState;
                        mapping.UserId = group.Id;

                        dse.AddToUserMappings(mapping);
                        dse.SaveChanges();

                        return Json(new { success = true, message = "User created successfuly" });
                    }
                    else
                    {
                        var ch = dse.Users.Where(p => p.UserName == model.Username && p.Id != model.Id).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "User with the same Username already exists." });
                        User group = dse.Users.Where(p => p.Id == model.Id).FirstOrDefault();
                        group.UserName = model.Username;
                        group.Password = _encrypter.Encrypt(model.Password);
                        group.Email = model.Email;
                        group.RoleId = model.RoleId;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        UserDetail detail = dse.UserDetails.Where(p => p.UserId == model.Id).FirstOrDefault();
                        detail.Name = model.Name;
                        detail.Address = model.Address;
                        detail.City = model.City;
                        detail.State = model.State;
                        detail.PinCode = model.PinCode;
                        detail.Mobile = model.Mobile;
                        detail.Phone = model.Phone;
                        detail.UserId = group.Id;
                        dse.SaveChanges();

                        UserMapping mapping = dse.UserMappings.Where(p => p.UserId == model.Id).FirstOrDefault();
                        if (mapping != null)
                        {
                            mapping.AdharNumber = model.AdharNo;

                            mapping.Designation = model.Designation;
                            mapping.EducationQualification = model.EducationQualiication;
                            mapping.Email1 = model.Email1;
                            mapping.Email2 = model.Email2;

                            mapping.Mobile2 = model.Mobile2;
                            mapping.Mobile3 = model.Mobile3;
                            mapping.Mobile4 = model.Mobile4;
                            mapping.FatherPhonenumber = model.FatherPhone;
                            mapping.MotherPhoneNumber = model.MotherPhone;
                            mapping.PANNumber = model.PANNo;
                            mapping.TempAddress = model.TempAddress;
                            mapping.TempCity = model.TempCity;
                            mapping.TempPin = model.TempPin;
                            mapping.TempState = model.TempState;
                            mapping.UserId = group.Id;
                            dse.SaveChanges();
                        }
                        return Json(new { success = true, message = "User updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitUser", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<UserModel> getUsers()
        {
            using (UserLogic logicLayer = new UserLogic())
                return logicLayer.GetUsers();
        }
        public JsonResult JsonUserCollection(GridSettings grid, string userName, string mobileNumber)
        {
            try
            {

                var context = this.getUsers();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<UserModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<UserModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<UserModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<UserModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<UserModel>();
                    }
                }

                //sorting
                context = context.OrderBy<UserModel>(grid.SortColumn, grid.SortOrder);

                //count
                var count = context.Count();

                //paging
                context = context.Skip((grid.PageIndex - 1) * grid.PageSize).Take(grid.PageSize).ToArray().AsQueryable();

                //search
                if (userName != null && !string.IsNullOrEmpty(userName.ToString()))
                {
                    //context = context.Where(e => e.Username.Contains(userName.ToString()));
                    context = context.Where(e => e.NameStr.StartsWith(userName, StringComparison.OrdinalIgnoreCase));
                }
                if (mobileNumber != null && !string.IsNullOrEmpty(mobileNumber.ToString()))
                {
                    //context = context.Where(e => e.Mobile.Equals(mobileNumber.ToString()));
                    context = context.Where(e => e.Mobile.Contains(mobileNumber));
                }

                // Format the data for the jqGrid
                var jsonData = new
                {
                    total = (int)Math.Ceiling((double)count / grid.PageSize),
                    page = grid.PageIndex,
                    records = count,
                    rows = (
                          from s in context
                          select new
                          {
                              i = s.Id,
                              cell = new string[] {
                            s.Id.ToString(),
                            s.Name.ToString().Replace("$$$$","'UpdateUser("+s.Id.ToString()+")'").Replace("****","href='#'"),
                            s.Address,
                            s.City,
                            s.State,
                            s.PinCode,
                            s.Mobile,
                            s.RoleName,
                            s.Active
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonUserCollection", ex);
                return Json(false);
            }
        }
    }
}