#!/bin/bash

# List of environments
environments=("dev" "staging" "prod")

# Loop through each environment
for environment in "${environments[@]}"
do
    echo "Running Terragrunt for environment: $environment"
    terragrunt apply -var="environment=$environment"
done
