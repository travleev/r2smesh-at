# Configuration file for compiling software on mesh-cem suse linux system
# (i5 Intel processor) using PGI fortran compiler

# Set TOPDIR if building outside of CVS tree
TOPDIR=../../source

# Fortran compiler
F90 = pgfortran
F77 = pgf77

# Fortran compiler flags
F90FLAGS = -fast -Mbackslash
#F90FLAGS = -g -C -Mbackslash -Mbounds -Mchkptr -Mchkstk -Mpgicoff -traceback


#F77FLAGS = -g -C -Mbounds -Mchkptr -Mchkstk -Mpgicoff -traceback
F77FLAGS = -O0 

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
