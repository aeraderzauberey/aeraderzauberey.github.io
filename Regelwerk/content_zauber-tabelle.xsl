<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
    xmlns:diffmk="http://diffmk.sf.net/ns/diff"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook">


<xsl:template match="/">
<book version="5.0" xml:lang="de">
    <xsl:for-each select="d:book/d:chapter">
    <chapter>
        <title><xsl:value-of select="d:title"/></title>
    <xsl:for-each select="d:section">
    <section>
        <title><xsl:value-of select="d:title"/></title>
        <informaltable>
            <tgroup cols="6">
                <colspec colnum="1" colwidth="1*" />
                <colspec colnum="2" colwidth="1*" />
                <colspec colnum="3" colwidth="1*" />
                <colspec colnum="4" colwidth="1*" />
                <colspec colnum="5" colwidth="1*" />
                <colspec colnum="6" colwidth="4*" />
                <thead>
		    <row>
		        <entry>Name</entry>
		        <entry>Fertigkeiten</entry>
		        <entry>Schwierigkeit</entry>
		        <entry>Kraft</entry>
	                <entry>Wirkungsdauer</entry>
		        <entry>Beschreibung</entry>
                    </row>
                </thead>
                <tbody>
                    <xsl:for-each select="d:section">
                        <row>
                            <entry><xsl:value-of select="d:title"/></entry>
                            <xsl:for-each select="d:variablelist/d:varlistentry/d:listitem">
                                <entry>
                                    <xsl:for-each select="*">
                                        <xsl:copy-of select="."/>
                                    </xsl:for-each>
                                </entry>
                            </xsl:for-each>
                        </row>
                    </xsl:for-each>
                    <row><entry/></row>
                </tbody>
            </tgroup>
        </informaltable>
    </section>
    </xsl:for-each>
    </chapter>
    </xsl:for-each>
</book>
</xsl:template>




</xsl:stylesheet>