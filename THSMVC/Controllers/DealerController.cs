using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using THSMVC.Classes;
using THSMVC.Models;
using THSMVC.Models.Grid;
using THSMVC.Models.Helpers;
using THSMVC.Services.Logging.Log4Net;
using THSMVC.Views.Shared;
using Newtonsoft.Json;

namespace THSMVC.Controllers
{
    public class DealerController : Controller
    {
        Log4NetLogger logger = new Log4NetLogger();
        [LogsRequest]
        public ActionResult DealerMaster(string Id, string MenuId)
        {
            return View();
        }
        [LogsRequest]
        public ActionResult AddEditDealer()
        {
            DealerModel model = new DealerModel();
            model.BtnText = "Create";
            return View(model);
        }
        [LogsRequest]
        public ActionResult EditDealer(int Id)
        {
            DealerModel model = new DealerModel();
            using (DataStoreEntities dse = new DataStoreEntities())
            {
                model = (from p in dse.Dealers
                         where p.DealerId == Id
                         select new DealerModel
                         {
                             Id = p.DealerId,
                             DealerName = p.DealerName,
                             Address = p.Address,
                             City = p.City,
                             State = p.State,
                             PinCode = p.PinCode,
                             CompanyName = p.CompanyName,
                             CompanyShortForm = p.CompanyShortForm,
                             TinNo = p.CompanyVATOrTinNo,
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
							 MobileNUmber1Com=p.MobileNumber1Com,
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
							 Email10Com = p.Email10Com
                         }).FirstOrDefault();
            }
            model.BtnText = "Update";
            return View("AddEditDealer", model);
        }
        [LogsRequest]
        public ActionResult DelDealer(int id)
        {
            try
            {
                using (var db = new DataStoreEntities())
                {
                    var query = from s in db.Dealers
                                where s.DealerId.Equals(id)
                                select s;
                    if (query.Count() > 0)
                    {
                        var Dealer = query.First();
                        Dealer.Status = true;
                        db.SaveChanges();
                        return Json(new { success = true, message = "Dealer deleted successfully" });
                    }
                    else
                        return Json(new { success = false, message = "Sorry! Please try again later" });
                }


            }
            catch (Exception ex)
            {
                logger.Error("DelDealer", ex);
                return Json(false);
            }
        }
        [LogsRequest]
        public ActionResult SubmitDealer(DealerModel model)
        {
            try
            {
                int inststanceId = Convert.ToInt32(Session["InstanceId"]);


                using (DataStoreEntities dse = new DataStoreEntities())
                {

                    if (model.Id == 0)
                    {
                        var ch = dse.Dealers.Where(p => p.DealerName == model.DealerName).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Dealer with the same name already exists." });

                        string[][] strings = JsonConvert.DeserializeObject<string[][]>(model.BankData);
                        int cnt = 1;
                        bool bankNameIsNull = false;
                        bool brannchNameIsNull = false;
                        bool accountNumberIsNull = false;
                        bool ifscCodeIsNull = false;
                        string msg = string.Empty;
                        foreach (string[] s in strings)
                        {
                            if (s[1] == null || s[1] == string.Empty)
                            {
                                msg += "Please enter Bank Name for Bank" + cnt.ToString() + "<br/>";
                                bankNameIsNull = true;
                            }
                            if (s[2] == null || s[2] == string.Empty)
                            {
                                msg += "Please enter Branch Name for Bank" + cnt.ToString() + "<br/>";
                                brannchNameIsNull = true;
                            }
                            if (s[3] == null || s[3] == string.Empty)
                            {
                                msg += "Please enter Account Number for Bank" + cnt.ToString() + "<br/>";
                                accountNumberIsNull = true;
                            }
                            if (s[4] == null || s[4] == string.Empty)
                            {
                                msg += "Please enter IFSC Code for Bank" + cnt.ToString() + "<br/>";
                                ifscCodeIsNull = true;
                            }

                            cnt++;
                            if (bankNameIsNull && brannchNameIsNull && accountNumberIsNull && ifscCodeIsNull)
                            {
                                msg = string.Empty;
                            }
                            else if (msg != string.Empty)
                                return Json(new { success = false, message = msg });
                        }
                        if (msg != string.Empty)
                            return Json(new { success = false, message = msg });

                        Dealer group = new Dealer();
                        group.InstanceId = inststanceId;
                        group.DealerName = model.DealerName;
                        group.CompanyName = model.CompanyName;
                        group.CompanyShortForm = model.CompanyShortForm;
                        group.Address = model.Address;
                        group.City = model.City;
                        group.State = model.State;
                        group.PinCode = model.PinCode;
                        group.CompanyVATOrTinNo = model.TinNo;
                        group.CreatedBy = Convert.ToInt32(Session["UserId"]);
                        group.CreatedDate = DateTime.Now;
						group.MobileNumber1 = model.MobileNUmber1;
						group.MobileNumber2 = model.MobileNUmber2;
						group.MobileNumber3 = model.MobileNUmber3;
						group.MobileNumber4 = model.MobileNUmber4;
						group.MobileNumber5 = model.MobileNUmber5;
						group.MobileNumber6 = model.MobileNUmber6;
						group.MobileNumber7 = model.MobileNUmber7;
						group.MobileNumber8 = model.MobileNUmber8;
						group.MobileNumber9 = model.MobileNUmber9;
						group.MobileNumber10 = model.MobileNUmber10;
						group.MobileNumber1Com = model.MobileNUmber1Com;
						group.MobileNumber2Com = model.MobileNUmber2Com;
						group.MobileNumber3Com = model.MobileNUmber3Com;
						group.MobileNumber4Com = model.MobileNUmber4Com;
						group.MobileNumber5Com = model.MobileNUmber5Com;
						group.MobileNumber6Com = model.MobileNUmber6Com;
						group.MobileNumber7Com = model.MobileNUmber7Com;
						group.MobileNumber8com = model.MobileNUmber8Com;
						group.MobileNumber9Com = model.MobileNUmber9Com;
						group.MobileNumber10Com = model.MobileNUmber10Com;
						group.Email1 = model.Email1;
						group.Email2 = model.Email2;
						group.Email3 = model.Email3;
						group.Email4 = model.Email4;
						group.Email5 = model.Email5;
						group.Email6 = model.Email6;
						group.Email7 = model.Email7;
						group.Email8 = model.Email8;
						group.Email9 = model.Email9;
						group.Email10 = model.Email10;
						group.Email1Com = model.Email1Com;
						group.Email2Com = model.Email2Com;
						group.Email3Com = model.Email3Com;
						group.Email4Com = model.Email4Com;
						group.Email5Com = model.Email5Com;
						group.Email6Com = model.Email6Com;
						group.Email7Com = model.Email7Com;
						group.Email8Com = model.Email8Com;
						group.Email9Com = model.Email9Com;
						group.Email10Com = model.Email10Com;
                        dse.AddToDealers(group);
                        dse.SaveChanges();

                        
                        int? res = dse.stp_Delete_Dealer_BankDetails_By_Id(model.Id).FirstOrDefault();
                        foreach (string[] s in strings)
                        {
                            if (s[1] != null && s[1] != string.Empty)
                            {
                                DealerBankDetail bank = new DealerBankDetail();
                                bank.DealerId = group.DealerId;
                                bank.BankName = s[1];
                                bank.BranchName = s[2];
                                bank.AccountNumber = s[3];
                                bank.IFSCCode = s[4];
                                bank.Comments = s[5];
                                bank.CreatedBy = Convert.ToInt32(Session["UserId"]);
                                bank.CreatedDate = DateTime.Now;
                                dse.AddToDealerBankDetails(bank);
                                dse.SaveChanges();
                            }
                        }


                        return Json(new { success = true, message = "Dealer created successfuly" });
                    }
                    else
                    {
                        var ch = dse.Dealers.Where(p => p.DealerName == model.DealerName && p.DealerId != model.Id).ToList();
                        if (ch.Count > 0)
                            return Json(new { success = false, message = "Dealer with the same name already exists." });

                        string[][] strings = JsonConvert.DeserializeObject<string[][]>(model.BankData);
                        int cnt = 1;
                        bool bankNameIsNull = false;
                        bool brannchNameIsNull = false;
                        bool accountNumberIsNull = false;
                        bool ifscCodeIsNull = false;
                        string msg = string.Empty;
                        foreach (string[] s in strings)
                        {
                            if (s[2] == null || s[2] == string.Empty)
                            {
                                msg += "Please enter Bank Name for Bank" + cnt.ToString() + "<br/>";
                                bankNameIsNull = true;
                            }
                            if (s[3] == null || s[3] == string.Empty)
                            {
                                msg += "Please enter Branch Name for Bank" + cnt.ToString() + "<br/>";
                                brannchNameIsNull = true;
                            }
                            if (s[4] == null || s[4] == string.Empty)
                            {
                                msg += "Please enter Account Number for Bank" + cnt.ToString() + "<br/>";
                                accountNumberIsNull = true;
                            }
                            if (s[5] == null || s[5] == string.Empty)
                            {
                                msg += "Please enter IFSC Code for Bank" + cnt.ToString() + "<br/>";
                                ifscCodeIsNull = true;
                            }

                            cnt++;
                            if (bankNameIsNull && brannchNameIsNull && accountNumberIsNull && ifscCodeIsNull)
                            {
                                msg = string.Empty;
                            }
                            else if (msg != string.Empty)
                                return Json(new { success = false, message = msg });
                        }
                        if (msg != string.Empty)
                            return Json(new { success = false, message = msg });

                        Dealer group = dse.Dealers.Where(p => p.DealerId == model.Id).FirstOrDefault();
                        group.DealerName = model.DealerName;
                        group.CompanyName = model.CompanyName;
                        group.CompanyShortForm = model.CompanyShortForm;
                        group.Address = model.Address;
                        group.City = model.City;
                        group.State = model.State;
                        group.PinCode = model.PinCode;
                        group.CompanyVATOrTinNo = model.TinNo;
						group.MobileNumber1 = model.MobileNUmber1;
						group.MobileNumber2 = model.MobileNUmber2;
						group.MobileNumber3 = model.MobileNUmber3;
						group.MobileNumber4 = model.MobileNUmber4;
						group.MobileNumber5 = model.MobileNUmber5;
						group.MobileNumber6 = model.MobileNUmber6;
						group.MobileNumber7 = model.MobileNUmber7;
						group.MobileNumber8 = model.MobileNUmber8;
						group.MobileNumber9 = model.MobileNUmber9;
						group.MobileNumber10 = model.MobileNUmber10;
						group.MobileNumber1Com = model.MobileNUmber1Com;
						group.MobileNumber2Com = model.MobileNUmber2Com;
						group.MobileNumber3Com = model.MobileNUmber3Com;
						group.MobileNumber4Com = model.MobileNUmber4Com;
						group.MobileNumber5Com = model.MobileNUmber5Com;
						group.MobileNumber6Com = model.MobileNUmber6Com;
						group.MobileNumber7Com = model.MobileNUmber7Com;
						group.MobileNumber8com = model.MobileNUmber8Com;
						group.MobileNumber9Com = model.MobileNUmber9Com;
						group.MobileNumber10Com = model.MobileNUmber10Com;
						group.Email1 = model.Email1;
						group.Email2 = model.Email2;
						group.Email3 = model.Email3;
						group.Email4 = model.Email4;
						group.Email5 = model.Email5;
						group.Email6 = model.Email6;
						group.Email7 = model.Email7;
						group.Email8 = model.Email8;
						group.Email9 = model.Email9;
						group.Email10 = model.Email10;
						group.Email1Com = model.Email1Com;
						group.Email2Com = model.Email2Com;
						group.Email3Com = model.Email3Com;
						group.Email4Com = model.Email4Com;
						group.Email5Com = model.Email5Com;
						group.Email6Com = model.Email6Com;
						group.Email7Com = model.Email7Com;
						group.Email8Com = model.Email8Com;
						group.Email9Com = model.Email9Com;
						group.Email10Com = model.Email10Com;
                        group.EditedBy = Convert.ToInt32(Session["UserId"]);
                        group.EditedDate = DateTime.Now;
                        dse.SaveChanges();

                        int? res = dse.stp_Delete_Dealer_BankDetails_By_Id(model.Id).FirstOrDefault();
                        foreach (string[] s in strings)
                        {
                            if (s[2] != null && s[2] != string.Empty)
                            {
                                DealerBankDetail bank = new DealerBankDetail();
                                bank.DealerId = model.Id;
                                bank.BankName = s[2];
                                bank.BranchName = s[3];
                                bank.AccountNumber = s[4];
                                bank.IFSCCode = s[5];
                                bank.Comments = s[6];
                                bank.CreatedBy = Convert.ToInt32(Session["UserId"]);
                                bank.CreatedDate = DateTime.Now;
                                dse.AddToDealerBankDetails(bank);
                                dse.SaveChanges();
                            }
                        }

                        return Json(new { success = true, message = "Dealer updated successfuly" });
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("SubmitDealer", ex);
                return Json(new { success = false, message = "Sorry! Please try again later" });
            }
        }
        public IQueryable<DealerModel> getDealers()
        {
            using (DealerLogic logicLayer = new DealerLogic())
                return logicLayer.GetDealers();
        }
        public ActionResult JsonDealerCollection(GridSettings grid, string companyName, string dealerName, string tinNo)
        {
            try
            {

                var context = this.getDealers();
                //filtring
                if (grid.IsSearch)
                {
                    //And
                    if (grid.Where.groupOp == "AND")
                    {
                        foreach (var rule in grid.Where.rules)
                        {
                            context = context.Where<DealerModel>(
                                                          rule.field, rule.data,
                                                          (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                        }
                    }
                    else
                    {
                        //Or
                        var temp = (new List<DealerModel>()).AsQueryable();
                        foreach (var rule in grid.Where.rules)
                        {
                            var t = context.Where<DealerModel>(
                            rule.field, rule.data,
                            (WhereOperation)StringEnum.Parse(typeof(WhereOperation), rule.op));
                            temp = temp.Concat<DealerModel>(t);
                        }
                        //remove repeating records
                        context = temp.Distinct<DealerModel>();
                    }
                }

                //sorting
                context = context.OrderBy<DealerModel>(grid.SortColumn, grid.SortOrder);

                //count
                var count = context.Count();

                //paging
                context = context.Skip((grid.PageIndex - 1) * grid.PageSize).Take(grid.PageSize).ToArray().AsQueryable();

                //search
                if (companyName != null && !string.IsNullOrEmpty(companyName))
                {
                    //context = context.Where(e => e.Username.Contains(userName.ToString()));
                    context = context.Where(e => e.CompanyName.StartsWith(companyName, StringComparison.OrdinalIgnoreCase));
                }
                if (dealerName != null && !string.IsNullOrEmpty(dealerName))
                {
                    context = context.Where(e => e.DealerName.Contains(dealerName));
                }

                if (tinNo != null && !string.IsNullOrEmpty(tinNo))
                {
                    context = context.Where(e => e.TinNo.Contains(tinNo));
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
                            s.CompanyName.ToString(),
                            s.DealerName.ToString().Replace("$$$$","'UpdateDealer("+s.Id.ToString()+")'").Replace("****","href='#'"),
                            //s.CompanyShortForm==null?"":s.CompanyShortForm,
                            //s.Address==null?"":s.Address,
                            //s.City==null?"":s.City,
                            //s.State==null?"":s.State,
                            //s.PinCode==null?"":s.PinCode,
                            
                            s.MobileNUmber1==null?"":s.MobileNUmber1,
                            s.TinNo,
                            s.Email1 == null?"":s.Email1
                        }
                          }).ToArray()
                };

                // Return the result in json
                return Json(jsonData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("JsonDealerCollection", ex);
                return Json(false);
            }
        }
        public ActionResult DealerBankDetails(int Id)
        {
            if (Id == 0)
            {
                DataStoreEntities dse = new DataStoreEntities();
                List<HideColumnPlugin> hdataarray = new List<HideColumnPlugin>();
                string[] strColHeaders = new string[5];
                string[] hiddenStrColHeaders = new string[5];
                HideColumnPlugin obj = new HideColumnPlugin();
                obj.data = 1;
                hdataarray.Add(obj);
                HideColumnPlugin obj1 = new HideColumnPlugin();
                obj1.data = 2;
                hdataarray.Add(obj1);
                HideColumnPlugin obj2 = new HideColumnPlugin();
                obj2.data = 3;
                hdataarray.Add(obj2);
                HideColumnPlugin obj3 = new HideColumnPlugin();
                obj3.data = 4;
                hdataarray.Add(obj3);
                HideColumnPlugin obj4 = new HideColumnPlugin();
                obj4.data = 5;
                hdataarray.Add(obj4);

                strColHeaders[0] = "Bank Name";
                strColHeaders[1] = "Branch Name";
                strColHeaders[2] = "Account Number";
                strColHeaders[3] = "IFSC Code";
                strColHeaders[4] = "Comments";
                hiddenStrColHeaders[0] = "Bank Name";
                hiddenStrColHeaders[1] = "Branch Name";
                hiddenStrColHeaders[2] = "Account Number";
                hiddenStrColHeaders[3] = "IFSC Code";
                hiddenStrColHeaders[4] = "Comments";
                List<string[]> dataArray = new List<string[]>();

                for (int i = 0; i < 3; i++)
                {
                    string[] strArr = new string[5];
                    strArr[0] = string.Empty;
                    strArr[1] = string.Empty;
                    strArr[2] = string.Empty;
                    strArr[3] = string.Empty;
                    strArr[4] = string.Empty;
                    dataArray.Add(strArr);
                }
                return Json(new { success = true, data = dataArray, colheaders = strColHeaders, hdata = hdataarray.ToArray(), hcolheaders = hiddenStrColHeaders });

            }
            else
            {
                DataStoreEntities dse = new DataStoreEntities();
                List<HideColumnPlugin> hdataarray = new List<HideColumnPlugin>();
                string[] strColHeaders = new string[7];
                string[] hiddenStrColHeaders = new string[6];
                HideColumnPlugin obj = new HideColumnPlugin();
                obj.data = 1;
                hdataarray.Add(obj);
                HideColumnPlugin obj1 = new HideColumnPlugin();
                obj1.data = 2;
                hdataarray.Add(obj1);
                HideColumnPlugin obj2 = new HideColumnPlugin();
                obj2.data = 3;
                hdataarray.Add(obj2);
                HideColumnPlugin obj3 = new HideColumnPlugin();
                obj3.data = 4;
                hdataarray.Add(obj3);
                HideColumnPlugin obj4 = new HideColumnPlugin();
                obj4.data = 5;
                hdataarray.Add(obj4);
                HideColumnPlugin obj5 = new HideColumnPlugin();
                obj5.data = 6;
                hdataarray.Add(obj5);

                strColHeaders[0] = "Dealer Id";
                strColHeaders[1] = "Dealer Name";
                strColHeaders[2] = "Bank Name";
                strColHeaders[3] = "Branch Name";
                strColHeaders[4] = "Account Number";
                strColHeaders[5] = "IFSC Code";
                strColHeaders[6] = "Comments";
                hiddenStrColHeaders[0] = "Dealer Name";
                hiddenStrColHeaders[1] = "Bank Name";
                hiddenStrColHeaders[2] = "Branch Name";
                hiddenStrColHeaders[3] = "Account Number";
                hiddenStrColHeaders[4] = "IFSC Code";
                hiddenStrColHeaders[5] = "Comments";
                List<string[]> dataArray = new List<string[]>();
                List<DealerBankDetails> dealerBankDetails = (from s in dse.Dealers
                                                             join d in dse.DealerBankDetails on s.DealerId equals d.DealerId into lj
                                                             from lm in lj.DefaultIfEmpty()
                                                             where s.DealerId == Id
                                                             select new DealerBankDetails()
                                                             {
                                                                 DealerName = s.DealerName,
                                                                 DealerId = s.DealerId,
                                                                 BankName = lm.BankName,
                                                                 BranchName = lm.BranchName,
                                                                 AccountNumber = lm.AccountNumber,
                                                                 IFSCCode = lm.IFSCCode,
                                                                 Comments = lm.Comments
                                                             }).ToList();
                foreach (DealerBankDetails dealerdetails in dealerBankDetails)
                {
                    string[] strArr = new string[7];
                    strArr[0] = dealerdetails.DealerId.ToString();
                    strArr[1] = dealerdetails.DealerName;
                    strArr[2] = dealerdetails.BankName;
                    strArr[3] = dealerdetails.BranchName;
                    strArr[4] = dealerdetails.AccountNumber;
                    strArr[5] = dealerdetails.IFSCCode;
                    strArr[6] = dealerdetails.Comments;
                    dataArray.Add(strArr);
                }
                if (dataArray.Count < 3)
                {
                    for (int i = dataArray.Count; i < 3; i++)
                    {
                        string[] strArr = new string[7];
                        strArr[0] = dealerBankDetails[0].DealerId.ToString();
                        strArr[1] = dealerBankDetails[0].DealerName;
                        strArr[2] = string.Empty;
                        strArr[3] = string.Empty;
                        strArr[4] = string.Empty;
                        strArr[5] = string.Empty;
                        strArr[6] = string.Empty;
                        dataArray.Add(strArr);
                    }
                }
                return Json(new { success = true, data = dataArray, colheaders = strColHeaders, hdata = hdataarray.ToArray(), hcolheaders = hiddenStrColHeaders });
            }
        }
    }
}