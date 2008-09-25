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
<head><title>JHMM Demonstration - Training Results</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Errors in Training</p>
<p><xsl:apply-templates/></p>
</body>
</html>
</xsl:template>

<xsl:template match="data">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Training Results</title>
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
<p class="title">Training Results</p>
<p class="subtitle">Probabilities</p>
<div class="probabilities">
<xsl:apply-templates select="trans|emit"/>
</div>
<p class="subtitle">Trace</p>
<div class="trace">
<xsl:apply-templates select="steps"/>
</div>
</body>
</html>
</xsl:template>

<xsl:template match="steps">
<p>Steps: <xsl:value-of select="@count"/></p>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="loglikelihood">
<xsl:if test="not(preceding-sibling::loglikelihood)">
<p>Loglikelihood</p>
</xsl:if>
<p><xsl:value-of select="@step"/> : <xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="trans">
<pre>
<xsl:apply-templates select="*"/>
</pre>
</xsl:template>

<xsl:template match="emit">
<pre>
<xsl:apply-templates select="*"/>
</pre>
</xsl:template>

<xsl:template match="trans/row[not(preceding-sibling::*)]">
<xsl:text>S</xsl:text><xsl:value-of select="../@step"/><xsl:text> =</xsl:text>
<xsl:apply-templates select="*"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="emit/row[not(preceding-sibling::*)]">
<xsl:text>T</xsl:text><xsl:value-of select="../@step"/><xsl:text> =</xsl:text>
<xsl:apply-templates select="*"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="row">
<xsl:text>   </xsl:text>
<xsl:choose>
<xsl:when test="../@step &lt; 10">
<xsl:text> </xsl:text>
</xsl:when>
<xsl:when test="../@step &lt; 100">
<xsl:text>  </xsl:text>
</xsl:when>
<xsl:when test="../@step &lt; 1000">
<xsl:text>   </xsl:text>
</xsl:when>
</xsl:choose>
<xsl:apply-templates select="*"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="e"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:template>

</xsl:stylesheet>
