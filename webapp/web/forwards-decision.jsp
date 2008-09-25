<%

   String dataStr = request.getParameter("data");
   if (dataStr==null || dataStr.length()==0) {
      %><jsp:forward page="/forwards.jsp"/><%
   }
   
   %><jsp:forward page="/forwards-action.jsp"/><%
   
%>
