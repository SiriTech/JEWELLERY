using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.Views.Shared;
using THSMVC.Models.Grid;
using THSMVC.Models;
using THSMVC.Classes;
using THSMVC.Models.Helpers;
using THSMVC.Services.Logging.Log4Net;

namespace THSMVC.Controllers
{
    public class CustomerController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();

        [LogsRequest]
        public ActionResult CustomerMaster(string Id, string MenuId)
        {
            return View();
        }

        
            [LogsRequest]
        public ActionResult AddEditCustomer()
        {
            CustomerModel model = new CustomerModel();
            model.InstanceId = Convert.ToInt32(Session["InstanceId"]);
            model.BtnText = "Create";
            return View(model);
        }

        [LogsRequest]
        public ActionResult EditCustomer(int Id)
        {
            
            CustomerModel model = new CustomerModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.Customers
                            where p.Id == Id
                         select new CustomerModel
                            {
                                Id = p.Id,
                                Address = p.Address,
                                City = p.City,
                                EmailAddress = p.EmailAddress,
                                Mobile = p.MobileNumber == null ? 0 : (int)p.MobileNumber,
                                Name = p.Name,
                                PhoneNumber = p.PhoneNumber == null ? 0 : (int)p.PhoneNumber,
                                Pin = p.Pin == null ? 0 : (int)p.Pin,
                                State = p.State,
                                File1=p.File1,
                                File2=p.File2,
                                File3=p.File3
                               
                            }).FirstOrDefault();
            }
            char[] delimiters = new char[] { '$', '$' };
            if (model.File1 != "" && model.File1 != null)
            {
                model.Isfile1Exists = true;
                model.File1Guid = model.File1.ToString().Split(delimiters)[2];
                model.File1 = model.File1.ToString().Split(delimiters)[0];
            }
            if (model.File2 != "" && model.File2 != null)
            {
                model.Isfile2Exists = true;
                model.File2Guid = model.File2.ToString().Split(delimiters)[2];
                model.File2 = model.File2.ToString().Split(delimiters)[0];
            }
            if (model.File3 != "" && model.File3 != null)
            {
                model.Isfile3Exists = true;
                model.File3Guid = model.File3.ToString().Split(delimiters)[2];
                model.File3 = model.File3.ToString().Split(delimiters)[0];
            }

            model.InstanceId = Convert.ToInt32(Session["InstanceId"]);
            model.BtnText = "Update";
            return View("AddEditCustomer", model);
        }

        

        [LogsRequest]
        public ActionResult SubmitCustomer(CustomerModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);
                using (DataStoreEntities dse = new DataStoreEntities())
                {
                    string custNumber = "";
                    var cnt = (from s in dse.Customers 
                                   where s.InstanceID == inststanceId
                                   select s).ToList();
                    if ((cnt.Count + 1).ToString().Length == 1)
                        custNumber = "Cust000" + (cnt.Count + 1).ToString();
                    if ((cnt.Count + 1).ToString().Length == 2)
                        custNumber = "Cust00" + (cnt.Count + 1).ToString();
                    if ((cnt.Count + 1).ToString().Length == 3)
                        custNumber = "Cust0" + (cnt.Count + 1).ToString();
                    if ((cnt.Count + 1).ToString().Length == 4)
                        custNumber = "Cust" + (cnt.Count + 1).ToString();

                    if (model.Id == 0)
                    {
                        var ch = dse.Customers.Where(p => p.Name.Equals(model.Name)).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Customer with the same name already exists." });
                        Customer cust = new Customer();
                        cust.InstanceID = inststanceId;
                        cust.Address = model.Address;
                        cust.City = model.City;
                        cust.CustomerNumber = custNumber;
                        cust.EmailAddress =  model.EmailAddress;
                        cust.MobileNumber = model.Mobile;
                        cust.Name = model.Name;
                        cust.PhoneNumber = model.PhoneNumber;
                        cust.Pin = model.Pin;
                        cust.State = model.State;
                        cust.File1 = model.File1;
                        cust.File2 = model.File2;
                        cust.File3 = model.File3;
                        cust.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        cust.CreatedDate = DateTime.Now;
                        dse.AddToCustomers(cust);
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Customer created successfuly" });
                    }
                    else
                    {
                        var ch = dse.Customers.Where(p => p.Name.Equals(model.Name) && p.Id != model.Id).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Customer with the same name already exists." });
                        Customer cust = dse.Customers.Where(p => p.Id == model.Id).FirstOrDefault();
                        cust.InstanceID = inststanceId;
                        cust.Address = model.Address;
                        cust.City = model.City;
                        cust.CustomerNumber = custNumber;
                        cust.EmailAddress = model.EmailAddress;
                        cust.MobileNumber = model.Mobile;
                        cust.Name = model.Name;
                        cust.PhoneNumber = model.PhoneNumber;
                        cust.Pin = model.Pin;
                        cust.State = model.State;
                        cust.File1 = model.File1;
                        cust.File2 = model.File2;
                        cust.File3 = model.File3;
                        cust.EditedBy = Convert.ToInt32(Session["UserId"]);
                        cust.EditedDate = DateTime.Now;
                        //cust.EditedBy = Convert.ToInt32(Session["UserId"]);
                        //cust.EditedDate = DateTime.Now;
                        dse.SaveChanges();
                        return Json(new { success = true, message = "Customer updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitProduct", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }

        public IQueryable<CustomerModel> getProducts()
        {
            using (CustomerLogic logicLayer = new CustomerLogic())
                return logicLayer.GetCustomers();
        }

        public ActionResult JsonCustomerCollection(GridSettings grid)
        {
            try
            {

                var context = this.getProducts();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<CustomerModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<CustomerModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<CustomerModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<CustomerModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<CustomerModel>();
                    }
                }

                //sorting
                context = context.OrderBy<CustomerModel>(grid.SortColumn, grid.SortOrder);

                //count
                var count = context.Count();

                //paging
                context = context.Skip((grid.PageIndex - 1) * grid.PageSize).Take(grid.PageSize).ToArray().AsQueryable();

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
                            s.Name.ToString().Replace("$$$$","'UpdateCustomer("+s.Id.ToString()+")'").Replace("****","href='#'"),
                            s.CustometNumber.ToString(),
                            s.Address,
                            s.City,
                            s.CustometNumber,
                            s.EmailAddress,
                            s.Mobile.ToString(),
                            s.PhoneNumber.ToString(),
                            s.State
                            
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonProductCollection", ex);
                return Json(false);
            }
        }
    }
}