<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : master.xsl
    Created on : October 23, 2004, 11:36 AM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<xsl:template name="style">
<style type="text/css">
div.options { display: table; }
div.option { display: table-row;}
div.label { display: table-cell; 
   padding-right: 10pt;
}
div > p {
   padding: 2pt; margin: 0pt; margin-bottom: 2pt;
}
div.field { display: table-cell;  padding: 0pt; margin:0pt;}
p.title { font-size: 18pt; font-weight: bold; color: gray; }
p.subtitle { font-size: 14pt; font-weight: bold; color: gray; }
p.error { color: red; }
a.nav { text-decoration: none; display: inline-block; padding: 2pt; margin: 1pt; border: 1pt solid gray; color: gray; font-weight: bold;}
a:link { text-decoration: none; }
</style>
</xsl:template>

<xsl:template name="navigation">
<p><a class="nav" href="models.jsp">Models</a> <a class="nav" href="generate.jsp">Generate Data</a> <a class="nav" href="train.jsp">Train</a> <a class="nav" href="forwards.jsp">Forwards/Backwards</a> <a class="nav" href="predict.jsp">Predict</a> <a class="nav" href="upload.jsp">Upload Model</a></p>
 
</xsl:template>

<xsl:template match="models">
<select name="model">
<xsl:apply-templates/>
</select>
</xsl:template>

<xsl:template match="model">
<option value="{@href}" selected='yes'>
<xsl:if test="@selected='yes'">
<xsl:attribute name="selected">yes</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
</option>
</xsl:template>

</xsl:stylesheet>
