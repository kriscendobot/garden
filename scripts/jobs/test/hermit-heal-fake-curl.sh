#!/bin/bash
# Deterministic Ollama /v1/models reachability stand-in for
# hermit-ollama-self-heal-test.sh. Reachable IFF $HEAL_CTL/up exists; logs each probe
# so the test can count poll iterations. Exit 22 = curl's HTTP-error rc (any nonzero
# reads as "down" to codex_local_endpoint_ready).
set -euo pipefail
echo probe >> "$HEAL_CTL/curl-calls"
[ -e "$HEAL_CTL/up" ] && exit 0
exit 22
