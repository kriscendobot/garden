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
#             one at a time, in order. A tick either promotes the next child, waits
#             on the in-flight one, halts on a failure (policy=halt), or completes.
#   parallel: promote ALL children at once (first tick), then watch them all; the
#             orchestration completes when every child is terminal.
#
# CHILD STATE is read purely from the board (child_state below):
#   done   — jobs/tada/<child> exists (and carries no failure marker).
#   active — jobs/todo or jobs/doin holds it (claimed / queued, in flight).
#   parked — jobs/plan holds it (gate=orchestrated, not yet promoted) and it is
#            NOT poisoned.
#   failed — either it VANISHED without reaching tada (promoted, then removed), or
#            its tada report marks `orchestration-failed: true`, or it is parked in
#            jobs/plan carrying `poisoned: true` (the reaper exhausted its requeue
#            budget and parked the work under a held gate rather than dropping it —
#            reaper.sh poison branch). A failed child triggers the on-child-failure
#            policy rather than a silent stall (or, for a poisoned child, rather
#            than an endless re-promote loop).
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

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="orchestrate"

require_tools git

fleet_draining && exit 0

DIR="${GARDEN_ORCH_CLONE:-$GARDEN_STATE/orch/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# --- child state, read purely from the board --------------------------------
child_state() {  # <child-base> → done|active|parked|failed
  local c="$1"
  if [ -e "$DIR/$JOBS_TADA/$c.md" ]; then
    if grep -qiE '^orchestration-(status:[[:space:]]*fail|failed:[[:space:]]*(true|yes))' \
         "$DIR/$JOBS_TADA/$c.md" 2>/dev/null; then
      printf 'failed\n'
    else
      printf 'done\n'
    fi
    return 0
  fi
  if [ -e "$DIR/$JOBS_TODO/$c.md" ] || [ -e "$DIR/$JOBS_DOIN/$c.md" ]; then
    printf 'active\n'; return 0
  fi
  if [ -e "$DIR/$JOBS_PLAN/$c.md" ]; then
    # A plan carrying `poisoned: true` is a poisoned-and-PARKED child: the reaper
    # exhausted its requeue budget and parked the work under a held gate for a human
    # (reaper.sh poison branch / poison-notice.sh) instead of dropping it. For
    # orchestration this is a FAILURE, not a fresh parked child to promote —
    # otherwise the watcher would re-promote (promote-plan.sh strips the gate) and
    # re-run a job that fails every time, forever. The work still survives in plan/
    # (held) for a human to resume; the orchestration merely stops waiting on it and
    # applies its on-child-failure policy.
    if grep -qx 'poisoned: true' "$DIR/$JOBS_PLAN/$c.md" 2>/dev/null; then
      printf 'failed\n'; return 0
    fi
    printf 'parked\n'; return 0
  fi
  # In none of tada/todo/doin/plan: it was promoted and vanished without a tada
  # (an older-style poison drop, or a manual removal).
  printf 'failed\n'
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
    if commit_and_push "$DIR" "orch($base) state→$newstate by $GARDEN"; then return 0; fi
    rc=$?; [ "$rc" -eq 2 ] && return 0   # no change to commit → already at that state
    backoff "$attempt"
  done
  return 1
}

