#!/usr/bin/env bash
# Creates the ILM lifecycle policy for mule-deva-logs indices.
#
# Lifecycle:
#   hot    — rollover when any primary shard reaches 40 GB
#   cold   — entered immediately after rollover; stays 30 days
#   frozen — entered 30 days after rollover; stays 90 days
#   delete — entered 120 days after rollover (30 cold + 90 frozen)

ES_HOST="${ES_HOST:-http://localhost:9200}"

curl -X PUT "${ES_HOST}/_ilm/policy/mule-deva-logs-policy" \
  -H "Content-Type: application/json" \
  -d '{
    "policy": {
      "phases": {
        "hot": {
          "actions": {
            "rollover": {
              "max_primary_shard_size": "40gb"
            },
            "set_priority": {
              "priority": 100
            }
          }
        },
        "cold": {
          "min_age": "0d",
          "actions": {
            "migrate": {},
            "set_priority": {
              "priority": 0
            }
          }
        },
        "frozen": {
          "min_age": "30d",
          "actions": {
            "searchable_snapshot": {
              "snapshot_repository": "found-snapshots"
            }
          }
        },
        "delete": {
          "min_age": "120d",
          "actions": {
            "delete": {}
          }
        }
      }
    }
  }'
