<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : generate-action2xhtml.xsl
    Created on : October 23, 2004, 3:19 PM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="master.xsl"/>

<xsl:template match="data">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Generated Observation Data</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Generated Observation Data</p>
<pre>
<xsl:apply-templates/>
</pre>
</body>
</html>
</xsl:template>

<xsl:template match="sequence">
<xsl:apply-templates/><xsl:text>,</xsl:text><xsl:value-of select="@count"/><xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
