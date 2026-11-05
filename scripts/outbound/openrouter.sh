#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
authorized_by=''
operation=''
body_file=''
status_file=''
while [ "$#" -gt 0 ]; do
  case "$1" in
    --authorized-by) authorized_by="${2:-}"; shift 2;;
    --operation) operation="${2:-}"; shift 2;;
    --body-file) body_file="${2:-}"; shift 2;;
    --status-file) status_file="${2:-}"; shift 2;;
    *) echo "openrouter.sh: unsupported argument" >&2; exit 2;;
  esac
done
case "$operation" in models|canary) ;; *) echo "openrouter.sh: unregistered operation" >&2; exit 2;; esac
[ -n "$authorized_by" ] || { echo "openrouter.sh: authorization required" >&2; exit 2; }
args=(--service openrouter --operation "$operation" --authorized-by "$authorized_by")
if [ "$operation" = canary ]; then [ -f "$body_file" ] || exit 2; args+=(--body-file "$body_file"); fi
[ -z "$status_file" ] || args+=(--status-file "$status_file")
exec env -u ANTHROPIC_API_KEY -u MOONSHOT_API_KEY -u FIREWORKS_API_KEY \
  -u OPENROUTER_API_KEY -u OLLAMA_CLOUD_API_KEY -u TYPESAFE_API_KEY \
  python3 "$HERE/client.py" "${args[@]}"
