#!/bin/bash
# orchestrate.sh — the deterministic ORCHESTRATION watcher: sequence a multi-part
# job's child sub-jobs into todo/ and watch them to completion.
#
# Usage: orchestrate.sh   (timer-driven oneshot; one tick per invocation)
#
# The maintainer directive (kriskowal 2026-07-01): for a MULTI-PART job, always
# make ONE orchestration job that moves the planned sub-jobs off plan/ into todo/
# in sequence (default) or in parallel, and WATCHES the children so it is less
# likely to forget to follow up with the next one. This watcher is that job's
# engine — deterministic, uses NO `claude -p`, exactly like unblock.sh.
#
# An orchestration is a record `jobs/orch/<base>.md` (post-orchestration.sh) whose
# frontmatter names its children (in run order), its `order` (serial|parallel),
# and its `on-child-failure` policy (halt|continue). Its children are parked in
# plan/ with gate=orchestrated (invisible to the foreman AND the unblock watcher),
# so ONLY this watcher promotes them. Each tick it advances every active
# orchestration ONE step against the board state:
#
#   serial:   promote child #1, WATCH it reach jobs/tada/, then promote #2, … —
#             one at a time, in order. Every N>1 promotion is CAS-conditional on
#             ALL predecessors still being unambiguously in tada/ in the promotion
#             primitive's own fresh board snapshot. A tick either promotes the next
#             child, waits on the in-flight one, halts on a failure (policy=halt),
#             or completes.
#   parallel: promote ALL children at once (first tick), then watch them all; the
#             orchestration completes when every child is terminal.
#
# CHILD STATE is read purely from the board (child_state below):
#   done        — jobs/tada/<child> exists (and carries no failure marker).
#   active      — jobs/todo or jobs/doin holds it (claimed / queued, in flight),
#                 unless its deterministic liveness bounds say it has stalled.
#   progressing — in flight AND its requeue count rose above the recorded baseline,
#                 BUT it carries the gardener's productive-cycle hint (a per-job
#                 worktree HEAD advanced this cycle — the SAME signal the reaper
#                 honors to reset its doom counter). Treated like active, and the
#                 caller advances the stored reap baseline to the new floor. This is
#                 the fix for the watcher tearing down a long-running child (a shepherd
#                 driving CI, a 35-seat panel) on its first NORMAL reap-and-resume.
#   parked      — jobs/plan holds it (gate=orchestrated, not yet promoted) and it is
#                 NOT doomed.
#   failed      — either it VANISHED without reaching tada (promoted, then removed),
#                 or its tada report marks `orchestration-failed: true`, or it is
#                 parked in jobs/plan carrying `doomed: true` (the reaper exhausted its
#                 requeue budget and parked the work under a held gate rather than
#                 dropping it — reaper.sh doom branch), or it exceeded
#                 GARDEN_ORCH_STALL_REQUEUE_LIMIT non-productive requeues with NO
#                 progress hint. A failed child triggers the on-child-failure policy
#                 rather than a silent stall (or, for a doomed child, rather than an
#                 endless re-promote loop).
#
# On completion the watcher writes tada/<base> (a progress/outcome summary) and
# removes the orch record, so the orchestration shows as done on the board and is
# no longer scanned. A child FAILURE always surfaces to the maintainer inbox.
#
# Relationship to blocked_on/unblock: unblock.sh is the OTHER deterministic serial
# primitive (child B blocked_on A → promoted when A lands in tada). This watcher
# builds on the SAME "promote when the board reaches a state" substrate but OWNS
# promotion of its children, so it can also express parallelism, an active progress
# report, and a failure policy that unblock's pure edge-following cannot.
#
# Part of the garden's autonomous posture: SILENT until an error; only promotions,
# completions, failures, and the watcher's own failures surface. Leader-only
# singleton (its unit's ExecCondition) so a child failure surfaces to the
# maintainer exactly once.
#
# Pluggable for tests:
#   GARDEN_ORCH_CLONE   this service's journal clone (default $GARDEN_STATE/orch/journal).
#   GARDEN_ORCH_AFTER_SYNC_CMD  command invoked with the clone path after the
#                       initial sync (used to model a half-applied checkout, or a
#                       transient snapshot in which a completing child reads gone).
#   GARDEN_ORCH_GONE_RECHECK / GARDEN_ORCH_GONE_RECHECK_SLEEP  attempts and per-
#                       attempt sleep for the gone re-sync guard (sleep=0 in tests).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="orchestrate"

require_tools git

fleet_draining && exit 0

# A child that keeps being reaped and requeued can remain in todo/doin forever,
# which used to look indistinguishable from healthy work to this watcher.  Keep a
# small, persisted observation in the orchestration record and turn that churn
# into the same failed state used for a vanished child.  The values are tunable
# for unusually slow boards, but the shipped defaults deliberately fail early:
# the reaper already gives a job several retries before doom-park, and an
# orchestration must not wait through all of them.
: "${GARDEN_HANDLER_TIMEOUT:=2400}"
: "${GARDEN_ORCH_STALL_TIMEOUT_MULTIPLIER:=1}"
: "${GARDEN_ORCH_STALL_REQUEUE_LIMIT:=2}"
# A `gone` reading (child in none of tada/todo/doin/plan) is the ONLY irreversible,
# campaign-halting verdict this watcher draws from a single synced snapshot, and it
# is the exact reading a doin→tada transition can flash through if the tick-top sync
# observed the board a beat before the completion commit landed (incident: a
# genuinely-completing child whose tada was already committed was still halted as
# "vanished"). Before trusting a gone reading, re-sync the clone and re-read up to
# this many times: a genuine reaper doom-drop stays gone across a fresh sync; a
# just-completing child resolves to tada. Only paid on the rare gone reading.
: "${GARDEN_ORCH_GONE_RECHECK:=2}"
: "${GARDEN_ORCH_GONE_RECHECK_SLEEP:=2}"

