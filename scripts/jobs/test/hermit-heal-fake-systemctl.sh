#!/bin/bash
# Deterministic `systemctl --user` stand-in for hermit-ollama-self-heal-test.sh. Logs
# each call; on `start garden-ollama.service`, brings the endpoint "up" (creates the
# reachability marker the fake curl reads) IFF GARDEN_TEST_HEAL_SUCCEEDS=1 — modelling
# a garden-ollama that either recovers or stays down.
set -euo pipefail
printf '%s\n' "$*" >> "$HEAL_CTL/systemctl-calls"
case "$*" in
  *"start garden-ollama.service"*) [ "${GARDEN_TEST_HEAL_SUCCEEDS:-0}" = 1 ] && : > "$HEAL_CTL/up" ;;
esac
exit 0
