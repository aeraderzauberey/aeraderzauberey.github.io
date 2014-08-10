$(function() {
    function logError() {
        $("body").addClass("error");
        console.error.apply(console, arguments);
    }

    function processLink(index, domElement) {
        var element = $(domElement);
        var href = element.attr("href");
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
                    element.text(headingText);
                } else {
                    logError("could not identify heading for", targetElement
                            .get(0), "linked from", element.get(0));
                }
            } else {
                var label = element.text().replace(/\s+/g, " ");
                console.debug("custom label '" + label + "' at",
                        element.get(0), "linking to", targetElement.get(0));
            }
        }
    }
    $("a[href^=#]").each(processLink);

    var maxLevel = 2;
    function generateToc(rootSection, targetElement, rootSectionTemplate,
            subSectionTemplate) {
        if (!subSectionTemplate) {
            subSectionTemplate = rootSectionTemplate;
        }
        var lastLevel = 0;
        var container = targetElement;
        rootSection.find("section").each(
                function(index, htmlElement) {
                    var element = $(htmlElement);
                    var text = element.find("> h1").text();
                    var level = element.parents("section").length + 1;

                    if (level <= maxLevel) {
                        if (level > lastLevel) {
                            if (level == 1) {
                                container = $(rootSectionTemplate).appendTo(
                                        container);
                            } else {
                                container = $(subSectionTemplate).appendTo(
                                        container);
                            }
                        } else {
                            for (var i = lastLevel; i > level; i--) {
                                container = container.parent();
                            }
                        }

                        if (!element.attr("id")) {
                            element.attr("id", new String(Math.random())
                                    .substr(2));
                        }

                        var link = $("<a>").attr("href",
                                "#" + element.attr("id")).text(text);

                        $("<li>").append(link).appendTo(container);
                        lastLevel = level;
                    }
                });
    }

    var container = $("nav");
    generateToc($("main"), container, "<ol>");
    generateToc($("#appendices"), container, "<ol class='A'>", "<ul>");
    generateToc($("#backmatter"), container, "<ul>");
});