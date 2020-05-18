(function (DOMParser) {
    "use strict";
    var DOMParser_proto = DOMParser.prototype,
		real_parseFromString = DOMParser_proto.parseFromString;

    // Firefox/Opera/IE throw errors on unsupported types  
    try {
        if ((new DOMParser).parseFromString("", "text/html")) {
            return;
        }
    } catch (ex) { };

    DOMParser_proto.parseFromString = function (markup, type) {
        if (/^\s*text\/html\s*(?:;|$)/i.test(type)) {
            var doc = document.implementation.createHTMLDocument(""),
				doc_elt = doc.documentElement,
				first_elt;

            doc_elt.innerHTML = markup;
            first_elt = doc_elt.firstElementChild;

            if (doc_elt.childElementCount === 1
                && first_elt.localName.toLowerCase() === "html") {
                doc.replaceChild(first_elt, doc_elt);
            }

            return doc;
        } else {
            return real_parseFromString.apply(this, arguments);
        }
    };
}(DOMParser));
(function (Element) {
    var Element_proto = Element.prototype;
    Element_proto.getElementsByTagType = function (attr) {
        var nodeList = this.getElementsByTagName("*");
        var nodeArray = [];
        for (var i = 0, elem; elem = nodeList[i]; i++) {
            if (elem.nodeName == "A") {
                nodeArray.push(elem);
            }
        }
        return nodeArray;
    };
    Element_proto.getElementsByAttribute = function (attr, value) {
        var nodeList = this.getElementsByTagName("*"),
            nodeArray = [];
        for (var i = 0, elem; elem = nodeList[i]; i++) {
            if (value) {
                if (elem.getAttribute(attr) == value) {
                    nodeArray.push(elem);
                }
            } else {
                if (elem.hasAttribute(attr)) {
                    nodeArray.push(elem);
                }
            }
        }
        return (nodeArray.length > 0) ? nodeArray
                                     : null;
    };
    Element_proto.getElementByAttribute = function (attr, value) {
        var nodeList = this.getElementsByTagName("*"),
            node = null;
        for (var i = 0, elem; elem = nodeList[i]; i++) {
            if (value) {
                if (elem.getAttribute(attr) == value) {
                    node = elem;
                }
            } else {
                if (elem.hasAttribute(attr)) {
                    node = elem;
                }
            }
        }
        return node;
    };
    Element_proto.hasChild = function (child) {
        var nodeList = this.getElementsByTagName("*"),
            nodeArray = [];
        while ((child = this) && child !== this);
        return !!child;
    };
    Element_proto.clear = function () {
        switch (this.nodeName) {
            case "SELECT":
                while (this.options.length > 0) {
                    this.remove(0);
                };
                break;
            case "INPUT":
                this.value = "";
                break;
            default:
                this.innerHTML = "";
                break;
        };
    };
    Element_proto.empty = function () {
        switch (this.nodeName) {
            case "SELECT":
                return this.options.length;
                break;
            case "INPUT":
            case "TEXTAREA":
                return this.value.trim() == "";
                break;
            default:
                return this.innerHTML == "";
                break;
        };
    };
    Element_proto.getCssProperty = function (propty) {
        var style = window.getComputedStyle(this);
        return style.getPropertyValue(propty);
    };
    Element_proto.setCssProperty = function (propty, value) {
        this.style[propty] = value;
    };
}(Element));
(function (_String) {
    var String_proto = _String.prototype;
    String_proto.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    };
    String_proto.empty = function () {
        var str = this.replace(/^\s+|\s+$/g, '');
        if (str == "")
            return true;
    };
    String_proto.explode = function (delmtr) {
        return this.split(delmtr);
    };
    String_proto.concatWord = function (delmtr) {
        var res = "";
        this.split(delmtr).map(function (itm) {
            res += itm;
        }); return res;
    };
    String_proto.shuffle = function () {
        var shuffledWord = '';
        var charIndex = 0;
        var word = this.split('');
        while (word.length > 0) {
            charIndex = word.length * Math.random() << 0;
            shuffledWord += word[charIndex];
            word.splice(charIndex, 1);
        }
        return shuffledWord;
    };
}(String));
(function (_Array) {
    var Array_proto = _Array.prototype;
}(Array));
(function (_Object) {
    var Object_proto = _Object.prototype;
}(Object));
(function (_Date) {
    var Date_proto = _Date.prototype;

    Date_proto.getMonthName = function (month) {
        return this.monthNames[month];
    };
    Date_proto.getShortMonthName = function (month) {
        return this.monthNames[month].substr(0, 3);
    };
    Date_proto.monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
}(Date));




