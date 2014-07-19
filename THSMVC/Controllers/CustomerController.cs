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
								MobileNUmber1 = p.MobileNumber1,
								MobileNUmber4 = p.MobileNumber4,
								MobileNUmber2 = p.MobileNumber2,
								MobileNUmber3 = p.MobileNumber3,
								MobileNUmber5 = p.MobileNumber5,
								MobileNUmber6 = p.MobileNumber6,
								MobileNUmber7 = p.MobileNumber7,
								MobileNUmber8 = p.MobileNumber8,
								MobileNUmber9 = p.MobileNumber9,
								MobileNUmber10 = p.MobileNumber10,
								MobileNUmber1Com = p.MobileNumber1Com,
								MobileNUmber2Com = p.MobileNumber2Com,
								MobileNUmber3Com = p.MobileNumber3Com,
								MobileNUmber4Com = p.MobileNumber4Com,
								MobileNUmber5Com = p.MobileNumber5Com,
								MobileNUmber6Com = p.MobileNumber6Com,
								MobileNUmber7Com = p.MobileNumber7Com,
								MobileNUmber8Com = p.MobileNumber8com,
								MobileNUmber9Com = p.MobileNumber9Com,
								MobileNUmber10Com = p.MobileNumber10Com,
								Email1 = p.Email1,
								Email2 = p.Email2,
								Email3 = p.Email3,
								Email4 = p.Email4,
								Email5 = p.Email5,
								Email6 = p.Email6,
								Email7 = p.Email7,
								Email8 = p.Email8,
								Email9 = p.Email9,
								Email10 = p.Email10,
								Email1Com = p.Email1Com,
								Email2Com = p.Email2Com,
								Email3Com = p.Email3Com,
								Email4Com = p.Email4Com,
								Email5Com = p.Email5Com,
								Email6Com = p.Email6Com,
								Email7Com = p.Email7Com,
								Email8Com = p.Email8Com,
								Email9Com = p.Email9Com,
								Email10Com = p.Email10Com,
								Name = p.Name,
								PhoneNumber = p.PhoneNumber == null ? 0 : (int)p.PhoneNumber,
								Pin = p.Pin == null ? 0 : (int)p.Pin,
								State = p.State,
								File1 = p.File1,
								File2 = p.File2,
								File3 = p.File3

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
						cust.MobileNumber1 = model.MobileNUmber1;
						cust.MobileNumber2 = model.MobileNUmber2;
						cust.MobileNumber3 = model.MobileNUmber3;
						cust.MobileNumber4 = model.MobileNUmber4;
						cust.MobileNumber5 = model.MobileNUmber5;
						cust.MobileNumber6 = model.MobileNUmber6;
						cust.MobileNumber7 = model.MobileNUmber7;
						cust.MobileNumber8 = model.MobileNUmber8;
						cust.MobileNumber9 = model.MobileNUmber9;
						cust.MobileNumber10 = model.MobileNUmber10;
						cust.MobileNumber1Com = model.MobileNUmber1Com;
						cust.MobileNumber2Com = model.MobileNUmber2Com;
						cust.MobileNumber3Com = model.MobileNUmber3Com;
						cust.MobileNumber4Com = model.MobileNUmber4Com;
						cust.MobileNumber5Com = model.MobileNUmber5Com;
						cust.MobileNumber6Com = model.MobileNUmber6Com;
						cust.MobileNumber7Com = model.MobileNUmber7Com;
						cust.MobileNumber8com = model.MobileNUmber8Com;
						cust.MobileNumber9Com = model.MobileNUmber9Com;
						cust.MobileNumber10Com = model.MobileNUmber10Com;
						cust.Email1 = model.Email1;
						cust.Email2 = model.Email2;
						cust.Email3 = model.Email3;
						cust.Email4 = model.Email4;
						cust.Email5 = model.Email5;
						cust.Email6 = model.Email6;
						cust.Email7 = model.Email7;
						cust.Email8 = model.Email8;
						cust.Email9 = model.Email9;
						cust.Email10 = model.Email10;
						cust.Email1Com = model.Email1Com;
						cust.Email2Com = model.Email2Com;
						cust.Email3Com = model.Email3Com;
						cust.Email4Com = model.Email4Com;
						cust.Email5Com = model.Email5Com;
						cust.Email6Com = model.Email6Com;
						cust.Email7Com = model.Email7Com;
						cust.Email8Com = model.Email8Com;
						cust.Email9Com = model.Email9Com;
						cust.Email10Com = model.Email10Com;
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
						cust.MobileNumber1 = model.MobileNUmber1;
						cust.MobileNumber2 = model.MobileNUmber2;
						cust.MobileNumber3 = model.MobileNUmber3;
						cust.MobileNumber4 = model.MobileNUmber4;
						cust.MobileNumber5 = model.MobileNUmber5;
						cust.MobileNumber6 = model.MobileNUmber6;
						cust.MobileNumber7 = model.MobileNUmber7;
						cust.MobileNumber8 = model.MobileNUmber8;
						cust.MobileNumber9 = model.MobileNUmber9;
						cust.MobileNumber10 = model.MobileNUmber10;
						cust.MobileNumber1Com = model.MobileNUmber1Com;
						cust.MobileNumber2Com = model.MobileNUmber2Com;
						cust.MobileNumber3Com = model.MobileNUmber3Com;
						cust.MobileNumber4Com = model.MobileNUmber4Com;
						cust.MobileNumber5Com = model.MobileNUmber5Com;
						cust.MobileNumber6Com = model.MobileNUmber6Com;
						cust.MobileNumber7Com = model.MobileNUmber7Com;
						cust.MobileNumber8com = model.MobileNUmber8Com;
						cust.MobileNumber9Com = model.MobileNUmber9Com;
						cust.MobileNumber10Com = model.MobileNUmber10Com;
						cust.Email1 = model.Email1;
						cust.Email2 = model.Email2;
						cust.Email3 = model.Email3;
						cust.Email4 = model.Email4;
						cust.Email5 = model.Email5;
						cust.Email6 = model.Email6;
						cust.Email7 = model.Email7;
						cust.Email8 = model.Email8;
						cust.Email9 = model.Email9;
						cust.Email10 = model.Email10;
						cust.Email1Com = model.Email1Com;
						cust.Email2Com = model.Email2Com;
						cust.Email3Com = model.Email3Com;
						cust.Email4Com = model.Email4Com;
						cust.Email5Com = model.Email5Com;
						cust.Email6Com = model.Email6Com;
						cust.Email7Com = model.Email7Com;
						cust.Email8Com = model.Email8Com;
						cust.Email9Com = model.Email9Com;
						cust.Email10Com = model.Email10Com;
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

		public ActionResult JsonCustomerCollection(GridSettings grid, string custName, string custNo, string mobile)
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

                //search
                if (custName != null && !string.IsNullOrEmpty(custName))
                {
                    context = context.Where(e => e.NameStr.ToLower().Contains(custName.ToLower()));
                    //context = context.Where(e => e.Name.StartsWith(custName, StringComparison.OrdinalIgnoreCase));
                }
                if (custNo != null && !string.IsNullOrEmpty(custNo))
                {
                    context = context.Where(e => e.CustometNumber.ToLower().Contains(custNo.ToLower()));
                }

                if (mobile != null && !string.IsNullOrEmpty(mobile))
                {
                    context = context.Where(e => e.MobileNUmber1.ToLower().Contains(mobile.ToLower()) || e.MobileNUmber2.ToLower().Contains(mobile.ToLower()) || e.MobileNUmber3.ToLower().Contains(mobile.ToLower()));
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
                            s.Name.ToString().Replace("$$$$","'UpdateCustomer("+s.Id.ToString()+")'").Replace("****","href='#'"),
                            s.CustometNumber.ToString(),
                            s.Address,
                            s.City,
                            s.State,
							s.MobileNUmber1,
							s.PhoneNumber==null?"":s.PhoneNumber.ToString(),
                            s.Email1
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