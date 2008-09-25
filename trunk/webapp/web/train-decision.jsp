<%@page import="com.oreilly.servlet.*"%>
<%!
   boolean notSpecified(String value) {
      return value==null || value.length()==0;
   }
   boolean specified(String value) {
      return !notSpecified(value);
   }
%>
<%

   ServletContext context = getServletContext();
   String path = context.getInitParameter("model-repository");
   String repository = context.getRealPath(path);
   MultipartRequest mrequest = new MultipartRequest(request,repository);
   
   boolean badData = false;
   String dataStr = request.getParameter("data");
   String datafileStr = request.getParameter("datafile");
   if (notSpecified(dataStr) && notSpecified(datafileStr)) {
      badData = true;
   }
   if (specified(dataStr) && specified(datafileStr)) {
      badData = true;
   }
   String limitStr = request.getParameter("limit");
   if (notSpecified(limitStr)) {
      badData = true;
   }   
   
   if (badData) {
      %><jsp:forward page="train.jsp?form=yes"/><%
   }
   
   %><jsp:forward page="/train-action.jsp"/><%
   
%>
