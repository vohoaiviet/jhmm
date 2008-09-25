<%@page contentType="text/html" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%>
<%!
   Transformer output2xhtml;
   File transformFile;
   long timestamp;
   
   public void jspInit() {
      output2xhtml = null;
      ServletConfig config = getServletConfig();
      transformFile = new File(config.getServletContext().getRealPath("predict-action2xhtml.xsl"));
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
   
%>
<%
   checkTransformer();
   if (output2xhtml==null) {
      %><p>Cannot load stylesheet.</p><%
      return;
   }
   
   ServletContext context = getServletContext();
   String path = context.getInitParameter("model-repository");
   File repository = new File(context.getRealPath(path));
      
   String dataStr = request.getParameter("data");
   File modelPath = new File(repository,request.getParameter("model"));
      
   try {
      SAXParserFactory saxFactory = SAXParserFactory.newInstance();
      saxFactory.setNamespaceAware(true);
      SAXParser saxParser = saxFactory.newSAXParser();
      XMLReader xmlReader = saxParser.getXMLReader();

      XMLModelReader modelReader = new XMLModelReader(xmlReader);
      FileReader modelInput = new FileReader(modelPath);
      InputSource source = new InputSource(modelInput);

      Model model = modelReader.load(source);

      modelInput.close();

      model.check();

      Model.Translator translator = model.getTranslator();
      short [] sequence;
      try {
         sequence = Forward.load(new StringReader(dataStr),translator);
      } catch (IOException ex) {
         StringBuffer sb = new StringBuffer();
         sb.append("<error>");
         sb.append("Cannot load sequence due to I/O error: ");
         sb.append(ex.getMessage());
         sb.append("</error>");
         
         StreamResult sout = new StreamResult(out);
         StreamSource in = new StreamSource(new StringReader(sb.toString()));
         output2xhtml.transform(in,sout);
         return;

      }

      Engine hmmEngine = new Engine();
      hmmEngine.loadModel(model);
      Engine.Prediction prediction = hmmEngine.mostLikely(sequence);

      StringBuffer dataOut = new StringBuffer();
      
      dataOut.append("<prediction score='"+prediction.getScore()+"'>\n");
      
      dataOut.append("<state-names>");
      for (int i=1; i<model.getNumberOfStates(); i++) {
         dataOut.append("<state id='");
         dataOut.append(i);
         dataOut.append("'>");
         dataOut.append(model.getStateName(i));
         dataOut.append("</state>\n");
      }
      dataOut.append("</state-names>");
      
      dataOut.append("<states>");
      short [] states = prediction.getResult();
      for (int state=0; state<states.length; state++) {
         dataOut.append("<s ch='");
         dataOut.append(dataStr.charAt(state));
         dataOut.append("'>");
         dataOut.append(states[state]);
         dataOut.append("</s>");
      }
      dataOut.append("</states>\n");

      dataOut.append("</prediction>\n");
           
      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(dataOut.toString()));
      output2xhtml.transform(in,sout);
      
   } catch (java.io.IOException ex) {
      context.log("I/O exception during processing.",ex);
   } catch (org.xml.sax.SAXException ex) {
      context.log("XML Parse exception during processing.",ex);
   } catch (javax.xml.parsers.ParserConfigurationException ex) {
      context.log("XML configuration error.",ex);
   }
%>