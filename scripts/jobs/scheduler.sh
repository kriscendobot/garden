#!/bin/bash
# scheduler.sh — dispatch regularly scheduled jobs (the sole scheduler service).
#
# Usage: scheduler.sh
#
# Each tick: sync the journal, and for every schedules/<name> whose cadence has
# elapsed since its last_dispatched, post a fresh copy of its task to the board
# AND stamp last_dispatched — in ONE CAS commit, so the dispatch and the stamp
# are atomic and two hosts cannot double-dispatch the same period. The common
# case is duplicating a task weekly.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="scheduler"

# GARDEN_SCHEDULER_NOW overrides the clock (epoch seconds) for deterministic
# cadence tests — mirrors GARDEN_FOREMAN_NOW / GARDEN_USAGE_NOW. When set, the
# cadence comparison, the last_dispatched stamp, and the dispatched job's
# timestamped basename all derive from it, so two back-to-back ticks driven with
# the same value are guaranteed not to cross a sub-tick cadence on a loaded host.
scheduler_now() { printf '%s\n' "${GARDEN_SCHEDULER_NOW:-$(date -u +%s)}"; }

cadence_seconds() {
  case "$1" in
    weekly) echo 604800;; daily) echo 86400;; hourly) echo 3600;;
    *s) echo "${1%s}";; *m) echo $(( ${1%m} * 60 ));; *h) echo $(( ${1%h} * 3600 ));; *d) echo $(( ${1%d} * 86400 ));;
    *) echo 604800;;  # default weekly
  esac
}

# Rewrite a recurring schedule's frontmatter with a fresh last_dispatched stamp,
# PRESERVING the optional preflight field and the consecutive not-found streak.
# Both the dispatch path and the gated (no-work) path go through this so the
# preflight: line is never dropped when the scheduler re-stamps the file.
# $1=dest, $2=cadence, $3=stamp, $4=prefix, $5=preflight (may be empty), $6=body,
# $7=preflight_missing_streak (default 0; the line is omitted at 0 so a healthy
# schedule keeps a clean file, and a reset back to 0 clears a stale streak).
write_schedule() {
  local dest="$1" cad="$2" stamp="$3" prefix="$4" preflight="$5" body="$6" missing_streak="${7:-0}"
  {
    printf 'cadence: %s\nlast_dispatched: %s\njob_basename_prefix: %s\n' "$cad" "$stamp" "$prefix"
    [ -n "$preflight" ] && printf 'preflight: %s\n' "$preflight"
    [ "${missing_streak:-0}" -gt 0 ] && printf 'preflight_missing_streak: %s\n' "$missing_streak"
    printf -- '---\n'
    printf '%s\n' "$body"
  } > "$dest"
}

# Consecutive not-found/not-executable preflight ticks tolerated before we
# escalate ONCE to the maintainer inbox. Fail-open never changes (a missing gate
# must never starve a schedule); this threshold only closes the loop on a gate
# that is GENUINELY absent every cadence — a deploy-lag or a typo'd preflight:
# path — instead of silently re-firing an expensive dispatch forever.
PREFLIGHT_MISSING_ESCALATE_THRESHOLD="${GARDEN_PREFLIGHT_MISSING_THRESHOLD:-3}"

# Escalate a persistently-absent preflight gate to the maintainer inbox. Guarded
# by the caller so a delivery failure never aborts the scheduler. $1=schedule
# name, $2=configured preflight path, $3=consecutive not-found streak.
escalate_missing_preflight() {
  local sname="$1" pfpath="$2" streak="$3"
  {
    printf 'Scheduler preflight gate for schedule "%s" has been NOT FOUND / not executable for %s consecutive ticks.\n\n' "$sname" "$streak"
    printf 'Configured preflight: %s\n' "$pfpath"
    printf 'Resolved relative to %s/ unless absolute.\n\n' "$HERE"
    printf 'The gate is failing open, so every cadence re-dispatches this schedule with the preflight fully bypassed — most likely a deploy-lag or a typo in the "preflight:" path. Please land the missing gate or fix the path so the schedule stops burning dispatches. This is a one-time escalation per breakage (it re-arms only after the gate is found again).\n'
  } | "$HERE/message-user.sh" "scheduler-preflight-$sname"
}

