#!/bin/bash
# migrate-host-to-monk.sh — cut THIS host's Anthropic worker pool over from the
# legacy garden-gardener@ units to the canonical garden-monk@ units, as the staged,
# reversible per-host transaction in designs/anthropic-worker-kind-monk.md
# § Staged, reversible rollout stage 1. Run ON the host being migrated (it drains
# and reconciles that host's OWN units only, exactly like set-workers.sh's
# same-host rule) — followers first, the leader last.
#
# Usage:
#   migrate-host-to-monk.sh cutover  [N] [host]   gardener@ pool -> monk@ pool
#   migrate-host-to-monk.sh rollback     [host]   monk@ pool  -> gardener@ pool
#   migrate-host-to-monk.sh status       [host]   report the host's Anthropic units
#
# N defaults to the host's current `gardeners:` count in the journal. `host` must be
# this host ($GARDEN); the argument exists only so a wrapper can be explicit.
#
# INVARIANTS (design § stage 1):
#   * NEVER both Anthropic pools armed for one capacity slot — the transaction
#     disables every gardener@ unit and asserts zero legacy units active before it
#     reports success, and the scaler's anthropic_active_kind selector refuses to
#     re-arm the shadowed spelling in between.
#   * Append-only: it writes `monks: N` while RETAINING `gardeners: N` as the
#     old-binary mirror (never summed), and never renames/deletes a worktree, clone,
#     or live state directory.
#   * RERUNNABLE: every step checks live unit/count state, so a completed step is a
#     no-op on a re-run; a partial run resumes where it stopped and never removes the
#     `gardeners:` mirror.
#   * REFUSES to continue on a busy worker, a duplicate/both-pools-active unit, an
#     unknown claim schema on a live doin claim owned by this host, a failed unit
#     action, or a mismatched count.
#   * This command changes neither a deployed checkout nor the leader marker; it does
#     not move the `leader` marker or start a second singleton.
#
# It uses unit_ctl (GARDEN_UNIT_CTL-mockable) for every systemd action, so it is
# tested hermetically against test/mock-systemctl.sh.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=auction.sh
source "$HERE/auction.sh"   # canonical_worker_kind's decode is used on live claims
GARDEN_TAG="monk-migrate"

action="${1:-status}"

# --- helpers -----------------------------------------------------------------

# A bounded wait for every legacy gardener busy marker (indices 1..N) to clear, so
# the cutover stops a worker BETWEEN claims, never mid-`claude -p`.
MONK_MIGRATE_DRAIN_WAIT="${MONK_MIGRATE_DRAIN_WAIT:-600}"   # seconds
MONK_MIGRATE_POLL="${MONK_MIGRATE_POLL:-3}"

any_busy() {  # any_busy <kind> <N>
  local kind="$1" n="$2" i
  for ((i=1; i<=n; i++)); do worker_busy "$kind" "$i" && return 0; done
  return 1
}

unit_active() { unit_ctl is-active "$1" >/dev/null 2>&1; }

# count_active <unit-prefix> <N> — how many of <prefix>1..N report active.
count_active() {
  local pfx="$1" n="$2" i c=0
  for ((i=1; i<=n; i++)); do unit_active "${pfx}$i.service" && c=$((c+1)); done
  printf '%s\n' "$c"
}

# read the host's declared gardeners: count from a fresh journal clone.
host_gardeners_count() {
  local clone="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  ensure_clone "$clone"; sync_clone "$clone"
  read_desired_count "$clone/hosts/$host" gardeners 2>/dev/null || return 1
}
host_monks_count() {
  local clone="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  ensure_clone "$clone"; sync_clone "$clone"
  read_desired_count "$clone/hosts/$host" monks 2>/dev/null || return 1
}

