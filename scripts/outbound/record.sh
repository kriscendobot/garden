#!/bin/bash
# Commit a value-free accepted outbound record before the corresponding egress.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
# shellcheck source=../jobs/common.sh
source "$ROOT/scripts/jobs/common.sh"

[ "$#" -eq 7 ] || die "usage: record.sh SERVICE AUTHORIZED_BY METHOD PATH BODY_JSON KIND ACTION"
service="$1" authorized_by="$2" method="$3" request_path="$4" body="$5" kind="$6" action="$7"
[[ "$service" =~ ^[a-z][a-z0-9-]*$ ]] || die "invalid outbound service"
[[ "$authorized_by" =~ ^[A-Za-z0-9][A-Za-z0-9._:/@+-]{0,127}$ ]] || die "invalid authorization label"
[[ "$method" =~ ^(GET|POST|EXEC)$ ]] || die "invalid outbound method"
path_pattern='^/[A-Za-z0-9._~:/?=&+,-]*$'
[[ "$request_path" =~ $path_pattern ]] || die "invalid outbound path"
jq -e 'type == "object"' <<<"$body" >/dev/null || die "outbound body projection must be a JSON object"

now="$(date -u +%FT%TZ)"
record="$(jq -cn --arg service "$service" --arg host "$GARDEN" --arg authorized_by "$authorized_by" \
  --arg at "$now" --arg method "$method" --arg path "$request_path" --arg kind "$kind" --arg action "$action" \
  --argjson body "$body" '{service:$service,host:$host,authorized_by:$authorized_by,accepted_at:$at,method:$method,path:$path,kind:$kind,action:$action,body:$body}')"

if [ -n "${GARDEN_OUTBOUND_LEDGER_CMD:-}" ]; then
  printf '%s\n' "$record" | "$GARDEN_OUTBOUND_LEDGER_CMD" "$service"
  exit
fi

DIR="${GARDEN_OUTBOUND_CLONE:-$GARDEN_STATE/producer/outbound-journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 20); do
  sync_clone "$DIR"
  stamp="$(date -u +%Y/%m/%d/%H%M%SZ)"
  nonce="$(printf '%s' "$record-$$-$RANDOM" | sha256sum | cut -c1-10)"
  rel="outbound/$service/$stamp-$nonce.json"
  mkdir -p "$DIR/$(dirname "$rel")"
  printf '%s\n' "$record" > "$DIR/$rel"
  git -C "$DIR" add "$rel"
  if commit_and_push "$DIR" "outbound: accept $service $method on $GARDEN"; then exit 0; fi
  backoff "$attempt"
done
die "outbound ledger unavailable; refusing egress"
