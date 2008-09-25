/*
 * TwoStateScenarios.java
 *
 * Created on October 29, 2004, 10:57 AM
 */

package training;

import java.io.*;
import java.util.*;

import javax.xml.parsers.*;
import org.xml.sax.*;

import com.milowski.hmm.*;
import com.milowski.hmm.tools.*;
import org.infoset.xml.util.WriterItemDestination;

/**
 *
 * @author  alex
 */
public class TwoStateScenarios
{
   
   /** Creates a new instance of TwoStateScenarios */
   public TwoStateScenarios()
   {
      
   }
   
   public static void main(String [] args) {
      if (args.length!=6) {
         System.err.println("TwoStateScenarios model error delta zero-value training-data output ");
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
         
         ScenarioGenerator generator = new ScenarioGenerator(model);
         
         double error = Double.parseDouble(args[1]);
         
         double delta = Double.parseDouble(args[2]);
         
         double zero = Double.parseDouble(args[3]);
         
         List sequenceCounts = Train.loadSequenceCounts(new FileReader(args[4]), model.getTranslator(), true);

         // This assumes a two state model!!!
         int max = (int)(1.0/delta);
         double penultimate = 1.0-delta;
         
         /*
         System.out.println("max="+max);
         System.out.println("delta="+delta);

         System.out.println("10*0.1="+(10*0.1));
         System.out.println("max*delta="+(max*delta));
         System.out.println("6*delta="+(((double)6)*delta));
          */
         for (int i=0; i<=max; i++) {
            double x = 0;
            for (int m=0; m<i; m++) {
               x += delta;
            }
            if (x==0) {
               x = zero;
            } else if (x>penultimate) {
               x = 1-zero;
            }
            for (int j=0; j<=max; j++) {
               double y = 0;
               for (int m=0; m<j; m++) {
                 y += delta;
               }
               if (y==0) {
                  y = zero;
               } else if (y>penultimate) {
                  y = 1-zero;
               }
               double [][] s = copy(model.getStateTransitions());
               s[1][1] = x;
               s[1][2] = 1-x;
               s[2][1] = 1-y;
               s[2][2] = y;
               generator.addScenario(sequenceCounts,error,s,null);
            }
         }
         
         generator.toXML(new WriterItemDestination(new FileWriter(args[5]), "UTF-8",true));
         
      } catch (Exception ex) {
         ex.printStackTrace();
      }
   }
   
   static double [][] copy(double [][]s) {
      double [][] n = new double[s.length][];
      for (int i=0; i<s.length; i++) {
         n[i] = new double[s[i].length];
         System.arraycopy(s[i],0,n[i],0, s[i].length);
      }
      return n;
   }
   
}
