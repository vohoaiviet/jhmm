<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : scenario2xy.xsl
    Created on : November 1, 2004, 2:47 PM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">

<xsl:output method="text"/>

<xsl:template match="training-scenarios">
<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="training-scenario">
<saxon:output href="xy.{@name}">
<xsl:apply-templates select="steps/step/transitions"/>
</saxon:output>
</xsl:template>

<xsl:template match="transitions">
<xsl:value-of select="row[2]/e[2]"/>
<xsl:text> </xsl:text>
<xsl:value-of select="row[3]/e[3]"/>
<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
