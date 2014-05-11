using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class LotUserMappingModel
    {

        public int LotId
        {
            get;
            set;
        }
       
        public string LotName
        {
            get;
            set;
        }
       
        public string UserName
        {
            get;
            set;
        }
      
        public string Status
        {
            get;
            set;
           
        }
       
        public int InstanceId
        {
            get;
            set;
        }
      
        public int UserId
        {
            get;
            set;
        }
     
        public int StatusId
        {
            get;
            set;
        }
    }
}