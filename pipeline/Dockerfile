# base image
FROM ubuntu

# Linux essentials/Compiler Stuff
WORKDIR /
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get install build-essential -y
RUN apt install wget -y
RUN apt-get install sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get install gettext -y
RUN sudo apt-get install zlib1g-dev
RUN sudo apt-get install libncurses5-dev -y
RUN sudo apt-get install liblzma-dev -y
RUN sudo apt install libbz2-dev -y
RUN apt-get install libcurl4-gnutls-dev -y
RUN apt-get install git -y
RUN sudo apt install bash -y
RUN sudo apt install file -y

# Install samtools
WORKDIR /
RUN wget https://github.com/samtools/samtools/releases/download/1.14/samtools-1.14.tar.bz2
RUN tar xvjf samtools-1.14.tar.bz2
WORKDIR /samtools-1.14
RUN make
RUN make install

# Install minimap
WORKDIR /
RUN git clone https://github.com/lh3/minimap2.git
WORKDIR /minimap2
RUN make

# Install nanopolish
WORKDIR /
RUN git clone --recursive https://github.com/jts/nanopolish.git
WORKDIR /nanopolish
RUN make all

# Practice Files
WORKDIR /
RUN wget http://s3.climb.ac.uk/nanopolish_tutorial/methylation_example.tar.gz
RUN tar -xvf methylation_example.tar.gz

# Add pipline shell script
WORKDIR /
ADD pipeline.sh /
