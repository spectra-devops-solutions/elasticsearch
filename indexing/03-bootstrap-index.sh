#!/usr/bin/env bash
# Bootstraps the initial backing index and creates the mule-deva-logs alias.
#
# Must be run after 01-ilm-policy.sh and 02-index-template.sh.
#
# ILM rollover requires the alias to exist on a concrete index before it can
# manage it. This creates "mule-deva-000001" and marks it as the current
# write index for the alias. Logstash should target the alias "mule-deva-logs".

ES_HOST="${ES_HOST:-http://localhost:9200}"

curl -X PUT "${ES_HOST}/mule-deva-000001" \
  -H "Content-Type: application/json" \
  -d '{
    "aliases": {
      "mule-deva-logs": {
        "is_write_index": true
      }
    }
  }'
