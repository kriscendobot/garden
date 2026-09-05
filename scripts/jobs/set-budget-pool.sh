#!/bin/bash
# set-budget-pool.sh — the deliberate promotion of a measured weekly-token cap into
# journal config/budget-pools, with provenance. This is the ACTUATE half of the
# measure/actuate boundary: fit-quota-calibration.sh (and weekly-capacity-calibration.sh)
# MEASURE and never touch config/budget-pools; this setter is the one place a human or
# a proxy role turns a measured figure into a live cap the leveling controller and the
# claim gate act on. Design: designs/manual-quota-calibration.md.
#
# It writes the provenance columns (calibrated_from, calibrated_at) that
# budget-level.sh's budget_level_uncalibrated predicate reads: a provenance of
# placeholder/uncalibrated/seed/tbd/todo/none/'-'/'' makes budget-level LEVEL NOTHING
# (config-absent for worker leveling). NOTE the asymmetry this setter cannot hide: the
# CLAIM gate (pool_admits/meter_quota_status) reads only the ceiling column and does
# NOT consult provenance, so ANY cap you write here arms per-claim admission at full
# authority regardless of its provenance marker. Do not promote a fit graded below
# `converged` expecting the uncalibrated marker to neuter it — it only disarms leveling,
# not admission. The approved design deliberately keeps that claim gate hard: never
# promote a fit below `converged`, and never expect provenance to make a configured
# cap fail open.
#
#   set-budget-pool.sh <pool_id> <ceiling> <calibrated_from> [calibrated_at] [--kind KIND]
#
#   <pool_id>          for example anthropic:endolin-garden-ece02cb4
#   <ceiling>          integer token cap (weekly-tokens), or `-` for an unmetered pool
#   <calibrated_from>  provenance, for example `manual-fit`, `usage-sample`, `placeholder`
#   [calibrated_at]    ISO date/time (default: today, UTC)
#   --kind KIND        ceiling_kind: weekly-tokens (default) | unmetered | weekly-usd
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=set-budget-pool

usage() { echo "usage: set-budget-pool.sh <pool_id> <ceiling> <calibrated_from> [calibrated_at] [--kind weekly-tokens|unmetered|weekly-usd]" >&2; exit 2; }

pool="${1:-}"; ceiling="${2:-}"; calibrated_from="${3:-}"
[ -n "$pool" ] && [ -n "$ceiling" ] && [ -n "$calibrated_from" ] || usage
case "$pool" in *:*) ;; *) echo "pool_id must be provider:host, for example anthropic:endolin-garden-ece02cb4" >&2; exit 2;; esac
shift 3
calibrated_at=""; kind="weekly-tokens"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --kind) kind="${2:?}"; shift 2;;
    -*) echo "unknown option: $1" >&2; usage;;
    *) [ -z "$calibrated_at" ] || usage; calibrated_at="$1"; shift;;
  esac
done
case "$kind" in weekly-tokens|unmetered|weekly-usd) ;; *) echo "--kind must be weekly-tokens|unmetered|weekly-usd" >&2; exit 2;; esac
[ -n "$calibrated_at" ] || calibrated_at="$(date -u +%F)"
provider="${pool%%:*}"; host="${pool#*:}"

# Validate the ceiling against the kind so a fat-fingered value cannot arm the claim
# gate on garbage. weekly-tokens: positive integer. unmetered: literal `-`. weekly-usd:
# positive number.
case "$kind" in
  weekly-tokens) [[ "$ceiling" =~ ^[0-9]+$ ]] && [ "$ceiling" -gt 0 ] || { echo "weekly-tokens ceiling must be a positive integer" >&2; exit 2; } ;;
  unmetered)     [ "$ceiling" = "-" ] || { echo "unmetered pools take ceiling '-'" >&2; exit 2; } ;;
  weekly-usd)    [[ "$ceiling" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "weekly-usd ceiling must be a number" >&2; exit 2; } ;;
esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

_set_once() {
  local dir="$1"
  local file="$dir/config/budget-pools" tmp
  mkdir -p "$dir/config" || return 1
  [ -f "$file" ] || : > "$file"
  tmp="$(mktemp)" || return 1
  # Preserve every comment and blank line verbatim; replace the matching pool row in
  # place, or append a new row (after the last existing row) if absent.
  awk -v pool="$pool" -v provider="$provider" -v host="$host" -v kind="$kind" \
      -v ceiling="$ceiling" -v cf="$calibrated_from" -v ca="$calibrated_at" '
    BEGIN { newrow = pool "\t" provider "\t" host "\t" kind "\t" ceiling "\t" cf "\t" ca }
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { print; next }
    { if ($1 == pool) { print newrow; found=1 } else { print; last=NR } }
    END { if (!found) print newrow }
  ' "$file" > "$tmp" || { rm -f "$tmp"; return 1; }
  mv "$tmp" "$file" || return 1
  git -C "$dir" add "config/budget-pools" || return 1
  log "budget-pool $pool <- kind=$kind ceiling=$ceiling calibrated_from=$calibrated_from calibrated_at=$calibrated_at"
  local rc=0
  commit_and_push "$dir" "budget-pool($pool) kind=$kind ceiling=$ceiling from=$calibrated_from" || rc=$?
  [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]
}

sync_clone "$DIR"
if _set_once "$DIR"; then exit 0; fi
for attempt in 2 3 4 5 6 7 8; do
  backoff "$((attempt - 1))"
  if ( sync_clone "$DIR"; _set_once "$DIR" ); then exit 0; fi
done
echo "set-budget-pool: exhausted journal-push attempts" >&2
exit 1
