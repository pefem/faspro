window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        layout_bdy = page.getElementsByAttribute("layout-obj", "body")[0],
        rd_modal_cancl_btn = document.getElementById("cancel_btn"),
        fgotpwd_buttn = null;


    if (document.getElementById("fgot_pwd")) {
        fgotpwd_buttn = document.getElementById("fgot_pwd").getElementsByTagName("a")[0];

        //fgotpwd_buttn.addEventListener("mousedown", function (evt) {
        //    fgotpwd_diag.setAttribute("show-dialg", "");
        //    evt.cancelBubble = true;
        //    evt.preventDefault();
        //});
        //rd_modal_cancl_btn.addEventListener("mousedown", function (evt) {
        //    fgotpwd_diag.removeAttribute("show-dialg");
        //});
        //fgotpwd_diag_modal.addEventListener("click", function (evt) {
        //    evt.cancelBubble = true;
        //    evt.preventDefault();
        //});
    }
    
});