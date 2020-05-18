using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FindAService_WebForm.Models
{
    public class Paginator
    {
        public int Page { get; set; }
        public int ToatalPages { get; set; }
        public int ToatalResults { get; set; }
        public int RowsPerPage { get; set; }
        public int URL { get; set; }
    }
}
