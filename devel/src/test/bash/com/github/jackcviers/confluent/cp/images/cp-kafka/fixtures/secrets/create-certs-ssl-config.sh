#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

#For testing, we need a private ca to sign with
/etc/kafka/secrets/create-private-ca.sh
#we need to create signed certs for each broker with its fqdn
/etc/kafka/secrets/create-individual-broker-certs.sh
#We need to create a single, shared trust store with signed certs
/etc/kafka/secrets/create-shared-trust-store.sh
#We need to create a single, shared trust store for clients
/etc/kafka/secrets/create-shared-client-trust-store.sh

# tail -f /dev/null
/etc/confluent/docker/run

