#!/bin/bash

# Script creates folder for collapse fispact run and starts fispact there.
# The file with spectrum is written by the driver to r2s_scratch/arb_flux.i.j.k, and
# the GRPCONVERT keyword to r2s_scratch/grpconvert.i.j.k.

wdr="$r2s_scratch"/r2s_c/$1/$2/$3           # Fispact working folder
flx="$r2s_scratch"/r2s_w/arb_flux.$1.$2.$3    # File with flux spectrum
inp="$r2s_scratch"/r2s_w/grpconvert.$1.$2.$3  # Part of the collapse input with GRPCONVERT
scr="$r2s_scratch"/r2s_r

# If collapx file exists, do nothing
if [ -f "$wdr"/collapx ]; then 
    exit 0
fi    

# Create fispact working folder, if necessary
if [ ! -d "$wdr" ]; then 
    mkdir -p "$wdr"
    ln -s "$r2s_scratch"/r2s_r/collapse_files "$wdr"/files
    ln -s "$scr"/fispact-data                 "$wdr"/fispact-data
    ln -s "$flx"                              "$wdr"/arb_flux

    # Concatenate parts of the collapse input file
    cat "$scr"/collapse_input_1 \
        "$inp"                  \
        "$scr"/collapse_input_2 > "$wdr"/collapse.i
fi

# Run fispact
cd "$wdr"
"$r2s_fispact_exe" collapse > fispact.out || exit 1


exit 0


