using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.App_Code
{
    public interface IFileStore
    {
        string SaveUploadedFile(HttpPostedFileBase fileBase,int InstanceId);
        string SaveNoticeUploadedFile(HttpPostedFileBase httpPostedFileBase, string InstanceID);
        string SaveAttendanceUploadedFile(HttpPostedFileBase httpPostedFileBase, string InstanceID);
    }
}