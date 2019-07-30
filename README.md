
## building syslogng client & server using Ansible roles & playbook ##

<br/>

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

<br/>

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

       sudo su -
       visudo  
add following line at bottom:

       ansible ALL=(ALL:ALL)           NOPASSWD: ALL

5) on the ansible controller, test the passwordless ssh has been correctly setup:-

       ssh ansible@[internal client ip]  ls -l
<br/>
<br/>



if you need to install both a syslogng client(log forwarder) and a syslogng server (log relay) , do this first! 

### installing a syslogng server (log relay)
1) update the /etc/ansible/hosts file with the local ip of the syslogng server
identify localhost internal ip:-

       hostname -i
	
add to [syslogng_servers] section of /etc/ansible/hosts

before you run the syslogng server playbook you need to setup the variables for the syslogng server role, and only edit the first 3 entries (i.e. ignore syslog_client variables  further down):-

    vi /etc/ansible/roles/ansible-role-syslogng/vars/main.yml

	#syslogng-server###server-variables
	syslogng_server_ip: [put server/relay local ip here    i.e. hostname -i ]
	syslogng_dn_prefix: [put server/relay shortname here   i.e. hostname -s ]
	syslogng_dn_suffix: [put server/relay domain name here     i.e. hostname -d]
	syslogng_server_protocol: tls
	syslogng_server_port: 514

    #syslogng-server###client-variables
    #syslogng_client_ip: 
    #syslogng_client_prefix: 
    #syslogng_client_suffix: 
    #syslogng_client_cert: |
    #<client cert goes here>
    #-----END CERTIFICATE-----

then run the playbook:-

    ansible-playbook /etc/ansible/playbook/syslogng-server.yml

<br/>

### installing a syslogng client (local log forwarder)

1) update the /etc/ansible/hosts file with the local ip of the syslogng client
identify localhost internal ip:-

       hostname -i
	
add to [syslogng_clients] section of /etc/ansible/hosts

before you run the syslogng client playbook you need to setup the variables for the syslogng client role, and only edit the first 3 entries (i.e. ignore syslog_client variables  further down):-

    vi /etc/ansible/roles/ansible-role-syslogng-client/vars/main.yml
    #syslogng-client###client-variables
    syslogng_client_ip: [local client/forwarder ip here   i.e. hostname -i ]
    syslogng_dn_prefix: [local shortname here   i.e. hostname -s]
    syslogng_dn_suffix: [client domain name     i.e. hostname -d]

    #syslogng-client###server-variables
    syslogng_server_ip: [local server/relay ip here]
    syslogng_server_prefix: [server/relay short hostname]
    syslogng_server_suffix: [server/relay domain name]
    syslogng_server_protocol: tls
    syslogng_server_port: 514
    syslogng_server_cert: |
      -----BEGIN CERTIFICATE-----
      -----END CERTIFICATE-----


then run the playbook:-

    ansible-playbook /etc/ansible/playbook/syslogng-server.yml





### test the log forwarding is working:-
1) on syslogng-server (log-relay) look under /var/log/syslog-ng
you should see a directory for each client, where directory name is same as client fqdn hostname.
under this is a set of date folders and a syslogng logfile
if you run a tail -f on this client logfile and then in a separate window, but on the syslogng client, run a logger command ( run logger 'type something random' ) you should see the message pop up in the window
