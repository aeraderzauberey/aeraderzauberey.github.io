// Footnotes as Hovering Tooltips
//
// Original Scripts by Lukas Mathis and Osvaldas Valutis
//     - http://ignorethecode.net/blog/2010/04/20/footnotes/
//     - http://osvaldas.info/blog/elegant-css-and-jquery-tooltip- \
//           responsive-mobile-friendly/
// Modified by Syeong Gan
//     - http://syeong.jcsg.com/2012/07/07/footnote-tooltips/
//     - Uses Mathis's base code and Valutis's tooltip design
//     - Searches for PHP Markdown Extra-style footnotes
//     - Disabled link click-through for Android devices
//     * "Feel free to modify/incorporate the script into your site."
// Modified by Jens Bannmann
//     - https://github.com/aeraderzauberey/aeraderzauberey.github.io
//     - Changes: see commit history
//
// Requirements: jQuery

$(document).ready(function() {
    Footnotes.initTooltip();
});

var Footnotes = {
    isIOS : function() {
        var agent = navigator.userAgent.toLowerCase();
        return (agent.indexOf('iphone') >= 0 || agent.indexOf('ipad') >= 0 || agent
                .indexOf('ipod') >= 0);
    },
    isAndroid : function() {
        var agent = navigator.userAgent.toLowerCase();
        return (agent.indexOf('android') >= 0);
    },
    initTooltip : function() {
        var footnoteList = $('#footnotes');
        var footnoteLinks = $([]);
        var footnoteNumber = 0;

        $('span.footnote').each(
                function() {
                    footnoteNumber++;
                    var source = $(this);

                    var footnote = $('<li id="fn:' + footnoteNumber + '"><p>'
                            + source.text() + '</p></li>');
                    footnoteList.append(footnote);

                    var sup = $('<sup id="fnref:' + footnoteNumber + '">');
                    var footnoteLink = $('<a href="#fn:' + footnoteNumber
                            + '" rel="footnote">' + footnoteNumber + '</a>');
                    footnoteLink.appendTo(sup);
                    source.replaceWith(sup);
                    footnoteLinks = footnoteLinks.add(footnoteLink);
                });

        footnoteLinks.unbind('mouseover', Footnotes.addTooltip);
        footnoteLinks.unbind('mouseout', Footnotes.removeTooltip);
        footnoteLinks.unbind('click', Footnotes.toggleTooltip);

        footnoteLinks.bind('mouseover', Footnotes.addTooltip);
        footnoteLinks.bind('mouseout', Footnotes.removeTooltip);
        footnoteLinks.bind('click', Footnotes.toggleTooltip);
    },
    toggleTooltip : function(e) {
        e.preventDefault();
        if ($('#tooltip').length == 0) {
            Footnotes.addTooltipForElement($(this));
        } else {
            Footnotes.removeTooltip();
        }
    },
    addTooltip : function(e) {
        Footnotes.addTooltipForElement($(this));
    },
    addTooltipForElement : function(target) {
        $('#tooltip').stop();
        $('#tooltip').remove();

        // Find matching footnote text and remove extraneous tags
        var id = target.attr('href').substr(1);
        var footnoteContents = $(document.getElementById(id)).clone();
        footnoteContents.find("a").remove();

        // Create Tooltip
        var tooltip = $('<div id="tooltip"></div>');
        tooltip.click(Footnotes.removeTooltip);

        // Add Tooltip to page (hidden)
        tooltip.css('opacity', 0).append(footnoteContents.html()).appendTo('body');

        var positionTooltip = function() {
            tooltip.css('max-width', $("body").width() * 2 / 3);

            // Set initial position of tooltip
            var pos_left = target.offset().left + (target.outerWidth() / 2)
                    - (tooltip.outerWidth() / 2);
            var pos_top = target.offset().top + 35;

            // Check if the left side of the tooltip is off screen
            if (pos_left < 0) {
                pos_left = target.offset().left + (target.outerWidth() / 2)
                        - 20;
                tooltip.addClass('left');
            } else
                tooltip.removeClass('left');

            // Check if the right side of the tooltip is off screen
            if (pos_left + tooltip.outerWidth() > $(window).width()) {
                pos_left = target.offset().left - tooltip.outerWidth()
                        + (target.outerWidth() / 2) + 20;
                tooltip.addClass('right');
            } else
                tooltip.removeClass('right');

            tooltip.css({
                left : pos_left,
                top : pos_top
            }).animate({
                opacity : 1
            }, 100);
        }

        // Show Tooltip (and reposition if window changes)
        positionTooltip();
        $(window).resize(positionTooltip());
    },
    removeTooltip : function() {
        var tooltip = $('#tooltip');

        tooltip.animate({
            opacity : 0
        }, 100, function() {
            tooltip.remove();
        });
    }
}
