using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using THSMVC.App_Code;
using THSMVC.Classes;

namespace THSMVC.Models
{
    public class ProductModel
    {
        public int Id{get;set;}
        public string ProductName { get; set; }
        public string ShortForm { get; set; }
        public decimal? ValueAddedByPerc { get; set; }
        public decimal? ValueAddedFixed { get; set; }
        public decimal? MakingChargesPerGram { get; set; }
        public decimal? MakingChargesFixed { get; set; }
        public bool IsStone { get; set; }
        public bool IsWeightless { get; set; }
        public int ProductCategoryId { get; set; }
        public int ProductGroupId { get; set; }
        public string BtnText { get; set; }
        public IEnumerable<SelectListItem> ProductGroups { get; set; }
        public IEnumerable<SelectListItem> ProductCategories { get; set; }

        public ProductModel()
        {
            using (ProductGroupLogic ProductGroupLogic = new ProductGroupLogic())
                ProductGroups = SelectListItemCls.ToSelectListItemsProductGroups(ProductGroupLogic.GetProductGroupsList().AsEnumerable(), ProductGroupId);
            using (ProductCategoryLogic ProductCategoryLogic = new ProductCategoryLogic())
                ProductCategories = SelectListItemCls.ToSelectListItemsProductCategories(ProductCategoryLogic.GetProductCategoriesList().AsEnumerable(), ProductCategoryId);
        }
    }
}