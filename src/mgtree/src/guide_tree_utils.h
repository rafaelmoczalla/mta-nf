/* 
 * File:   guide_tree_utils.h
 * Author: morobitg
 *
 * Created on 21 / agost / 2014, 15:15
 */

#ifndef GUIDE_TREE_UTILS_H
#define	GUIDE_TREE_UTILS_H

#include <stdarg.h>
#include <signal.h>

#include "utils.h"
#include "distance_matrix_utils.h"

#define NODE 0
#define LEAF 1
#define LEFT 1
#define RIGHT 2
#define INTERVAL 0.50


void make_tree(Distance_matrix *DM, Sequence *S, char *tree_file, char *mode, int tree, int nrand);
void make_nj_tree(int **distances, char **out_seq, char **out_seq_name, int *out_seq_id, int out_nseq, char *tree_file, char *mode, int tree, int nrand);
void int_dist2nj_tree(int **distances, char **out_seq_name, int *out_seq_id, int out_nseq,  char *tree_file, char *mode, int tree, int nrand);
void float_dist2nj_tree(float **distances, char **out_seq_name, int *out_seq_id, int out_nseq,  char *tree_file, char *mode, int tree, int nrand);
void dist2nj_tree (double **distances, char **out_seq_name, int *out_seq_id, int out_nseq,  char *tree_file, char *mode, int tree, int nrand);
void guide_tree(char *fname, double **saga_tmat, char **saga_seq_name, int saga_nseq, char *mode, int tree, int nrand);
void nj_tree(char **tree_description, int nseq, char *mode, int tree, int nrand);
void print_phylip_tree(char **tree_description, FILE *tree, int bootstrap);
void print_phylip_tree_clo(char **tree_description, FILE *tree, int bootstrap);
void two_way_split(char **tree_description, FILE *tree, int start_row, int flag, int bootstrap);
void slow_nj_tree_random(char **tree_description, int tree, int nrand);
void fast_nj_tree_random(char **tree_description, int tree, int nrand);
void slow_nj_tree_bgt(char **tree_description);
void fast_nj_tree_bgt(char **tree_description);

int search_tree_id(char** tree_id_list, char* tree_id, int ntreeid);
int count_entries_file(char *fname, int nseq);
char** file2tree_id_list(char *fname, int ntrees, int nseqs, int entries);

char* root_unrooted_tree(char *treename, int ntree, char *retree_bin);

#endif	/* GUIDE_TREE_UTILS_H */

