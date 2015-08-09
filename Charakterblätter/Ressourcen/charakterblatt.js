$(function() {
    $.get("Ressourcen/Charakterblatt-Seite001.svg", function(data, textStatus, jqXhr) {
        var container = $("<div>").addClass("pageContainer").appendTo("body");
        var coords = $("<div>").addClass("coords").appendTo(container).html(jqXhr.responseText);
        $("#Formular g[id] path").attr("style", "fill: white").each(function(index, element) {
            var pos = $(element).position();
            var box = element.getClientRects()[0];
            var field = $("<div>").addClass("field").appendTo(coords).css({
                top: pos.top + "px",
                left: pos.left + "px",
                width: box.width + "px",
                height: box.height + "px"
            });

            var inputHeightOffset = 8;
            var input = $("<input>").appendTo(coords).css({
                top: (pos.top - inputHeightOffset) + "px",
                left: pos.left + "px",
                width: box.width + "px",
                height: (box.height + inputHeightOffset) + "px"
            });
            if (box.width > box.height * 5) {
                input.addClass("wide");
            }
        });
    });
});