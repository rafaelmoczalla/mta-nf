
#include "parameters.h"

/*Parameters declaration*/

Parameters *declare_parameters(){

    Parameters *P;

    P = vcalloc(1, sizeof(Parameters));
    P->seqfile = (char *) vcalloc(FILENAMELEN, sizeof(char));
    P->mode = (char *) vcalloc(MAXNAMES, sizeof(char));
    P->output = (char *) vcalloc(FILENAMELEN, sizeof(char));
    
    P->isseq=0;
    return P;
}

void free_parameters(Parameters *P){

    vfree(P->seqfile);
    vfree(P->mode);
    vfree(P->output);
    free_fname(P->F);
    
    vfree(P);
}


Parameters *default_values(Parameters *P, char *output){
 
    sprintf(P->output, "%s", output);
    sprintf(P->mode, "multiple");
    P->ntree = 10;
    P->random_percentage=50;
    return P;
}

/*Function to read the input parameters*/

Parameters *read_parameters(int argc, char** argv){

    Parameters *P;
    int i;
    
    if(argc < 2 || argc > 12){
        fprintf(stderr, "ERROR - Number of parameters wrong\n\n");
        //printhelp();
        exit(EXIT_FAILURE);
    }

    P = declare_parameters();

    if(argc == 2 && strm(argv[1], "-help")){
        printhelp();
        exit(EXIT_SUCCESS);
    }
    else if(argc != 2 && strm(argv[1], "-help")){
            fprintf(stderr, "ERROR -help: Number of parameters wrong\n");
            printhelp();
            exit(EXIT_FAILURE);
    }

    for(i=1; i<argc; i++){
        if(strm(argv[i], "-seq")){
            i++;
            if(i<argc && argv[i][0] != '-'){
                sprintf(P->seqfile, "%s", argv[i]);
                P->F = parse_fname(P->seqfile);
                P = default_values(P, (P->F)->path);
                P->isseq = 1;
            }
            else {
                fprintf(stderr, "ERROR - Parameter -seq: No Sequences\n");
                exit(EXIT_FAILURE);
            }
        }
    }

    if(P->isseq == 0){
        fprintf(stderr, "ERROR - No Sequences\n\n");
        printhelp();
        exit(EXIT_FAILURE);
    }

    for(i=1; i<argc; i++){          
        if(strm(argv[i], "-seq")){
            i++;
        }
        else if(strm(argv[i], "-mode")){
			i++;
			if(i<argc && argv[i][0] != '-'){
				if(strm(argv[i], "single") || strm(argv[i], "multiple")){
					sprintf(P->mode, "%s", argv[i]);
				}
				else {
					fprintf(stderr, "ERROR - Parameter -mode: Wrong mode (single, multiple)\n");
				}
			}
			else {
				fprintf(stderr, "ERROR - Parameter -mode: No Value\n");
				exit(EXIT_FAILURE);
			}
		}
        else if(strm(argv[i], "-ntree")){
            i++;
            if(i<argc && argv[i][0] != '-'){
                P->ntree = atoi(argv[i]);
            }
            else {
                fprintf(stderr, "ERROR - Parameter -ntree: No Value (Number of trees)\n");
                exit(EXIT_FAILURE);
            }
        }

        else if(strm(argv[i], "-%tree")){
            i++;
            if(i<argc && argv[i][0] != '-'){
                P->random_percentage = atoi(argv[i]);
            }
            else {
                fprintf(stderr, "ERROR - Parameter -'%%'tree: No Value\n");
                exit(EXIT_FAILURE);
            }
        }
        else if(strm(argv[i], "-output")){
            i++;
            if(i<argc && argv[i][0] != '-'){
                sprintf(P->output, "%s", argv[i]);
            }
            else {
                fprintf(stderr, "ERROR - Parameter -output: No Value\n");
                exit(EXIT_FAILURE);
            }
        }
    }

    return P;
}

void printhelp(){
    fprintf(stdout, "\n******************HELP MENU***************************************************\n\n");
}
