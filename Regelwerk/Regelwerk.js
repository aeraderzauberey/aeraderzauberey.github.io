$(function() {
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
                    console.log(text);
                    var level = element.parents("section").length + 1;

                    if (level <= maxLevel) {
                        console.log("level = " + level);
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