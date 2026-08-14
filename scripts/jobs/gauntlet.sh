#!/bin/bash
# gauntlet.sh — the deterministic STAGED-GAUNTLET driver: walk a PR through the
# clean → panel → fix-loop → un-draft chain ONE claim-sized stage at a time, so no
# single handler ever spans the (unbounded) loop.
#
# Usage: gauntlet.sh   (timer-driven oneshot; one tick per invocation)
#
# THE PROBLEM (designs/staged-gauntlet.md): the gauntlet ran as ONE claimed job
# whose wall-clock was the SUM of every stage, every fix-loop iteration, and every
# CI wait — a sum that fits no handler budget. Nine jobs doomed on deadline-overrun
# 2026-07-28, one already at a 14000s budget against the GARDEN_CLAIM_TTL ceiling.
# The budget ladder is exhausted; splitting is the only move.
#
# THE SHAPE: decompose the gauntlet into claim-sized STAGE jobs (`<g>-clean`,
# `<g>-panel-<k>`, `<g>-fix-<k>`, `<g>-undraft`), each a normal independently
# claimable job with its own fresh handler budget and per-base worktree. This driver
# is the per-PR analog of orchestrate.sh: a deterministic, leader-only, NO-`claude -p`
# watcher over a RECORD outside the claim lifecycle (`jobs/gauntlet/<g>.md`), advancing
# every active record ONE step per tick against the board and each stage's completion
# marker. Succession lives in ONE deterministic place, not scattered across handlers.
#
# PER TICK, per active record, read `current_child`'s board state (byte-for-byte the
# read orchestrate.sh performs):
#   active  — in jobs/todo/ or jobs/doin/            → wait (do nothing this tick).
#   failed  — in NONE (promoted then vanished: the reaper doomed it), or its tada
#             report carries the orchestration-failed marker, or it was doom-parked
#             in plan/                                → HALT (surface once, never a
#             silent strand).
#   done    — in jobs/tada/ → read its STAGE-RESULT MARKER and apply the transition:
#
#     <!-- gauntlet-stage-result: <stage>=<result> -->
#
#     | completed | result        | next                                            |
#     | clean     | done          | panel-1                                         |
#     | clean     | still-pending | re-post <g>-clean (bounded by max_resumes)      |
#     | panel-k   | pass          | undraft (feature) / done (probe never un-drafts)|
#     | panel-k   | must-fix      | fix-k                                           |
#     | fix-k     | done          | panel-(k+1); if k+1 > max_iterations → HALT     |
#     | fix-k     | still-pending | re-post <g>-fix-k (bounded by max_resumes)      |
#     | undraft   | done          | done — write jobs/tada/<g>, remove the record   |
#
# A `done` child with NO parseable marker (or an unexpected marker value) is a
# FAILURE (halt + surface), never guessed at — the same fail-closed discipline
# panel.sh's disposition parse uses. `still-pending` is the ONE recognized
# non-terminal result: the CI-blocking stages (clean/fix) emit it when ci-wait-merge
# hits its deadline with CI still pending, and the driver re-posts the SAME stage
# base next tick (a fresh budget; a stable base resumes the stage's own session).
# That re-post is BOUNDED by `max_resumes` (per stage), so CI that never goes terminal
# — a checkless repo above all — halts loudly instead of looping forever (see
# resume_stage).
#
# SELF-HEALING: a dead stage is simply requeued by the reaper; the driver re-observes
# board state next tick and re-posts nothing it already posted (basename idempotence).
# Record writes are CAS-retried. Leader-only singleton (its unit's ExecCondition) so a
# halt surfaces to the maintainer exactly once; stage-job promotion is CAS-deduped and
# safe on any host.
#
# Pluggable for tests:
#   GARDEN_GAUNTLET_CLONE   this service's journal clone (default $GARDEN_STATE/gauntlet/journal).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="gauntlet"

require_tools git

fleet_draining && exit 0

