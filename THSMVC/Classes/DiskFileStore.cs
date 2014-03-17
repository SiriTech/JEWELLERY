using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.IO;

namespace THSMVC.App_Code
{
    public class DiskFileStore:IFileStore
    {
        private string _uploadsFolder = HostingEnvironment.MapPath("~/StudentPhotos/");
        private string _niticeuploadsFolder = HostingEnvironment.MapPath("~/NoticeDocs/");
        private string _attendanceSMSuploadsFolder = HostingEnvironment.MapPath("~/AttendanceSMSDocs/");
        public string SaveUploadedFile(HttpPostedFileBase fileBase,string InstanceId)
        {
            var identifier = Guid.NewGuid();
            fileBase.SaveAs(GetDiskLocation(identifier.ToString() + fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length-4),InstanceId));
            return identifier.ToString() + fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length - 4);
        }

        private string GetDiskLocation(string identifier, string InstanceId)
        {
            if (Directory.Exists(_uploadsFolder + InstanceId))
                return Path.Combine(_uploadsFolder + InstanceId, identifier);
            else
            {
                Directory.CreateDirectory(_uploadsFolder + InstanceId);
                return Path.Combine(_uploadsFolder + InstanceId, identifier);
            }
        }
        public string SaveNoticeUploadedFile(HttpPostedFileBase fileBase, string InstanceId)
        {
            var identifier = Guid.NewGuid();
            fileBase.SaveAs(GetNoticeDocsDiskLocation(identifier.ToString() + fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length - 4), InstanceId));
            return identifier.ToString() + fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length - 4);
        }
        private string GetNoticeDocsDiskLocation(string identifier, string InstanceId)
        {
            if (Directory.Exists(_niticeuploadsFolder + InstanceId))
                return Path.Combine(_niticeuploadsFolder + InstanceId, identifier);
            else
            {
                Directory.CreateDirectory(_niticeuploadsFolder + InstanceId);
                return Path.Combine(_niticeuploadsFolder + InstanceId, identifier);
            }
        }

        public string SaveAttendanceUploadedFile(HttpPostedFileBase fileBase, string InstanceId)
        {
            var identifier = Guid.NewGuid();
            if (fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length - 4).Length == 4)
            {
                fileBase.SaveAs(GetAttendanceSMSDocsDiskLocation(identifier.ToString() + fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length - 5), InstanceId));
            }
            else
            {
                fileBase.SaveAs(GetAttendanceSMSDocsDiskLocation(identifier.ToString() + fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length - 4), InstanceId));
            }
            return identifier.ToString() + fileBase.FileName.ToString().Substring(fileBase.FileName.ToString().Length - 4);
        }
        private string GetAttendanceSMSDocsDiskLocation(string identifier, string InstanceId)
        {
            if (Directory.Exists(_attendanceSMSuploadsFolder + InstanceId))
                return Path.Combine(_attendanceSMSuploadsFolder + InstanceId, identifier);
            else
            {
                Directory.CreateDirectory(_attendanceSMSuploadsFolder + InstanceId);
                return Path.Combine(_attendanceSMSuploadsFolder + InstanceId, identifier);
            }
        }
    }
}