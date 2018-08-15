# Johns Hopkins Library website crawler and search appliance

DRAFT 

The Library Applications use Apache Nutch, Apache HBase, and Elastic Search to periodically crawl the library website, guides, and other sites. 

## Development (Docker Compose)

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
```
Elastic Search
Create the index in advance. I am not sure we have to do this
```
curl -D - -w '\n' -X PUT http://localhost:9200/y
curl -D - -w '\n'  http://localhost:9200/_cat/indices?v
```

## Production (To Be Determined)

AWS services EC2 instance is provided to 
- run a cron.d/nutch on a regular intervals
- runs the container and then exits when completed
-

