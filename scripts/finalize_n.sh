#!/bin/bash

# This script is called after all processes receive the end-of-job signal, once on each node.

# Clear scratch folders
rm -rf $r2s_scratch/r2s_w
rm -rf $r2s_scratch/r2s_r
