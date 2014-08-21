/* 
 * File:   parameters.h
 * Author: morobitg
 *
 * Created on 21 / agost / 2014, 15:23
 */

#ifndef PARAMETERS_H
#define	PARAMETERS_H

#include "utils.h"

/*Parameters list*/

struct Parameters{

    char *seqfile;
    char *dm_method;
    char *outdir;

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

