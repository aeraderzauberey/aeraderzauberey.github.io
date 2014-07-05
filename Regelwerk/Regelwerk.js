$(function() {
  var container = $("nav");
  var lastLevel = 0;
  $("main").add("#appendices").find("section").each(function(index, htmlElement) {
                                                    var element = $(htmlElement);
                                                    var text = element.find("> h1").text();
                                                    console.log(text);
                                                    var level = element.parents("section").length + 1;
                                                    console.log("level = "+level);
                                                    if (level > lastLevel) {
                                                        container = $("<ol>").appendTo(container);
                                                    } else {
                                                        for (var i = lastLevel; i > level; i--) {
                                                            container = container.parent();
                                                        }
                                                    }
                                                    $("<li>").text(text).appendTo(container);
                                                    lastLevel = level;
                                                    
                                                    // Spätestens fürs Stichwortverzeichnis funktioniert das nicht, denn es hat keine Nummer.

                                                    
                         });
});