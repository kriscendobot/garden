#!/bin/bash
# receipt-watcher.sh — per-repo PR-TERMINAL-STATE producer. Watch one gated repo's OWN
# PRs and, the moment one reaches a terminal state (MERGED or CLOSED) that the garden
# actually worked, generate its completion receipt. pr-receipt.sh is deterministic,
# plain-code, explicitly NO `claude -p`, so this watcher runs it DIRECTLY IN-PROCESS
# (rows + MRE + post + archive) — mirroring how ci/comment/dependabot watchers call
# their deterministic generators straight, rather than round-tripping through a
# post-job.sh LLM-tier claim that just re-invokes the same no-judgment script. The
# job-board post survives only as the STRUCTURAL-failure fallback: if the direct call
# fails for a non-transient reason (a genuine pr-receipt.sh bug), post <slug>-pr<N>-
# receipt so a gardener re-runs it and the doom machinery surfaces a persistent failure
# to the maintainer inbox instead of this watcher retrying silently forever.
#
# Usage: receipt-watcher.sh <repo-slug>      e.g. endojs-endo-but-for-bots
#
# Sibling to ci-watcher.sh (watches CI STATUS) and comment-watcher.sh (watches COMMENT
# text). This one watches PR TERMINAL STATE. Fully DETERMINISTIC — plain-code state
# reads and a fixed mapping, NO `claude -p`, NO external comment text into any model
# (it reads only PR number/state/timestamps; the generator later reads human comment
# bodies only to COUNT and MEASURE length). Injection-safe by construction like
# ci-watcher, and armed only for repos already in the journal's comment-repos/ set
# (reconciled by repo-watcher.sh) — it widens the monitoring surface by nothing
# (CLAUDE.md § Monitoring safety constraint). Leader-only via the unit's ExecCondition.
# Design: designs/pr-completion-receipts.md § The trigger.
#
# THE PIPELINE, per tick:
#   read a durable journal cursor receipts/<slug> (last completion timestamp handled)
#     → enumerate the repo's terminally-closed PRs newest-first (authoritative REST)
#     → keep PRs completed AFTER the cursor (first run seeds the cursor to now and
#       posts NOTHING historical — receipts are for work completed GOING FORWARD)
#     → drop PRs the garden did not work (no jobs/index identity, panel-runs, or
#       gauntlet-archived record naming the PR)
#     → drop PRs that already have a receipt (journal archive file, OR the
#       <!-- garden-receipt: repo#N --> comment marker)
#     → GENERATE the receipt in-process: pr-receipt.sh <repo> <num> --dir <clone>
#       (idempotent by its own archive/comment-marker guards)
#     → only on a STRUCTURAL generate failure, fall back to post <slug>-pr<N>-receipt
#       (idempotent by basename via post-job.sh) so the bug surfaces; a TRANSIENT
#       generate failure cools down and retries next tick, posting nothing
#     → advance the cursor to the newest completion fully handled this tick.
#
# The per-PR I/O is indirected so a test can substitute a deterministic stub:
#   GARDEN_RECEIPT_PR_SOURCE <owner/name>          -> TSV: number state completed_at (ISO)
#   GARDEN_RECEIPT_GENERATE  <repo> <num> --dir D  (pr-receipt.sh, the common path)
#   GARDEN_RECEIPT_POST      <basename> <file>     (post-job.sh, the fallback path)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

