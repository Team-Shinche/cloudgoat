#!/bin/bash

DIRS=("./16" "./17")

for dir in "${DIRS[@]}"; do
    find "$dir" -type f -name "*.json.gz" -print0 | xargs -0 gunzip
done
