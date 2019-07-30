#!/usr/bin/env bash

# Print out current shell user info in suitable format for OUlibraries.users

# Stupidly print stuff that looks like YAML.
printf "users:\n"

# Get a list of users on the system
for user in $(cut -d: -f1 /etc/passwd | sort); do

  # The path to the keyfile. For convenience and DRYness. 
  keypath=/home/${user}/.ssh/authorized_keys

  # Check for those with SSH keys
  if [ -f ${keypath} ]; then

    # Get a group membership list that exlcudes this user's own group
    groups=$(groups ${user} | sed "s#${user}##g" | cut -d ':' -f '2' | xargs |  tr ' ' ',')

    # Get the date that the authorized_keys file was last touched
    keyage=$(stat ${keypath} | grep 'Modify' | cut -d ' ' -f 2)

    # Get the pubkey
    pubkey=$(head -1 /home/${user}/.ssh/authorized_keys)

    # Stupidly print stuff that looks like YAML.
    printf "  - name: '${user}'\n    groups: '${groups}'\n    keyname: '${user}-${keyage}'\n    pubkey: '${pubkey}'\n"
  fi
done
