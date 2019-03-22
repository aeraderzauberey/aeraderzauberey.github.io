$(function() {
    function jumpToNext() {
        var subSections = $(this).parents("h1").nextAll("section");
        var siblingSections = $(this).parents("section").next();
        var target = $().add(subSections).add(siblingSections).first();
        jumpTo(target);
    }

    function jumpToPrevious() {
        var siblingSection = $(this).parents("section").first().prevAll(
                "section").first();
        var siblingDeepestSection = siblingSection.children().andSelf().filter(
                "section").last();

        var parentSection = $(this).parents("section").slice(1).first();

        var target;
        if (siblingDeepestSection.length) {
            target = siblingDeepestSection;
        } else {
            target = parentSection;
        }
        jumpTo(target);
    }

    function getOrGenerateIdFor(element) {
        var id = element.attr("id");
        if (!id) {
            id = new String(Math.random()).substr(2);
            element.attr("id", id);
        }
        return id;
    }

    function jumpTo(element) {
        var id = getOrGenerateIdFor(element);
        window.location.hash = "#" + id;
    }

    function jumpToNav() {
        $(this).parents("section").each(
                function(index, element) {
                    var id = $(element).first().attr("id");
                    var target = $("#toc_" + id);
                    if (target.length) {
                        target.parents("ol, ul").parents(".collapsed")
                                .toggleClass("collapsed").toggleClass(
                                        "expanded");
                        jumpTo(target);
                        window.scrollBy(0,
                                -(document.documentElement.clientHeight / 2));
                        return false;
                    }
                });
    }

    var maxLevel = 3;
    var maxInitialLevel = 2;
    function generateToc(rootSection, targetElement, rootSectionTemplate,
            subSectionTemplate) {
        if (!subSectionTemplate) {
            subSectionTemplate = rootSectionTemplate;
        }
        var lastLevel = 0;
        var container = targetElement;
        var currentList = null;

        function toggleToc() {
            $(this).parents(".collapsible").toggleClass("collapsed")
                    .toggleClass("expanded");
        }
        function processSection(index, htmlElement) {
            var element = $(htmlElement);
            var level = element.parents("section").length + 1;

            var heading = element.find("> h1");
            var text = heading.text().trim();

            var buttons = $("<span class='buttons'>").appendTo(heading);
            $('<i class="fa fa-angle-up">').click(jumpToPrevious).appendTo(
                    buttons);
            $('<i class="fa fa-angle-down">').click(jumpToNext).appendTo(
                    buttons);

            buttons.append('<i class="break">');
            $('<i class="fa fa-list">').click(jumpToNav).appendTo(buttons);

            if (level <= maxLevel) {
                if (level > lastLevel) {
                    if (level == 1) {
                        currentList = $(rootSectionTemplate).appendTo(
                                targetElement);
                    } else {
                        currentList = $(subSectionTemplate).appendTo(
                                currentList.children().last());
                    }
                } else if (level < lastLevel) {
                    for (var i = lastLevel; i > level; i--) {
                        currentList = currentList.parent().parent();
                    }
                }

                var id = getOrGenerateIdFor(element);

                var link = $("<a>").attr("href", "#" + id).attr("id",
                        "toc_" + id).text(text);

                var li = $("<li>").append(link).appendTo(currentList);

                if (level > maxInitialLevel) {
                    var parentLi = currentList.parent();
                    if (!parentLi.hasClass("collapsible")) {
                        parentLi.addClass("collapsible collapsed");
                        $(
                                '<span class="toggler"><i class="fa fa-plus"></i><i class="fa fa-minus"></i></span>')
                                .click(toggleToc).insertBefore(currentList);
                    }
                }
                lastLevel = level;
            }
        }

        rootSection.find("section").each(processSection);
    }

    var container = $("nav");
    generateToc($("#intro"), container, "<ul>");
    generateToc($("main"), container, "<ol>");
    generateToc($("#appendices"), container, "<ol class='A'>", "<ul>");
    generateToc($("#backmatter"), container, "<ul>");
});