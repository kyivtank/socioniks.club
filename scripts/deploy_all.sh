#!/bin/bash
IP=`cat terraform/terraform.out |grep PUBLIC_IP |sed 's/PUBLIC_IP = //'|sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`
echo "Check ssh connection to $IP"
ssh -i $private_key -o StrictHostKeyChecking=no ubuntu@$GD_DOMAIN uptime
echo "Run Ansible Playbook for $IP"
ansible-playbook --private-key $private_key -i ansible/inventory/socioniks.club ansible/setup_wordpress.yml --extra-vars "target_host=$IP"