# Refuse if any live doin claim owned by THIS host/instance carries a worker_kind
# the SOLE decoder cannot classify (an unknown-schema claim — design "unknown claim
# schema" refusal). A gardener/monk/known claim is fine (it decodes); an
# unrecognized one blocks the cutover so it is diagnosed, not mis-owned.
assert_no_unknown_local_claim() {
  local clone="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}" jf host_f kind schema prov raw
  ensure_clone "$clone"; sync_clone "$clone"
  shopt -s nullglob
  for jf in "$clone/$JOBS_DOIN"/*.md; do
    host_f="$(sed -n 's/^[[:space:]]*host:[[:space:]]*//p' "$jf" | head -1)"
    [ "$host_f" = "$host" ] || continue
    raw="$(sed -n 's/^[[:space:]]*worker_kind:[[:space:]]*//p' "$jf" | head -1)"
    [ -n "$raw" ] || continue
    schema="$(sed -n 's/^[[:space:]]*worker_kind_schema:[[:space:]]*//p' "$jf" | head -1)"
    prov="$(sed -n 's/^[[:space:]]*provider:[[:space:]]*//p' "$jf" | head -1)"
    if ! canonical_worker_kind "$raw" "$schema" "$prov" >/dev/null 2>&1; then
      shopt -u nullglob
      die "refusing cutover: a live doin claim ($(basename "$jf" .md)) on $host carries an undecodable worker identity (worker_kind=$raw schema=${schema:-none} provider=${prov:-none}); resolve it before migrating"
    fi
  done
  shopt -u nullglob
  return 0
}

# Record the pre-state + an audit trail under host-local state (never the journal
# working tree). Idempotence comes from live state checks, not this file; it is the
# forensic record the design's stage-1 step 5 asks for.
RECORD_DIR="${MONK_MIGRATE_RECORD_DIR:-$GARDEN_STATE/monk-migration}"
record() { mkdir -p "$RECORD_DIR"; printf '%s %s\n' "$(date -u +%FT%TZ)" "$*" >> "$RECORD_DIR/$host.log"; }

