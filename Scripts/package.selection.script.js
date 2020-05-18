window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        layout_bdy = page.getElementsByAttribute("layout-obj", "body")[0],
        selectn_optn_pnl = page.getElementByAttribute("pane-obj", "selection-view"),
        selectn_optn_pnl = page.getElementByAttribute("pane-obj", "selection-view");

    if (selectn_optn_pnl) {
        var selctn_frm = selectn_optn_pnl.getElementsByTagName("form")[0];
        var selctn_pckge = selctn_frm.getElementByAttribute("name", "package");
        var optns = selectn_optn_pnl.getElementsByAttribute("pricing-table-obj", "itm");
        Array.prototype.forEach.call(optns, function (optn) {
            optn.getElementByAttribute("bdy-obj", "btn").addEventListener("mousedown", function (evt) {
                var itm = this.getAttribute("value");
                selctn_pckge.value = itm;
                selctn_frm.submit();
            });
        });
    }
});