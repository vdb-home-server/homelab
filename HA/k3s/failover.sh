#!/usr/bin/env bash

# ===== CONFIG =====
CF_API_TOKEN=""
CF_ZONE_ID="e69128fbe2f2d4f1063d1e5295a08713"

RECORD_NAME="cluster.vdbhome.ovh"

NODE1="node1.cluster.vdbhome.ovh"
NODE2="node2.cluster.vdbhome.ovh"

NODE1_HEALTH="https://node1.cluster.vdbhome.ovh/healthz"
NODE2_HEALTH="https://node2.cluster.vdbhome.ovh/healthz"

FAIL_THRESHOLD=3
TTL=60

STATE_FILE="/tmp/cf_failover_state"
LOG_FILE="/var/log/cf-failover.log"

# ==================

log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

check_health() {
    status=$(curl -k -s -o /dev/null -w "%{http_code}" --max-time 5 "$1")

    if [[ "$status" =~ ^[23] ]]; then
        return 0
    else
        return 1
    fi
}

get_record() {
    curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?type=CNAME&name=$RECORD_NAME" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json"
}

update_record() {
    local record_id="$1"
    local target="$2"

    curl -s -X PUT \
        "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$record_id" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{
          \"type\": \"CNAME\",
          \"name\": \"$RECORD_NAME\",
          \"content\": \"$target\",
          \"ttl\": $TTL,
          \"proxied\": false
        }" > /dev/null
}

# ===== Load state =====
NODE1_FAILS=0
NODE2_FAILS=0

if [[ -f "$STATE_FILE" ]]; then
    source "$STATE_FILE"
fi

# ===== Health checks =====
if check_health "$NODE1_HEALTH"; then
    NODE1_FAILS=0
    NODE1_OK=true
else
    ((NODE1_FAILS++))
    NODE1_OK=false
fi

if check_health "$NODE2_HEALTH"; then
    NODE2_FAILS=0
    NODE2_OK=true
else
    ((NODE2_FAILS++))
    NODE2_OK=false
fi

# Save state
echo "NODE1_FAILS=$NODE1_FAILS" > "$STATE_FILE"
echo "NODE2_FAILS=$NODE2_FAILS" >> "$STATE_FILE"

# ===== Get current record =====
RESP=$(get_record)

RECORD_ID=$(echo "$RESP" | jq -r '.result[0].id')
CURRENT_TARGET=$(echo "$RESP" | jq -r '.result[0].content')

if [[ "$RECORD_ID" == "null" ]]; then
    log "ERROR: Record not found"
    exit 1
fi

# ===== Decide target =====
DESIRED_TARGET="$CURRENT_TARGET"

if [[ "$NODE1_OK" == true ]]; then
    DESIRED_TARGET="$NODE1"

elif [[ "$NODE1_FAILS" -ge "$FAIL_THRESHOLD" && "$NODE2_OK" == true ]]; then
    DESIRED_TARGET="$NODE2"
fi

# ===== Apply change if needed =====
if [[ "$DESIRED_TARGET" != "$CURRENT_TARGET" ]]; then
    log "Switching $RECORD_NAME → $DESIRED_TARGET"
    update_record "$RECORD_ID" "$DESIRED_TARGET"
else
    log "No change needed (current → $CURRENT_TARGET)"
fi
