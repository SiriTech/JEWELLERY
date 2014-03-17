using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Objects;
using System.Web.UI.WebControls;

namespace THSMVC
{
    public static class ExcelControllerExtensions
    {

        public static ActionResult Excel
        (
            this Controller controller,
            ObjectContext ObjectContext,
            ObjectQuery rows,
            string fileName
        )
        {
            return new ExcelResult(ObjectContext, rows, fileName, null, null, null, null);
        }

        public static ActionResult Excel
        (
            this Controller controller,
            ObjectContext ObjectContext,
            ObjectQuery rows,
            string fileName,
            string[] headers
        )
        {
            return new ExcelResult(ObjectContext, rows, fileName, headers, null, null, null);
        }

        public static ActionResult Excel
        (
            this Controller controller,
            ObjectContext ObjectContext,
            ObjectQuery rows,
            string fileName,
            string[] headers,
            TableStyle tableStyle,
            TableItemStyle headerStyle,
            TableItemStyle itemStyle
        )
        {
            return new ExcelResult(ObjectContext, rows, fileName, headers, tableStyle, headerStyle, itemStyle);
        }

    }
}