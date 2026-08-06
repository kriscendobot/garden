#!/bin/bash
# approval-reconciler-test.sh — validate the periodic APPROVAL reconciler on
# throwaway fixtures, with no GitHub. The open-PR SOURCE, the maintainer-approval
# GATE, and the mergeable/green PROBE are stubbed deterministically; the bot-author
# gate, the head-pushable gate, the is-bot-repo gate, the approval→conductor and
# approved-but-not-green→shepherd mappings, the deterministic basenames, the
# board/content dedup, and the leader gate all run for real against a throwaway
# journal.
#
# Asserts (the job brief's required cases):
#   A. MISSED EVENT — a bot PR with a current maintainer approval on head that is
#      mergeable+green → exactly one <slug>-pr<N>-conduct job (no maintainer comment)
#   B. STALE APPROVAL after head movement — approval handler returns nonzero (its
#      commit_id != head) → no job
#   C. EVENT/SWEEP RACE — a <slug>-pr<N>-conduct already live on the board →
#      idempotent (still exactly one conductor, no duplicate)
#   D. MANUAL JOB, DIFFERENT BASENAME — a hand-named conductor job that references
#      the PR URL (role: conductor) → the sweep dedups against it (no duplicate)
#   E. RED CI — approved but pr-mergeable rc 1 (not green) → exactly one
#      <slug>-pr<N>-shepherd (the finalize→shepherd degrade), NOT a conductor
#   F. DRAFT PR — pr-mergeable rc 0 (draft is not a blocker; the conductor un-drafts)
#      → conductor posted
#   G. UNTRUSTED APPROVER — approval handler nonzero → no job
#   H. NON-BOT PR — author != bot → no job (author gate)
#   I. MERGED/CLOSED — approved but pr-mergeable rc 2 → no job
#   J. SHEPHERD DEDUP — approved-not-green while a shepherd is already live → no dup
#   K. FOLLOWER — GARDEN_LEADER_DEFAULT=follower → the whole tick is skipped, no job
#      for an otherwise-eligible PR (leader-only singleton); the SAME fixture on a
#      leader posts, proving the gate is what suppressed it
#   L. NON-BOT REPO SLUG — the reconciler exits at the is-bot-repo gate, no job
#   M. TRANSIENT POST FAILURE — captured/classified, then retried in the same tick
#   N. UNCERTAIN POST OUTCOME — nonzero post that actually landed is recognized by
#      a fresh confirmation and is not posted again
#   O. PERSISTENT POST FAILURE — bounded attempts, actionable diagnostics retained,
#      then explicit deferral to the next tick
#
# Usage: approval-reconciler-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-ar-test
SLUG=endojs-endo-but-for-bots
REPO=endojs/endo-but-for-bots
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet GARDEN_*/JOURNAL_* so a live gardener running this test cannot
# splice the real journal under the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|CI_|AR_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/orch jobs/gauntlet work comment-repos maintainers
    for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/orch jobs/gauntlet work comment-repos; do touch "$d/.gitkeep"; done
    printf 'kriskowal\n' > maintainers/allowlist )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

# Seed an arbitrary job file directly onto the board (for the pre-existing-job cases).
seed_job() {  # seed_job <bare> <lane> <base> <body>
  local bare="$1" lane="$2" base="$3" body="$4" s; s="$(mktemp -d "$TR/sj.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$bare" "$s" 2>/dev/null
  mkdir -p "$s/jobs/$lane"; printf '%s\n' "$body" > "$s/jobs/$lane/$base.md"
  git -C "$s" add -A; git -C "$s" "${git_id[@]}" commit -q -m "seed $lane/$base"
  git -C "$s" push -q origin "$BRANCH"; rm -rf "$s"
}

board_has() {  # board_has <bare> <base>  -> 0 if job present in todo/doin/tada/plan
  local v rc=1 s; v="$(mktemp -d "$TR/bv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  for s in todo doin tada plan; do [ -e "$v/jobs/$s/$2.md" ] && rc=0; done
  rm -rf "$v"; return $rc
}
lane_count() {  # lane_count <bare> <lane> <glob>  -> count of matching non-gitkeep entries
  local v n; v="$(mktemp -d "$TR/lc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/$2" 2>/dev/null | grep -vx '.gitkeep' | grep -cE "$3" || true)
  rm -rf "$v"; printf '%s' "$n"
}

