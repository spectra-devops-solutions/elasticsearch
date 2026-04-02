#!/usr/bin/env bash
# Creates a composable index template for mule-deva-logs indices.
#
# Applies to any index matching "mule-deva-logs-*" (the rollover naming pattern).
# Wires in:
#   - 3 primary shards, 1 replica
#   - the mule-deva-logs-policy ILM policy
#   - the mule-deva-logs rollover alias

ES_HOST="${ES_HOST:-http://localhost:9200}"

curl -X PUT "${ES_HOST}/_index_template/mule-deva-logs-template" \
  -H "Content-Type: application/json" \
  -d '{
    "index_patterns": ["mule-deva-*"],
    "template": {
      "settings": {
        "number_of_shards": 3,
        "number_of_replicas": 1,
        "index.lifecycle.name": "mule-deva-logs-policy",
        "index.lifecycle.rollover_alias": "mule-deva-logs"
      }
    }
  }'
