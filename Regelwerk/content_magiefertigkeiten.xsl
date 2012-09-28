<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:diffmk="http://diffmk.sf.net/ns/diff"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java"
	xmlns:d="http://docbook.org/ns/docbook">


<xsl:template match="/">
<d:book>
	<xsl:copy-of select="/d:book/d:info"/>
	<d:chapter>
		<xsl:for-each select="d:book/d:appendix/d:section/d:section">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</d:chapter>
</d:book>
</xsl:template>




</xsl:stylesheet>