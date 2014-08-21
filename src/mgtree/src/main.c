/* 
 * File:   main.c
 * Author: morobitg
 *
 * Created on 21 / agost / 2014, 15:13
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

    fprintf(stdout, "\n-------------------MULTIPLE GUIDE TREES METHOD---------------------------\n\n");           
    fprintf(stdout, "Input Files:\n");
    fprintf(stdout, "\tInput: (Sequences) %s.%s\n", (P->F)->name, (P->F)->suffix);
    fprintf(stdout, "\tInput: (Distance Method) %s\n", P->dm_method);
    fprintf(stdout, "\tInput: (Number of trees) %d\n", P->ntree);
    fprintf(stdout, "\tOutdir:  %s\n", P->outdir);

    treename = (char *) vcalloc(FILENAMELEN, sizeof(char));

    S=read_fasta_sequences(P->seqfile);

    if(S==NULL){
        fprintf(stderr, "Error - No Sequences\n");
        return(EXIT_FAILURE);
    }

    DM = make_distance_matrix(S, P->dm_method);
    srand(1985);
    fprintf(stdout, "\n---> Generationg the guide trees\n");
    for(i=0; i<P->ntree; i++){
        sprintf(treename, "%s%s_%d.dnd", P->outdir, (P->F)->name, i);
        make_tree(DM, S, treename, "nj", i, P->random_percentage); 
    }
    fprintf(stdout, "---> DONE\n");
    return (EXIT_SUCCESS);
}

