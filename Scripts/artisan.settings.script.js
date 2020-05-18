window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        layout_bdy = page.getElementsByAttribute("layout-obj", "body")[0],
        profile_pnl = page.getElementByAttribute("mode", "cinf"),
        account_pnl = page.getElementByAttribute("mode", "aset"),
        locatn_pnl = page.getElementByAttribute("mode", "cloc"),
        wrkExpr_pnl = page.getElementByAttribute("mode", "exp"),
        eduQual_pnl = page.getElementByAttribute("mode", "edq"),
        adsDshBrd_pnl = page.getElementByAttribute("mode", "ads");


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
    // Clear Notifier
    (clearNotifier = function () {
        var notifier = document.getElementById("infoNotifierPnl");
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
    })();

    //

    if (profile_pnl != null) {
        var upld_btn = profile_pnl.getElementByAttribute("upload-button").getElementsByTagName("input")[0];
        upld_btn.addEventListener("change", function (evt) {
            if (this.files.length > 0) {
                var upldFrm = profile_pnl.getElementByAttribute("id", "profilephotoupldr");
                var txtFirstName = document.getElementById("txtFirstName");
                var txtLastName = document.getElementById("txtLastName");
                var cmbSex = document.getElementById("cmbSex");
                var txtPhoneNo = document.getElementById("txtPhoneNo");
                var txtAboutUs = document.getElementById("txtAboutUs");
                var cmbServ = document.getElementById("cmbServ");

                document.getElementById("tmpTxtFirstName").value = txtFirstName.value;
                document.getElementById("tmpTxtLastName").value = txtLastName.value;
                document.getElementById("tmpCmbSex").value = cmbSex.value;
                document.getElementById("tmpTxtPhoneNo").value = txtPhoneNo.value;
                document.getElementById("tmpTxtAboutUs").value = txtAboutUs.value;
                document.getElementById("tmpcmbServ").value = cmbServ.options[cmbServ.selectedIndex].value;

                upldFrm.submit();

                //console.log(document.getElementById("tmpcmbServ").value);
            }
        });

        var saveChngesBtn = profile_pnl.getElementByAttribute("id", "saveChngesBtn");
        saveChngesBtn.addEventListener("click", function (evt) {
            var updateFrm = profile_pnl.getElementByAttribute("id", "profileupdate");
            updateFrm.submit();
        });
    }

    if (account_pnl != null) {
        var genbtn = account_pnl.getElementByAttribute("id", "genbtn");
        var shwbtn = account_pnl.getElementByAttribute("id", "shwbtn");
        var pwdtxt = account_pnl.getElementByAttribute("name", "txtPwd");
        var npwdtxt = account_pnl.getElementByAttribute("name", "txtNPwd");
        var rpwdtxt = account_pnl.getElementByAttribute("name", "txtRPwd");

        var chr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var num = "0123456789";
        var alp = "@#$&";

        genbtn.addEventListener("mousedown", function (evt) {
            var pwd_chr = chr.shuffle();
            var num_chr = num.shuffle();
            var alp_chr = alp.shuffle();

            var str = pwd_chr.substr(0, 5) + "" + num_chr.substr(0, 3) + "" + alp_chr.substr(0, 2);
            str = str.shuffle();
            npwdtxt.value = str;
            rpwdtxt.value = str;
        });
        shwbtn.addEventListener("mousedown", function (evt) {
            if (shwbtn.value == "Show Password") {
                npwdtxt.setAttribute("type", "text");
                rpwdtxt.setAttribute("type", "text");
                this.setAttribute("value", "Hide Password");
            }
            else {
                npwdtxt.setAttribute("type", "password");
                rpwdtxt.setAttribute("type", "password");
                this.setAttribute("value", "Show Password");
            }
        });
    }

    if (locatn_pnl != null) {
        var city_cmb = locatn_pnl.getElementByAttribute("name", "cmbCity");
        var state_cmb = locatn_pnl.getElementByAttribute("name", "cmbState");
        var cntry_cmb = locatn_pnl.getElementByAttribute("name", "cmbCntry");

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
            get_states(cntry_cmb.options[cntry_cmb.selectedIndex].value);
        })();
    }

    if (wrkExpr_pnl != null) {
        if (wrkExpr_pnl.getElementByAttribute("upload-button") != null) {
            var upld_btn = wrkExpr_pnl.getElementByAttribute("upload-button").getElementsByTagName("input")[0];
            upld_btn.addEventListener("change", function (evt) {
                if (this.files.length > 0) {
                    var updateFrm = wrkExpr_pnl.getElementByAttribute("id", "portfolioupdate");
                    
                    var upldFrm = wrkExpr_pnl.getElementByAttribute("id", "portfolioimageupldr");
                    var txtJobTitle = upldFrm.getElementByAttribute("name", "txtJobTitle");
                    var txtJobClient = upldFrm.getElementByAttribute("name", "txtJobClient");
                    var txtJobDescr = upldFrm.getElementByAttribute("name", "txtJobDescr");

                    txtJobTitle.value = updateFrm.getElementByAttribute("name", "txtJobTitle").value;
                    txtJobClient.value = updateFrm.getElementByAttribute("name", "txtJobClient").value;
                    txtJobDescr.value = updateFrm.getElementByAttribute("name", "txtJobDescr").value;
                    upldFrm.submit();
                }
            });
        }

        var gridvw = wrkExpr_pnl.getElementByAttribute("bdy-obj", "grdvw");
        if (gridvw) {
            var gridvw_itms = gridvw.getElementsByAttribute("grdvw-obj", "rw");
            if (gridvw_itms) {
                gridvw_itms.map(function (itm) {
                    var remove_btn = itm.getElementByAttribute("remove").getElementsByTagName("a")[0];
                    var edit_btn = itm.getElementByAttribute("edit");

                    remove_btn.addEventListener("click", function (evt) {
                        var $this = this;

                        var cfrm = new confirmbox();
                        cfrm.show({
                            text: 'Are you sure you want to delete this work experience? (Y/N)',
                            yes: function (param) {
                                document.location.href = $this.getAttribute("href");
                            }
                        });

                        evt.cancelBubble = true;
                        evt.preventDefault();
                    });
                });
            }
        }

        var saveChngesBtn = wrkExpr_pnl.getElementByAttribute("id", "saveChngesBtn");
        saveChngesBtn.addEventListener("click", function (evt) {
            var updateFrm = wrkExpr_pnl.getElementByAttribute("id", "portfolioupdate");
            updateFrm.submit();
        });
    }

    if (eduQual_pnl != null) {

        var gridvw = eduQual_pnl.getElementByAttribute("bdy-obj", "grdvw");
        if (gridvw) {
            var gridvw_itms = gridvw.getElementsByAttribute("grdvw-obj", "rw");
            if (gridvw_itms) {
                gridvw_itms.map(function (itm) {
                    var remove_btn = itm.getElementByAttribute("remove").getElementsByTagName("a")[0];
                    var edit_btn = itm.getElementByAttribute("edit");

                    remove_btn.addEventListener("click", function (evt) {
                        var $this = this;

                        var cfrm = new confirmbox();
                        cfrm.show({
                            text: 'Are you sure you want to delete this educational qualification? (Y/N)',
                            yes: function (param) {
                                document.location.href = $this.getAttribute("href");
                            }
                        });

                        evt.cancelBubble = true;
                        evt.preventDefault();
                    });
                });
            }
        }

    }

    if (adsDshBrd_pnl != null) {
        if (adsDshBrd_pnl.getElementByAttribute("upload-button") != null) {
            var upld_btn = adsDshBrd_pnl.getElementByAttribute("upload-button").getElementsByTagName("input")[0];
            upld_btn.addEventListener("change", function (evt) {
                if (this.files.length > 0) {
                    var updateFrm = adsDshBrd_pnl.getElementByAttribute("id", "campgnupdate");

                    var upldFrm = adsDshBrd_pnl.getElementByAttribute("id", "adbannerupldr");
                    var txtCmpgnTitle = upldFrm.getElementByAttribute("name", "txtCmpgnTitle");
                    var txtCmpgnDescr = upldFrm.getElementByAttribute("name", "txtCmpgnDescr");
                    var txtCmpgnURL = upldFrm.getElementByAttribute("name", "txtCmpgnURL");

                    txtCmpgnTitle.value = updateFrm.getElementByAttribute("name", "txtCmpgnTitle").value;
                    txtCmpgnDescr.value = updateFrm.getElementByAttribute("name", "txtCmpgnDescr").value;
                    txtCmpgnURL.value = updateFrm.getElementByAttribute("name", "txtCmpgnURL").value;

                    upldFrm.submit();
                }
            });
        }

        var saveChngesBtn = adsDshBrd_pnl.getElementByAttribute("id", "saveChngesBtn");
        if (saveChngesBtn != null) {
            saveChngesBtn.addEventListener("click", function (evt) {
                var updateFrm = adsDshBrd_pnl.getElementByAttribute("id", "campgnupdate");
                updateFrm.submit();
            });
        }


        var gridvw = adsDshBrd_pnl.getElementByAttribute("bdy-obj", "grdvw");
        if (gridvw) {
            var gridvw_itms = gridvw.getElementsByAttribute("grdvw-obj", "rw");
            if (gridvw_itms) {
                gridvw_itms.map(function (itm) {
                    if (itm.getElementByAttribute("remove")) {
                        var remove_btn = itm.getElementByAttribute("remove").getElementsByTagName("a")[0];

                        remove_btn.addEventListener("click", function (evt) {
                            var $this = this;

                            var cfrm = new confirmbox();
                            cfrm.show({
                                text: 'Are you sure you want to delete this campaign? (Y/N)',
                                yes: function (param) {
                                    document.location.href = $this.getAttribute("href");
                                }
                            });

                            evt.cancelBubble = true;
                            evt.preventDefault();
                        });
                    }
                    if (itm.getElementByAttribute("renew")) {
                        var renew_btn = itm.getElementByAttribute("renew").getElementsByTagName("a")[0];

                        renew_btn.addEventListener("click", function (evt) {
                            var $this = this;
                            xhr({
                                url: "?p=renewads",
                                data: {
                                    receiptNo: $this.getAttribute("invoice"),
                                    task: "renew"
                                },
                                onready: function (param) {
                                    var response = param.response;
                                    document.location.href = "?p=viewinvoice&pckge=" + response.package + "&invoice=" + response.invoice + "&renew";
                                }
                            });

                            evt.cancelBubble = true;
                            evt.preventDefault();
                        });
                    }
                });
            }
        }
    }
});