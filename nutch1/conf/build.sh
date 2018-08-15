#!/usr/bin/env bash
set -x

source /etc/profile.d/java.sh
source /etc/profile.d/ant.sh
source /etc/profile.d/nutch.sh

# config dir is copies to runtime/config on build
ELASTICSEARCH_ENDPOINT="localhost"
ELASTICSEARCH_PORT="9200"
envsubst < /opt/conf/nutch-site.xml.tmpl > $NUTCH_HOME/conf/nutch-site.xml
cp -f /opt/conf/regex-urlfilter.txt $NUTCH_HOME/conf/

cd /opt/nutch
ant
