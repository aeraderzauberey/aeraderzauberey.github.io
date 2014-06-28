<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:diffmk="http://diffmk.sf.net/ns/diff"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">


	<xsl:import href="base.xsl"/>

	<xsl:param name="double.sided">0</xsl:param>
	<xsl:param name="page.margin.inner">1.75cm</xsl:param>
	<xsl:param name="page.margin.outer">1.75cm</xsl:param>


	<xsl:param name="page.margin.top">2.1cm</xsl:param>
	<xsl:param name="body.margin.top">0</xsl:param>
	<xsl:param name="region.before.extent">0</xsl:param>

	<xsl:param name="region.after.extent">0.4cm</xsl:param>
	<xsl:param name="body.margin.bottom">1.1cm</xsl:param><!-- + sum = 2.1 -->
	<xsl:param name="page.margin.bottom">1.0cm</xsl:param><!-- ^ -->


	<xsl:attribute-set name="footer.content.properties">
		<xsl:attribute name="font-family">Carolingia</xsl:attribute>
		<!--<xsl:attribute name="font-size">12pt</xsl:attribute>-->
	</xsl:attribute-set>


	<xsl:template name="footer.content">
	  <xsl:param name="pageclass" select="''"/>
	  <xsl:param name="sequence" select="''"/>
	  <xsl:param name="position" select="''"/>
	  <xsl:param name="gentext-key" select="''"/>
	  
	  <fo:block>
		<!-- pageclass can be front, body, back -->
		<!-- sequence can be odd, even, first, blank -->
		<!-- position can be left, center, right -->
		<xsl:choose>
		  <xsl:when test="$position='center'">
			<fo:page-number/>
		  </xsl:when>
		  <xsl:otherwise>
			<!-- nop -->
		  </xsl:otherwise>
		</xsl:choose>
	  </fo:block>
	</xsl:template>

</xsl:stylesheet>