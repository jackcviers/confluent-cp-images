# Copyright 2022 Jack Viers

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

find_container_for_service(){
    local service=$1
    echo $(${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} ps ${service} | grep -v PORTS | awk '{print $1}')
}

execute_on_service(){
    local service=$1
    local command=$2
    local service_container=$(find_container_for_service ${service})
    unbuffer ${BATS_BUILD_TOOL} exec -it $service_container "${@:2}";
}

kadmin_keytab_create(){
    local principal=$1
    local hostname=$2
    local filename=$3

    execute_on_service kerberos bash -c "kadmin.local -q \"addprinc -randkey ${principal}/${hostname}@TEST.CONFLUENT.IO\" && kadmin.local -q \"ktadd -norandkey -k /var/run/krb5/${filename}.keytab ${principal}/${hostname}@TEST.CONFLUENT.IO\" && chown appuser:root /var/run/krb5/${filename}.keytab"
}

health_check(){
    local service=$1
    local port=$2
    local host=localhost

    if [[ ! -z "$3" ]]; then
	host=$3
    fi
    execute_on_service $service bash -c "cub zk-ready ${host}:${port} 60 && echo PASS || echo FAIL"
}

kafka_health_check () {
    local service=$1
    local port=$2
    local num_brokers=$3
    local host=$4
    local security_protocol=PLAINTEXT

    if [[ ! -z "$5" ]]; then
        security_protocol=$5
    fi

    execute_on_service $service bash -c "cp /etc/kafka/kafka.properties /tmp/cub.properties && echo security.protocol=${security_protocol} >> /tmp/cub.properties && cub kafka-ready ${num_brokers} 40 -b ${host}:${port} -c /tmp/cub.properties -s ${security_protocol} && echo PASS || echo FAIL"
}

external_health_check(){
    local port=$1
    local mode=$2
    local host=localhost
    if [[ ! -z "$3" ]]; then
	host=$3
    fi
    ${BATS_BUILD_TOOL} run --rm --network=${mode} ${BATS_IMAGE} bash -c "cub zk-ready ${host}:${port} 60 && echo PASS || echo FAIL"
}

jmx_check(){
    local client_port=$1
    local jmx_port=$2
    local host=$3
    local mode=host
    if [[ ! -z "$4" ]]; then
	mode=$4
    fi
    unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=${mode} ${JMX_IMAGE} bash -c "echo 'get -b org.apache.ZooKeeperService:name0=StandaloneServer_port${client_port} Version' | java -jar /opt/jmxterm-1.0.2-uber.jar -l ${host}:${jmx_port} -n -v silent "
    # ${BATS_BUILD_TOOL} run --rm --network=${mode} ${JMX_IMAGE} bash -c "java -jar /opt/jmxterm-1.0.1-uber.jar -l \"localhost:9999\" 'get *'"
}

kafka_jmx_check(){
    local port=$1
    local jmx_hostname=$2
    local mode=host
    if [[ ! -z "$3" ]];
    then
	mode=$3
    fi
    # unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=${mode} ${JMX_IMAGE} bash -c "echo 'get -b kafka.server:id=1,type=app-info Version' | java -jar /opt/jmxterm-1.0.2-uber.jar -l ${jmx_hostname}:${port} -n -v silent "
    unbuffer ${BATS_BUILD_TOOL} run --rm --network=host ${JMX_IMAGE} bash -c "java -jar /opt/jmxterm-1.0.2-uber.jar -l \"localhost:39999\" 'get *'"
}

produce_n_plain_messages(){
    local topic=$1
    local brokers=$2
    local messages=$3
    local network=$4
    local zookeeper_servers=$5
    local currenttime=$(date +%s)

    unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=${network} --name kafka-bridged-plain-producer-${messages}-${currenttime} -e "KAFKA_ZOOKEEPER_CONNECT=${zookeeper_servers}" -e "KAFKA_TOOLS_LOG4J_LOGLEVEL=DEBUG" localhost:5000/jackcviers/cp-kafka:7.0.0 bash -c "dub template /etc/confluent/docker/tools-log4j.properties.template /etc/kafka/tools-log4j.properties && kafka-topics --create --topic ${topic} --partitions 1 --replication-factor 3 --if-not-exists --bootstrap-server ${brokers} && seq ${messages} | kafka-console-producer --broker-list ${brokers} --topic ${topic} && echo PRODUCED ${messages} messages. && kafka-console-consumer --bootstrap-server ${brokers} --topic foo --from-beginning --max-messages ${messages}"
}
