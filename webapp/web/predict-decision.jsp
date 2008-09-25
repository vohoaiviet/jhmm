<%

   String dataStr = request.getParameter("data");
   if (dataStr==null || dataStr.length()==0) {
      %><jsp:forward page="/predict.jsp"/><%
   }
   
   %><jsp:forward page="/predict-action.jsp"/><%
   
%>
