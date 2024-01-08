#!/bin/bash

for dir in $(find . -maxdepth 1 -type d); do
    if [ -f "${dir}/*.tf" ]; then
        echo "Generating documentation for module in ${dir}"
        terraform-docs markdown table "${dir}"
    fi
done

