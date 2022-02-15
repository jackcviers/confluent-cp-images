#!/bin/bash

set -e

cat > ${KRB5_CONFIG} <<EOF
[libdefaults]
    default_realm = TEST.CONFLUENT.IO

[realms]
    TEST.CONFLUENT.IO = {
        kdc = $(hostname -f)
        admin_server = $(hostname -f)
    }
EOF
