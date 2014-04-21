using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class LotMasterModel
    {
        public int LotId { get; set; }
        public string LotName { get; set; }
        public List<ProductGroup> ProductGroupList { get; set; }
        public List<Dealer> DealerList { get; set; }
        public int ProductGroupId { get; set; }
        public double Weight { get; set; }
        public double Qty { get; set; }
        public int DealerId { get; set; }
        public bool IsMRP { get; set; }
        public double MRP { get; set; }
        public double DiffAllowed { get; set; }
        public bool Create { get; set; }
        public bool Update { get; set; }
    }
}