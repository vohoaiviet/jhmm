<%@page pageEncoding="UTF-8" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%>
<%!
   static class XMLFilter implements FilenameFilter {
      public boolean accept(File dir, String name) {
         return name.endsWith(".xml");
      }
   }
   
   Map transformers;
   Map transformerFiles;
   Map timestamps;
   Map contentTypes;
   
   static String [] keys = { "browser","matlab","r" };
   static String [] xslt = { "train-action2xhtml.xsl", "train-action2matlab.xsl", "train-action2r.xsl" };
   static String [] ctypes = { "text/html", "text/plain", "text/plain" };
   
   public void jspInit() {
      ServletConfig config = getServletConfig();
      transformerFiles = new HashMap();
      timestamps = new HashMap();
      transformers = new HashMap();
      contentTypes = new HashMap();
      for (int i=0; i<keys.length; i++) {
         File f = new File(config.getServletContext().getRealPath(xslt[i]));
         transformerFiles.put(keys[i],f);
         contentTypes.put(keys[i],ctypes[i]);
      }
      checkTransformer(null);
   }
   
   void loadTransformer(String key,File f) {
      try {
         Long timestamp = new Long(f.lastModified());

         TransformerFactory tfactory = TransformerFactory.newInstance();
         Transformer t = tfactory.newTransformer(new StreamSource(f));
         transformers.put(key,t);
         timestamps.put(key,timestamp);
      } catch (Exception ex) {
         ServletConfig config = getServletConfig();
         config.getServletContext().log("Cannot load stylesheet "+f.getName(),ex);
      }
   }
   
   
   public void checkTransformer(String key,File f) {
      Transformer t = (Transformer)transformers.get(key);
      Long timestamp = (Long)timestamps.get(key);
      if (t!=null && f.lastModified()>timestamp.longValue()) {
         t = null;
      }
      if (t==null) {
         loadTransformer(key,f);
      }
   }
   
   public void checkTransformer(String type) {
      if (type==null) {
         for (int i=0; i<keys.length; i++) {
            File f = (File)transformerFiles.get(keys[i]);
            checkTransformer(keys[i],f);
         }
      } else {
         File f = (File)transformerFiles.get(type);
         checkTransformer(type,f);
      }
            
   }
   
   public boolean isTransformerLoaded(String key) {
      return transformers.get(key)!=null;
   }
   
   public String valueOf(String value) {
      return value==null ? "" : value;
   }
