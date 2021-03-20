#!/bin/bash

# Setup default environment variables for r2smesh

##################################
#    USAGE NOTE                  #
##################################

# This script should be sourced (not executed) from the problem directory to
# ensure that all variables defined here become available in the current shell.
# I.e, 
# 
#     > . ./r2s_env.sh         # this is correct
#     > source ./r2s_env.sh    # the same as above
#     > ./r2s_env.sh           # this is wrong
#
# For details see e.g. 
# https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it 

# The environmental variables, the script makes use of:
# R2S_ROOT -- (optional) path, where all r2smesh-related files are located (i.e. the repository)
# FISPACT_DATA -- (optional) path to the FISPACT data. If not given, derived from the location of fispact-II executable)
# R2S_SCRATCH -- (optional) default scratch folder. If not given, ``./scratch`` is used, local to the problem directory.

# Check that this script is sourced, not executed (bash-specific):
[ $0 = $BASH_SOURCE ] && echo "WARNING: this script must be sourced, not executed."

#####################################
#    PROBLEM-INDEPENDENT variables  #
#####################################

# Root folder for the r2s distribution.
# This variable is used only in this script, as a common part of the path
# containing executables, default scripts and input files. It is assumed that
# the user has defined the $R2S_ROOT variable, which points to the default
# place of r2s distribution.
if [ -v R2S_ROOT ]; then
    export r2s_root=$R2S_ROOT
else    
    # This situation is bad, but exiting the script will not help 
    # (on Marconi it will close the ssh connection, when this script
    # is sourced). Therefore, warn the user.
    r2s_root=`dirname $BASH_SOURCE`/..
    r2s_root=`realpath $r2s_root`
    export r2s_root
    echo "WARNING: R2S_ROOT variable is undefined. Check if it is guessed correctly: "
    echo "         R2S_ROOT set to $r2s_root"
fi

# Path to the activation driver executable
export r2s_driver=$r2s_root/adriver/adriver.exe

# Path to the scripts that are called by $r2s_driver. 
# THese are  initialization and finalization scripts that are usually
# cluster-dependent, but problem-independent, and scripts that prepare fispact
# working folders and run fispact. This variable is used only here to define
# places of the scripts actually started by the driver (see below).
export r2s_scripts=$r2s_root/scripts

# Scripts called by the driver only once.
# The scripts are started before all fispact runs (e.g. to create out and log
# folders) and after all fispact runs are completed.
export r2s_init_1=$r2s_scripts/init_1.sh
export r2s_finalize_1=$r2s_scripts/finalize_1.sh

# Scripts called by the driver on each node only once.
# The scripts are started before collapse and inventory fispact runs (e.g. to
# copy fispact data and organize scratch folders at the local node filesystem).
# The scripts are started by the driver with two command line arguments, the
# node number and its name.
export r2s_init_n=$r2s_scripts/init_n.sh
export r2s_finalize_n=$r2s_scripts/finalize_n.sh

# Path to the default natural abundancies.
# Material composition for inventory runs is taken from $r2s_matcomposition
# file. Usually this file is prepared based on MCNP material cards and thus can
# have nuclides of the form ZZ000 (i.e. elemental cross secitons). For fispact,
# isotopic composition is needed (material compsition in the inventory input is
# defined by the "FUEL" keyword) therefore, for such cross-sections, isotopic
# compositions are taken from this file. This file is always read by the
# driver, but its informaiton is used only when ZZ000 nuclides appear in
# $r2s_matcomposition.
export r2s_natab=$r2s_root/files/natural.txt


# Path to fispact executable.
# This variable is used in the scripts that actually start fispact for
# condense, collapse and inventory calculations, see e.g. $r2s_condense_s1
# variable below.
if [ -v FISPACT ]; then
    r2s_fispact_exe=$FISPACT
else    
    r2s_fispact_exe=`which fispact`  # FISPACT-II standard distribution contains precompiled exe named "fispact". Use this naem also here.
fi
export r2s_fispact_exe

# Path to fispact data.
# This folder is copied to the local node filesystem by the $r2s_init_n script.
# From there, it is linked to the fispace work places (folders containing all
# files necessary to start fispact) to "fispact-data".  The latter name must be
# used in $r2s_condense_files, $r2s_collapse_files and $r2s_inventory_files
# files.

# Use user's variable, if not set try to guess
if [ -v FISPACT_DATA ]; then
    r2s_fispact_data="$FISPACT_DATA"    
