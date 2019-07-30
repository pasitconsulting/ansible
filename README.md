## building syslogng client & server using Ansible roles & playbook ##

### terms:
syslogng client = local log forwarder
syslogng server = log relay

### PLAYBOOKS 
are here:-
/etc/ansible/playbook

### playbook names:-
syslogng-clients.yml 
syslogng-server.yml

### ROLES:-
are here:-
/etc/ansible/roles

### role names:-
ansible-hardening               source github repo: https://github.com/openstack/ansible-hardening  

ansible-role-syslogng-client    source githubrepo: https://github.com/OULibraries/ansible-role-syslogng-client  
ansible-role-syslogng           source github repo: https://github.com/OULibraries/ansible-role-syslogng  
ansible-role-users              source github repo: https://github.com/OULibraries/ansible-role-users  

install-syslogng  
configure-syslogng            
hardening-syslogng  






ansible-playbook --ask-vault-pass /etc/ansible/playbook/syslogng-server.yml