DIR="${GARDEN_GAUNTLET_CLONE:-$GARDEN_STATE/gauntlet/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# The CI-blocking stages (clean/fix) need a CI-sized handler budget; only the short
# undraft stage fits the plain default. Kept under GARDEN_CLAIM_TTL so the reaper
# invariant holds.
: "${GARDEN_GAUNTLET_STAGE_HANDLER_TIMEOUT:=$GARDEN_SHEPHERD_HANDLER_TIMEOUT}"
# The panel stage is a SCRIPTED juror fan-out + aggregation, not a CI wait, but one
# round routinely runs LONGER than the plain GARDEN_HANDLER_TIMEOUT (2400s / 40min):
# the re-panel deadline overrun showed a single round exceeding it and being doomed
# after ONE deterministic wall hit (rc=124), so the panel base burned its requeue
# budget on a wall it was always going to hit rather than on genuine failure. Budget
# that known long-running stage its OWN CI-sized default (a dedicated knob so it tunes
# independently of the clean/fix CI budget) — comfortably under the same claim-TTL
# ceiling as GARDEN_SHEPHERD_HANDLER_TIMEOUT (GARDEN_CLAIM_TTL − GARDEN_HANDLER_KILL_AFTER
# − 1 ≈ 14339s at the shipped defaults), so the gardener honors it verbatim rather than
# clamping and escalating.
: "${GARDEN_GAUNTLET_PANEL_HANDLER_TIMEOUT:=7200}"
# CI-wait deadline for the clean/fix stages — comfortably UNDER the stage handler
# budget so ci-wait-merge returns rc=4 (still-pending) and the stage re-posts CLEANLY
# rather than the handler being killed mid-wait (which the reaper dooms after one
# cycle). Headroom above it covers the coverage/fix work that runs before the wait.
: "${GARDEN_GAUNTLET_CI_DEADLINE_SECS:=3600}"

# --- child state, read purely from the board (mirrors orchestrate.sh) --------
child_state() {  # <stage-base> → done|active|failed
  local c="$1" tada_path
  tada_path="$(tada_find "$DIR" "$c" || true)"
  if [ -n "$tada_path" ]; then
    # A tada report can carry the completed-but-declined marker (tada_failed) —
    # a stage that finished yet reported orchestration-failed: true.
    if tada_failed "$DIR/$tada_path"; then printf 'failed\n'; else printf 'done\n'; fi
    return 0
  fi
  if [ -e "$DIR/$JOBS_TODO/$c.md" ] || [ -e "$DIR/$JOBS_DOIN/$c.md" ]; then
    printf 'active\n'; return 0
  fi
  # A stage the reaper doom-PARKED in plan/ (requeue budget exhausted) is a FAILURE,
  # not a fresh job — otherwise the driver would wait on it forever.
  if [ -e "$DIR/$JOBS_PLAN/$c.md" ]; then
    printf 'failed\n'; return 0
  fi
  # In none of tada/todo/doin/plan: promoted and vanished without a tada (an older
  # doom drop, or a manual removal).
  printf 'failed\n'
}

# --- stage-result marker parse ----------------------------------------------
# Print "<stage> <result>" from the LAST marker in a tada report, or nothing if the
# report carries no parseable marker (→ the caller halts, fail-closed).
parse_stage_result() {  # <tada-file>
  grep -oE '<!--[[:space:]]*gauntlet-stage-result:[[:space:]]*[a-z]+=[a-z-]+[[:space:]]*-->' "$1" 2>/dev/null \
    | tail -1 \
    | sed -E 's/.*gauntlet-stage-result:[[:space:]]*([a-z]+)=([a-z-]+)[[:space:]]*-->.*/\1 \2/'
}