else
    # FISPACT_DATA not set. Try to guess from the realpath to fispact-II executable
    r2s_fispact_data=$(dirname `realpath $r2s_fispact_exe`)
    echo "WARNING: FISPACT_DATA variable is undefined. Check if it is guessed correctly: "
    echo "         FISPACT_DATA set to $r2s_fispact_data"
fi
export r2s_fispact_data

# Fispact input files, usually problem-independent.
# Input files for condense and collapse fispact runs are usually
# problem-independent. Also the upper part of the inventory input file (i.e.
# before material composition and irradiation scenario) is problem-independent. 
export r2s_condense_input=$r2s_root/files/condense_input
export r2s_condense_files=$r2s_root/files/condense_files
export r2s_collapse_input=$r2s_root/files/collapse_input
export r2s_collapse_files=$r2s_root/files/collapse_files
export r2s_inventory_input_header=$r2s_root/files/inventory_input_header
export r2s_inventory_files=$r2s_root/files/inventory_files

# Scripts to prepare fispact workplace and run it.
# Scripts $r2s_*_s1 prepare fispact workplace and start fispact. Scripts
# $r2s_*_s2 clean up the workspace (if needed). These scripts are usually
# problem-independent, until the user wants to preserve fispact workplaces for
# post-mortem debugging or extracting additional information from fispact
# results.
export r2s_condense_s1=$r2s_scripts/condense_s1.sh
export r2s_condense_s2=$r2s_scripts/condense_s2.sh
export r2s_collapse_s1=$r2s_scripts/collapse_s1.sh
export r2s_collapse_s2=$r2s_scripts/collapse_s2.sh
export r2s_inventory_s1=$r2s_scripts/inventory_s1.sh
export r2s_inventory_s2=$r2s_scripts/inventory_s2.sh

# Path to scratch folders. 
# The driver communicates with fispact via external files. Parts of fispact
# input files (neutorn flux, material composition, irradiation scenario) are
# written by the driver to an external file and than copied to the fispact
# workplace by  correspondent script. Fispact, in turn, writes its output that
# is than read by the driver. For a massively parallel run (1000 processes and
# above on Marconi), the use of node local filesystem for such files is much
# more effective, as copmared to the use of the common file system. This
# variable defines the folder where all temporary files are written.
if [ -v R2S_SCRATCH ]; then 
    r2s_scratch=$R2S_SCRATCH
else    
    r2s_scratch='./scratch'
fi
export r2s_scratch=`realpath $r2s_scratch`




#####################################
#    PROBLEM-DEPENDENT variables    #
#####################################

# Whether to continue previous fispact runs. 
# When $r2s_continue set to "yes" (case sensitive), the $r2s_out folder will not
# be moved, and fispact runs will be started only for the coarse mesh elements,
# for whose there are no cgi files. For all other values of $r2s_continue, the
# $r2s_out folder is emptied before fispact runs.
export r2s_continue=yes  # "yes" is case sensitive. 
# export r2s_continue=no   # any other value means "no".

# Folder with the problem data.
# This variable is used only here to provide common part to other variables.
export r2s_input=$(realpath ./input)

# Folder where gamma intensities are written by each process.
# This must be a global file system, to ensure files remain accessible after
# the job is completed.  The cgi.* files, containing gamma intensities in
# coarse mesh elements are copied here after all calculation for that coarse
# mesh element are completed. This folder is recreated by $r2s_init_1 script,
# unless $r2s_continue is set to "yes". This folder is searched by the driver
# before starting fispact calculations for particular coarse mesh element. If
# the file cgi.i.j.k exists, where i, j and k are indices of the coarse mesh
# element, the calculations are skipped.
export r2s_out=$(realpath ./out)

# Folder where each process writes its log file.
# WHen the driver starts with N mpi processes, log.0 file in this folder
# contains log messages from the master (that reads input files and distributes
# job among the slaves). The other log.i files, i=1, N-1, contain log messages
# from the slave processes that actually start fispact calculations.
export r2s_log=$(realpath ./log)


