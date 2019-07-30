## building syslogng client & server using Ansible roles & playbook ##

### terms:
syslogng client = local log forwarder
syslogng server = log relay

#### Playbooks
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


### prereqs: install ansible client:-
before running the playbooks, you need to prep a centos7 box with an ansible client:
1) set hostname:-
hostnamectl set-hostname  shortname.domain.suffix   e.g. bill.example.com

2) create ansible user, login, create ssh key, set ansible control node to have passwordless access
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



if you need to install both a syslogng client(log forwarder) and a syslogng server (log relay) , do this first! 

### installing a syslogng server (log relay)
1) update the /etc/ansible/hosts file with the local ip of the syslogng server

before you run the syslogng server playbook you need to setup the variables for the syslogng server role:-
/etc/ansible/roles/ansible-role-syslogng
the variables are in /etc/ansible/roles/ansible-role-syslogng/vars/main.yml
ansible-playbook --ask-vault-pass /etc/ansible/playbook/syslogng-server.yml

	#syslogng-server###server-variables
	syslogng_server_ip: [put server local ip here]
	syslogng_dn_prefix: [put server shortname here]
	syslogng_dn_suffix: [put server domain name here e.g. example.com]
	syslogng_server_protocol: tls
	syslogng_server_port: 514

	#syslogng-server###client-variables
	syslogng_client_ip: [add client local ip here - later on!]
	syslogng_client_prefix: [add client shortname here  - later on!]
	syslogng_client_suffix: [add client domain name here e.g. example.com  - later on!]
	syslogng_client_cert: |
	  <client cert goes here  - later on!>
	  -----END CERTIFICATE-----


### installing a syslogng client (local log forwarder)

### test the log forwarding is working:-
1) on syslogng-server (log-relay) look under /var/log/syslog-ng
you should see a directory for each client, where directory name is same as client fqdn hostname.
under this is a set of date folders and a syslogng logfile
if you run a tail -f on this client logfile and then in a separate window, but on the syslogng client, run a logger command ( run logger 'type something random' ) you should see the message pop up in the window