slug="${1:?usage: receipt-watcher.sh <repo-slug>}"
export GARDEN_TAG="receipt-watcher/$slug"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_RECEIPT_PR_SOURCE:=$HERE/handlers/receipt-pr-source-gh.sh}"
# The deterministic generator this watcher now invokes DIRECTLY, in-process, on the
# common path (no LLM dispatch). post-job.sh is retained only as the STRUCTURAL-failure
# fallback below.
: "${GARDEN_RECEIPT_GENERATE:=$HERE/pr-receipt.sh}"
: "${GARDEN_RECEIPT_POST:=$HERE/post-job.sh}"
# PER-SLUG journal clone (default keyed on $slug). Every armed
# garden-receipt-watcher@<slug> instance (currently 16 repos) runs concurrently on the
# same cadence (OnUnitActiveSec=300s, RandomizedDelaySec=60s) with per-run wall times of
# 30–100s+. A single shared clone ($GARDEN_STATE/receipt-watcher/journal) serialized all
# 16 on ONE sibling clone_lock in ensure_clone/sync_clone (fetch + `git reset --hard`),
# so a queued-out loser died loudly on routine contention — the FATAL "receipt journal
# prerequisite failed" (empty prerequisite stderr) that recurred across differing slugs
# clustered in the same few-minute window. Giving each slug its OWN clone gives it its
# OWN $DIR.lock sibling (_clone_lockfile), so the instances never contend: no shared
# lock, no cross-instance fetch/reset race. A watcher instance is a systemd singleton
# per instance name, so its own per-slug clone has no concurrent users and common.sh's
# default clone_lock budget suffices. The set of clones is bounded (one per armed slug)
# and reused across ticks, not an unbounded per-id leak. Override to a shared path only
# in a test that deliberately exercises the concurrent-clone path.
: "${GARDEN_RECEIPT_WATCH_CLONE:=$GARDEN_STATE/receipt-watcher/journal-$slug}"
# On the very first tick (no cursor yet), seed the cursor this far back rather than to
# "now", so a just-completed PR from the last day or two is still picked up — but the
# whole historical backlog is NOT flooded as live comments. Empty ⇒ seed to now.
: "${GARDEN_RECEIPT_SEED_WINDOW:=2 days}"
: "${GARDEN_RECEIPT_SOURCE_TIMEOUT_SECS:=180}"
# Bound the in-process generator too: pr-receipt.sh does bounded gh reads plus a
# CAS-retried archive push, so it should finish well inside this, but a hung gh call
# must not wedge the tick. A timeout kill classifies as transient (rc=124), so the tick
# cools down and retries rather than posting a wasteful fallback job.
: "${GARDEN_RECEIPT_GENERATE_TIMEOUT_SECS:=300}"
: "${GARDEN_RECEIPT_KILL_AFTER:=10s}"
# Bound the EXIT-path cgroup sweep so an unkillable process cannot wedge shutdown.
: "${GARDEN_RECEIPT_CGROUP_REAP_DEADLINE_SECS:=3}"

# A journal/GitHub outage is shared by every per-repo instance of this watcher.
# Collapse it onto common.sh's host-wide gh-api cooldown: the first observer opens
# one bounded window and warns; siblings exit 0 without each becoming a failed
# systemd unit. Structural errors deliberately return false so the caller prints
# the captured diagnostic and fails loud on every later tick until repaired.
#
# A GitHub PRIMARY hourly-quota refusal is classified BEFORE the transient path: the
# account-wide bucket cannot recover before its hourly reset, so the short default
# window would expire inside the quota hour and the next tick would retry a doomed
# call. Request the full api_primary_quota_secs window instead, as comment-watcher
# does. When gh_api_retry already latched the quota (the usual case: the source's or
# generator's gh call recorded it under the admission lock, where nobody announces
# it), start_api_cooldown ADOPTS that latch with its expiry untouched and this tick
# owns the single WARN, so the logged window is read back from the marker: the real
# remaining cooldown, not the nominal request.
shared_availability_failure() {  # shared_availability_failure <stage> <rc> <stderr-file>
  local stage="$1" rc="$2" errf="$3" pq_secs expiry now
  if is_gh_primary_rate_limit_text "$(cat "$errf" 2>/dev/null || true)"; then
    pq_secs="$(api_primary_quota_secs)"
    if start_api_cooldown "receipt:$slug:$stage:primary-quota" "$pq_secs"; then
      expiry="$(sed -n '1p' "$(_api_cooldown_marker_for all)" 2>/dev/null || true)"
      now="$(date +%s)"
      case "$expiry" in ''|*[!0-9]*) : ;; *) [ "$expiry" -le "$now" ] || pq_secs=$((expiry - now)) ;; esac
      log "WARN: receipt $stage hit GitHub primary quota exhaustion (rc=$rc) — cooling all receipt/gh-api watchers for ${pq_secs}s (never guess)"
    fi
    return 0
  fi
  if [ "$rc" -eq "$GARDEN_OFFLINE_RC" ] || [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || \
     is_transient_net_error "$errf" || is_transient_gh_source_error "$errf"; then
    if start_api_cooldown "receipt:$slug:$stage"; then
      log "WARN: receipt $stage unavailable (transient, rc=$rc) — cooling all receipt/gh-api watchers for $(_api_cooldown_secs)s (never guess)"
    fi
    return 0
  fi
  return 1
}

