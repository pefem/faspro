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
    
    public partial class AccountListing
    {
        public string ID { get; set; }
        public System.DateTime DateCreated { get; set; }
        public int Status { get; set; }
        public string ReceiptNo { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string User_ID { get; set; }
        public string AccountListingPackage_ID { get; set; }
        public int Increment { get; set; }
    
        public virtual AccountListingPackage AccountListingPackage { get; set; }
        public virtual UserIndividual UserIndividual { get; set; }
    }
}