# Case input files.
# Neutron flux intensities and spectra, material allocation, material
# compositions and correspondense between cell and material names and indices
# must be specified in these input files.
#
# Material allocation.
# Resembles the original fine-mesh_content file, but contains number of hits
# rather than vol. fractions.  This file is prepared by the modified MCNP5
# version that is used to detect material allocation in the mesh.  The mesh
# geometry must correspond to the fine mesh, used for neutron flux intensity.
export r2s_matallocation=$r2s_input/fine_mesh_content
#
# Meshtal for neutron intensity.
# This is part of meshtal file containing mesh tally results for neutron flux
# intensity.  Geometry of the mesh must correspond to the geometry of the mesh
# used for material allocation, see $r2s_matallocation.
export r2s_neutronintensity=$r2s_input/meshtal.fine
#
# Meshtal for neutron spectra.
# This is part of meshtal file containing mesh tally results for neutron flux
# spectra.  The VITAMIN-J group structure must be used. The mesh boundaries
# must coinside with (some of) the mesh boundaries of the neutron flux
# intensity, given by $r2s_neutronintensity.
export r2s_neutronspectra=$r2s_input/meshtal.coarse
#
# Material compositions.
# This is a file containing material isotopic compositins in format suitable
# for the "FUEL" fispct keyword, for each material index, mentioned in the
# material allocation file $r2s_matallocation. Content of this file is prepared
# by the modified MCNP5 version, used for material detection, as "print table
# FIS".
export r2s_matcomposition=$r2s_input/mat_table
#
# Cell and material indices.
# This is a table specifying for each cell index (used in $r2s_matallocation)
# its the cell name, mateirial index and name, and density and concentration.
# Content of this table is prepared by the modified MCNP5 version, used for
# material detection, as "print table CMI".
export r2s_cellsmaterials=$r2s_input/cmi_table
#
# Irradiation scenario.
# This is the part of fispact input for inventory calculations, describing
# irradiation scenario. Flux values here are multiplied by the neutron flux
# intensity from $r2s_neutronintensity. Normalization thus depends on the
# normalization of the correspondent meshtally.  
export r2s_inventory_input_footer=$r2s_input/inventory_input_footer


##############################################
# Source problem-specific configuration file #
##############################################

# All default values can be changed in the local script, which is sourced here
echo "************************************************************"
if [ -r ./r2s_env_local.sh ]; then
    source ./r2s_env_local.sh
    echo "Local configuration file is sourced: `realpath ./r2s_env_local.sh`"
fi    

# Ensure that absolute path for scratch is used
r2s_scratch=`realpath $r2s_scratch` 



#########################
# Unique scratch folder #
#########################

# If several independent runs use the same scratch folder, they will interfere.
# Ensure that each run gets its own unique scratch folder. Note that the unique
# folder is created at the moment this script is executed (or sourced),
# therefore, be sure to source it each time a new driver run is started. A good
# practice is to source this file just before starting adriver.exe, e.g. in a
# script.
# TODO: add ``run_adriver.sh`` script that has two steps: sources this file and runs adriver.
mkdir -p $r2s_scratch
r2s_scratch=`mktemp -d --tmpdir=$r2s_scratch -t r2s.XXXX`



##########################
# Check that files exist #
##########################

# Directories
for v in r2s_root r2s_scripts; do
    if [ -d ${!v} ]; then
        echo "$v: ${!v}"
    else
        echo "$v: does not exist"
    fi
done

# Fispact
[ -x $r2s_fispact_exe  ] && r1=$r2s_fispact_exe  || r1="cannot be executed"
[ -d $r2s_fispact_data ] && r2=$r2s_fispact_data || r2="does not exist"
echo "r2s_fispact_exe: $r1"
echo "r2s_fispact_data: $r2"

# Adriver
[ -x $r2s_driver  ] && r1=$r2s_driver  || r1="cannot be executed"
echo "r2s_driver: $r1"


# Executables and scripts
scripts="r2s_init_1 r2s_finalize_1 r2s_init_n r2s_finalize_n"
scripts="$scripts r2s_condense_s1 r2s_condense_s2 r2s_collapse_s1 r2s_collapse_s2"
scripts="$scripts r2s_inventory_s1 r2s_inventory_s2"
for v in $scripts; do
    [ -x ${!v} ] && r=${!v} || r="cannot be executed"
    echo "$v: $r"
done    

# Scratch folder
echo "r2s_scratch: $r2s_scratch"

# Input files for adriver
for d in r2s_input r2s_out r2s_log; do
    [ -d ${!d} ] && r=${!d} || r="does not exist"
    echo "$d: $r"
done
files="matallocation neutronintensity neutronspectra matcomposition cellsmaterials"
files="$files inventory_input_footer"
for f in $files; do
    f="r2s_$f"
    [ -r ${!f} ] && r=${!f} || r="is not readable"
    echo "$f: $r"
done


