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


###prereqs:-
before running the playbooks, you need to prep a centos7 box with an ansible client:-
1) set hostname:-
hostnamectl set-hostname  shortname.domain.suffix   e.g. bill.example.com

2)create ansible user, login, create ssh key, set ansible control node to have passwordless access
sudo su -
useradd ansible   (where ansible = username)
sudo su - ansible
ssh-keygen -t rsa (accept all defaults)
touch /home/ansible/.ssh/authorized_keys; chmod 600 /home/ansible/.ssh/authorized_keys

3) copy the ansible controller's ssh pub key to the authorized_keys file you just created on client

4) edit sudo file on client to allow ansible user to run all commands:-
visudo  
-add following line at bottom:
ansible	ALL=(ALL:ALL) ALL


ansible-playbook --ask-vault-pass /etc/ansible/playbook/syslogng-server.yml

