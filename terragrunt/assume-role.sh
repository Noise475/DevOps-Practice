#!/bin/bash

# Usage: ./assume-role.sh <role-arn> <session-name>

# Check if required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <role-arn> <session-name>"
    exit 1
fi

role_arn="$1"
session_name="$2"

# Assume the IAM role and retrieve temporary credentials
credentials=$(aws sts assume-role --role-arn "$role_arn" --role-session-name "$session_name")


# Extract the temporary credentials from the JSON response
aws_access_key_id=$(echo "$credentials" | jq -r .Credentials.AccessKeyId)
aws_secret_access_key=$(echo "$credentials" | jq -r .Credentials.SecretAccessKey)
aws_session_token=$(echo "$credentials" | jq -r .Credentials.SessionToken)

# Set AWS CLI environment variables
export AWS_ACCESS_KEY_ID="$aws_access_key_id"
export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
export AWS_SESSION_TOKEN="$aws_session_token"

# Optionally, update AWS CLI configuration file
# aws configure set aws_access_key_id "$aws_access_key_id"
# aws configure set aws_secret_access_key "$aws_secret_access_key"
# aws configure set aws_session_token "$aws_session_token"

echo "Temporary credentials obtained and configured."
