var headerURL = 'https://assets.aan.com/vendor/header/AANVendorHeader.html';

//commented out for dev testing
//var headerURL = 'https://localhost:44300/vendor/header/AANVendorHeader.html';

var publicationsURL = 'https://www.aan.com/api/sharedlayout/publications';

//var publicationsURL = 'http://localhost:65200/api/sharedlayout/publications';

var publicationImageURL = 'https://www.aan.com/siteassets/';

var aanHeaderDiv = document.getElementById('aanVendorHeader');
var publicationsLoaded = false;


if (aanHeaderDiv !== null) {
    aanHeaderDiv.style.visibility = 'hidden';
}

String.prototype.replaceAll = function (find, replace) {
    var str = this;
    return str.replace(new RegExp(find, 'g'), replace);
};

function populateHeader(html) {
    //grab the headerDiv (assuming this exists)
    var headerDiv = document.getElementById("aanVendorHeader");

    //populate headerDiv with HTML response from HttpRequest
    if (headerDiv !== null && html !== null) {
        headerDiv.innerHTML = html;
    } else {
        console.error('Must add div container with id="aanVendorHeader"');
    }
}

function populatePublications(html) {
    //grab the header (assuming this exists)
    var header = document.getElementsByTagName("header")[0];

    //populate headerDiv with HTML response from HttpRequest
    if (header !== null && html !== null) {
        var jsonResponse = JSON.parse(html);

        var publications = jsonResponse.Publications;

        //API call will send image files as relative path.  Replace the text to Make it absolute.
        //publications = publications.replaceAll('/siteassets/', publicationImageURL);

        header.insertAdjacentHTML('afterend', publications);
    } else {
        console.error('Must add div container with id="aanVendorHeader"');
    }
}



function loadPage(url, requestType) {
    var oReq = new XMLHttpRequest();

    oReq.open("GET", url);

    oReq.onreadystatechange = function () {
        if (oReq.readyState === 4 && oReq.status === 200) {
            //RequestType1 === full header HTML
            if (requestType === 1) {
                populateHeader(oReq.responseText);
                //Once request has finished successfully, call again to populate publications
                loadPage(publicationsURL, 2);
            }
            //RequestType2 === publications modal only
            if (requestType === 2) {
                populatePublications(oReq.responseText);
                publicationsLoaded = true;
            }
        }
    }

    oReq.send();
}

function loadjscssfile(filename, filetype) {
    if (filetype === "js") { //if filename is a external JavaScript file
        var fileref = document.createElement('script');
        fileref.setAttribute("type", "text/javascript");
        fileref.setAttribute("src", filename);
    } else if (filetype === "css") { //if filename is an external CSS file
        var fileref = document.createElement("link");
        fileref.setAttribute("rel", "stylesheet");
        fileref.setAttribute("type", "text/css");
        fileref.setAttribute("href", filename);
    }
    if (typeof fileref !== "undefined")
        document.getElementsByTagName("head")[0].appendChild(fileref);
}

//Download page from CDN and populate headerDiv ( requestType 1 is full HTML header)
loadPage(headerURL, 1);

//Load vendor assets and populate <head>
loadjscssfile("https://assets.aan.com/vendor/header/stylesheets/vendor.css", "css");
loadjscssfile("https://assets.aan.com/vendor/header/stylesheets/styles.css?v=1", "css");
//Vendor.js file was causing jQuery conflicts with neurology.org, and is not necessary since AwesomeComplete is no longer used
//loadjscssfile("https://assets.aan.com/vendor/header/javascripts/vendor.js", "js");

//Document must be loaded before accessing layout scripts
document.onreadystatechange = function () {
    if (document.readyState === 'complete') {

        //Wait for publications AJAX to populate before trying to grab DOM elements
        if (publicationsLoaded) {
            loadjscssfile("https://assets.aan.com/vendor/header/javascripts/scripts.js", "js");
        } else {
            var timeout = setInterval(function() {
                if (publicationsLoaded) {
                    loadjscssfile("https://assets.aan.com/vendor/header/javascripts/scripts.js", "js");
                    clearInterval(timeout);
                }
            }, 1000);
        }

        aanHeaderDiv = document.getElementById('aanVendorHeader');

        if (aanVendorHeader !== null) {
            aanHeaderDiv.style.visibility = 'visible';
        }

        //Search autocomplete
        var input = document.getElementById("SearchValue");
        //var awesomplete = new Awesomplete(input);

        //var searchFunction = function (e) {

        //    // get keycode of current keypress event
        //    var code = (e.keyCode || e.which);

        //    // do nothing if it's an arrow key
        //    if (code === 37 || code === 38 || code === 39 || code === 40) {
        //        return;
        //    }

        //    if (!$(this).val()) {
        //        awesomplete.list = [];
        //    } else {
        //        var ajax = new XMLHttpRequest();
        //        ajax.open("GET", "https://www.aan.com/api/suggest/complete/" + $(this).val(), true);

        //        ajax.onload = function () {
        //            var list = JSON.parse(ajax.responseText).map(function (i) { return i; });
        //            awesomplete.list = list;
        //        };
        //        ajax.send();
        //    }

        //};

        //input.addEventListener("keyup", searchFunction);
    }
};