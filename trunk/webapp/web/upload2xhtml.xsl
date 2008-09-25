<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="master.xsl"/>

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JHMM Demonstration - Upload Model</title>
<xsl:call-template name="style"/>
</head>
<body>
<xsl:call-template name="navigation"/>
<p class="title">Upload a Model</p>
<form enctype="multipart/form-data" action="upload-action.jsp" method="POST">
<ol>
<li>
<p>Select your model from a file on your system:</p>
<p> Model <input name="model" type="file"/></p>
<p>Note: Your model has a name internal to its structure.  This name will be used on the website.</p>
</li>
<li>
<p>Make it go! <input value="Upload" type="submit"/></p>
</li>
</ol>
</form>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
