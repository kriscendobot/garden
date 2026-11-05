#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "${1:-}" != --authorized-by ] || [ -z "${2:-}" ] || [ "$#" -ne 2 ]; then
  echo "usage: fireworks.sh --authorized-by LABEL" >&2
  exit 2
fi
exec env -u ANTHROPIC_API_KEY -u MOONSHOT_API_KEY -u FIREWORKS_API_KEY \
  -u OPENROUTER_API_KEY -u OLLAMA_CLOUD_API_KEY -u TYPESAFE_API_KEY \
  python3 "$HERE/client.py" --service fireworks --operation models --authorized-by "$2" --timeout 15
