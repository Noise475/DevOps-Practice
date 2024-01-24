#!/bin/bash

# Find all directories containing at least one Terraform file
find . -type f -name '*.tf' -exec dirname {} \; | sort -u | while read -r dir; do
    echo "Generating documentation for module in ${dir}"
    terraform-docs markdown table "${dir}" --output-file README.md
done
