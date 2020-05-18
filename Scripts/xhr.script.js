xhr = function (param) {
    var fd = new FormData();
    fd.append("data", JSON.stringify(param.data));
    var _xhr = new XMLHttpRequest();
    _xhr.open("POST", param.url, true);
    _xhr.addEventListener("progress", function (evt) {
        if (param.onloading)
            param.onloading({
                status: true
            });
    });
    _xhr.addEventListener("load", function (evt) {
        if (this.readyState == 4) {
            var response = null;
            try {
                response = JSON.parse(this.responseText);
            }
            catch (e) {
                response = {
                    message: this.responseText,
                    error: e.message
                };
            }
            if (param.onready)
                param.onready({
                    response: response
                });
            if (param.onloading)
                param.onloading({
                    status: false
                });
        }
    });
    _xhr.addEventListener("error", function (evt) {
        if (param.onerror)
            param.onerror({
                status: true
            });

        if (param.onloading)
            param.onloading({
                status: false
            });
    });
    _xhr.addEventListener("timeout", function (evt) {
        if (param.ontimeout)
            param.ontimeout({
                status: true
            });

        if (param.onloading)
            param.onloading({
                status: false
            });
    });
    _xhr.addEventListener("abort", function (evt) {
        if (param.onabort)
            param.onabort({
                status: true
            });

        if (param.onloading)
            param.onloading({
                status: false
            });
    });
    _xhr.send(fd);
}