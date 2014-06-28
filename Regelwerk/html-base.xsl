<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
    xmlns:diffmk="http://diffmk.sf.net/ns/diff"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:java="http://xml.apache.org/xslt/java"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:d="http://docbook.org/ns/docbook"
    exclude-result-prefixes="java">

  <xsl:import href="file:////Library/Tools/docbook-xsl-snapshot/html/docbook.xsl"/>
  <xsl:variable name="date">(date)</xsl:variable>
  <xsl:variable name="releaseInfoRaw"><xsl:value-of select="/d:book/d:info/d:releaseinfo"/></xsl:variable>
  <xsl:variable name="releaseInfoRevision"><xsl:value-of select="substring-before(substring-after($releaseInfoRaw, ': '), ' $')"/></xsl:variable>

  <xsl:param name="show.comments">0</xsl:param>

	<!-- hide paragraphs that only consist of a remark -->
	<xsl:template match="para[count(*)=1 and remark and not(text())]">
		<xsl:if test="$show.comments != 0">
			<fo:block xsl:use-attribute-sets="normal.para.spacing">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="comment|remark">
		<xsl:if test="$show.comments != 0">
			<fo:inline xsl:use-attribute-sets="remark.properties">
				<xsl:call-template name="inline.charseq"/>
			</fo:inline>
		</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="remark.properties">
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="color">#0000c0</xsl:attribute>
	</xsl:attribute-set>


</xsl:stylesheet>