fleet_draining && { log "fleet draining; skipping"; exit 0; }
api_cooldown_active && exit 0

owner="${slug%%-*}"; name="${slug#*-}"
repo="$owner/$name"
[ "$owner" != "$slug" ] && [ -n "$name" ] || die "cannot derive owner/name from slug '$slug'"

DIR="$GARDEN_RECEIPT_WATCH_CLONE"
PREREQ_ERR="$(mktemp)"
prereq_rc=0
# Contain both helpers in a subshell: ensure_clone and sync_clone intentionally use
# die/exit for structural and EX_TEMPFAIL outcomes, which a same-shell `||` cannot
# catch. The subshell turns either exit into data we can classify here.
#
# The ERR trap records the failing command/line into PREREQ_ERR for the case that
# actually bit us (self-heal capture 24818db04 — endojs/endo-but-for-bots: prereq_rc=1
# with a COMPLETELY EMPTY PREREQ_ERR): a command inside the subshell fails without ever
# reaching die()/log() (which always write to stderr), so nothing at all was captured.
# Diagnostics only — on success no command fails, so the trap never fires and behavior
# is identical.
#
# Getting the trap to fire is subtle: the old `( … ) 2>ERR || prereq_rc=$?` put the
# subshell in a `||` (tested) context, where bash IGNORES errexit — and the ERR trap
# fires only under errexit conditions, so a bare `trap … ERR` there never fires. So we
# instead (1) `set +e` in the parent so the subshell is a standalone statement (not a
# `||`-tested one) and its rc can be read separately without killing the script, (2)
# `set -eE` INSIDE the subshell — errexit re-armed for a subshell that is now in an
# un-ignored context, plus errtrace so the ERR trap is inherited into ensure_clone /
# sync_clone and the sourced common.sh helpers they call, and (3) capture prereq_rc as a
# separate statement, then restore the parent's errexit. die()/exit inside still
# propagate as the subshell rc with their own stderr, exactly as before.
set +e
( set -eE
  trap 'echo "  [prereq] failed at ${BASH_SOURCE[0]##*/}:$LINENO in ${FUNCNAME[0]:-main}(): $BASH_COMMAND (rc=$?)" >&2' ERR
  ensure_clone "$DIR"; sync_clone "$DIR" ) 2>"$PREREQ_ERR"
prereq_rc=$?
set -e
if [ "$prereq_rc" -ne 0 ]; then
  # A live peer can legitimately hold this clone through a contention rebuild
  # longer than clone_lock's bounded wait ladder. That is local, self-resolving
  # contention: skip this tick without opening the fleet-wide gh-api cooldown.
  # clone_lock_is_busy_contention keeps definite local/auth/corruption failures
  # loud even when the same capture also contains the busy-lock signature.
  if clone_lock_is_busy_contention "$prereq_rc" "$(cat "$PREREQ_ERR")"; then
    log "receipt journal clone lock busy (live peer; likely a contention rebuild) — skipping tick"
    rm -f "$PREREQ_ERR"
    exit 0
  fi
  if shared_availability_failure "journal prerequisite" "$prereq_rc" "$PREREQ_ERR"; then
    rm -f "$PREREQ_ERR"
    exit 0
  fi
  if [ -s "$PREREQ_ERR" ]; then
    sed -E 's/^(<[0-9]>)?/\1  prerequisite: /' "$PREREQ_ERR" >&2 || true
    rm -f "$PREREQ_ERR"
    die "receipt journal prerequisite failed for $repo (rc=$prereq_rc; see prerequisite stderr above)"
  fi
  rm -f "$PREREQ_ERR"
  # A completely empty stderr here is now the environmental-interruption signature: the
  # ERR trap above (commit 3002969de5) captures any command that fails under errexit, and
  # every die()/log() path in ensure_clone/sync_clone/clone_lock/journal_remote logs
  # unconditionally — so if NOTHING was captured, the subshell was cut down before a
  # command could fail and report (a fork failure, ENOSPC on $TMPDIR, an OOM kill, or a
  # signal), bypassing normal error reporting. Point a future self-heal responder at a
  # resource check rather than leaving them to diagnose a silent rc=$prereq_rc.
  log "WARN: prerequisite subshell produced NO diagnostic output (rc=$prereq_rc) — neither the ERR trap nor any die()/log() fired, so the subshell was likely cut down by an environmental interruption (fork failure, ENOSPC on \$TMPDIR=${TMPDIR:-/tmp}, OOM, or a signal) that bypassed normal error reporting; check host disk space and fork/process limits"
  die "receipt journal prerequisite failed for $repo (rc=$prereq_rc; no diagnostic captured — see WARN above; suspect a resource/environmental interruption)"
