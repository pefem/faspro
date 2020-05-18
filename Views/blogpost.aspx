<%@ Page Language="C#" MasterPageFile="Shared/BlogPostPage.Master" AutoEventWireup="true" CodeBehind="blogpost.aspx.cs" Inherits="FindAService_WebForm.Views.blogpost" %>


<asp:Content ID="script" ContentPlaceHolderID="script_area" runat="server">
    <script src="/Scripts/prototype.script.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="style_area" ContentPlaceHolderID="style_area" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="menu_area" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var individualCntr = new FindAService_WebForm.Controllers.IndividualUserController();
        var businessCntr = new FindAService_WebForm.Controllers.BusinessUserController();
        var adsCntr = new FindAService_WebForm.Controllers.AdsController();
        var user = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
        {
            Email = Request["u"]
        });

        //if (user == null)
        //{
        //    Response.Redirect("?p=nopage");
        //}
        var howitworks = db.ContentCategories.Where(x => x.PageSection == (int)FindAService_WebForm.PageSection.homepage_howitwrk).FirstOrDefault();
        if (Session["user_account_active"] == null || ((bool)Session["user_account_active"]) != true)
        {
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><a href=".">Home</a></div>
        <%
            //if (howitworks != null)
            //{
            //    var hwitwrk_cntnt = db.Contents.Where(x => x.Category_ID == howitworks.ID).OrderBy(x => x.Increment).FirstOrDefault();
            //    if (hwitwrk_cntnt != null)
            //    {
        %>
        <%--<div menu-obj="item"><a href="?p=content&title=<% Response.Write(hwitwrk_cntnt.Title.ToLower()); %>&category=<% Response.Write(howitworks.Increment); %>&uid=&<% Response.Write(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Guid.NewGuid().ToString())).ToLower()); %>&id=<% Response.Write(hwitwrk_cntnt.Increment); %>">How it works</a></div>--%>
        <%
            //    }
            //}
        %>
        <!--<div menu-obj="item"><a href="?p=advertise">Advertise</a></div>-->
        <div menu-obj="item"><a href="?p=blog">Blog</a></div>
        <div menu-obj="item"><a href="?p=login">Login</a></div>
        <div menu-obj="item" aria-selected="true"><a href="?p=signup">Sign Up</a></div>
    </div>
    <%
        }
        else
        {
            var email = "";
            var name = "";
            
            var iusr = individualCntr.GetUser(new FindAService_WebForm.UserIndividual
             {
                 Email = Session["user_account_email"].ToString()
             });
            if (iusr == null)
            {
                var busr = businessCntr.GetUser(new FindAService_WebForm.UserBusiness
                {
                    Email = Session["user_account_email"].ToString()
                });
                if (busr != null)
                {
                    email = busr.Email.ToString();
                    name = busr.BusinessName.ToString();
                }
            }
            else
            {
                email = iusr.Email.ToString();
                name = iusr.FirstName.ToString();
            }
    %>
    <div btn-obj="menu-list">
        <div menu-obj="item"><span text><a href="?p=account&u=<% Response.Write(email); %>"><% Response.Write(name); %></a></span></div>
        <div menu-obj="item"><span text><a href="?p=account&tb=3&mode=cinf&u=<% Response.Write(email); %>">Settings</a></span></div>
        <div menu-obj="item"><span text><a href="?p=blog">Blog</a></span></div>
        <div menu-obj="item"><span text><a href="?p=logout">Logout</a></span></div>
    </div>
    <%
        }
    %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main_body" runat="server">
    <%
        var db = new FindAService_WebForm.FASDBEntities();
        var logged_in_usr = "";
        if (Session["user_account_email"] != null)
        {
            logged_in_usr = Session["user_account_email"].ToString();
        }

        if (Request["post"] == null)
        {
    %>
    <div layout-obj="header"></div>
    <form method="post" action="?p=doblogsearch" enctype="application/x-www-form-urlencoded" accept-charset="">
        <div layout-obj="blog-post-search">
                <div search="field">
                    <div field-obj="textbox"><input name="what_txt" value="<% Response.Write((Request["q"] != null && Request["q"] != "") ? Request["q"] : ""); %>" type="text" placeholder="Blog Search..." /></div>
                </div>
                <div search="button">
                    <div button-obj="submit"><span>Search</span><input type="submit" /></div>
                </div>
        </div>
    </form>  
    <div layout-obj="blog-posts">    
        <%
            var page = 0;
            int.TryParse(Request["page"], out page);

            var blogPostCntr = new FindAService_WebForm.Controllers.BlogPostController();
            var posts = blogPostCntr.GetPosts(((Request["q"] != null && Request["q"] != "") ? Request["q"] : ""), (Request["page"] != null ? page : 1));

            if(posts != null)
            {
                foreach (var post in posts)
                {
                    var authrName = "";
                    var image = "";
                    var author = db.Admins.Find(post.Author_ID);
                    if (author != null)
                    {
                        authrName = author.FirstName + " " + author.LastName;
                        image = author.ImageUrl;
                    }

                    var post_cover_image = "";
                    if (post.User_ID == null)
                    {
                        post_cover_image = "?p=blogpostimage&url=" + post.CoverImage;
                    }
                    else
                    {
                        var iuser = db.UserIndividuals.Find(post.User_ID);
                        if (iuser != null)
                        {
                            post_cover_image = "?p=avatar&url=" + iuser.ImageUrl; //.Substring(0, iuser.ImageUrl.LastIndexOf('.'));
                        }
                        else
                        {
                            var buser = db.UserBusinesses.Find(post.User_ID);
                            if (buser != null)
                            {
                                post_cover_image = "?p=cover&url=" + buser.CoverImageUrl; //.Substring(0, buser.CoverImageUrl.LastIndexOf('.'));
                            }
                        }
                    }
        %>
        <div posts-item="post">
            <div post="article">
                <div article="hint">
                    <div hint="title"><a href="?p=blog&post=<% Response.Write(HttpUtility.UrlEncode(post.Title)); %>&id=<% Response.Write(post.Increment); %>"><% Response.Write(post.Title); %></a></div>
                    <div hint="authr"><span><% Response.Write(authrName); %></span> <span><% Response.Write(post.DateCreated.ToString("dddd, MMMM dd, yyyy")); %></span></div>
                    <div hint="sumry">
                        <% Response.Write(post.MetaDescription); %>
                    </div>
                </div>
            </div>
            <div post="banner" style="background-image: url('<% Response.Write(post_cover_image); %>')"></div>
        </div>
        <%
                }

                if ((int)Session["totalPages"] > 1)
                {
        %>
        <div posts-obj="paging">
            <div paging-obj="pages">
                <%
                    var pages = blogPostCntr.ShowPages();
                    Response.Write(pages);                                                  
                %>
            </div>
            <div paging-obj="title"><% Response.Write("Page " + Session["currentPage"] + " of " + Session["totalPages"]); %></div>
        </div>
        <%
                }
            }    
        %>
    </div>
    <%
    }
    else if (Request["post"] != null)
    {
    %>
    <div layout-obj="article-reader">
        <div reader="pane">
            <div pane="article">
                <%
                    var blogPostCntr = new FindAService_WebForm.Controllers.BlogPostController();
                    var post = blogPostCntr.GetPost(Request["id"]);
                    var authrName = "";
                    var image = "";
                    var author = db.Admins.Find(post.Author_ID);
                    if (author != null)
                    {
                        authrName = author.FirstName + " " + author.LastName;
                        image = author.ImageUrl;
                    }

                    var post_cover_image = "";
                    if (post.User_ID == null)
                    {
                        post_cover_image = "?p=blogpostimage&url=" + post.CoverImage;
                    }
                    else
                    {
                        var iuser = db.UserIndividuals.Find(post.User_ID);
                        if (iuser != null)
                        {
                            post_cover_image = "?p=avatar&url=" + iuser.ImageUrl; //.Substring(0, iuser.ImageUrl.LastIndexOf('.'));
                        }
                        else
                        {
                            var buser = db.UserBusinesses.Find(post.User_ID);
                            if (buser != null)
                            {
                                post_cover_image = "?p=cover&url=" + buser.CoverImageUrl; //.Substring(0, buser.CoverImageUrl.LastIndexOf('.'));
                            }
                        }
                    }
                %>
                <div article="content">
                    <% 
                        if (post_cover_image != null && post_cover_image != "")
                        {
                    %>
            		<div content="banner" style="background-image: url('<% Response.Write(post_cover_image); %>')"></div>
                    <% 
                        }; 
                    %>
                    <div content="title"><% Response.Write(post.Title); %></div>
                    <div content="authr"><span>By <% Response.Write(authrName); %></span> <span><% Response.Write(post.DateCreated.ToString("dddd, MMMM dd, yyyy")); %></span></div>
                    <div content="sumry"><% Response.Write(post.Article); %></div>
                </div>
                <div article="comment">
                	<div id="disqus_thread"></div>
					<script>
					    var disqus_config = function () {
					        this.page.url = document.location.href;
					        this.page.identifier = Request["id"];
					    };

					    (function () {
					        var d = document, s = d.createElement('script');
					        s.src = '//uvind-com.disqus.com/embed.js';
					        s.setAttribute('data-timestamp', +new Date());
					        (d.head || d.body).appendChild(s);
					    })();
                    </script>
                    <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
                </div>
            </div>
            <div pane="widget">
            	<%--<div widget="item" about>
                	<div item="title">About</div>
                    <div item="body">
                    	This blog is curated by the team at <?php echo APPNAME; ?>. We write articles focused on on design, brand insights, leadership, culture, stories and why ideas spread.
                    </div>
                </div>--%>
                <div widget="item" blog-posts>
                	<div item="title">Recent Blog Post</div>
                    <div item="posts">        
                    <%
                        var page = 0;
                        int.TryParse(Request["page"], out page);

                        var posts = blogPostCntr.GetPosts(null, (Request["page"] != null ? page : 1)).Take(5);

                        foreach (var postItem in posts)
                        {

                            var postItem_cover_image = "";
                            if (postItem.User_ID == null)
                            {
                                postItem_cover_image = "?p=blogpostimage&url=" + postItem.CoverImage;
                            }
                            else
                            {
                                var iuser = db.UserIndividuals.Find(postItem.User_ID);
                                if (iuser != null)
                                {
                                    postItem_cover_image = "?p=avatar&url=" + iuser.ImageUrl; //.Substring(0, iuser.ImageUrl.LastIndexOf('.'));
                                }
                                else
                                {
                                    var buser = db.UserBusinesses.Find(postItem.User_ID);
                                    if (buser != null)
                                    {
                                        postItem_cover_image = "?p=cover&url=" + buser.CoverImageUrl; //.Substring(0, buser.CoverImageUrl.LastIndexOf('.'));
                                    }
                                }
                            }
                    %>
                    	<div posts="post">
                            <div post="banner" style="background-image: url('<% Response.Write(postItem_cover_image); %>')"><a href="?p=blog&post=<% Response.Write(HttpUtility.UrlEncode(postItem.Title)); %>&id=<% Response.Write(postItem.Increment); %>"></a></div>
                            <div post="title"><a href="?p=blog&post=<% Response.Write(HttpUtility.UrlEncode(postItem.Title)); %>&id=<% Response.Write(postItem.Increment); %>"><% Response.Write(postItem.Title); %></a></div>
                        </div>
                     <%
                     }
                     %>
                    </div>
                </div>
                <div widget="item" newsletter>
                	<div item="title">Newsletter</div>
                    <div item="body">
                    	Subscribe and get our inspiring newsletter on tips and tricks to grow your business.
                    </div>
                    <div item="form">
                        <form method="post" action="?p=donewslettersignup">
                    	    <div form="row" field>
                                <div field-obj="textbox">
                        	        <input type="text" placeholder="Your Email Address" />
                                </div>
                            </div>
                    	    <div form="row" button>
                                <div button-obj="submit">
                                    <span>Subscribe</span>
                                    <input type="submit" value="Subscribe" />
                        	    </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
    }
    %>
</asp:Content>
