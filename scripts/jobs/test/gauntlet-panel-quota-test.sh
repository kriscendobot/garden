#!/bin/bash
# gauntlet-panel-quota-test.sh — validate the gauntlet driver's PANEL-PROVIDER
# quota/admission pre-gate (gauntlet.sh: panel_provider_admits + the advance/retry
# guards). The panel stage fans juror seats that all authenticate to one provider
# (Anthropic — panel.sh shells `claude -p` per seat), so posting a panel round while
# that provider's weekly quota is exhausted spends a whole panel attempt that aborts
# at a seat with NO verdict. The driver must DEFER the panel stage — leaving the
# record at its current stage to re-attempt each tick — until quota is usable, and
# post it automatically once it recovers.
#
# Subtests (hermetic; no systemd, no network, no `claude -p` — a bare journal, a
# seeded config/budget-pools, and fake Claude session logs that drive meter spend):
#   1. DEFER      — clean=done with the anthropic pool at weekly-quota backoff posts
#                    NO panel-1; the record stays at stage=clean; a coalesced INFO
#                    reaches the maintainer inbox.
#   2. RE-DEFER   — a second tick still at backoff still posts no panel (idempotent
#                    defer, record unchanged).
#   3. RECOVER    — once spend drops under the mark, the SAME record advances to
#                    panel-1 with no manual intervention.
#   4. NON-PANEL  — viability and clean posted NORMALLY while the panel gate would
#                    defer (the guard is panel-only), proven by reaching clean=done.
#
# Usage: gauntlet-panel-quota-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient garden env so a live gardener running this test cannot splice the
# real journal/root underneath the hermetic fixture.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-gauntlet-panel-quota-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

# A pool at high water: cap 1000. Fake Claude session logs supply the spend.
POOLROW='anthropic:testhost anthropic testhost weekly-tokens 1000'
# meter_window_total prunes session files by mtime >= the week anchor, so the files
# (written now) are always in-window relative to this historical NOW; the JSON
# `timestamp` (>= the Fri-20:00-Pacific anchor for this NOW) is what gets summed.
NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"
LOGTS='2026-08-22T06:00:00Z'
make_logs() {  # make_logs <dir> <tokens>
  rm -rf "$1"; mkdir -p "$1/p"
  printf '{"type":"assistant","timestamp":"%s","message":{"id":"s","usage":{"input_tokens":%s,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}\n' \
    "$LOGTS" "$2" > "$1/p/session.jsonl"
}
LOGS_OK="$TR/logs-ok"   ; make_logs "$LOGS_OK" 10    # 10/1000  = 0.01 → ok
LOGS_HI="$TR/logs-hi"   ; make_logs "$LOGS_HI" 900   # 900/1000 = 0.90 → backoff (>=0.85)

# --- seed origin ------------------------------------------------------------
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read config
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done
  printf '%s\n' "$POOLROW" > config/budget-pools )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board + budget-pools"
git -C "$SEED" remote add origin "$BARE"
git init -q --bare "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_ASSERT_PINNED_BASE=/bin/true     # fixture PRs are not on GitHub
export GARDEN_POST_ATTEMPTS=50
export GARDEN_CLAIM_TTL=14400 GARDEN_HANDLER_KILL_AFTER=60
export GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200

# --- board inspection (fresh clone each call) -------------------------------
V="$TR/verify"
board() {  # board <subdir> → basenames present
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  # shellcheck disable=SC2010
  ls -1 "$V/$1" 2>/dev/null | grep -v -x '.gitkeep' | sed 's/\.md$//' | sort | tr '\n' ' '
}
in_dir() { board "$1" | tr ' ' '\n' | grep -qx "$2"; }
record_field() {  # record_field <g> <key>
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  sed -n "s/^$2:[[:space:]]*//p" "$V/jobs/gauntlet/$1.md" 2>/dev/null | head -1
}
maintainer_inbox_has() {  # maintainer_inbox_has <grep-re>
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  grep -rqi "$1" "$V/inbox/maintainer/unread/" 2>/dev/null
}

