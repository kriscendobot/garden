#!/bin/bash
# set-model-routing.sh — edit the per-instance model-routing table on the journal (CAS).
#
# The model-routing table decides WHICH backend/provider may claim a `model:`-pinned
# job and each provider's fleet-default model (see scripts/jobs/model-routing-defaults.tsv
# for the column contract and CLAUDE.md § model routing). This is DATA: as models come
# and go you change routing HERE — a journal edit, CAS-pushed, NO deploy needed. A
# deploy is only needed when the READING code changes.
#
# Usage:
#   set-model-routing.sh <provider> <patterns> [default]   # upsert one provider row
#   set-model-routing.sh --remove <provider>               # delete a provider row
#   set-model-routing.sh --show                            # print the effective table
#   set-model-routing.sh --validate [file]                 # validate a table (default: journal / effective)
#
#   <provider>  a worker-kind provider: anthropic | openai | local
#   <patterns>  space-separated shell globs (quote them); a leading `!` = EXCLUDE glob
#               e.g.  'qwen*'   or  'gpt-* o[0-9]* codex-* !gpt-oss*'
#   [default]   the provider's fleet-default concrete model id (optional; empty ok)
#
# The journal file (config/model-routing) is a COMPLETE table read as one unit, so an
# upsert edits an existing journal file OR seeds a fresh one from the tracked defaults
# (model-routing-defaults.tsv) and then applies the row — never leaving a partial table.
# Overwrites one file, so a rejected push just re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="set-model-routing"

RELPATH="${GARDEN_MODEL_ROUTING_PATH:-config/model-routing}"

# validate_routing_table <file> — deterministic table validator (no LLM). Rejects a
# table that would mis-route: a row without a provider or patterns column, a provider
# named more than once, or a stray non-tab-delimited line. Prints a diagnostic and
# returns non-zero on the first fault.
validate_routing_table() {
  local f="$1"
  [ -s "$f" ] || { echo "routing table is empty: $f" >&2; return 1; }
  awk -F'\t' '
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    {
      prov=$1
      if (prov ~ /[[:space:]]/ || prov=="") { print "row " NR ": missing/whitespace provider column"; bad=1; exit }
      if (NF < 2 || $2 ~ /^[[:space:]]*$/)  { print "row " NR ": provider \x27" prov "\x27 has no patterns column (need a TAB then globs)"; bad=1; exit }
      if (seen[prov]++)                     { print "row " NR ": provider \x27" prov "\x27 appears more than once"; bad=1; exit }
      rows++
    }
    END { if (!bad && rows==0) { print "table has no provider rows"; bad=1 }; exit bad }
  ' "$f" >&2 || return 1
}

# --- read-only modes ---------------------------------------------------------
case "${1:-}" in
  --show)
    _model_routing_table
    exit 0 ;;
  --validate)
    f="${2:-}"
    if [ -z "$f" ]; then
      # validate the effective table (journal override if present, else tracked default)
      f="$(mktemp)"; _model_routing_table > "$f"
      validate_routing_table "$f"; rc=$?; rm -f "$f"
      [ "$rc" -eq 0 ] && log "effective model-routing table is valid"
      exit "$rc"
    fi
    validate_routing_table "$f" && { log "model-routing table valid: $f"; exit 0; } || exit 1 ;;
esac

# --- mutating modes ----------------------------------------------------------
REMOVE=""
if [ "${1:-}" = "--remove" ]; then
  REMOVE="${2:?usage: set-model-routing.sh --remove <provider>}"
  provider="$REMOVE"; patterns=""; default=""
else
  provider="${1:?usage: set-model-routing.sh <provider> <patterns> [default] | --remove <provider> | --show | --validate}"
  patterns="${2?usage: set-model-routing.sh <provider> <patterns> [default]}"
  default="${3:-}"
fi
case "$provider" in
  ''|*[[:space:]]*|-*) die "illegal provider '$provider'";;
esac
# A tab in a supplied field would corrupt the TSV column framing.
case "$patterns$default" in *$'\t'*) die "patterns/default must not contain a TAB";; esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/config"
  cur="$DIR/$RELPATH"
  tmp="$(mktemp)"
  if [ -s "$cur" ]; then
    cp "$cur" "$tmp"
  else
    # Seed a fresh journal table from the tracked canonical defaults so the result
    # is always a COMPLETE table, never a single-row partial.
    def_file="$(_model_routing_defaults_file)"
    [ -s "$def_file" ] && cp "$def_file" "$tmp" || : > "$tmp"
  fi
  # Rewrite the provider's row: drop any existing row for it, then (unless removing)
  # append the new one. Comments/other rows are preserved verbatim.
  out="$(mktemp)"
  awk -F'\t' -v p="$provider" '
    /^[[:space:]]*#/ { print; next }
    /^[[:space:]]*$/ { print; next }
    $1==p { next }
    { print }
  ' "$tmp" > "$out"
  if [ -z "$REMOVE" ]; then
    printf '%s\t%s\t%s\n' "$provider" "$patterns" "$default" >> "$out"
  fi
  # Validate BEFORE staging so a bad edit can never be committed.
  if ! validate_routing_table "$out"; then rm -f "$tmp" "$out"; die "refusing to write an invalid model-routing table"; fi
  mv "$out" "$cur"; rm -f "$tmp"
  git -C "$DIR" add "$RELPATH"
  if [ -n "$REMOVE" ]; then msg="config: model-routing remove $provider"; else msg="config: model-routing $provider=[$patterns] default=[$default]"; fi
  rc=0; commit_and_push "$DIR" "$msg" || rc=$?
  [ "$rc" -eq 0 ] && { log "$msg"; exit 0; }
  [ "$rc" -eq 2 ] && { log "model-routing already at desired state ($provider)"; exit 0; }
  log "set-model-routing lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not set model-routing after retries"