fi
cat "$PREREQ_ERR" >&2
rm -f "$PREREQ_ERR"

# --- garden_worked_pr <n> : cheap "did the garden touch this PR" gate ---------
# True when a jobs/index identity names repo#n, OR a panel-runs / gauntlet-archived
# record for the PR exists. Deterministic, journal-local, no gh. Keeps the watcher
# from minting receipt jobs for PRs the garden never worked (a foreign merge).
garden_worked_pr() {
  local n="$1"
  [ -d "$DIR/panel-runs/$slug-$n" ] && return 0
  [ -d "$DIR/panel-runs/$slug-pr$n" ] && return 0
  if [ -d "$DIR/jobs/gauntlet-archived" ] && \
     ls "$DIR/jobs/gauntlet-archived/"*"pr$n"* >/dev/null 2>&1; then return 0; fi
  if [ -d "$DIR/jobs/index" ] && \
     grep -rlE "^identity:[[:space:]]*$repo#$n([^0-9]|$)" "$DIR/jobs/index" >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

# --- receipt_exists <n> : idempotency — a receipt already produced -----------
# Journal archive file present is the cheap first guard; the PR-comment marker is the
# authoritative second (a posted-but-not-archived crash). We check the journal file
# here (cheap, no gh); the generator re-checks the comment marker before posting, so a
# missing-file-but-present-marker case is still deduped downstream.
receipt_exists() {
  local n="$1"
  ls "$DIR/receipts/$slug/"*/*/"pr$n.md" >/dev/null 2>&1 && return 0
  return 1
}

# --- cursor (last completion timestamp handled) ------------------------------
cursor_raw="$("$HERE/cursor-get.sh" "receipts/$slug" 2>/dev/null || true)"
cursor="$(printf '%s' "$cursor_raw" | sed -n 's/^last_completed_at:[[:space:]]*//p' | head -1)"
if [ -z "$cursor" ]; then
  # First tick: seed and post nothing historical.
  if [ -n "${GARDEN_RECEIPT_SEED_WINDOW:-}" ]; then
    cursor="$(date -u -d "-${GARDEN_RECEIPT_SEED_WINDOW}" +%FT%TZ 2>/dev/null || date -u +%FT%TZ)"
  else
    cursor="$(date -u +%FT%TZ)"
  fi
  printf 'last_completed_at: %s\n' "$cursor" | "$HERE/cursor-set.sh" "receipts/$slug" >/dev/null 2>&1 || true
  log "first tick on $repo — seeded receipt cursor to $cursor (no historical backfill)"
fi

# --- enumerate terminally-closed PRs (bounded, reaped source) ----------------
SRC="$(mktemp)"; ERRF="$(mktemp)"; SRC_PID=""
# rc 0 iff <pid> is still running. A killed zombie has already left the cgroup even
# though kill -0 continues to find it, so consult /proc state as well.
_straggler_alive() {  # _straggler_alive <pid>
  local p="$1" st
  kill -0 "$p" 2>/dev/null || return 1
  st="$(awk '{ s=$0; sub(/^.*\) /,"",s); print substr(s,1,1) }' "/proc/$p/stat" 2>/dev/null || echo Z)"
  [ "$st" != Z ]
}

# _proc_starttime <pid> — the kernel start time (clock ticks since boot, stat field 22).
_proc_starttime() {
  awk '{ s=$0; sub(/^.*\) /,"",s); split(s,f," "); print f[20] }' "/proc/$1/stat" 2>/dev/null
}

# Fell descendants that escaped the source process group but remain in this
# watcher's service cgroup. The leaf guard and keep-set make this a strict no-op
# outside garden-receipt-watcher services and ensure $$ and its ancestors are never
# signalled. A test-only cgroup.procs fixture exercises the loop without granting CI
# control over a real cgroup.
#
# `reap_cgroup_stragglers startup` runs the same sweep BEFORE the PR source starts,
# restricted to VERIFIED prior-run stragglers: a pid that started strictly before this
# run's eldest in-cgroup ancestor (the self-heal-run.sh main PID). Every process this
# run spawned — our own children and the wrapper's concurrent tee sibling — descends
# from that ancestor and so is no older than it. The age test deliberately does not
# consult parentage: an orphaned prior-run git is reparented to the user manager, which
# is also this run's main PID's parent. This fells the git helpers a previous tick left
# behind (systemd "Found left-over process ... (git)" at start, 2026-09-29) before they
# can race the new tick's fetch/clone.
reap_cgroup_stragglers() {  # reap_cgroup_stragglers [startup]
  local mode="${1:-exit}" procs
  if [ -n "${GARDEN_RECEIPT_CGROUP_PROCS_FILE:-}" ] && _in_test_context; then
    procs="$GARDEN_RECEIPT_CGROUP_PROCS_FILE"
    [ -r "$procs" ] || return 0
  else
    local line cgpath leaf
    line="$(grep '^0::' /proc/self/cgroup 2>/dev/null)" || return 0
    [ -n "$line" ] || return 0
    cgpath="${line#0::}"
    leaf="${cgpath##*/}"
    case "$leaf" in
      garden-receipt-watcher@*.service) ;;
      *) return 0 ;;
    esac
    procs="/sys/fs/cgroup${cgpath}/cgroup.procs"
    [ -r "$procs" ] || return 0
  fi

  local keep=" $$ " p ppid
  p="$$"
  while [ -n "$p" ] && [ "$p" != "0" ]; do
    ppid="$(awk '/^PPid:/{print $2}' "/proc/$p/status" 2>/dev/null)" || break
    [ -n "$ppid" ] || break
    keep="$keep$ppid "
    [ "$ppid" = "1" ] && break
    p="$ppid"
  done

  # Re-read cgroup.procs each pass to close both races in a one-shot sweep: a child
  # can fork after the first snapshot, and SIGKILL can be queued while the victim is
  # still present during watcher teardown. Stop only once no live stragglers remain,
  # or at the bounded deadline for an unkillable D-state process.
  # Startup mode: this run began when its eldest ancestor still in the cgroup started
  # (in a fixture no ancestor is listed, so fall back to $$). Anything older that is
  # not in our own process tree can only be left over from a previous tick.
  local run_start="" st k
  if [ "$mode" = startup ]; then
    run_start="$(_proc_starttime "$$")"
    while read -r k; do
      [ -n "$k" ] || continue
      case "$keep" in *" $k "*) ;; *) continue ;; esac
      st="$(_proc_starttime "$k")"
      [ -n "$st" ] && [ -n "$run_start" ] && [ "$st" -lt "$run_start" ] && run_start="$st"
    done < "$procs"
    [ -n "$run_start" ] || return 0
  fi

  local deadline_secs="$GARDEN_RECEIPT_CGROUP_REAP_DEADLINE_SECS"
  local now start pid remaining felled=""
  start="$(date +%s 2>/dev/null || echo 0)"
  while :; do
    remaining=0
    while read -r pid; do
      [ -n "$pid" ] || continue
      case "$keep" in *" $pid "*) continue ;; esac
      _straggler_alive "$pid" || continue
      if [ "$mode" = startup ]; then
        st="$(_proc_starttime "$pid")"
        [ -n "$st" ] && [ "$st" -lt "$run_start" ] || continue
        case " $felled " in *" $pid "*) ;; *) felled="$felled $pid" ;; esac
      fi
      kill -KILL "$pid" 2>/dev/null || true
      remaining=$((remaining + 1))
    done < "$procs"
    if [ "$remaining" -eq 0 ]; then
      [ -z "$felled" ] || log "reaped prior-run cgroup straggler(s) at startup:$felled"
      return 0
    fi
    now="$(date +%s 2>/dev/null || echo 0)"
    if [ $((now - start)) -ge "$deadline_secs" ]; then
      log "WARN: cgroup still holds $remaining $mode straggler(s) after ${deadline_secs}s reap deadline ($procs) — best-effort; next start may migrate them"
      return 0
    fi
    sleep 0.1 2>/dev/null || sleep 1
  done
}

