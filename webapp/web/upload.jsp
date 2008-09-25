<%@page contentType="text/html" import="java.io.*,org.w3c.dom.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*"%>
<%@page pageEncoding="UTF-8"%>
<%!
  
   Transformer output2xhtml;
   File transformFile;
   long timestamp;
   
   public void jspInit() {
      output2xhtml = null;
      ServletConfig config = getServletConfig();
      transformFile = new File(config.getServletContext().getRealPath("upload2xhtml.xsl"));
      checkTransformer();
   }
   
   
   public void checkTransformer() {
      if (output2xhtml!=null && transformFile.lastModified()>timestamp) {
         output2xhtml = null;
      }
      if (output2xhtml==null) {
         ServletConfig config = getServletConfig();
         try {
            timestamp = transformFile.lastModified();

            TransformerFactory tfactory = TransformerFactory.newInstance();
            output2xhtml = tfactory.newTransformer(new StreamSource(transformFile));
         } catch (Exception ex) {
            config.getServletContext().log("Cannot load stylesheet.",ex);
         }
      }
   }
   
   public String valueOf(String value) {
      return value==null ? "" : value;
   }
%>
<%
   checkTransformer();
   if (output2xhtml!=null) {
      StringBuffer sb = new StringBuffer();
      sb.append("<form/>");
      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(sb.toString()));
      output2xhtml.transform(in,sout);
   } else {
      out.println("<p>Stylesheet not loaded during initialization.</p>");
   }
 %>