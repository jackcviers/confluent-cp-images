#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

if [[ -z "${KAFKA_BROKER_ID}" ]]; then
    echo "KAFKA_BROKER_ID env variable is required!" && exit 1
fi

if [[ -z "${CERT_VALIDITY_DAYS}" ]]; then
    echo "CERT_VALIDITY_DAYS env variable is required!" && exit 1
fi

if [[ -z "${KAFKA_SSL_KEYSTORE_CREDENTIALS}" ]]; then
    echo "KAFKA_SSL_KEYSTORE_CREDENTIALS env var is required!" && exit 1
fi

if [[ -z "$KAFKA_SSL_KEYSTORE_FILENAME" ]]; then
    echo "KAFKA_SSL_KEYSTORE_FILENAME env var is required!" && exit 1
fi

if [[ -z "${KAFKA_SSL_TRUSTSTORE_CREDENTIALS}" ]]; then
    echo "KAFKA_SSL_TRUSTSTORE_CREDENTIALS env var is required!" && exit 1
fi

if [[ -z "${KAFKA_SSL_TRUSTSTORE_FILENAME}" ]]; then
    echo "KAFKA_SSL_TRUSTSTORE_FILENAME env var is required!" && exit 1
fi

if [[ -z "${CLIENT_KAFKA_SSL_TRUSTSTORE_FILENAME}" ]]; then
    echo "CLIENT_KAFKA_SSL_TRUSTSTORE_FILENAME env var is required!" && exit 1
fi

generate_ssl(){
    local ca_key_filename=""
    local ca_cert_filename=""
    local fqdn="$(hostname --fqdn)"
    local keystore_to_check=/etc/kafka/secrets/ssl-cluster-bridged-client-trustore.jks
    local cluster_ca_cert_1_in_client_store=false
    local cluster_ca_cert_2_in_client_store=false
    local cluster_ca_cert_3_in_client_store=false

    #key generation only needs to be done on the master ssl broker
    if [[ -z "${MASTER_SSL}" ]]; then
	#the ca cert is added to the client trust store as the last
	#step in cert generation, so we check the client store for all
	#three certs. The stores are deleted when the test tears down,
	#so existence of the alias is enough.
	echo "Waiting for key generation..."
	while [[ ! cluster_ca_cert_1_in_client_store && ! cluster_ca_cert_2_in_client_store && ! cluster_ca_cert_3_in_client_store ]];
	do
	    keytool -list -storepass confluent -keystore $keystore_to_check -alias kafka-ssl-bridged-1-caroot 2>&1 | grep -q -v '"Alias <kafka-ssl-bridged-1-caroot> does not exist" => false' && cluster_ca_cert_1_in_client_store=true | cluster_ca_cert_1_in_client_store=false
	    keytool -list -storepass confluent -keystore $keystore_to_check -alias kafka-ssl-bridged-2-caroot 2>&1 | grep -q -v '"Alias <kafka-ssl-bridged-2-caroot> does not exist" => false' && cluster_ca_cert_2_in_client_store=true | cluster_ca_cert_2_in_client_store=false
	    keytool -list -storepass confluent -keystore $keystore_to_check -alias kafka-ssl-bridged-3-caroot 2>&1 | grep -q -v '"Alias <kafka-ssl-bridged-3-caroot> does not exist" => false' && cluster_ca_cert_3_in_client_store=true | cluster_ca_cert_3_in_client_store=false
	    sleep 5
	done
	/etc/confluent/docker/run
    else
	#create and sign the certs in the key and truststores for each broker
	for broker_number in 1 2 3
	do
	    ca_key_filename=/etc/kafka/secrets/ssl-cluster-ca-key-${broker_number}
	    ca_cert_filename=ssl-cluster-ca-cert-${broker_number}
	    openssl req -new -days ${CERT_VALIDITY_DAYS} -x509 \
		    -keyout ${ca_key_filename} -out ${ca_cert_filename} \
		    -nodes \
		    -subj "/C=US/ST=IA/O=Github Jackcviers/CN=kafka-ssl-${broker_number}" \
		    -passin pass:confluent
	
	    keytool -keystore /etc/kafka/secrets/ssl-cluster-bridged-broker${broker_number}-keystore.jks \
		    --alias ssl-cluster-bridged-broker-${broker_number} \
		    -validity ${CERT_VALIDITY_DAYS} -genkey -keyalg RSA \
		    -storepass confluent -keypass confluent \
		    -storetype pkcs12 -dname "CN=kafka-ssl-${broker_number}" \
		    -ext SAN=DNS:kafka-ssl-${broker_number},DNS:localhost

	    keytool -keystore /etc/kafka/secrets/ssl-cluster-bridged-broker${broker_number}-keystore.jks \
		    -certreq \
		    -alias ssl-cluster-bridged-broker-${broker_number} \
		    -file ssl-cluster-bridged-server-cert-file-${broker_number} \
		    -storepass confluent \
		    -keypass confluent

	    openssl x509 -req -CA ${ca_cert_filename} \
		    -CAkey ${ca_key_filename} -in ssl-cluster-bridged-server-cert-file-${broker_number} \
		    -out ssl-cluster-bridged-server-cert-file-signed-${broker_number} \
		    -days ${CERT_VALIDITY_DAYS} \
		    -CAcreateserial -passin pass:confluent

	    keytool \
		-keystore /etc/kafka/secrets/ssl-cluster-bridged-broker${broker_number}-keystore.jks \
		-alias kafka-ssl-bridged-${broker_number}-caroot \
		-import -file ${ca_cert_filename} -storepass confluent \
		-keypass confluent -noprompt \
		-ext SAN=DNS:kafka-ssl-${broker_number},DNS:localhost

	    keytool \
		-keystore /etc/kafka/secrets/ssl-cluster-bridged-server-truststore.jks \
		-alias kafka-ssl-bridged-${broker_number}-caroot \
		-import -file ${ca_cert_filename} -storepass confluent \
		-keypass confluent -noprompt \
		-ext SAN=DNS:kafka-ssl-${broker_number},DNS:localhost

	    keytool \
		-keystore /etc/kafka/secrets/ssl-cluster-bridged-broker${broker_number}-keystore.jks \
		-import -alias kafka-ssl-bridged-${broker_number} \
		-file ssl-cluster-bridged-server-cert-file-signed-${broker_number} \
		-storepass confluent -keypass confluent -noprompt
	    
	    keytool \
		-keystore /etc/kafka/secrets/ssl-cluster-bridged-client-trustore.jks \
		-alias kafka-ssl-bridged-${broker_number}-caroot \
		-import -file ${ca_cert_filename} -storepass confluent \
		-keypass confluent -noprompt \
		-ext SAN=DNS:kafka-ssl-${broker_number},DNS:localhost
	done
	/etc/confluent/docker/run
    fi
}

generate_ssl
