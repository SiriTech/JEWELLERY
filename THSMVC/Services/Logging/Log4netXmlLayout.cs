using System;
using System.Xml;
using log4net.Core;
using log4net.Layout;
using THSMVC.Services.Logging.Log4Net;

namespace THSMVC.Services.Logging
{
    public class Log4netXmlLayout : XmlLayoutBase
    {
        Log4NetLogger logger = new Log4NetLogger();
        protected override void FormatXml(XmlWriter writer, LoggingEvent loggingEvent)
        {
            try
            {
                writer.WriteStartElement("LogEntry");

                writer.WriteStartElement("Level");
                writer.WriteString(loggingEvent.Level.DisplayName);
                writer.WriteEndElement();

                writer.WriteStartElement("Message");
                writer.WriteString(loggingEvent.RenderedMessage);
                writer.WriteEndElement();

                writer.WriteStartElement("Details");
                if (loggingEvent.ExceptionObject != null)
                    writer.WriteString(loggingEvent.ExceptionObject.ToString());
                writer.WriteEndElement();

                writer.WriteStartElement("StackTrace");
                if (loggingEvent.ExceptionObject != null)
                    writer.WriteString(string.IsNullOrEmpty(loggingEvent.ExceptionObject.StackTrace) ? string.Empty : loggingEvent.ExceptionObject.StackTrace);
                writer.WriteEndElement();

                writer.WriteStartElement("TimeStamp");
                writer.WriteString(loggingEvent.TimeStamp.ToString("dd/MM/yyyy HH:mm:ss"));
                writer.WriteEndElement();

                writer.WriteStartElement("UserID");
                if (System.Web.HttpContext.Current.Session == null)
                    writer.WriteString(null);
                else if (System.Web.HttpContext.Current.Session["UserID"] != null)
                    writer.WriteString(System.Web.HttpContext.Current.Session["UserID"].ToString());
                else
                    writer.WriteString(null);
                writer.WriteEndElement();

                writer.WriteEndElement();
            }
            catch (Exception ex)
            {
                logger.Error("Log4netXmlLayout", ex);
            }
        }
    }
}
