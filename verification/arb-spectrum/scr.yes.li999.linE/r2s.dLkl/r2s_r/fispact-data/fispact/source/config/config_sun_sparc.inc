# Configuration file for compiling software on solaris sparc system
# (64-bit RISC processor) using Sun Studio 12 (update 1) compiler
# collection

# Set TOPDIR if building outside of CVS tree
 TOPDIR=../../source

# Fortran compiler
F90 = f90

#directory for previously compiled .mod files (Solaris sparc special)
INCS=-M ../build

# Fortran compiler flags
#F90FLAGS = -ansi -C -g -O0
#F77FLAGS = -ansi -C -g -O0
F90FLAGS = -O3
F77FLAGS = -O3

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
