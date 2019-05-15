#!/bin/bash

meshtals="$@"
for meshtal in $meshtals; do
    if [ ! -f "$meshtal" ];  then
        echo "Meshtal file $meshtal does not exist"
    else
        echo "Splitting file $meshtal"

        rm -rf xx??
        csplit  $meshtal '/Mesh Tally /' '{*}'

        echo "Renaming chunks:"
        cmnd=""
        i=1
        for n in $(grep "Mesh Tally" $1| awk '{print $NF}'); do
            chunk=xx`printf "%02d" $i`
            mv -v $chunk $meshtal.tall.$n
            let i++
            # cmnd="$cmnd "'/Mesh Tally .*'"$n"'/'
            # echo "$cmnd"
        done
    fi
done    
