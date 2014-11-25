/* 
 * File:   main.c
 * Author: Miquel Orobitg
 *
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "utils.h"
#include "sequence_utils.h"
#include "distance_matrix_utils.h"
#include "guide_tree_utils.h"
#include "parameters.h"

/*
 * 
 */
int main(int argc, char** argv) {

    Parameters *P;
    Sequence *S;
    Distance_matrix *DM;

    char *treename;

    int i=0;

    P = read_parameters(argc, argv);

    treename = (char *) vcalloc(FILENAMELEN, sizeof(char));

    S=read_fasta_sequences(P->seqfile);

    if(S==NULL){
        fprintf(stderr, "Error - No Sequences\n");
        return(EXIT_FAILURE);
    }

    DM = make_distance_matrix(S);


    if(strm(P->mode, "multiple")){
		for(i=0; i<P->ntree; i++){
			srand(1985+i);
			sprintf(treename, "%s%s_%d.dnd", P->output, (P->F)->name, i);
			make_tree(DM, S, treename, "nj", i, P->random_percentage);
		}
    }
    else if (strm(P->mode, "single")){
    	srand(1985+P->ntree);
		sprintf(treename, "%s%s_%d.dnd", P->output, (P->F)->name, P->ntree);
		make_tree(DM, S, treename, "nj", P->ntree, P->random_percentage);
    }

    return (EXIT_SUCCESS);
}

