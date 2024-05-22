#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables as an error

# Setup Env
export ACCOUNT_ID=503489311732 \
    TF_ROLE_ARN=arn:aws:iam::503489311732:role/terraform_role \
    REGION=us-east-2 \
    AWS_PROFILE=noise

# Define environments
environments=("dev" "staging" "prod")

# Function to run terragrunt with the terraform_role
run_initial_setup() {
    local env=$1
    echo "Running initial setup for environment: ${env}"

    export AWS_ACCESS_KEY_ID="your-access-key"
    export AWS_SECRET_ACCESS_KEY="your-secret-key"
    export AWS_DEFAULT_REGION="your-region"

    # Change to the environment directory
    cd environments/${env}

    # Run Terragrunt to provision resources
    terragrunt init
    terragrunt plan -out=tfplan
    terragrunt apply -auto-approve tfplan

    cd - # Go back to the previous directory
}

# Function to run terragrunt with environment-specific roles
run_with_env_role() {
    local env=$1
    echo "Running Terragrunt with environment-specific role for: ${env}"

    # Assume the environment-specific role (replace with actual role ARN)
    eval $(aws sts assume-role --role-arn arn:aws:iam::$ACCOUNT_ID:role/${env}_role --role-session-name terragrunt_session --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text | awk '{ print "export AWS_ACCESS_KEY_ID="$1" AWS_SECRET_ACCESS_KEY="$2" AWS_SESSION_TOKEN="$3 }')

    # Change to the environment directory
    cd environments/${env}

    # Run Terragrunt to enforce tagging
    terragrunt plan -out=tfplan
    terragrunt apply -auto-approve tfplan

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
