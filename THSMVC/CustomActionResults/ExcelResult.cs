using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Objects;
using System.Web.UI.WebControls;
using System.Drawing;
using System.IO;
using System.Web.UI;
using System.Web.Hosting;
using System.Data.Metadata.Edm;
using THSMVC.Models;

namespace THSMVC
{
    public class ExcelResult : ActionResult
    {
        private ObjectContext _ObjectContext;
        private string _fileName;
        private ObjectQuery _rows;
        private string[] _headers = null;

        private TableStyle _tableStyle;
        private TableItemStyle _headerStyle;
        private TableItemStyle _itemStyle;

        public string FileName
        {
            get { return _fileName; }
        }

        public ObjectQuery Rows
        {
            get { return _rows; }
        }


        public ExcelResult(ObjectContext ObjectContext, ObjectQuery rows, string fileName)
            : this(ObjectContext, rows, fileName, null, null, null, null)
        {
        }

        public ExcelResult(ObjectContext ObjectContext, string fileName, ObjectQuery rows, string[] headers)
            : this(ObjectContext, rows, fileName, headers, null, null, null)
        {
        }

        public ExcelResult(ObjectContext ObjectContext, ObjectQuery rows, string fileName, string[] headers, TableStyle tableStyle, TableItemStyle headerStyle, TableItemStyle itemStyle)
        {
            _ObjectContext = ObjectContext;
            _rows = rows;
            _fileName = fileName;
            _headers = headers;
            _tableStyle = tableStyle;
            _headerStyle = headerStyle;
            _itemStyle = itemStyle;

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
            StringWriter sw = new StringWriter();
            HtmlTextWriter tw = new HtmlTextWriter(sw);

            // Build HTML Table from Items
            if (_tableStyle != null)
                _tableStyle.AddAttributesToRender(tw);
            tw.RenderBeginTag(HtmlTextWriterTag.Table);

            // Generate headers from table
            if (_headers == null)
            {
                // _headers = _ObjectContext.Mapping.GetMetaType(_rows.ElementType).PersistentDataMembers.Select(m => m.Name).ToArray();
                DataStoreEntities dse = new DataStoreEntities();

                var members = (_rows as ObjectQuery).GetResultType().EdmType.
  MetadataProperties.First(p => p.Name == "Members").Value as IEnumerable<EdmMember>;
                _headers = (from meta in members
                            let prop = (meta as EdmProperty)
                            let type = meta is EdmProperty ? (meta as EdmProperty).TypeUsage.EdmType : null
                            where meta is EdmProperty
                            select new
                            {
                                Name = prop.Name
                            }).Select(t => t.Name).ToArray();
            }


            // Create Header Row
            tw.RenderBeginTag(HtmlTextWriterTag.Thead);
            foreach (String header in _headers)
            {
                if (_headerStyle != null)
                    _headerStyle.AddAttributesToRender(tw);
                tw.RenderBeginTag(HtmlTextWriterTag.Th);
                tw.Write(header);
                tw.RenderEndTag();
            }
            tw.RenderEndTag();



            // Create Data Rows
            tw.RenderBeginTag(HtmlTextWriterTag.Tbody);
            foreach (Object row in _rows)
            {
                tw.RenderBeginTag(HtmlTextWriterTag.Tr);
                foreach (string header in _headers)
                {
                    string strValue = row.GetType().GetProperty(header).GetValue(row, null).ToString();
                    strValue = ReplaceSpecialCharacters(strValue);
                    if (_itemStyle != null)
                        _itemStyle.AddAttributesToRender(tw);
                    tw.RenderBeginTag(HtmlTextWriterTag.Td);
                    tw.Write(HttpUtility.HtmlEncode(strValue));
                    tw.RenderEndTag();
                }
                tw.RenderEndTag();
            }
            tw.RenderEndTag(); // tbody
            tw.RenderEndTag(); // table
            WriteFile(_fileName, "application/ms-excel", sw.ToString());
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