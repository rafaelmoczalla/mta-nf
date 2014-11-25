
#ifndef PARAMETERS_H
#define	PARAMETERS_H

#include "utils.h"

/*Parameters list*/

struct Parameters{

    char *seqfile;
    char *mode;
    char *output;

    int ntree;
    int random_percentage;
    int isseq;

    Fname *F;
};
typedef struct Parameters Parameters;

Parameters *declare_parameters();
void free_parameters(Parameters *P);
Parameters *default_values(Parameters *P, char *outdir);
Parameters *read_parameters(int argc, char** argv);
void printhelp();
#endif	/* PARAMETERS_H */

