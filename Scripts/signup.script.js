window.addEventListener("DOMContentLoaded", function () {
    var bdy = document.body;

    var page = bdy.getElementByAttribute("page", "layout");
    var form_page = page.getElementByAttribute("signup-obj", "bdy");
    var forms = form_page.getElementsByAttribute("ftype");
    var tabs = form_page.getElementByAttribute("bdy-obj", "tab").getElementsByTagName("li");
    var selected_tab = null;
    var selected_tab_page = null;
    Array.prototype.forEach.call(tabs, function (tab_btn, indx) {
        tab_btn.addEventListener("mousedown", function (evt) {
            Array.prototype.forEach.call(tabs, function (tab_btn, indx) {
                tab_btn.removeAttribute("selected");
            });
            selected_tab = this;
            selected_tab.setAttribute("selected", "true");

            var selected_frm = null;
            Array.prototype.forEach.call(forms, function (form, indx) {
                form.setAttribute("class", "hide_form");
                if (selected_tab.getAttribute("form") == form.getAttribute("ftype")) {
                    selected_frm = form;
                }
            });
            selected_frm.removeAttribute("class");

            //
            // Clear Password
            if (ipwdtxt)
                ipwdtxt.value = "";

            if (irpwdtxt)
                irpwdtxt.value = "";

            if (bpwdtxt)
                bpwdtxt.value = "";

            if (brpwdtxt)
                brpwdtxt.value = "";

            selected_tab_page = form_page.getElementByAttribute("ftype", tab_btn.getAttribute("form"));

            city_cmb = selected_tab_page.getElementByAttribute("name", "cityCmb");
            state_cmb = selected_tab_page.getElementByAttribute("name", "stateCmb");
            cntry_cmb = selected_tab_page.getElementByAttribute("name", "countryCmb");

            cntry_cmb.addEventListener("change", function (evt) {
                get_states(this.options[this.selectedIndex].value);
            });
            state_cmb.addEventListener("change", function () {
                get_cities(this.options[this.selectedIndex].value);
            });

            (function () {
                if (cntry_cmb.getAttribute("id") != "") {
                    cntry_cmb.value = cntry_cmb.getAttribute("id");
                }
                if (cntry_cmb.options.length > 0)
                    get_states(cntry_cmb.options[cntry_cmb.selectedIndex].value);
            })();


            var submt_btn = selected_tab_page.getElementByAttribute("id", "submt-btn");
            //var chkTrms = selected_tab_page.getElementByAttribute("id", "chkTerms");
            //chkTrms.addEventListener("click", function (evt) {
            //    if (this.checked == true) {
            //        submt_btn.disabled = false;
            //    }
            //    else {
            //        submt_btn.disabled = true;
            //    }
            //});


            var post_frm = selected_tab_page.getElementByAttribute("id", "frm").addEventListener("submit", function (evt) {
                if (validateFrm(this)) {
                    this.submit();
                }
                evt.cancelBubble = true;
                evt.preventDefault();
            });


            //
            // Clear Notifier
            (clearNotifier = function () {
                //var notifier = document.getElementById("hintbox");
                var notifier = selected_tab_page.getElementByAttribute("id", "hintbox");
                if (notifier) {
                    var notifier_parent = notifier.parentNode;
                    notifier_parent.removeChild(notifier); //console.log(notifier_parent);
                    if (notifier) {
                        setTimeout(function () {
                            xhr({
                                url: "?p=clearnotifier",
                                data: null,
                                onready: function (param) {
                                    try {
                                        var response = param.response;
                                        notifier.removeAttribute("aria-hidden");
                                    } catch (e) {
                                        throw e;
                                    }
                                }
                            });
                        }, 3000);
                    }
                }
            })();

        });
        if (eval(tab_btn.getAttribute("selected"))) {
            selected_tab_page = form_page.getElementByAttribute("ftype", tab_btn.getAttribute("form"));
        }
    });


    var cbox = page.getElementByAttribute("wnd-obj", "diag");
    var yes_btn = cbox.getElementByAttribute("bttn-obj", "yes");

    //
    // Alert Box
    alertbox = function () {
        return {
            show: function (param) {
                cbox.setAttribute("show", "");
                cbox.getElementByAttribute("chrome-obj", "msag").innerHTML = param.text;
                yes_btn.addEventListener("mousedown", function () {
                    cbox.removeAttribute("show");
                    //
                    if (param.onokay)
                        param.onokay({});

                    this.removeEventListener("mousedown", function () { }, false);
                });
            }
        }
    };


    var city_cmb = selected_tab_page.getElementByAttribute("name", "cityCmb");
    var state_cmb = selected_tab_page.getElementByAttribute("name", "stateCmb");
    var cntry_cmb = selected_tab_page.getElementByAttribute("name", "countryCmb");

    cntry_cmb.addEventListener("change", function (evt) {
        get_states(this.options[this.selectedIndex].value);
    });
    state_cmb.addEventListener("change", function () {
        get_cities(this.options[this.selectedIndex].value);
    });
    city_cmb.addEventListener("change", function () {

    });


    var igenbtn = null, ishwbtn = null,
        ipwdtxt = null, irpwdtxt = null,

        bgenbtn = null, bshwbtn = null,
        bpwdtxt = null, brpwdtxt = null;

    if (selected_tab_page != null) {
        igenbtn = page.getElementByAttribute("id", "igenbtn");
        ishwbtn = page.getElementByAttribute("id", "ishwbtn");
        ipwdtxt = page.getElementByAttribute("id", "itxtPwd");
        irpwdtxt = page.getElementByAttribute("id", "itxtCPwd");

        bgenbtn = page.getElementByAttribute("id", "bgenbtn");
        bshwbtn = page.getElementByAttribute("id", "bshwbtn");
        bpwdtxt = page.getElementByAttribute("id", "btxtPwd");
        brpwdtxt = page.getElementByAttribute("id", "btxtCPwd");

        var chr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var num = "0123456789";
        var alp = "@%*$";

        //igenbtn.addEventListener("mousedown", function (evt) {
        //    var pwd_chr = chr.shuffle();
        //    var num_chr = num.shuffle();
        //    var alp_chr = alp.shuffle();

        //    var str = pwd_chr.substr(0, 5) + "" + num_chr.substr(0, 3) + "" + alp_chr.substr(0, 2);
        //    str = str.shuffle();
        //    ipwdtxt.value = str;
        //    irpwdtxt.value = str;
        //});
        //ishwbtn.addEventListener("mousedown", function (evt) {
        //    if (ishwbtn.value == "Show Password") {
        //        ipwdtxt.setAttribute("type", "text");
        //        irpwdtxt.setAttribute("type", "text");
        //        this.setAttribute("value", "Hide Password");
        //    }
        //    else {
        //        ipwdtxt.setAttribute("type", "password");
        //        irpwdtxt.setAttribute("type", "password");
        //        this.setAttribute("value", "Show Password");
        //    }
        //});

        //bgenbtn.addEventListener("mousedown", function (evt) {
        //    var pwd_chr = chr.shuffle();
        //    var num_chr = num.shuffle();
        //    var alp_chr = alp.shuffle();

        //    var str = pwd_chr.substr(0, 5) + "" + num_chr.substr(0, 3) + "" + alp_chr.substr(0, 2);
        //    str = str.shuffle();
        //    bpwdtxt.value = str;
        //    brpwdtxt.value = str;
        //});
        //bshwbtn.addEventListener("mousedown", function (evt) {
        //    if (bshwbtn.value == "Show Password") {
        //        bpwdtxt.setAttribute("type", "text");
        //        brpwdtxt.setAttribute("type", "text");
        //        this.setAttribute("value", "Hide Password");
        //    }
        //    else {
        //        bpwdtxt.setAttribute("type", "password");
        //        brpwdtxt.setAttribute("type", "password");
        //        this.setAttribute("value", "Show Password");
        //    }
        //});

        var submt_btn = selected_tab_page.getElementByAttribute("id", "submt-btn");
        //var chkTrms = selected_tab_page.getElementByAttribute("id", "chkTerms");
        //chkTrms.addEventListener("click", function (evt) {
        //    if (this.checked == true) {
        //        submt_btn.disabled = false;
        //    }
        //    else {
        //        submt_btn.disabled = true;
        //    }
        //});

        validateFrm = function (frm) {
            var type = frm.getAttribute("type");
            if (type == "individual") {
                var pwdtxt = frm.getElementByAttribute("name", "txtPwd");
                var rpwdtxt = frm.getElementByAttribute("name", "txtCPwd");
                var fnametxt = frm.getElementByAttribute("name", "txtFirstName");
                var lnametxt = frm.getElementByAttribute("name", "txtLastName");
                var caddrtxt = frm.getElementByAttribute("name", "txtContactAddress");
                var phonetxt = frm.getElementByAttribute("name", "txtPhoneNo");
                var emailtxt = frm.getElementByAttribute("name", "txtEmail");
                var countrycmb = frm.getElementByAttribute("name", "countryCmb");
                var statecmb = frm.getElementByAttribute("name", "stateCmb");
                var citycmb = frm.getElementByAttribute("name", "cityCmb");
                var servicescmb = frm.getElementByAttribute("name", "serviceCmb");

                if (pwdtxt.empty()) {
                    var alrtbx = new alertbox();
                    alrtbx.show({
                        text: "Please choose a password to continue",
                        onokay: function (param) {
                            pwdtxt.focus();
                        }
                    });
                }
                else {
                    if (rpwdtxt.empty()) {
                        var alrtbx = new alertbox();
                        alrtbx.show({
                            text: "Please retype the above password to continue",
                            onokay: function (param) {
                                rpwdtxt.focus();
                            }
                        });
                    }
                    else {
                        if (pwdtxt.value != rpwdtxt.value) {
                            var alrtbx = new alertbox();
                            alrtbx.show({
                                text: "Password mismatch! retype your password to continue",
                                onokay: function (param) {
                                    rpwdtxt.focus();
                                }
                            });
                        }
                        else {
                            if (fnametxt.empty()) {
                                var alrtbx = new alertbox();
                                alrtbx.show({
                                    text: "Please enter your first name",
                                    onokay: function (param) {
                                        fnametxt.focus();
                                    }
                                });
                            }
                            else {
                                if (lnametxt.empty()) {
                                    var alrtbx = new alertbox();
                                    alrtbx.show({
                                        text: "Please enter your last name",
                                        onokay: function (param) {
                                            lnametxt.focus();
                                        }
                                    });
                                }
                                else {
                                    if (caddrtxt.empty()) {
                                        var alrtbx = new alertbox();
                                        alrtbx.show({
                                            text: "Please enter your contact address",
                                            onokay: function (param) {
                                                caddrtxt.focus();
                                            }
                                        });
                                    }
                                    else {
                                        if (countrycmb.options.length <= 0) {
                                            var alrtbx = new alertbox();
                                            alrtbx.show({
                                                text: "Please choose a country",
                                                onokay: function (param) {
                                                    // nametxt.focus();
                                                }
                                            });
                                        }
                                        else {
                                            if (statecmb.options.length <= 0) {
                                                var alrtbx = new alertbox();
                                                alrtbx.show({
                                                    text: "Please choose a state",
                                                    onokay: function (param) {
                                                        // nametxt.focus();
                                                    }
                                                });
                                            }
                                            else {
                                                if (citycmb.options.length <= 0) {
                                                    var alrtbx = new alertbox();
                                                    alrtbx.show({
                                                        text: "Please choose a city",
                                                        onokay: function (param) {
                                                            // nametxt.focus();
                                                        }
                                                    });
                                                }
                                                else {
                                                    if (phonetxt.empty()) {
                                                        var alrtbx = new alertbox();
                                                        alrtbx.show({
                                                            text: "Please enter your phone number",
                                                            onokay: function (param) {
                                                                phonetxt.focus();
                                                            }
                                                        });
                                                    }
                                                    else {
                                                        if (emailtxt.empty()) {
                                                            var alrtbx = new alertbox();
                                                            alrtbx.show({
                                                                text: "Please enter your email address",
                                                                onokay: function (param) {
                                                                    emailtxt.focus();
                                                                }
                                                            });
                                                        }
                                                        else {
                                                            if (servicescmb.options.length <= 0) {
                                                                var alrtbx = new alertbox();
                                                                alrtbx.show({
                                                                    text: "Please tell us what you do",
                                                                    onokay: function (param) {
                                                                        // nametxt.focus();
                                                                    }
                                                                });
                                                            }
                                                            else {
                                                                return true
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                var pwdtxt = frm.getElementByAttribute("name", "txtPwd");
                var rpwdtxt = frm.getElementByAttribute("name", "txtCPwd");
                var nametxt = frm.getElementByAttribute("name", "txtName");
                var descrtxt = frm.getElementByAttribute("name", "txtDescr");
                var caddrtxt = frm.getElementByAttribute("name", "txtContactAddress");
                var phonetxt = frm.getElementByAttribute("name", "txtPhoneNo");
                var emailtxt = frm.getElementByAttribute("name", "txtEmail");
                var websitetxt = frm.getElementByAttribute("name", "txtWebsite");
                var bizcategcmb = frm.getElementByAttribute("name", "bizCategryCmb");
                var countrycmb = frm.getElementByAttribute("name", "countryCmb");
                var statecmb = frm.getElementByAttribute("name", "stateCmb");
                var citycmb = frm.getElementByAttribute("name", "cityCmb");

                if (pwdtxt.empty()) {
                    var alrtbx = new alertbox();
                    alrtbx.show({
                        text: "Please choose a password to continue",
                        onokay: function (param) {
                            pwdtxt.focus();
                        }
                    });
                }
                else {
                    if (rpwdtxt.empty()) {
                        var alrtbx = new alertbox();
                        alrtbx.show({
                            text: "Please retype the above password to continue",
                            onokay: function (param) {
                                rpwdtxt.focus();
                            }
                        });
                    }
                    else {
                        if (pwdtxt.value != rpwdtxt.value) {
                            var alrtbx = new alertbox();
                            alrtbx.show({
                                text: "Password mismatch! retype your password to continue",
                                onokay: function (param) {
                                    rpwdtxt.focus();
                                }
                            });
                        }
                        else {
                            if (bizcategcmb.options.length <= 0) {
                                var alrtbx = new alertbox();
                                alrtbx.show({
                                    text: "Please choose a business category",
                                    onokay: function (param) {
                                        // nametxt.focus();
                                    }
                                });
                            }
                            else {
                                if (nametxt.empty()) {
                                    var alrtbx = new alertbox();
                                    alrtbx.show({
                                        text: "Please enter your company name",
                                        onokay: function (param) {
                                            nametxt.focus();
                                        }
                                    });
                                }
                                else {
                                    if (descrtxt.empty()) {
                                        var alrtbx = new alertbox();
                                        alrtbx.show({
                                            text: "Please tell us a little about your company",
                                            onokay: function (param) {
                                                descrtxt.focus();
                                            }
                                        });
                                    }
                                    else {
                                        if (caddrtxt.empty()) {
                                            var alrtbx = new alertbox();
                                            alrtbx.show({
                                                text: "Please enter your contact address",
                                                onokay: function (param) {
                                                    caddrtxt.focus();
                                                }
                                            });
                                        }
                                        else {
                                            if (countrycmb.options.length <= 0) {
                                                var alrtbx = new alertbox();
                                                alrtbx.show({
                                                    text: "Please choose a country",
                                                    onokay: function (param) {
                                                        // nametxt.focus();
                                                    }
                                                });
                                            }
                                            else {
                                                if (statecmb.options.length <= 0) {
                                                    var alrtbx = new alertbox();
                                                    alrtbx.show({
                                                        text: "Please choose a state",
                                                        onokay: function (param) {
                                                            // nametxt.focus();
                                                        }
                                                    });
                                                }
                                                else {
                                                    if (citycmb.options.length <= 0) {
                                                        var alrtbx = new alertbox();
                                                        alrtbx.show({
                                                            text: "Please choose a city",
                                                            onokay: function (param) {
                                                                // nametxt.focus();
                                                            }
                                                        });
                                                    }
                                                    else {
                                                        if (phonetxt.empty()) {
                                                            var alrtbx = new alertbox();
                                                            alrtbx.show({
                                                                text: "Please enter your phone number",
                                                                onokay: function (param) {
                                                                    phonetxt.focus();
                                                                }
                                                            });
                                                        }
                                                        else {
                                                            if (emailtxt.empty()) {
                                                                var alrtbx = new alertbox();
                                                                alrtbx.show({
                                                                    text: "Please enter your email address",
                                                                    onokay: function (param) {
                                                                        emailtxt.focus();
                                                                    }
                                                                });
                                                            }
                                                            else {
                                                                return true
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        var post_frm = selected_tab_page.getElementByAttribute("id", "frm").addEventListener("submit", function (evt) {
            if (validateFrm(this)) {
                this.submit();
            }
            evt.cancelBubble = true;
            evt.preventDefault();
        });
    }

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

                        if (city_cmb.getAttribute("id") != "") {
                            city_cmb.value = city_cmb.getAttribute("id");
                        }

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

                        if (state_cmb.getAttribute("id") != "") {
                            state_cmb.value = state_cmb.getAttribute("id");
                        }

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
        if (cntry_cmb.getAttribute("id") != "") {
            cntry_cmb.value = cntry_cmb.getAttribute("id");
        }
        if (cntry_cmb.options.length > 0)
            get_states(cntry_cmb.options[cntry_cmb.selectedIndex].value);
    })();

});