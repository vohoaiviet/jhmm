<%@page contentType="text/html" import="java.io.*,org.w3c.dom.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*,com.oreilly.servlet.*"%>
<%@page pageEncoding="UTF-8"%>
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
      transformFile = new File(config.getServletContext().getRealPath("train2xhtml.xsl"));
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
      ServletContext context = getServletContext();
      String path = context.getInitParameter("model-repository");
      File repository = new File(context.getRealPath(path));

      String form = null;
      String model = null;
      String data = null;
      String datafile = null;
      String limit = null;
      String random = null;
      String initial = null;
      String trans = null;
      String emit = null;
      String output = null;
      
      // Get models
      File [] models = repository.listFiles(new XMLFilter());
      
/*
      String enc = request.getHeader("content-type");
      if (enc!=null) {
         MultipartRequest mrequest = new MultipartRequest(request,repository.getAbsolutePath());

         // Get other parameters
         form = mrequest.getParameter("form");
         model = mrequest.getParameter("model");
         data = mrequest.getParameter("data");
         datafile = mrequest.getOriginalFileName("datafile");
         limit = mrequest.getParameter("limit");
         random = mrequest.getParameter("random");
         initial = mrequest.getParameter("initial");
         trans = mrequest.getParameter("trans");
         emit = mrequest.getParameter("emit");

      } else {
 */
         // Get other parameters
         form = request.getParameter("form");
         model = request.getParameter("model");
         data = request.getParameter("data");
         datafile =request.getParameter("datafile");
         limit = request.getParameter("limit");
         random = request.getParameter("random");
         initial = request.getParameter("initial");
         trans = request.getParameter("trans");
         emit = request.getParameter("emit");
         output = request.getParameter("output");
         /*
      }*/
      
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
            sb.append(form==null ? (i==0 ? "yes" : "no") : (model!=null && model.equals(href) ? "yes" : "no"));
            sb.append("'>");
            sb.append(name);
            sb.append("</model>");
         } catch (Exception ex) {
            context.log("Bad model "+models[i],ex);
         }
      }
      sb.append("</models>");
      sb.append("<data>");
      sb.append(valueOf(data));
      sb.append("</data>");
      sb.append("<datafile>");
      sb.append(valueOf(datafile));
      sb.append("</datafile>");
      sb.append("<limit>");
      sb.append(valueOf(limit));
      sb.append("</limit>");
      sb.append("<options>");
      sb.append("<random>");
      sb.append(valueOf(random));
      sb.append("</random>");
      sb.append("<initial>");
      sb.append(valueOf(initial));
      sb.append("</initial>");
      sb.append("<trans>");
      sb.append(valueOf(trans));
      sb.append("</trans>");
      sb.append("<emit>");
      sb.append(valueOf(emit));
      sb.append("</emit>");
      sb.append("</options>");
      sb.append("<output>");
      sb.append(valueOf(output));
      sb.append("</output>");
      sb.append("</form>");

      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(sb.toString()));
      output2xhtml.transform(in,sout);
      
   } else {
      out.println("<p>Stylesheet not loaded during initialization.</p>");
   }
 %>