DIR="${GARDEN_ORCH_CLONE:-$GARDEN_STATE/orch/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"
[ -z "${GARDEN_ORCH_AFTER_SYNC_CMD:-}" ] || "$GARDEN_ORCH_AFTER_SYNC_CMD" "$DIR"

# --- child state, read from one committed board snapshot --------------------
# A `git reset --hard` updates the checkout path-by-path. Reading tada/todo/doin/
# plan with four working-tree `test -e` calls can therefore observe no path while
# the reset is between deleting the old path and creating the new one. Resolve all
# four candidates from ONE immutable commit tree instead. An unreadable tree or a
# commit that contains the child in multiple board directories is not evidence of
# failure: return `retry` and let the next timer tick read again.
child_board_view_once() {  # <child> -> "<location> <snapshot>"; location includes gone|retry
  local c="$1" snapshot listing tada_path count path location
  if ! snapshot="$(git -C "$DIR" rev-parse --verify 'HEAD^{commit}' 2>/dev/null)"; then
    printf 'retry -\n'; return 0
  fi
  tada_path="$(tada_find_tree "$DIR" "$snapshot" "$c" || true)"
  if ! listing="$(git -C "$DIR" ls-tree --name-only "$snapshot" -- \
      "$JOBS_TODO/$c.md" "$JOBS_DOIN/$c.md" "$JOBS_PLAN/$c.md" 2>/dev/null)"; then
    printf 'retry %s\n' "$snapshot"; return 0
  fi
  [ -z "$tada_path" ] || listing="${tada_path}${listing:+$'\n'}${listing}"
  count="$(printf '%s\n' "$listing" | awk 'NF{n++} END{print n+0}')"
  if [ "$count" -eq 0 ]; then printf 'gone %s\n' "$snapshot"; return 0; fi
  if [ "$count" -ne 1 ]; then printf 'retry %s\n' "$snapshot"; return 0; fi
  path="$(printf '%s\n' "$listing" | awk 'NF{print; exit}')"
  case "$path" in
    "$tada_path") [ -n "$tada_path" ] && location=tada || location=retry ;;
    "$JOBS_TODO/$c.md") location=todo ;;
    "$JOBS_DOIN/$c.md") location=doin ;;
    "$JOBS_PLAN/$c.md") location=plan ;;
    *) location=retry ;;
  esac
  printf '%s %s\n' "$location" "$snapshot"
}

# child_board_view wraps the single-snapshot read with a bounded re-sync guard for
# the one reading that cannot be walked back: `gone`. df2226 made the read atomic
# w.r.t. a hard reset's path-by-path checkout, so a gone reading is no longer a
# working-tree artifact — but it is still only as FRESH as the tick's single top
# sync, which can observe the board one commit before a child's doin→tada
# completion lands and thereby read the completing child as absent. Because gone is
# the sole verdict that halts a whole serial campaign, confirm it against a FRESH
# sync before trusting it: re-sync and re-read; a genuine reaper doom-drop is still
# gone afterward, while a just-completed child now resolves to tada. Every other
# reading (tada/todo/doin/plan/retry) is already self-correcting on the next tick,
# so only gone pays the re-sync cost. child_state and child_failure_detail both call
# this, so they observe the SAME confirmed reading and never disagree.
child_board_view() {  # <child> -> "<location> <snapshot>"
  local c="$1" view attempt
  view="$(child_board_view_once "$c")"
  case "$view" in
    gone\ *)
      for attempt in $(seq 1 "$GARDEN_ORCH_GONE_RECHECK"); do
        [ "$GARDEN_ORCH_GONE_RECHECK_SLEEP" -gt 0 ] 2>/dev/null && sleep "$GARDEN_ORCH_GONE_RECHECK_SLEEP"
        sync_clone "$DIR" >/dev/null 2>&1 || true
        view="$(child_board_view_once "$c")"
        case "$view" in gone\ *) ;; *) break ;; esac
      done
      ;;
  esac
  printf '%s\n' "$view"
}

child_snapshot_file() {  # <snapshot> <location> <child> <destination>
  local snapshot="$1" location="$2" c="$3" destination="$4" path
  case "$location" in
    tada) path="$(tada_find_tree "$DIR" "$snapshot" "$c")" || return 1 ;;
    todo) path="$JOBS_TODO/$c.md" ;;
    doin) path="$JOBS_DOIN/$c.md" ;;
    plan) path="$JOBS_PLAN/$c.md" ;;
    *) return 1 ;;
  esac
  git -C "$DIR" show "$snapshot:$path" > "$destination" 2>/dev/null
}

set_orch_field() {  # <base> <field> <value>; CAS-retried, leading frontmatter only
  local base="$1" field="$2" value="$3" f rc attempt
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    f="$DIR/$JOBS_ORCH/$base.md"
    [ -f "$f" ] || return 0
    if grep -q "^${field}:" "$f"; then
      sed -i "s|^${field}:.*|${field}: ${value}|" "$f"
    else
      sed -i "1a ${field}: ${value}" "$f"
    fi
    git -C "$DIR" add "$JOBS_ORCH/$base.md"
    rc=0; commit_and_push "$DIR" "orch($base) observed $field=$value by $GARDEN" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0
    backoff "$attempt"
  done
  return 1
}

