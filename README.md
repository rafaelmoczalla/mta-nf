MTA-nf
======

MTA-nf is a Multiple Sequence Alignment pipeline to align multiple guide-tree variations for the same input sequences, evaluating the alignments obtained and selecting the best one as result. MTA method can be applied to any progressive method that accepts guide trees as an input parameter (in this version accepts T-Coffee and ClustalW). In addition, the method also allows different evaluation metrics to select the best multiple guide trees (sp, normd). The aim is to find a variation of the original tree that provides a more accurate alignment than the original one produced. MTA-nf is implemented using the nextflow dataflow.


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

Pipeline parameters
-------------------

**--seq**  
   
* The location of the sequences fasta file.
* Involved in the task: make_tree, align_tree, evaluate_scores.
	* By default is set to the mta-nf's localization: './tutorial/.fa'
  	`	$ ./nextflow run mta.nf --seq /home/user/seq/example.fa`

**--ntree**  
   
* Number of of guide trees to align and evaluate.
* Involved in the task: make_tree.
	* By default is set to 10 guide trees
  	`	$ ./nextflow run mta.nf --ntree 100`

**--msa**  
   
* The MSA tool to produce the alignemnts.
* Two options: t_coffee, clustalw.
* Involved in the task: align_tree.
	* By default is set to 'T-Coffee'
	`	$ ./nextflow run mta.nf --msa t_coffee`

**--score**  
   
* The evaluation score to choose an alignemnt.
* Two options: sp, normd.
* Involved in the task: score_tree.
	* By default is set to 'Sum-of-Pairs (sp)'
  	`	$ ./nextflow run mta.nf --score sp`

**--gop** 
   
* Sets the Gap Opening Penalty. Only used with SP score.  
* Involved in the task: score_tree.
	* By default is set to -11
  	`	$ ./nextflow run mta-nf --score sp --gop -11`

**--gep** 
   
* Sets the Gap Extended Penalty. Only used with SP score.  
* Involved in the task: score_tree.
	* By default is set to -1
  	`	$ ./nextflow run mta-nf --score sp --gep -1`

**--matrix** 
   
* Sets the Distance Matrix. Only used with SP score.  
* Involved in the task: score_tree.
* Options: blosum30mt, blosum40mt, blosum45mt, blosum50mt, blosum55mt, blosum62mt, blosum80mt, idmat, dna_idmat, pam120mt, pam160mt, pam250mt, pam350mt, md_40mt, md_120mt, md_250mt, md_350mt.
	* By default is set to 'blosum62mt'
  	`	$ ./nextflow run mta-nf --score sp --gep -1`

**--cpu** 
   
* Sets the number of CPUs used in every tasks.  
* Involved in the task: align_tree.
	* By default is set to the number of the available cores
  	`	$ ./nextflow run mta-nf --cpu 10`
  
  
**--output** 
   
* Specifies the folder where the results will be stored for the user.  
* It does not matter if the folder does not exist.
  	* By default is set to mta-nf's folder: './results'
  	`	$ ./nextflow run mta-nf --output /home/user/my_results`



Dependencies 
------------

 * T-Coffee - http://www.tcoffee.org/Projects/tcoffee/index.html
 * ClustalW - http://www.clustal.org/clustal2/
 * Normd - ftp://ftp-igbmc.u-strasbg.fr/pub/NORMD/

