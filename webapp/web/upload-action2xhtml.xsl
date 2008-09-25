<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="master.xsl"/>

<xsl:template match="ok">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Upload Complete</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Model Uploaded</p>
<p>Your model has been added to the system.  You should now see it amongst all the other models.</p>
</body>
</html>
</xsl:template>

<xsl:template match="error">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Upload Error</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Upload Error</p>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="msg">
<p><xsl:apply-templates/></p>
</xsl:template>

</xsl:stylesheet>