child_reap_count() { reap_count "$1"; }
child_claim_host() { sed -n 's/^  host:[[:space:]]*//p' "$1" | tail -1; }
child_claimed_at() { sed -n 's/^  claimed_at:[[:space:]]*//p' "$1" | tail -1; }
child_promoted_at() { sed -n 's/.*garden-promoted-from-plan:.* at=\([^ >]*\).*/\1/p' "$1" | tail -1; }
child_handler_timeout() {
  local n
  n="$(sed -n 's/^handler-timeout:[[:space:]]*//p' "$1" | head -1 | tr -dc '0-9')"
  printf '%s\n' "${n:-$GARDEN_HANDLER_TIMEOUT}"
}

set_orch_reap_baseline() {  # <orch-base> <child>; record the child's current reap count as the floor
  # Called immediately after promotion (child is in todo) AND when a progressing child
  # advances its baseline (child is in doin — the reaper has not yet requeued the
  # productive cycle), so read whichever of todo/doin holds it.
  local base="$1" c="$2" jf n
  if [ -f "$DIR/$JOBS_TODO/$c.md" ]; then jf="$DIR/$JOBS_TODO/$c.md"
  elif [ -f "$DIR/$JOBS_DOIN/$c.md" ]; then jf="$DIR/$JOBS_DOIN/$c.md"
  else return 0; fi
  n="$(child_reap_count "$jf")"
  set_orch_field "$base" "child-$c-reap-count" "$n"
}

# serial_sibling_in_flight <self-child> <all-children...> — print the FIRST sibling
# child (≠ self) that currently occupies jobs/todo or jobs/doin, and return 0; return
# 1 (nothing printed) if no sibling is in flight. The defense-in-depth gate a SERIAL
# run applies before promoting a parked child: a serial orchestration must have AT
# MOST ONE child in flight, so if any sibling is queued/claimed we must NOT promote.
serial_sibling_in_flight() {
  local self="$1"; shift
  local c
  for c in "$@"; do
    [ "$c" = "$self" ] && continue
    if [ -e "$DIR/$JOBS_TODO/$c.md" ] || [ -e "$DIR/$JOBS_DOIN/$c.md" ]; then
      printf '%s\n' "$c"; return 0
    fi
  done
  return 1
}

set_orch_claim_host() {  # <orch-base> <child>; preserve the first claiming host
  local base="$1" c="$2" f jf host known
  f="$DIR/$JOBS_ORCH/$base.md"; [ -f "$f" ] || return 0
  known="$(plan_field "$f" "child-$c-host")"; [ -n "$known" ] && return 0
  jf="$DIR/$JOBS_DOIN/$c.md"; [ -f "$jf" ] || return 0
  host="$(child_claim_host "$jf")"; [ -n "$host" ] || return 0
  set_orch_field "$base" "child-$c-host" "$host"
}

# child_failure_detail mirrors child_state's deterministic checks for reports and
# notices.  It is deliberately recomputed from the board rather than kept in
# process globals (the caller receives child_state through command substitution).
child_failure_detail() {  # <child> <orch-record>
  local c="$1" orch="$2" jf view location snapshot n limit started now started_epoch age host
  view="$(child_board_view "$c")"; read -r location snapshot <<<"$view"
  case "$location" in
    retry) printf 'board snapshot unreadable or inconsistent; retrying\n'; return 0 ;;
    gone) printf 'vanished from the board\n'; return 0 ;;
  esac
  jf="$(mktemp "${TMPDIR:-/tmp}/orch-child.XXXXXX")"
  if ! child_snapshot_file "$snapshot" "$location" "$c" "$jf"; then
    rm -f "$jf"; printf 'board snapshot unreadable or inconsistent; retrying\n'; return 0
  fi
  if [ "$location" = tada ]; then
    if tada_failed "$jf"; then printf 'completed but declared its gated outcome unsatisfied\n'
    else printf 'completed successfully\n'; fi
    rm -f "$jf"; return 0
  fi
  if [ "$location" = plan ]; then
    if grep -qxE 'doomed: true|poisoned: true' "$jf" 2>/dev/null; then
      printf 'doomed and held in plan\n'
    else
      printf 'parked in plan\n'
    fi
    rm -f "$jf"; return 0
  fi
  n="$(child_reap_count "$jf")"
  host="$(child_claim_host "$jf")"; [ -n "$host" ] || host="$(plan_field "$orch" "child-$c-host")"; [ -n "$host" ] || host=unknown
  limit="$GARDEN_ORCH_STALL_REQUEUE_LIMIT"
  # Mirror child_state EXACTLY (these two must never disagree): a child that advanced a
  # per-job worktree HEAD this cycle carries the productive-cycle hint and is
  # progressing, never stalled. Only a child with NO hint whose non-productive requeue
  # streak EXCEEDS the tunable limit is a requeue stall. The old "rose above baseline"
  # clause is gone — any rise was punishing the normal reap-and-resume path.
  if ! has_productive_cycle_hint "$jf" && [ "$n" -gt "$limit" ] 2>/dev/null; then
    printf 'stalled after %s requeues on host %s (limit %s, no progress hint this cycle)\n' "$n" "$host" "$limit"; rm -f "$jf"; return 0
  fi
  started="$(child_claimed_at "$jf")"; [ -n "$started" ] || started="$(child_promoted_at "$jf")"
  if [ -n "$started" ]; then
    now="$(date -u +%s)"; started_epoch="$(date -u -d "$started" +%s 2>/dev/null || true)"
    if [ -n "$started_epoch" ]; then
      age=$(( now - started_epoch )); limit=$(( $(child_handler_timeout "$jf") * GARDEN_ORCH_STALL_TIMEOUT_MULTIPLIER ))
      if [ "$age" -gt "$limit" ]; then
        printf 'stalled in flight for %ss on host %s (handler-timeout=%ss, multiplier=%s)\n' \
          "$age" "$host" "$(child_handler_timeout "$jf")" "$GARDEN_ORCH_STALL_TIMEOUT_MULTIPLIER"; rm -f "$jf"; return 0
      fi
    fi
  fi
  printf 'failed while still in flight\n'
  rm -f "$jf"
}