# --- deterministic stubs ----------------------------------------------------
SRCSTUB="$TR/pr-source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
cat "${AR_FIXTURE:?set AR_FIXTURE}"
EOF
chmod +x "$SRCSTUB"

# approval gate stub: PR -> exit via AR_APPROVAL_MAP="885=0 884=1"; default 1 (none).
APPRSTUB="$TR/approval-stub.sh"
cat > "$APPRSTUB" <<'EOF'
#!/bin/bash
pr="$2"
for kv in $AR_APPROVAL_MAP; do [ "${kv%%=*}" = "$pr" ] && exit "${kv##*=}"; done
exit 1
EOF
chmod +x "$APPRSTUB"

# mergeable probe stub: PR -> exit via AR_MERGE_MAP="885=0 836=1 721=2"; default 1.
MERGESTUB="$TR/mergeable-stub.sh"
cat > "$MERGESTUB" <<'EOF'
#!/bin/bash
pr="$2"
for kv in $AR_MERGE_MAP; do [ "${kv%%=*}" = "$pr" ] && exit "${kv##*=}"; done
exit 1
EOF
chmod +x "$MERGESTUB"

FRESH_TS="$(date -u -d '-1 hour'  +%Y-%m-%dT%H:%M:%SZ)"
RUN_AR_LOG=/dev/null
# fixture line: number \t author \t head_repo \t updated_at \t title
prline() { printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "${4:-$FRESH_TS}" "${5:-a PR}"; }

run_ar() {  # run_ar <state> <bare> <fixture> <approval-map> <merge-map> [slug] [KEY=VAL ...]
  local state="$1" bare="$2" fix="$3" amap="$4" mmap="$5" slug="${6:-$SLUG}"; shift 6 || shift $#
  env GARDEN_STATE="$state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN=testleader GARDEN_LEADER_DEFAULT=leader GARDEN_BOT_LOGIN=kriscendobot \
      GARDEN_AR_PR_SOURCE="$SRCSTUB" AR_FIXTURE="$fix" \
      GARDEN_AR_APPROVAL="$APPRSTUB" AR_APPROVAL_MAP="$amap" \
      GARDEN_AR_MERGEABLE="$MERGESTUB" AR_MERGE_MAP="$mmap" \
      GARDEN_AR_POST="$JOBS/post-job.sh" GARDEN_AR_ACTIVITY_WINDOW='' "$@" \
      "$JOBS/approval-reconciler.sh" "$slug" >"$RUN_AR_LOG" 2>&1
}

BOThead="kriscendobot/endo-but-for-bots"

# ============================================================================
hr; echo "A. MISSED EVENT — approved+green bot PR → one conductor"; hr
BARE="$TR/a.git"; seed_bare "$BARE"
FIX="$TR/a.tsv"; prline 885 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/sa" "$BARE" "$FIX" "885=0" "885=0"
if board_has "$BARE" "$SLUG-pr885-conduct" && [ "$(lane_count "$BARE" todo "conduct")" = 1 ]; then
  ok "conductor posted exactly once for the missed approval"
else bad "expected exactly one $SLUG-pr885-conduct"; fi

# ============================================================================
hr; echo "B. STALE APPROVAL after head movement — approval gate nonzero → no job"; hr
BARE="$TR/b.git"; seed_bare "$BARE"
FIX="$TR/b.tsv"; prline 885 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/sb" "$BARE" "$FIX" "885=1" "885=0"   # approval nonzero (stale/no current head)
if ! board_has "$BARE" "$SLUG-pr885-conduct"; then
  ok "no conductor when the approval is not on the current head"
else bad "stale approval should not dispatch a conductor"; fi

# ============================================================================
hr; echo "C. EVENT/SWEEP RACE — a conductor already live → no duplicate"; hr
BARE="$TR/c.git"; seed_bare "$BARE"
seed_job "$BARE" todo "$SLUG-pr885-conduct" "$(printf -- '---\nrole: conductor\n---\n# already posted by the event watcher\nPR: https://github.com/%s/pull/885\n' "$REPO")"
FIX="$TR/c.tsv"; prline 885 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/sc" "$BARE" "$FIX" "885=0" "885=0"
if [ "$(lane_count "$BARE" todo "conduct")" = 1 ]; then
  ok "the existing conductor was not duplicated (event/sweep race)"
