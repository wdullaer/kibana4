# Install and configure a Kibana 4 server
#
# Usage: docker run --link=<elasticsearch_container>:elasticsearch -p <public_port>:5601 --name <container_name> <image_name>
#
# Version 1.1

FROM ubuntu:latest
MAINTAINER Wouter Dullaert, wouter.dullaert@toyota-europe.com

# Install wget
RUN apt-get install -y wget

# Download Kibana 4
WORKDIR /tmp
RUN wget 'https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz'

# Extract and install Kibana 4
RUN tar xvf "kibana-4.0.1-linux-x64.tar.gz" &&\
    mv /tmp/kibana-4.0.1-linux-x64/ /opt/kibana/

# Add the wrapper startup script
ADD dockerizedStartup.sh /opt/kibana/bin/dockerizedStartup.sh
RUN chmod +x /opt/kibana/bin/dockerizedStartup.sh

# Expose our port
EXPOSE 5601

# Run Kibana 4 whent the container starts
CMD '/opt/kibana/bin/dockerizedStartup.sh'

