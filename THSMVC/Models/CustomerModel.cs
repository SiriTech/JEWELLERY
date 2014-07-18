using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace THSMVC.Models
{
    public class CustomerModel
    {
        public int Id { get; set; }
        public int InstanceId { get; set; }
        public string Name { get; set; }
        public string CustometNumber { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public int Pin { get; set; }
        public string MobileNUmber1 { get; set; }
		public string MobileNUmber2 { get; set; }
		public string MobileNUmber3 { get; set; }
		public string MobileNUmber4 { get; set; }
		public string MobileNUmber5 { get; set; }
		public string MobileNUmber6 { get; set; }
		public string MobileNUmber7 { get; set; }
		public string MobileNUmber8 { get; set; }
		public string MobileNUmber9 { get; set; }
		public string MobileNUmber10 { get; set; }

		public string MobileNUmber1Com { get; set; }
		public string MobileNUmber2Com { get; set; }
		public string MobileNUmber3Com { get; set; }
		public string MobileNUmber4Com { get; set; }
		public string MobileNUmber5Com { get; set; }
		public string MobileNUmber6Com { get; set; }
		public string MobileNUmber7Com { get; set; }
		public string MobileNUmber8Com { get; set; }
		public string MobileNUmber9Com { get; set; }
		public string MobileNUmber10Com { get; set; }

		public string Email1 { get; set; }
		public string Email2 { get; set; }
		public string Email3 { get; set; }
		public string Email4 { get; set; }
		public string Email5 { get; set; }
		public string Email6 { get; set; }
		public string Email7 { get; set; }
		public string Email8 { get; set; }
		public string Email9 { get; set; }
		public string Email10 { get; set; }

		public string Email1Com { get; set; }
		public string Email2Com { get; set; }
		public string Email3Com { get; set; }
		public string Email4Com { get; set; }
		public string Email5Com { get; set; }
		public string Email6Com { get; set; }
		public string Email7Com { get; set; }
		public string Email8Com { get; set; }
		public string Email9Com { get; set; }
		public string Email10Com { get; set; }

        public int PhoneNumber { get; set; }
        public bool Isfile1Exists { get; set; }
        public string File1 { get; set; }
        public string File1Guid { get; set; }
        public bool Isfile2Exists { get; set; }
        public string File2 { get; set; }
        public string File2Guid { get; set; }
        public bool Isfile3Exists { get; set; }
        public string File3 { get; set; }
        public string File3Guid { get; set; }
        public string BtnText { get; set; }
    }
}