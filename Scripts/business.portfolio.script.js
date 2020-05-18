window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        layout_bdy = page.getElementsByAttribute("layout-obj", "body")[0],
        mansory = layout_bdy.getElementsByAttribute("mansory-lstvw-obj", "mansory")[0],
        mansory_items = mansory.getElementsByAttribute("lstvw-obj", "itm");

    var cbox = page.getElementByAttribute("wnd-obj", "diag");
    var yes_btn = cbox.getElementByAttribute("bttn-obj", "yes");
    var no_btn = cbox.getElementByAttribute("bttn-obj", "no");

    var pbox = page.getElementByAttribute("wnd-obj", "prevw-diag");
    var close_btn = pbox.getElementByAttribute("bttn-obj", "no");

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
    // Preview Box
    previewbox = function () {
        return {
            show: function (param) {
                pbox.setAttribute("show", "");

                var prevw_pnl = pbox.getElementByAttribute("msag-obj", "prevw");
                prevw_pnl.setAttribute("style", "background-image:url('" + param.url + "')");

                var hint_title = pbox.getElementByAttribute("hint-obj", "title");
                hint_title.innerHTML = param.title;

                var hint_descr = pbox.getElementByAttribute("hint-obj", "descr");
                hint_descr.innerHTML = param.descr;

                close_btn.addEventListener("mousedown", function () {
                    pbox.removeAttribute("show");
                    //
                    if (param.oncancel)
                        param.oncancel({});

                    this.removeEventListener("mousedown", function () { }, false);
                });
            }
        }
    };

    if (mansory_items) {
        Array.prototype.forEach.call(mansory_items, function (mansory_itm) {
            mansory_itm.addEventListener("click", function (evt) {
                var prevw = new previewbox();
                prevw.show({
                    title: this.getAttribute("port-title"),
                    descr: this.getAttribute("port-descr"),
                    url: this.getAttribute("port-image-url"),
                    oncancel: function (param) {

                    }
                });
                evt.cancelBubble = true;
                evt.preventDefault();
            });
        });
    }
});