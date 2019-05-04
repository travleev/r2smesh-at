#!/bin/bash

# Script cleans inventory fispact run.

wdr="$r2s_scratch"/r2s_i/$1/$2/$3        # Inventory working folder
scr="$r2s_scratch"/r2s_r                 # Scratch foder, where resulting tab4 files are moved
scw="$r2s_scratch"/r2s_w                 # Scratch foder, where parts of the inventory input are written by the driver 


[ -z "$r2s_debug" ] && rm "$scr"/tab4.$1.$2.$3
[ -z "$r2s_debug" ] && rm -rf "$wdr"
[ -z "$r2s_debug" ] && rm "$scw"/mat.content.$1.$2.$3 
[ -z "$r2s_debug" ] && rm "$scw"/scenario.$1.$2.$3 


exit 0

