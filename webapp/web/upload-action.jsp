<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%>
<%!
   static class XMLFilter implements FilenameFilter {
      public boolean accept(File dir, String name) {
         return name.endsWith(".xml");
      }
   }
   
   Transformer output2xhtml;
   File transformFile;
   long timestamp;
   
   public void jspInit() {
      output2xhtml = null;
      ServletConfig config = getServletConfig();
      transformFile = new File(config.getServletContext().getRealPath("upload-action2xhtml.xsl"));
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
%><%

ServletContext context = getServletContext();
String path = context.getInitParameter("model-repository");
String repository = context.getRealPath(path);

MultipartRequest mrequest = new MultipartRequest(request,repository);

File modelFile = mrequest.getFile("model");

if (modelFile!=null) {

   DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
   docBuilderFactory.setNamespaceAware(true);
   DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
   try {
      Document doc = docBuilder.parse(modelFile);     
      SAXParserFactory saxFactory = SAXParserFactory.newInstance();
      saxFactory.setNamespaceAware(true);
      SAXParser saxParser = saxFactory.newSAXParser();
      XMLReader xmlReader = saxParser.getXMLReader();

      XMLModelReader modelReader = new XMLModelReader(xmlReader);
      FileReader modelInput = new FileReader(modelFile);
      InputSource source = new InputSource(modelInput);

      Model model = modelReader.load(source);

      modelInput.close();

      model.check();
      
      StringBuffer sb = new StringBuffer();
      sb.append("<ok/>");
      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(sb.toString()));
      output2xhtml.transform(in,sout);
      
   } catch (Exception ex) {
      StringBuffer sb = new StringBuffer();
      sb.append("<error>");
      sb.append("<msg>Model file is not well-formed.  Model was not added.</msg>");
      sb.append("<msg>"+ex.getMessage()+"</msg>");
      sb.append("</error>");
      
      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(sb.toString()));
      output2xhtml.transform(in,sout);
      
      modelFile.delete();
   }
} else {
      StringBuffer sb = new StringBuffer();
      sb.append("<error>");
      sb.append("<msg>No model file was specified.</msg>");
      sb.append("</error>");
      
      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(sb.toString()));
      output2xhtml.transform(in,sout);
}
%>