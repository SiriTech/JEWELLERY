using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace THSMVC.App_Code
{
    public class JsonDropdownData
    {
        public string JsonData(IDictionary<string, string> dict)
        {
            JavaScriptSerializer JSserializer = new JavaScriptSerializer();
            string output = JSserializer.Serialize(dict);
            output = output.Replace("\"", "");
            output = output.Replace(",", ";");
            output = output.Replace("{", "");
            output = output.Replace("}", "");
            return output;
        }
        public string JsonTokenInput(IDictionary<string, string> dict)
        {
            JavaScriptSerializer JSserializer = new JavaScriptSerializer();
            string output = JSserializer.Serialize(dict);
            output = output.Replace("\"", "");
            output = output.Replace(":", ",");
            output = output.Replace("$", ":");
            output = output.Remove(0, 1);
            output = output.Remove(output.Length - 1);
            output = output.Replace("**", "\"");
            output = "[" + output + "]";
            return output;
        }
    }
}