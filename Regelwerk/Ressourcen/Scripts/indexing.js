/*
 * Base form and alternatives can be specified either in the <dfn> body or as attributes:
 * - Reticulating <dfn data-base="spline">splines</dfn>.
 * - First, we need to make sure each <dfn data-alternatives="splines">spline</dfn> is reticulated.
 * Both examples result in the same index entries - an index term "spline" with a hidden alternative "splines". The techniques can be mixed.
 * 
 * The data-alternatives attribute specifies a comma-separated list of alternatives (added to the implicit one if data-base is used).
 * 
 * The data-synonyms attribute is a comma-separated list of official synonyms that appear in the index as well, e.g. abbreviations.
 */
$(function() {
    var forbiddenCharacters = /[\\.[\]^$()*?+|{}]/g;
    var termInfoList = [];
    var lookupMap = {};
    var termExpressions = [];

    function processDefinition() {
        var element = $(this);

        var termInfo = {
            base : null,
            alternatives : [],
            synonyms : [],
            definitionElement : element,
            occurrenceNodes : []
        };

        var baseAttribute = element.data().base;
        if (baseAttribute) {
            termInfo.base = baseAttribute;
            termInfo.alternatives.push(element.text());
        } else {
            termInfo.base = element.text();
        }

        function add(property) {
            var list = element.data()[property];
            if (list) {
                termInfo[property] = termInfo[property].concat(list.split(","));
            }
        }
        add("alternatives");
        add("synonyms");

        termInfo.id = "def-"
                + termInfo.base.toLowerCase().replace(/[^a-z]/g, "");
        termInfo.definitionElement.attr("id", termInfo.id);

        $.each([ termInfo.base ].concat(termInfo.alternatives,
                termInfo.synonyms), function(index, value) {
            lookupMap[value] = termInfo;

            if (!value.match(forbiddenCharacters)) {
                termExpressions.push(value.replace(/ /g, "\\s+"));
            } else {
                logError("invalid index term:", value);
            }
        });
        termInfoList.push(termInfo);

    }
    $('dfn').each(processDefinition);

    var regex = new RegExp("\\b(" + termExpressions.join("|") + ")\\b", "g");

    var nodeIterator = document.createNodeIterator(document,
            NodeFilter.SHOW_TEXT, {
                acceptNode : function(node) {
                    return NodeFilter.FILTER_ACCEPT;
                }
            });

    var replacements = [];
    var node;
    while ((node = nodeIterator.nextNode())) {
        regex.lastIndex = 0;
        var searchResult;
        var newNodes = [];

        var position = 0;
        while ((searchResult = regex.exec(node.data)) != null) {
            if (searchResult.index > 0) {
                newNodes.push(document.createTextNode(node.data.substring(
                        position, searchResult.index)));
            }

            var termAsFound = searchResult[1];

            var span = document.createElement("span");
            span.setAttribute("class", "indexterm");
            span.appendChild(document.createTextNode(termAsFound))
            newNodes.push(span);

            position = searchResult.index + termAsFound.length;

            var termInfo = lookupMap[termAsFound];
            if (!termInfo) {
                /*
                 * The term that was found is different due to the whitespace
                 * wildcard. Normalize whitespace to find it.
                 */
                var termKey = termAsFound.replace(/\s+/g, " ");
                termInfo = lookupMap[termKey];
            }
            termInfo.occurrenceNodes.push(span);
        }

        if (newNodes.length) {
            if (position < node.data.length) {
                newNodes.push(document.createTextNode(node.data
                        .substr(position)));
            }

            /*
             * Store replacements for later use - NodeIterator crashes when
             * modifying the DOM while using it (Firefox 34).
             */
            replacements.push({
                "originalNode" : node,
                "newNodes" : newNodes
            });
        }
    }

    var replacement;
    while (replacement = replacements.shift()) {
        var node = replacement.originalNode;
        var element = node.parentNode;

        var newNode;
        while (newNode = replacement.newNodes.shift()) {
            element.insertBefore(newNode, node);
        }
        element.removeChild(node);
    }
});