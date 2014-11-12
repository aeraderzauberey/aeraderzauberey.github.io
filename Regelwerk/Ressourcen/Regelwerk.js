$(function() {
    function logError() {
        $("body").addClass("error");
        console.error.apply(console, arguments);
    }

    $("img").error(function() {
        logError("Failed to load", this);
    });

    var revisionElement = $("#revision");
    if (revisionElement.is(":empty")) {
        function displayUnknownRevisionMessage() {
            $("#revision").text("Stand: unbekannt");
        }
        $.ajax({
            url : "../buildinfo.json",
            success : function(buildinfo) {
                if ('revision' in buildinfo && 'time' in buildinfo) {
                    var regex = /^(\d{4})-(\d{2})-(\d{2}).*$/;
                    var match = regex.exec(buildinfo.time);
                    var readableDate = match[3] + "." + match[2] + "."
                            + match[1];

                    var readableRevision = buildinfo.revision.substr(0, 7);

                    revisionElement.text("Stand: " + readableDate + ", "
                            + readableRevision);
                } else {
                    console.log("missing properties in buildinfo", buildinfo);
                    displayUnknownRevisionMessage();
                }
            },
            error : function(jqXHR, textStatus, errorThrown) {
                console.log("buildinfo could not be parsed: " + errorThrown);
                console.log("raw buildinfo:", jqXHR.responseText);
                displayUnknownRevisionMessage();
            },
            dataType : "json"
        });
    }

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
                        element.text(headingText);
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
        } else {
            logError("invalid link href", domElement,
                    "only ID refs or external URLs allowed");
        }
    }
    $("a[href]").each(processLink);

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

    $(window).on('hashchange', function() {
        if (window.location.hash.substr(0, 5) != "#toc_") {
            ensureNotObscured($(window.location.hash));
        }
    });

    function ensureNotObscured(target) {
        // Google Chrome mobile redisplays its toolbar when the hash
        // changes, thus hiding the target element. We detect and fix
        // this quickly if it occurs during the first second.
        var interval = window.setInterval(function() {
            if (!isElementInViewport(target)) {
                $(window.location.hash)[0].scrollIntoView();
            }
        }, 50);

        window.setTimeout(function() {
            window.clearInterval(interval);
        }, 1000);
    }

    function isElementInViewport(el) {
        if (el instanceof jQuery) {
            el = el[0];
        }

        var rect = el.getBoundingClientRect();

        return (rect.top >= 0 && rect.left >= 0
                && rect.bottom <= $(window).height() && rect.right <= $(window)
                .width());
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
            var text = heading.text();

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
    generateToc($("main"), container, "<ol>");
    generateToc($("#appendices"), container, "<ol class='A'>", "<ul>");
    generateToc($("#backmatter"), container, "<ul>");
});