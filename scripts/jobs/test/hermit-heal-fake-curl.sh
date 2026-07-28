#!/bin/bash
# Deterministic Ollama /v1/models reachability stand-in for
# hermit-ollama-self-heal-test.sh. Reachable IFF $HEAL_CTL/up exists; logs each probe
# so the test can count poll iterations. Exit 22 = curl's HTTP-error rc (any nonzero
# reads as "down" to codex_local_endpoint_ready). A healthy fixture exposes the
# default hermit model through the same /v1/models JSON shape Ollama serves.
set -euo pipefail
echo probe >> "$HEAL_CTL/curl-calls"
[ -e "$HEAL_CTL/up" ] && {
  if [ -e "$HEAL_CTL/empty-models" ]; then
    printf '{"object":"list","data":null}\n'
  else
    printf '{"object":"list","data":[{"id":"qwen3:0.6b"}]}\n'
  fi
  exit 0
}
exit 22
