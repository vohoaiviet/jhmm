<%@page contentType="text/plain" import="java.io.*,java.util.*,java.text.*,javax.xml.parsers.*,org.xml.sax.*,org.w3c.dom.*,com.milowski.hmm.*,com.milowski.hmm.tools.*,com.oreilly.servlet.*"%><%
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

      if (count==1) {
         int [][] result = model.generateSequence(length);

         List lexicon = model.getLexicon();
         for (int i=0; i<result[0].length; i++) {
            out.print((Character)lexicon.get(result[0][i]));
         }
         out.println();
         int numberOfStates = model.getNumberOfStates();
         if (numberOfStates>9) {
            for (int i=0; i<result[1].length; i++) {
               out.print(result[1][i]);
               out.print(',');
            }
         } else {
            for (int i=0; i<result[1].length; i++) {
               out.print(result[1][i]);
            }
         }
      } else {
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
            for (int i=0; i<key.length; i++) {
               out.print((Character)lexicon.get(key[i]));
            }
            out.print(',');
            out.println(seq.getCount());
            sum += seq.getCount();
         }
      }

   } catch (java.io.IOException ex) {
      ex.printStackTrace();
   } catch (org.xml.sax.SAXException ex) {
      ex.printStackTrace();
   } catch (javax.xml.parsers.ParserConfigurationException ex) {
      ex.printStackTrace();
   }
%>