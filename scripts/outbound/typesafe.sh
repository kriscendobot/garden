#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
authorized_by=''
operation=''
body_file=''
status_file=''
timeout=60
while [ "$#" -gt 0 ]; do
  case "$1" in
    --authorized-by) authorized_by="${2:-}"; shift 2;;
    --operation) operation="${2:-}"; shift 2;;
    --body-file) body_file="${2:-}"; shift 2;;
    --status-file) status_file="${2:-}"; shift 2;;
    --timeout) timeout="${2:-}"; shift 2;;
    *) echo "typesafe.sh: unsupported argument" >&2; exit 2;;
  esac
done
case "$operation" in classify|muster) ;; *) echo "typesafe.sh: unregistered operation" >&2; exit 2;; esac
if [ -z "$authorized_by" ] || [ ! -f "$body_file" ]; then
  echo "typesafe.sh: authorization and body file required" >&2
  exit 2
fi
args=(--service typesafe --operation "$operation" --authorized-by "$authorized_by" --body-file "$body_file" --timeout "$timeout")
[ -z "$status_file" ] || args+=(--status-file "$status_file")
exec env -u ANTHROPIC_API_KEY -u MOONSHOT_API_KEY -u FIREWORKS_API_KEY \
  -u OPENROUTER_API_KEY -u OLLAMA_CLOUD_API_KEY -u TYPESAFE_API_KEY \
  python3 "$HERE/client.py" "${args[@]}"
