MTA-nf
======

MTA-nf is a Multiple Sequence Alignment pipeline to align multiple guide-tree variations for the same input sequences, evaluating the alignments obtained and selecting the best one as result. MTA method can be
applied to any progressive method that accepts guide trees as an input parameter (in this version accepts T-Coffee and ClustalW). In addition, the method also allows different evaluation metrics to select the best multiple guide trees (sp, normd). The aim is to find a variation of the original tree that provides a more accurate alignment than the original one produced.


Quick start 
-----------

Clone the git repository on your computer with the following command:

    $ git clone git@github.com:orobitg/mta-nf.git
    

Make sure you have installed the required dependencies listed below, or just 
use the self-configured Vagrant VM. 

When done, move in the project root folder named `mta-nf`, 
which contains an example dataset in the `tutorial` folder. 

Launch the pipeline by entering the following command 
on your shell terminal:

    $ ./nextflow run mta.nf
    
By default the pipeline is executed against the provided tutorial dataset. 
Check the *Pipeline parameters*  section below to see how enter your data on the program command line.

 