# --- cutover: gardener@ -> monk@ ---------------------------------------------
cutover() {
  local n="${1:-}"
  # N: explicit, else the host's declared gardeners: count.
  if [ -z "$n" ]; then
    n="$(host_gardeners_count)" || die "no explicit N and no gardeners: count in hosts/$host; declare it or pass N"
  fi
  [[ "$n" =~ ^[0-9]+$ ]] || die "N must be a non-negative integer (got '$n')"
  [ "$n" -ge 1 ] || die "refusing cutover with N=$n; nothing to migrate (a zero Anthropic pool is not a rename)"
  local gpfx mpfx; gpfx="$(worker_kind_field gardener unit)"; mpfx="$(worker_kind_field monk unit)"  # garden-gardener@ / garden-monk@

  # If the host is already fully cut over (monks: present and exactly N monk units
  # active, zero gardener units), report success — the whole command is a no-op.
  if [ "$(count_active "$mpfx" "$n")" -eq "$n" ] && [ "$(count_active "$gpfx" "$n")" -eq 0 ] && host_monks_count >/dev/null 2>&1; then
    log "host '$host' already cut over to monk (monks pool active, no legacy units); nothing to do"
    return 0
  fi

  record "cutover start N=$n gardener_active=$(count_active "$gpfx" "$n") monk_active=$(count_active "$mpfx" "$n")"

  # STEP 1 — local drain, then wait for every legacy busy marker to clear.
  "$HERE/drain-fleet.sh" on "monk cutover of $host (gardener@ -> monk@)" >/dev/null 2>&1 || true
  local waited=0
  while any_busy gardener "$n"; do
    [ "$waited" -lt "$MONK_MIGRATE_DRAIN_WAIT" ] || die "refusing cutover: a garden-gardener@ worker is still busy after ${MONK_MIGRATE_DRAIN_WAIT}s; re-run once it goes idle (drain stays ON)"
    sleep "$MONK_MIGRATE_POLL"; waited=$((waited + MONK_MIGRATE_POLL))
  done

  # STEP 2 — no live doin claim on this host carries an undecodable identity.
  assert_no_unknown_local_claim

  # STEP 3 — write monks: N, RETAINING gardeners: N as the old-binary mirror.
  # set-monks.sh (set-workers.sh monk) writes only the monks: line and preserves
  # every sibling, so the gardeners: mirror is kept, never summed. It fails closed if
  # the Anthropic backend probe is unavailable — but anthropic is exempt from that
  # gate (declarable ahead of the login), so this is a plain journal write.
  "$HERE/set-monks.sh" "$n" "$host" || die "failed to declare monks: $n for $host"
  host_monks_count >/dev/null 2>&1 || die "post-write verification failed: monks: not present in hosts/$host"
  host_gardeners_count >/dev/null 2>&1 || die "the gardeners: mirror disappeared during the write; refusing to proceed (rollback floor lost)"

  # STEP 4 — disable+stop every gardener@1..N, verify none active, render the monk
  # unit, then enable+start monk@1..N with the SAME indices. Each unit action is
  # checked; a failure refuses rather than leaving a half-migrated pool.
  local i u
  for ((i=1; i<=n; i++)); do
    u="${gpfx}$i.service"
    unit_ctl disable --now "$u" >/dev/null 2>&1 || die "failed to disable $u"
    unit_active "$u" && die "refusing: $u is still active after disable --now"
  done
  # Render units so garden-monk@.service exists on disk (idempotent; monk is in the
  # worker_kinds registry so `install` renders it alongside the rest). Skippable under
  # a mocked systemd (MONK_MIGRATE_SKIP_RENDER=1), where enable does not need the file.
  if [ "${MONK_MIGRATE_SKIP_RENDER:-0}" != 1 ]; then
    "$HERE/install-units.sh" install >/dev/null 2>&1 || die "failed to render/install units (garden-monk@ template)"
  fi
  for ((i=1; i<=n; i++)); do
    u="${mpfx}$i.service"
    # DUPLICATE/BOTH-POOLS guard: the paired legacy index must be down first.
    if unit_active "${gpfx}$i.service"; then die "refusing: ${gpfx}$i.service and $u would both be active for slot $i"; fi
    unit_ctl enable --now "$u" >/dev/null 2>&1 || die "failed to enable $u"
  done

  # STEP 5 — assert exactly N monk units and ZERO legacy units active, then lift the
  # drain and append the auditable host-migration record.
  local mact gact; mact="$(count_active "$mpfx" "$n")"; gact="$(count_active "$gpfx" "$n")"
  [ "$mact" -eq "$n" ] || die "post-cutover mismatch: $mact/$n garden-monk@ units active (drain stays ON for diagnosis)"
  [ "$gact" -eq 0 ]    || die "post-cutover mismatch: $gact legacy garden-gardener@ units still active (drain stays ON)"
  "$HERE/drain-fleet.sh" off >/dev/null 2>&1 || true
  record "cutover done N=$n monk_active=$mact legacy_active=$gact"
  log "host '$host' cut over to monk: $mact garden-monk@ active, 0 legacy; monks: $n written, gardeners: mirror retained; drain lifted"
}

