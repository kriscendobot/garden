#!/bin/bash
# pull-local-model.sh — the ExecStart of garden-local-model-pull.service.
#
# The DETERMINISTIC, no-LLM async worker for the sysop `local-model` provisioning op
# (designs/sysop-local-model.md § Async execution). It takes NO model argument: the
# sysop froze the target — the deployed inventory's `local` routing default — into a
# host-local execution record before starting this unit, and this helper reads it
# from there. It rechecks the target's closed-inventory classification (a stale record
# must never pull an unclassified tag), runs ONE `ollama pull` against the garden
# endpoint's model store, and writes a terminal result the sysop's next tick reads.
#
# The unit has no wall-clock limit (TimeoutStartSec=infinity) and no [Install]
# section, so a routine unit install never enables it; it is started only by an
# accepted, attested request and supervised by systemd. This helper is NOT a
# supervisor — it runs the pull in the foreground and exits with the pull's status.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="pull-local-model"

: "${GARDEN_SYSOP_LOCALMODEL_STATE:=$GARDEN_STATE/sysop/local-model}"
: "${GARDEN_SYSOP_OLLAMA_BIN:=ollama}"
LM="$GARDEN_SYSOP_LOCALMODEL_STATE"

# write_result <outcome> <exit> <tail> — atomically publish the terminal result the
# sysop poll reads. Temp file + rename so a half-written record is never observed.
write_result() {
  mkdir -p "$LM" 2>/dev/null || true
  {
    printf 'outcome: %s\n' "$1"
    printf 'exit: %s\n'    "$2"
    printf 'tail: %s\n'    "$(printf '%s' "$3" | tr '\n' ' ')"
    printf 'at: %s\n'      "$(date -u +%FT%TZ)"
  } > "$LM/result.tmp" && mv -f "$LM/result.tmp" "$LM/result"
}

target="$(sed -n 's/^target:[[:space:]]*//p' "$LM/exec" 2>/dev/null | head -1)"
if [ -z "$target" ]; then
  log "no frozen target in $LM/exec — refusing to pull"
  write_result failure 64 "no frozen target in execution record"
  exit 64
fi

# Fail closed if the frozen target is no longer classified by the deployed inventory
# (e.g. the record outlived a downgrade of the corrected inventory).
if ! model_dispatch_tier local "$target" >/dev/null 2>&1; then
  log "frozen target '$target' is not classified in the current inventory — refusing to pull"
  write_result failure 65 "target '$target' not classified in current inventory"
  exit 65
fi

logf="$(mktemp)"; trap 'rm -f "$logf"' EXIT
OLLAMA_HOST="$(ollama_serve_host)"; export OLLAMA_HOST
log "pulling local model '$target' into the garden Ollama store (OLLAMA_HOST=$OLLAMA_HOST)"
rc=0
"$GARDEN_SYSOP_OLLAMA_BIN" pull "$target" >"$logf" 2>&1 || rc=$?
tail_line="$(tail -n 1 "$logf" 2>/dev/null || true)"
if [ "$rc" -eq 0 ]; then
  log "ollama pull '$target' completed"
  write_result success 0 "$tail_line"
else
  log "ollama pull '$target' failed (exit $rc)"
  write_result failure "$rc" "$tail_line"
fi
exit "$rc"
