$(function() {
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
});