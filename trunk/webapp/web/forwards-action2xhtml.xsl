<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : forwards-action2xhtml.xsl
    Created on : October 23, 2004, 12:27 PM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="http://www.w3.org/1999/xhtml">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="master.xsl"/>

<xsl:template match="error">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Error</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Error in Processing Sequence</p>
<p><xsl:apply-templates/></p>
</body>
</html>
</xsl:template>

<xsl:template match="data">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Forwards/Backwards Trace</title>
<xsl:call-template name="style"/>
<style type="text/css">
div.probabilities { padding: 0pt; margin: 0pt; padding: 5pt; margin-left: 10pt; }
div.trace { padding: 0pt; margin: 0pt; padding: 5pt; margin-left: 10pt; }
th {
   color: gray;
   font-size: 110%;
}
</style>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Results of Forwards/Backwards for Sequence</p>
<p class="subtitle">Probabilities</p>
<div class="probabilities">
<xsl:apply-templates select="forwards|backwards"/>
</div>
<p class="subtitle">Trace</p>
<div class="trace">
<xsl:apply-templates select="forwards" mode="trace"/>
</div>
</body>
</html>
</xsl:template>

<xsl:template match="forwards">
<p>Forwards : <xsl:value-of select="@probability"/></p>
</xsl:template>

<xsl:template match="backwards">
<p>Backwards : <xsl:value-of select="@probability"/></p>
</xsl:template>

<xsl:template match="forwards" mode="trace">
<table>
<xsl:apply-templates select="../states"/>
<xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="states">
<tr>
<th colspan="{count(*)}">Forwards</th>
<th colspan="{count(*)}">Backwards</th>
</tr>
<tr>
<xsl:apply-templates/>
<xsl:apply-templates/>
</tr>
</xsl:template>

<xsl:template match="state">
<th><xsl:apply-templates/></th>
</xsl:template>

<xsl:template match="row">
<xsl:variable name="pos" select="@pos"/>
<tr>
<xsl:apply-templates/>
<xsl:apply-templates select="../../backwards/row[@pos=$pos]/p"/>
</tr>
</xsl:template>

<xsl:template match="p[ancestor::forward and not(following-sibling::*)]">
<td class="last">
<xsl:apply-templates/>
</td>
</xsl:template>

<xsl:template match="p">
<td>
<xsl:apply-templates/>
</td>
</xsl:template>

</xsl:stylesheet>
