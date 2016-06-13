# docker-swarmkit-terraform

Small terraform project to play around with Docker Swarmkit on Digital Ocean

## Goal
Setup swarmkit on a master (management) node and add a worker to the swarmkit cluster.

## Instructions
##  Cloning

Clone this repository

## Building swarmkit
Run the following commands to build swarmkit locally

```
git clone https://github.com/docker/swarmkit.git
```

Build the swarmkit binaries from source (assuming you run Docker locally)

```
docker run -it -v `pwd`/swarmkit:/go/src/github.com/docker/swarmkit golang:1.6 /bin/bash
```

Move the binaries to the bin/ folder

```
mv swarmkit/bin/* bin/
```

## Setup terraform

Supply your variables by copying `terraform.tfvars.example` to `terraform.tfvars`. Use paths to the private and public keys.
```
do_token = ""
pub_key = ""
pvt_key = ""
ssh_fingerprint = ""
```

## Running terraform
Run `terraform plan` and `terraform apply` to build the infrastructure.

## Using swarmkit

When terraform is done the IP of the master node will be echoed. Use your provided private key from the variables to connect to the master node. Run `swarmctl node ls` to check if all nodes are available

The command should output something like
```
ID             Name                Membership  Status  Availability  Manager status
--             ----                ----------  ------  ------------  --------------
055ioyh1iqevb  swarmkit-worker-01  ACCEPTED    READY   ACTIVE
0ue5up2z7dd4b  swarmkit-mgmt-01    ACCEPTED    READY   ACTIVE        REACHABLE *
```

Use `swarmctl --help` and the README from swarmkit to find out what commands are available. Happy testing!

## TODO

* Thou shall not run as root!
* Build a service from swarmkit
* Build swarmkit in the cloud instead of locally
* Use multiple workers instead of one
