jHMM is a library and application for handling Hidden Markov Models that is written in Java.  The models are encoded in a simple XML format that allows you to have arbitrary states, transitions, and alphabets.  The library implements sequence state predictions and Baum-Welch training of the model parameters.

# Building #

Build the code with ant:
```
cd hmm
ant jar
```

# Running #

By default, the jar file is setup to generate a prediction from a model and input sequence:

```
java -jar dist/jhmm.jar model.xml input.txt
```

You can run a test by doing the following:

```
cd hmm-data
java -jar ../hmm/dist/jhmm.jar ../models/two-dice-model.xml dice.txt
```

and you get the output:

```
1111111111111111111111111111111111111112222222222222222222222222222111111111111111111111111111111111
Score = -178.57415471540796
```

You can also run several other programs using the `jhmm.sh` script:

```
cd hmm
./jhmm.sh com.milowski.hmm.tools.Forward ../models/two-dice-model.xml ../hmm-data/dice.txt
```

The following tools are available:

  * `com.milowski.hmm.tools.Forward` - the forward algorithm output
  * `com.milowski.hmm.tools.Generate` - generates random output according to your model
  * `com.milowski.hmm.tools.ModelCheck` - check the syntax of your model
  * `com.milowski.hmm.tools.Predict` - calculate the most likely state for a sequence
  * `com.milowski.hmm.tools.Train` - train a model on a set of sequences
