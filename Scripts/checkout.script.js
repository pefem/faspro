window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */

    var page_body = this.document.body;
    var page = page_body.getElementByAttribute("page", "layout");
    var layout_bdy = page.getElementByAttribute("layout-obj", "body");
    var review_btn_wrappr = layout_bdy.getElementByAttribute("review-obj", "btn-wrappr");
    if (review_btn_wrappr) {
        var checkout_btn = review_btn_wrappr.getElementByAttribute("checkout");
        checkout_btn.addEventListener("mousedown", function (evt) {
            document.location.href = checkout_btn.getAttribute("url");
        });
    }

    if (review_btn_wrappr) {
        var cancel_btn = review_btn_wrappr.getElementByAttribute("cancel");
        cancel_btn.addEventListener("mousedown", function (evt) {
            window.history.go(-1);
        });
    }

    var city_cmb = layout_bdy.getElementByAttribute("name", "cityCmb");
    var state_cmb = layout_bdy.getElementByAttribute("name", "stateCmb");
    var cntry_cmb = layout_bdy.getElementByAttribute("name", "countryCmb");

    if (cntry_cmb != null) {
        cntry_cmb.addEventListener("change", function (evt) {
            get_states(this.options[this.selectedIndex].value);
        });
    }

    if (state_cmb != null) {
        state_cmb.addEventListener("change", function () {
            get_cities(this.options[this.selectedIndex].value);
        });
    }

    if (city_cmb != null) {
        city_cmb.addEventListener("change", function () {

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
        if (cntry_cmb != null) {
            get_states(cntry_cmb.options[cntry_cmb.selectedIndex].value);
        }
    })();
});