#!/bin/bash
r2s_continue=no
r2s_debug="yes"

r2s_grpconvert=$1
r2s_neutronspectra=$2
sfx=$(basename $2)
r2s_out=out.$1.$sfx
r2s_log=log.$1.$sfx
r2s_scratch=scr.$1.$sfx

r2s_neutronintensity=nf/meshtal_fine