complete_stage() {  # complete_stage <base> <marker-body>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  { printf '# %s complete\n\nstage work done.\n\n' "$1"
    printf '<!-- gauntlet-stage-result: %s -->\n' "$2"; } > "$wt/jobs/tada/$1.md"
  git -C "$wt" add "jobs/tada/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "tada($1) $2"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

# A tick with a chosen quota posture (session-log dir drives meter spend).
tick() {  # tick <logdir>
  GARDEN_CCUSAGE_LOGDIR="$1" GARDEN_USAGE_NOW="$NOW" \
    "$JOBS/gauntlet.sh" >"$TR/tick.log" 2>&1 \
    || { echo "  (gauntlet.sh rc=$? — see below)"; cat "$TR/tick.log"; }
}

post_gauntlet() { "$JOBS/post-gauntlet.sh" "$@" >/dev/null; }

# ============================================================================
hr; echo "Drive g1 through viability → clean under NORMAL quota (panel-only gate)"; hr
post_gauntlet g1 https://github.com/testowner/testrepo/pull/1

tick "$LOGS_OK"   # fresh record → viability
{ in_dir jobs/todo g1-viability && [ "$(record_field g1 stage)" = viability ]; } \
  && ok "viability stage posted under ok quota" \
  || bad "viability not posted: todo=[$(board jobs/todo)] stage=$(record_field g1 stage)"

complete_stage g1-viability viability=proceed
tick "$LOGS_OK"   # viability=proceed → clean
{ in_dir jobs/todo g1-clean && [ "$(record_field g1 stage)" = clean ]; } \
  && ok "SUBTEST 4 NON-PANEL: clean stage posted normally while a panel would defer" \
  || bad "clean not posted: todo=[$(board jobs/todo)] stage=$(record_field g1 stage)"

complete_stage g1-clean clean=done

# ============================================================================
hr; echo "SUBTEST 1 — DEFER: clean=done at panel-provider backoff posts NO panel"; hr
tick "$LOGS_HI"   # clean=done, but anthropic pool at backoff → defer the panel
{ ! in_dir jobs/todo g1-panel-1 && [ "$(record_field g1 stage)" = clean ] \
    && [ "$(record_field g1 current_child)" = g1-clean ]; } \
  && ok "panel deferred: no g1-panel-1 posted, record held at stage=clean" \
  || bad "expected no panel + stage=clean; todo=[$(board jobs/todo)] stage=$(record_field g1 stage) child=$(record_field g1 current_child)"
maintainer_inbox_has 'DEFERRING' \
  && ok "a coalesced INFO defer notice reached the maintainer inbox" \
  || bad "no defer notice in the maintainer inbox"
# The clean tada that drives the transition must survive (not consumed by the defer).
in_dir jobs/tada g1-clean \
  && ok "the clean tada survives the defer (re-drives the transition next tick)" \
  || bad "clean tada was consumed while deferring"

# ============================================================================
hr; echo "SUBTEST 2 — RE-DEFER: a second backoff tick still posts no panel"; hr
tick "$LOGS_HI"
{ ! in_dir jobs/todo g1-panel-1 && [ "$(record_field g1 stage)" = clean ]; } \
  && ok "still deferred on the second backoff tick (idempotent, record unchanged)" \
  || bad "second defer tick changed state: todo=[$(board jobs/todo)] stage=$(record_field g1 stage)"

# ============================================================================
hr; echo "SUBTEST 3 — RECOVER: spend drops under the mark → panel posts automatically"; hr
tick "$LOGS_OK"   # quota usable again → the held clean=done transition fires
{ in_dir jobs/todo g1-panel-1 && [ "$(record_field g1 stage)" = panel ] \
    && [ "$(record_field g1 iteration)" = 1 ]; } \
  && ok "panel-1 posted automatically once the provider admitted (no manual step)" \
  || bad "panel not posted after recovery: todo=[$(board jobs/todo)] stage=$(record_field g1 stage) iter=$(record_field g1 iteration)"

# ============================================================================
hr
echo "gauntlet-panel-quota: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
