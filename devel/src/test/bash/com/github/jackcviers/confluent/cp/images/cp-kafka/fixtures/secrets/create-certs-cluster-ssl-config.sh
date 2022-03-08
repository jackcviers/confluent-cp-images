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
    local sec_dir=/etc/kafka/secrets
    local ca_cert_file=${sec_dir}/ca_cert
    local ca_key_file=${sec_dir}/ca_key
    local truststore_credentials=$(cat ${sec_dir}/${KAFKA_SSL_TRUSTSTORE_CREDENTIALS})
    local keystore_credentials=$(cat ${sec_dir}/${KAFKA_SSL_KEYSTORE_CREDENTIALS})
    local client_truststore_credentials=$(cat ${sec_dir}/${CLIENT_KAFKA_SSL_TRUSTSTORE_CREDENTIALS})
    local server_keystore=${sec_dir}/${KAFKA_SSL_KEYSTORE_FILENAME}
    local cluster_truststore=${sec_dir}/${KAFKA_SSL_TRUSTSTORE_FILENAME}
    local client_truststore=${sec_dir}/${CLIENT_KAFKA_SSL_TRUSTSTORE_FILENAME}
    local fqdn="$(hostname --fqdn)"

    if [ "${MASTER_SSL}" = "1" ];then
	rm -rf ${ca_cert_file} ${ca_key_file}
	openssl req -new -days ${CERT_VALIDITY_DAYS} -x509 \
		-keyout ${ca_key_file} \
		-out ${ca_cert_file} -nodes \
		-subj "/C=US/ST=IA/O=Github Jackcviers/CN=${fqdn}" \
		-passin pass:${truststore_credentials}

	keytool \
	    -keystore ${cluster_truststore} -delete -alias CARoot \
	    -storepass ${truststore_credentials} \
	    -keypass ${truststore_credentials} || echo "CARoot not in ${cluster_truststore}"

	keytool \
	    -keystore ${client_truststore} -delete -alias CARoot \
	    -storepass ${client_truststore_credentials} \
	    -keypass ${client_truststore_credentials} || echo "CARoot not in ${client_truststore}"

	if [ ! -f ${cluster_truststore} ]; then
	    touch ${cluster_truststore}
	fi

	if [ ! -f ${client_truststore} ]; then
	    touch ${client_truststore}
	fi

	keytool -keystore ${cluster_truststore} -alias CARoot \
		-import -file ${ca_cert_file} -storepass ${truststore_credentials} \
		-keypass ${truststore_credentials} -noprompt

	keytool -keystore ${client_truststore} -alias CARoot \
		-import -file ${ca_cert_file} \
		-storepass ${client_truststore_credentials} \
		-keypass ${client_truststore_credentials} -noprompt
	
    fi

    echo "Waiting for private ${ca_cert_file} to be created"
    sleep 10

    echo "Creating and signing broker keys"
    
    keytool -keystore ${server_keystore} -delete -alias CARoot \
	    -storepass ${keystore_credentials} \
	    -keypass ${keystore_credentials} || echo "CARoot not in ${server_keystore}"

    keytool -keystore ${server_keystore} -delete -alias server \
	    -storepass ${keystore_credentials} \
	    -keypass ${keystore_credentials} || echo "server not in ${server_keystore}"

    keytool -keystore ${server_keystore} --alias server \
	    -validity ${CERT_VALIDITY_DAYS} -genkey -keyalg RSA \
	    -storepass ${keystore_credentials} \
	    -keypass ${keystore_credentials} \
	    -storetype pkcs12 -dname "CN=kafka-ssl-1" \
	    -ext SAN=DNS:${fqdn},DNS:localhost

    keytool -keystore ${server_keystore} -certreq \
	    -alias server -file server-cert-file \
	    -storepass ${keystore_credentials} \
	    -keypass ${keystore_credentials}

    openssl x509 -req -CA ${ca_cert_file} -CAkey ${ca_key_file} \
	    -in server-cert-file \
	    -out server-cert-file-signed -days ${CERT_VALIDITY_DAYS} \
	    -CAcreateserial -passin pass:${truststore_credentials}

    keytool -keystore ${server_keystore} -alias CARoot \
	    -import -file ${ca_cert_file} -storepass ${keystore_credentials} \
	    -keypass ${keystore_credentials} -noprompt

    keytool -keystore ${server_keystore} -import \
	    -alias server -file server-cert-file-signed \
	    -storepass ${keystore_credentials} \
	    -keypass ${keystore_credentials} -noprompt

    echo "starting cp-kafka..."
    /etc/confluent/docker/run
}

generate_ssl
