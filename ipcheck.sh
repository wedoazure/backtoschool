#!/bin/bash

## NOTE:
##This is some silly bash to output the IP address of the VM.

## get the IP address of the VM
IP=$(curl https://ipinfo.io/ip)

## some formatting
GREEN='\033[0;32m'
NC='\033[0m' # No Color

## output the IP address

printf "\n${NC}The IP address of the VM is: ${GREEN}$IP ${NC}\n\n"

## end of script