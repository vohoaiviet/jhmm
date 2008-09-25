<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : models2xhtml.xsl
    Created on : October 23, 2004, 9:09 AM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hmm="urn:publicid:IDN+milowski.com:schemas:math:hmm:2004:us"
xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://www.w3.org/1999/xhtml">

<xsl:import href="master.xsl"/>

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:template match="models">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Generate Data</title>
<xsl:call-template name="style"/>
<style type="text/css">
td { vertical-align: top;  padding: 5pt;  }
td.name { width: 30%; border-right: 1pt solid black;}
td { border-top: 1pt solid black; }
</style>
</head>
<body>
<xsl:call-template name="navigation"/>
<table>
<xsl:apply-templates/>
</table>
</body>
</html>
</xsl:template>

<xsl:template match="model">
<xsl:apply-templates select="document(@href)/hmm:hmm">
<xsl:with-param name="href" select="@rel"/>
</xsl:apply-templates>
</xsl:template>

<xsl:template match="hmm:hmm">
<xsl:param name="href"/>
<tr>
<td class="name"><p><xsl:apply-templates select="@name" mode="value"/></p></td>
<td>
<xsl:apply-templates select="hmm:description"/>
<p><a href="{$href}">XML Source</a></p>
</td>
</tr>
</xsl:template>

<xsl:template match="hmm:description|h:body">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

</xsl:stylesheet>
