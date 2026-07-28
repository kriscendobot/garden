#!/bin/bash
# Deterministic `systemctl` stand-in for hermit-ollama-self-heal-test.sh. Logs each
# call, and models two things the preflight does with systemd:
#
#   * `--user start garden-ollama.service` — brings the endpoint "up" (creates the
#     reachability marker the fake curl reads) IFF GARDEN_TEST_HEAL_SUCCEEDS=1,
#     modelling a garden-ollama that either recovers or stays down.
#   * `is-active --quiet <unit>` — the READ-ONLY probe behind the operator unit hint.
#     Answers from control markers so a test can pose a host where the garden `--user`
#     unit serves, where the installer's SYSTEM ollama.service serves instead, where
#     both claim the port, or where neither runs. Default (no marker) is "inactive",
#     systemd's exit 3.
set -euo pipefail
printf '%s\n' "$*" >> "$HEAL_CTL/systemctl-calls"
case "$*" in
  *"start garden-ollama.service"*) [ "${GARDEN_TEST_HEAL_SUCCEEDS:-0}" = 1 ] && : > "$HEAL_CTL/up" ;;
  *"is-active"*"garden-ollama.service"*) [ -e "$HEAL_CTL/unit-active-garden" ] || exit 3 ;;
  *"is-active"*" ollama.service"*) [ -e "$HEAL_CTL/unit-active-system" ] || exit 3 ;;
esac
exit 0
