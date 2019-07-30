#!/usr/bin/env bash

# Print out current secure_path info in suitable format for OUlibraries.users

securepath=$(grep 'secure_path' /etc/sudoers | cut -d '=' -f 2 | xargs)

# Stupidly print stuff that looks like YAML.
printf "users_secure_path: '$securepath'\n"
