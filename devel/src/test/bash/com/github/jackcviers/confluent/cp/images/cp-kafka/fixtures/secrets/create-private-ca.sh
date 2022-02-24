#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

if [[ -z "${CERT_VALIDITY_DAYS}" ]]; then
    echo "CERT_VALIDITY_DAYS env variable is required!" && exit 1
fi

openssl version

openssl req -new -days ${CERT_VALIDITY_DAYS} -x509 -keyout ca-key \
	-out ca-cert -nodes \
	-subj "/C=US/ST=IA/O=Github Jackcviers/CN=$(hostname --fqdn)" \
	-passin pass:confluent

openssl x509 -noout -modulus -in ca-cert | openssl md5
openssl rsa -noout -modulus -in ca-key | openssl md5

	     
