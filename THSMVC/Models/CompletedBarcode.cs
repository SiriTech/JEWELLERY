using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class CompletedBarcodeModel
    {
        #region Primitive Properties


        public int BarcodeId
        {
            get;
            set;
        }
        public int LotId
        {
            get;
            set;
        }

        public string ProductName
        {
            get;
            set;
        }
        public int BarcodeNumber
        {
            get;
            set;
        }
        
        public int ProductId
        {
            get;
            set;
        }
        public int NoOfPieces
        {
            get;
            set;
        }
       
        public double NetWeight
        {
            get;
            set;
        }
        public double GrossWeight
        {
            get;
            set;
        }
        public string WeightMeasure
        {
            get;
            set;
        }

        public double Price
        {
            get;
            set;
        }
      

        public bool IsSubmitted
        {
            get;
            set;
        }
       
        public string Notes
        {
            get;
            set;
        }

        public string Edit
        {
            get;
            set;
        }
        public string Delete
        {
            get;
            set;
        }
        #endregion
    }
}