# --- record field update (CAS retry, like set_orch_state) -------------------
# Update one-or-more `key: value` frontmatter fields in the record, then push. Every
# gauntlet field exists from post-gauntlet.sh, so each key is REPLACED in place.
set_gauntlet_fields() {  # <base> key=val [key=val...]
  local base="$1"; shift
  local kvs=("$@") attempt rc kv k v vesc f
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    f="$DIR/$JOBS_GAUNTLET/$base.md"
    [ -f "$f" ] || return 0   # record already completed/removed — nothing to do
    for kv in "${kvs[@]}"; do
      k="${kv%%=*}"; v="${kv#*=}"
      vesc="$(printf '%s' "$v" | sed -e 's/[&/\]/\\&/g')"
      if grep -q "^$k:" "$f"; then
        sed -i "s/^$k:.*/$k: $vesc/" "$f"
      else
        sed -i "1a $k: $vesc" "$f"
      fi
    done
    git -C "$DIR" add "$JOBS_GAUNTLET/$base.md"
    rc=0; commit_and_push "$DIR" "gauntlet($base) ${kvs[*]} by $GARDEN" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # nothing to commit → already at that state
    backoff "$attempt"
  done
  return 1
}

# --- terminal transitions (mirror finish_orch) ------------------------------
# Write tada/<base> from a summary file and remove the record. Retries until it lands.
finish_gauntlet() {  # <base> <summary-file>
  local base="$1" summary="$2" attempt rc
  for attempt in $(seq 1 100); do
    sync_clone "$DIR"
    if [ ! -e "$DIR/$JOBS_GAUNTLET/$base.md" ] && tada_exists "$DIR" "$base"; then
      return 0   # already finished on a prior tick
    fi
    mkdir -p "$DIR/$JOBS_TADA"
    cp "$summary" "$DIR/$JOBS_TADA/$base.md"
    git -C "$DIR" add "$JOBS_TADA/$base.md"
    [ -e "$DIR/$JOBS_GAUNTLET/$base.md" ] && git -C "$DIR" rm -q "$JOBS_GAUNTLET/$base.md"
    rc=0; commit_and_push "$DIR" "gauntlet($base) finished → tada by $GARDEN" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0
    backoff "$attempt"
  done
  return 1
}

# Surface a halt to the maintainer inbox (best-effort; a notify failure must never
# wedge the tick). Body on stdin. Mirrors orchestrate.sh's orch_notify.
gauntlet_notify() {  # <subject> ; body on stdin
  local subject="$1"
  GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="gauntlet:${subject}" "$HERE/inbox-send.sh" maintainer >/dev/null 2>&1 || \
    log "gauntlet notify to maintainer failed (non-fatal): $subject"
}

finish_done() {  # <base> <reason>
  local base="$1" reason="$2" sf
  sf="$(mktemp "${TMPDIR:-/tmp}/gauntlet-done.XXXXXX")"
  {
    printf 'gauntlet-status: complete\n'
    printf '# gauntlet %s — complete\n\n' "$base"
    printf '%s\n' "$reason"
  } > "$sf"
  finish_gauntlet "$base" "$sf" || log "gauntlet '$base': done-finish failed; retrying next tick"
  log "gauntlet '$base': complete — $reason"
  rm -f "$sf"
}

halt_gauntlet() {  # <base> <reason>
  local base="$1" reason="$2" sf
  sf="$(mktemp "${TMPDIR:-/tmp}/gauntlet-halt.XXXXXX")"
  {
    # `orchestration-status: halted` makes tada_failed classify this as a failure —
    # the shared marker both deterministic serial primitives honor; `gauntlet-status`
    # is the human-legible twin.
    printf 'orchestration-status: halted\n'
    printf 'gauntlet-status: halted\n'
    printf '# gauntlet %s — HALTED\n\n' "$base"
    printf '%s\n' "$reason"
  } > "$sf"
  finish_gauntlet "$base" "$sf" || log "gauntlet '$base': halt-finish failed; retrying next tick"
  printf 'Gauntlet %s HALTED: %s\n' "$base" "$reason" | gauntlet_notify "$base-halted"
  log "gauntlet '$base': HALTED — $reason"
  rm -f "$sf"
}

