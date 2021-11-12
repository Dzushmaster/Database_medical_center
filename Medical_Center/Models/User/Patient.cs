using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Medical_Center.Models
{
    public class Patient : IUser
    {
        public string name { get; set; }
        public string lastname { get; set;}
        public string surname { get; set; }
        public string email { get; set; }
        public string login { get; set ; }
        public string password { get; set; }
        public Roles role { get; set; }
        public DateTime birthday { get; set; }
        //valid fio ;
        //valid email;
        //valid login;
        //valid password;
        //valid role
        //valid birthday

    }
}
