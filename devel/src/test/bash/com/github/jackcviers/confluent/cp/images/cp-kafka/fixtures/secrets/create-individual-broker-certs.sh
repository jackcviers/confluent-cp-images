#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

if [[ -z "${CERT_VALIDITY_DAYS}" ]]; then
    echo "CERT_VALIDITY_DAYS env var is required!" && exit 1
fi

if [[ -z "${KAFKA_SSL_KEYSTORE_CREDENTIALS}" ]]; then
    echo "KAFKA_SSL_KEYSTORE_CREDENTIALS env var is required!" && exit 1
fi

if [[ -z "$KAFKA_SSL_KEYSTORE_FILENAME" ]]; then
    echo "KAFKA_SSL_KEYSTORE_FILENAME env var is required!" && exit 1
fi

create-individual-broker-certs(){

    local server_creds=$(cat /etc/kafka/secrets/${KAFKA_SSL_KEYSTORE_CREDENTIALS})
    local fqdn="$(hostname --fqdn)"
    local server_file_name=$KAFKA_SSL_KEYSTORE_FILENAME

    rm -rf /etc/kafka/secrets/${server_file_name}
    keytool -keystore /etc/kafka/secrets/${server_file_name} --alias server \
	    -validity ${CERT_VALIDITY_DAYS} -genkey -keyalg RSA \
	    -storepass ${server_creds} -keypass ${server_creds} \
	    -storetype pkcs12 -dname "CN=${fqdn}" -ext SAN=DNS:${fqdn},DNS:localhost

    keytool -keystore /etc/kafka/secrets/${server_file_name} -certreq \
	    -alias server -file server-cert-file -storepass ${server_creds} \
	    -keypass ${server_creds} -ext SAN=DNS:${fqdn},DNS:localhost

    openssl x509 -req -CA ca-cert -CAkey ca-key -in server-cert-file \
	    -out server-cert-file-signed -days ${CERT_VALIDITY_DAYS} \
	    -CAcreateserial -passin pass:${server_creds}

    sleep 5
    echo "===================================================="
    openssl x509 -in server-cert-file-signed -text -noout
    echo "===================================================="
    sleep 5

    keytool -keystore /etc/kafka/secrets/${server_file_name} -alias CARoot \
	    -import -file ca-cert -storepass ${server_creds} \
	    -keypass ${server_creds} -noprompt -ext SAN=DNS:${fqdn},DNS:localhost

    keytool -keystore /etc/kafka/secrets/${server_file_name} -import \
	    -alias server -file server-cert-file-signed \
	    -storepass ${server_creds} -keypass ${server_creds} -noprompt

    keytool -keystore /etc/kafka/secrets/${server_file_name} -list -v -storepass confluent -keypass confluent
}

create-individual-broker-certs
