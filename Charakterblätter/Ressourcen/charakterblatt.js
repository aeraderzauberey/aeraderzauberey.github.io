$(function() {
    $.get("Ressourcen/Charakterblatt-Seite001.svg", function(data, textStatus, jqXhr) {
        var container = $("<div>").addClass("pageContainer").appendTo("body");
        var coords = $("<div>").addClass("coords").appendTo(container).html(jqXhr.responseText);
        $("#Formular g[id] path").attr("style", "fill: white").each(function(index, element) {
            var pos = $(element).position();
            var clientRect = element.getBoundingClientRect();
            var field = $("<div>").addClass("field").appendTo(coords).css({
                top: pos.top + "px",
                left: pos.left + "px",
                width: clientRect.width + "px",
                height: clientRect.height + "px"
            });

            var inputVerticalOffset = 1;
            var inputExtraHeight = 3;
            var input = $("<input>").appendTo(coords).css({
                top: (pos.top + inputVerticalOffset) + "px",
                left: pos.left + "px",
                width: clientRect.width + "px",
                height: (clientRect.height + inputExtraHeight + 1) + "px"
            });
            if (clientRect.width > clientRect.height * 5) {
                input.addClass("wide");
            }
        });
    });
});