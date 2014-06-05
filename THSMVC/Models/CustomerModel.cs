using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class CustomerModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string CustometNumber { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public int Pin { get; set; }
        public int Mobile { get; set; }
        public int PhoneNumber { get; set; }
        public string EmailAddress { get; set; }
        public string BtnText { get; set; }
    }
}