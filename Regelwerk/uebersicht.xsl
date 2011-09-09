<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:diffmk="http://diffmk.sf.net/ns/diff"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

  <xsl:import href="base.xsl"/>

  <xsl:param name="generate.toc">nop</xsl:param>

  <xsl:param name="double.sided">0</xsl:param>
  <xsl:param name="page.margin.top">0.5cm</xsl:param>
  <xsl:param name="page.margin.inner">1cm</xsl:param>
  <xsl:param name="page.margin.outer">1cm</xsl:param>
  <xsl:param name="page.margin.bottom">1cm</xsl:param>

  <xsl:template name="footer.content"></xsl:template>
  <xsl:param name="region.after.extent">0</xsl:param>

  <xsl:template name="component.title"></xsl:template>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="space-before">0</xsl:attribute>
    <xsl:attribute name="space-after">-0.5em</xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
  </xsl:attribute-set>


</xsl:stylesheet>