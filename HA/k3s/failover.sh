#!/usr/bin/env bash

CF_API_TOKEN="YOUR_API_TOKEN"
CF_ZONE_ID="e69128fbe2f2d4f1063d1e5295a08713"

RECORD_NAME="cluster.vdbhome.ovh"

TTL=60
FAIL_THRESHOLD=3

STATE_FILE="/tmp/cf_failover_state"
LOG_FILE="/var/log/cf-failover.log"

NODES=(
  "node1.vdbhome.ovh"
  "node2.vdbhome.ovh"
)

log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

check_health() {
    local url="https://$1"
    status=$(curl -k -s -o /dev/null -w "%{http_code}" --max-time 5 "$url")

    [[ "$status" =~ ^[23] ]]
}

# ----- Load failure counters -----
declare -A FAILS

if [[ -f "$STATE_FILE" ]]; then
    source "$STATE_FILE"
fi

# ----- Evaluate nodes -----
SELECTED_NODE=""

for node in "${NODES[@]}"; do

    if check_health "$node"; then
        FAILS["$node"]=0

        if [[ -z "$SELECTED_NODE" ]]; then
            SELECTED_NODE="$node"
        fi

    else
        FAILS["$node"]=$(( ${FAILS["$node"]:-0} + 1 ))
    fi

done

# Save state
> "$STATE_FILE"
for node in "${!FAILS[@]}"; do
    echo "FAILS[\"$node\"]=${FAILS[$node]}" >> "$STATE_FILE"
done

# ----- Cloudflare record -----
RESP=$(curl -s -X GET \
  "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?type=CNAME&name=$RECORD_NAME" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json")

RECORD_ID=$(echo "$RESP" | jq -r '.result[0].id')
CURRENT_TARGET=$(echo "$RESP" | jq -r '.result[0].content')

if [[ -z "$SELECTED_NODE" ]]; then
    log "All nodes appear down. Not switching."
    exit 0
fi

if [[ "$CURRENT_TARGET" != "$SELECTED_NODE" ]]; then

    log "Switching → $SELECTED_NODE"

    curl -s -X PUT \
      "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
      -H "Authorization: Bearer $CF_API_TOKEN" \
      -H "Content-Type: application/json" \
      --data "{
        \"type\": \"CNAME\",
        \"name\": \"$RECORD_NAME\",
        \"content\": \"$SELECTED_NODE\",
        \"ttl\": $TTL,
        \"proxied\": false
      }" > /dev/null
else
    log "Already pointing to healthy node ($CURRENT_TARGET)"
fi
