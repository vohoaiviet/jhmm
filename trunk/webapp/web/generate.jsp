<%@page contentType="text/html" import="java.io.*,org.w3c.dom.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*"%>
<%@page pageEncoding="UTF-8"%>
<%!
   static class XMLFilter implements FilenameFilter {
      public boolean accept(File dir, String name) {
         return name.endsWith(".xml");
      }
   }
   
   Transformer model2xhtml;
   File transformFile;
   long timestamp;
   
   public void jspInit() {
      model2xhtml = null;
      ServletConfig config = getServletConfig();
      transformFile = new File(config.getServletContext().getRealPath("generate2xhtml.xsl"));
      checkTransformer();
   }
   
   
   public void checkTransformer() {
      if (model2xhtml!=null && transformFile.lastModified()>timestamp) {
         model2xhtml = null;
      }
      if (model2xhtml==null) {
         ServletConfig config = getServletConfig();
         try {
            timestamp = transformFile.lastModified();

            TransformerFactory tfactory = TransformerFactory.newInstance();
            model2xhtml = tfactory.newTransformer(new StreamSource(transformFile));
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
   if (model2xhtml!=null) {
      ServletContext context = getServletContext();
      
      // Get models
      String path = context.getInitParameter("model-repository");
      File repository = new File(context.getRealPath(path));
      if (!repository.exists()) {
         throw new ServletException("Repository "+repository.getAbsolutePath()+" does not exist.");
      }
      File [] models = repository.listFiles(new XMLFilter());
      
      // Get other parameters
      String form = request.getParameter("form");
      String model = request.getParameter("model");
      String size = request.getParameter("size");
      String number = request.getParameter("number");
      String display = request.getParameter("display");
      
      StringBuffer sb = new StringBuffer();
      sb.append("<form first='"+(form==null ? "yes" : "no")+"'>");
      sb.append("<models>");
      DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
      docBuilderFactory.setNamespaceAware(true);
      DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
      for (int i=0; i<models.length; i++) {
         try {
            Document doc = docBuilder.parse(models[i]);      
            String name = doc.getDocumentElement().getAttribute("name");
            String href = models[i].getName();
            sb.append("<model href='");
            sb.append(href);
            sb.append("' selected='");
            sb.append(form==null ? (i==0 ? "yes" : "no") : (model.equals(href) ? "yes" : "no"));
            sb.append("'>");
            sb.append(name);
            sb.append("</model>");
         } catch (Exception ex) {
            context.log("Bad model "+models[i],ex);
         }
      }
      sb.append("</models>");
      sb.append("<size>");
      sb.append(valueOf(size));
      sb.append("</size>");
      sb.append("<number>");
      sb.append(valueOf(number));
      sb.append("</number>");
      sb.append("<display>");
      sb.append(valueOf(display));
      sb.append("</display>");
      sb.append("</form>");

      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(sb.toString()));
      model2xhtml.transform(in,sout);
      
   } else {
      out.println("<p>Stylesheet not loaded during initialization.</p>");
   }
 %>