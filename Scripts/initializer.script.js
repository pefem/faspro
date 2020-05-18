window.addEventListener("DOMContentLoaded", function (evt) {
    /*
     * DOM Declarations
     */
    var page_body = this.document.body,
        page = page_body.getElementsByAttribute("page", "layout")[0],
        page_headr = page.getElementsByAttribute("layout-obj", "headr")[0],
        page_headr_bannr = page.getElementsByAttribute("headr-obj", "bannr")[0],

        page_body = page.getElementsByAttribute("layout-obj", "body")[0],
        page_footr = page.getElementsByAttribute("layout-obj", "footr")[0];

    var ads_bannr = page.getElementsByAttribute("tilevw-obj", "lft-tile")[0]


    //console.log(page_headr_bannr);


    // Initialize banner component
    //
    var _duration = 8000;

    var banner = banner_initializer({
        banner: page_headr_bannr,
        duration: _duration
    });


    // Initialize ads_banner component
    //
    var _ads_duration = 8000;

    var banner = ads_banner_initializer({
        banner: ads_bannr,
        duration: _duration
    });
    //
    window.addEventListener("resize", function () {
        banner = banner_initializer({
            banner: page_headr_bannr,
            duration: _duration
        });
    });
});