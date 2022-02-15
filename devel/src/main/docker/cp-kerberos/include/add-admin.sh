#!/bin/bash

set -e

kadmin.local -q "addprinc -pw admin admin/admin@TEST.CONFLUENT.IO"
