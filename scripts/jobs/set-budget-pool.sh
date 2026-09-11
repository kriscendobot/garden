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
  # Preserve unrelated comments and blank lines verbatim, but remove any
  # host-specific calibration block for this pool. Refresh cap figures that name the
  # pool inside shared prose instead of heading their own block; otherwise a summary
  # can keep advertising an old cap after the authoritative row changes. Replace the
  # matching pool row in place, or append a new row if absent.
  awk -v pool="$pool" -v provider="$provider" -v host="$host" -v kind="$kind" \
      -v ceiling="$ceiling" -v cf="$calibrated_from" -v ca="$calibrated_at" '
    BEGIN {
      newrow = pool "\t" provider "\t" host "\t" kind "\t" ceiling "\t" cf "\t" ca
      cap_re = "([$][0-9]+([.][0-9]+)?|[0-9]+([.][0-9]+)?[[:space:]]*[kKmMgGtT]([[:space:]]*(tokens?|token-cap))?|[0-9]+[[:space:]]+tokens?)[[:space:]]*(/[[:space:]]*(w|wk|week)|per[[:space:]]+week|weekly)"
    }
    function comment_indent(line, tail) {
      sub(/^[[:space:]]*#/, "", line)
      match(line, /^[[:space:]]*/)
      return RLENGTH
    }
    function target_header(line, value, text, rest) {
      text = line
      sub(/^[[:space:]]*#[[:space:]]*/, "", text)
      if (substr(text, 1, length(value)) != value) return 0
      rest = substr(text, length(value) + 1)
      return rest ~ /^[[:space:]]*:/
    }
    function target_position(line, p, q) {
      p = index(line, pool)
      q = index(line, host)
      if (p && (!q || p <= q)) {
        target_len = length(pool)
        return p
      }
      target_len = length(host)
      return q
    }
    function other_pool_before(text, limit, id, p) {
      for (id in pool_ids) {
        if (id == pool || id == host) continue
        p = index(text, id)
        if (p && p < limit) return 1
      }
      return 0
    }
    function cap_display(value, short) {
      if (kind == "unmetered") return "unmetered"
      if (kind == "weekly-usd") return "$" value "/wk"
      short = value
      if (value ~ /^[0-9]+000000000$/) short = substr(value, 1, length(value) - 9) "G"
      else if (value ~ /^[0-9]+000000$/) short = substr(value, 1, length(value) - 6) "M"
      else if (value ~ /^[0-9]+000$/) short = substr(value, 1, length(value) - 3) "K"
      else short = value " tokens"
      return short "/wk"
    }
    function refresh_cap_after(line, start, tail, before, after) {
      cap_replaced = 0
      tail = substr(line, start)
      if (!match(tail, cap_re) || other_pool_before(tail, RSTART)) return line
      if (substr(tail, 1, RSTART - 1) ~ /;/) return line
      before = substr(line, 1, start + RSTART - 2)
      after = substr(tail, RSTART + RLENGTH)
      cap_replaced = 1
      return before cap_display(ceiling) after
    }
    function refresh_cap_before(line, stop, head, scan, offset, base, semi, last_start, last_len, other, id, p) {
      cap_replaced = 0
      head = substr(line, 1, stop - 1)
      base = 0
      scan = head
      while ((semi = index(scan, ";"))) {
        base += semi
        scan = substr(scan, semi + 1)
      }
      head = substr(head, base + 1)
      scan = head
      offset = base
      while (match(scan, cap_re)) {
        last_start = offset + RSTART
        last_len = RLENGTH
        offset += RSTART + RLENGTH - 1
        scan = substr(scan, RSTART + RLENGTH)
      }
      if (!last_start) return line
      other = 0
      for (id in pool_ids) {
        if (id == pool || id == host) continue
        p = index(head, id)
        if (p > other) other = p
      }
      if (other > last_start) return line
      cap_replaced = 1
      return substr(line, 1, last_start - 1) cap_display(ceiling) substr(line, last_start + last_len)
    }
    NR == FNR {
      if ($0 !~ /^[[:space:]]*#/ && $0 !~ /^[[:space:]]*$/) {
        pool_ids[$1] = 1
        pool_ids[$3] = 1
      }
      next
    }
    {
      is_comment = ($0 ~ /^[[:space:]]*#/)
      if (dropping_header) {
        if ($0 ~ /^[[:space:]]*$/) { print; next }
        if (is_comment && comment_indent($0) > header_indent) next
        dropping_header = 0
      }
      if (is_comment && (target_header($0, host) || target_header($0, pool))) {
        header_indent = comment_indent($0)
        dropping_header = 1
        pending_embedded = 0
        next
      }
      if (is_comment) {
        line = $0
        target_at = target_position($0)
        if (target_at) {
          line = refresh_cap_after(line, target_at + target_len)
          changed = cap_replaced
          if (!changed) {
            line = refresh_cap_before(line, target_at)
            changed = cap_replaced
          }
          pending_embedded = !changed
        } else if (pending_embedded) {
          line = refresh_cap_after(line, 1)
          if (cap_replaced) pending_embedded = 0
          else if (other_pool_before(line, length(line) + 1)) pending_embedded = 0
        }
        print line
        next
      }
      pending_embedded = 0
      if ($0 ~ /^[[:space:]]*$/) { print; next }
      if ($1 == pool) { print newrow; found=1 } else print
    }
    END { if (!found) print newrow }
  ' "$file" "$file" > "$tmp" || { rm -f "$tmp"; return 1; }
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