cleanup() {
  rm -f "$SRC" "$ERRF"
  local pid="$SRC_PID"; SRC_PID=""
  if [ -n "$pid" ]; then
    kill -TERM "-$pid" 2>/dev/null || kill -TERM "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    kill -KILL "-$pid" 2>/dev/null || true
  fi
  reap_cgroup_stragglers
}
trap 'cleanup' EXIT
trap 'cleanup; exit 143' TERM
trap 'cleanup; exit 130' INT

# Fell verified prior-run stragglers before this tick's source spawns its own git.
reap_cgroup_stragglers startup

src_rc=0
if command -v timeout >/dev/null 2>&1; then
  timeout --signal=TERM --kill-after="$GARDEN_RECEIPT_KILL_AFTER" "${GARDEN_RECEIPT_SOURCE_TIMEOUT_SECS}s" \
    "$GARDEN_RECEIPT_PR_SOURCE" "$repo" > "$SRC" 2>"$ERRF" &
  SRC_PID=$!
  wait "$SRC_PID" || src_rc=$?
  SRC_PID=""
else
  "$GARDEN_RECEIPT_PR_SOURCE" "$repo" > "$SRC" 2>"$ERRF" || src_rc=$?
fi
if [ "$src_rc" -ne 0 ]; then
  if shared_availability_failure "PR source" "$src_rc" "$ERRF"; then
    exit 0
  fi
  sed -E 's/^(<[0-9]>)?/\1  source: /' "$ERRF" >&2 || true
  die "receipt PR source failed for $repo (rc=$src_rc; see source stderr above)"
