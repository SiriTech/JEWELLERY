using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using System.Data.Objects;

namespace THSMVC
{
    public static class ExcelListControllerExtensions
    {
        public static ActionResult ExcelList<T>
        (
            this Controller controller, 
            List<T> rows,
            string fileName
        )
        {
            return new ExcelListResult<T>(rows, fileName, null, null, null, null, null);
        }

        public static ActionResult ExcelList<T>
        (
            this Controller controller,
            List<T> rows,
            string fileName,
            List<string> headersToBeSkipped
        )
        {
            return new ExcelListResult<T>(rows, fileName, null, null, null, null, headersToBeSkipped);
        }

        public static ActionResult ExcelList<T>
        (
            this Controller controller,
            ObjectContext ObjectContext,
            List<T> rows,
            string fileName,
            string[] headers
        )
        {
            return new ExcelListResult<T>(rows, fileName, headers, null, null, null, null);
        }

        public static ActionResult ExcelList<T>
        (
            this Controller controller,
            ObjectContext ObjectContext,
            List<T> rows,
            string fileName,
            string[] headers,
            TableStyle tableStyle,
            TableItemStyle headerStyle,
            TableItemStyle itemStyle
        )
        {
            return new ExcelListResult<T>(rows, fileName, headers, tableStyle, headerStyle, itemStyle, null);
        }
    }
}