child_state() {  # <child-base> <orch-record> → done|active|progressing|parked|failed|retry
  local c="$1" orch="$2" jf view location snapshot n prev detail
  view="$(child_board_view "$c")"; read -r location snapshot <<<"$view"
  case "$location" in retry) printf 'retry\n'; return 0;; gone) printf 'failed\n'; return 0;; esac
  jf="$(mktemp "${TMPDIR:-/tmp}/orch-child.XXXXXX")"
  if ! child_snapshot_file "$snapshot" "$location" "$c" "$jf"; then
    rm -f "$jf"; printf 'retry\n'; return 0
  fi
  if [ "$location" = tada ]; then
    # A tada report can carry the "completed but declined its gated outcome"
    # marker (tada_failed, common.sh) — shared with the unblock watcher.
    if tada_failed "$jf"; then
      printf 'failed\n'
    else
      printf 'done\n'
    fi
    rm -f "$jf"; return 0
  fi
  if [ "$location" = todo ] || [ "$location" = doin ]; then
    n="$(child_reap_count "$jf")"
    prev="$(plan_field "$orch" "child-$c-reap-count")"
    # A requeue is NOT automatically a failure. The fleet already distinguishes a
    # requeued-but-PROGRESSING child from a requeued-and-FAILING one via the
    # productive-cycle hint (common.sh § productive-cycle hint): the gardener stamps it
    # when a per-job worktree HEAD advanced this cycle, and the reaper RESETS its doom
    # counter on it instead of incrementing. Consult the SAME predicate the reaper
    # honors so a long-running child that is reaped and re-claims — the NORMAL path for
    # a shepherd waiting on CI or a 35-seat panel — is not declared stalled on its
    # first requeue.  Promotion records the baseline in the orchestration record.
    if has_productive_cycle_hint "$jf"; then
      # Advanced a HEAD this cycle → making real progress. Never fail it on requeue
      # count. If the count rose above the recorded baseline, signal the caller to
      # ADVANCE the stored floor so the next tick compares against the new baseline.
      if [ -n "$prev" ] && [ "$n" -gt "$prev" ] 2>/dev/null; then
        printf 'progressing\n'; rm -f "$jf"; return 0
      fi
    else
      # No progress hint this cycle: consecutive non-productive requeues count toward
      # GARDEN_ORCH_STALL_REQUEUE_LIMIT and fail the child only once they EXCEED it —
      # which is what the tunable was for. The reaper resets the reap count on every
      # productive cycle, so n already measures the non-productive streak.
      if [ "$n" -gt "$GARDEN_ORCH_STALL_REQUEUE_LIMIT" ] 2>/dev/null; then
        printf 'failed\n'; rm -f "$jf"; return 0
      fi
    fi
    # Claim metadata is stamped by claim-job.sh.  A queued child uses the promotion
    # timestamp instead, so an unclaimable child cannot wait forever either.
    detail="$(child_failure_detail "$c" "$orch")"
    if [[ "$detail" == stalled\ in\ flight* ]]; then printf 'failed\n'; rm -f "$jf"; return 0; fi
    printf 'active\n'; rm -f "$jf"; return 0
  fi
  if [ "$location" = plan ]; then
    # A plan carrying `doomed: true` (or the legacy `poisoned: true`, dual-read
    # for the rollout window) is a doomed-and-PARKED child: the reaper
    # exhausted its requeue budget and parked the work under a held gate for a human
    # (reaper.sh doom branch / doom-notice.sh) instead of dropping it. For
    # orchestration this is a FAILURE, not a fresh parked child to promote —
    # otherwise the watcher would re-promote (promote-plan.sh strips the gate) and
    # re-run a job that fails every time, forever. The work still survives in plan/
    # (held) for a human to resume; the orchestration merely stops waiting on it and
    # applies its on-child-failure policy.
    if grep -qxE 'doomed: true|poisoned: true' "$jf" 2>/dev/null; then
      printf 'failed\n'; rm -f "$jf"; return 0
    fi
    printf 'parked\n'; rm -f "$jf"; return 0
  fi
  rm -f "$jf"; printf 'retry\n'
}

# --- record state update (CAS retry, like promote-plan.sh) ------------------
set_orch_state() {  # <base> <newstate>
  local base="$1" newstate="$2" f rc attempt
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    f="$DIR/$JOBS_ORCH/$base.md"
    [ -f "$f" ] || return 0   # record already completed/removed — nothing to do
    if grep -q '^state:' "$f"; then
      sed -i "s/^state:.*/state: $newstate/" "$f"
    else
      sed -i "1a state: $newstate" "$f"
    fi
    git -C "$DIR" add "$JOBS_ORCH/$base.md"
    # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
    # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
    rc=0; commit_and_push "$DIR" "orch($base) state→$newstate by $GARDEN" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # no change to commit → already at that state
    backoff "$attempt"
  done
  return 1
}

