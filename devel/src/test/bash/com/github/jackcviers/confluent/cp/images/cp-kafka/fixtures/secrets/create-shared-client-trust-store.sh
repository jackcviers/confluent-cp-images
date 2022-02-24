#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

if [[ -z "${CLIENT_KAFKA_SSL_TRUSTSTORE_FILENAME}" ]]; then
    echo "CLIENT_KAFKA_SSL_TRUSTSTORE_FILENAME env var is required!" && exit 1
fi

if [ -f "ca-cert" ];
then
    echo ""
else
    echo "ca-cert must exist!" && exit 1
fi

create-shared-client-trust-store(){
    local client_trust_creds=$(cat /etc/kafka/secrets/${CLIENT_KAFKA_SSL_TRUSTSTORE_CREDENTIALS})
    local client_trust_file_name=$CLIENT_KAFKA_SSL_TRUSTSTORE_FILENAME

    #this should only have to be run once per cluster, on a shared storage space
    rm -rf /etc/kafka/secrets/${client_trust_file_name}
    keytool -keystore /etc/kafka/secrets/${client_trust_file_name} -alias CARoot \
	    -import -file ca-cert -storepass ${client_trust_creds} \
	    -keypass ${client_trust_creds} -noprompt -ext SAN=DNS:$(hostame --fqdn),DNS:localhost

    keytool -keystore /etc/kafka/secrets/${client_trust_file_name} -list -v -storepass confluent -keypass confluent
}
create-shared-client-trust-store
