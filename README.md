
## building syslogng client(forwarder) & server(relay) with mTLS enabled using Ansible roles & playbook ##
<br/>
<br/>

###   use cases 

  1)  build a syslogng-client & syslog-ng server to test log forwarding in your own/an AWS account
2) in the intended use case we will just need the syslogng-client/log forwarder installing (the syslogng-server /relay is already setup and we will be provided server details via email)
<br/>

#### terms
syslogng client = local log forwarder <br>
syslogng server = log relay
<br/>

#### Playbooks
are here:-

       ls -l /etc/ansible/playbook
       syslogng-clients.yml 
       syslogng-server.yml
<br/>

#### Roles
are here:-
  
     ls -l /etc/ansible/roles

### role names
**ansible-hardening**     source github repo: https://github.com/openstack/ansible-hardening  

**ansible-role-syslogng-client**    source githubrepo: https://github.com/OULibraries/ansible-role-syslogng-client  
**ansible-role-syslogng**           source github repo: https://github.com/OULibraries/ansible-role-syslogng  
**ansible-role-users**              source github repo: https://github.com/OULibraries/ansible-role-users  
**ansible-role-ntp**              source github repo: https://github.com/geerlingguy/ansible-role-ntp.git  

**install-syslogng**  
**configure-syslogng**  
**hardening-syslogng**   

<br/>

### prereqs: install ansible client:-
before running the playbooks, you need to prep a centos7 box with an ansible client:
1) set fully qualified hostname:-

       hostnamectl set-hostname  [  myansibleclient.example.com ]

2) create ansible user, login, create ssh key, set ansible control node to have passwordless access

       sudo su -
       useradd ansible   (where ansible = username)
       sudo su - ansible
       ssh-keygen -t rsa (accept all defaults)
       touch /home/ansible/.ssh/authorized_keys; chmod 600 /home/ansible/.ssh/authorized_keys

3) copy the ansible controller's ssh pub key to the authorized_keys file you just created on client

4) as root user, edit sudo file on client to allow ansible user to run all commands:-

       sudo su -
       visudo  
add following line at bottom:

       ansible ALL=(ALL:ALL)           NOPASSWD: ALL

5) on the ansible controller, test the passwordless ssh has been correctly setup:-

       ssh ansible@[internal client ip]  ls -l

NOTE: if you are setting up an AWS testlab with syslogng client/forwarder & server/relay; setup the syslogng server/relay first
<br/>
<br/>
<br/>
### installing a syslogng server (log relay)
1) update the /etc/ansible/hosts file with the local ip of the syslogng server
identify localhost internal ip:-

       hostname -i
	
add to [syslogng_servers] section of /etc/ansible/hosts

2) setup the variables for the syslogng server role, and edit the ip and dn_prefix/suffix for BOTH client and server but IGNORE the client cert variable (leave blank for now):-

       vi /etc/ansible/roles/ansible-role-syslogng/vars/main.yml
       #syslogng-server###server-variables
       syslogng_server_ip: [put server/relay local ip here    i.e. hostname -i ]
       syslogng_dn_prefix: [put server/relay shortname here   i.e. hostname -s ]
       syslogng_dn_suffix: [put server/relay domain name here  i.e. hostname -d]
       syslogng_server_protocol: tls
       syslogng_server_port: 514

       #syslogng-server###client-variables
       syslogng_client_ip: [syslogng client/forwarder ip here   i.e. hostname -i ]
       syslogng_client_prefix: [syslogng client shortname here   i.e. hostname -s]
       syslogng_client_suffix: [syslogng client domain name     i.e. hostname -d]
       #syslogng_server_cert: |
         -----BEGIN CERTIFICATE-----
         -----END CERTIFICATE-----

3) run the playbook 
**note it will fail on the step [Configure Syslog-ng Client Cert] but this is expected**

       ansible-playbook /etc/ansible/playbook/syslogng-server.yml

then check the pki cert folder and see it has created a server cert folder with pem cert below it (note: it should also create an empty client dir at this point)

    ls -l /etc/pki/tls/certs 
  you should see a directory with the syslogng server name and a pem cert below it
                
       cat /etc/pki/tls/certs/[syslogng-server]/[syslogng-server].pem
       
