<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:diffmk="http://diffmk.sf.net/ns/diff"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:java="http://xml.apache.org/xslt/java"
    xmlns:d="http://docbook.org/ns/docbook"
	exclude-result-prefixes="java">

  <xsl:import href="base.xsl"/>

  <xsl:param name="generate.toc">nop</xsl:param>

  <xsl:param name="double.sided">0</xsl:param>
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="page-break-before">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="footer.content.custom_cell">
    r<xsl:value-of select="$releaseInfoRevision"/>
  </xsl:template>

  <xsl:param name="show.comments">1</xsl:param>

  <xsl:template name="book.titlepage.before.recto"/>
  <xsl:template name="book.titlepage.recto"/>
  <xsl:template name="book.titlepage.before.verso"/>
  <xsl:template name="book.titlepage.verso"/>

</xsl:stylesheet>