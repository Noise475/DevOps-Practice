#!/bin/bash

### Only run this file from the ./terragrunt directory ###

# set -e # Exit immediately if a command exits with a non-zero status; Will close IDE terminal
set -u # Treat unset variables as an error

# Define environments
environments=("dev" "staging") # Add "prod" as needed

# Function to run terragrunt for an environment
run_terragrunt() {
    local env=$1
    export ENVIRONMENT=$env
    export ACCOUNT_ID=590183659157
    export REGION=us-east-2


    echo "Running terragrunt for environment: ${env}"

    # Assume the terraform_role and set AWS credentials
    source ./assume-role.sh $TF_ROLE_ARN $AWS_PROFILE

    # Get the environment-specific role ARN
    export ROLE_ARN=$(terragrunt output -raw ou_role_arn)

    # Change to the environment directory
    cd environments/${env}

    # Run Terragrunt to provision resources
    terragrunt init
    terragrunt run-all plan --terragrunt-non-interactive -out=tfplan
    terragrunt run-all apply --terragrunt-non-interactive tfplan

    cd - # Go back to root directory
}

# Loop through each environment and run Terragrunt
for env in "${environments[@]}"; do
    run_terragrunt $env
done

echo "Provisioning completed for ${environments}."