# --- stage-job body composition ---------------------------------------------
# Each stage is a thin `role: gardener` job. The gardener does the substantive work
# with the existing project scripts (coverage / panel.sh / ci-wait-merge.sh /
# safe-push-pr-head.sh) and ENDS its completion report with the deterministic
# stage-result marker this driver greps. The driver itself runs NO `claude -p`.
compose_stage_body() {  # <base> <rec-file> <stage> <iter> <child>
  local base="$1" rec="$2" stage="$3" iter="$4" child="$5"
  local pr repo prnum kind
  pr="$(gauntlet_pr "$rec")"; repo="$(gauntlet_repo "$rec")"
  prnum="$(gauntlet_pr_number "$rec")"; kind="$(gauntlet_kind "$rec")"

  # CI-blocking stages carry the CI-sized handler budget; the panel stage carries its
  # own (longer-than-default) scripted-fan-out budget; only undraft takes the default.
  local timeout_line=""
  case "$stage" in
    clean|fix) timeout_line="handler-timeout: $GARDEN_GAUNTLET_STAGE_HANDLER_TIMEOUT";;
    panel)     timeout_line="handler-timeout: $GARDEN_GAUNTLET_PANEL_HANDLER_TIMEOUT";;
  esac

  printf -- '---\n'
  printf 'role: gardener\n'
  case "$stage" in
    clean|fix) printf 'handler-budget-role: shepherd\n' ;;
    panel)     printf 'handler-budget-role: panel\n' ;;
  esac
  [ -n "$timeout_line" ] && printf '%s\n' "$timeout_line"
  printf 'gauntlet: %s\n' "$base"
  printf 'gauntlet_stage: %s\n' "$stage"
  printf 'gauntlet_iteration: %s\n' "$iter"
  printf 'pr: %s\n' "$pr"
  printf -- '---\n\n'

  case "$stage" in
    clean)
      cat <<EOF
# Gauntlet stage: CLEAN — $repo PR #$prnum

You are ONE stage of a staged gauntlet ($base). Do ONLY the clean stage, then STOP.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's \`\$GARDEN_ROOT\` (known by \`scripts/jobs/common.sh\`), never against the
posting host's garden root.

