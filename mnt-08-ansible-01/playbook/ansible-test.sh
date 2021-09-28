#!/bin/bash
docker start centos7 ubuntu fedora
ansible-playbook -i inventory/prod.yml --vault-password-file  ~/vault-pwd site.yml
docker stop centos7 ubuntu fedora