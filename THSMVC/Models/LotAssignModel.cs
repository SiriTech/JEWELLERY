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
    }
}