using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.App_Code;

namespace THSMVC.Models
{
    public class MainMenuModel
    {
        public string MenuId { get; set; }
        public string Menu { get; set; }

    }
    public class ChangePwdModel
    {
        public bool Change { get; set; }
    }

}