# --- terminal transitions ---------------------------------------------------
# Complete an orchestration: write tada/<base> from a summary file, remove the
# orch record, and (halt only) sweep any still-parked children so a halt does not
# leave orphaned plan jobs. Retries until it lands (touches only its own base).
finish_orch() {  # <base> <summary-file> [<child-to-sweep>...]
  local base="$1" summary="$2"; shift 2
  local sweep=("$@") attempt rc c
  for attempt in $(seq 1 100); do
    sync_clone "$DIR"
    if [ ! -e "$DIR/$JOBS_ORCH/$base.md" ] && [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
      return 0   # already finished on a prior tick
    fi
    mkdir -p "$DIR/$JOBS_TADA"
    cp "$summary" "$DIR/$JOBS_TADA/$base.md"
    git -C "$DIR" add "$JOBS_TADA/$base.md"
    [ -e "$DIR/$JOBS_ORCH/$base.md" ] && git -C "$DIR" rm -q "$JOBS_ORCH/$base.md"
    for c in "${sweep[@]}"; do
      [ -e "$DIR/$JOBS_PLAN/$c.md" ] && git -C "$DIR" rm -q "$JOBS_PLAN/$c.md"
    done
    if commit_and_push "$DIR" "orch($base) finished → tada by $GARDEN"; then return 0; fi
    rc=$?; [ "$rc" -eq 2 ] && return 0
    backoff "$attempt"
  done
  return 1
}

# Surface a child failure / a completion to the maintainer inbox (best-effort;
# a notify failure must never wedge the tick). Body on stdin.
orch_notify() {  # <subject> ; body on stdin
  local subject="$1"
  GARDEN_SENDER="orchestrator:${subject}" "$HERE/inbox-send.sh" maintainer >/dev/null 2>&1 || \
    log "orchestration notify to maintainer failed (non-fatal): $subject"
}

# --- serial and parallel advancement ----------------------------------------
advance_serial() {  # <base> <policy> <child>...
  local base="$1" policy="$2"; shift 2
  local kids=("$@") total; total=$(( ${#kids[@]} ))
  local i c st done_count=0
  local failed=()
  for i in "${!kids[@]}"; do
    c="${kids[$i]}"
    st="$(child_state "$c")"
    case "$st" in
      done)
        done_count=$((done_count+1)); continue;;
      active)
        log "orchestration '$base': waiting on child $((i+1))/$total '$c' (in flight)"
        return 0;;
      parked)
        if "$HERE/promote-plan.sh" "$c" >/dev/null 2>&1; then
          log "orchestration '$base': promoted child $((i+1))/$total '$c' (serial)"
          set_orch_state "$base" running || true
        else
          log "orchestration '$base': could not promote child '$c'; retrying next tick"
        fi
        return 0;;
      failed)
        failed+=("$c")
        if [ "$policy" = "halt" ]; then
          # HALT the serial run at the first failure. Sweep the downstream children
          # that are still parked so they never run.
          local sweep=() k
          for ((k=i+1; k<total; k++)); do
            [ "$(child_state "${kids[$k]}")" = "parked" ] && sweep+=("${kids[$k]}")
          done
          local sf; sf="$(mktemp "${TMPDIR:-/tmp}/orch-halt.XXXXXX")"
          {
            printf 'orchestration-status: halted\n'
            printf '# orchestration %s — HALTED\n\n' "$base"
            printf 'Serial run halted at child %d/%d **%s** (failed / vanished from the board).\n' \
              "$((i+1))" "$total" "$c"
            printf '%d/%d children completed before the failure.\n\n' "$done_count" "$total"
            if [ "${#sweep[@]}" -gt 0 ]; then
              printf 'Swept %d not-yet-run downstream child(ren): %s\n' "${#sweep[@]}" "${sweep[*]}"
            fi
            printf '\non-child-failure policy: halt.\n'
          } > "$sf"
          finish_orch "$base" "$sf" "${sweep[@]}" || log "orchestration '$base': halt-finish failed; retrying next tick"
          printf 'Orchestration %s HALTED: child %s failed (serial, on-child-failure=halt). %d/%d done before halt; swept: %s\n' \
            "$base" "$c" "$done_count" "$total" "${sweep[*]:-none}" | orch_notify "$base-halted"
          log "orchestration '$base': HALTED at failed child '$c' (policy=halt); swept ${#sweep[@]} downstream"
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
    local promoted=0 c
    for c in "${kids[@]}"; do
      [ "$(child_state "$c")" = "parked" ] && "$HERE/promote-plan.sh" "$c" >/dev/null 2>&1 && promoted=$((promoted+1))
    done
    log "orchestration '$base': promoted $promoted/$total children at once (parallel)"
    set_orch_state "$base" running || true
    return 0
  fi
  # running: re-promote any still-parked child (idempotent safety net), then tally.
  local done_count=0 active=0 parked=0 c st
  local failed=()
  for c in "${kids[@]}"; do
    st="$(child_state "$c")"
    case "$st" in
      done)   done_count=$((done_count+1));;
      failed) failed+=("$c");;
      active) active=$((active+1));;
      parked) parked=$((parked+1)); "$HERE/promote-plan.sh" "$c" >/dev/null 2>&1 || true;;
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
  local failed=("$@") sf
  sf="$(mktemp "${TMPDIR:-/tmp}/orch-done.XXXXXX")"
  {
    if [ "${#failed[@]}" -gt 0 ]; then printf 'orchestration-status: complete-with-failures\n'
    else printf 'orchestration-status: complete\n'; fi
    printf '# orchestration %s — complete\n\n' "$base"
    printf 'All %d children reached a terminal state (%s).\n' "$total" "$order"
    if [ "${#failed[@]}" -gt 0 ]; then
      printf '%d child(ren) FAILED: %s\n' "${#failed[@]}" "${failed[*]}"
    else
      printf 'All children succeeded.\n'
    fi
  } > "$sf"
  finish_orch "$base" "$sf" || log "orchestration '$base': done-finish failed; retrying next tick"
  if [ "${#failed[@]}" -gt 0 ]; then
    printf 'Orchestration %s complete WITH FAILURES (%s): %d/%d failed: %s\n' \
      "$base" "$order" "${#failed[@]}" "$total" "${failed[*]}" | orch_notify "$base-complete-failures"
    log "orchestration '$base': complete with ${#failed[@]} failure(s)"
  else
    log "orchestration '$base': complete — all $total children done"
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
  case "$order" in
    parallel) advance_parallel "$base" "$policy" "${kids[@]}";;
    *)        advance_serial   "$base" "$policy" "${kids[@]}";;
  esac
  advanced=$((advanced+1))
done

[ "$advanced" -gt 0 ] && log "advanced $advanced orchestration(s)"
exit 0
