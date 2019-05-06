#!/bin/bash

# Copy results for the coarse mesh element and clean workplaces

wdr="$r2s_scratch"/r2s_c/$1/$2/$3           # Collapse working folder (see collapse_s1.sh)
flx="$r2s_scratch"/r2s_w/arb_flux.$1.$2.$3    # File with flux spectrum

[  -z "$r2s_debug"  ] && rm -rf "$wdr"
[  -z "$r2s_debug"  ] && rm -rf "$flx"

mv "$r2s_scratch"/r2s_w/cgi.$1.$2.$3 "$r2s_out"

exit 0



