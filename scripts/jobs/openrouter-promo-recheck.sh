#!/bin/bash
# openrouter-promo-recheck.sh — the cloaked-lane re-review cadence enforcer.
#
# A cloaked ("stealth") OpenRouter id can vanish or silently become a different model
# at any moment, so the design mandates a SHORT re-review cadence that AUTOMATICALLY
# DISABLES an id which 404s or which the maintainer has not re-attested within the
# window (designs/openrouter-provider.md § the stealth/promotional lane). This script
# is that enforcer, and it is DETERMINISTIC — plain code, NO `claude`/`codex`, no LLM.
#
# Two layers of safety, so the disable never depends on this timer firing:
#   1. READ-SIDE (primary, daemon-free): common.sh drops any ledger row whose
#      attestation is older than the cadence window at CLASSIFY time, so a stale id is
#      already unclaimable before this ever runs.
#   2. THIS JANITOR (on top): prune expired rows, check each surviving id against
#      OpenRouter's live /models listing, and run a two-turn live tool canary when
#      the key is present. A missing listing or request 404 drops the row. Every
#      disable raises one deduped maintainer alert.
#
# USAGE
#   openrouter-promo-recheck.sh [schedule-name]
# It is wired as a SCHEDULE PREFLIGHT (skill: schedule) on a daily
# cadence: it performs enforcement in-band and exits 2 ("no work"), so the scheduler
# advances the clock and dispatches NO agent. Repair its schedule definition with:
#   GARDEN_SCHEDULE_PREFLIGHT=openrouter-promo-recheck.sh \
#     set-schedule.sh openrouter-promo-recheck daily openrouter-promo-recheck <body-file>
# It may also be run directly by an operator for an immediate sweep.
#
# EXIT CODES (as a scheduler preflight): always 2 (no LLM dispatch). It never returns
# 0, because there is never an agent job to run — the whole point is deterministic
# enforcement with no model in the loop.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="openrouter-promo-recheck"

rel="${GARDEN_OPENROUTER_PROMOS_PATH:-config/openrouter-promos}"
cadence="${GARDEN_OPENROUTER_PROMO_CADENCE_SECS:-86400}"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"
f="$DIR/$rel"

if [ ! -s "$f" ]; then
  log "no openrouter-promo ledger; nothing to recheck"
  exit 2
fi

now="$(date -u +%s)"
cutoff=$(( now - cadence ))

# _promo_id_alive <wire-id> -- inspect OpenRouter's public /models listing without
# printing it. Prints one of: alive | gone | unknown. A missing exact id or a 404 is
# `gone`; malformed output, a transient, or a missing local dependency is `unknown`.
_promo_id_alive() {
  local wire="$1" status rc base body
  command -v curl >/dev/null 2>&1 || { printf 'unknown\n'; return 0; }
  command -v jq >/dev/null 2>&1 || { printf 'unknown\n'; return 0; }
  base="${GARDEN_OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}"
  body="$(mktemp "${GARDEN_STATE:-$GARDEN_ROOT/scratch}/openrouter-models.XXXXXX")"
  set +e
  status="$(curl -sS -o "$body" -w '%{http_code}' --connect-timeout 5 --max-time 30 \
    "${base%/}/models" 2>/dev/null)"
  rc=$?
  set -e
  [ "$rc" -eq 0 ] || { rm -f "$body"; printf 'unknown\n'; return 0; }
  case "$status" in
    404) rm -f "$body"; printf 'gone\n' ;;
    2*)
      if jq -e --arg wire "$wire" '.data[]? | select(.id == $wire)' "$body" >/dev/null 2>&1; then
        rm -f "$body"; printf 'alive\n'
      elif jq -e '.data | type == "array"' "$body" >/dev/null 2>&1; then
        rm -f "$body"; printf 'gone\n'
      else
        rm -f "$body"; printf 'unknown\n'
      fi
      ;;
    *) rm -f "$body"; printf 'unknown\n' ;; # do not auto-drop on transients
  esac
}

disabled=0; canary_passed=0; canary_failed=0; canary_skipped=0
# Read the ledger from the synced clone; drop offenders via the tested CAS path.
while IFS=$'\t' read -r wire tier at by; do
  case "$wire" in ''|\#*) continue;; esac
  reason=""
  ts="$(date -u -d "$at" +%s 2>/dev/null || true)"
  if [ -z "$ts" ]; then
    reason="its attestation timestamp ('$at') is unparsable"
  elif [ "$ts" -lt "$cutoff" ]; then
    reason="its attestation ($at, by ${by:-unknown}) is older than the ${cadence}s re-review window and was not refreshed"
  else
    case "$(_promo_id_alive "$wire")" in
      gone) reason="OpenRouter's /models listing no longer contains it (or returned 404); it rotated away or was withdrawn" ;;
    esac
  fi
  if [ -z "$reason" ]; then
    canary_rc=0
    "$HERE/openrouter-promo-tool-canary.sh" "$wire" >/dev/null 2>&1 || canary_rc=$?
    case "$canary_rc" in
      0) canary_passed=$((canary_passed + 1)) ;;
      2) canary_skipped=$((canary_skipped + 1)) ;;
      44) reason="its live tool-using canary returned a definitive 404" ;;
      *)
        canary_failed=$((canary_failed + 1))
        alert_maintainer "openrouter-promo-canary-$(printf '%s' "$wire" | tr -c 'A-Za-z0-9._-' '-')" \
          "Cloaked OpenRouter id '$wire' remains listed but failed its required live tool-using canary. It was not auto-dropped because the failure was not a definitive 404; inspect before re-attesting."
        ;;
    esac
  fi
  if [ -n "$reason" ]; then
    log "auto-disabling cloaked id $wire ($tier): $reason"
    if "$HERE/openrouter-promo-drop.sh" "$wire" >/dev/null 2>&1; then
      disabled=$((disabled + 1))
      alert_maintainer "openrouter-promo-disabled-$(printf '%s' "$wire" | tr -c 'A-Za-z0-9._-' '-')" \
        "Auto-disabled cloaked OpenRouter id '$wire' (tier $tier): $reason. Re-attest with openrouter-promo-attest.sh if it is back and still reviewed."
    else
      log "WARN could not drop $wire this tick; will retry next cadence (read-side filter still fails it closed)"
    fi
  fi
done < "$f"

log "openrouter-promo recheck: disabled=$disabled tool_canary_passed=$canary_passed tool_canary_failed=$canary_failed tool_canary_skipped=$canary_skipped"
# Deterministic enforcement done in-band; never dispatch an agent job.
exit 2
