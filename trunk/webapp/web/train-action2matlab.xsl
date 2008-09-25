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
S=<xsl:apply-templates select="trans"/>
<xsl:text>
</xsl:text>
T=<xsl:apply-templates select="emit"/>
<xsl:text>
</xsl:text>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="steps"/>
</xsl:template>

<xsl:template match="steps">
<xsl:text>L=[ </xsl:text><xsl:apply-templates select="loglikelihood"/><xsl:text>]

</xsl:text>
<xsl:apply-templates select="trans|emit" mode="steps"/>
</xsl:template>

<xsl:template match="loglikelihood">
<xsl:apply-templates/>
<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="trans">
<xsl:text>[ </xsl:text>
<xsl:apply-templates select="*"/>
<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="emit">
<xsl:text>[ </xsl:text>
<xsl:apply-templates select="*"/>
<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="trans" mode="steps">
<xsl:text>S</xsl:text><xsl:value-of select="@step"/><xsl:text> = [ </xsl:text>
<xsl:apply-templates select="*"/>
<xsl:text>]
</xsl:text>
</xsl:template>

<xsl:template match="emit" mode="steps">
<xsl:text>T</xsl:text><xsl:value-of select="@step"/><xsl:text> = [ </xsl:text>
<xsl:apply-templates select="*"/>
<xsl:text>]
</xsl:text>
</xsl:template>

<xsl:template match="row">
<xsl:apply-templates select="*"/>
<xsl:if test="following-sibling::row">
<xsl:text>;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="e"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:template>

</xsl:stylesheet>