4) reboot the syslog-ng server/relay

5) once back up after reboot, check syslog-ng is running & logging the local syslogng server/relay itself

       systemctl status syslog-ng.service
       ls -l /var/log/syslog-ng/[syslog-ng fqdn hostname]/YYYY/MM/DD/[syslog-ng fqdn hostname]-YYYY-MM-DD.log
<br/>
<br/>
<br/>

### installing a syslogng client (local log forwarder)

1) update the /etc/ansible/hosts file with the local ip of the syslogng client
identify localhost internal ip:-

       hostname -i
	
add to [syslogng_clients] section of /etc/ansible/hosts

before you run the syslogng client playbook you need to setup the variables for the syslogng client role:-

    vi /etc/ansible/roles/ansible-role-syslogng-client/vars/main.yml
    #syslogng-client###client-variables
    syslogng_client_ip: [syslogng client/forwarder ip here   i.e. hostname -i ]
    syslogng_dn_prefix: [syslogng client shortname here   i.e. hostname -s]
    syslogng_dn_suffix: [syslogng client domain name     i.e. hostname -d]

    #syslogng-client###server-variables
    syslogng_server_ip: [local server/relay ip here]
    syslogng_server_prefix: [server/relay short hostname]
    syslogng_server_suffix: [server/relay domain name]
    syslogng_server_protocol: tls
    syslogng_server_port: 514
    syslogng_server_cert: |
      -----BEGIN CERTIFICATE-----
      [insert the cert from syslogng-server /etc/pki/tls/certs/[syslogng-server]/[syslogng-server]_chain.pem
      -----END CERTIFICATE-----

**NOTE: the cert needs 2 spaces indentation on each line**

2) run the playbook:-

    ansible-playbook /etc/ansible/playbook/syslogng-clients.yml

3) copy newly generated client cert to your clipboard

       ls -l /etc/pki/tls/certs 
     you should see a directory with the syslogng client name and a pem cert below it
                
       cat /etc/pki/tls/certs/[syslogng-client]/[syslogng-client].pem
     
4) add the client certificate to the syslogng **server** role variables file, this time adding in the client certificate that has just been generated, i.e

       vi /etc/ansible/roles/ansible-role-syslogng/vars/main.yml
       #syslogng_client_cert: |
      -----BEGIN CERTIFICATE-----
      [insert the cert from syslogng-client /etc/pki/tls/certs/[syslogng-client]/[syslogng-client]_chain.pem
      -----END CERTIFICATE-----

**NOTE: the cert needs 2 spaces on each line indentation**

5) rerun the server playbook

       ansible-playbook /etc/ansible/playbook/syslogng-server.yml

then check the cert folder on the syslogng server and see it now has both client and server folders with .pem files below

    ls -l /etc/pki/tls/certs 
  you should see a directory with the syslogng server name and a pem cert below it & ditto for the client
                
6) reboot the syslog-ng client/forwarder

7) once back up after reboot, check syslog-ng is running & logging the client/forwarder

       systemctl status syslog-ng.service
       ls -l /var/log/syslog-ng/[syslogng client fqdn hostname]/YYYY/MM/DD/[syslog-ng client fqdn hostname]-YYYY-MM-DD.log

<br/>
<br/>
<br/>



### test the log forwarding is working:-
1) on syslogng-server (log-relay) look under /var/log/syslog-ng
you should see a directory for each client, where directory name is same as client fqdn hostname.
under this is a set of date folders and a syslogng logfile
if you run a tail -f on this client logfile and then in a separate window, but on the syslogng client, run a logger command ( run logger 'type something random' ) you should see the message pop up in the window

2) the acid test!
run a logger test i.e print a random message to your syslog whilst tailing the syslogng-server's copy of the client's forwarded logfile

client:
  
    logger 'this will be a miracle if this log appears on the syslogng-server!!!'

server

    tail -f /var/log/syslog-ng/[syslogng-client fqdn]/YYY/MM/DD/[syslogng-client fqdn]-YYYY-MM-DD.log