else bad "expected exactly one conductor after the race"; fi

# ============================================================================
hr; echo "D. MANUAL JOB, DIFFERENT BASENAME — content dedup"; hr
BARE="$TR/d.git"; seed_bare "$BARE"
seed_job "$BARE" doin "conduct-ebfb-885-manual" "$(printf -- '---\nrole: conductor\n---\n# hand-named manual conductor kriskowal posted\nMerge https://github.com/%s/pull/885\n' "$REPO")"
FIX="$TR/d.tsv"; prline 885 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/sd" "$BARE" "$FIX" "885=0" "885=0"
if ! board_has "$BARE" "$SLUG-pr885-conduct"; then
  ok "the differently-named manual conductor suppressed the duplicate"
else bad "content dedup failed — a duplicate conductor was posted"; fi

# ============================================================================
hr; echo "E. RED CI — approved but not green → shepherd, not conductor"; hr
BARE="$TR/e.git"; seed_bare "$BARE"
FIX="$TR/e.tsv"; prline 836 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/se" "$BARE" "$FIX" "836=0" "836=1"   # approved, mergeable rc1 (not green)
if board_has "$BARE" "$SLUG-pr836-shepherd" && ! board_has "$BARE" "$SLUG-pr836-conduct"; then
  ok "approved-but-not-green dispatched a shepherd, never a conductor"
else bad "expected a shepherd (no conductor) for the approved red PR"; fi

# ============================================================================
hr; echo "F. DRAFT PR — mergeable+green+approved (draft not a blocker) → conductor"; hr
# The mergeable probe returns 0 for a green/mergeable/approved DRAFT (the conductor
# un-drafts), so at this layer a draft is indistinguishable from a ready PR — which
# is the intended reuse-the-event-semantics behavior.
BARE="$TR/f.git"; seed_bare "$BARE"
FIX="$TR/f.tsv"; prline 880 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/sf" "$BARE" "$FIX" "880=0" "880=0"
if board_has "$BARE" "$SLUG-pr880-conduct"; then
  ok "a green/mergeable/approved draft is finalized (conductor un-drafts)"
else bad "expected a conductor for the ready draft"; fi

# ============================================================================
hr; echo "G. UNTRUSTED APPROVER — approval gate nonzero → no job"; hr
BARE="$TR/g.git"; seed_bare "$BARE"
FIX="$TR/g.tsv"; prline 870 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/sg" "$BARE" "$FIX" "870=1" "870=0"   # approval gate rejects untrusted approver
if ! board_has "$BARE" "$SLUG-pr870-conduct"; then
  ok "an untrusted approver dispatches nothing"
else bad "untrusted approver must not dispatch a conductor"; fi

# ============================================================================
hr; echo "H. NON-BOT PR — author gate → no job"; hr
BARE="$TR/h.git"; seed_bare "$BARE"
FIX="$TR/h.tsv"; prline 340 someoneelse "someoneelse/endo-but-for-bots" > "$FIX"
run_ar "$TR/sh" "$BARE" "$FIX" "340=0" "340=0"
if [ "$(lane_count "$BARE" todo "conduct")" = 0 ]; then
  ok "a non-bot-authored PR is excluded from automatic dispatch"
else bad "non-bot PR should never mint a conductor"; fi

# ============================================================================
hr; echo "I. MERGED/CLOSED — probe rc 2 → no job"; hr
BARE="$TR/i.git"; seed_bare "$BARE"
FIX="$TR/i.tsv"; prline 721 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/si" "$BARE" "$FIX" "721=0" "721=2"   # approved but already merged/closed
if [ "$(lane_count "$BARE" todo "conduct|shepherd")" = 0 ]; then
  ok "an already-merged/closed PR mints nothing"
else bad "merged/closed PR should mint nothing"; fi

