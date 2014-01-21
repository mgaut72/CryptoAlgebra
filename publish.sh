#! /bin/bash
name=$(basename "$1")
date=$(date +%F)
mv "$1" "_posts/$date-$name"
