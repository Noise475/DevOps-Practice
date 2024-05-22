#!/bin/bash

#set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables as an error

# Define environments
environments=("dev" "staging") # "prod")
role_arn=($TF_ROLE_ARN)

# Initial setup function using terraform_role
run_initial_setup() {
    local env=$1
    export ENVIRONMENT=$env

    echo "Running initial setup for environment: ${env}"

    source ./assume-role.sh $TF_ROLE_ARN $AWS_PROFILE

    # Make sure IAM roles are created
    cd iam
    terragrunt init
    terragrunt plan -out=tfplan
    # terragrunt apply tfplan
    cd -

    export ROLE_ARN=$(terragrunt output -raw ou_role_arn)

    # Change to the environment directory
    cd environments/${env}

    # Run Terragrunt to provision resources
    terragrunt init
    terragrunt run-all plan --terragrunt-non-interactive -out=tfplan
    #terragrunt run-all apply --terragrunt-non-interactive tfplan

    cd - # Go back to root directory
}

# Function to run terragrunt with environment-specific roles
run_with_env_role() {
    local env=$1
    echo "Running Terragrunt with environment-specific role for: ${env}"

    # Assume the environment-specific role (replace with actual role ARN)
    role_arn_var="${env^^}_ROLE_ARN" # Converts env to uppercase to match the variable names
    eval role_arn=\$$role_arn_var

    source ./assume-role.sh $TF_ROLE_ARN $AWS_PROFILE

    # Make sure IAM roles are created
    cd iam
    terragrunt init
    terragrunt plan -out=tfplan
    # terragrunt apply tfplan
    cd -

    export ROLE_ARN=$(terragrunt output -raw ou_role_arn)

    # Change to the environment directory
    cd environments/${env}

    # Run Terragrunt to enforce tagging
    terragrunt run-all plan --terragrunt-non-interactive -out=tfplan
    #terragrunt run-all apply --terragrunt-non-interactive tfplan

    cd - # Go back to the previous directory
}

# Loop through each environment and run the initial setup
for env in "${environments[@]}"; do
    run_initial_setup ${env}
done

# Loop through each environment and run Terragrunt with environment-specific roles
# for env in "${environments[@]}"; do
#     run_with_env_role ${env}
# done

# echo "Initial setup and tagging completed for all environments."