# --- terminal transitions ---------------------------------------------------
# Complete an orchestration: write tada/<base> from a summary file and remove the
# orch record. Parked children deliberately survive a halt as recoverable held
# work. Retries until it lands (touches only its own base).
finish_orch() {  # <base> <summary-file>
  local base="$1" summary="$2"
  local attempt rc
  for attempt in $(seq 1 100); do
    sync_clone "$DIR"
    if [ ! -e "$DIR/$JOBS_ORCH/$base.md" ] && tada_exists "$DIR" "$base"; then
      return 0   # already finished on a prior tick
    fi
    mkdir -p "$DIR/$JOBS_TADA"
    cp "$summary" "$DIR/$JOBS_TADA/$base.md"
    git -C "$DIR" add "$JOBS_TADA/$base.md"
    [ -e "$DIR/$JOBS_ORCH/$base.md" ] && git -C "$DIR" rm -q "$JOBS_ORCH/$base.md"
    # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
    # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
    rc=0; commit_and_push "$DIR" "orch($base) finished → tada by $GARDEN" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0
    backoff "$attempt"
  done
  return 1
}

# Surface a child failure / a completion to the maintainer inbox (best-effort;
# a notify failure must never wedge the tick). Body on stdin.
orch_notify() {  # <subject> ; body on stdin
  local subject="$1"
  GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="orchestrator:${subject}" "$HERE/inbox-send.sh" maintainer >/dev/null 2>&1 || \
    log "orchestration notify to maintainer failed (non-fatal): $subject"
}

# --- budgeted-campaign reporting and terminal transitions ------------------
campaign_spend() {  # <base> — one JSON object, from this tick's synced checkout
  "$HERE/campaign-spend.sh" --dir "$DIR" "$1"
}

campaign_parked_children() {  # <orch-record> <child>...
  local record="$1"; shift
  local child
  for child in "$@"; do
    [ "$(child_state "$child" "$record")" = parked ] && printf '%s\n' "$child"
  done
}

print_campaign_quantities() {  # <snapshot-json>
  local snapshot="$1"
  printf 'campaign-budget-tokens: %s\n' "$(jq -r '.budget_tokens' <<<"$snapshot")"
  printf 'campaign-spend-tokens: %s\n' "$(jq -r '.spend_tokens' <<<"$snapshot")"
  printf 'campaign-unspent-tokens: %s\n' "$(jq -r '.unspent_tokens' <<<"$snapshot")"
  printf 'campaign-overshoot-tokens: %s\n' "$(jq -r '.overshoot_tokens' <<<"$snapshot")"
  printf 'campaign-unmetered-engagements: %s\n' "$(jq -r '.unmetered' <<<"$snapshot")"
}

print_campaign_price_snapshot() {  # <snapshot-json>
  local snapshot="$1" notional real index calibrated unpriced unmetered
  notional="$(jq -r '.notional_usd' <<<"$snapshot")"
  real="$(jq -r '.real_equivalent_usd' <<<"$snapshot")"
  index="$(jq -r '.notional_to_real_index' <<<"$snapshot")"
  calibrated="$(jq -r '.calibration_as_of' <<<"$snapshot")"
  unpriced="$(jq -r '.unpriced' <<<"$snapshot")"
  unmetered="$(jq -r '.unmetered' <<<"$snapshot")"
  printf 'Recorded token spend excludes %s unmetered engagement(s).\n' "$unmetered"
  printf 'Notional spend at the terminal snapshot: $%.2f (%s unpriced engagement(s)).\n' "$notional" "$unpriced"
  printf 'Real-dollar-equivalent: $%.2f at the %.4fx fleet index as of %s.\n' "$real" "$index" "$calibrated"
}

finish_budget_meter_incomplete() {  # <base> <reason> <position> <total> <child>...
  local base="$1" reason="$2" position="$3" total="$4"; shift 4
  local kids=("$@") record="$DIR/$JOBS_ORCH/$base.md" budget sf
  local parked=()
  mapfile -t parked < <(campaign_parked_children "$record" "${kids[@]}")
  budget="$(orch_budget_tokens "$record")"
  sf="$(mktemp "${TMPDIR:-/tmp}/orch-budget-meter.XXXXXX")"
  {
    printf 'orchestration-status: budget-meter-incomplete\n'
    printf 'campaign-budget-tokens: %s\n' "${budget:-unknown}"
    printf 'campaign-spend-tokens: unknown\n'
    printf 'campaign-unspent-tokens: unknown\n'
    printf 'campaign-overshoot-tokens: unknown\n'
    printf 'campaign-unmetered-engagements: unknown\n'
    printf 'campaign-parked-children: %s\n' "${parked[*]}"
    printf '# orchestration %s — BUDGET METER INCOMPLETE\n\n' "$base"
    if [ "$position" -gt 0 ]; then
      printf 'Stopped before promoting child %d/%d.\n' "$position" "$total"
    else
      printf 'Stopped while rendering the terminal campaign snapshot.\n'
    fi
    printf '%d not-yet-run child(ren) remain parked: %s\n\n' "${#parked[@]}" "${parked[*]:-none}"
    printf 'Meter failure: %s\n' "$reason"
  } > "$sf"
  if finish_orch "$base" "$sf"; then
    printf 'Orchestration %s stopped with budget-meter-incomplete. Budget: %s. Parked remainder: %s. Reason: %s\n' \
      "$base" "${budget:-unknown}" "${parked[*]:-none}" "$reason" | orch_notify "$base-budget-meter-incomplete"
    log "orchestration '$base': BUDGET METER INCOMPLETE; ${#parked[@]} child(ren) remain parked"
  else
    log "orchestration '$base': budget-meter-incomplete finish failed; retrying next tick"
  fi
  rm -f "$sf"
}