%><%

   ServletContext context = getServletContext();
   String path = context.getInitParameter("model-repository");
   String repository = context.getRealPath(path);
   String dpath = context.getInitParameter("data-repository");
   String dataPath = context.getRealPath(dpath);

   MultipartRequest mrequest = new MultipartRequest(request,dataPath);

   File modelPath = new File(repository,mrequest.getParameter("model"));
   
   File datafilePath = mrequest.getFile("datafile");
   String data = mrequest.getParameter("data");
   if ((data==null || data.length()==0) && datafilePath==null) {
      %><jsp:forward page="train.jsp?form=yes"/><%
      return;
   }
   boolean initial = mrequest.getParameter("initial").equals("yes");
   boolean transitions = mrequest.getParameter("trans").equals("yes");
   boolean emissions = mrequest.getParameter("emit").equals("yes");
   boolean random = mrequest.getParameter("random").equals("yes");
   double trainingLimit = Double.parseDouble(mrequest.getParameter("limit"));
   String output = mrequest.getParameter("output");
      
   checkTransformer(output);
   
   if (!isTransformerLoaded(output)) {
      %><p>Cannot load stylesheets.</p><%
      return;
   }
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

      if (random) {
        model.randomize(false,transitions,emissions);
      }
            
      model.check();

      Model.Translator translator = model.getTranslator();
      List sequences;
      try {
         if (datafilePath!=null) {
            sequences = Train.loadSequenceCounts(new FileReader(datafilePath),translator);
         } else {
            sequences = Train.loadSequenceCounts(new StringReader(data),translator);
         }
      } catch (IOException ex) {
         StringBuffer sb = new StringBuffer();
         sb.append("<error>");
         sb.append("Cannot load sequence due to I/O error: ");
         sb.append(ex.getMessage());
         sb.append("</error>");
         
         Transformer output2xhtml = (Transformer)transformers.get("browser");
         StreamResult sout = new StreamResult(out);
         StreamSource in = new StreamSource(new StringReader(sb.toString()));
         output2xhtml.transform(in,sout);
         return;
      }
            
      Engine hmmEngine = new Engine();
      hmmEngine.loadModel(model);
      hmmEngine.setTraining(initial,transitions,emissions);
      TrainingPathRecorder recorder = new TrainingPathRecorder();
      hmmEngine.setTrainingTracer(recorder);
      try {
         hmmEngine.train(sequences,trainingLimit,null);
      } catch(RuntimeException ex) {
         StringBuffer sb = new StringBuffer();
         sb.append("<error>");
         sb.append(ex.getMessage());
         sb.append("</error>");
         Transformer output2xhtml = (Transformer)transformers.get("browser");
         StreamResult sout = new StreamResult(out);
         StreamSource in = new StreamSource(new StringReader(sb.toString()));
         output2xhtml.transform(in,sout);
         return;
      }

      hmmEngine.updateModel(model);

      double s[][] = model.getStateTransitions();
      double t[][] = model.getStateEmissions();
      
      NumberFormat formatter = NumberFormat.getInstance();
      formatter.setMaximumFractionDigits(2);
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

      dataOut.append("<trans>\n");
      for (int row=0; row<s.length; row++) {
         dataOut.append("<row from='");
         dataOut.append(Integer.toString(row));
         dataOut.append("'>\n");
         for (int col=0; col<s[row].length; col++) {
            dataOut.append("<e to='");
            dataOut.append(Integer.toString(col));
            dataOut.append("'>");
            dataOut.append(formatter.format(s[row][col]));
            dataOut.append("</e>");
         }
         dataOut.append("</row>\n");
      }
      dataOut.append("</trans>\n");

      dataOut.append("<emit>\n");
      for (int row=0; row<t.length; row++) {
         dataOut.append("<row from='");
         dataOut.append(Integer.toString(row));
         dataOut.append("'>\n");
         for (int col=0; col<t[row].length; col++) {
            dataOut.append("<e to='");
            dataOut.append(Integer.toString(col));
            dataOut.append("'>");
            dataOut.append(formatter.format(t[row][col]));
            dataOut.append("</e>");
         }
         dataOut.append("</row>\n");
      }
      dataOut.append("</emit>\n");
      
      int steps = recorder.getSteps();
      dataOut.append("<steps role='transitions' count='");
      dataOut.append(Integer.toString(steps));
      dataOut.append("'>\n");
      int lcount = recorder.getLogLikelihoodCount();
      for (int i=0; i<lcount; i++) {
         double logLikelihood = recorder.getLogLikelihood(i);
         if (logLikelihood!=Double.NEGATIVE_INFINITY) {
            dataOut.append("<loglikelihood step='");
            dataOut.append(Integer.toString(i+1));
            dataOut.append("'>");
            dataOut.append(Double.toString(logLikelihood));
            dataOut.append("</loglikelihood>\n");
         }
      }

      List [][] p = recorder.getTransitionSteps();
      for (int step=0; step<steps; step++) {
         dataOut.append("<trans step='");
         dataOut.append(Integer.toString(step+1));
         dataOut.append("'>\n");
         for (int from=0; from<p.length; from++) {
            dataOut.append("<row from='");
            dataOut.append(Integer.toString(from));
            dataOut.append("'>\n");
            for (int to=0; to<p[from].length; to++) {
               dataOut.append("<e to='");
               dataOut.append(Integer.toString(to));
               dataOut.append("'>");
               dataOut.append(formatter.format(Math.exp(((Double)p[from][to].get(step)).doubleValue())));
               dataOut.append("</e>");
            }
            dataOut.append("</row>\n");
         }
         dataOut.append("</trans>\n");
      }
      List [][] emit = recorder.getEmissionSteps();
      for (int step=0; step<steps; step++) {
         dataOut.append("<emit step='");
         dataOut.append(Integer.toString(step+1));
         dataOut.append("'>\n");
         for (int from=0; from<emit.length; from++) {
            dataOut.append("<row from='");
            dataOut.append(Integer.toString(from));
            dataOut.append("'>\n");
            for (int to=0; to<emit[from].length; to++) {
               dataOut.append("<e to='");
               dataOut.append(Integer.toString(to));
               dataOut.append("'>");
               dataOut.append(formatter.format(Math.exp(((Double)emit[from][to].get(step)).doubleValue())));
               dataOut.append("</e>");
            }
            dataOut.append("</row>\n");
         }
         dataOut.append("</emit>\n");
      }
      
      dataOut.append("</steps>\n");
      
      dataOut.append("</data>\n");

      Transformer xform2output = (Transformer)transformers.get(output);
      response.setContentType((String)contentTypes.get(output));
      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(dataOut.toString()));
      xform2output.transform(in,sout);
      
   } catch (java.io.IOException ex) {
      context.log("I/O exception during processing.",ex);
      %><p>I/O error during processing.</p><%
   } catch (org.xml.sax.SAXException ex) {
      context.log("XML Parse exception during processing.",ex);
      %><p>XML parse error during processing.</p><%
   } catch (javax.xml.parsers.ParserConfigurationException ex) {
      context.log("XML configuration error.",ex);
      %><p>Parser configuration error during processing.</p><%
   }
   
%>