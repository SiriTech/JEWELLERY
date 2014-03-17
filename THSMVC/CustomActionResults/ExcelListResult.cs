using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Data.Objects;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Web.Hosting;

namespace THSMVC
{
    public class ExcelListResult<T> : ActionResult
    {
        private string _fileName;
        private List<T> _rows;
        private List<string> _headersToBeSkipped;
        private string[] _headers = null;

        private TableStyle _tableStyle;
        private TableItemStyle _headerStyle;
        private TableItemStyle _itemStyle;

        public string FileName
        {
            get { return _fileName; }
        }

        public List<T> Rows
        {
            get { return _rows; }
        }

        public List<string> HeadersToBeSkipped
        {
            get { return _headersToBeSkipped; }
        }


        public ExcelListResult(List<T> rows, string fileName)
            : this(rows, fileName, null, null, null, null, null)
        {
        }

        public ExcelListResult(string fileName, List<T> rows, string[] headers)
            : this(rows, fileName, headers, null, null, null, null)
        {
        }

        public ExcelListResult(List<T> rows, string fileName, string[] headers, TableStyle tableStyle, TableItemStyle headerStyle, TableItemStyle itemStyle, List<string> headersToBeSkipped)
        {
            _rows = rows;
            _fileName = fileName.Replace(".xls",DateTime.Now.ToString("_MM_dd_yyyy_hh_mm_ss")+".xls");
            _headers = headers;
            _tableStyle = tableStyle;
            _headerStyle = headerStyle;
            _itemStyle = itemStyle;
            if (headersToBeSkipped == null || headersToBeSkipped.Count < 0)
            {
                _headersToBeSkipped = new List<string>();
            }
            else
            {
                _headersToBeSkipped = headersToBeSkipped;
            }

            // provide defaults
            if (_tableStyle == null)
            {
                _tableStyle = new TableStyle();
                _tableStyle.BorderStyle = BorderStyle.Solid;
                _tableStyle.BorderColor = Color.Black;
                _tableStyle.BorderWidth = Unit.Parse("2px");
            }
            if (_headerStyle == null)
            {
                _headerStyle = new TableItemStyle();
                _headerStyle.BackColor = Color.LightGray;
            }
        }

        public override void ExecuteResult(ControllerContext context)
        {
            // Create HtmlTextWriter
            StringWriter Sw = new StringWriter();
            HtmlTextWriter Tw = new HtmlTextWriter(Sw);
            
            // Build HTML Table from Items
            if (_tableStyle != null)
                _tableStyle.AddAttributesToRender(Tw);
            Tw.RenderBeginTag(HtmlTextWriterTag.Table);

            // Generate headers from table
            if (_headers == null)
            {
                _headers = (_rows as List<T>).AsQueryable()
                    .ElementType
                    .GetProperties()
                    .Select(m => m.Name)
                    .ToArray();
            }
            // Create Header Row
            Tw.RenderBeginTag(HtmlTextWriterTag.Thead);
            foreach (String header in _headers)
            {
                if (!_headersToBeSkipped.Contains(header))
                {
                    if (_headerStyle != null)
                        _headerStyle.AddAttributesToRender(Tw);

                    Tw.RenderBeginTag(HtmlTextWriterTag.Th);

                    var TempHeader = header;
                    //// Check if object has DisplayName attribute.
                    //if ((_rows as List<T>).AsQueryable().ElementType.GetCustomAttributes(false).Count() > 0)
                    //{
                    //    MetadataTypeAttribute ObjMetadataTypeAttribute = (MetadataTypeAttribute)(_rows as List<T>).AsQueryable().ElementType.GetCustomAttributes(false).FirstOrDefault();
                    //    Type DataAnnotationFullName = ObjMetadataTypeAttribute.MetadataClassType.FullName.GetType();
                    //    DisplayNameAttribute[] ObjDisplayNameAttribute = null;
                    //    string StrMetaDataClass = ObjMetadataTypeAttribute.MetadataClassType.FullName + "," + ObjMetadataTypeAttribute.MetadataClassType.Namespace;
                    //    if (Type.GetType(StrMetaDataClass).GetProperty(header) != null)
                    //    {
                    //        ObjDisplayNameAttribute = (DisplayNameAttribute[])Type.GetType(StrMetaDataClass).GetProperty(header).GetCustomAttributes(typeof(DisplayNameAttribute), false);
                    //        if (ObjDisplayNameAttribute.Any())
                    //            TempHeader = ObjDisplayNameAttribute.FirstOrDefault().DisplayName;
                    //    }

                    //}

                    Tw.Write(TempHeader);
                    Tw.RenderEndTag();
                }
            }
            Tw.RenderEndTag();



            // Create Data Rows
            Tw.RenderBeginTag(HtmlTextWriterTag.Tbody);
            foreach (Object row in _rows)
            {
                Tw.RenderBeginTag(HtmlTextWriterTag.Tr);
                foreach (string header in _headers)
                {
                    if (!_headersToBeSkipped.Contains(header))
                    {
                        string strValue = row.GetType().GetProperty(header).GetValue(row, null) != null ? row.GetType().GetProperty(header).GetValue(row, null).ToString() : string.Empty;
                        strValue = ReplaceSpecialCharacters(strValue);
                        if (_itemStyle != null)
                            _itemStyle.AddAttributesToRender(Tw);
                        Tw.RenderBeginTag(HtmlTextWriterTag.Td);
                        Tw.Write(HttpUtility.HtmlEncode(strValue));
                        Tw.RenderEndTag();
                    }
                }
                Tw.RenderEndTag();
            }
            Tw.RenderEndTag(); // tbody
            Tw.RenderEndTag(); // table
            WriteFile(_fileName, "application/ms-excel", Sw.ToString());
        }


        private static string ReplaceSpecialCharacters(string value)
        {
            value = value.Replace("’", "'");
            value = value.Replace("“", "\"");
            value = value.Replace("”", "\"");
            value = value.Replace("–", "-");
            value = value.Replace("…", "...");
            return value;
        }

        private static void WriteFile(string fileName, string contentType, string content)
        {
            string fName = fileName.Split('/')[4];
            HttpContext context = HttpContext.Current;
            System.IO.File.WriteAllText(HostingEnvironment.MapPath(fileName), content);
            context.Response.Clear();
            context.Response.AddHeader("content-disposition", "attachment;filename=" + fName);
            context.Response.Charset = "";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.ContentType = contentType;
            context.Response.Write(content);
            context.Response.End();
        }
    }
}