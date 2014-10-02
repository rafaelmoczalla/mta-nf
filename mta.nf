#!/usr/bin/env nextflow
/*
 * Copyright (c) 2014, Centre for Genomic Regulation (CRG) and the authors.
 *
 *   This file is part of 'MTA-NF'.
 *
 *   Piper-NF is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Piper-NF is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Piper-NF.  If not, see <http://www.gnu.org/licenses/>.
 */

/* 
 * Main Mta-NF pipeline script
 *
 * @authors
 * Miquel Orobitg <miquelorobitg@gmail.com> 
 */

params.seq = "$baseDir/tutorial/12asA_1atiA.fasta"
params.ntree = 10
params.msa = 't_coffee'
params.score = 'sp'
params.cpu = 1
params.output = './results'
params.gop = -11
params.gep = -1
params.matrix = "blosum62mt" 


log.info "MTA - N F  ~  version 1.0"
log.info "================================="
log.info "Fasta sequence    : ${params.seq}"
log.info "Number of trees   : ${params.ntree}"
log.info "MSA method        : ${params.msa}"
log.info "Score             : ${params.score}"
log.info "cpus              : ${params.cpu}"
log.info "ouput             : ${params.output}"
if( params.score=='sp' )  {
log.info "GOP               : ${params.gop}"
log.info "GEP               : ${params.gep}"
log.info "Matrix            : ${params.matrix}"
}

log.info "\n"


/*
 * Input parameters validation
 */

if( !(params.msa in ['t_coffee','clustalw', 'clustalo'])) { exit 1, "Invalid msa tool: '${params.msa}'" }
if( !(params.score in ['sp','normd', 'tcs'])) { exit 1, "Invalid score: '${params.score}'" }

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
    file '*.dnd' into tree_result
      
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
    file '*.aln' into aln_result

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

    else if( params.msa == 'clustalo' )
    """
        fileName=\$(basename "${t}")
        baseName="\${fileName%.*}"
	t2=`echo "outtree"`

        echo "Y" > \${baseName}.tmp
	echo "${t}" >> \${baseName}.tmp
	echo "W" >> \${baseName}.tmp
	echo "F" >> \${baseName}.tmp
	echo "R" >> \${baseName}.tmp
	echo "Q" >> \${baseName}.tmp

	retree < \${baseName}.tmp
	
	clustalo -i ${fasta_file} --guidetree-in=\${t2} --outfmt=fa -o \$baseName.aln	
    """

}

process score_tree {
    input:
    file a from aln

    output:
    file '*.sc' into sc_file

    script:
    //launch sp, normd, tcs


    if( params.score=='sp' )
    """
        fileName=\$(basename "${a}")
        baseName="\${fileName%.*}"

        sc=`t_coffee -other_pg fastal -i ${a} --eval_aln -g ${params.gop} -e ${params.gep} -a --mat ${params.matrix} | grep Score: | cut -d' ' -f2`
        echo "\$baseName \$sc" > \${baseName}.sc
    """
    
    else if( params.score == 'normd' )

    """
        fileName=\$(basename "${a}")
        baseName="\${fileName%.*}"


        sc=`normd ${a}`
        echo "\$baseName \$sc" > \${baseName}.sc
    """

    else if( params.score == 'tcs' )
    """
        fileName=\$(basename "${a}")
        baseName="\${fileName%.*}"
	t_coffee -infile ${a} -evaluate -method proba_pair -output score_ascii -outfile \${baseName}.tcs
	sc=`cat \${baseName}.tcs | grep SCORE= | cut -d'=' -f2`
	echo "\$baseName \$sc" > \${baseName}.sc
    """
    
}


bigFile = sc_file.collectFile(name: 'result')
all_aln_result = aln_result.toList()

process evaluate_scores {
    input:
    file fasta_file
    file all_aln_result
    file tree_result
    file 'big_result' from bigFile

    output:
    file "*.sc" into res_sc
    file "*.dnd" into res_tree
    file "*.aln" into res_aln

    script:
    """
    fileName=\$(basename "${fasta_file}")
    baseName="\${fileName%.*}"

    oldIFS=\$IFS
    IFS=\$'\n'
    max_sc=-99999999.999999
    maxfile=`echo "null"`
    for line in \$(cat big_result); do
        name=`echo \$line | cut -d' ' -f1`
        sc=`echo \$line | cut -d' ' -f2`
        echo  \$name \$line
        if (( \$(echo "\${sc} > \${max_sc}" | bc -l) )); then
            max_sc=\${sc}
            maxfile=\${name}
        fi
    done

    cp big_result \${baseName}.sc
    echo "Maximum: \${maxfile} \${max_sc}" >> \${baseName}.sc

    cp \${maxfile}.dnd \${baseName}.dnd
    cp \${maxfile}.aln \${baseName}.aln

    IFS=\$oldIFS

    """

}

res_sc.subscribe { it ->
    log.info "Copying results log file to results: ${result_path}/${it.name}"
    it.copyTo(result_path)
    }

res_tree.subscribe { it ->
    log.info "Copying the guide tree to results: ${result_path}/${it.name}"
    it.copyTo(result_path)
    }

res_aln.subscribe { it ->
    log.info "Copying the alignment to results: ${result_path}/${it.name}"
    it.copyTo(result_path)
    }



