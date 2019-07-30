Role Name
=========

Syslog-NG Client role with two way encrypted communication to Syslog-NG server using certificates for OULib.

Requirements
------------

A target system running CentOS7x and a configured Syslog-NG server for logging destination.

Role Variables
--------------

There are two sets of variables needed for the myvars.yml file. 1 set for the client and 1 set for the server.

Client Variables:

	syslogng_client_ip: 10.255.255.11
	syslogng_dn_prefix: syslogngclient
	syslogng_dn_suffix: vagrant.localdomain

Server Variables

	syslogng_server_ip: 10.255.255.10
	syslogng_server_prefix: syslogng
	syslogng_server_suffix: vagrant.localdomain
	syslogng_server_protocol: tls
	syslogng_server_port: 514

	syslogng_server_cert: |
	  -----BEGIN CERTIFICATE-----
	  <paste server certificate>
	  -----END CERTIFICATE-----

Dependencies
------------

* [OU Libraries Centos7 Role](https://github.com/OULibraries/ansible-role-centos7)
* [OU Libraries Users Role](https://github.com/OULibraries/ansible-role-users)

This role configures the client for logging of syslogs. The companion role is the Syslog-NG Server Role, which is used to configure the sever on the network. Once the server has been deployed on the network, simply copy the server SSL certificate into your my-vars.yml file and insert the server IP address and domain name.

* [OU Libraries Syslog-NG Server Role](https://github.com/OULibraries/ansible-role-syslogng)


Example Playbook
----------------

Make sure to change the client variables in the my-vars.yml file for each client on the network.

License
-------

[MIT](https://github.com/OULibraries/ansible-role-syslogng-client/blob/master/LICENSE)

Author Information
------------------

Chris Cone @ OU Libraries

