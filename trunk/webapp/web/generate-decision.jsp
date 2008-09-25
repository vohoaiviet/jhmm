<%

   boolean badData = false;
   String sizeStr = request.getParameter("size");
   if (sizeStr==null || sizeStr.length()==0) {
      badData = true;
   }
   String numberStr = request.getParameter("number");
   if (numberStr==null || numberStr.length()==0) {
      badData = true;
   }   
   
   if (badData) {
      %><jsp:forward page="/generate.jsp"/><%
   }
   
   boolean display = request.getParameter("display").equals("yes");
   
   if (display) {
      %><jsp:forward page="/generate-action-display.jsp"/><%
   } else {
      %><jsp:forward page="/generate-action-download.jsp"/><%
   }
   
%>
