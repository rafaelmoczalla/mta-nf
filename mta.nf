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

log.info "MTA - N F  ~  version 1.0.0"
log.info "================================="
log.info "Fasta sequence               : ${params.seq}"
log.info "Number of trees             : ${params.ntree}"
log.info "MSA method         : ${params.msa}"
log.info "Score            : ${params.score}"
log.info "cpus               : ${params.cpus}"
log.info "ouput		: ${params.output}"
log.info "\n"


/*
 * Input parameters validation
 */

if( !(params.msa in ['t_coffee','clustalw'])) { exit 1, "Invalid msa tool: '${params.msa}'" }
if( !(params.score in ['sp','normd', 'tcs'])) { exit 1, "Invalid score: '${params.score}'" }

fasta_file = file(params.seq)
result_path = file(params.output)

/*
 * validate input files
 */
if( !fasta_file.exists() ) exit 1, "Missing sequence file: ${fasta_file}"
if( !annotation_file.exists() ) exit 2, "Missing annotatio file: ${annotation_file}"

if( !result_path.exists() && !result_path.mkdirs() ) {
    exit 3, "Cannot create output folder: $result_path -- Check file system access permission"
}

process make_tree {
    input:
    file fasta_file
    
    output:
    file '*.tree*' into tree
      
    script:
   	//launch mta

}

process align_tree {
    input:
    file tree
    
    output:
    file '*.aln' into aln
      
    script:
	//launch t_coffe or clustalw
	if( params.msa=='t_coffee' )
   	
	else if( params.msa == 'clustalw' )

}

process evaluate_tree {
    input:
    file aln
    
    output:
    	file '*.aln' into outaln
	file '*.tree' into outtree
	file '*.sc_list into outsc

    script:
	//launch sp, normd, tcs
	if( params.score=='sp' )
   	
	else if( params.score == 'normd' )

	else if( params.score == 'tcs' )

}

outaln.subscribe { it ->
    log.info "Copying alignment file to results: ${result_path}/${it.name}"
    it.copyTo(result_path)
    }

outtree.subscribe { it ->
    log.info "Copying tree file to results: ${result_path}/${it.name}"
    it.copyTo(result_path)
    }

outsc.subscribe { it ->
    log.info "Copying score list file to results: ${result_path}/${it.name}"
    it.copyTo(result_path)
    }


