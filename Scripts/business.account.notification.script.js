window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        layout_bdy = page.getElementsByAttribute("layout-obj", "body")[0],
        rlatd_itms_pnl = page.getElementByAttribute("related-pnl-obj", "related-photo-preview");

    var cbox = page.getElementByAttribute("wnd-obj", "diag");
    var yes_btn = cbox.getElementByAttribute("bttn-obj", "yes");
    var no_btn = cbox.getElementByAttribute("bttn-obj", "no");

    //
    // Confirm Box
    confirmbox = function () {
        return {
            show: function (param) {
                cbox.setAttribute("show", "");
                cbox.getElementByAttribute("chrome-obj", "msag").innerHTML = param.text;
                yes_btn.addEventListener("mousedown", function () {
                    cbox.removeAttribute("show");
                    //
                    if (param.yes)
                        param.yes({});

                    this.removeEventListener("mousedown", function () { }, false);
                });
                no_btn.addEventListener("mousedown", function () {
                    cbox.removeAttribute("show");
                    //
                    if (param.no)
                        param.no({});
                });
            }
        }
    };

    //
    // Message Area
    var msg_tpad = page.getElementByAttribute("hdr-obj", "txt-pad");

    if (msg_tpad) {
        msg_tpad.addEventListener("paste", function (evt) {
            evt.preventDefault();
            var text = (evt.originalEvent || evt).clipboardData.getData('text/plain');
            document.execCommand('insertText', false, text);
        });

        var post_btn = page.getElementByAttribute("btn-pad-obj", "btn");
        post_btn.addEventListener("mousedown", function (evt) {
            var msg_tpad_txt = document.getElementById("msg-txt").value;
            if (!msg_tpad_txt.empty()) {
                document.getElementById("post-msg-frm").submit();
            }
        });
    }
    else {
        var post_btns = page.getElementsByAttribute("btn-pad-obj", "btn");
        if (post_btns != null) {
            post_btns.map(function (post_btn) {
                post_btn.addEventListener("mousedown", function (evt) {
                    if (this.getAttribute("id") == "send-btn") {
                        document.getElementById("post-msg-frm").submit();
                    }
                    else {
                        console.log("Cancelling...");
                    }
                });
            });
        }
    }

    //
    // List Area
    var lst_itms = page.getElementsByAttribute("lstvw-obj", "itm");
    if ((lst_itms != null) && lst_itms.length > 0) {
        lst_itms.map(function (itm) {
            var btn = itm.getElementByAttribute("itm-obj", "btn");
            if (btn != null) {
                btn.addEventListener("mousedown", function (evt) {
                    var btn = this;
                    var cfrm = new confirmbox();
                    cfrm.show({
                        text: 'Are you sure you want to send this request to "' + btn.getAttribute("name") + '"? (Y/N)',
                        yes: function (param) {
                            var frm = btn.parentNode.getElementsByTagName("form")[0];
                            frm.submit();
                        }
                    });
                    evt.cancelBubble = true;
                    evt.preventDefault();

                });
            }

            var buttn = itm.getElementByAttribute("itm-obj", "buttn");
            if (buttn != null) {
                buttn.addEventListener("mousedown", function (evt) {
                    var btn = this;
                    var cfrm = new confirmbox();
                    cfrm.show({
                        text: "Are you sure you want to delete this request? (Y/N)",
                        yes: function (param) {
                            var frm = btn.getElementsByTagName("form")[0];
                            frm.submit();
                        }
                    });
                    evt.cancelBubble = true;
                    evt.preventDefault();
                });
            }

            var a = itm.getElementsByTagName("a")[0];
            if (a != null) {
                a.addEventListener("mousedown", function (evt) {
                    document.location.href = this.getAttribute("href");
                    evt.cancelBubble = true;
                    evt.preventDefault();
                });
            }


            itm.addEventListener("mousedown", function (evt) {
                if (evt.button != 2 && this.getAttribute("url")) {
                    document.location.href = this.getAttribute("url");
                }
            });
        });
    }


    var serv_cmb = page.getElementByAttribute("name", "serv-cmb");
    if (serv_cmb) {
        serv_cmb.addEventListener("change", function (evt) {
            if (this.options[this.selectedIndex].value != "All") {
                location.href = "?p=" + this.getAttribute("p") + "&u=" + this.getAttribute("u") + "&m=" + this.getAttribute("m") + "&t=" + this.getAttribute("t") + "&c=" + this.options[this.selectedIndex].value;
            }
            else {
                location.href = "?p=" + this.getAttribute("p") + "&u=" + this.getAttribute("u") + "&m=" + this.getAttribute("m") + "&t=" + this.getAttribute("t")
            }
        });
    }


    var bcateg_cmb = page.getElementByAttribute("name", "bizcateg-cmb");
    if (bcateg_cmb) {
        bcateg_cmb.addEventListener("change", function (evt) {
            if (this.options[this.selectedIndex].value != "All") {
                location.href = "?p=" + this.getAttribute("p") + "&u=" + this.getAttribute("u") + "&m=" + this.getAttribute("m") + "&t=" + this.getAttribute("t") + "&c=" + this.options[this.selectedIndex].value;
            }
            else {
                location.href = "?p=" + this.getAttribute("p") + "&u=" + this.getAttribute("u") + "&m=" + this.getAttribute("m") + "&t=" + this.getAttribute("t")
            }
        });
    }




    var choose_locatn_wnd = page.getElementByAttribute("wnd-obj", "choose-locatn-diag");
    var cancel_btn = choose_locatn_wnd.getElementByAttribute("bttn-obj", "no");
    var submit_btn = choose_locatn_wnd.getElementByAttribute("bttn-obj", "yes");

    var city_cmb = choose_locatn_wnd.getElementByAttribute("name", "cmbCity");
    var state_cmb = choose_locatn_wnd.getElementByAttribute("name", "cmbState");
    var cntry_cmb = choose_locatn_wnd.getElementByAttribute("name", "cmbCntry");

    cntry_cmb.addEventListener("change", function (evt) {
        get_states(this.options[this.selectedIndex].value);
    });
    state_cmb.addEventListener("change", function () {
        get_cities(this.options[this.selectedIndex].value);
    });
    city_cmb.addEventListener("change", function () {

    });

    get_cities = function (state) {
        xhr({
            url: "?p=getcities",
            data: {
                id: state
            },
            onready: function (param) {
                try {
                    city_cmb.clear();
                    if (param.response && param.response.length > 0) {
                        city_cmb.removeAttribute("disabled");

                        var cities = param.response;
                        for (var city in cities) {
                            var opt = new Option(cities[city].CityName, cities[city].ID);
                            if (cities[city].ID)
                                city_cmb.appendChild(opt);
                        };
                        city_cmb.value = city_cmb.getAttribute("id");
                    }
                    else {
                        city_cmb.setAttribute("disabled", "true");
                    }
                } catch (e) {
                    throw e;
                }
            }
        });
    };
    get_states = function (country) {
        xhr({
            url: "?p=getstates",
            data: {
                id: country
            },
            onready: function (param) {
                try {
                    state_cmb.clear();
                    if (param.response && param.response.length > 0) {
                        state_cmb.removeAttribute("disabled");

                        var states = param.response;
                        for (var state in states) {
                            var opt = new Option(states[state].StateName, states[state].ID);
                            if (states[state].ID)
                                state_cmb.appendChild(opt);
                        };

                        state_cmb.value = state_cmb.getAttribute("id");
                        
                        //
                        // Get Cities

                        get_cities(state_cmb.options[state_cmb.selectedIndex].value);
                    }
                    else {
                        var opt = new Option("No state found!");
                        state_cmb.appendChild(opt);
                        state_cmb.setAttribute("disabled", "true");

                        city_cmb.clear();
                        var opt = new Option("No city found!");
                        city_cmb.appendChild(opt);
                        city_cmb.setAttribute("disabled", "true");
                    }
                } catch (e) {
                    throw e;
                }
            }
        });
    };
    (function () {
        cntry_cmb.value = cntry_cmb.getAttribute("id");
        get_states(cntry_cmb.options[cntry_cmb.selectedIndex].value);
    })();

    //
    // Preview Box
    chooseLocationWnd = function () {
        return {
            show: function (param) {
                choose_locatn_wnd.setAttribute("show", "");
                cancel_btn.addEventListener("mousedown", function () {
                    choose_locatn_wnd.removeAttribute("show");
                });
                submit_btn.addEventListener("mousedown", function () {
                    choose_locatn_wnd.removeAttribute("show");

                    var cntry_cmb = choose_locatn_wnd.getElementByAttribute("name", "cmbCntry");
                    var state_cmb = choose_locatn_wnd.getElementByAttribute("name", "cmbState");
                    var city_cmb = choose_locatn_wnd.getElementByAttribute("name", "cmbCity");

                    var country_id = cntry_cmb.options[cntry_cmb.selectedIndex].value;
                    var state_id = state_cmb.options[state_cmb.selectedIndex].value;
                    var city_id = city_cmb.options[city_cmb.selectedIndex].value;

                    var country_txt = cntry_cmb.options[cntry_cmb.selectedIndex].text;
                    var state_txt = state_cmb.options[state_cmb.selectedIndex].text;
                    var city_txt = city_cmb.options[city_cmb.selectedIndex].text;

                    var loactn_hint = page.getElementByAttribute("cmb-obj", "lbl");
                    loactn_hint.innerHTML = city_txt + ", " + state_txt + ". " + country_txt;

                    var changeloctnfrm = document.getElementById("changeloctnfrm");
                    changeloctnfrm.submit();

                });
            }
        }
    };

    var locatn_btn = page.getElementByAttribute("cmb-obj", "btn");
    if (locatn_btn) {
        locatn_btn.addEventListener("mousedown", function (evt) {
            var locatn = new chooseLocationWnd();
            locatn.show({
                title: 'Choose a Location'
            });
        });
    }

});