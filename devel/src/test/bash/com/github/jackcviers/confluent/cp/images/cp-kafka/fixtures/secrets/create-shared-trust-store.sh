#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

if [[ -z "${KAFKA_SSL_TRUSTSTORE_CREDENTIALS}" ]]; then
    echo "KAFKA_SSL_TRUSTSTORE_CREDENTIALS env var is required!" && exit 1
fi

if [[ -z "${KAFKA_SSL_TRUSTSTORE_FILENAME}" ]]; then
    echo "KAFKA_SSL_TRUSTSTORE_FILENAME env var is required!" && exit 1
fi

create-shored-trust-store(){
    local server_trust_creds=$(cat /etc/kafka/secrets/${KAFKA_SSL_TRUSTSTORE_CREDENTIALS})
    local server_trust_file_name=$KAFKA_SSL_TRUSTSTORE_FILENAME

    #this should only have to be run once per cluster, on a shared storage space
    rm -rf /etc/kafka/secrets/${server_trust_file_name}
    keytool -keystore /etc/kafka/secrets/${server_trust_file_name} -alias CARoot \
	    -import -file ca-cert -storepass ${server_trust_creds} \
	    -keypass ${server_trust_creds} -noprompt -ext SAN=DNS:$(hostname --fqdn),DNS:localhost

    keytool -keystore /etc/kafka/secrets/${server_trust_file_name} -list -v -storepass confluent -keypass confluent
}

create-shored-trust-store
