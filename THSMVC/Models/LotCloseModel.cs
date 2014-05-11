using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class LotCloseModel
    {
        public int LotId { get; set; }

        public int LotStatisID { get; set; }

        public string LotName { get; set; }

        public int NoOfPcs { get; set; }

        public double Weight { get; set; }

        public int ProductGroupId { get; set; }

        public string ProductGroupName { get; set; }

        public bool IsMRP { get; set; }

        public double MRP { get; set; }

        public double DiffAllowed { get; set; }
        
        public int ProductId { get; set; }


        public double WeightCompleted { get; set; }

        public double MRPCompleted { get; set; }

        public int NoOfPcsCompleted { get; set; }

        public int NoOfPcsPending { get; set; }

        public double WeightPending { get; set; }

        public double DiffAllowedActual { get; set; }
    }
}