using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Objects;
using System.Web.UI.WebControls;

namespace THSMVC
{
    public static class WordListControllerExtensions
    {
        public static ActionResult WordList<T>
        (
            this Controller controller,
            List<T> rows,
            string fileName
        )
        {
            return new WordListResult<T>(rows, fileName, null, null, null, null, null);
        }

        public static ActionResult WordList<T>
        (
            this Controller controller,
            List<T> rows,
            string fileName,
            List<string> headersToBeSkipped
        )
        {
            return new WordListResult<T>(rows, fileName, null, null, null, null, headersToBeSkipped);
        }

        public static ActionResult WordList<T>
        (
            this Controller controller,
            ObjectContext ObjectContext,
            List<T> rows,
            string fileName,
            string[] headers
        )
        {
            return new WordListResult<T>(rows, fileName, headers, null, null, null, null);
        }

        public static ActionResult WordList<T>
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
            return new WordListResult<T>(rows, fileName, headers, tableStyle, headerStyle, itemStyle, null);
        }
    }
}