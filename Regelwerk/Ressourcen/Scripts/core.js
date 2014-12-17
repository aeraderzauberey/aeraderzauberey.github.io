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
    
    function checkIds() {
        var ids = {};
        var found = false;
        $('[id]').each(function() {
          if (this.id && ids[this.id]) {
              logError('Duplicate ID #' + this.id);
          }
          ids[this.id] = 1;
        });
    }
    checkIds();
});