# --- rollback: monk@ -> gardener@ (the alias-window reverse) ------------------
rollback() {
  local gpfx mpfx n; gpfx="$(worker_kind_field gardener unit)"; mpfx="$(worker_kind_field monk unit)"
  n="$(host_monks_count)" || n="$(host_gardeners_count)" \
    || die "no monks: or gardeners: count in hosts/$host to size the rollback"
  [ "$n" -ge 1 ] || die "refusing rollback with N=$n"
  record "rollback start N=$n monk_active=$(count_active "$mpfx" "$n") gardener_active=$(count_active "$gpfx" "$n")"

  # Drain, and WAIT for a busy monk rather than killing it (design: rollback waits).
  "$HERE/drain-fleet.sh" on "monk rollback of $host (monk@ -> gardener@)" >/dev/null 2>&1 || true
  local waited=0
  while any_busy monk "$n"; do
    [ "$waited" -lt "$MONK_MIGRATE_DRAIN_WAIT" ] || die "refusing rollback: a garden-monk@ worker is still busy after ${MONK_MIGRATE_DRAIN_WAIT}s; re-run once it goes idle (drain stays ON)"
    sleep "$MONK_MIGRATE_POLL"; waited=$((waited + MONK_MIGRATE_POLL))
  done

  local i u
  for ((i=1; i<=n; i++)); do
    u="${mpfx}$i.service"
    unit_ctl disable --now "$u" >/dev/null 2>&1 || die "failed to disable $u"
    unit_active "$u" && die "refusing: $u still active after disable --now"
  done
  for ((i=1; i<=n; i++)); do
    u="${gpfx}$i.service"
    if unit_active "${mpfx}$i.service"; then die "refusing: ${mpfx}$i.service and $u would both be active for slot $i"; fi
    unit_ctl enable --now "$u" >/dev/null 2>&1 || die "failed to enable $u"
  done
  # Both count keys are RETAINED (the design keeps the monks: and gardeners: mirror
  # through the alias window); the scaler's anthropic_active_kind now sees monks: and
  # would pick monk, so drop the monks: line to make the legacy pool the active one
  # again. gardeners: is preserved as the live count.
  "$HERE/set-workers.sh" gardener "$(host_gardeners_count || echo "$n")" "$host" >/dev/null 2>&1 || true
  # Remove the monks: line so anthropic_active_kind resolves back to gardener.
  drop_monks_line
  local gact mact; gact="$(count_active "$gpfx" "$n")"; mact="$(count_active "$mpfx" "$n")"
  [ "$gact" -eq "$n" ] || die "post-rollback mismatch: $gact/$n legacy units active (drain stays ON)"
  [ "$mact" -eq 0 ]    || die "post-rollback mismatch: $mact garden-monk@ units still active (drain stays ON)"
  "$HERE/drain-fleet.sh" off >/dev/null 2>&1 || true
  record "rollback done N=$n gardener_active=$gact monk_active=$mact"
  log "host '$host' rolled back to the legacy garden-gardener@ pool: $gact active, 0 monk; monks: line dropped"
}

# drop_monks_line — CAS-remove the host's monks: line from the journal so the
# active Anthropic spelling reverts to the legacy gardeners: count. Own-host only.
drop_monks_line() {
  local clone="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}" f attempt
  ensure_clone "$clone"
  for attempt in $(seq 1 30); do
    sync_clone "$clone"; f="$clone/hosts/$host"
    [ -f "$f" ] || return 0
    grep -q '^monks:' "$f" || return 0
    grep -v '^monks:' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    git -C "$clone" add "hosts/$host"
    local rc=0; commit_and_push "$clone" "monk-rollback($host) drop monks: line" || rc=$?
    { [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]; } && return 0
    backoff "$attempt"
  done
  return 1
}

status() {
  local gpfx mpfx n; gpfx="$(worker_kind_field gardener unit)"; mpfx="$(worker_kind_field monk unit)"
  n="$(host_gardeners_count || echo "?")"; local m; m="$(host_monks_count || echo "-")"
  local clone="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  ensure_clone "$clone" 2>/dev/null || true; sync_clone "$clone" 2>/dev/null || true
  local aak; aak="$(anthropic_active_kind "$clone/hosts/$host" 2>/dev/null || echo gardener)"
  echo "host: $host"
  echo "counts: gardeners=$n monks=$m  (active Anthropic kind: $aak)"
  local probe="${n}"; case "$probe" in ''|\?|*[!0-9]*) probe=8 ;; esac
  echo "units active: garden-gardener@=$(count_active "$gpfx" "$probe") garden-monk@=$(count_active "$mpfx" "$probe")"
}

host="${3:-$GARDEN}"
case "$action" in
  cutover)  host="${3:-$GARDEN}"; [ "$host" = "$GARDEN" ] || die "run the cutover ON $host (a host migrates only its own pool)"; cutover "${2:-}" ;;
  rollback) host="${2:-$GARDEN}"; [ "$host" = "$GARDEN" ] || die "run the rollback ON $host"; rollback ;;
  status)   host="${2:-$GARDEN}"; status ;;
  *) die "usage: migrate-host-to-monk.sh {cutover [N] [host]|rollback [host]|status [host]}" ;;
esac
