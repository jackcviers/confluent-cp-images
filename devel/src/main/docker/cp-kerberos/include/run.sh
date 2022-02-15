#!/bin/bash

set -e

service krb5-kdc start
service krb5-admin-server start

tail -F /var/log/krb5kdc.log /var/log/kadmin.log /var/log/krb5lib.log
