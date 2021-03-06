$(function() {
    var provisionalLinks = 0;
    function processLink(index, domElement) {
        var element = $(domElement);
        var href = element.attr("href");
        if (href.charAt(0) == "#") {
            var targetElement = $(href);
            if (targetElement.length != 1) {
                logError("invalid ID ref: ", element.get(0));
            } else {
                if (element.is(":empty")) {
                    var headingText;
                    if (targetElement.is("dt")) {
                        headingText = targetElement.text();
                    } else {
                        var heading = targetElement.find("h1:first");
                        if (heading.length == 1) {
                            headingText = heading.text();
                        }
                    }

                    if (headingText) {
                        element.text(headingText.trim());
                    } else {
                        logError("could not identify heading for",
                                targetElement.get(0), "linked from", element
                                        .get(0));
                    }
                } else {
                    var label = element.text().replace(/\s+/g, " ");
                    console.debug("custom label '" + label + "' at", element
                            .get(0), "linking to", targetElement.get(0));
                }
            }
        } else if (href.match(/^http(s)?:\//)) {
            console.debug("found external link", domElement);
        } else if (href.match(/\.html$/)) {
            console.debug("found internal link", domElement);
        } else if (href.match(/^_/)) {
            provisionalLinks++;
        } else {
            logError("invalid link href", domElement,
                    "only ID refs or external URLs allowed");
        }
    }
    $("a[href]").each(processLink);

    if (provisionalLinks > 0) {
        // TODO turn into error
        console.debug("found " + provisionalLinks + ' provisional links (href="_...")');
    }
});