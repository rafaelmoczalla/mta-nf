MTA-NF
======

MTA-NF is a Multiple Sequence Alignment pipeline to align multiple guide-tree variations for the same input sequences, evaluating the alignments obtained and selecting the best one as result. MTA method can be applied to any progressive method that accepts guide trees as an input parameter (in this version accepts T-Coffee and ClustalW). In addition, the method also allows different evaluation metrics to select the best multiple guide trees (sp, normd). The aim is to find a variation of the original tree that provides a more accurate alignment than the original one produced. MTA-NF is implemented using the [Nextflow](http://www.nextflow.io) framework.


Quick start 
-----------

Clone the git repository on your computer with the following command:

    $ git clone git@github.com:orobitg/mta-nf.git
    
Run the script install.sh to download, compile and install the tools listed below  (if you are not using Docker).

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
	* By default is set to the MTA-NF's localization: './tutorial/.fa'  
  	`$ ./nextflow run mta.nf --seq /home/user/seq/example.fa`

**--ntree**  
   
* Number of of guide trees to align and evaluate.
* Involved in the task: make_tree.
	* By default is set to 10 guide trees  
  	`$ ./nextflow run mta.nf --ntree 100`

**--msa**  
   
* The MSA tool to produce the alignemnts.
* Two options: t_coffee, clustalw.
* Involved in the task: align_tree.
	* By default is set to 'T-Coffee'  
	`$ ./nextflow run mta.nf --msa t_coffee`

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
  	`$ ./nextflow run mta-nf --score sp --gop -11`

**--gep** 
   
* Sets the Gap Extended Penalty. Only used with SP score.  
* Involved in the task: score_tree.
	* By default is set to -1   
  	`$ ./nextflow run mta-nf --score sp --gep -1`

**--matrix** 
   
* Sets the Distance Matrix. Only used with SP score.  
* Involved in the task: score_tree.
* Options: blosum30mt, blosum40mt, blosum45mt, blosum50mt, blosum55mt, blosum62mt, blosum80mt, idmat, dna_idmat, pam120mt, pam160mt, pam250mt, pam350mt, md_40mt, md_120mt, md_250mt, md_350mt.
	* By default is set to 'blosum62mt'    
  	`$ ./nextflow run mta-nf --score sp --matrix blosum62mt`

**--cpu** 
   
* Sets the number of CPUs used in every tasks.  
* Involved in the task: align_tree.
	* By default is set to the number of the available cores.   
  	`$ ./nextflow run mta-nf --cpu 10`
  
  
**--output** 
   
* Specifies the folder where the results will be stored for the user.  
* It does not matter if the folder does not exist.
  	* By default is set to MTA-NF's folder: './results'  
  	`$ ./nextflow run mta-nf --output /home/user/my_results`


Run locally
------------

**Command line**

* Install all the dependencies running the bash script install.sh.
	$ bash install.sh

* Run nextflow mta-nf command line indication all the input parameters. For example:
	$ ./nextflow run mta-nf --seq /home/user/seq.fasta --ntree 100 --msa t_coffee --score sp --cpu 4 --output /home/user/results

**Config file**

* The user can modify the nextflow.config or create a new config file adding the parameters information:

	params {
		seq = '/home/user/seq.fasta'
		ntree = 100
		msa = 't_coffee'
		score = 'sp'
		gop = '-11'
		gep = '-1'
		matrix = 'blosum62mt'
		cpu = 4
		output = '/home/user/results'
	}

* If you are running MTA-NF with a config file different to the nextflow.config, use the following command line:

	$ ./nextflow -c /home/user/example.config run mta-nf

* More information in http://www.nextflow.io/docs/latest/config.html


Run with Docker 
---------------- 

MTA-NF dependecies are also distributed by using a [Docker](http://www.docker.com) container 
which frees you from the installation and configuration of all the pieces of software required 
by MTA-NF. 

The MTA-NF Docker image is published at this address https://registry.hub.docker.com/u/cbcrg/mta-nf/

If you have Docker installed in your computer pull this image by entering the following command: 

    $ docker pull cbcrg/mta-nf
  
  
After that you will be able to run Grape-NF using the following command line: 

    $ nextflow run cbcrg/mta-nf -with-docker

  
Cluster support
---------------

MTA-NF execution relies on [Nextflow](http://www.nextflow.io) framework which provides an 
abstraction between the pipeline functional logic and the underlying processing system.

Thus it is possible to execute it on your computer or any cluster resource
manager without modifying it.

Currently the following clusters are supported:

  + Oracle/Univa/Open Grid Engine (SGE)
  + Platform LSF
  + SLURM
  + PBS/Torque

By default the pipeline is parallelized by spanning multiple threads in the machine where the script is launched.

To submit the execution to a SGE cluster create a file named `nextflow.config`, in the directory
where the pipeline is going to be launched, with the following content:

    task {
      processor='sge'
      queue='<your queue name>'
    }

In doing that, tasks will be executed through the `qsub` SGE command, and so your pipeline will behave like any
other SGE job script, with the benefit that *Nextflow* will automatically and transparently manage the tasks
synchronisation, file(s) staging/un-staging, etc.

Alternatively the same declaration can be defined in the file `$HOME/.nextflow/config`.

To lean more about the avaible settings and the configuration file read the Nextflow documentation 
 http://www.nextflow.io/docs/latest/config.html



Dependencies 
------------

 * T-Coffee - http://www.tcoffee.org/Projects/tcoffee/index.html
 * ClustalW - http://www.clustal.org/clustal2/
 * Normd - ftp://ftp-igbmc.u-strasbg.fr/pub/NORMD/

