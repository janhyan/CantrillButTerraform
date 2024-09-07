# Configuring A4L public subnets and Jumpbox
This is a continuation of "Implement multi-tier VPC subnets"

This demo exercise by Cantrill mplements an Internet Gateway, Route Tables and Routes within the Animals4life VPC to support the WEB public subnets.

Once the WEB subnets are public, we create a bastion host with public IPv4 addressing and connect to it to test.

By the end of this demo you will have a fully working public capable VPC and bastion ingress point.



