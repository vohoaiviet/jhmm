<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : forwards2xhtml.xsl
    Created on : October 23, 2004, 11:41 AM
    Author     : alex
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="master.xsl"/>

<xsl:template match="form">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Forwards/Backwards Trace</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Calculate the Forwards/Backwards values for a Sequence</p>
<form method="POST" action="forwards-decision.jsp">
<input type="hidden" name="form" value="yes"/>
<ol>
<li>
<p>Select your model from the list below.</p>
<p> Model <xsl:apply-templates select="models"/></p>
</li>
<li>
<p>Enter a single sequence below.  If you wish to get observation data from a model, use <a href="generate.jsp">generate data</a> via this website and then cut-n-paste the data into this form.</p>
<p>Data:</p>
<textarea name="data" rows="2" cols="70"><xsl:text>
</xsl:text>
</textarea>
<xsl:if test="@first='no' and data=''">
<p class="error">You must specify a sequence to run the forwards/backwards algorithm upon.</p>
</xsl:if>
</li>
<li>
<p>Make it go!
<input type="submit" value="Calculate"/>
</p>
</li>
</ol>
</form>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
