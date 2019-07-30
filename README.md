# building syslogng client & server using Ansible roles & playbook #

## terms:
syslogng client = local log forwarder
syslogng server = log relay

## PLAYBOOKS 
are here:-
/etc/ansible/playbook

## playbook names:-
syslogng-clients.yml 
syslogng-server.yml

## ROLES:-
are here:-
/etc/ansible/roles

## role names:-
ansible-hardening  [https://github.com/openstack/ansible-hardening]
ansible-role-syslogng-client (from https://github.com/OULibraries/ansible-role-syslogng-client)
configure-syslogng
install-syslogng
ansible-role-syslogng
ansible-role-users 
hardening-syslogng



ansible-playbook --ask-vault-pass /etc/ansible/playbook/syslogng-server.yml

