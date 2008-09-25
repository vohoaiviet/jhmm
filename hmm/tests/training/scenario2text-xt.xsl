<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xt="http://www.jclark.com/xt" extension-element-prefixes="xt">
    <xsl:output method="text"/>

<xsl:import href="scenario2text.xsl"/>

<xsl:template match="training-scenarios">
<xsl:apply-templates select="*"/>
<finished/>
</xsl:template>

<xsl:template match="training-scenario">
<output name="{@name}"/>
<xt:document href="final.{@name}">
<xsl:text>
</xsl:text>
<xsl:apply-templates select="transitions|emissions"/>
</xt:document>
<xt:document href="loglikelihood.{@name}">
<xsl:apply-templates select="steps" mode="loglikelihood"/>
</xt:document>
<xt:document href="transitions.{@name}">
<xsl:apply-templates select="steps/step/transitions"/>
</xt:document>
<xt:document href="emissions.{@name}">
<xsl:apply-templates select="steps/step/emissions"/>
</xt:document>
</xsl:template>

</xsl:stylesheet>
