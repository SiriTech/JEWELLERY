using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using THSMVC.Services.Logging.Log4Net;
using System.Net;
using System.Net.Mail;

namespace THSMVC.App_Code
{
    public class EmailHelper
    {
        public static bool SendTemplateMail(string from, string to, string subject, string templatepath)
        {
            Log4NetLogger logger = new Log4NetLogger();
            try
            {
                using (MailMessage mm = new MailMessage(from, to))
                {
                    mm.Subject = subject;
                    mm.Body = GetEmailBody(templatepath);
                    if (mm.Body != "")
                    {
                        mm.IsBodyHtml = true;
                        NetworkCredential info = new NetworkCredential("test@stellaritapps.com", "Test#1234");
                        using (SmtpClient smtp = new SmtpClient("mail.stellaritapps.com"))
                        {
                            smtp.Credentials = info;
                            smtp.Send(mm);
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                logger.Error("EmailHelper ----> SendTemplateMail", ex);
                return false;
            }
        }
        public static bool SendTemplateMailWithCC(string from, string to, string cc, string subject, string templatepath)
        {
            Log4NetLogger logger = new Log4NetLogger();
            try
            {
                using (MailMessage mm = new MailMessage(from, to))
                {
                    // Add a carbon copy recipient.
                    if (cc != "")
                    {
                        MailAddress copy = new MailAddress(cc);
                        mm.CC.Add(copy);
                    }
                    mm.Subject = subject;
                    mm.Body = GetEmailBody(templatepath);
                    if (mm.Body != "")
                    {
                        mm.IsBodyHtml = true;
                        NetworkCredential info = new NetworkCredential("postmaster@corporatefirms.org", "0551r0551");
                        using (SmtpClient smtp = new SmtpClient("mail.corporatefirms.org"))
                        {
                            smtp.Credentials = info;
                            smtp.Send(mm);
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                logger.Error("EmailHelper ----> SendTemplateMailWithCC", ex);
                return false;
            }
        }
        public static bool SendTemplateMailWithAttachment(string from, string to, string subject, string templatepath, string AttachmentPath)
        {
            Log4NetLogger logger = new Log4NetLogger();
            try
            {
                using (MailMessage mm = new MailMessage(from, to))
                {
                    mm.Subject = subject;
                    mm.Body = GetEmailBody(templatepath);
                    if (mm.Body != "")
                    {
                        mm.IsBodyHtml = true;

                        mm.Attachments.Add(new Attachment(AttachmentPath));
                        NetworkCredential info = new NetworkCredential("postmaster@corporatefirms.org", "0551r0551");
                        using (SmtpClient smtp = new SmtpClient("mail.corporatefirms.org"))
                        {
                            smtp.Credentials = info;
                            smtp.Send(mm);
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                logger.Error("EmailHelper ----> SendTemplateMailWithAttachment", ex);
                return false;
            }
        }
        public static string GetEmailBody(string templatepath)
        {
            Log4NetLogger logger = new Log4NetLogger();
            try
            {
                using (System.Net.WebClient objWebClient = new System.Net.WebClient())
                {
                    byte[] aRequestedHTML = null;
                    string strRequestedHTML = null;
                    aRequestedHTML = objWebClient.DownloadData(templatepath);
                    System.Text.UTF8Encoding objUTF8 = new System.Text.UTF8Encoding();
                    strRequestedHTML = objUTF8.GetString(aRequestedHTML);
                    return strRequestedHTML;
                }
            }
            catch (Exception ex)
            {
                logger.Error("EmailHelper ----> GetEmailBody", ex);
                return string.Empty;
            }
        }
    }
}