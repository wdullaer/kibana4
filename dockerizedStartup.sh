#!/bin/bash

# Check for environment variables or supply useful defaults
#----------------------------------------------------------

# Some variables to keep the code readable
KIBANA_CONFIG='/opt/kibana/config/kibana.yml'

# Kibana configuration
PORT=${PORT:-5601}
HOST=${HOST:-0.0.0.0}
VERIFY_SSL=${VERIFY_SSL:-true}
ELASTICSEARCH_PRESERVE_HOST=${ELASTICSEARCH_PRESERVE_HOST:-true}

# Elasticsearch: use the given one, or create a default one from docker if blank
if [ -z $ELASTICSEARCH ]; then
    ELASTICSEARCH_PORT_9200_TCP_ADDR=${ELASTICSEARCH_PORT_9200_TCP_ADDR:-localhost}
    ELASTICSEARCH_PORT_9200_TCP_PORT=${ELASTICSEARCH_PORT_9200_TCP_PORT:-9200}
    ELASTICSEARCH="http://$ELASTICSEARCH_PORT_9200_TCP_ADDR:$ELASTICSEARCH_PORT_9200_TCP_PORT"
fi

# Basic auth credentials of the Elasticsearch cluster
if [ $BASIC_AUTH_USERNAME ]; then
    BASIC_AUTH_USERNAME="kibana_elasticsearch_username: $BASIC_AUTH_USERNAME"
    BASIC_AUTH_PASSWORD="kibana_elasticsearch_password: $BASIC_AUTH_PASSWORD"
fi

# Remove the default config file and replace it with our own
rm $KIBANA_CONFIG
cat << EOF > $KIBANA_CONFIG
# Kibana is served by a back end server. This controls which port to use.
port: $PORT

# The host to bind the server to.
host: "$HOST"

# The Elasticsearch instance to use for all your queries.
elasticsearch_url: "$ELASTICSEARCH"

# elasticsearch_preserve_host true will send the hostname specified in elasticsearch. If you set it to false,
# then the host you use to connect to *this* Kibana instance will be sent.
elasticsearch_preserve_host: $ELASTICSEARCH_PRESERVE_HOST

# Kibana uses an index in Elasticsearch to store saved searches, visualizations
# and dashboards. It will create a new index if it doesn't already exist.
kibana_index: ".kibana"

# If your Elasticsearch cluster is protected by basic auth, these are the user credentials
# used by the Kibana server to perform maintenance on the kibana_index at startup. Your Kibana
# users will still need to authenticate with Elasticsearch (which is proxied through
# the Kibana server)
$BASIC_AUTH_USERNAME
$BASIC_AUTH_PASSWORD

# The default application to load.
default_app_id: "discover"

# Time in miliseconds to wait for responses from the back end or elasticsearch.
# This must be > 0
request_timeout: 30000

# Time in milliseconds for Elasticsearch to wait for responses from shards.
# Set to 0 to disable.
shard_timeout: 0

# Set to false to have a complete disregard for the validity of the SSL
# certificate.
verify_ssl: $VERIFY_SSL

# If you need to provide a CA certificate for your Elasticsearch instance, put
# the path of the pem file here.
# ca: /path/to/your/CA.pem

# SSL for outgoing requests from the Kibana Server (PEM formatted)
# ssl_key_file: /path/to/your/server.key
# ssl_cert_file: /path/to/your/server.crt

# Set the path to where you would like the process id file to be created.
# pid_file: /var/run/kibana.pid

# Plugins that are included in the build, and no longer found in the plugins/ folder
bundled_plugin_ids:
- plugins/dashboard/index
- plugins/discover/index
- plugins/doc/index
- plugins/kibana/index
- plugins/metric_vis/index
- plugins/settings/index
- plugins/table_vis/index
- plugins/vis_types/index
- plugins/visualize/index
EOF

# Run Kibana in the foreground
/opt/kibana/bin/kibana

