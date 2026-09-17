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
# (config-absent for worker leveling). Since credit-controls-fail-closed-pools the
# CLAIM gate (pool_admits/pool_admission_refusal) consults BOTH kind and provenance and
# FAILS CLOSED on an untrustworthy pool: an `unmetered` pool (no ceiling) or an
# uncalibrated cap now REFUSES every claim rather than admitting at full authority.
# So the escape hatch out of a fail-closed halt is exactly this setter: promote a
# CALIBRATED cap (a provenance outside the uncalibrated set) so the pool gates on a
# real number instead of refusing. Do not promote a fit graded below `converged`: an
# uncalibrated marker no longer merely disarms leveling, it halts the host's claims.
#
#   set-budget-pool.sh <pool_id> <ceiling> <calibrated_from> [calibrated_at] [--kind KIND] [--monk-cap N] [--cleric-cap M]
#
#   <pool_id>          for example anthropic:endolin-garden-ece02cb4
#   <ceiling>          integer token cap (weekly-tokens), or `-` for an unmetered pool
#   <calibrated_from>  provenance, for example `manual-fit`, `usage-sample`, `placeholder`
#   [calibrated_at]    ISO date/time (default: today, UTC)
#   --kind KIND        ceiling_kind: weekly-tokens (default) | unmetered | weekly-usd
#   --monk-cap N       host monk physical cap for the worker-leveling row (see below)
#   --cleric-cap M     host cleric physical cap (optional; default 0 on an insert)
#
# Worker-leveling physical-cap coupling. budget-level.sh apportions one fleet monk
# ceiling across every ENABLED (calibrated) Anthropic weekly-tokens pool, and each such
# pool's host MUST carry a `host <id> <monk-cap> <cleric-cap>` row in journal
# config/worker-leveling (proportional-worker-leveling.md § 1.4). If one enabled pool's
# host has no physical-cap row, budget-level fails the fleet-wide provenance/capacity gate
# and FREEZES all monk allocation every tick — no monk count may rise anywhere until a
# human notices. That is a config error this setter must catch at the write boundary
# rather than let the leveler rediscover forever (the oros-studio-garden-ce242c49 incident:
# a freshly calibrated pool with no host row).
#
# So when this setter enables a CALIBRATED Anthropic weekly-tokens pool (provenance outside
# the uncalibrated set) AND worker-leveling is configured (the file exists), it REQUIRES the
# host's physical cap and, in the SAME atomic journal commit as the pool row:
#   * validates an existing host row's monk cap (positive integer); or
#   * upserts the host row from --monk-cap (and optional --cleric-cap) — insert if absent,
#     update if --monk-cap overrides an existing value; or
#   * REJECTS (exit 2) when the host row is absent and no --monk-cap is supplied, or when
#     the resulting file would still freeze the fleet (monk-fleet-ceiling above physical
#     capacity, or below the one-per-host floor — both a set-worker-leveling.sh policy call).
# It never invents or changes the fleet ceilings (F/K_max): those stay a deliberate
# set-worker-leveling.sh decision. When worker-leveling is NOT configured, leveling is off
# and no freeze is possible, so no physical cap is required.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=set-budget-pool

usage() { echo "usage: set-budget-pool.sh <pool_id> <ceiling> <calibrated_from> [calibrated_at] [--kind weekly-tokens|unmetered|weekly-usd] [--monk-cap N] [--cleric-cap M]" >&2; exit 2; }

pool="${1:-}"; ceiling="${2:-}"; calibrated_from="${3:-}"
[ -n "$pool" ] && [ -n "$ceiling" ] && [ -n "$calibrated_from" ] || usage
case "$pool" in *:*) ;; *) echo "pool_id must be provider:host, for example anthropic:endolin-garden-ece02cb4" >&2; exit 2;; esac
shift 3
calibrated_at=""; kind="weekly-tokens"; monk_cap=""; cleric_cap=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --kind) kind="${2:?}"; shift 2;;
    --monk-cap) monk_cap="${2:?}"; shift 2;;
    --cleric-cap) cleric_cap="${2:?}"; shift 2;;
    -*) echo "unknown option: $1" >&2; usage;;
    *) [ -z "$calibrated_at" ] || usage; calibrated_at="$1"; shift;;
  esac
