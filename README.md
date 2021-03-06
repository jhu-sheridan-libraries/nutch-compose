# Johns Hopkins Library website crawler and search appliance

DRAFT 

The Library Applications use Apache Nutch, Apache HBase, and Elastic Search to periodically crawl the library website, guides, and other sites. 

## Configuration

for ElasticRest interface see 
https://github.com/apache/nutch/blob/master/conf/nutch-default.xml

## Development (Docker Compose)

### ElasticSearch
ElasticSearch requires a change to the default vm.max.map_count paramter which sets a limit on the 
virtual memory that can be used by an application. The default is ''

Add the following to the /etc/sysctl.conf file
```
vm.max_map_count=262144
```

We are using a container volume to persist the es data. 
use the docker volume command to manage the volume.


### Nutch1

Run the following to change the value without restarting
```
sudo sysctl -w vm.max_map_count=262144
```

Remove old files
rm -rf  data/nutch1/?(crawldb|linkdb|segments)

create new data/nutch1/urls/seed.txt

docker-compose up -d
The project uses docker-compose for local development.

Run the container after building to debug
comment out the command line in the docker-composr for nutch1 and add the tty: true line
This will keep the container running. You can then terminal into the container and run the 
the command manually. 

You can also run the container on its own, this will not start and link the solr and es containers.
```
docker run -ti --rm --name nutch nutch-compose_nutch1:latest bash
```

Useful commands
```
docker-compose build
docker-compose up -d 
docker images | grep nutch1j
docker rmi nutch-compose_nutch1
docker-compose build nutch1
docker-compose log nutch1
docker-compose stop nutch1
docker-compose start nutch1
docker-compose down
docker-compose logs nutch1
docker volumes ls \# no docker-compose equivalent
```
Elastic Search
Create the index in advance. I am not sure we have to do this
```
curl -D - -w '\n' -X PUT http://localhost:9200/y
curl -D - -w '\n'  http://localhost:9200/_cat/indices?v
```

# Testing the docker image using docker

## using a fresh es container to test
```
\# get the es image
\# volume is created
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.3.2
\#run es
docker run \
  --name=es_test \
  -v es_test_data:/usr/share/elasticsearch/data \
  -p 9200:9200 -p 9300:9300 \
  -e "discovery.type=single-node"\
  docker.elastic.co/elasticsearch/elasticsearch:6.3.2
```

``
# get the nutch image to test
docker pull jhulibraries/sheridan-libraries-nutch:1.0.0

# run nutch and test volume works
ELASTICSEARCH_PORT=9200
ELASTICSEARCH_HOST=10.0.1.160
ELASTICSEARCH_ENDPOINT=http://$ELASTICSEARCH_HOST:ELASTICSEARCH_HOST/nutch
docker run -it \
   --name nutch_test
   -v nutch_data:/opt/data \
   -e ELASTICSEARCH_ENDPOINT=$ELASTICSEARCH_ENDPOINT \
   -e ELASTICSEARCH_HOST=$ELASTICSEARCH_HOST \
   -e ELASTICSEARCH_PORT=$ELASTICSEARCH_PORT \
   --rm jhulibraries/sheridan-libraries-nutch:1.0.0 \
   /opt/conf/command.sh
```
## Production (To Be Determined)

AWS services EC2 instance is provided to 
- run a cron.d/nutch on a regular intervals
- runs the container and then exits when completed
-

