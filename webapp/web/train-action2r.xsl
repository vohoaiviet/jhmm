<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : forwards-action2xhtml.xsl
    Created on : October 23, 2004, 12:27 PM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="text"/>

<xsl:template match="error">
Errors in Training
</xsl:template>

<xsl:template match="data">
<xsl:apply-templates select="trans"/>
<xsl:apply-templates select="emit"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="steps"/>
</xsl:template>

<xsl:template match="steps">
<xsl:apply-templates select="loglikelihood"/><xsl:text>

</xsl:text>
<xsl:apply-templates select="trans"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="emit"/>
</xsl:template>

<xsl:template match="loglikelihood">
<xsl:apply-templates/>
<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="trans">
<xsl:apply-templates select="*"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="emit">
<xsl:apply-templates select="*"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="row">
<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="e"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:template>

</xsl:stylesheet>