fi

# --- process candidates (oldest completion first; advance cursor as we go) ----
# The source emits `number<TAB>state<TAB>completed_at` newest-first. Sort ascending by
# completion so the cursor advances monotonically and a mid-tick post failure leaves
# the cursor BEFORE the unhandled PR (retried next tick).
scanned=0; worked=0; posted=0; skipped=0; newcur="$cursor"
while IFS=$'\t' read -r num st done_at; do
  [ -n "$num" ] || continue
  case "$num" in *[!0-9]*) continue ;; esac
  scanned=$((scanned+1))
  # Only PRs completed strictly after the cursor.
  [ -n "$done_at" ] || continue
  if ! [ "$done_at" \> "$cursor" ]; then continue; fi
  if ! garden_worked_pr "$num"; then
    log "#$num ($st) completed but the garden did not work it (no index/panel/gauntlet record) — skip"
    [ "$done_at" \> "$newcur" ] && newcur="$done_at"
    continue
  fi
  worked=$((worked+1))
  if receipt_exists "$num"; then
    log "#$num already has a journal receipt — idempotent skip"
    skipped=$((skipped+1))
    [ "$done_at" \> "$newcur" ] && newcur="$done_at"
    continue
  fi
  base="$slug-pr$num-receipt"
  # --- generate the receipt IN-PROCESS (deterministic, no LLM dispatch) --------
  # pr-receipt.sh is plain code, explicitly NO `claude -p`, and this same process
  # already computed repo/num and holds a freshly-synced journal clone ($DIR) the
  # generator reuses via --dir. Round-tripping through post-job.sh into an LLM-tier
  # claim (the old `tier: mentor` / `fallback-tier: minion` job whose body just said
  # "run pr-receipt.sh") was pure waste and self-defeating: an LLM asked to run a
  # no-judgment script burned a model attempt + fallback that both exited rc=1 in a
  # constant ~3s with no output, tripped the gardener elapsed-constancy overrun-suspect
  # detector, and got doomed `requeue-exhausted`
  # (kriscendobot-oros-ckm-data-readiness-pr1-receipt). Mirror ci/comment/dependabot
  # watchers: call the deterministic generator straight.
  gen_err="$(mktemp)"; gen_rc=0
  if command -v timeout >/dev/null 2>&1; then
    timeout --signal=TERM --kill-after="$GARDEN_RECEIPT_KILL_AFTER" "${GARDEN_RECEIPT_GENERATE_TIMEOUT_SECS}s" \
      "$GARDEN_RECEIPT_GENERATE" "$repo" "$num" --dir "$DIR" >/dev/null 2>"$gen_err" || gen_rc=$?
  else
    "$GARDEN_RECEIPT_GENERATE" "$repo" "$num" --dir "$DIR" >/dev/null 2>"$gen_err" || gen_rc=$?
  fi
  if [ "$gen_rc" -eq 0 ]; then
    log "generated receipt in-process for #$num (deterministic, no LLM dispatch)"
    posted=$((posted+1))
    rm -f "$gen_err"
    [ "$done_at" \> "$newcur" ] && newcur="$done_at"
  elif shared_availability_failure "receipt generate" "$gen_rc" "$gen_err"; then
    # A transient outage (network / timeout / rate-limit) is NOT a pr-receipt.sh bug:
    # do not waste a fallback job on it. Cool down, leave the cursor before #$num, and
    # retry next tick — exactly as the PR-source and journal-prerequisite paths do.
    log "receipt generate for #$num hit a transient outage (rc=$gen_rc) — cooled down, will retry next tick"
    rm -f "$gen_err"
    break
  else
    # A STRUCTURAL failure of the deterministic generator is a genuine pr-receipt.sh
    # bug (or a malformed ledger). Fall back to the job board so a gardener re-runs it
    # and, if it keeps failing, the doom machinery surfaces it to the maintainer inbox
    # — rather than this watcher silently retrying the same broken call every tick.
    sed -E 's/^/  generate: /' "$gen_err" >&2 || true
    log "WARN: in-process receipt generate for #$num failed structurally (rc=$gen_rc) — falling back to a job-board post so the failure surfaces"
    rm -f "$gen_err"
    jb="$(mktemp)"
    {
      printf '# receipt (fallback) — completion receipt for %s PR #%s (%s)\n\n' "$repo" "$num" "$st"
      printf 'tier: mentor\nfallback-tier: minion\n\n'
      printf 'The receipt watcher tried to generate this completion RECEIPT in-process and\n'
      printf 'the deterministic generator FAILED structurally (see the watcher log). This is\n'
      printf 'the surfacing fallback: run the generator, which builds the per-engagement rows\n'
      printf '+ the maintainer-review heuristic, posts the PR comment (identity-pinned gh),\n'
      printf 'and archives the receipt in the journal, all idempotently:\n\n'
      printf '    scripts/jobs/pr-receipt.sh %s %s\n\n' "$repo" "$num"
      printf 'It is fail-open and idempotent (journal archive file + comment marker guards),\n'
      printf 'so a re-run never double-posts. If it fails again, report the failure so the\n'
      printf 'generator bug reaches the maintainer inbox rather than retrying forever.\n'
      printf 'See designs/pr-completion-receipts.md and scripts/jobs/pr-receipt.sh.\n\n'
      printf 'PR: https://github.com/%s/pull/%s\n' "$repo" "$num"
    } > "$jb"
    if "$GARDEN_RECEIPT_POST" "$base" "$jb" >/dev/null 2>&1; then
      log "posted fallback $base after in-process generate failed on #$num"
      posted=$((posted+1))
      [ "$done_at" \> "$newcur" ] && newcur="$done_at"
    else
      log "WARN: fallback post of $base did not land — leaving cursor before #$num for retry next tick"
      rm -f "$jb"
      break
    fi
    rm -f "$jb"
  fi
done < <(sort -t"$(printf '\t')" -k3,3 "$SRC")

if [ "$newcur" \> "$cursor" ]; then
  printf 'last_completed_at: %s\n' "$newcur" | "$HERE/cursor-set.sh" "receipts/$slug" >/dev/null 2>&1 \
    && log "advanced receipt cursor for $slug to $newcur"
fi
log "scanned $scanned closed PR(s) on $repo since $cursor: $worked garden-worked, $posted receipt(s) produced (in-process or fallback), $skipped already-receipted"
