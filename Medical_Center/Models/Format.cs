using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Medical_Center.Models
{
    public class Format
    {
        public bool checkFormatName(string name) => new Regex("а-яА-ЯЁёa-zA-Z]{10,20}$").IsMatch(name);
        public bool checkFormatEmail(string email) => new Regex(@"\w+@\w+\.\w+").IsMatch(email);
        public bool checkFormatPassword(string password) => new Regex(@"\w{10,20}$").IsMatch(password);
    }
}
