<%@page contentType="text/html" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%>
<%@page pageEncoding="UTF-8" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,javax.xml.transform.*,javax.xml.transform.stream.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%>
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
      transformFile = new File(config.getServletContext().getRealPath("generate-action2xhtml.xsl"));
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
   
   if (output2xhtml==null) {
      %><p>Cannot load stylesheet.</p><%
      return;
   }
   ServletContext context = getServletContext();
   String path = context.getInitParameter("model-repository");
   File repository = new File(context.getRealPath(path));

   File modelPath = new File(repository,request.getParameter("model"));
   int length = Integer.parseInt(request.getParameter("size"));
   int count = Integer.parseInt(request.getParameter("number"));

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

      StringBuffer dataOut = new StringBuffer();
      dataOut.append("<data>\n");
      List lexicon = model.getLexicon();
      Generate.ListOfSequences uniqueSeqs = new Generate.ListOfSequences();
      for (int i=0; i<count; i++) {
         int [][] result = model.generateSequence(length);
         uniqueSeqs.addSequence(result[0]);
      }
      Iterator seqs = uniqueSeqs.iterator();
      int sum = 0;
      while (seqs.hasNext()) {
         Generate.SequenceCount seq = (Generate.SequenceCount)seqs.next();
         int [] key = seq.getSequence();
         dataOut.append("<sequence count='");
         dataOut.append(seq.getCount());
         dataOut.append("'>");
         for (int i=0; i<key.length; i++) {
            dataOut.append((Character)lexicon.get(key[i]));
         }
         dataOut.append("</sequence>");
      }
      dataOut.append("</data>\n");
      StreamResult sout = new StreamResult(out);
      StreamSource in = new StreamSource(new StringReader(dataOut.toString()));
      output2xhtml.transform(in,sout);
      
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