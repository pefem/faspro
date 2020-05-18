window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        layout_bdy = page.getElementsByAttribute("layout-obj", "body")[0],
        rlatd_itms_pnl = page.getElementByAttribute("related-pnl-obj", "related-photo-preview");

    show_rating = function (itm) {
        var rlated_ftr = page.getElementByAttribute("related-obj", "ftr");
        var rlated_ftr_hdr = rlated_ftr.getElementByAttribute("ftr-obj", "hdr").getElementsByTagName("a")[0];
        var rlated_ftr_cmpny = rlated_ftr.getElementByAttribute("ftr-obj", "cmpny");
        var rlated_ftr_link = rlated_ftr.getElementByAttribute("ftr-obj", "link");

        rlated_ftr_hdr.innerHTML = itm.getAttribute("name");
        rlated_ftr_hdr.setAttribute("href", itm.getElementsByTagName("a")[0].href);

        var rlated_ftr = page.getElementByAttribute("related-obj", "ftr");
        var rating = itm.getAttribute("rating");
        var whole_part = Math.floor(rating);
        var decimal_prt = rating - Math.floor(rating);

        var stars = rlated_ftr.getElementsByAttribute("rating-obj", "star");
        for (var i = 1, star; star = stars[i - 1]; i++) {
            star.setAttribute("percentage", percent);
            star.getElementByAttribute("star-obj", "percent").removeAttribute("style");
        }

        for (var i = 1, star; star = stars[i - 1]; i++) {
            var percent = 0.0;
            if (i <= Math.ceil(rating)) {
                percent = (i <= whole_part) ? 100 : (decimal_prt * 100);
                star.setAttribute("percentage", percent);
                star.getElementByAttribute("star-obj", "percent").setAttribute("style", "width:" + percent + "%");
            }
        }

        Array.prototype.forEach.call(rlatd_itms, function (rlatd_itm) {
            rlatd_itm.removeAttribute("selected");
        });
        itm.setAttribute("selected", "");
    }

    if (rlatd_itms_pnl) {
        var rlatd_itms = rlatd_itms_pnl.getElementsByAttribute("photo-wrappr-obj", "photo");
        Array.prototype.forEach.call(rlatd_itms, function (rlatd_itm) {
            rlatd_itm.addEventListener("mouseover", function (evt) {
                show_rating(this);
            });
        });


        //
        // Select first item

        show_rating(rlatd_itms[0]);
    }

    //
    // Comment Area

    var comment_tpad = page.getElementByAttribute("hdr-obj", "txt-pad");
    if (comment_tpad) {
        comment_tpad.addEventListener("paste", function (evt) {
            evt.preventDefault();
            var text = (evt.originalEvent || evt).clipboardData.getData('text/plain');
            document.execCommand('insertText', false, text);
        });
        var post_btn = page.getElementByAttribute("hdr-obj", "post-btn");
        if (post_btn) {
            post_btn.addEventListener("mousedown", function (evt) {
                if (!comment_tpad.innerText.empty()) {
                    document.getElementById("comment-txt").value = comment_tpad.innerText
                    document.getElementById("comment-frm").submit();
                }
            });
        }
    }

    

    if (page.getElementsByAttribute("coporate-obj", "hdr")) {

        var layout_hdr = page.getElementsByAttribute("coporate-obj", "hdr")[0];

        //
        // Rating

        var rating = layout_hdr.getElementByAttribute("hdr-obj", "rating");
        var rating_frm = rating.getElementsByTagName("form")[0];
        var stars = rating.getElementsByAttribute("rating-obj", "star");

        get_user_rating = function (fb_response) {
            xhr({
                url: "?p=getrating",
                data: {
                    owner_id: fb_response.owner_id,
                    user_id: fb_response.user_id
                },
                onready: function (param) {
                    try {
                        var response = param.response;
                        var ratd_star = eval(response.Star1) ? 1 :
                                        (eval(response.Star2) ? 2 :
                                        (eval(response.Star3) ? 3 :
                                        (eval(response.Star4) ? 4 :
                                        (eval(response.Star5) ? 5 : 0))));

                        for (var i = 0; i <= ratd_star - 1; i++) {
                            stars[i].setAttribute("full", "");
                        }
                    } catch (e) {
                        throw e;
                    }
                }
            });
        };
        //get_user_rating({
        //    owner_id: "878960897687",
        //    user_id: document.getElementById("txtUserID").value
        //});

        window.fbAsyncInit = function () {
            FB.init({
                appId: '918578634878592',
                cookie: true,
                xfbml: true,
                version: 'v2.5'
            });

            FB.getLoginStatus(function (response) {
                if (response.status === 'connected') {
                    FB.api('/me?fields=id,name,email,first_name,last_name', function (response) {
                        get_user_rating({
                            owner_id: response.id,
                            user_id: document.getElementById("txtUserID").value
                        });
                    });
                }
            });

        };

        //
        // Load the SDK asynchronously
        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));

        stars.map(function (star) {

            star.addEventListener("mousemove", function (evt) {
                // Clear
                stars.map(function (star) {
                    star.removeAttribute("hover");
                });

                var loop_cntr = this.getAttribute("indx");
                for (var i = 0; i <= loop_cntr - 1; i++) {
                    stars[i].setAttribute("hover", "");
                }
            });

            star.addEventListener("mouseout", function (evt) {
                // Clear
                stars.map(function (star) {
                    star.removeAttribute("hover");
                });
            });

            star.addEventListener("mousedown", function (evt) {
                if (evt.button == 0) {
                    //
                    // Clear
                    stars.map(function (star) {
                        star.removeAttribute("full");
                        star.getElementsByTagName("input")[0].value = "0";
                    });

                    var loop_cntr = this.getAttribute("indx");
                    for (var i = 0; i <= loop_cntr - 1; i++) {
                        stars[i].setAttribute("full", "");
                    }

                    this.getElementsByTagName("input")[0].value = 1;

                    //
                    // Login with facebook
                    FB.getLoginStatus(function (response) {
                        if (response.status !== 'connected') {
                            FB.login(function (response) {
                                if (response.authResponse) {
                                    FB.api('/me?fields=id,name,email,first_name,last_name', function (response) {
                                        var fname_txt = rating_frm.getElementByAttribute("name", "fname_txt");
                                        var lname_txt = rating_frm.getElementByAttribute("name", "lname_txt");
                                        var email_txt = rating_frm.getElementByAttribute("name", "email_txt");
                                        var owner_txt = rating_frm.getElementByAttribute("name", "owner_txt");
                                        //
                                        owner_txt.value = response.id ? response.id : "";
                                        fname_txt.value = response.first_name ? response.first_name : "";
                                        lname_txt.value = response.last_name ? response.last_name : "";
                                        email_txt.value = response.email ? response.email : "";
                                        rating_frm.submit();
                                    });
                                }
                            }, { scope: 'email,user_likes' });
                        }
                        else {
                            //
                            // Check if user has rated before
                            // If not allow user to rate
                            // 
                            FB.api('/me?fields=id,name,email,first_name,last_name', function (response) {
                                var fname_txt = rating_frm.getElementByAttribute("name", "fname_txt");
                                var lname_txt = rating_frm.getElementByAttribute("name", "lname_txt");
                                var email_txt = rating_frm.getElementByAttribute("name", "email_txt");
                                var owner_txt = rating_frm.getElementByAttribute("name", "owner_txt");
                                //
                                owner_txt.value = response.id ? response.id : "";
                                fname_txt.value = response.first_name ? response.first_name : "";
                                lname_txt.value = response.last_name ? response.last_name : "";
                                email_txt.value = response.email ? response.email : "";
                                rating_frm.submit();
                            });
                        }
                    });
                }
            });
        });
    }
});