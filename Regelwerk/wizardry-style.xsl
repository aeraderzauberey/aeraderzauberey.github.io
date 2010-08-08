<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions">

  <xsl:import href="file:////Library/Tools/docbook-xsl-1.74.0/fo/docbook.xsl"/>
  <xsl:output method="xml"/>

  <xsl:param name="paper.type" select="'A4'"></xsl:param>
  <xsl:param name="draft.mode">no</xsl:param>
  <xsl:param name="double.sided">0</xsl:param>
  <xsl:param name="hyphenate">false</xsl:param>
  <xsl:param name="page.margin.inner">2cm</xsl:param>
  <xsl:param name="page.margin.outer">2cm</xsl:param>

  <xsl:param name="toc.section.depth">1</xsl:param>
  <xsl:attribute-set name="toc.line.properties">
    <xsl:attribute name="line-height">1.2</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="page.margin.top">1cm</xsl:param>
  <xsl:param name="body.margin.top">2cm</xsl:param>
  <xsl:param name="region.before.extent">2cm</xsl:param>
  <xsl:param name="header.image.height">1.25cm</xsl:param>

  <xsl:param name="header.image.filename">file:////Users/jens/Documents/Rollenspiel/Wizardry/Logo/Logo.svg</xsl:param>
  <xsl:param name="footer.rule" select="0"></xsl:param>
  
  <!-- This template always returns the string '1', which
       sets the page number format to 1,2,3,... -->
  <xsl:template name="page.number.format">1</xsl:template>

  <!-- Let the TOC start at page 3, then always continue page numbers. -->
  <xsl:template name="initial.page.number">
    <xsl:param name="element" select="local-name(.)"/>
    <xsl:choose>
      <xsl:when test="$element = 'toc' and self::book">3</xsl:when>
      <xsl:otherwise>auto</xsl:otherwise>
    </xsl:choose>
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
<!--    <xsl:if test="ancestor::informaltable">-->
      <xsl:attribute name="space-before">0</xsl:attribute>
<!--    </xsl:if>-->
  </xsl:attribute-set>

  <xsl:template match="para[@role='compactheading']">
    <fo:block space-after="0" font-weight="bold">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="processing-instruction('hard-pagebreak')">
    <fo:block break-after='page'/>
  </xsl:template>

  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <xsl:variable name="candidate">
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>

        <xsl:when test="$position = 'left'">
          <fo:external-graphic content-height="1.25cm">
            <xsl:attribute name="src">
              <xsl:call-template name="fo-external-image">
                <xsl:with-param name="filename" select="$header.image.filename"/>
              </xsl:call-template>
            </xsl:attribute>
          </fo:external-graphic>
        </xsl:when>

        <xsl:when test="$position = 'center'">
          <xsl:value-of select="//title[1]"/>
        </xsl:when>

      </xsl:choose>

    </xsl:variable>

    <xsl:choose>

      <xsl:when test="$sequence='blank' and $headers.on.blank.pages=0">
        <!-- no output -->
      </xsl:when>

      <!-- titlepages have no headers -->
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- no output -->
      </xsl:when>

      <xsl:otherwise>
        <xsl:copy-of select="$candidate"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <xsl:variable name="candidate">
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>

        <xsl:when test="$position = 'left'">
          <xsl:value-of select="//title[1]"/>
        </xsl:when>

        <xsl:when test="$position = 'center'">
          <fo:page-number/>
        </xsl:when>

        <xsl:when test="$position = 'right'">
          <xsl:value-of select="//pubdate[1]"/>
        </xsl:when>

      </xsl:choose>

    </xsl:variable>

    <xsl:choose>

      <xsl:when test="$sequence='blank' and $headers.on.blank.pages=0">
        <!-- no output -->
      </xsl:when>

      <!-- titlepages have no headers -->
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- no output -->
      </xsl:when>

      <xsl:otherwise>
        <xsl:copy-of select="$candidate"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


</xsl:stylesheet>