# ============================================================================
hr; echo "J. SHEPHERD DEDUP — approved-not-green with a live shepherd → no dup"; hr
BARE="$TR/j.git"; seed_bare "$BARE"
seed_job "$BARE" doin "$SLUG-pr836-shepherd" "$(printf -- '---\nrole: shepherd\n---\n# already shepherding\nPR: https://github.com/%s/pull/836\n' "$REPO")"
FIX="$TR/j.tsv"; prline 836 kriscendobot "$BOThead" > "$FIX"
run_ar "$TR/sj" "$BARE" "$FIX" "836=0" "836=1"
if [ "$(lane_count "$BARE" doin "shepherd")" = 1 ] && ! board_has "$BARE" "$SLUG-pr836-conduct"; then
  ok "the live shepherd was not duplicated and no conductor was minted"
else bad "expected exactly one shepherd, no conductor"; fi

# ============================================================================
hr; echo "K. FOLLOWER — leader-only gate suppresses the tick"; hr
BARE="$TR/k.git"; seed_bare "$BARE"
FIX="$TR/k.tsv"; prline 885 kriscendobot "$BOThead" > "$FIX"
# Follower: GARDEN_LEADER_DEFAULT=follower with no leader marker → is_main_host false.
env GARDEN_STATE="$TR/sk" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN=testfollower GARDEN_LEADER_DEFAULT=follower GARDEN_BOT_LOGIN=kriscendobot \
    GARDEN_AR_PR_SOURCE="$SRCSTUB" AR_FIXTURE="$FIX" \
    GARDEN_AR_APPROVAL="$APPRSTUB" AR_APPROVAL_MAP="885=0" \
    GARDEN_AR_MERGEABLE="$MERGESTUB" AR_MERGE_MAP="885=0" \
    GARDEN_AR_POST="$JOBS/post-job.sh" GARDEN_AR_ACTIVITY_WINDOW='' \
    "$JOBS/approval-reconciler.sh" "$SLUG" >/dev/null 2>&1
follower_ok=1; board_has "$BARE" "$SLUG-pr885-conduct" && follower_ok=0
# Same fixture on a leader DOES post — proving the gate is what suppressed it.
run_ar "$TR/sk2" "$BARE" "$FIX" "885=0" "885=0"
if [ "$follower_ok" = 1 ] && board_has "$BARE" "$SLUG-pr885-conduct"; then
  ok "a follower skips the whole tick; the same fixture posts on the leader"
else bad "leader/follower gating incorrect"; fi

# ============================================================================
hr; echo "L. NON-BOT REPO SLUG — is-bot-repo gate, no job"; hr
BARE="$TR/l.git"; seed_bare "$BARE"
FIX="$TR/l.tsv"; prline 1 kriscendobot "kriscendobot/agoric-sdk" > "$FIX"
run_ar "$TR/sl" "$BARE" "$FIX" "1=0" "1=0" "agoric-agoric-sdk"
if [ "$(lane_count "$BARE" todo "conduct|shepherd")" = 0 ]; then
  ok "an out-of-scope upstream repo mints nothing (never touch agoric-sdk)"
else bad "the is-bot-repo gate must exclude agoric-sdk"; fi

# ============================================================================
hr; echo "M. TRANSIENT POST FAILURE — classify + recover within this tick"; hr
BARE="$TR/m.git"; seed_bare "$BARE"
FIX="$TR/m.tsv"; prline 901 kriscendobot "$BOThead" > "$FIX"
RETRYSTUB="$TR/post-retry-stub.sh"; RETRYCOUNT="$TR/post-retry.count"
cat > "$RETRYSTUB" <<'EOF'
#!/bin/bash
n=0; [ ! -f "$AR_POST_COUNT" ] || n="$(cat "$AR_POST_COUNT")"
n=$((n+1)); printf '%s\n' "$n" > "$AR_POST_COUNT"
if [ "$n" -eq 1 ]; then
  echo "could not post: journal push race" >&2
  exit 1
fi
exec "$REAL_POST" "$@"
EOF
chmod +x "$RETRYSTUB"
MLOG="$TR/m.log"
RUN_AR_LOG="$MLOG"
run_ar "$TR/sm" "$BARE" "$FIX" "901=0" "901=0" "$SLUG" \
  GARDEN_AR_POST="$RETRYSTUB" AR_POST_COUNT="$RETRYCOUNT" REAL_POST="$JOBS/post-job.sh" \
  GARDEN_AR_POST_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=0 GARDEN_BACKOFF_CAP_MS=0
