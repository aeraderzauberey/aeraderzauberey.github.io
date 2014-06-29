DocBook|Bedeutung|HTML-Markup
-------|---------|-----------
`<book>`|Wurzelelement|`<body>`
`<info>`|Metainformationen|_zu definieren_, ggf. erstmal nicht ins HTML übernehmen
`<chapter>`|Kapitel eines Buches|`<section><h1>`
`<... xml:id="foo">`|Element-ID|`<... id="foo">`
`<title>`|Titel des jeweiligen Elements|Text des `<h*>`-Elements
`<para>`|Absatz|`<p>`
`<section>`|Unterkapitel|`<section><h1>`
`<emphasis>`|Betonung/Kursiv|`<em>`
`<para><remark>bla</remark></para>`|Anmerkung/Hintergrund zum Regeltext|`<p class="remark">bla</p>`
`<indexterm>`|Begriff, der im Index aufgeführt wird|_erstmal nicht übernehmen, später ggf. manuell_ `<a href="#def-probe">`
`<indexterm significance="preferred">`|Primäre Textstelle für diesen Begriff|`Dazu wird eine <dfn id="def-probe">Probe</dfn> durchgeführt`
`<indexterm significance="preferred">`|Primäre Textstelle für diesen Begriff (abweichende Schreibweise)|`dazu werden <dfn id="def-probe" title="Probe">Proben</dfn> durchgeführt`
`<firstterm>`|Einführung eines neuen Begriffs|wie `<indexterm significance="preferred">` 
`<informaltable>`|Tabelle|`<table>`
`<entry>` innerhalb von `<thead>`|Kopfzelle|`<th>`
`<entry>` innerhalb von `<tbody>`|Normale Zelle|`<td>`
`<inlinemediaobject>`...`<imagedata>`|Bild|`<img>`
`<colspec colnum="1" colwidth="5*"/>`|Layoutinfos für Spalte|in HTML erstmal nicht nötig
Komplett leere Spalten links oder rechts|zum Zentrieren der Tabelle|`<table class="center">`
`<xref linkend="proben"/>`|Verweis auf anderes Kapitel|`<a href="#proben">TODO</a>`
`<xref linkend="magiefertigkeiten" xrefstyle="page"/>`|Verweis auf Seitenzahl eines anderen Kapitels|`<a href="#magiefertigkeiten" class="page">TODO</a>`
`<informalexample><para/><para/>`|Beispiel|`<div class="example"><p/><p/>`
`<orderedlist>`|Nummerierte Liste|`<ol>`
`<itemizedlist>`|Bullet-Liste|`<ul>`
`<listitem><para>foo</para></listitem>`|Listeneintrag|`<li>foo</li>`
