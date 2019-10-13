# Configuration file for compiling software on solaris x86 system
# (64-bit AMD processor) using Sun Studio 12 (update 1) compiler
# collection

# Set TOPDIR if building outside of CVS tree
 TOPDIR=../../source

# Fortran compiler
F90 = f95

# Fortran compiler flags
#F90FLAGS = -ansi -C -g -fstore -O0
#F77FLAGS = -ansi -C -g -fstore -O0
F90FLAGS = -fstore -O3
F77FLAGS = -fstore -O3

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
