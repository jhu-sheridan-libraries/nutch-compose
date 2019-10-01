#!/usr/bin/env bash
# passing docker  enviroment variables
# ELASTICSEARCH_HOST
# ELASTICSEARCH_PORT
# ELASTICSEARCH_ENDPOINT
#
echo "$ELASTICSEARCH_HOST $ELASTICSEARCH_PORT $ELASTICSEARCH_ENDPOINT"

source /etc/profile.d/java.sh
source /etc/profile.d/nutch.sh

envsubst < /opt/conf/nutch-site.xml.tmpl > $NUTCH_RUNTIME/conf/nutch-site.xml
envsubst < /opt/conf/nutch-site.xml.tmpl > $NUTCH_HOME/conf/nutch-site.xml
cat $NUTCH_RUNTIME/conf/nutch-site.xml

DATA=/opt/data
mkdir -p $DATA/crawldb $DATA/segments $DATA/linkdb $NUTCH_LOG_DIR
rm -rf /opt/data/crawldb/.locked

nutch inject $DATA/crawldb /opt/conf/urls/
nutch generate $DATA/crawldb $DATA/segments

s1=$(ls -d $DATA/segments/2* | tail -1)
echo $s1

nutch fetch $s1
nutch parse $s1
nutch updatedb $DATA/crawldb $s1
nutch invertlinks $DATA/linkdb -dir $DATA/segments

nutch index -Delastic.server.url=$ELASTICSEARCH_ENDPOINT  $DATA/crawldb/ -linkdb $DATA/linkdb/ $DATA/segments/* -filter -normalize -deleteGone
