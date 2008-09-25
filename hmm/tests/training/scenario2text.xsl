<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : scenario2text.xsl
    Created on : October 29, 2004, 12:40 PM
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
<saxon:output href="final.{@name}">
<xsl:text>
</xsl:text>
<xsl:apply-templates select="transitions|emissions"/>
</saxon:output>
<saxon:output href="loglikelihood.{@name}">
<xsl:apply-templates select="steps" mode="loglikelihood"/>
</saxon:output>
<saxon:output href="transitions.{@name}">
<xsl:apply-templates select="steps/step/transitions"/>
</saxon:output>
<saxon:output href="emissions.{@name}">
<xsl:apply-templates select="steps/step/emissions"/>
</saxon:output>
</xsl:template>

<xsl:template match="transitions|emissions">
<xsl:apply-templates select="*"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="steps" mode="loglikelihood">
<xsl:value-of select="@log-likelihood"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="step" mode="loglikelihood"/>
</xsl:template>

<xsl:template match="step" mode="loglikelihood">
<xsl:value-of select="@log-likelihood"/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="steps">
<xsl:text># Steps
</xsl:text>
<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="step">
<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="training-scenario/transitions">
<xsl:text># S 
</xsl:text>
<xsl:apply-templates select="*"/>
<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="training-scenario/emissions">
<xsl:text># T 
</xsl:text>
<xsl:apply-templates select="*"/>
<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="row">
<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="e">
<xsl:apply-templates/>
<xsl:text> </xsl:text>
</xsl:template>

</xsl:stylesheet>
