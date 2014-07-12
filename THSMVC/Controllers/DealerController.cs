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
                             Email1 = p.Email1,
                             Email2 = p.Email2
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
                        group.Email1 = model.Email1;
                        group.Email2 = model.Email2;
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
                        group.Email1 = model.Email1;
                        group.Email2 = model.Email2;
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
        public ActionResult JsonDealerCollection(GridSettings grid)
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
                            s.CompanyShortForm==null?"":s.CompanyShortForm,
                            s.Address==null?"":s.Address,
                            s.City==null?"":s.City,
                            s.State==null?"":s.State,
                            s.PinCode==null?"":s.PinCode,
                            s.TinNo==null?"":s.TinNo,
                            s.MobileNUmber1==null?"":s.MobileNUmber1,
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