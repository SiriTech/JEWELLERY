using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class DealerModel
    {
        public int Id { get; set; }
        public string DealerName { get; set; }
        public string CompanyName { get; set; }
        public string CompanyShortForm { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PinCode { get; set; }
        public string TinNo { get; set; }
        public string BtnText { get; set; }

        public string MobileNUmber1 { get; set; }
        public string MobileNUmber2 { get; set; }
        public string MobileNUmber3 { get; set; }
        public string MobileNUmber4 { get; set; }

        public string Email1 { get; set; }
        public string Email2 { get; set; }

        public string BankData { get; set; }
    }
    public class DealerBankDetails
    {
        public string DealerName { get; set; }
        public int DealerId { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public string AccountNumber { get; set; }
        public string IFSCCode { get; set; }
        public string Comments { get; set; }
    }

    public class HideColumnPlugin
    {
        public int data { get; set; }
    }
}