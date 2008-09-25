/*
 * LogLikelihood.java
 *
 * Created on October 26, 2004, 1:53 PM
 */

package matlab;

import java.io.*;
import java.util.*;

import javax.xml.parsers.*;
import org.xml.sax.*;

import com.milowski.hmm.*;
import com.milowski.hmm.tools.Train;

/**
 *
 * @author  alex
 */
public class LogLikelihood {
   
   /** Creates a new instance of LogLikelihood */
   public LogLikelihood()
   {
   }
   
   public static void main(String [] args) {
      if (args.length!=2) {
         System.err.println("Arguments required: model-file sequence-counts-file");
         System.exit(1);
      }
      
      try {
         SAXParserFactory saxFactory = SAXParserFactory.newInstance();
         saxFactory.setNamespaceAware(true);
         SAXParser saxParser = saxFactory.newSAXParser();
         XMLReader xmlReader = saxParser.getXMLReader();

         XMLModelReader modelReader = new XMLModelReader(xmlReader);
         FileReader modelInput = new FileReader(args[0]);
         InputSource source = new InputSource(modelInput);

         Model model = modelReader.load(source);

         modelInput.close();

         model.check();

         double s[][] = model.getStateTransitions();
         double t[][] = model.getStateEmissions();

         System.out.print("S=[");
         for (int from=1; from<s.length; from++) {
            for (int to=1; to<s[from].length; to++) {
               System.out.print(Double.toString(s[from][to]));
               System.out.print(' ');
            }
            if (from!=(s.length-1)) {
               System.out.print("; ");
            }
         }
         System.out.println("];");

         System.out.print("T=[");
         for (int from=1; from<t.length; from++) {
            for (int ch=0; ch<t[from].length; ch++) {
               System.out.print(Double.toString(t[from][ch]));
               System.out.print(' ');
            }
            if (from!=(t.length-1)) {
               System.out.print("; ");
            }
         }
         System.out.println("];");

         Model.Translator translator = model.getTranslator();
         FileReader sequenceInput = new FileReader(args[1]);
         List sequences = Train.loadSequenceCounts(sequenceInput,translator);
         System.out.println("l=0;");
         for (int i=0; i<sequences.size(); i++) {
            short [] sequence = (short [])sequences.get(i);
            System.out.print("[x,lp"+i+"] = hmmdecode([");
            for (int j=0; j<sequence.length; j++) {
               System.out.print(Integer.toString(sequence[j]+1));
               if (j!=(sequence.length-1)) {
                  System.out.print(',');
               }
            }
            System.out.println("],S,T);");
            System.out.println("l=l+lp"+i+";");
         }

      } catch (java.io.IOException ex) {
         ex.printStackTrace();
      } catch (org.xml.sax.SAXException ex) {
         System.err.println(ex.getMessage());
      } catch (javax.xml.parsers.ParserConfigurationException ex) {
         ex.printStackTrace();
      }
   }
   
}
