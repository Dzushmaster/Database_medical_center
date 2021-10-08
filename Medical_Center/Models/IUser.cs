using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Medical_Center.Models
{
    interface IUser
    {
        string name { get; set; }
        string lastname{ get; set; }
        string surname { get; set; }
        string email { get; set; }
        string login { get; set; }
        string password { get; set; }
        Roles role { get; set; }
        DateTime birthday { get; set; }
    }
}
