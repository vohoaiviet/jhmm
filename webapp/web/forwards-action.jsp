<%@page contentType="text/html" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%>
<%!
   Transformer output2xhtml;
   File transformFile;
   long timestamp;
   
   public void jspInit() {
      output2xhtml = null;
      ServletConfig config = getServletConfig();
      transformFile = new File(config.getServletContext().getRealPath("forwards-action2xhtml.xsl"));
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
      double f[][] = hmmEngine.forwards(sequence,null);
      double b[][] = hmmEngine.backwards(sequence,null);
      double s[][] = model.getStateTransitions();
      double e[][] = model.getStateEmissions();

      double p_f = 0;
      double p_b = 0;
      for (int state=0; state<s.length; state++) {
         p_f += Math.exp(f[state][sequence.length-1])*s[state][0];
         p_b += s[0][state]*e[state][sequence[0]]*Math.exp(b[state][0]);
      }
      
      NumberFormat formatter = NumberFormat.getInstance();
      formatter.setMaximumFractionDigits(10);
      formatter.setMinimumFractionDigits(2);

      StringBuffer dataOut = new StringBuffer();
      
      dataOut.append("<data>\n");
      dataOut.append("<states>\n");
      for (int state=0; state<s.length; state++) {
         dataOut.append("<state id='");
         dataOut.append(Integer.toString(state));
         dataOut.append("'>");
         dataOut.append(state==0 ? "initial" : model.getStateName(state));
         dataOut.append("</state>\n");
      }
      dataOut.append("</states>\n");

      dataOut.append("<forwards probability='");
      dataOut.append(Double.toString(p_f));
      dataOut.append("'>\n");
      for (int i=0; i<sequence.length; i++) {
         dataOut.append("<row pos='");
         dataOut.append(Integer.toString(i));
         dataOut.append("'>");
         for (int state=0; state<s.length; state++) {
            dataOut.append("<p id='");
            dataOut.append(Integer.toString(state));
            dataOut.append("'>");
            dataOut.append(formatter.format(Math.exp(f[state][i])));
            dataOut.append("</p>");
         }
         dataOut.append("</row>\n");
      }
      dataOut.append("</forwards>\n");
      dataOut.append("<backwards probability='");
      dataOut.append(Double.toString(p_b));
      dataOut.append("'>\n");
      for (int i=0; i<sequence.length; i++) {
         dataOut.append("<row pos='");
         dataOut.append(Integer.toString(i));
         dataOut.append("'>");
         for (int state=0; state<s.length; state++) {
            dataOut.append("<p id='");
            dataOut.append(Integer.toString(state));
            dataOut.append("'>");
            dataOut.append(formatter.format(Math.exp(b[state][i])));
            dataOut.append("</p>");
         }
         dataOut.append("</row>\n");
      }
      dataOut.append("</backwards>\n");
      dataOut.append("</data>\n");
           
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