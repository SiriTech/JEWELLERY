using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class LotDetailsModel
    {
        public int LotId { get; set; }

        public string LotName { get; set; }

        public double NoOfPcs { get; set; }

        public double Weight { get; set; }

        public int ProductGroupId { get; set; }

        public string ProductGroupName { get; set; }

        public bool IsMRP { get; set; }
        
        public double MRP { get; set; }

        public double DiffAllowed { get; set; }

        public int DealerId { get; set; }

        public List<Product> ProductList { get; set; }

        public int ProductId { get; set; }


    }
}