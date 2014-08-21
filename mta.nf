#!/usr/bin/env nextflow

import org.apache.commons.lang.StringUtils

/* 
 * Main Mta-NF pipeline script
 *
 * @authors
 * Miquel Orobitg <miquelorobitg@gmail.com> 
 */

params.seq = "$HOME/sample.fa"
params.ntree = 10
params.msa = "t_coffee"
params.score = "sp"
params.cpu = 1
params.output      = './results'

params.gep = -11
params.gop = -1
params.matrix = "blosum62mt" 


log.info "MTA - N F  ~  version 0.0.1"
log.info "================================="
log.info "Fasta sequence               : ${params.seq}"
log.info "Number of trees             : ${params.ntree}"
log.info "MSA method         : ${params.msa}"
log.info "Score            : ${params.score}"
log.info "cpus               : ${params.cpu}"
log.info "ouput		: ${params.output}"
if( params.score=='sp' )
	log.info "GOP            : ${params.gop}"
	log.info "GEP               : ${params.gep}"
	log.info "Matrix		: ${params.matrix}"
log.info "\n"


/*
 * Input parameters validation
 */

if( !(params.msa in ['t_coffee','clustalw'])) { exit 1, "Invalid msa tool: '${params.msa}'" }
if( !(params.score in ['sp','normd'])) { exit 1, "Invalid score: '${params.score}'" }

fasta_file = file(params.seq)
result_path = file(params.output)

/*
 * validate input files
 */
if( !fasta_file.exists() ) exit 1, "Missing sequence file: ${fasta_file}"

if( !result_path.exists() && !result_path.mkdirs() ) {
    exit 3, "Cannot create output folder: $result_path -- Check file system access permission"
}

process make_tree {
	input:
	file fasta_file
    
	output:
	file '*.dnd' into tree mode flatten
      
    	script:
 	
	"""
   	mgtree -seq ${fasta_file} -ntree ${params.ntree}
	"""
}

process align_tree {
	input:
   	file fasta_file	
  	file t from tree
    
	output:
		file '*.aln' into aln mode flatten

 	script:
	//launch t_coffee or clustalw
	
	if( params.msa=='t_coffee' )
	"""
		fileName=\$(basename "${t}")
		baseName="\${fileName%.*}"
		t_coffee ${fasta_file} -usetree ${t} -output=fasta -n_core=${params.cpu} -outfile=\$baseName.aln
	"""
	else if( params.msa == 'clustalw' )
	"""
		fileName=\$(basename "${t}")
		baseName="\${fileName%.*}"
		clustalw2 -infile=${fasta_file} -usetree=${t} -output=fasta -outfile=\$baseName.aln
	"""
}

process score_tree {
    	input:
	file a from aln
    
	output:
	file result into sc_file

	script:
	//launch sp, normd, tcs
	 
	if( params.score=='sp' )
	"""
		fileName=\$(basename "${a}")
		baseName="\${fileName%.*}"
		
		sc=`t_coffee -other_pg fastal -i ${a} --eval_aln -g ${params.gop} -e ${params.gep} -a --mat ${params.matrix} | grep Score: | cut -d' ' -f2`
		echo "\$baseName \$sc" > result
	"""
	else if( params.score == 'normd' )
	"""
		fileName=\$(basename "${a}")
		baseName="\${fileName%.*}"
		sc=`normd ${a}`
		echo "\$baseName \$sc" > result
	"""
}

bigFile = sc_file.collectFile(name: 'result')

process evaluate_scores {
	input:
	file bigFile

	script:
	"""
	echo ${bigFile}
	"""

}