1. Idempotence first. \`gh pr view $pr --json isDraft,state,statusCheckRollup\`. If the
   PR is already the right shape (coverage already pushed, CI GREEN at the current
   head), this stage is a NO-OP: skip to the marker with clean=done.
2. Get an ISOLATED project checkout of the PR head:
   \`scripts/jobs/ensure-project-worktree.sh $child <pr-head-owner>/<repo-name> <pr-head-branch>\`.
   Resolve the head owner and branch with \`gh pr view $pr --json headRepositoryOwner,headRefName\`;
   do not pass the base repo when the PR head belongs to a fork.
3. In that checkout: run the coverage pass on the touched packages
   (skills/coverage-driven-testing) and remove any dead code the change orphaned.
4. If you changed anything, push follow-ups to the PR head with
   \`scripts/jobs/gardening/safe-push-pr-head.sh\`.
5. Watch CI to a terminal state, BOUNDED so this handler is never killed mid-wait:
   \`GARDEN_CI_DEADLINE_SECS=$GARDEN_GAUNTLET_CI_DEADLINE_SECS \\
     scripts/jobs/gardening/ci-wait-merge.sh $repo $prnum --no-merge\`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING at the deadline): CI is not terminal — report still-pending
     so the driver re-posts this stage on a fresh budget (do NOT emit clean=done).
   - rc 3 (RED): this stage FAILS. Begin your report with a line
     \`orchestration-failed: true\` and describe the failing checks; do NOT emit any
     clean=done marker (the driver halts the gauntlet and surfaces it).

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: clean=done -->            (coverage clean, CI green)
  <!-- gauntlet-stage-result: clean=still-pending -->   (CI still pending at deadline)
EOF
      ;;
    panel)
      cat <<EOF
# Gauntlet stage: PANEL round $iter — $repo PR #$prnum

You are ONE stage of a staged gauntlet ($base). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's \`\$GARDEN_ROOT\` (known by \`scripts/jobs/common.sh\`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   \`scripts/jobs/ensure-project-worktree.sh $child <pr-head-owner>/<repo-name> <pr-head-branch>\`.
   Resolve the head owner and branch with \`gh pr view $pr --json headRepositoryOwner,headRefName\`;
   do not pass the base repo when the PR head belongs to a fork.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   \`GARDEN_PANEL_SINGLE_ROUND=1 \\
     scripts/jobs/gardening/panel.sh <worktree> $prnum <base-ref>\`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: \`pass\` or \`must-fix\`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in \$GARDEN_PANEL_RUNDIR) as a \`gh pr review\` on $pr — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with \`orchestration-failed: true\` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->
EOF
      ;;
    fix)
      cat <<EOF
# Gauntlet stage: FIX round $iter — $repo PR #$prnum

You are ONE stage of a staged gauntlet ($base). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-$((iter+1))).

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's \`\$GARDEN_ROOT\` (known by \`scripts/jobs/common.sh\`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   \`scripts/jobs/ensure-project-worktree.sh $child <pr-head-owner>/<repo-name> <pr-head-branch>\`.
   Resolve the head owner and branch with \`gh pr view $pr --json headRepositoryOwner,headRefName\`;
   do not pass the base repo when the PR head belongs to a fork.
2. Read the LATEST panel verdict on $pr (the request-changes \`gh pr review\` the
   panel-$iter stage just posted) for its must-fix items. Apply them.
3. Push the fix as review-feedback follow-up commits to the PR head with
   \`scripts/jobs/gardening/safe-push-pr-head.sh\`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   \`GARDEN_CI_DEADLINE_SECS=$GARDEN_GAUNTLET_CI_DEADLINE_SECS \\
     scripts/jobs/gardening/ci-wait-merge.sh $repo $prnum --no-merge\`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
   - rc 3 (RED): begin your report with \`orchestration-failed: true\`; no fix=done.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
  <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)
EOF
      ;;
    undraft)
      cat <<EOF
# Gauntlet stage: UNDRAFT — $repo PR #$prnum

You are the FINAL stage of a staged gauntlet ($base). The panel passed. Un-draft the PR.

1. Idempotence: \`gh pr view $pr --json isDraft,state\`. If the PR is already ready
   (not draft) or not OPEN, this stage is a NO-OP: skip to the marker.
2. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   \`claude -p\` review for anything the panel systematically missed; record it, do not
   gate on it.
3. \`gh pr ready $pr\` to un-draft (kind=$kind — a probe never reaches this stage).

END your completion report with EXACTLY this marker line (last line):
  <!-- gauntlet-stage-result: undraft=done -->
EOF
      ;;
  esac
}

# --- posting a stage --------------------------------------------------------
# Normal (first-time) post: post-job.sh is idempotent by basename, so a re-post of a
# stage already on the board is a clean no-op.
post_stage() {  # <child> <body-file>
  "$HERE/post-job.sh" "$1" "$2" >/dev/null 2>&1
}

# Re-post the SAME stage after a still-pending report: ATOMICALLY swap the child's
# tada report for a fresh todo entry in ONE commit, so the base is continuously
# occupied (tada→todo) and child_state never briefly reads it as failed. The stable
# base means a re-posted stage resumes its own --resume session.
repost_stage() {  # <child> <body-file>
  local child="$1" body="$2" attempt rc tada_path
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    [ -e "$DIR/$JOBS_TODO/$child.md" ] && return 0   # already re-posted on a prior tick
    mkdir -p "$DIR/$JOBS_TODO"
    cp "$body" "$DIR/$JOBS_TODO/$child.md"
    git -C "$DIR" add "$JOBS_TODO/$child.md"
    tada_path="$(tada_find "$DIR" "$child" || true)"
    [ -z "$tada_path" ] || git -C "$DIR" rm -q "$tada_path"
    rc=0; commit_and_push "$DIR" "gauntlet re-post stage $child (CI still pending) by $GARDEN" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0
    backoff "$attempt"
  done
  return 1
}

# advance to a NEW stage: compose+post the child, then (only on a successful post)
# update the record. Post BEFORE the record write so a crash between them re-observes
# the old current_child next tick and recomputes — never a current_child pointing at a
# not-yet-posted (→ "failed") stage.
advance_stage() {  # <base> <rec-file> <newstage> <newiter> <child>
  local base="$1" rec="$2" nstage="$3" niter="$4" child="$5" body
  body="$(mktemp "${TMPDIR:-/tmp}/gauntlet-stage.XXXXXX")"
  compose_stage_body "$base" "$rec" "$nstage" "$niter" "$child" > "$body"
  if post_stage "$child" "$body"; then
    # resumes is reset here because the re-post bound is PER STAGE: a clean stage that
    # spent five waits must not shorten the fix stage's own budget.
    if set_gauntlet_fields "$base" "stage=$nstage" "iteration=$niter" "current_child=$child" "state=running" "resumes=0"; then
      log "gauntlet '$base': advanced to $nstage (child $child)"
    else
      log "gauntlet '$base': posted $child but record update failed; retrying next tick"
    fi
  else
    log "gauntlet '$base': could not post stage $child; retrying next tick"
  fi
  rm -f "$body"
}

# re-post the same stage (still-pending): compose a fresh body and atomically swap.
#
# BOUNDED. `still-pending` is the one non-terminal stage result, and re-posting on it
# used to be unconditional — so a PR whose CI never reaches a terminal state re-posted
# the SAME stage forever, burning a whole GARDEN_GAUNTLET_CI_DEADLINE_SECS wait and one
# gardener claim per round, silently, with no bound and no notice. The reachable case is
# not a hung check but a CHECKLESS repo: ci-wait-merge treats an empty rollup as
# not-green (correctly — right after a push the rollup is [] for ~a minute), so a repo
# whose only workflow is push-triggered attaches NO check to a PR head, times out at
# every deadline, and reports still-pending every single round. kriscendobot/minion.town
# is exactly that shape (one `on: push: branches: [main]` deploy workflow, zero check
# runs on a PR head). Spending the bound turns the silent forever-loop into the same
# loud halt every other non-convergence takes, naming ci-wait-merge's own opt-out.
resume_stage() {  # <base> <rec-file> <stage> <iter> <child> <resumes> <max-resumes>
  local base="$1" rec="$2" stage="$3" iter="$4" child="$5" resumes="$6" maxres="$7" body next
  next=$((resumes + 1))
  if [ "$next" -gt "$maxres" ]; then
    halt_gauntlet "$base" "stage '$child' ($stage) reported CI still-pending $resumes time(s) and has spent its re-post bound (max_resumes=$maxres). CI never reached a terminal state — most likely $(gauntlet_repo "$rec") attaches NO checks to a PR head (a push-only workflow set), which ci-wait-merge reports as a timeout rather than green. Re-run the stage with GARDEN_CI_ALLOW_NO_CHECKS=1 if the repo is genuinely checkless, or fix the CI trigger."
    return 0
  fi
  body="$(mktemp "${TMPDIR:-/tmp}/gauntlet-stage.XXXXXX")"
  compose_stage_body "$base" "$rec" "$stage" "$iter" "$child" > "$body"
  if repost_stage "$child" "$body"; then
    set_gauntlet_fields "$base" "resumes=$next" \
      || log "gauntlet '$base': re-posted $child but the resume-count update failed; retrying next tick"
    log "gauntlet '$base': CI still pending — re-posted stage $child (fresh budget; resume $next/$maxres)"
  else
    log "gauntlet '$base': could not re-post stage $child; retrying next tick"
  fi
  rm -f "$body"
}

# --- the tick ---------------------------------------------------------------
advanced=0
for j in $(list_jobs "$DIR" "$JOBS_GAUNTLET"); do
  case "$j" in *.md) ;; *) continue;; esac
  f="$DIR/$JOBS_GAUNTLET/$j"; [ -f "$f" ] || continue
  base="${j%.md}"

  state="$(gauntlet_state "$f")"
  case "$state" in done|halted) continue;; esac   # terminal record — leave it

  kind="$(gauntlet_kind "$f")"
  stage="$(gauntlet_stage "$f")"
  iter="$(gauntlet_iteration "$f")"
  maxit="$(gauntlet_max_iterations "$f")"
  resumes="$(gauntlet_resumes "$f")"
  maxres="$(gauntlet_max_resumes "$f")"
  child="$(gauntlet_current_child "$f")"
  repo="$(gauntlet_repo "$f")"
  prnum="$(gauntlet_pr_number "$f")"

  if [ -z "$repo" ] || [ -z "$prnum" ]; then
    log "gauntlet '$base' is malformed (missing repo/pr_number); leaving untouched"
    continue
  fi

  # Fresh record (no stage in flight): post the first stage (clean).
  if [ -z "$child" ]; then
    advance_stage "$base" "$f" clean 0 "$base-clean"
    advanced=$((advanced+1))
    continue
  fi

  st="$(child_state "$child")"
  case "$st" in
    active)
      log "gauntlet '$base': waiting on stage '$child' ($stage, in flight)"
      continue;;
    failed)
      halt_gauntlet "$base" "stage '$child' ($stage) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling."
      advanced=$((advanced+1))
      continue;;
    done) ;;   # fall through to the transition table
  esac

  # The completed child's stage-result marker drives the transition. `read` returns
  # non-zero on the empty (no-marker) stream; `|| true` keeps that from tripping
  # set -e (which would abort the whole tick and strand every later record) — the
  # empty-marker case is handled explicitly just below.
  mstage=""; mresult=""
  child_tada_path="$(tada_find "$DIR" "$child" || true)"
  read -r mstage mresult < <(parse_stage_result "$DIR/$child_tada_path") || true
  if [ -z "${mstage:-}" ]; then
    halt_gauntlet "$base" "stage '$child' ($stage) completed with NO parseable gauntlet-stage-result marker — fail-closed, never a guess."
    advanced=$((advanced+1)); continue
  fi
  if [ "$mstage" != "$stage" ]; then
    halt_gauntlet "$base" "stage '$child' reported marker stage '$mstage' but the record is at stage '$stage' — inconsistent; halting fail-closed."
    advanced=$((advanced+1)); continue
  fi

  case "$stage" in
    clean)
      case "$mresult" in
        done)          advance_stage "$base" "$f" panel 1 "$base-panel-1";;
        still-pending) resume_stage "$base" "$f" clean 0 "$child" "$resumes" "$maxres";;
        *)             halt_gauntlet "$base" "clean stage reported unexpected result '$mresult'";;
      esac;;
    panel)
      case "$mresult" in
        pass)
          if [ "$kind" = probe ]; then
            finish_done "$base" "panel round $iter passed; kind=probe, so the PR stays DRAFT by design (never un-drafted)."
          else
            advance_stage "$base" "$f" undraft "$iter" "$base-undraft"
          fi;;
        must-fix)      advance_stage "$base" "$f" fix "$iter" "$base-fix-$iter";;
        *)             halt_gauntlet "$base" "panel stage reported unexpected result '$mresult'";;
      esac;;
    fix)
      case "$mresult" in
        done)
          local_next=$((iter+1))
          if [ "$local_next" -gt "$maxit" ]; then
            halt_gauntlet "$base" "the panel/fix loop did not converge in $maxit rounds (fix round $iter done, would start panel round $local_next > max_iterations=$maxit)."
          else
            advance_stage "$base" "$f" panel "$local_next" "$base-panel-$local_next"
          fi;;
        still-pending) resume_stage "$base" "$f" fix "$iter" "$child" "$resumes" "$maxres";;
        *)             halt_gauntlet "$base" "fix stage reported unexpected result '$mresult'";;
      esac;;
    undraft)
      case "$mresult" in
        done) finish_done "$base" "un-drafted after a clean panel — the staged gauntlet is complete.";;
        *)    halt_gauntlet "$base" "undraft stage reported unexpected result '$mresult'";;
      esac;;
    *)
      halt_gauntlet "$base" "record is at unknown stage '$stage'";;
  esac
  advanced=$((advanced+1))
done

[ "$advanced" -gt 0 ] && log "advanced $advanced gauntlet(s)"
exit 0
