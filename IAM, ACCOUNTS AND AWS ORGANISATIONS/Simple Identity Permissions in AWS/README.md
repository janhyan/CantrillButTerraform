## [DEMO] Simple Identity Permissions in AWS

This Terraform config will deploy a CloudFormation stack for IAM users with assigned permissions from managed policies in AWS. This deployment will only cover Adrian Cantrill's 1-Click Deployment written on CloudFormation.

This template implements an IAM user 'Sally'
An S3 bucket for cat pictues
An S3 bucket for dog pictures
An S3 bucket for other animals
And permissions appropriate for Sally.