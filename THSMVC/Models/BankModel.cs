using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class BankModel
    {
        public int Id { get; set; }
        public int DealerId { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public string AccountNumber { get; set; }
        public string IFSCCode { get; set; }
        public string Comments { get; set; }
        public string BtnText { get; set; }
    }
}