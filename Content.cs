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
    
    public partial class Content
    {
        public Content()
        {
            this.ContentImages = new HashSet<ContentImage>();
        }
    
        public string ID { get; set; }
        public string Title { get; set; }
        public string Body { get; set; }
        public string MetaTitle { get; set; }
        public string MetaDescription { get; set; }
        public string Keyword { get; set; }
        public string URL { get; set; }
        public System.DateTime DateCreated { get; set; }
        public string CoverImage { get; set; }
        public bool ShowImage { get; set; }
        public bool SingletonApp { get; set; }
        public string Author_ID { get; set; }
        public string Category_ID { get; set; }
        public int PageTemplate { get; set; }
        public int Increment { get; set; }
    
        public virtual ContentCategory ContentCategory { get; set; }
        public virtual ICollection<ContentImage> ContentImages { get; set; }
    }
}