# Per-host, one-shot dedup+diagnosis state for a NOT-FOUND preflight gate. The
# gate ALWAYS fails open (never starve real work), but the WARN it logs must not
# repeat on every cadence for the whole deploy-lag window. We stamp a per-schedule
# marker under $GARDEN_STATE (per-host, outside any reset-prone worktree, never
# committed) recording the resolved path we already warned about; while the marker
# still names that path the tick stays silent. The marker is cleared the instant
# the gate is found again (clear_missing_preflight, below), so the WARN and the
# deploy-lag diagnosis re-arm per breakage — exactly like the frontmatter streak,
# but for the noisy per-tick log line the streak never suppressed.
GARDEN_PREFLIGHT_MISSING_STATE="${GARDEN_PREFLIGHT_MISSING_STATE:-$GARDEN_STATE/scheduler/preflight-missing}"
preflight_missing_marker() { printf '%s\n' "$GARDEN_PREFLIGHT_MISSING_STATE/${1//[^A-Za-z0-9._-]/_}"; }
preflight_deploy_lag_note() { printf '%s\n' "$GARDEN_DEPLOY_STATE/preflight-deploy-lag-${1//[^A-Za-z0-9._-]/_}"; }

# Clear a schedule's not-found marker AND any deploy-lag note it left in the
# deploy surface, so the WARN + deploy-lag diagnosis re-arm the next time the
# gate goes missing. Called on the tick the gate is found (present/executable) —
# e.g. after this host is deployed and the previously-behind script arrives.
clear_missing_preflight() {  # $1=schedule name
  rm -f "$(preflight_missing_marker "$1")" "$(preflight_deploy_lag_note "$1")" 2>/dev/null || true
}

