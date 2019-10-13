# Configuration file for compiling software on mesh-cem suse linux system
# (i5 Intel processor) using ifort compiler

# Set TOPDIR if building outside of CVS tree
TOPDIR=../../source

# Fortran compiler
F90 = ifort

# Fortran compiler flags
F90FLAGS = -O -static-intel -std03 -unroll -fp-model source -diag-disable 8291,8577

F77FLAGS = -O -fp-model source

# fftw libraries
#LIBS= -L/usr/local/lib -lfftw3

# command to remove files
RM = /bin/rm -f

# extra cleanup command
EXTRA_CLEAN_CMD = :

# Extra files to clean
EXTRA_CLEAN_FILES = *.T

# only needed by developers who run "make depend"
PERL = perl

# Module extension
MOD=.mod
