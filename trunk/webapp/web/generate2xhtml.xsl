<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : generate2xhtml.xsl
    Created on : October 23, 2004, 9:50 AM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="master.xsl"/>

<xsl:template match="form">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Generate Data</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Generate Observation Data</p>
<form method="POST" action="generate-decision.jsp">
<input type="hidden" name="form" value="true"/>
<p>This form lets you generate observation data from a model.  You need to decide the following:</p>
<ol>
<li>
<p>Select the model:</p>
<p><xsl:apply-templates select="models"/></p>
</li>
<li>
<p>Select the length and number of sequences:</p>
<p><xsl:apply-templates select="size"/><xsl:apply-templates select="number"/>
</p>
<xsl:if test="@first!='yes' and size=''">
<p class="error">The length of the sequence must be specified.</p>
</xsl:if>
<xsl:if test="@first!='yes' and number=''">
<p class="error">The number of sequences must be specified.</p>
</xsl:if>

</li>
<li>
<p>Select where the data will go: </p>
<p><xsl:apply-templates select="display"/></p>
</li>
 
<li>
<p>Generate the data by submitting this form: <input type="submit" value="Generate"/> </p>
</li>
</ol>
</form>
</body>
</html>
</xsl:template>

<xsl:template match="size">
Length 
<input type="text" name="size">
<xsl:choose>
<xsl:when test="/form/@first='yes'"><xsl:attribute name="value">3</xsl:attribute></xsl:when>
<xsl:otherwise><xsl:attribute name="value"><xsl:apply-templates/></xsl:attribute></xsl:otherwise>
</xsl:choose>
</input>
</xsl:template>

<xsl:template match="number">
Number 
<input type="text" name="number">
<xsl:choose>
<xsl:when test="/form/@first='yes'"><xsl:attribute name="value">500</xsl:attribute></xsl:when>
<xsl:otherwise><xsl:attribute name="value"><xsl:apply-templates/></xsl:attribute></xsl:otherwise>
</xsl:choose>
</input>
</xsl:template>

<xsl:template match="display">
<input name="display" type="radio" value="yes"> 
<xsl:if test=".='yes' or .=''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Display 
<input name="display" type="radio" value="no">
<xsl:if test=".='no'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Download
</xsl:template>
    
</xsl:stylesheet>
