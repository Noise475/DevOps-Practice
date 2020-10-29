eksctl create cluster \
--name test \
--version 1.17 \
--region us-east-2 \
--node-type t3.micro \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--managed \
--asg-access
