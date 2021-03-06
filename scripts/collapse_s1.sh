#!/bin/bash

# Script creates folder for collapse fispact run and starts fispact there.
# The file with spectrum is written by the driver to r2s_scratch/fluxes_i_j_k. 

wdr="$r2s_scratch"/r2s_c/$1/$2/$3           # Fispact working folder
flx="$r2s_scratch"/r2s_w/fluxes.$1.$2.$3    # File with flux spectrum
scr="$r2s_scratch"/r2s_r

# If collapx file exists, do nothing
if [ -f "$wdr"/collapx ]; then 
    exit 0
fi    

# Create fispact working folder, if necessary
if [ ! -d "$wdr" ]; then 
    mkdir -p "$wdr"
    ln -s "$r2s_scratch"/r2s_r/collapse_files "$wdr"/files
    ln -s "$r2s_scratch"/r2s_r/collapse_input "$wdr"/collapse.i
    ln -s "$scr"/fispact-data                 "$wdr"/fispact-data
    ln -s "$flx"                              "$wdr"/fluxes
fi

# Run fispact
cd "$wdr"
"$r2s_fispact_exe" collapse > fispact.out || exit 1


exit 0


