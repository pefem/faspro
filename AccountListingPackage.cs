//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FindAService_WebForm
{
    using System;
    using System.Collections.Generic;
    
    public partial class AccountListingPackage
    {
        public AccountListingPackage()
        {
            this.AccountListings = new HashSet<AccountListing>();
        }
    
        public string ID { get; set; }
        public string Title { get; set; }
        public double Amount { get; set; }
        public string Description { get; set; }
        public int Duration { get; set; }
        public int Increment { get; set; }
    
        public virtual ICollection<AccountListing> AccountListings { get; set; }
    }
}
