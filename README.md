# Kibana 4

## Overview
This repository fetches the latest official build of [Kibana 4](http://www.elasticsearch.org/overview/kibana/) and packages it up into a docker container. It powers an automated build on the official Docker Hub.

The container tries to make Kibana more [12-factor](http://12factor.net/), by overwriting the configuration file with values specified in the environment.

## Usage
### Prebuilt image
* Standalone
```bash
docker run -p 80:5601 wdullaer/kibana4
```
* With Elasticsearch Docker container
```bash
docker run --link elasticsearch:elasticsearch -p 80:5601 wdullaer/kibana4
```

### Build image from source
```bash
git clone 'https://github.com/wdullaer/kibana4.git'
cd kibana4
docker build -t kibana4 .
docker run -p 80:5601 kibana4
```

## Configuration Environment Variables
* `$PORT` Port on which the Kibana server will listen (default: 5601)
* `$HOST` Ip address on which the Kibana server will bind (default: 0.0.0.0)
* `$VERIFY_SSL` Do strict certificate validation on ssl connections (default: true)
* `$ELASTICSEARCH_PRESERVE_HOST` If true, send the Elasticsearch hostname. If false, send the hostname of *this* Kibana instance. (default: false)
* `$ELASTICSEARCH` Connection string (URL + port) of the elasticsearch cluster (default: http://localhost:9200)
* `$ELASTICSEARCH_PORT_9200_TCP_ADDR` URL of the Elasticsearch cluster. Useful when linking in an Elasticsearch Docker container. Unused if `$ELASTICSEARCH` is set. (default: localhost)
* `$ELASTICSEARCH_PORT_9200_TCP_PORT` Port of the Elasticsearch cluster. Useful when linking in an Elasticsearch Docker container. Unused if `$ELASTICSEARCH` is set. (default: 9200)
* `$BASIC_AUTH_USERNAME` Username for a basic auth protected Elasticsearch cluster. (no basic auth by default)
* `$BASIC_AUTH_PASSWORD` Password for a basic auth protected Elasticsearch cluster. (no basic auth by default) 
