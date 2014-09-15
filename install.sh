#!/bin/bash

dir=$PWD

# Environment 
SRC=./src
BIN=./bin

mkdir -p $BIN

#T-Coffee
wget -P ${SRC} http://www.tcoffee.org/Packages/Stable/Latest/linux/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz
tar xvzf ${SRC}/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz -C ${SRC}
cd ${SRC}/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64/src
make -f makefile
cp t_coffee ${dir}/${BIN}

cd $dir
#ClustalW2
wget -P ${SRC} http://www.clustal.org/download/current/clustalw-2.1-linux-x86_64-libcppstatic.tar.gz
tar xvzf ${SRC}/clustalw-2.1-linux-x86_64-libcppstatic.tar.gz -C ${SRC}
cp ${SRC}/clustalw-2.1-linux-x86_64-libcppstatic/clustalw2 ${BIN}

#NORMD
cd $dir
wget -P ${SRC} ftp://ftp-igbmc.u-strasbg.fr/pub/NORMD/norMD1_3.tar.gz
tar xvzf ${SRC}/norMD1_3.tar.gz -C ${SRC}
cd $SRC/normd_noexpat
make -f makefile
cp normd $dir/$BIN/

#MGTREE
cd $dir
cd ${SRC}/mgtree
make -f Makefile
cp bin/mgtree $dir/$BIN

