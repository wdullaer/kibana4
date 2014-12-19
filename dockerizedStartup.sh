#!/bin/bash

# Check for environment variables or supply useful defaults
#----------------------------------------------------------

# Some variables to keep the code readable
KIBANA_CONFIG='/opt/kibana/config/kibana.yml'

# Kibana configuration
PORT=${PORT:-5601}
HOST=${HOST:-0.0.0.0}
VERIFY_SSL=${VERIFY_SSL:-true}

# Elasticsearch: use the given one, or create a default one from docker if blank
if [ -z $ELASTICSEARCH ]; then
    ELASTICSEARCH_PORT_9200_TCP_ADDR=${ELASTICSEARCH_PORT_9200_TCP_ADDR:-localhost}
    ELASTICSEARCH_PORT_9200_TCP_PORT=${ELASTICSEARCH_PORT_9200_TCP_PORT:-9200}
    ELASTICSEARCH="http://$ELASTICSEARCH_PORT_9200_TCP_ADDR:$ELASTICSEARCH_PORT_9200_TCP_PORT"
fi

# Remove the default config file and replace it with our own
rm $KIBANA_CONFIG
cat << EOF > $KIBANA_CONFIG
# Kibana is served by a back end server. This controls which port to use.
port: $PORT

# The host to bind the server to.
host: "$HOST"

# The Elasticsearch instance to use for all your queries.
elasticsearch: "$ELASTICSEARCH"

# Kibana uses an index in Elasticsearch to store saved searches, visualizations
# and dashboards. It will create a new index if it doesn't already exist.
kibana_index: ".kibana"

# The default application to load.
default_app_id: "discover"

# Time in seconds to wait for responses from the back end or elasticsearch.
# Note this should always be higher than "shard_timeout".
# This must be > 0
request_timeout: 60

# Time in milliseconds for Elasticsearch to wait for responses from shards.
# Note this should always be lower than "request_timeout".
# Set to 0 to disable (not recommended).
shard_timeout: 30000

# Set to false to have a complete disregard for the validity of the SSL
# certificate.
verify_ssl: $VERIFY_SSL

# Plugins that are included in the build, and no longer found in the plugins/ folder
bundledPluginIds:
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

