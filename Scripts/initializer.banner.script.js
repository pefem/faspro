banner_initializer = function (param) {
    var bannr_wrappr = param.banner.getElementsByAttribute("bannr-obj", "bannr-wrappr")[0];
    var bannr_itm_obj = bannr_wrappr.getElementsByAttribute("wrappr-obj", "bannr")[0];
    bannr_wrappr.clear();
    //
    var buttn_wrappr = param.banner.getElementsByAttribute("bannr-obj", "buttn-wrappr")[0];
    var buttn_cntainr = buttn_wrappr.getElementsByAttribute("wrappr-obj", "cntainr")[0];
    var buttn_itm_obj = buttn_cntainr.getElementsByAttribute("cntainr-obj", "buttn")[0];
    buttn_cntainr.clear();
    //
    banner = function (bannr) {
        var bannr_itm = bannr_itm_obj.cloneNode(true);
        var buttn_itm = buttn_itm_obj.cloneNode(true);
        //
        return {
            widget: bannr_itm,
            add: function (param) {
                bannr_wrappr.appendChild(bannr_itm);
                bannr_itm.className = param.image;
                //
                buttn_itm.addEventListener("mouseup", function (evt) {
                    int_bnr_indx = eval(this.getAttribute("index"));
                    start();
                });
                buttn_itm.setAttribute("index", param.index);
                buttn_cntainr.appendChild(buttn_itm);
                //
                var btn_cntr_width = buttn_cntainr.offsetWidth + (buttn_itm.offsetWidth + 10);
                buttn_cntainr.setCssProperty("width", btn_cntr_width + "px");
                //
                var wdth = document.body.offsetWidth || document.body.clientWidth;
                bannr_itm.removeAttribute("selected");
                bannr_itm.setAttribute("style", "width:" + wdth + "px;");
            }
        };
    };
    slide = function () {
        //
        var buttn_itms = buttn_cntainr.getElementsByAttribute("cntainr-obj", "buttn");
        buttn_itms.map(function (itm) {
            itm.removeAttribute("selected");
        });
        var btn = buttn_itms[int_bnr_indx];
        btn.setAttribute("selected", "true");
        //
        var bannr_itms = bannr_wrappr.getElementsByAttribute("wrappr-obj", "bannr");
        bannr_itms.map(function (itm) {
            itm.removeAttribute("selected");
        });
        //
        var bnr = bannr_itms[int_bnr_indx];
        bnr.setAttribute("selected", "true");
        bannr_wrappr.style.left = "-" + bnr.offsetLeft + "px";
        //
        if (int_bnr_indx < bannr_itms.length - 1) {
            int_bnr_indx += 1;
        } else {
            int_bnr_indx = 0;
        };
    }
    //
    start = function () {
        slide();
        //
        var bannr_itms = bannr_wrappr.getElementsByAttribute("wrappr-obj", "bannr");
        bannr_itms.map(function (itm, indx) {
            clearTimeout(window["bnr_" + indx]);
        });
        window["bnr_" + int_bnr_indx] = setTimeout("start()", param.duration);
    };
    //
    var bannr_arr = ["bannr_1", "bannr_2", "bannr_3", "bannr_4", "bannr_5", "bannr_6"];
    bannr_arr.map(function (bannr, indx) {
        banner(bannr).add({
            image: bannr_arr[indx],
            index:indx
        });
    });

    var int_bnr_indx = 0;
    start();

};