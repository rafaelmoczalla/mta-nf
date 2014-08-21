PROJECT = mgtree

# Environment 
SRC = ./src
OBJ = ./obj
BIN = ./bin

# Better do not change this

CC = gcc
#MPICC = mpicc
GCCFLAGS := -I$(INC) -I$(MPIEXT)

# Add any options you like
GCCFLAGS += -g
GCCFLAGS += -O3
#CFLAGS=-DMPI_FLAG

LIBS = -lm -lpthread

MKDIR=mkdir
CP=cp

OBJS = 	\
	utils.o \
	parameters.o \
	sequence_utils.o \
	distance_matrix_utils.o \
	guide_tree_utils.o \
	main.o
	  
	
vpath %.c $(SRC)
vpath %.o   $(OBJ)
vpath %     $(BIN)

.PHONY: all dir clean distclean

all: dir build

build: $(PROJECT)

%.o: $(SRC)/%.c
	$(CC) $(GCCFLAGS) -c $(SRC)/$(<F) -o $(OBJ)/$(@F)

%: %.o
	$(CC) $(LDFLAGS) $(addprefix $(OBJ)/,$(filter %.o,$(^F))) -o $(BIN)/$(@F)

dir:
	mkdir -p $(BIN); mkdir -p $(OBJ);
	mkdir -p $(BIN)/plugins

clean:
	rm -f $(OBJ)/*.o

distclean:
	rm -rf $(BIN)
	rm -rf $(OBJ)

$(PROJECT): $(OBJS)
	$(CC) $(LDFLAGS) $(addprefix $(OBJ)/,$(OBJS)) $(LIBS) -o $(BIN)/$(PROJECT)

