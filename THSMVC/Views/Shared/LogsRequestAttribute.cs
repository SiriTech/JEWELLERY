using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Threading;
using THSMVC.Models;
using THSMVC.Services.Logging.Log4Net;
using THSMVC.App_Code;
using System.IO.Compression;

namespace THSMVC.Views.Shared
{
    public class LogsRequestAttribute : ActionFilterAttribute, IActionFilter
    {
        Log4NetLogger logger = new Log4NetLogger();
        private static LoggerDataStoreEntities DataStore = new LoggerDataStoreEntities();
        void IActionFilter.OnActionExecuted(ActionExecutedContext FilterContext)
        {
           
        }
        void IActionFilter.OnActionExecuting(ActionExecutingContext FilterContext)
        {
            ThreadPool.QueueUserWorkItem(delegate
            {
                try
                {
                    //Get the Application URL
                    string url = string.Empty;
                    if (FilterContext.HttpContext.Request.QueryString.Count <= 0)
                    {
                        if (FilterContext.HttpContext.Request.Url == null)
                            url = string.Empty;
                    }
                    else
                        url = FilterContext.HttpContext.Request.Url.ToString();
                    //Get the Host Address
                    string hostaddress = string.Empty;
                    if (FilterContext.HttpContext.Request.UserHostAddress == null)
                        hostaddress = string.Empty;
                    else
                        hostaddress = FilterContext.HttpContext.Request.UserHostAddress.ToString();
                    //Get the UserID
                    string userid = string.Empty;
                    if (FilterContext.HttpContext.Session["UserID"] == null)
                        userid = string.Empty;
                    else
                        userid = FilterContext.HttpContext.Session["UserID"].ToString();
                    DataStore.AddToSiteLogs(new SiteLog
                    {
                        Action = FilterContext.ActionDescriptor.ActionName,
                        Controller = FilterContext.Controller.ToString(),
                        TimeStamp = FilterContext.HttpContext.Timestamp,
                        IPAddress = System.Net.Dns.GetHostAddresses(System.Net.Dns.GetHostName()).GetValue(0).ToString(),
                        URL = url,
                        HostAddress = hostaddress,
                        UserID = userid,
                    });

                    DataStore.SaveChanges();
                }
                catch (Exception ex)
                {
                    //logger.Error("LogsRequestAttribute(SiteLog)", ex);
                }
                finally { }
            });
        }
    }

    public class CompressFilterAttribute : ActionFilterAttribute, IActionFilter
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpRequestBase request = filterContext.HttpContext.Request;

            string acceptEncoding = request.Headers["Accept-Encoding"];

            if (string.IsNullOrEmpty(acceptEncoding)) return;

            acceptEncoding = acceptEncoding.ToUpperInvariant();

            HttpResponseBase response = filterContext.HttpContext.Response;

            if (acceptEncoding.Contains("GZIP"))
            {
                response.AppendHeader("Content-encoding", "gzip");
                response.Filter = new GZipStream(response.Filter, CompressionMode.Compress);
            }
            else if (acceptEncoding.Contains("DEFLATE"))
            {
                response.AppendHeader("Content-encoding", "deflate");
                response.Filter = new DeflateStream(response.Filter, CompressionMode.Compress);
            }
        }
    }
}