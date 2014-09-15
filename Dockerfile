FROM fedora:20
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

#
# Create the home folder 
#
RUN mkdir -p /root
ENV HOME /root

#
# Install pre-requistes
#
RUN yum install -q -y bc which wget nano make gcc g++ gcc-gfortran unzip


#
# T-Coffee 
#
RUN wget -q http://www.tcoffee.org/Packages/Stable/Version_11.00.8cbe486/linux/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz; \
  tar xf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz -C /root; \
  rm -rf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz; \
  ln -s /root/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64 /root/tcoffee
  
#
# Clustal
#
RUN wget -q http://www.clustal.org/download/current/clustalw-2.1-linux-x86_64-libcppstatic.tar.gz; \
  tar xf clustalw-2.1-linux-x86_64-libcppstatic.tar.gz -C /root; \
  rm -rf clustalw-2.1-linux-x86_64-libcppstatic.tar.gz; \
  ln -s /root/clustalw-2.1-linux-x86_64-libcppstatic /root/clustalw
  
  
#
# Normd 
# 
RUN mkdir -p /root/bin ; \
   wget -q ftp://ftp-igbmc.u-strasbg.fr/pub/NORMD/norMD1_3.tar.gz; \
   tar xf norMD1_3.tar.gz ; \
   cd normd_noexpat; \
   make; \
   find .  -executable -type f -exec cp "{}" /root/bin/ \;; \
   cd -; \
   rm -rf norMD1_3.tar.gz normd_noexpat
   
   
#
# MTA
# 
ADD src/mgtree /root/mgtree

RUN cd /root/mgtree; \
    make clean && make; \
    cp bin/mgtree /root/bin; \
    cd -; \
    rm -rf /root/mgtree   
    
#
# Finalize environment
#
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/tcoffee/bin:/root/clustalw:/root/bin
ENV TMP /tmp
ENV CACHE_4_TCOFFEE /tmp/cache/
ENV LOCKDIR_4_TCOFFEE /tmp/lck/
ENV TMP_4_TCOFFEE /tmp/tmp/
ENV DIR_4_TCOFFEE /root/tcoffee
ENV MAFFT_BINARIES /root/tcoffee/plugins/linux/
ENV EMAIL_4_TCOFFEE tcoffee.msa@gmail.com
   
    
    