# Log the not-found WARN AT MOST ONCE per (schedule, resolved-path) breakage, and
# on the first tick of that breakage emit a DISTINCT one-shot deploy-lag signal
# when the named script is present on the dev branch but missing from this
# deployed root. A gate that is named-but-missing while the SAME script exists on
# origin/$GARDEN_MAIN_BRANCH is not a typo — it is deploy-lag (this root is behind
# the branch that already carries the gate), so the schedule fails open and
# re-dispatches every cadence until the host is deployed. That is actionable, so
# we surface it once into the deploy state dir (co-located with the upgrade-ready
# marker the liaison's deploy Monitor watches) and once onto the message bus,
# pointing at the pending deploy as the cause — instead of burying it as recurring
# WARN noise. $1=schedule, $2=configured preflight (as written), $3=resolved path.
note_missing_preflight() {
  local sname="$1" pfcfg="$2" pfpath="$3"
  local marker; marker="$(preflight_missing_marker "$sname")"
  # Already warned+diagnosed for this exact resolved path? Stay silent this tick.
  [ -f "$marker" ] && [ "$(cat "$marker" 2>/dev/null || true)" = "$pfpath" ] && return 0

  log "WARN schedule $sname preflight '$pfcfg' not found/executable at $pfpath; treating as work-present (fail-open; deploy-lag or typo'd preflight: path)"

  # Deploy-lag test: is the script present on the dev branch but not here? Only
  # decidable for a preflight resolved INSIDE the deployed root (a relative path);
  # an absolute path outside the repo has no branch-relative form, so skip it.
  local rel="" onbranch=0
  case "$pfpath" in
    "$GARDEN_ROOT"/*) rel="${pfpath#"$GARDEN_ROOT"/}";;
  esac
  if [ -n "$rel" ]; then
    # Best-effort, bounded refresh so the check does not read a stale ref; a
    # one-shot fetch per breakage, and an offline tick never aborts the scheduler.
    timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT" \
      git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" >/dev/null 2>&1 || true
    git -C "$GARDEN_ROOT" cat-file -e "origin/$GARDEN_MAIN_BRANCH:$rel" 2>/dev/null && onbranch=1
  fi

  if [ "$onbranch" -eq 1 ]; then
    local dep up ahead detected note
    dep="$(deployed_sha)"
    up="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "origin/$GARDEN_MAIN_BRANCH" || true)"
    ahead="$(git -C "$GARDEN_ROOT" rev-list --count "$dep..$up" 2>/dev/null || echo '?')"
    detected="$(date -u +%FT%TZ)"
    log "deploy-lag: preflight '$rel' for schedule $sname exists on origin/$GARDEN_MAIN_BRANCH but not in this deployed root ($dep, behind by $ahead); the pending deploy is the cause"
    # (a) A distinct one-shot note in the deploy surface, next to upgrade-ready.
    note="$(preflight_deploy_lag_note "$sname")"
    mkdir -p "$(dirname "$note")" 2>/dev/null || true
    {
      echo "Scheduler preflight deploy-lag"
      echo
      echo "schedule:   $sname"
      echo "preflight:  $rel"
      echo "status:     present on origin/$GARDEN_MAIN_BRANCH, ABSENT from this deployed root"
      echo "deployed:   $dep"
      echo "available:  $up"
      echo "ahead_by:   $ahead commit(s)"
      echo "host:       $GARDEN"
      echo "detected:   $detected"
      echo
      echo "The named preflight gate cannot run because this host is behind the dev"
      echo "branch that already carries it, so the schedule fails open and re-dispatches"
      echo "every cadence. Deploying this host (scripts/jobs/deploy-garden.sh) resolves it."
    } > "$note" 2>/dev/null || true
    # (b) A one-shot message-bus escalation so it is actively surfaced, not just a
    #     file. Best-effort; a delivery failure never aborts the scheduler.
    {
      printf 'Scheduler preflight gate for schedule "%s" is a DEPLOY-LAG symptom, not a typo.\n\n' "$sname"
      printf 'The gate script "%s" exists on origin/%s but is ABSENT from this host'\''s\n' "$rel" "$GARDEN_MAIN_BRANCH"
      printf 'deployed root (deployed %s, behind by %s commit(s)). The schedule is failing\n' "$dep" "$ahead"
      printf 'open and re-dispatching every cadence until this host is deployed.\n\n'
      printf 'Fix: scripts/jobs/deploy-garden.sh on %s. One-time signal per breakage.\n' "$GARDEN"
    } | "$HERE/message-user.sh" "scheduler-preflight-deploy-lag-$sname" >/dev/null 2>&1 || true
  fi

  mkdir -p "$(dirname "$marker")" 2>/dev/null || true
  printf '%s\n' "$pfpath" > "$marker" 2>/dev/null || true
}

DIR="${GARDEN_SCHEDULER_CLONE:-$GARDEN_STATE/scheduler/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

now="$(scheduler_now)"
dispatched=0
for name in $(list_jobs "$DIR" schedules); do
  f="$DIR/schedules/$name"

  # One-time future schedule (`once: <ISO>`): dispatch exactly once when due,
  # then DELETE the schedule file in the same CAS commit so it never repeats.
  # The recurring path below is unchanged.
  once_iso="$(sed -n 's/^once:[[:space:]]*//p' "$f" | head -1)"
  if [ -n "$once_iso" ]; then
    due="$(date -u -d "$once_iso" +%s 2>/dev/null || echo '')"
    [ -n "$due" ] || { log "schedule $name has unparseable once: '$once_iso'; skipping"; continue; }
    [ "$now" -ge "$due" ] || continue   # not due yet
    prefix="$(sed -n 's/^job_basename_prefix:[[:space:]]*//p' "$f" | head -1)"
    base="${prefix:-${name%.md}}"       # deterministic — no timestamp, so a retry is idempotent
    for attempt in $(seq 1 50); do
      sync_clone "$DIR"
      [ -f "$DIR/schedules/$name" ] || { log "schedule $name already fired+removed; skip"; break; }
      body="$(sed '1,/^---$/d' "$DIR/schedules/$name")"
      git -C "$DIR" rm -q "schedules/$name"
      if [ -e "$DIR/$JOBS_TODO/$base.md" ] || [ -e "$DIR/$JOBS_DOIN/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
        # job already exists in the lifecycle — just retire the schedule
        if commit_and_push "$DIR" "schedule-once($name) already dispatched; removing"; then
          log "one-time schedule $name retired ($base already present)"; break
        fi
      else
        mkdir -p "$DIR/$JOBS_TODO"
        printf '%s\n' "$body" > "$DIR/$JOBS_TODO/$base.md"
        git -C "$DIR" add "$JOBS_TODO/$base.md"
        if commit_and_push "$DIR" "schedule-once($name) dispatched $base + removed"; then
          log "dispatched $base from one-time schedule $name (removed)"; dispatched=$((dispatched+1)); break
        fi
      fi
      backoff "$attempt"
    done
    continue
  fi

  cad="$(sed -n 's/^cadence:[[:space:]]*//p' "$f" | head -1)"
  last_iso="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$f" | head -1)"
  prefix="$(sed -n 's/^job_basename_prefix:[[:space:]]*//p' "$f" | head -1)"
  preflight="$(sed -n 's/^preflight:[[:space:]]*//p' "$f" | head -1)"
  cad_s="$(cadence_seconds "$cad")"
  last=0; [ -n "$last_iso" ] && last="$(date -u -d "$last_iso" +%s 2>/dev/null || echo 0)"
  [ $(( now - last )) -ge "$cad_s" ] || continue

  stamp="$(date -u -d "@$now" +%FT%TZ)"
  base="${prefix:-$name}-$(date -u -d "@$now" +%Y%m%d-%H%M%S)"
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    # re-check due against the freshest state (another host may have dispatched)
    last_iso="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$DIR/schedules/$name" | head -1)"
    last=0; [ -n "$last_iso" ] && last="$(date -u -d "$last_iso" +%s 2>/dev/null || echo 0)"
    [ $(( now - last )) -ge "$cad_s" ] || { log "$name no longer due; skip"; break; }

    body="$(sed '1,/^---$/d' "$DIR/schedules/$name")"

    # Consecutive not-found streak, read fresh each attempt so a lost CAS race
    # recomputes off the freshest board state. Defaults to 0 and stays 0 for a
    # gate that is present (whether it says work-present, no-work, or errors).
    missing_streak="$(sed -n 's/^preflight_missing_streak:[[:space:]]*//p' "$DIR/schedules/$name" | head -1)"
    missing_streak="${missing_streak:-0}"
    new_streak="$missing_streak"
    escalate_now=0

    # Optional deterministic preflight gate (designs/job-board.md; skills/schedule).
    # A `preflight:` script proves in plain code whether this schedule has any work,
    # moving the idle/active decision off the dispatched agent. Resolved relative to
    # this script's dir (scripts/jobs/) unless absolute, and passed the schedule
    # name. Run INSIDE the CAS loop so it sees the freshest board state. Exit codes:
    #   0     work present     → post the job + stamp last_dispatched (normal path)
    #   2     no work          → stamp last_dispatched only (advance the clock,
    #                            post nothing), and log the gate
    #   other treat as 0       → fail open, so a broken/erroring gate (incl. an
    #                            EX_TEMPFAIL offline tick) never silently starves
    #                            the schedule.
    # A gate that is NOT FOUND / not executable also fails open (work-present), but
    # is DISTINGUISHED from a gate that runs and errors: a missing gate persists
    # every cadence and silently burns an expensive dispatch, so we count the
    # consecutive not-found ticks and, past the threshold, escalate once to the
    # maintainer inbox. A gate that is merely erroring is transient and resets the
    # streak (it exists, so a deploy-lag/typo is not the cause).
    if [ -n "$preflight" ]; then
      pf="$preflight"; case "$pf" in /*) :;; *) pf="$HERE/$pf";; esac
      pf_rc=0
      if [ -x "$pf" ]; then
        new_streak=0   # gate present → not a not-found tick, clear any streak
        clear_missing_preflight "$name"   # re-arm the one-shot WARN + deploy-lag diagnosis
        if "$pf" "$name"; then pf_rc=0; else pf_rc=$?; fi
      else
        new_streak=$(( missing_streak + 1 ))
        # WARN ONCE per breakage (not every tick) and, on the first tick, diagnose
        # a deploy-lag cause once. Idempotent across CAS retries via its marker.
        note_missing_preflight "$name" "$preflight" "$pf"
        [ "$new_streak" -eq "$PREFLIGHT_MISSING_ESCALATE_THRESHOLD" ] && escalate_now=1
      fi
      if [ "$pf_rc" -eq 2 ]; then
        # No work: advance the clock so the cadence keeps marching, post nothing.
        write_schedule "$DIR/schedules/$name" "$cad" "$stamp" "$prefix" "$preflight" "$body" "$new_streak"
        git -C "$DIR" add "schedules/$name"
        if commit_and_push "$DIR" "schedule($name) preflight gated: no work; advanced clock"; then
          log "preflight gated: no work for $name; advanced clock, posted nothing"; break
        fi
        rc=$?; [ "$rc" -eq 2 ] && break   # already current; nothing to stamp
        backoff "$attempt"; continue      # lost the CAS race; re-sync and retry
      fi
    fi

    mkdir -p "$DIR/$JOBS_TODO"
    printf '%s\n' "$body" > "$DIR/$JOBS_TODO/$base.md"
    # stamp last_dispatched in the same commit (preserving preflight: + streak)
    write_schedule "$DIR/schedules/$name" "$cad" "$stamp" "$prefix" "$preflight" "$body" "$new_streak"
    git -C "$DIR" add "$JOBS_TODO/$base.md" "schedules/$name"
    if commit_and_push "$DIR" "schedule($name) dispatched $base"; then
      log "dispatched $base from schedule $name"; dispatched=$((dispatched+1))
      # Escalate only after the streak-bearing commit lands, so a lost CAS race
      # never double-escalates; equality with the threshold fires exactly once.
      [ "$escalate_now" -eq 1 ] && { escalate_missing_preflight "$name" "$preflight" "$new_streak" \
        || log "WARN could not escalate missing preflight for $name"; }
      break
    fi
    backoff "$attempt"
  done
done
log "dispatched $dispatched scheduled job(s)"
