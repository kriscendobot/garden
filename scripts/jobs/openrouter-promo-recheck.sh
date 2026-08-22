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
#   2. THIS JANITOR (on top): prune the expired rows for real, and — when the key is
#      present — 404-probe each surviving id against OpenRouter's live listing and drop
#      any that has rotated away. Every disable raises one deduped maintainer alert.
#
# USAGE
#   openrouter-promo-recheck.sh [schedule-name]
# It is designed to be wired as a SCHEDULE PREFLIGHT (skill: schedule) on a daily
# cadence: it performs enforcement in-band and exits 2 ("no work"), so the scheduler
# advances the clock and dispatches NO agent. Register it host-side (leader only) with:
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
GARDEN_TAG="openrouter-promo-recheck"

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

# _promo_id_alive <wire-id> — status-only liveness probe against OpenRouter's live
# model listing. Prints one of: alive | gone | unknown. `unknown` on a transient
# (429/503/network/absent key) so a blip NEVER auto-drops a still-valid id; only a
# definitive 404 returns `gone`. Never prints the key, a header, or any response body.
_promo_id_alive() {
  local wire="$1" key status rc base
  key="${OPENROUTER_API_KEY:-}"
  [ -n "$key" ] || { printf 'unknown\n'; return 0; }
  command -v curl >/dev/null 2>&1 || { printf 'unknown\n'; return 0; }
  base="${GARDEN_OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}"
  set +e
  status="$(curl -sS -o /dev/null -w '%{http_code}' --connect-timeout 5 --max-time 15 \
    -H "Authorization: Bearer $key" "$base/models/$wire/endpoints" 2>/dev/null)"
  rc=$?
  set -e
  [ "$rc" -eq 0 ] || { printf 'unknown\n'; return 0; }
  case "$status" in
    404) printf 'gone\n' ;;
    2*)  printf 'alive\n' ;;
    *)   printf 'unknown\n' ;;   # 401/403/429/503/etc — do not auto-drop on these
  esac
}

disabled=0
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
      gone) reason="OpenRouter no longer lists it (404) — it has rotated away or been withdrawn" ;;
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

if [ "$disabled" -gt 0 ]; then
  log "openrouter-promo recheck: auto-disabled $disabled cloaked id(s)"
else
  log "openrouter-promo recheck: all enabled cloaked ids fresh and live"
fi
# Deterministic enforcement done in-band; never dispatch an agent job.
exit 2
