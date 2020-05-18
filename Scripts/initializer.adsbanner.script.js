ads_banner_initializer = function (param) {
    var ads_bannr_wrappr = param.banner.getElementByAttribute("lft-tile-obj", "wrappr");
    var ads_bannr_itm_obj = ads_bannr_wrappr.getElementByAttribute("wrappr-obj", "itm");
    //ads_bannr_wrappr.clear();
    //
    //
    ads_banner = function (bannr) {
        var ads_bannr_itm = ads_bannr_itm_obj.cloneNode(true);
        //
        return {
            widget: ads_bannr_itm,
            add: function (param) {
                ads_bannr_wrappr.appendChild(ads_bannr_itm);
                ads_bannr_itm.className = param.image;
                //
                //
                var wdth = document.body.offsetWidth || document.body.clientWidth;
                ads_bannr_itm.removeAttribute("selected");
                ads_bannr_itm.setAttribute("style", "width:" + wdth + "px;");
            }
        };
    };
    slide_ads = function () {
        var ads_bannr_itms = ads_bannr_wrappr.getElementsByAttribute("wrappr-obj", "itm");
        if (ads_bannr_itms != null) {
            ads_bannr_itms.map(function (itm) {
                itm.removeAttribute("selected");
            });
            //
            var ads_bnr = ads_bannr_itms[ads_int_bnr_indx];
            ads_bnr.setAttribute("selected", "true");
            ads_bannr_wrappr.style.left = "-" + ads_bnr.offsetLeft + "px";
            //
            if (ads_int_bnr_indx < ads_bannr_itms.length - 1) {
                ads_int_bnr_indx += 1;
            }
            else {
                ads_int_bnr_indx = 0;
            };
        }
    }
    //
    start_ads = function () {
        slide_ads();
        //
        var ads_bannr_itms = ads_bannr_wrappr.getElementsByAttribute("wrappr-obj", "itm");
        if (ads_bannr_itms != null) {
            ads_bannr_itms.map(function (itm, indx) {
                clearTimeout(window["ads_bnr_" + indx]);
            });
            window["ads_bnr_" + ads_int_bnr_indx] = setTimeout("start_ads()", param.duration);
        }
    };
    //
    var ads_bannr_arr = ["bannr_1", "bannr_2", "bannr_3"];

    var ads_int_bnr_indx = 0;
    start_ads();

};