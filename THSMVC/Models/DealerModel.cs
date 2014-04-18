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
    }
}