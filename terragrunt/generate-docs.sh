#!/bin/bash

# Find all .tf files within modules directory 
find ./modules -type f -name '*.tf' -exec dirname {} \; | sort -u | while read -r dir; do
    echo "Generating documentation for module in ${dir}"
    terraform-docs markdown table "${dir}" --output-file README.md
done
