<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%>
<%!
   static class XMLFilter implements FilenameFilter {
      public boolean accept(File dir, String name) {
         return name.endsWith(".xml");
      }
   }
%>
<%
   String selectedModel = request.getParameter("model");
   ServletContext context = getServletContext();
   String path = context.getInitParameter("model-repository");
   File repository = new File(context.getRealPath(path));
   File [] models = repository.listFiles(new XMLFilter());
   %><select name="model"><%
   DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
   docBuilderFactory.setNamespaceAware(true);
   DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
   for (int i=0; i<models.length; i++) {
      try {
         Document doc = docBuilder.parse(models[i]);      
         String name = doc.getDocumentElement().getAttribute("name");
         String modelName = models[i].getName();
         if (selectedModel!=null && selectedModel.equals(modelName)) {
            %><option value='<%=models[i].getName()%>' selected='yes'><%=name%></option><%       
         } else {
            %><option value='<%=models[i].getName()%>'><%=name%></option><%       
         }
      } catch (Exception ex) {
         context.log("Bad model "+models[i],ex);
      }
   }
   %></select><%
%>
<html>
<head><title>JSP Page</title></head>
<body>

<%-- <jsp:useBean id="beanInstanceName" scope="session" class="beanPackage.BeanClassName" /> --%>
<%-- <jsp:getProperty name="beanInstanceName"  property="propertyName" /> --%>

</body>
</html>