done
case "$kind" in weekly-tokens|unmetered|weekly-usd) ;; *) echo "--kind must be weekly-tokens|unmetered|weekly-usd" >&2; exit 2;; esac
[ -z "$monk_cap" ] || [[ "$monk_cap" =~ ^[1-9][0-9]*$ ]] || { echo "--monk-cap must be a positive integer" >&2; exit 2; }
[ -z "$cleric_cap" ] || [[ "$cleric_cap" =~ ^[0-9]+$ ]] || { echo "--cleric-cap must be a non-negative integer" >&2; exit 2; }
[ -n "$calibrated_at" ] || calibrated_at="$(date -u +%F)"
provider="${pool%%:*}"; host="${pool#*:}"

# When we ENABLE a calibrated Anthropic weekly-tokens pool, budget-level.sh will demand a
# worker-leveling physical-cap row for this host or freeze the whole monk fleet. Gate the
# physical-cap coupling on exactly that condition (see the header).
require_leveling=0
if [ "$provider" = anthropic ] && [ "$kind" = weekly-tokens ] && ! pool_provenance_uncalibrated "$calibrated_from"; then
  require_leveling=1
fi

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

# _leveling_reconcile <dir> — validate/upsert this host's worker-leveling physical-cap row
# so enabling a calibrated Anthropic pool cannot freeze the monk fleet. Returns:
#   0  nothing to do, or the file was reconciled and staged;
#   3  hard reject (do not retry — a config decision the operator must make);
#   1  transient local failure (mktemp/git) — the caller retries after a re-sync.
# Operates on the synced clone the caller already prepared; pure function of that state,
# so a CAS retry re-derives it idempotently.
_leveling_reconcile() {
  local dir="$1"
  local file="$dir/config/worker-leveling"
  # No leveling configured => budget-level exits "leveling frozen/off" before the per-pool
  # physical-cap gate, so no missing-row freeze is possible and no cap is required. But a
  # --monk-cap here has nowhere valid to land: the fleet ceilings are a deliberate policy
  # the operator sets first with set-worker-leveling.sh.
  if [ ! -f "$file" ]; then
    if [ -n "$monk_cap" ] || [ -n "$cleric_cap" ]; then
      echo "set-budget-pool: worker-leveling is not configured; establish fleet ceilings and per-host caps first with set-worker-leveling.sh <monk-fleet> <cleric-fleet> <host:monk:cleric>..." >&2
      return 3
    fi
    return 0
  fi

  local have_row existing_mc existing_cc
  read -r have_row existing_mc existing_cc < <(awk -v h="$host" '
    $1=="host" && $2==h { print "1", $3, $4; found=1; exit }
    END { if (!found) print "0", "", "" }' "$file")

  local new_mc new_cc action
  if [ "$have_row" = 1 ]; then
    [ -n "$monk_cap" ] && new_mc="$monk_cap" || new_mc="$existing_mc"
    [ -n "$cleric_cap" ] && new_cc="$cleric_cap" || new_cc="$existing_cc"
    [[ "$new_mc" =~ ^[1-9][0-9]*$ ]] || { echo "set-budget-pool: host $host worker-leveling monk physical cap '${existing_mc:-}' is invalid; pass --monk-cap N to fix it" >&2; return 3; }
    [[ "$new_cc" =~ ^[0-9]+$ ]] || { echo "set-budget-pool: host $host worker-leveling cleric physical cap '${existing_cc:-}' is invalid; pass --cleric-cap M to fix it" >&2; return 3; }
    # Already valid and no override => validate-only, nothing to write.
    [ "$new_mc" = "$existing_mc" ] && [ "$new_cc" = "$existing_cc" ] && return 0
    action=update
  else
    [ -n "$monk_cap" ] || { echo "set-budget-pool: host $host has no worker-leveling physical-cap row; enabling calibrated pool $pool would FREEZE all monk allocation fleet-wide. Pass --monk-cap N (and optional --cleric-cap M) to upsert it atomically, or run set-worker-leveling.sh." >&2; return 3; }
    new_mc="$monk_cap"; [ -n "$cleric_cap" ] && new_cc="$cleric_cap" || new_cc=0
    action=insert
  fi

  local tmp; tmp="$(mktemp)" || return 1
  awk -v h="$host" -v mc="$new_mc" -v cc="$new_cc" -v action="$action" '
    BEGIN { OFS="\t" }
    $1=="host" && $2==h { print "host", h, mc, cc; done=1; next }
    { print }
    END { if (!done) print "host", h, mc, cc }
  ' "$file" > "$tmp" || { rm -f "$tmp"; return 1; }

  # Never trade the missing-row freeze for a ceiling-vs-capacity freeze: after the upsert
  # the file must still satisfy the invariants budget-level.sh and set-worker-leveling.sh
  # enforce. We only touch physical caps here, never the fleet ceiling.
  local mf hcount ssum
  read -r mf hcount ssum < <(awk '
    $1=="monk-fleet-ceiling" { mf=$2 }
    $1=="host" { h++; s+=$3 }
    END { print mf, h+0, s+0 }' "$tmp")
  if [[ "$mf" =~ ^[1-9][0-9]*$ ]]; then
    if [ "$ssum" -lt "$mf" ]; then echo "set-budget-pool: upsert leaves monk physical capacity ($ssum) below the monk-fleet-ceiling ($mf); raise per-host caps or lower the ceiling via set-worker-leveling.sh" >&2; rm -f "$tmp"; return 3; fi
    if [ "$mf" -lt "$hcount" ]; then echo "set-budget-pool: monk-fleet-ceiling ($mf) is below the one-per-host floor ($hcount hosts) after the upsert; raise it via set-worker-leveling.sh" >&2; rm -f "$tmp"; return 3; fi
  fi

  mv "$tmp" "$file" || { rm -f "$tmp"; return 1; }
  git -C "$dir" add "config/worker-leveling" || return 1
  log "worker-leveling host $host <- monk-cap=$new_mc cleric-cap=$new_cc ($action, coupled to budget-pool $pool)"
  return 0
}

_set_once() {
  local dir="$1"
  local file="$dir/config/budget-pools" tmp
  mkdir -p "$dir/config" || return 1
  # Couple the worker-leveling physical cap into the SAME commit. A hard reject (rc 3)
  # aborts before we touch config/budget-pools, so a bad promotion lands neither file.
  if [ "$require_leveling" -eq 1 ]; then
    local lrc=0; _leveling_reconcile "$dir" || lrc=$?
    [ "$lrc" -eq 0 ] || return "$lrc"
  fi
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

# rc 3 from _set_once is a hard config reject (missing/uncompleteable physical cap):
# surface it as exit 2 immediately, never burning the push-retry budget on it.
sync_clone "$DIR"
rc=0; _set_once "$DIR" || rc=$?
[ "$rc" -eq 0 ] && exit 0
[ "$rc" -eq 3 ] && exit 2
for attempt in 2 3 4 5 6 7 8; do
  backoff "$((attempt - 1))"
  rc=0; ( sync_clone "$DIR"; _set_once "$DIR" ) || rc=$?
  [ "$rc" -eq 0 ] && exit 0
  [ "$rc" -eq 3 ] && exit 2
done
echo "set-budget-pool: exhausted journal-push attempts" >&2
exit 1
