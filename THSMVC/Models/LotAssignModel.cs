using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class LotAssignModel
    {
        public List<User> UserList { set; get; }
        public int userId { set; get; }
        public List<Lot> LotList { set; get; }
        public int LotId { get; set; }

        public string UserName { get; set; }
        public string LotName { get; set; }
        public string Status { get; set; }
        public int StatusId { get; set; }
        public string AcceptLink { get; set; }
    }
}