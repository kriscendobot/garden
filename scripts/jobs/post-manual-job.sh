#!/bin/bash
# post-manual-job.sh — the sole explicit mentat/Fable dispatch path.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base="${1:?usage: post-manual-job.sh <basename> [body-file]}"
body="${2:-}"
if [ -n "$body" ]; then [ -f "$body" ] || { echo "body source '$body' is not a file" >&2; exit 2; }; payload="$(cat "$body")"; else payload="$(cat)"; fi
printf '%s\n' '---' 'model: mentat' 'dispatch: manual' '---' "$payload" | GARDEN_MANUAL_DISPATCH=1 "$HERE/post-job.sh" "$base"
