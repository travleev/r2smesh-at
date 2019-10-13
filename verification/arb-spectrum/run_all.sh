#!/bin/bash

source /opt/intel/bin/ifortvars.sh intel64

# Run all cases specified in the command line
gc=$1   # "yes" to use group convert, otherwise "no".
shift
for i in $@; do
    source ../../scripts/r2s_env.sh r2s_env.sh $gc $i
    $r2s_driver
done

