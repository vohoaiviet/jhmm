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
<head><title>JHMM Demonstration - Train Model Parameters</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Train Model Parameters</p>
<form method="POST" action="train-action.jsp" enctype="multipart/form-data" >
<input type="hidden" name="form" value="true"/>
<p>This form lets you train model parameters.  You need to decide the following:</p>
<ol>
<li>
<p>Select the model you wish to train:</p>
<p><xsl:apply-templates select="models"/></p>
</li>
<li>
<p>Specify your observation data (i.e. sequences).  You may either specify sequences in this form or uploade a file.</p>
<p>Each sequence must be on its own line and it must be following by a comma a count of the number of observations.  For example:</p>
<pre>
1001,3
1101,1
</pre>
<p>This specifies the sequence '1001' was observed 3 times and '1101' was observed once.</p>
<p><xsl:apply-templates select="data"/></p>
<p><xsl:apply-templates select="datafile"/></p>
<xsl:if test="@first!='yes' and (data='' or datafile='')">
<p class="error">You must specify sequence data.</p>
</xsl:if>
<xsl:if test="data!='' and datafile!=''">
<p class="error">You cannot specify sequence data and a sequence data file.</p>
</xsl:if>
</li>

<li>
<p>Specify you training options.</p>
<xsl:apply-templates select="limit|options"/>
</li>

<li>
<xsl:apply-templates select="output"/>
</li> 
<li>
<p>Make it go! <input type="submit" value="Train"/> </p>
</li>
</ol>
</form>
</body>
</html>
</xsl:template>

<xsl:template match="data">
<p>Observation Data:</p>
<textarea name="data" rows="20" cols="70"><xsl:text>
</xsl:text>
<xsl:apply-templates/>
</textarea>
</xsl:template>

<xsl:template match="datafile">
<p>Data File 
<input type="file" name="datafile" value="{.}"/>
</p>
</xsl:template>

<xsl:template match="limit">
<p>The training limit effects how many iterations of training via the Baum-Welch algorithm. This controls how small the delta between the last log-likelihood and the current iteration's log-likelihood can get.  When the delta is small enough,
the training loop will stop.</p>
<p>Log-likelihood Training Limit:
<input type="text" name="limit" size="20">
<xsl:choose>
<xsl:when test=".!=''"><xsl:attribute name="value"><xsl:apply-templates/></xsl:attribute></xsl:when>
<xsl:when test="/form/@first='yes'"><xsl:attribute name="value">0.005</xsl:attribute></xsl:when>
</xsl:choose>
</input>

</p>
<xsl:if test="/form/@first!='yes' and .=''">
<p class="error">You must specify a training limit</p>
</xsl:if>
</xsl:template>

<xsl:template match="options">
<p>A random set of parameters can be choosen as a starting point. This controls whether the trained parameters will be randomly selected at training time. Otherwise, the default model parameters will be used.</p>
<xsl:apply-templates select="random"/>
<p>These options select what parameters will be trained. These also control which parameters will be randomly generated if you select a random starting point via the above.</p>
<table>
<xsl:apply-templates select="initial|trans|emit"/>
</table>
</xsl:template>

<xsl:template match="random">
<tr>
<td><p>Random Starting Parameters:</p></td>
<td>
<p>
<input name="random" type="radio" value="yes"> 
<xsl:if test=".='yes'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Yes
<input name="random" type="radio" value="no"> 
<xsl:if test=".='no' or .=''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> No
</p>
</td>
</tr>
</xsl:template>
    

<xsl:template match="initial">
<tr>
<td><p>Initial:</p></td>
<td>
<p>
<input name="initial" type="radio" value="yes">
<xsl:if test=".='yes'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Yes 
<input name="initial" type="radio" value="no"><xsl:if test=".='no' or .=''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> No 
</p>
</td>
</tr>
</xsl:template>
    
<xsl:template match="trans">
<tr>
<td><p>Transitions:</p></td>
<td>
<p>
<input name="trans" type="radio" value="yes"> 
<xsl:if test=".='yes' or .=''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Yes
<input name="trans" type="radio" value="no">
<xsl:if test=".='no'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> No 
</p>
</td>
</tr>
</xsl:template>
    
<xsl:template match="emit">
<tr>
<td><p>Emissions:</p></td>
<td>
<p>
<input name="emit" type="radio" value="yes">
<xsl:if test=".='yes'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Yes 
<input name="emit" type="radio" value="no">
<xsl:if test=".='no' or .=''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> No 
</p>
</td>
</tr>
</xsl:template>
    
<xsl:template match="output">
<p>You may have the output of training either formatting for the browser or formatted as matricies for matlab/maple/etc.  The non-browser
output will display as plain text and you need to have your browser save it to the local disk.</p>
<p>
<input name="output" type="radio" value="browser">
<xsl:if test=".='browser' or .=''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Browser
<input name="output" type="radio" value="matlab">
<xsl:if test=".='matlab'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> Matlab
<input name="output" type="radio" value="r">
<xsl:if test=".='r'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input> R
</p>
</xsl:template>

</xsl:stylesheet>