finish_budget_exhausted() {  # <base> <snapshot> <position> <done-count> <child>...
  local base="$1" snapshot="$2" position="$3" done_count="$4"; shift 4
  local kids=("$@")
  local total="${#kids[@]}" record="$DIR/$JOBS_ORCH/$base.md" sf
  local parked=()
  mapfile -t parked < <(campaign_parked_children "$record" "${kids[@]}")
  sf="$(mktemp "${TMPDIR:-/tmp}/orch-budget-exhausted.XXXXXX")"
  {
    printf 'orchestration-status: budget-exhausted\n'
    print_campaign_quantities "$snapshot"
    printf 'campaign-parked-children: %s\n' "${parked[*]}"
    printf '# orchestration %s — BUDGET EXHAUSTED\n\n' "$base"
    printf 'Stopped before promoting child %d/%d. %d children were already complete.\n' \
      "$position" "$total" "$done_count"
    printf '%d not-yet-run child(ren) remain parked: %s\n' "${#parked[@]}" "${parked[*]:-none}"
    print_campaign_price_snapshot "$snapshot"
  } > "$sf"
  if finish_orch "$base" "$sf"; then
    printf 'Orchestration %s exhausted its %s-token campaign budget after %s recorded tokens (%s overshoot). Unspent: %s. Parked remainder: %s\n' \
      "$base" "$(jq -r '.budget_tokens' <<<"$snapshot")" "$(jq -r '.spend_tokens' <<<"$snapshot")" \
      "$(jq -r '.overshoot_tokens' <<<"$snapshot")" "$(jq -r '.unspent_tokens' <<<"$snapshot")" \
      "${parked[*]:-none}" | orch_notify "$base-budget-exhausted"
    log "orchestration '$base': BUDGET EXHAUSTED; ${#parked[@]} child(ren) remain parked"
  else
    log "orchestration '$base': budget-exhausted finish failed; retrying next tick"
  fi
  rm -f "$sf"
}

