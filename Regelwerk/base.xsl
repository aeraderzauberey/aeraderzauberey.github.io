<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
    xmlns:diffmk="http://diffmk.sf.net/ns/diff"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:java="http://xml.apache.org/xslt/java"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="java">

  <xsl:import href="file:////Library/Tools/docbook-xsl-1.76.1/fo/docbook.xsl"/>
  <xsl:output method="xml"/>

  <xsl:variable name="date" select="java:format(java:java.text.SimpleDateFormat.new('dd.MM.yyyy'), java:java.util.Date.new())"/>

  <xsl:param name="fop1.extensions">1</xsl:param>

  <xsl:param name="paper.type">A4</xsl:param>
  <xsl:param name="draft.mode">no</xsl:param>

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
    <xsl:attribute name="line-height">1.5</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="page.margin.top">1.5cm</xsl:param>
  <xsl:param name="body.margin.top">0</xsl:param>
  <xsl:param name="region.before.extent">0</xsl:param>

  <xsl:param name="header.rule">0</xsl:param>
  <xsl:param name="footer.rule">0</xsl:param>

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
                <fo:external-graphic src="url('../Logo/Logo.svg')" content-width="14cm"/>
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
    <fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="center" font-size="40pt" space-before="30pt" font-family="{$title.fontset}">
      <xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="book.titlepage.verso">
    <xsl:choose>
      <xsl:when test="bookinfo/title">
        <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/title"/>
      </xsl:when>
      <xsl:when test="info/title">
        <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/title"/>
      </xsl:when>
      <xsl:when test="title">
        <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="title"/>
      </xsl:when>
    </xsl:choose>

    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/corpauthor"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/corpauthor"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/authorgroup"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/authorgroup"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/author"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/author"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/othercredit"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/othercredit"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/releaseinfo"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/releaseinfo"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/pubdate"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/pubdate"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/copyright"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/copyright"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/abstract"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/abstract"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="bookinfo/legalnotice"/>
    <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="info/legalnotice"/>

    <fo:block margin-top="2cm" xsl:use-attribute-sets="book.titlepage.verso.style">
      <fo:table>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell width="1.75cm">
              <fo:block>
                <fo:external-graphic src="url('../Grafiken/qrcode.svg')" content-width="1.5cm"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell display-align="center">
              <fo:block>Das aktuelle Regelwerk ist auf der Website</fo:block>
              <fo:block>http://www.aeraderzauberey.de/ verfügbar.</fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template match="releaseinfo" mode="book.titlepage.verso.auto.mode">
    <xsl:variable name="info"><xsl:value-of select="."/></xsl:variable>

    <fo:block xsl:use-attribute-sets="book.titlepage.verso.style" space-before="0.5em">
      Stand: <xsl:value-of select="$date"/>, r<xsl:value-of select="substring-before(substring-after($info, ': '), ' $')"/>
    </fo:block>
  </xsl:template>

  <xsl:param name="insert.xref.page.number">yes</xsl:param>
  
  <!-- xref: leave out element type and numbering, just use the title. also, use "Seite X" instead of "[X]". -->
  <xsl:param name="local.l10n.xml" select="document('')"/>
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="de">
      <l:context name="xref-number-and-title">
        <l:template name="chapter" text="%t,&#160;"/>
        <l:template name="appendix" text="%t,&#160;"/>
      </l:context>

      <l:context name="xref">
        <l:template name="section" text="%t,&#160;"/>

        <l:template name="page.citation" text="Seite %p"/>
      </l:context>
    </l:l10n>
  </l:i18n>
  
  <!-- format ALL titles in xrefs using italics -->
  <xsl:template match="*" mode="insert.title.markup">
    <xsl:param name="purpose"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="title"/>

    <xsl:choose>
      <xsl:when test="$purpose = 'xref'">
        <fo:inline font-style="italic">
          <xsl:copy-of select="$title"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- leave out title in xrefs with xrefstyle="page" (copied and simplified from fo/xref.xsl) -->
  <xsl:template match="xref" name="xref">
    <xsl:param name="xhref" select="@xlink:href"/>
    <!-- is the @xlink:href a local idref link? -->
    <xsl:param name="xlink.idref">
      <xsl:if test="starts-with($xhref,'#')
                    and (not(contains($xhref,'&#40;'))
                    or starts-with($xhref, '#xpointer&#40;id&#40;'))">
        <xsl:call-template name="xpointer.idref">
          <xsl:with-param name="xpointer" select="$xhref"/>
        </xsl:call-template>
     </xsl:if>
    </xsl:param>
    <xsl:param name="xlink.targets" select="key('id',$xlink.idref)"/>
    <xsl:param name="linkend.targets" select="key('id',@linkend)"/>
    <xsl:param name="target" select="($xlink.targets | $linkend.targets)[1]"/>
    <xsl:param name="refelem" select="local-name($target)"/>

    <xsl:variable name="xrefstyle">
      <xsl:value-of select="@xrefstyle"/>
    </xsl:variable>

    <xsl:variable name="content">
      <fo:inline xsl:use-attribute-sets="xref.properties">
        <xsl:choose>
          <xsl:when test="$target">
            <xsl:apply-templates select="$target" mode="xref-to">
              <xsl:with-param name="referrer" select="."/>
              <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            </xsl:apply-templates>
    
            <xsl:if test="not(parent::citation)">
              <xsl:apply-templates select="$target" mode="xref-to-suffix"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:text>ERROR: xref linking to </xsl:text>
              <xsl:value-of select="@linkend|@xlink:href"/>
              <xsl:text> has no generated link text.</xsl:text>
            </xsl:message>
            <xsl:text>???</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </fo:inline>
    </xsl:variable>

    <!-- Convert it into an active link -->
    <xsl:if test="not($xrefstyle = 'page')">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content" select="$content"/>
      </xsl:call-template>
    </xsl:if>

    <!-- Add standard page reference? -->
    <xsl:choose>
      <xsl:when test="not($target)">
        <!-- page numbers only for local targets -->
      </xsl:when>
      <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:') 
                    and contains($xrefstyle, 'nopage')">
        <!-- negative xrefstyle in instance turns it off -->
      </xsl:when>
      <!-- positive xrefstyle already handles it -->
      <xsl:when test="not(starts-with(normalize-space($xrefstyle), 'select:') 
                    and (contains($xrefstyle, 'page')
                         or contains($xrefstyle, 'Page')))
                    and ( $insert.xref.page.number = 'yes' 
                       or $insert.xref.page.number = '1')
                    or local-name($target) = 'para'">
        <xsl:apply-templates select="$target" mode="page.citation">
          <xsl:with-param name="id" select="$target/@id|$target/@xml:id"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  
  <!-- column configuration -->
  <xsl:param name="column.count.body">1</xsl:param>
  <xsl:param name="column.count.back">1</xsl:param>
  <xsl:attribute-set name="component.titlepage.properties">
    <xsl:attribute name="span">all</xsl:attribute>
    <xsl:attribute name="margin-bottom">1em</xsl:attribute>
  </xsl:attribute-set>


  <xsl:param name="body.start.indent">0pt</xsl:param>
  <xsl:param name="body.font.master">12</xsl:param> <!-- TODO experiment with '10' -->
  <xsl:param name="line-height">1.2</xsl:param>
  <xsl:param name="margin.left">none</xsl:param>

  <xsl:param name="table.frame.border.style">none</xsl:param>
  <xsl:param name="table.cell.border.style">none</xsl:param>


  <xsl:attribute-set name="informaltable.properties">
    <xsl:attribute name="keep-together.within-column">
      <xsl:choose>
        <xsl:when test="@role='breakable'">never</xsl:when>
        <xsl:otherwise>always</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

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

  <!-- Index customization -->
  <xsl:param name="column.count.index">3</xsl:param>
  <xsl:attribute-set name="index.div.title.properties">
    <xsl:attribute name="space-after">0.5em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="table.cell.block.properties">
    <!-- highlight this entry? -->
    <xsl:if test="ancestor::thead or ancestor::tfoot or @role='head'">
      <xsl:attribute name="font-family">Carolingia</xsl:attribute>
      <xsl:attribute name="font-size">120%</xsl:attribute>
    </xsl:if>
    <xsl:if test="ancestor::row[@role='gray']">
      <xsl:attribute name="color">#A0A0A0</xsl:attribute>
    </xsl:if>
    <xsl:if test="self::node()[@role='group']">
      <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
      <xsl:attribute name="border-bottom-color">black</xsl:attribute>
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

	<!-- remove para magins in lists -->
	<xsl:template match="listitem//para">
		<fo:block space-before="0">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:attribute-set name="list.block.spacing">
		<xsl:attribute name="space-before">0</xsl:attribute>
	</xsl:attribute-set>

  <xsl:attribute-set name="list.item.spacing">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="space-before.optimum">
		  <xsl:choose><xsl:when test="ancestor::variablelist">1em</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
	  </xsl:attribute>
      <xsl:attribute name="space-before.minimum">
		  <xsl:choose><xsl:when test="ancestor::variablelist">0.8em</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
	  </xsl:attribute>
      <xsl:attribute name="space-before.maximum">
		  <xsl:choose><xsl:when test="ancestor::variablelist">1.2em</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
	  </xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="variablelist.as.blocks">1</xsl:param>
  <xsl:attribute-set name="variablelist.term.properties">
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="space-before">1em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="para[@role='compactheading']">
    <fo:block space-after="0" font-weight="bold">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="processing-instruction('hard-pagebreak')">
    <fo:block break-after='page'/>
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