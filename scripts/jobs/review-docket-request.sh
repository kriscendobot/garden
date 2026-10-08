#!/bin/bash
# Adapter used by review-request producers. It deliberately exposes only the
# validated review-docket intake contract, never the journal record path.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
url="" ask="" source_id="" summary="" arc="unallocated" milestone="-" unblocks='[]'
while [ $# -gt 0 ]; do
  case "$1" in
    --url) url="${2:?}"; shift 2;;
    --ask) ask="${2:?}"; shift 2;;
    --source) source_id="${2:?}"; shift 2;;
    --summary) summary="${2:?}"; shift 2;;
    --arc) arc="${2:?}"; shift 2;;
    --milestone) milestone="${2:?}"; shift 2;;
    --unblocks-json) unblocks="${2:?}"; shift 2;;
    *) echo "review-docket-request: unknown option '$1'" >&2; exit 64;;
  esac
done
if [ -z "$url" ] || [ -z "$ask" ] || [ -z "$source_id" ] || [ -z "$summary" ]; then
  echo "usage: review-docket-request.sh --url URL --ask ASK --source ID --summary TEXT [--arc ARC] [--milestone M<N>|-] [--unblocks-json JSON]" >&2
  exit 64
fi
request="$(mktemp "${TMPDIR:-/tmp}/review-docket-request.XXXXXX")"
trap 'rm -f "$request"' EXIT
jq -cn --arg ask "$ask" --arg source "$source_id" --arg summary "$summary" \
  --arg arc "$arc" --arg milestone "$milestone" --argjson unblocks "$unblocks" \
  '{schema:1,ask:$ask,source:$source,summary:$summary,arc:$arc,milestone:$milestone,unblocks:$unblocks}' > "$request"
"$HERE/review-docket.sh" upsert "$url" "$request"