# --- serial and parallel advancement ----------------------------------------
advance_serial() {  # <base> <policy> <child>...
  local base="$1" policy="$2"; shift 2
  local kids=("$@") total; total=$(( ${#kids[@]} ))
  local i c st done_count=0
  local failed=()
  for i in "${!kids[@]}"; do
    c="${kids[$i]}"
    st="$(child_state "$c" "$DIR/$JOBS_ORCH/$base.md")"
    case "$st" in
      done)
        done_count=$((done_count+1)); continue;;
      active|progressing)
        set_orch_claim_host "$base" "$c" || true
        if [ "$st" = progressing ]; then
          # Requeued but the gardener advanced a per-job worktree HEAD this cycle —
          # real progress, not a stall. Advance the stored reap baseline so the next
          # tick compares against the new floor, and keep waiting on it.
          set_orch_reap_baseline "$base" "$c" || true
          log "orchestration '$base': child $((i+1))/$total '$c' requeued but PROGRESSING (advanced a worktree HEAD); baseline advanced, still in flight"
        else
          log "orchestration '$base': waiting on child $((i+1))/$total '$c' (in flight)"
        fi
        return 0;;
      retry)
        log "orchestration '$base': child $((i+1))/$total '$c' board snapshot unreadable/inconsistent; retrying next tick"
        return 0;;
      parked)
        # DEFENSE-IN-DEPTH serial gate: a serial run must have AT MOST ONE child in
        # flight. The ordered loop above already returns at the first active child, but
        # if an earlier sibling were momentarily MISCLASSIFIED as terminal (a live child
        # misread as failed, then policy=continue) a `continue` could reach this parked
        # child and promote it — two children editing overlapping sources and pushing to
        # ONE shared PR branch (the 2026-08-08 ironhorse-262 five-children collision).
        # Independently assert no OTHER child of this orchestration occupies todo/doin
        # before promoting; if one does, WAIT rather than promote.
        local sib
        if sib="$(serial_sibling_in_flight "$c" "${kids[@]}")"; then
          log "orchestration '$base': NOT promoting child $((i+1))/$total '$c' — serial sibling '$sib' still in flight (todo/doin)"
          return 0
        fi
        local budget snapshot reason_file spend
        budget="$(orch_budget_tokens "$DIR/$JOBS_ORCH/$base.md")"
        if orch_has_budget "$DIR/$JOBS_ORCH/$base.md"; then
          reason_file="$(mktemp "${TMPDIR:-/tmp}/orch-budget-reason.XXXXXX")"
          if ! snapshot="$(campaign_spend "$base" 2>"$reason_file")"; then
            finish_budget_meter_incomplete "$base" "$(tail -1 "$reason_file")" "$((i+1))" "$total" "${kids[@]}"
            rm -f "$reason_file"
            return 0
          fi
          rm -f "$reason_file"
          spend="$(jq -r '.spend_tokens' <<<"$snapshot")"
          log "orchestration '$base': campaign spend $spend/$budget before child $((i+1))/$total '$c'; $(jq -r '.unmetered' <<<"$snapshot") unmetered engagement(s) excluded"
          if [ "$spend" -ge "$budget" ]; then
            finish_budget_exhausted "$base" "$snapshot" "$((i+1))" "$done_count" "${kids[@]}"
            return 0
          fi
        fi
        # The ordered read above chooses WHICH child is next, but it cannot by
        # itself authorize the move: DIR and promote-plan.sh use separate clones,
        # so the board can change between this read and the promotion CAS. Carry
        # every predecessor into the primitive. It re-syncs and validates them in
        # the SAME critical section as the plan-to-todo move, and repeats the validation after
        # every rejected-push retry. This is the serial ordering invariant's final
        # enforcement point, not merely a watcher-side observation.
        local promotion_args=() k promote_rc=0
        for ((k=0; k<i; k++)); do
          promotion_args+=(--require-tada "${kids[$k]}")
        done
        "$HERE/promote-plan.sh" "${promotion_args[@]}" "$c" >/dev/null 2>&1 || promote_rc=$?
        if [ "$promote_rc" -eq 0 ]; then
          log "orchestration '$base': promoted child $((i+1))/$total '$c' (serial)"
          set_orch_state "$base" running || true
          set_orch_reap_baseline "$base" "$c" || true
        elif [ "$promote_rc" -eq 3 ]; then
          log "orchestration '$base': NOT promoting child $((i+1))/$total '$c': fresh promotion snapshot did not confirm every predecessor in tada/"
        else
          log "orchestration '$base': could not promote child '$c'; retrying next tick"
        fi
        return 0;;
      failed)
        failed+=("$c")
        local detail; detail="$(child_failure_detail "$c" "$DIR/$JOBS_ORCH/$base.md")"
        if [ "$policy" = "halt" ]; then
          # HALT the serial run at the first failure. Downstream children remain
          # parked under their orchestrated gate for a human to inspect or resume.
          local parked_remainder=() k
          for ((k=i+1; k<total; k++)); do
            [ "$(child_state "${kids[$k]}" "$DIR/$JOBS_ORCH/$base.md")" = "parked" ] && parked_remainder+=("${kids[$k]}")
          done
          local sf; sf="$(mktemp "${TMPDIR:-/tmp}/orch-halt.XXXXXX")"
          {
            printf 'orchestration-status: halted\n'
            printf '# orchestration %s — HALTED\n\n' "$base"
            printf 'Serial run halted at child %d/%d **%s**: %s.\n' \
              "$((i+1))" "$total" "$c" "$detail"
            printf '%d/%d children completed before the failure.\n\n' "$done_count" "$total"
            if [ "${#parked_remainder[@]}" -gt 0 ]; then
              printf 'Left %d not-yet-run downstream child(ren) parked under their held orchestrated gate: %s\n' "${#parked_remainder[@]}" "${parked_remainder[*]}"
            fi
            printf '\non-child-failure policy: halt.\n'
          } > "$sf"
          finish_orch "$base" "$sf" || log "orchestration '$base': halt-finish failed; retrying next tick"
          printf 'Orchestration %s HALTED: child %s %s (serial, on-child-failure=halt). %d/%d done before halt; parked remainder: %s\n' \
            "$base" "$c" "$detail" "$done_count" "$total" "${parked_remainder[*]:-none}" | orch_notify "$base-halted"
          log "orchestration '$base': HALTED at failed child '$c' (policy=halt); left ${#parked_remainder[@]} downstream parked"
          rm -f "$sf"
          return 0
        fi
        # continue: record the failure and proceed to the next child.
        log "orchestration '$base': child $((i+1))/$total '$c' failed; continuing (policy=continue)"
        done_count=$((done_count+1))
        continue;;
    esac
  done
  # Fell through: every child is terminal (done, or continued-past-failure).
  complete_done "$base" "$total" "serial" "${failed[@]}"
}

