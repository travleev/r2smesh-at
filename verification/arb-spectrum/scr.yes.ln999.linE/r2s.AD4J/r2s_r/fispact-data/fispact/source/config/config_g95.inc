# Configuration file for compiling software on suse linux system
# (64-bit AMD processor) using g95 compiler

# Set TOPDIR if building outside of CVS tree
TOPDIR=../../source

# Fortran compiler
F90 = g95

# Fortran compiler flags
F90FLAGS = -O -ffloat-store  -ffree-form -ftr15581 -std=f2003

#F77FLAGS = -g -debug -CB -CA -CU -std77  -fp-model precise
F77FLAGS = -O -Wno=155 -ffloat-store

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
