OULibraries.centos7
=========

This role adds users and ssh keys, confiures ssh, and configures sudoers.

Requirements
------------

A target system running CentOS/RHEL. 

Role Variables
--------------

### User Config


Define users and the groups they should get as follows:

```
# Admin users (wheel membership is automatic)
users_admin_groups: "tomcat,apache"
users_admin_users:
  - name: 'admin'
    pubkey: 'ssh-rsa somepubkey admin@example.org'
  - name: 'otheradmin'
    pubkey: 'ssh-rsa anotherpubkey otheradmin@example.org'


# Normal users 
users_std_groups: apache
users_std_users:
  - name: 'tester'
    pubkey: 'ssh-rsa somepubkey tester@example.org'
```

You may optionally define users_secure_path to allow sudo to work as expected with executables in arbitrary locations, eg.

```
users_secure_path: '/opt/somevendor/someproduct/bin:/sbin:/bin:/usr/sbin:/usr/bin'
```

### SSH Config

To enable outgoing ssh, you'll need to define one or more ssh brokers in the 'ssh_brokers' var, eg.
Note that dn suffix is the domain name space for the servers you will reach through the broker.

```
ssh_brokers:
  - alias: 'mybroker'
    ip: '192.168.1.2'
    dn_suffix: 'example.org'
```

You may optionally define conditional sshd_config via Match. To do so, specify the 'sshd_match' var, eg.

```
sshd_match:
  - criteria:
      - 'User'
      - 'centos'
      - 'Address'
      - '192.168.1.*'
    overrides:
      - keyword: 'PasswordAuthentication'
        value: 'no'
      - keyword: 'MaxAuthTries'
        value: '10'
```

would result in the following block of config:

```
# Match exceptions
Match User centos Address 192.168.1.*
  PasswordAuthentication no
  MaxAuthTries 10
```


Dependencies
------------
No special dependencies. 


License
-------

[MIT](https://github.com/OULibraries/ansible-role-users/blob/master/LICENSE)

Author Information
------------------

OU Libraries

