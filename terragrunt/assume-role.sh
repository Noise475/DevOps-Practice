#!/bin/bash

set -u # unset vars cause error

# Usage: ./assume-role.sh <role-arn> <session-name>

# Check if required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <role-arn> <session-name>"
    return 1
fi

role_arn="$1"
session_name="$2"

# Ensure jq is installed
if ! command -v jq &>/dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    return 1
fi

if [ -n "${AWS_SESSION_TOKEN+x}" ]; then
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
fi

# Assume the IAM role and retrieve temporary credentials
credentials=$(aws sts assume-role --role-arn "$role_arn" --role-session-name "$session_name" 2>&1)

# Check if assume-role command was successful
if [ $? -ne 0 ]; then
    echo "Failed to assume role: $credentials"
    return 1
fi

# Extract the temporary credentials from the JSON response
aws_access_key_id=$(echo "$credentials" | jq -r .Credentials.AccessKeyId)
aws_secret_access_key=$(echo "$credentials" | jq -r .Credentials.SecretAccessKey)
aws_session_token=$(echo "$credentials" | jq -r .Credentials.SessionToken)

# Validate that credentials were extracted correctly
if [ -z "$aws_access_key_id" ] || [ -z "$aws_secret_access_key" ] || [ -z "$aws_session_token" ]; then
    echo "Failed to extract temporary credentials from assume-role response."
    return 1
fi

# Set AWS CLI environment variables
export AWS_ACCESS_KEY_ID="$aws_access_key_id"
export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
export AWS_SESSION_TOKEN="$aws_session_token"

# Check identity
identity=$(aws sts get-caller-identity 2>&1)

# Check if get-caller-identity command was successful
if [ $? -ne 0 ]; then
    echo "Failed to get caller identity: $identity"
    return 1
fi

echo "Temporary credentials obtained and configured."
echo "$identity"
