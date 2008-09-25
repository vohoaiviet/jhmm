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

<xsl:template match="prediction">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - State Prediction</title>
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
<p>Probability: <xsl:value-of select="@score"/></p>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="state-names"></xsl:template>

<xsl:template match="states">
<table>
<xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="s">
<xsl:variable name="state" select="."/>
<tr><td><xsl:value-of select="@ch"/></td><td><xsl:value-of select="$state"/></td><td><xsl:apply-templates select="/prediction/state-names/state[@id=$state]"/></td></tr>
</xsl:template>

<xsl:template match="state">
<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
