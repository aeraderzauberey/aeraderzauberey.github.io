<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:diffmk="http://diffmk.sf.net/ns/diff"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

  <xsl:import href="file:////Library/Tools/docbook-xsl-1.74.0/fo/docbook.xsl"/>
  <xsl:output method="xml"/>

  <xsl:variable name="date" select="java:format(java:java.text.SimpleDateFormat.new('dd.MM.yyyy'), java:java.util.Date.new())"/>

  <xsl:param name="fop1.extensions">1</xsl:param>

  <xsl:param name="paper.type">A4</xsl:param>
  <xsl:param name="draft.mode">no</xsl:param>
  <xsl:param name="double.sided">1</xsl:param>

  <xsl:param name="hyphenate">true</xsl:param>
  <!-- turn off hyphenation in tables -->
  <xsl:attribute-set name="table.table.properties">
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="page.margin.inner">2cm</xsl:param>
  <xsl:param name="page.margin.outer">2cm</xsl:param>

  <xsl:param name="toc.section.depth">1</xsl:param>
  <xsl:attribute-set name="toc.line.properties">
    <xsl:attribute name="line-height">1.2</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="page.margin.top">1.5cm</xsl:param>
  <xsl:param name="body.margin.top">0</xsl:param>
  <xsl:param name="region.before.extent">0</xsl:param>

  <xsl:param name="header.rule" select="0"></xsl:param>
  <xsl:param name="footer.rule" select="0"></xsl:param>
  
  <!-- Set the page number format to 1,2,3,... -->
  <xsl:template name="page.number.format">1</xsl:template>

  <!-- Let the TOC start at page 3, then always continue page numbers. -->
  <xsl:template name="initial.page.number">
    <xsl:param name="element" select="local-name(.)"/>
    <xsl:choose>
      <xsl:when test="$element = 'toc' and self::book">3</xsl:when>
      <xsl:otherwise>auto</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="book.titlepage.recto">
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          <fo:table-row height="200mm">
            <fo:table-cell display-align="before" padding-top="5.4cm">
              <fo:block text-align="center">
                <fo:external-graphic src="url('../Logo/Logo.svg')" content-width="12cm"/>
              </fo:block>

              <xsl:choose>
                <xsl:when test="bookinfo/subtitle">
                  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/subtitle"/>
                </xsl:when>
                <xsl:when test="info/subtitle">
                  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/subtitle"/>
                </xsl:when>
                <xsl:when test="subtitle">
                  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="subtitle"/>
                </xsl:when>
              </xsl:choose>

              <fo:block text-align="center" space-before="9cm">
                <fo:external-graphic src="url('../Logo/cc by-nc-sa.eu.svg')" content-width="2.5cm"/>
              </fo:block>

            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
  </xsl:template>

  <xsl:template match="subtitle" mode="book.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="center" font-size="30pt" space-before="30pt" font-family="{$title.fontset}">
      <xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="releaseinfo" mode="book.titlepage.verso.auto.mode">
    <xsl:variable name="info"><xsl:value-of select="."/></xsl:variable>

    <fo:block xsl:use-attribute-sets="book.titlepage.verso.style" space-before="0.5em">
      Stand: <xsl:value-of select="$date"/>, r<xsl:value-of select="substring-before(substring-after($info, ': '), ' $')"/>
    </fo:block>
  </xsl:template>

  <xsl:param name="insert.xref.page.number">yes</xsl:param>

  <xsl:param name="column.count.body" select="1"></xsl:param>
  <xsl:param name="body.start.indent" select="'0pt'"></xsl:param>
  <xsl:param name="body.font.master">12</xsl:param>
  <xsl:param name="line-height" select="1.2"></xsl:param>
  <!--<xsl:param name="line-height" select="2.4"></xsl:param>-->
  <xsl:param name="margin.left">none</xsl:param>

  <xsl:param name="table.frame.border.style" select="'none'"></xsl:param>
  <xsl:param name="table.cell.border.style" select="'none'"></xsl:param>

  <xsl:param name="title.font.family">Carolingia</xsl:param>

  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.properties">
  </xsl:attribute-set>

  <xsl:attribute-set name="informalexample.properties">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="margin-left">2em</xsl:attribute>
    <xsl:attribute name="margin-right">2em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="sidebar.properties">
    <xsl:attribute name="margin-left">12.5%</xsl:attribute>
    <xsl:attribute name="margin-right">12.5%</xsl:attribute>
    <xsl:attribute name="padding-top">-0.5em</xsl:attribute>
    <xsl:attribute name="border-top-width">0.01cm</xsl:attribute>
    <xsl:attribute name="border-left-width">0.01cm</xsl:attribute>
    <xsl:attribute name="border-bottom-width">0.05cm</xsl:attribute>
    <xsl:attribute name="border-right-width">0.05cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- Titles of chapters and top-level sections within a chapter -->
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="space-before">0.3em</xsl:attribute>
    <xsl:attribute name="space-after">-0.2em</xsl:attribute>
  </xsl:attribute-set>

  <!-- Titles of second-level sections within chapters -->
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="space-after">-0.6em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="table.cell.block.properties">
    <!-- highlight this entry? -->
    <xsl:if test="ancestor::thead or ancestor::tfoot or @role='head'">
      <xsl:attribute name="font-family">Carolingia</xsl:attribute>
    </xsl:if>
    <xsl:if test="ancestor::row[@role='gray']">
      <xsl:attribute name="color">#A0A0A0</xsl:attribute>
    </xsl:if>
    <xsl:if test="@role='nowrap' or @role='head'">
      <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:attribute-set name="table.cell.padding">
    <xsl:attribute name="padding-right">1em</xsl:attribute>
  </xsl:attribute-set>

  <!-- remove leading space for paras in tables, but keep it between successive paras -->
  <xsl:template match="informaltable//tbody//para[1]">
    <fo:block space-before="0">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- remove all para margins in table headers -->
  <xsl:template match="informaltable//thead//para">
    <fo:block space-before="0">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="listitem//para">
    <fo:block space-before="0">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:attribute-set name="list.block.spacing">
      <xsl:attribute name="space-before">0</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="para[@role='compactheading']">
    <fo:block space-after="0" font-weight="bold">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="processing-instruction('hard-pagebreak')">
    <fo:block break-after='page'/>
  </xsl:template>

  <!-- HACK: should be referenced by some native docbook means, so that it works for HTML output as well -->
  <xsl:template match="processing-instruction('box')">
    <fo:external-graphic src="url('Schadenskästchen.svg')" content-width="0.4cm"/>
  </xsl:template>

  <!-- disable default header -->
  <xsl:template name="header.content">
  </xsl:template>

<!--
  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

      <xsl:choose>
        <xsl:when test="$position='left'">
		  <fo:page-number/>
        </xsl:when>

        <xsl:when test="$position = 'center'">
          <xsl:value-of select="$date"/>
        </xsl:when>

        <xsl:when test="$position = 'right'">
            x<xsl:value-of select="position()"/>
        </xsl:when>

      </xsl:choose>


  </xsl:template>
-->

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
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- nop; no footer on title pages -->
      </xsl:when>

      <xsl:when test="$double.sided = 0 and $position='left'">
        <xsl:value-of select="$date"/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and $sequence = 'even'
                      and $position='left'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')
                      and $position='right'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided = 0 and $position='center'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and $position='center'">
        <xsl:value-of select="$date"/>
      </xsl:when>

      <xsl:when test="$sequence='blank'">
        <xsl:choose>
          <xsl:when test="$double.sided != 0 and $position = 'left'">
            <fo:page-number/>
          </xsl:when>
          <xsl:when test="$double.sided = 0 and $position = 'center'">
            <fo:page-number/>
          </xsl:when>
          <xsl:otherwise>
            <!-- nop -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

  <xsl:template match="diffmk:wrapper">
    <fo:inline background-color="#a0a0a0">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>


</xsl:stylesheet>