advance_parallel() {  # <base> <policy> <child>...
  local base="$1" policy="$2"; shift 2
  local kids=("$@") total; total=$(( ${#kids[@]} ))
  local f="$DIR/$JOBS_ORCH/$base.md" state
  state="$(orch_state "$f")"
  if [ "$state" = "pending" ]; then
    local promoted=0 c prestate
    # Validate every child against a readable immutable snapshot before changing
    # any board state. A transient read failure postpones the whole fan-out.
    for c in "${kids[@]}"; do
      prestate="$(child_state "$c" "$DIR/$JOBS_ORCH/$base.md")"
      [ "$prestate" = retry ] && { log "orchestration '$base': unreadable/inconsistent child snapshot; retrying parallel promotion next tick"; return 0; }
    done
    for c in "${kids[@]}"; do
      if [ "$(child_state "$c" "$DIR/$JOBS_ORCH/$base.md")" = "parked" ] \
        && "$HERE/promote-plan.sh" "$c" >/dev/null 2>&1; then
        set_orch_reap_baseline "$base" "$c" || true
        promoted=$((promoted+1))
      fi
    done
    log "orchestration '$base': promoted $promoted/$total children at once (parallel)"
    set_orch_state "$base" running || true
    return 0
  fi
  # running: re-promote any still-parked child (idempotent safety net), then tally.
  local done_count=0 active=0 parked=0 c st
  local failed=()
  for c in "${kids[@]}"; do
    st="$(child_state "$c" "$DIR/$JOBS_ORCH/$base.md")"
    case "$st" in
      done)   done_count=$((done_count+1));;
      failed) failed+=("$c");;
      active|progressing)
        active=$((active+1)); set_orch_claim_host "$base" "$c" || true
        [ "$st" = progressing ] && { set_orch_reap_baseline "$base" "$c" || true; };;
      parked) parked=$((parked+1)); "$HERE/promote-plan.sh" "$c" >/dev/null 2>&1 || true;;
      retry) log "orchestration '$base': child '$c' board snapshot unreadable/inconsistent; retrying next tick"; return 0;;
    esac
  done
  local terminal=$(( done_count + ${#failed[@]} ))
  if [ "$terminal" -eq "$total" ]; then
    complete_done "$base" "$total" "parallel" "${failed[@]}"
  else
    log "orchestration '$base': $done_count/$total done, ${#failed[@]} failed, $active in flight, $parked parked (parallel)"
  fi
}

# Complete an all-children-terminal orchestration (done). Any failures (only
# reachable on policy=continue for serial, or normally for parallel) are surfaced.
complete_done() {  # <base> <total> <order> [<failed-child>...]
  local base="$1" total="$2" order="$3"; shift 3
  local failed=("$@") sf budget snapshot reason_file c f disposition
  local completion_kids=()
  read -ra completion_kids <<<"$(orch_children "$DIR/$JOBS_ORCH/$base.md")"
  budget="$(orch_budget_tokens "$DIR/$JOBS_ORCH/$base.md")"
  if orch_has_budget "$DIR/$JOBS_ORCH/$base.md"; then
    reason_file="$(mktemp "${TMPDIR:-/tmp}/orch-budget-reason.XXXXXX")"
    if ! snapshot="$(campaign_spend "$base" 2>"$reason_file")"; then
      read -ra completion_kids <<<"$(orch_children "$DIR/$JOBS_ORCH/$base.md")"
      finish_budget_meter_incomplete "$base" "$(tail -1 "$reason_file")" 0 "$total" "${completion_kids[@]}"
      rm -f "$reason_file"
      return 0
    fi
    rm -f "$reason_file"
  fi
  sf="$(mktemp "${TMPDIR:-/tmp}/orch-done.XXXXXX")"
  {
    if [ "${#failed[@]}" -gt 0 ]; then printf 'orchestration-status: complete-with-failures\n'
    else printf 'orchestration-status: complete\n'; fi
    printf '# orchestration %s — complete\n\n' "$base"
    printf 'All %d children reached a terminal state (%s).\n' "$total" "$order"
    if [ "${#failed[@]}" -gt 0 ]; then
      printf '%d child(ren) FAILED: %s\n' "${#failed[@]}" "${failed[*]}"
    fi
    printf '\nChild dispositions:\n'
    for c in "${completion_kids[@]}"; do
      disposition='tada report present; no machine-readable failure declaration detected'
      for f in "${failed[@]}"; do
        [ "$c" = "$f" ] && disposition='failure detected'
      done
      printf -- '- %s: %s\n' "$c" "$disposition"
    done
    if orch_has_budget "$DIR/$JOBS_ORCH/$base.md"; then
      printf '\n'
      print_campaign_quantities "$snapshot"
      printf 'campaign-parked-children: \n'
      printf '\nCampaign budget finished with %s token(s) unused.\n' "$(jq -r '.unspent_tokens' <<<"$snapshot")"
      print_campaign_price_snapshot "$snapshot"
    fi
  } > "$sf"
  if ! finish_orch "$base" "$sf"; then
    log "orchestration '$base': done-finish failed; retrying next tick"
    rm -f "$sf"
    return 0
  fi
  if [ "${#failed[@]}" -gt 0 ]; then
    printf 'Orchestration %s complete WITH FAILURES (%s): %d/%d failed: %s\n' \
      "$base" "$order" "${#failed[@]}" "$total" "${failed[*]}" | orch_notify "$base-complete-failures"
    log "orchestration '$base': complete with ${#failed[@]} failure(s)"
  else
    log "orchestration '$base': complete — all $total children done"
  fi
  if [ -n "$budget" ]; then
    printf 'Orchestration %s completed within its %s-token campaign budget after %s recorded tokens. %s token(s) remain unused.\n' \
      "$base" "$budget" "$(jq -r '.spend_tokens' <<<"$snapshot")" \
      "$(jq -r '.unspent_tokens' <<<"$snapshot")" | orch_notify "$base-budget-complete"
  fi
  rm -f "$sf"
}

# --- the tick ---------------------------------------------------------------
advanced=0
for j in $(list_jobs "$DIR" "$JOBS_ORCH"); do
  case "$j" in *.md) ;; *) continue;; esac
  f="$DIR/$JOBS_ORCH/$j"; [ -f "$f" ] || continue
  base="${j%.md}"
  order="$(orch_order "$f")"
  policy="$(orch_failure_policy "$f")"
  read -ra kids <<<"$(orch_children "$f")"
  if [ "${#kids[@]}" -lt 1 ]; then
    log "orchestration '$base' names no children; leaving parked (malformed record)"
    continue
  fi
  if [ "$order" = parallel ] && orch_has_budget "$f"; then
    finish_budget_meter_incomplete "$base" "budget_tokens is invalid with parallel order" 1 "${#kids[@]}" "${kids[@]}"
    advanced=$((advanced+1))
    continue
  fi
  case "$order" in
    parallel) advance_parallel "$base" "$policy" "${kids[@]}";;
    *)        advance_serial   "$base" "$policy" "${kids[@]}";;
  esac
  advanced=$((advanced+1))
done

[ "$advanced" -gt 0 ] && log "advanced $advanced orchestration(s)"
exit 0