RUN_AR_LOG=/dev/null
if board_has "$BARE" "$SLUG-pr901-conduct" \
   && [ "$(cat "$RETRYCOUNT")" = 2 ] \
   && grep -q 'class=journal-contention.*retrying after backoff' "$MLOG"; then
  ok "a journal-race failure is diagnosed and recovered before the next tick"
else bad "transient post failure was not classified/retried/confirmed"; fi

# ============================================================================
hr; echo "N. UNCERTAIN POST OUTCOME — fresh confirmation wins over nonzero rc"; hr
BARE="$TR/n.git"; seed_bare "$BARE"
FIX="$TR/n.tsv"; prline 902 kriscendobot "$BOThead" > "$FIX"
UNCERTAINSTUB="$TR/post-uncertain-stub.sh"; UNCERTAINCOUNT="$TR/post-uncertain.count"
cat > "$UNCERTAINSTUB" <<'EOF'
#!/bin/bash
n=0; [ ! -f "$AR_POST_COUNT" ] || n="$(cat "$AR_POST_COUNT")"
n=$((n+1)); printf '%s\n' "$n" > "$AR_POST_COUNT"
"$REAL_POST" "$@" || exit $?
echo "fetch failed after push landed" >&2
exit 42
EOF
chmod +x "$UNCERTAINSTUB"
NLOG="$TR/n.log"
RUN_AR_LOG="$NLOG"
run_ar "$TR/sn" "$BARE" "$FIX" "902=0" "902=0" "$SLUG" \
  GARDEN_AR_POST="$UNCERTAINSTUB" AR_POST_COUNT="$UNCERTAINCOUNT" REAL_POST="$JOBS/post-job.sh" \
  GARDEN_AR_POST_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=0 GARDEN_BACKOFF_CAP_MS=0
RUN_AR_LOG=/dev/null
if board_has "$BARE" "$SLUG-pr902-conduct" \
   && [ "$(cat "$UNCERTAINCOUNT")" = 1 ] \
   && grep -q 'exited rc=42 class=journal-contention but fresh confirmation found it' "$NLOG"; then
  ok "a nonzero producer outcome is accepted once a fresh origin fetch confirms it"
else bad "fresh post-confirmation did not resolve the uncertain producer outcome"; fi

# ============================================================================
hr; echo "O. PERSISTENT POST FAILURE — bounded, diagnostic, deferred"; hr
BARE="$TR/o.git"; seed_bare "$BARE"
FIX="$TR/o.tsv"; prline 903 kriscendobot "$BOThead" > "$FIX"
FAILSTUB="$TR/post-fail-stub.sh"; FAILCOUNT="$TR/post-fail.count"
cat > "$FAILSTUB" <<'EOF'
#!/bin/bash
n=0; [ ! -f "$AR_POST_COUNT" ] || n="$(cat "$AR_POST_COUNT")"
n=$((n+1)); printf '%s\n' "$n" > "$AR_POST_COUNT"
echo "could not post: persistent journal push race marker-903" >&2
exit 1
EOF
chmod +x "$FAILSTUB"
OLOG="$TR/o.log"
RUN_AR_LOG="$OLOG"
run_ar "$TR/so" "$BARE" "$FIX" "903=0" "903=0" "$SLUG" \
  GARDEN_AR_POST="$FAILSTUB" AR_POST_COUNT="$FAILCOUNT" \
  GARDEN_AR_POST_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=0 GARDEN_BACKOFF_CAP_MS=0
RUN_AR_LOG=/dev/null
if ! board_has "$BARE" "$SLUG-pr903-conduct" \
   && [ "$(cat "$FAILCOUNT")" = 3 ] \
   && grep -q 'class=journal-contention.*marker-903.*deferring to the next tick' "$OLOG"; then
  ok "persistent failure stops at the bound and preserves its diagnostic for next-tick deferral"
else bad "persistent failure did not retain diagnostics or respect the retry bound"; fi

# ============================================================================
hr
echo "approval-reconciler-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
