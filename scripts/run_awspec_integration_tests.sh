#!/usr/bin/env bash
set -eo pipefail

export ENVIRONMENT=$1
export AWS_ACCOUNT_ID=$(jq -r .aws_account_id < ${ENVIRONMENT}.auto.tfvars.json)
export AWS_ASSUME_ROLE=$(jq -r .aws_assume_role < ${ENVIRONMENT}.auto.tfvars.json)

aws sts assume-role --output json --role-arn arn:aws:iam::"${AWS_ACCOUNT_ID}":role/"${AWS_ASSUME_ROLE}" --role-session-name psk-aws-platform-vpc > credentials

export AWS_ACCESS_KEY_ID=$(jq -r ".Credentials.AccessKeyId" < credentials)
export AWS_SECRET_ACCESS_KEY=$(jq -r ".Credentials.SecretAccessKey" < credentials)
export AWS_SESSION_TOKEN=$(jq -r ".Credentials.SessionToken" < credentials)
export AWS_DEFAULT_REGION=$(jq -r .aws_region < ${ENVIRONMENT}.auto.tfvars.json)

rspec test/psk_aws_platform_vpc_spec.rb --format documentation
