
//TODO:need to move in common js file
String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
}

var isAbstractLoaded = false;
var isPrecisLoaded = false;

function adcShowAbs(panelDiv, placeholder, hierarchyKey, showDiv, hideDiv, userName) {
    var currentPlaceholder;
    if ($get(placeholder).innerHTML.trim() == "" || $get(placeholder).innerHTML.trim() == "\n\n") {
        currentPlaceholder = $get(placeholder);

        // Show loading while ajax operation is performed
        currentPlaceholder.innerHTML = '<i class="fa fa-refresh  fa-spin fa-3x"></i>';

        //GetAbstractXml
        WKH.PE.OAKS.Journals.UserControls.ArticleInfoService.GetAbstractXml(hierarchyKey, userName, function adcAbstractSuccessCallback(result) {

            currentPlaceholder.innerHTML = result;

            // Set transformed abstract with styles
            $("<div class='abstract-item' id='accum" + currentPlaceholder.id + "'></div>").insertAfter(currentPlaceholder);
            var accumDiv = document.getElementById("accum" + currentPlaceholder.id);
            traverseAbstract(currentPlaceholder, accumDiv);

            $(currentPlaceholder).html(accumDiv.textContent);
            accumDiv.parentNode.removeChild(accumDiv);

            currentPlaceholder = null;
            isAbstractLoaded = true;
        });

    }

    $get(panelDiv).style.display = "block";
    $get(showDiv).style.display = "none";
    $get(hideDiv).style.display = "block";
}

function adcHideAbs(panelDiv, showDiv, hideDiv) {
    $get(panelDiv).style.display = "none";
    $get(showDiv).style.display = "block";
    $get(hideDiv).style.display = "none";
}

function adcShowInBrief(panelDiv, placeholder, hierarchyKey, showDiv, hideDiv, userName) {

    var currentPlaceholder;
    if ($get(placeholder).innerHTML.trim() == "" || $get(placeholder).innerHTML.trim() == "\n\n") {
        currentPlaceholder = $get(placeholder);

        // Show loading while ajax operation is performed
        currentPlaceholder.innerHTML = '<i class="fa fa-refresh  fa-spin fa-3x"></i>';

        WKH.PE.OAKS.Journals.UserControls.ArticleInfoService.GetPrecis(hierarchyKey, userName, function adcShowInBriefSuccessCallback(result) {
            var html = "";
            for (i in result) {
                html += "<p>" + result[i] + "</p>";
            }
            currentPlaceholder.innerHTML = html;
            currentPlaceholder = null;
        });

    }

    $get(panelDiv).style.display = "block";
    $get(showDiv).style.display = "none";
    $get(hideDiv).style.display = "block";
}

function adcHideInBrief(panelDiv, showDiv, hideDiv) {
    $get(panelDiv).style.display = "none";
    $get(showDiv).style.display = "block";
    $get(hideDiv).style.display = "none";
}

function showAllAuthors(ancMore) {
    ancMore.parentNode.parentNode.parentNode.style.display = 'none';
    ancMore.parentNode.parentNode.parentNode.nextElementSibling.style.display = 'block';
}

function showFewAuthors(ancLess) {
    ancLess.parentNode.parentNode.parentNode.style.display = 'none';
    ancLess.parentNode.parentNode.parentNode.previousElementSibling.style.display = 'block';
}

// Transforming abstract xml to html
function traverseAbstract(tree, accumDiv) {
    var items = $(tree).contents();
    for (var i = 0; i < items.length; i++) {
        // Text node
        if (items[i].nodeType == 3) {
            accumDiv.textContent += $(items[i]).text();
        }
        else {
            var elem = "";
            switch (items[i].nodeName.toLowerCase()) {
                case "div":
                    elem = "div";
                    break;
                case "heading":
                    if ($(items[i]).attr("level") == "1" || $(items[i]).children("text").text() == "Abstract") {
                        elem = "h3";
                    } 
                    else {
                        elem = "span";
                    }
                    break;
                case "url":
                    elem = "a";
                    break;
                case "p":
                case "paragraph":
                    elem = "p";
                    break;
                case "emph":
                    var formatAttr = $(items[i]).attr("format");
                    if (formatAttr === "subscript") {
                        elem = "sub";
                    }
                    else if (formatAttr === "superscript") {
                        elem = "sup";
                    }
                    else if (formatAttr === "italic") {
                        elem = "i";
                    }
                    else if (formatAttr === "bold") {
                        elem = "b";
                    }
                    else if (formatAttr === "strikethrough") {
                        elem = "del";
                    }
                    else if (formatAttr === "underline") {
                        elem = "span style='text-decoration: underline;'";
                    }
                    else if (formatAttr === "monospace") {
                        elem = "tt";
                    }
                    else if (formatAttr === "overline") {
                        elem = "span style='text-decoration: overline;'";
                    }
                    else if (formatAttr === "roman") {
                        elem = 'span style="font-family: "Times New Roman", Times, serif;"';
                    }
                    else if (formatAttr === "small-caps") {
                        elem = 'span style="font-variant: small-caps;"';
                    }
                    break;
                case "text":
                case "section":
                    elem = "";
                    break;
                default:
                    elem = items[i].nodeName.toLowerCase();
                    break;
            }

            if ("a" == elem) {
                accumDiv.textContent += ("<a href=" + $(items[i]).attr("href") + ">");
            }
            else if ("span" == elem) {
                accumDiv.textContent += ('<span class="abstract-section-header">');
            }
            else if ("" != elem && "h3" != elem) {
                accumDiv.textContent += ("<" + elem + ">");
            }

            if ("h3" != elem) {
                traverseAbstract(items[i], accumDiv);
                if ("" != elem) {
                    accumDiv.textContent += "</" + elem.split(' ')[0] + ">";
                }
            }
        }
    }
}
