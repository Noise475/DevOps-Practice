#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables as an error

# Setup Env
export ACCOUNT_ID=503489311732 TF_ROLE_ARN=arn:aws:iam::503489311732:role/terraform_role REGION=us-east-2 AWS_PROFILE=noise

# Define environments
environments=("dev") # "stage" "prod")
role_arn=$TF_ROLE_ARN

# Initial setup function using terraform_role
run_initial_setup() {
    local env=$1
    echo "Running initial setup for environment: ${env}"

    source ./assume-role.sh $TF_ROLE_ARN $AWS_PROFILE

    # Change to the environment directory
    cd environments/${env}

    # Run Terragrunt to provision resources
    terragrunt init
    terragrunt run-all plan -out=tfplan
    terragrunt run-all apply -auto-approve tfplan

    cd - # Go back to the previous directory
}

# Function to run terragrunt with environment-specific roles
run_with_env_role() {
    local env=$1
    echo "Running Terragrunt with environment-specific role for: ${env}"

    # Assume the environment-specific role (replace with actual role ARN)
    role_arn_var="${env^^}_ROLE_ARN" # Converts env to uppercase to match the variable names
    eval role_arn=\$$role_arn_var

    source ./assume-role.sh $TF_ROLE_ARN $AWS_PROFILE

    # Change to the environment directory
    cd environments/${env}

    # Run Terragrunt to enforce tagging
    terragrunt run-all plan -out=tfplan
    terragrunt run-all apply -auto-approve tfplan

    cd - # Go back to the previous directory
}

# Loop through each environment and run the initial setup
for env in "${environments[@]}"; do
    run_initial_setup ${env}
done

# Loop through each environment and run Terragrunt with environment-specific roles
for env in "${environments[@]}"; do
    run_with_env_role ${env}
done

echo "Initial setup and tagging completed for all environments."
