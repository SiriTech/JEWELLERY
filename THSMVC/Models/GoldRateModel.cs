using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.App_Code;

namespace THSMVC.Models
{
    public class GoldRateModel
    {
        public IEnumerable<SelectListItem> goldRates { get; set; }
        public int goldRate { get; set; }
        public string GoldWt { get; set; }
        public string GoldPrice { get; set; }
        public string SilverWt { get; set; }
        public string SilverPrice { get; set; }
        public bool IsConnected { get; set; }
        public string SelectedCity { get; set; }
        public GoldRateModel()
        {
            using(GoldRateLogic GoldRatesLogic = new GoldRateLogic())
                goldRates = SelectListItemCls.ToSelectListItemsGoldRates(GoldRatesLogic.GetGoldRates().AsEnumerable(), goldRate);
        }
    }
}