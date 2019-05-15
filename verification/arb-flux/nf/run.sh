#!/bin/bash

for i in $(ls inp?.inp); do
    echo "Preparing meshtal for $i"
    rm meshtal $i?
    mcnp5 name = $i
    mv meshtal $i.meshtal
done    
