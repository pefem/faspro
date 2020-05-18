window.addEventListener("DOMContentLoaded", function () {
    var bdy = document.body;
    var page = bdy.getElementByAttribute("page", "layout");
    var page_headr = page.getElementByAttribute("layout-obj", "headr");
    var tabs = page_headr.getElementByAttribute("tab-obj", "tab-btn-wrappr").getElementsByTagName("li");
    Array.prototype.forEach.call(tabs, function (tab_btn, indx) {
        tab_btn.addEventListener("mousedown", function (evt) {
            Array.prototype.forEach.call(tabs, function (tab_btn, indx) {
                tab_btn.removeAttribute("selected");
            });
            var selected_tab = this;
            selected_tab.setAttribute("selected", "true");

            var selected_frm = null;
            var forms = page_headr.getElementByAttribute("srch-bdy-obj", "tabpage").getElementsByAttribute("ftype");
            Array.prototype.forEach.call(forms, function (form, indx) {
                form.setAttribute("class", "hide_form");
                if (selected_tab.getAttribute("form") == form.getAttribute("ftype")) {
                    selected_frm = form;
                }
            });
            selected_frm.removeAttribute("class");
        });
    });

    
});