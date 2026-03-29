#!/bin/bash
USER="yeghia"
declare -a IPs=("10.0.0.238" "10.0.0.251" "10.0.0.160" "10.0.0.161" "10.0.0.162" "10.0.0.163" "10.0.0.164")

for HOST in "${IPs[@]}"; do
     ssh $USER@$HOST 'sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
done
