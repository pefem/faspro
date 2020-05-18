window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        layout_bdy = page.getElementsByAttribute("layout-obj", "body")[0],
        cntactus_frm = layout_bdy.getElementByAttribute("id", "contactus");

    console.log(cntactus_frm);
    cntactus_frm.addEventListener("submit", function (evt) {
        var full_name_txt = this.getElementByAttribute("name", "full-name-txt");
        var email_add_txt = this.getElementByAttribute("name", "email-add-txt");
        var subject_txt = this.getElementByAttribute("name", "subject-txt");
        var message_txt = this.getElementByAttribute("name", "message-txt");

        if (full_name_txt.value.trim() != "" && email_add_txt.value.trim() != "" && subject_txt.value.trim() != "" && message_txt.value.trim() != "") {
            this.submit();
        }
        else {
            console.log("Hello world");
        }

        evt.cancelBubble = true;
        evt.preventDefault();
    });
});