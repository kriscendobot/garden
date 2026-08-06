#!/bin/bash
# comment-watcher-test.sh — validate the PR/issue comment watcher on throwaway
# fixtures, with no GitHub and no claude. The comment SOURCE, the REACTJI poster,
# and (for the lost-post case) the JOB POSTER are stubbed deterministically; the
# verb mapping, ack-AFTER-post sequencing (an ack implies a posted job),
# idempotency, and cursor-advance logic under test run for real against a throwaway
# journal.
#
# Asserts:
#   A. a "rebase #N" comment → a rebase job + an eyes reactji + cursor advance
#   B. a non-directive comment → no job, no reactji, cursor still slides past it
#   C. re-polling an already-actioned comment → idempotent (no dup job/reactji)
#   D. a post that did NOT land on origin/journal2 → NO reactji, cursor does NOT advance
#   PK. a directive whose base is PARKED in plan/ annotates the parked job (keyed on
#       the directive identity) instead of freezing the cursor on a phantom lost push
#   PKR. a follow-up review whose retro is already parked annotates it rather than
#       silently no-opping the re-post through post-plan.sh
#   AK. a directive whose post keeps FAILING is never acked, no matter how many
#       ticks re-poll it (ack-implies-posted; the endo-but-for-bots #600 five-acks-
#       no-job regression), and the FIRST tick whose post lands acks exactly once
#
# Usage: comment-watcher-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
# Per-run temp root (mktemp), NOT a fixed shared path: ~20 gardeners can race this
# suite concurrently, and a fixed dir makes each run's `rm -rf; mkdir` collide with a
# peer's live writes (ENOTEMPTY), flaking the whole suite. A unique dir + EXIT-trap
# teardown isolates each run. Mirrors skills/mermaid-validation's per-run mktemp fix.
# Location: NOT /tmp (mounted noexec here, and this suite runs executable stubs from
# under $TR), and NOT inside a git repo ($HOME is /home/<bot>/garden2, the garden
# checkout — a $TR beneath it would confuse git-tree discovery in the fixtures).
# `dirname "$HOME"` (the bot's real home, /home/<bot>) is exec-capable and outside any
# git tree — exactly where the old fixed path lived.
TR="$(mktemp -d "$(dirname "$HOME")/.garden-cw-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
SLUG=endojs-endo-but-for-bots
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# rc 0 iff <pid> is a process that is still RUNNING (not gone, not a zombie). A
# killed-but-not-yet-collected child is a zombie reparented to a subreaper; it
# holds no cgroup resource and `kill -0` still succeeds on it, so distinguish it
# from a live process by its /proc state. Used by the signal-reaping cases to
# assert the source subtree is felled the instant the watcher exits, with no flaky
# grace loop hiding a zombie-reaping delay.
proc_running() {  # proc_running <pid>
  local p="$1" st
  kill -0 "$p" 2>/dev/null || return 1                       # gone entirely
  # State is the first token after the final `) ` — robust to a comm with parens.
  st="$(awk '{ s=$0; sub(/^.*\) /,"",s); print substr(s,1,1) }' "/proc/$p/stat" 2>/dev/null || echo Z)"
  [ "$st" != Z ]
}
# rc 0 if <pid> stops RUNNING within ~3s. The grace only absorbs sub-ms kernel
# signal-delivery jitter after the watcher's reap; a reap REGRESSION leaves the
# source child alive for its full 600s sleep, far past this window, so a short
# bound discriminates cleanly without flaking.
reaped_within() {  # reaped_within <pid>
  local p="$1" _
  for _ in $(seq 1 30); do proc_running "$p" || return 0; sleep 0.1; done
  proc_running "$p" && return 1 || return 0
}

git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos comment-repos cursors entries
    for d in jobs/todo jobs/doin jobs/tada work repos comment-repos cursors entries; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

# --- deterministic stubs ----------------------------------------------------
SRCSTUB="$TR/source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
# emit the fixture verbatim (ignores repo/since/bot); the watcher classifies.
cat "${CW_FIXTURE:?set CW_FIXTURE}"
EOF
chmod +x "$SRCSTUB"

REACTSTUB="$TR/reactji-stub.sh"
cat > "$REACTSTUB" <<'EOF'
#!/bin/bash
# log "<surface> <comment-id> <content>" per call so duplicates are detectable.
printf '%s %s %s\n' "$2" "$3" "$4" >> "${CW_REACTJI_LOG:?set CW_REACTJI_LOG}"
EOF
chmod +x "$REACTSTUB"

# Reply-comment poster stub (the "at least a reply, not just a reactji" directive).
# Logs "<surface> <comment-id> <pr>" per call so a missing reply, a double-reply on
# re-poll, and a forbidden self-reply are all detectable. Defaults to /dev/null when
# a case does not opt in, so the existing A–Z runners stay quiet unless CW_REPLY_LOG
# is set in the calling environment.
REPLYSTUB="$TR/reply-stub.sh"
cat > "$REPLYSTUB" <<'EOF'
#!/bin/bash
# GARDEN_COMMENT_REPLY <owner/name> <surface> <comment-id> <pr> <body-file>
printf '%s %s %s\n' "$2" "$3" "$4" >> "${CW_REPLY_LOG:-/dev/null}"
EOF
chmod +x "$REPLYSTUB"

LIESTUB="$TR/lying-post-stub.sh"
cat > "$LIESTUB" <<'EOF'
#!/bin/bash
# the observed failure mode: claims success but never lands the job on the board.
echo "posted (lie)"; exit 0
EOF
chmod +x "$LIESTUB"

# Default PR-state probe for the directive-verb runners: a LIVE/open PR (exit 0) so
# rebase/retcon/refresh/gauntlet directives proceed to mint their job. The watcher
# now runs GARDEN_PR_MERGEABLE before minting a NON-finalize directive verb too (so a
# stale directive on an already-merged PR drops instead of minting a no-op job); this
# stub keeps the existing hermetic cases off the real `gh`. A case overrides it via
# CW_MERGEABLE to assert the merged/closed (exit 2) drop.
MERGEABLE_OPEN="$TR/mergeable-open.sh"
printf '#!/bin/bash\nexit 0\n' > "$MERGEABLE_OPEN"; chmod +x "$MERGEABLE_OPEN"

cursor_seen() {  # cursor_seen <state-dir> <bare>  -> prints last_seen
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
    "$JOBS/cursor-get.sh" "comments/$SLUG" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1
}
board_has() {  # board_has <bare> <base>  -> 0 if job present in todo/doin/tada
  local v; v="$(mktemp -d "$TR/bv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  local rc=1
  for s in todo doin tada; do [ -e "$v/jobs/$s/$2.md" ] && rc=0; done
  rm -rf "$v"; return $rc
}
board_job_body() {  # board_job_body <bare> <base>  -> prints the live job body
  local v f
  v="$(mktemp -d "$TR/bjb.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  for s in todo doin tada; do
    f="$v/jobs/$s/$2.md"
    [ -f "$f" ] && { cat "$f"; rm -rf "$v"; return 0; }
  done
  rm -rf "$v"
  return 1
}
board_has_plan() {  # board_has_plan <bare> <base>  -> 0 if job parked in jobs/plan
  local v; v="$(mktemp -d "$TR/bp.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  local rc=1; [ -e "$v/jobs/plan/$2.md" ] && rc=0
  rm -rf "$v"; return $rc
}
board_has_gauntlet() {  # board_has_gauntlet <bare> <base>  -> 0 if a gauntlet RECORD exists
  local v; v="$(mktemp -d "$TR/bg.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  local rc=1; [ -e "$v/jobs/gauntlet/$2.md" ] && rc=0
  rm -rf "$v"; return $rc
}
gauntlet_record_body() {  # gauntlet_record_body <bare> <base>  -> prints the record
  local v f; v="$(mktemp -d "$TR/gb.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  f="$v/jobs/gauntlet/$2.md"
  [ -f "$f" ] && cat "$f"; rm -rf "$v"
}
plan_count() {  # plan_count <bare>  -> non-gitkeep entries in jobs/plan
  local v n; v="$(mktemp -d "$TR/pc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/plan" 2>/dev/null | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}

run_watcher() {  # run_watcher <state> <bare> <fixture> <reactlog> [post-cmd]
  # Trust is DENIED deterministically (empty allowlist + /bin/false org check) so
  # these verb-gate cases stay hermetic: a trusted sender's ambiguous comment now
  # mints a deterministic `attention` job (rc 2), which would otherwise hit the real
  # org-membership API to decide trust. The cases here act via a DETECTED VERB
  # (trust-independent) or DROP as untrusted; the trusted-ambiguous `attention` path
  # is exercised separately by run_directive (E/G/GG/DET).
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_REPLY="$REPLYSTUB" CW_REPLY_LOG="${CW_REPLY_LOG:-/dev/null}" \
      GARDEN_COMMENT_POST="${5:-$JOBS/post-job.sh}" \
      GARDEN_RETRO_POST="${CW_RETRO_POST:-$JOBS/post-plan.sh}" \
      GARDEN_COMMENT_TRUST=/bin/false \
      GARDEN_TRUSTED_ALLOWLIST=/dev/null \
      GARDEN_PR_MERGEABLE="${CW_MERGEABLE:-$MERGEABLE_OPEN}" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"${CW_LOG:-/dev/null}"
}

# ============================================================================
hr; echo "A — rebase directive → job + reactji + cursor advance"; hr
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
FIX_A="$TR/fix-a.tsv"; RLOG_A="$TR/react-a.log"; : > "$RLOG_A"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T10:00:00Z issue-comment 111 57 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/57#issuecomment-111 \
  'Please rebase on #475' > "$FIX_A"
run_watcher "$TR/state-a" "$BARE_A" "$FIX_A" "$RLOG_A"
board_has "$BARE_A" "$SLUG-pr57-rebase" && ok "rebase job posted ($SLUG-pr57-rebase)" || bad "rebase job missing"
grep -qx "issue-comment 111 eyes" "$RLOG_A" && ok "eyes reactji posted on the source comment" || bad "reactji not posted ($(cat "$RLOG_A"))"
[ "$(grep -c . "$RLOG_A")" -eq 1 ] && ok "exactly one reactji" || bad "reactji count $(grep -c . "$RLOG_A")"
[ "$(cursor_seen "$TR/state-a" "$BARE_A")" = 2026-06-24T10:00:00Z ] && ok "cursor advanced to the comment's created_at" || bad "cursor not advanced ($(cursor_seen "$TR/state-a" "$BARE_A"))"

# ============================================================================
hr; echo "B — non-directive comment → nothing, cursor still slides"; hr
BARE_B="$TR/b.git"; seed_bare "$BARE_B"
FIX_B="$TR/fix-b.tsv"; RLOG_B="$TR/react-b.log"; : > "$RLOG_B"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T11:00:00Z issue-comment 222 58 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-222 \
  'Thanks, this looks great!' > "$FIX_B"
run_watcher "$TR/state-b" "$BARE_B" "$FIX_B" "$RLOG_B"
njobs=$(git clone -q --single-branch --branch "$BRANCH" "$BARE_B" "$TR/bv-b" && ls -1 "$TR/bv-b/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$TR/bv-b"
[ "$njobs" -eq 0 ] && ok "no job posted for a non-directive" || bad "posted $njobs job(s)"
[ ! -s "$RLOG_B" ] && ok "no reactji on a non-directive" || bad "reactji posted: $(cat "$RLOG_B")"
[ "$(cursor_seen "$TR/state-b" "$BARE_B")" = 2026-06-24T11:00:00Z ] && ok "cursor slid past the non-actionable comment" || bad "cursor did not slide ($(cursor_seen "$TR/state-b" "$BARE_B"))"

# ============================================================================
hr; echo "C — re-poll an already-actioned comment → idempotent"; hr
# reuse A's board + state + fixture; running again must not duplicate anything.
run_watcher "$TR/state-a" "$BARE_A" "$FIX_A" "$RLOG_A"
ntodo=$(git clone -q --single-branch --branch "$BRANCH" "$BARE_A" "$TR/bv-c" && ls -1 "$TR/bv-c/jobs/todo" | grep -c "^$SLUG-pr57-rebase" || true); rm -rf "$TR/bv-c"
[ "$ntodo" -eq 1 ] && ok "no duplicate job on re-poll (still exactly one)" || bad "job duplicated ($ntodo)"
[ "$(grep -c . "$RLOG_A")" -eq 1 ] && ok "no duplicate reactji on re-poll" || bad "reactji duplicated ($(grep -c . "$RLOG_A"))"
[ "$(cursor_seen "$TR/state-a" "$BARE_A")" = 2026-06-24T10:00:00Z ] && ok "cursor stable on idempotent re-poll" || bad "cursor moved on re-poll"

# ============================================================================
hr; echo "SD — stale directive verb on an already-MERGED PR → dropped, no job, cursor slides"; hr
# A rebase/retcon/refresh/gauntlet directive that lands AFTER the PR merged (the #9
# rebase that arrived ~2 months post-merge) must NOT mint a live job the gardener can
# only resolve as a no-op. The PR-state probe (stubbed exit 2 = merged/closed) drops
# it before minting, logging the reason, and the cursor still slides past it.
BARE_SD="$TR/sd.git"; seed_bare "$BARE_SD"
FIX_SD="$TR/fix-sd.tsv"; RLOG_SD="$TR/react-sd.log"; : > "$RLOG_SD"
LOG_SD="$TR/log-sd.txt"; : > "$LOG_SD"
MERGED="$TR/mergeable-merged.sh"; printf '#!/bin/bash\nexit 2\n' > "$MERGED"; chmod +x "$MERGED"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T10:30:00Z issue-comment 117 9 kriskowal \
  https://github.com/kriskowal/garden/pull/9#issuecomment-117 \
  'Please rebase on #475' > "$FIX_SD"
CW_MERGEABLE="$MERGED" CW_LOG="$LOG_SD" run_watcher "$TR/state-sd" "$BARE_SD" "$FIX_SD" "$RLOG_SD"
board_has "$BARE_SD" "$SLUG-pr9-rebase" && bad "stale directive on a merged PR minted a job" || ok "no job minted for a directive on an already-merged PR"
[ ! -s "$RLOG_SD" ] && ok "no reactji on the dropped stale directive" || bad "reactji posted: $(cat "$RLOG_SD")"
grep -qi 'already merged/closed' "$LOG_SD" && ok "the stale-directive drop is LOGGED with its reason" || bad "drop reason not logged ($(cat "$LOG_SD"))"
[ "$(cursor_seen "$TR/state-sd" "$BARE_SD")" = 2026-06-24T10:30:00Z ] && ok "cursor slid past the dropped stale directive" || bad "cursor did not slide ($(cursor_seen "$TR/state-sd" "$BARE_SD"))"

# ============================================================================
hr; echo "D — post that did not land → cursor does NOT advance"; hr
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
FIX_D="$TR/fix-d.tsv"; RLOG_D="$TR/react-d.log"; : > "$RLOG_D"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T12:00:00Z issue-comment 333 59 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/59#issuecomment-333 \
  'please shepherd #59' > "$FIX_D"
run_watcher "$TR/state-d" "$BARE_D" "$FIX_D" "$RLOG_D" "$LIESTUB"
board_has "$BARE_D" "$SLUG-pr59-shepherd" && bad "lying poster somehow landed the job" || ok "job correctly absent (push was lost)"
[ ! -s "$RLOG_D" ] && ok "no reactji on a lost post (ack implies a posted job)" || bad "reactji posted despite a lost push: $(cat "$RLOG_D")"
seen_d="$(cursor_seen "$TR/state-d" "$BARE_D")"
[ -z "$seen_d" ] && ok "cursor did NOT advance past a lost post (will re-poll)" || bad "cursor advanced despite lost post ($seen_d)"

# ============================================================================
hr; echo "AK — a repeatedly-FAILING post never acks (endo-but-for-bots #600); the tick that lands acks once"; hr
# The #600 incident (2026-07-18 ~04:30Z): a pr600-rebase directive was reactji-acked
# FIVE times across five ticks while no job ever reached the board — the ack fired
# BEFORE the post, so each re-poll from the frozen head-of-line cursor re-acked a
# comment whose job never landed, making a silently-dropped directive look handled.
# The fix acks only AFTER the post is confirmed on origin/journal2. Reproduce: run
# the watcher against a LYING poster across several ticks; the cursor stays frozen
# (re-polling the same comment each tick) and NOT ONE reactji must be emitted. Then
# switch to the REAL poster on a later tick: the post lands and the comment is acked
# exactly once — proving the ack was merely deferred, never lost.
BARE_AK="$TR/ak.git"; seed_bare "$BARE_AK"
FIX_AK="$TR/fix-ak.tsv"; RLOG_AK="$TR/react-ak.log"; : > "$RLOG_AK"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-18T04:30:00Z issue-comment 4870000600 600 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4870000600 \
  'Please rebase on #789' > "$FIX_AK"
# Five ticks against the LYING poster (never lands): mimics the five 04:30Z re-polls.
for _ in 1 2 3 4 5; do
  run_watcher "$TR/state-ak" "$BARE_AK" "$FIX_AK" "$RLOG_AK" "$LIESTUB"
done
board_has "$BARE_AK" "$SLUG-pr600-rebase" && bad "lying poster somehow landed the #600 job" || ok "#600 job correctly absent across five failing ticks"
[ ! -s "$RLOG_AK" ] && ok "ZERO reactji across five failing ticks (no five-acks-no-job; the #600 fix)" || bad "reactji fired on a failing post: $(grep -c . "$RLOG_AK") ack(s) — $(cat "$RLOG_AK")"
[ -z "$(cursor_seen "$TR/state-ak" "$BARE_AK")" ] && ok "cursor frozen below the un-postable directive (keeps re-polling)" || bad "cursor advanced past an un-posted directive"
# Now the post SUCCEEDS on a later tick (real poster) — the comment is acked once.
run_watcher "$TR/state-ak" "$BARE_AK" "$FIX_AK" "$RLOG_AK"
board_has "$BARE_AK" "$SLUG-pr600-rebase" && ok "the #600 job lands once the post succeeds" || bad "job did not land with a working poster"
grep -qx "issue-comment 4870000600 eyes" "$RLOG_AK" && ok "the comment is acked once its job lands (ack was deferred, not lost)" || bad "no reactji after a successful post ($(cat "$RLOG_AK"))"
[ "$(grep -c . "$RLOG_AK")" -eq 1 ] && ok "exactly one reactji total across all six ticks" || bad "reactji count across ticks: $(grep -c . "$RLOG_AK")"
[ "$(cursor_seen "$TR/state-ak" "$BARE_AK")" = 2026-07-18T04:30:00Z ] && ok "cursor advances once the directive is genuinely handled" || bad "cursor not advanced after a successful post"

# ============================================================================
hr; echo "HOL — an EARLIER lost post must NOT block a LATER directive (head-of-line fix)"; hr
# Regression for the missed kriskowal #594 CHANGES_REQUESTED review (2026-07-02):
# an earlier item that keeps POST-LOSing used to `break` the whole batch, so every
# chronologically-later directive behind it was never even attempted, tick after
# tick (the cursor stayed frozen and re-hit the same front item). The fix processes
# the WHOLE batch: the lost item freezes the cursor below itself (so it re-polls),
# but a later independent directive is still classified and posted THIS tick.
BARE_HOL="$TR/hol.git"; seed_bare "$BARE_HOL"
FIX_HOL="$TR/fix-dd.tsv"; RLOG_HOL="$TR/react-dd.log"; : > "$RLOG_HOL"; LOG_HOL="$TR/log-dd.txt"; : > "$LOG_HOL"
ALLOW_HOL="$TR/allow-dd"; printf 'kriskowal\n' > "$ALLOW_HOL"
# A post stub that LIES (never lands) for the earlier #59 shepherd job — the
# head-of-line doom — but delegates to the REAL post-job.sh for everything else,
# so the later review genuinely lands on the board.
DOOM_HOL="$TR/doom-post-hol.sh"
cat > "$DOOM_HOL" <<EOF
#!/bin/bash
case "\$1" in
  *pr59-shepherd*) echo "posted (lie)"; exit 0 ;;
  *) exec "$JOBS/post-job.sh" "\$@" ;;
esac
EOF
chmod +x "$DOOM_HOL"
# Batch (emitted unsorted; the watcher sorts ascending by created_at): the earlier
# #59 shepherd comment (05:00:00Z, will POST-LOSE) then kriskowal's later #594
# CHANGES_REQUESTED review body (10:14:32Z, must still be detected + posted).
{
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    2026-07-02T05:00:00Z issue-comment 4862458763 59 erights \
    https://github.com/endojs/endo-but-for-bots/pull/59#issuecomment-4862458763 \
    'please shepherd #59'
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    2026-07-02T10:14:32Z pr-review-body 4616520025 594 kriskowal \
    https://github.com/endojs/endo-but-for-bots/pull/594#pullrequestreview-4616520025 \
    '[CHANGES_REQUESTED] Please use JavaScript for the driver script. Use zx or drive eslint by API.'
} > "$FIX_HOL"
env GARDEN_STATE="$TR/state-hol" JOURNAL_REMOTE="$BARE_HOL" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$TR/norepos" \
    CW_FIXTURE="$FIX_HOL" CW_REACTJI_LOG="$RLOG_HOL" \
    GARDEN_COMMENT_SOURCE="$SRCSTUB" \
    GARDEN_COMMENT_REACTJI="$REACTSTUB" \
    GARDEN_COMMENT_REPLY="$REPLYSTUB" CW_REPLY_LOG=/dev/null \
    GARDEN_COMMENT_POST="$DOOM_HOL" \
    GARDEN_COMMENT_TRUST=/bin/false \
    GARDEN_TRUSTED_ALLOWLIST="$ALLOW_HOL" \
    GARDEN_PR_MERGEABLE="$MERGEABLE_OPEN" \
    "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$LOG_HOL"
# The doom #59 job is (correctly) NOT on the board — its push was lost.
board_has "$BARE_HOL" "$SLUG-pr59-shepherd" && bad "doom #59 job somehow landed" || ok "doom #59 job correctly absent (push lost)"
# The KEY assertion: the later #594 review was still detected and posted despite the
# earlier lost post — the head-of-line block is gone.
review_posted_hol() {
  local v n; v="$(mktemp -d "$TR/rph.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE_HOL" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" 2>/dev/null | grep -c "^$SLUG-pr594-review-" || true); rm -rf "$v"; [ "$n" -ge 1 ]
}
review_posted_hol && ok "the LATER #594 review job was posted despite the earlier lost post" || bad "the #594 review was NOT posted — head-of-line block still present (log: $(cat "$LOG_HOL"))"
# The cursor must stay FROZEN below the lost item (05:00:00Z) so #59 re-polls next
# tick — it must NOT jump to the review's 10:14:32Z (which would strand the lost #59).
seen_hol="$(cursor_seen "$TR/state-hol" "$BARE_HOL")"
[ -z "$seen_hol" ] && ok "cursor frozen below the lost post (will re-poll #59)" || bad "cursor advanced past the lost post ($seen_hol)"
grep -q 'POST LOST' "$LOG_HOL" && ok "the lost post is logged" || bad "no POST LOST log line"

# ============================================================================
# Bug 2 — a trusted sender's plain-language directive (no @-mention, no verb) must
# become a job, while the same comment from an untrusted sender stays dropped. The
# observe→post-job path is FULLY DETERMINISTIC — there is NO claude/LLM anywhere
# between observing a comment and posting a job (maintainer directive 2026-07-01);
# the ambiguous case mints a generic `attention` (triage) job. Trust is granted via
# the allowlist file override and DENIED by a /bin/false org-membership handler.
ALLOW="$TR/allowlist"; printf 'kriskowal\n' > "$ALLOW"

# NEVER-CALL sentinel — the watcher must invoke NO LLM/fallback in the observe→post
# path. There is no GARDEN_COMMENT_FALLBACK var anymore, so setting it must be inert.
# The DET case wires this as GARDEN_COMMENT_FALLBACK and asserts the sentinel file is
# NEVER created (proving the dead env var is ignored); a few legacy cases also pass it
# positionally to run_directive, where the extra arg is simply unused.
NEVERCALL="$TR/never-call-fallback.sh"
cat > "$NEVERCALL" <<'EOF'
#!/bin/bash
# The observe→post-job path must never exec any LLM fallback. Reaching here is a bug.
echo "FATAL: comment-watcher execed an LLM fallback in the observe->post-job path" >&2
: > "${CW_NEVERCALL_SENTINEL:-/dev/null}"
echo skip
EOF
chmod +x "$NEVERCALL"
# run the watcher with the directive-aware trust wiring (allowlist + deny org).
# Optional 5th arg names a file to capture the watcher's stderr (the `log` stream),
# so a test can assert the no-silent-slide REASON line. (A legacy 6th positional arg
# is accepted and IGNORED — there is no LLM fallback to override.) The default
# discards both streams.
run_directive() {  # run_directive <state> <bare> <fixture> <reactlog> [logfile]
  local logf="${5:-/dev/null}"
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_REPLY="$REPLYSTUB" CW_REPLY_LOG="${CW_REPLY_LOG:-/dev/null}" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_RETRO_POST="${CW_RETRO_POST:-$JOBS/post-plan.sh}" \
      GARDEN_COMMENT_TRUST=/bin/false \
      GARDEN_TRUSTED_ALLOWLIST="${CW_ALLOW:-$ALLOW}" \
      GARDEN_PR_MERGEABLE="${CW_MERGEABLE:-$MERGEABLE_OPEN}" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$logf"
}
todo_count() {  # todo_count <bare>  -> non-gitkeep entries in jobs/todo
  local v n; v="$(mktemp -d "$TR/tc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}

hr; echo "E — trusted sender plain directive (no @, no verb) → deterministic attention job"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
FIX_E="$TR/fix-e.tsv"; RLOG_E="$TR/react-e.log"; : > "$RLOG_E"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T13:00:00Z issue-comment 444 503 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-4794208524 \
  'Please apply this feedback' > "$FIX_E"
run_directive "$TR/state-e" "$BARE_E" "$FIX_E" "$RLOG_E"
[ "$(todo_count "$BARE_E")" -eq 1 ] && ok "trusted plain-language directive routed to a posted job" || bad "directive dropped (todo=$(todo_count "$BARE_E"))"
[ -s "$RLOG_E" ] && ok "eyes reactji acked the directive comment" || bad "no reactji on the directive"
[ "$(cursor_seen "$TR/state-e" "$BARE_E")" = 2026-06-24T13:00:00Z ] && ok "cursor advanced past the actioned directive" || bad "cursor not advanced"

hr; echo "F — SAME directive from an UNTRUSTED sender → still dropped"; hr
BARE_F="$TR/f.git"; seed_bare "$BARE_F"
FIX_F="$TR/fix-f.tsv"; RLOG_F="$TR/react-f.log"; : > "$RLOG_F"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T14:00:00Z issue-comment 555 503 drive-by-rando \
  https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-555 \
  'Please apply this feedback' > "$FIX_F"
run_directive "$TR/state-f" "$BARE_F" "$FIX_F" "$RLOG_F"
[ "$(todo_count "$BARE_F")" -eq 0 ] && ok "untrusted sender's directive dropped (no job)" || bad "untrusted directive posted a job"
[ ! -s "$RLOG_F" ] && ok "no reactji for an untrusted sender" || bad "reactji posted for untrusted: $(cat "$RLOG_F")"
[ "$(cursor_seen "$TR/state-f" "$BARE_F")" = 2026-06-24T14:00:00Z ] && ok "cursor slid past the dropped untrusted comment" || bad "cursor did not slide"

hr; echo "G — a TRUSTED sender's ambiguous chatter → a DETERMINISTIC attention job (no LLM skip)"; hr
# The observe→post-job path is now fully deterministic (no claude): a trusted, in-scope
# comment with no verb NEVER depends on an LLM to decide "skip". It ALWAYS mints an
# `attention` (triage) job — the gardener that claims it reads the comment and, if it is
# pure chatter, completes a light-reply no-op. This is the fix for the dropped ambiguous
# #503/#405 directives: an LLM skip/failure can no longer drop a trusted comment.
BARE_G="$TR/g.git"; seed_bare "$BARE_G"
FIX_G="$TR/fix-g.tsv"; RLOG_G="$TR/react-g.log"; : > "$RLOG_G"; GLOG="$TR/g.stderr"; : > "$GLOG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T15:00:00Z issue-comment 666 503 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-666 \
  'Thanks for the help here!' > "$FIX_G"
run_directive "$TR/state-g" "$BARE_G" "$FIX_G" "$RLOG_G" "$GLOG"
[ "$(todo_count "$BARE_G")" -eq 1 ] && ok "trusted ambiguous comment minted a deterministic attention job (never an LLM skip/drop)" || bad "trusted ambiguous comment did not post a job (todo=$(todo_count "$BARE_G"))"
grep -q 'attention on #503' "$GLOG" && ok "the posted job is an 'attention' (triage) job on #503 — deterministic, no LLM" || bad "no posted-attention log line ($(cat "$GLOG"))"
grep -qx "issue-comment 666 eyes" "$RLOG_G" && ok "the comment got its 👀 receipt" || bad "no reactji on the comment ($(cat "$RLOG_G"))"
[ "$(cursor_seen "$TR/state-g" "$BARE_G")" = 2026-06-24T15:00:00Z ] && ok "cursor advanced past the actioned comment" || bad "cursor did not advance"

hr; echo "GG — trusted directive with NO 'please'/verb (the #405 phrasing) → deterministic attention job, not rc==1"; hr
# The #405 root cause: "Getting closer. 1. … 2. Let's aggregate Handles … 4. Remove …"
# carries clear asks but no "please" and no listed verb, so the deterministic gate
# scores it non-actionable. For a TRUSTED sender it must mint a deterministic
# `attention` (triage) job, NEVER the old silent rc==1 drop and NEVER an LLM skip.
BARE_GG="$TR/gg.git"; seed_bare "$BARE_GG"
FIX_GG="$TR/fix-gg.tsv"; RLOG_GG="$TR/react-gg.log"; : > "$RLOG_GG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-28T06:48:40Z issue-comment 4825162435 405 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/405#issuecomment-4825162435 \
  'Getting closer. 1. Aggregate the Handles into one table. 2. Let'\''s manually order them. 4. Remove the stray import and increase the indent.' > "$FIX_GG"
run_directive "$TR/state-gg" "$BARE_GG" "$FIX_GG" "$RLOG_GG"
[ "$(todo_count "$BARE_GG")" -eq 1 ] && ok "the #405-style directive minted a deterministic attention job" || bad "directive dropped at rc==1 (todo=$(todo_count "$BARE_GG"))"
[ -s "$RLOG_GG" ] && ok "eyes reactji acked the #405-style directive" || bad "no reactji on the #405-style directive"
[ "$(cursor_seen "$TR/state-gg" "$BARE_GG")" = 2026-06-28T06:48:40Z ] && ok "cursor advanced past the actioned directive" || bad "cursor not advanced"

hr; echo "GH — UNTRUSTED non-directive → still dropped, but the drop is LOGGED (not silent), no reactji"; hr
BARE_GH="$TR/gh.git"; seed_bare "$BARE_GH"
FIX_GH="$TR/fix-gh.tsv"; RLOG_GH="$TR/react-gh.log"; : > "$RLOG_GH"; GHLOG="$TR/gh.stderr"; : > "$GHLOG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T15:30:00Z issue-comment 667 503 drive-by-rando \
  https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-667 \
  'random chatter from a stranger' > "$FIX_GH"
run_directive "$TR/state-gh" "$BARE_GH" "$FIX_GH" "$RLOG_GH" "$GHLOG"
[ "$(todo_count "$BARE_GH")" -eq 0 ] && ok "untrusted non-directive dropped (no job)" || bad "untrusted comment posted a job"
[ ! -s "$RLOG_GH" ] && ok "no reactji for an untrusted sender" || bad "reactji posted for untrusted: $(cat "$RLOG_GH")"
grep -q 'DROP:' "$GHLOG" && grep -q 'verb-gate:not-actionable' "$GHLOG" && ok "the untrusted drop is LOGGED with its reason (not silent)" || bad "untrusted drop not logged ($(cat "$GHLOG"))"

# ============================================================================
# H — the ROOT CAUSE: a missing jq must make the comment SOURCE fail LOUD, not
# emit empty. Simulate by PATH-masking jq (a shimdir of every /usr/bin tool EXCEPT
# jq; common.sh re-prepends its own gh wrapper, so gh stays resolvable). Assert the
# handler exits NONZERO, names jq on stderr, and produces NO stdout — the opposite
# of the silent-empty behaviour that hid the 2026-06-24 outage.
hr; echo "H — missing jq → comment-source-gh.sh fails LOUD (no silent empty)"; hr
SHIMDIR="$TR/nojq-bin"; mkdir -p "$SHIMDIR"
for f in /usr/bin/*; do ln -sf "$f" "$SHIMDIR/$(basename "$f")" 2>/dev/null || true; done
# common.sh now appends /usr/bin to every fleet PATH, so merely removing jq from
# the leading shim cannot mask it. Put an executable broken-jq sentinel first and
# use an empty API stub: the source reaches its jq pipeline hermetically and must
# still fail loud rather than treating the absent implementation as empty JSON.
rm -f "$SHIMDIR/jq"
cat > "$SHIMDIR/jq" <<'EOF'
#!/bin/bash
echo 'jq: command not found (test sentinel)' >&2
exit 127
EOF
chmod +x "$SHIMDIR/jq"
GH_EMPTY="$TR/gh-empty.sh"
cat > "$GH_EMPTY" <<'EOF'
#!/bin/bash
printf '[]\n'
EOF
chmod +x "$GH_EMPTY"
command -v jq >/dev/null 2>&1 && have_jq=1 || have_jq=0   # sanity: jq exists on the real host
SRC_OUT="$TR/h.out"; SRC_ERR="$TR/h.err"
set +e
env -i HOME="$HOME" PATH="$SHIMDIR" GARDEN_GH="$GH_EMPTY" GARDEN_NO_MAINTAINER_ALERT=1 \
    GARDEN_STATE="$TR/state-h" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots 2026-06-24T00:00:00Z kriscendobot \
    > "$SRC_OUT" 2> "$SRC_ERR"
rc=$?
set -e
if [ "$have_jq" -eq 0 ]; then
  echo "  SKIP: no real jq on host to mask meaningfully"
else
  [ "$rc" -ne 0 ] && ok "comment-source exits nonzero when jq is masked (rc=$rc)" || bad "comment-source returned 0 with jq masked (silent-empty regression!)"
  grep -qi 'jq' "$SRC_ERR" && ok "stderr names the missing tool (jq)" || bad "stderr did not mention jq: $(cat "$SRC_ERR")"
  [ ! -s "$SRC_OUT" ] && ok "no stdout emitted on the missing-tool failure" || bad "emitted output despite missing jq"
fi

# ============================================================================
# I/J — BLINDNESS is a POSITIVE SELF-TEST, never an inactivity inference. Human
# inactivity (a quiet repo) must NEVER page the maintainer — "people sleep
# sometimes" (maintainer directive 2026-06-27). The watcher's only zero-result
# concern is the source path going SILENTLY BLIND (the 2026-06-24 jq outage), which
# is detected by a deterministic self-test that confirms the source path can still
# fetch a KNOWN-EXISTING comment — NOT by how long the repo has been quiet. The
# self-test is stubbed by exit code (HEALTHY=0 / BLIND=1); the interval is forced to
# 0 so EVERY tick runs it (so streak length is irrelevant by construction); alerts
# are captured via GARDEN_ALERT_CMD.
EMPTY_FIX="$TR/empty.tsv"; : > "$EMPTY_FIX"
HEALTHY="$TR/healthy.sh"; printf '#!/bin/bash\nexit 0\n' > "$HEALTHY"; chmod +x "$HEALTHY"
BLIND="$TR/blind.sh";     printf '#!/bin/bash\nexit 1\n' > "$BLIND";   chmod +x "$BLIND"
run_silent() {  # run_silent <state> <bare> <selftest-probe> <alert-cmd>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$EMPTY_FIX" CW_REACTJI_LOG="$TR/react-silent.log" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_REPLY="$REPLYSTUB" CW_REPLY_LOG="${CW_REPLY_LOG:-/dev/null}" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_SELFTEST="$3" \
      GARDEN_COMMENT_SELFTEST_INTERVAL_SECS=0 \
      GARDEN_ALERT_CMD="$4" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1
}

hr; echo "I — zero results + a BLIND source (self-test FAILS) → throttled anomaly"; hr
BARE_I="$TR/i.git"; seed_bare "$BARE_I"
ALERTLOG_I="$TR/alert-i.log"; : > "$ALERTLOG_I"
ALERTCAP="$TR/alert-cap.sh"
cat > "$ALERTCAP" <<EOF
#!/bin/bash
# capture key+message so the test can count alerts without touching the board.
printf '%s\t%s\n' "\$1" "\$2" >> "$ALERTLOG_I"
EOF
chmod +x "$ALERTCAP"
# Several zero-result ticks against a BLIND source: the very first failed self-test
# fires the anomaly; later ticks are throttled by alert_maintainer's per-key window.
run_silent "$TR/state-i" "$BARE_I" "$BLIND" "$ALERTCAP"
run_silent "$TR/state-i" "$BARE_I" "$BLIND" "$ALERTCAP"
run_silent "$TR/state-i" "$BARE_I" "$BLIND" "$ALERTCAP"
nalert=$(grep -c "blind-comment-watcher-$SLUG" "$ALERTLOG_I" 2>/dev/null || echo 0)
[ "$nalert" -ge 1 ] && ok "a FAILED self-test surfaces the blindness anomaly (alerts=$nalert)" || bad "no anomaly alert despite a blind source"
run_silent "$TR/state-i" "$BARE_I" "$BLIND" "$ALERTCAP"   # a 4th tick must be throttled
nalert2=$(grep -c "blind-comment-watcher-$SLUG" "$ALERTLOG_I" 2>/dev/null || echo 0)
[ "$nalert2" -eq "$nalert" ] && ok "alert is throttled (no flood: still $nalert2)" || bad "alert flooded ($nalert2 > $nalert)"

hr; echo "J — zero results while the source is HEALTHY (just quiet) → NO anomaly, any streak"; hr
BARE_J="$TR/j.git"; seed_bare "$BARE_J"
ALERTLOG_J="$TR/alert-j.log"; : > "$ALERTLOG_J"
ALERTCAP_J="$TR/alert-cap-j.sh"
cat > "$ALERTCAP_J" <<EOF
#!/bin/bash
printf '%s\t%s\n' "\$1" "\$2" >> "$ALERTLOG_J"
EOF
chmod +x "$ALERTCAP_J"
# Six consecutive zero-result ticks — a long quiet streak — with a HEALTHY source.
# Inactivity must NEVER alert, no matter how long the streak runs.
for _ in 1 2 3 4 5 6; do
  run_silent "$TR/state-j" "$BARE_J" "$HEALTHY" "$ALERTCAP_J"
done
[ ! -s "$ALERTLOG_J" ] && ok "no anomaly for a quiet repo regardless of streak length (people sleep)" || bad "false inactivity anomaly on a healthy quiet source: $(cat "$ALERTLOG_J")"

# ============================================================================
# K/L/M — VERB-AS-SUBJECT-MATTER gate on the FIXED verb table. A bare verb word
# (rebase/retcon/refresh/shepherd) appearing as a PR's topic or as a future/
# conditional intention ("a subsequent rebase ... will", "no action needed") must
# NOT short-circuit into a deterministic verb job; the table fires only when the
# body reads as an imperative directive OR @-mentions the bot. Canonical case:
# endo-but-for-bots #513 issue-comment 4800685785 minted a bogus pr513-rebase from
# a future-tense "rebase" whose own text said to WAIT.
hr; echo "K — future-tense 'rebase' as subject matter (no @, no imperative) → NO verb job"; hr
# Author is a non-bot sender (so it reaches the verb-gate, not the new bot-self
# guard): the point under test is that a future-tense/subject-matter "rebase" with
# no imperative cue and no @-mention does NOT mint a deterministic rebase verb job.
BARE_K="$TR/k.git"; seed_bare "$BARE_K"
FIX_K="$TR/fix-k.tsv"; RLOG_K="$TR/react-k.log"; : > "$RLOG_K"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T10:00:00Z issue-comment 777 513 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/513#issuecomment-4800685785 \
  'A subsequent rebase of this PR onto a fresh `llm` snapshot will pick it up. No action needed here until #528 merges.' > "$FIX_K"
run_watcher "$TR/state-k" "$BARE_K" "$FIX_K" "$RLOG_K"
board_has "$BARE_K" "$SLUG-pr513-rebase" && bad "verb-as-subject-matter minted a bogus rebase job (#513 regression)" || ok "no rebase job from a future-tense 'rebase' mention"
[ "$(todo_count "$BARE_K")" -eq 0 ] && ok "non-imperative verb mention posted no job at all" || bad "posted a job for verb-as-topic (todo=$(todo_count "$BARE_K"))"
[ ! -s "$RLOG_K" ] && ok "no reactji on a non-directive verb mention" || bad "reactji posted: $(cat "$RLOG_K")"
[ "$(cursor_seen "$TR/state-k" "$BARE_K")" = 2026-06-25T10:00:00Z ] && ok "cursor slid past the non-actionable verb mention" || bad "cursor did not slide"

hr; echo "L — CHANGES_REQUESTED body discussing a 'rebase' design → one 'review' job, NOT a verb job"; hr
BARE_L="$TR/l.git"; seed_bare "$BARE_L"
FIX_L="$TR/fix-l.tsv"; RLOG_L="$TR/react-l.log"; : > "$RLOG_L"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T11:00:00Z pr-review-body 888 526 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/526#pullrequestreview-888 \
  '[CHANGES_REQUESTED] The clean-rebase git code-mode eval scenario needs deeper folders.' > "$FIX_L"
run_directive "$TR/state-l" "$BARE_L" "$FIX_L" "$RLOG_L"
board_has "$BARE_L" "$SLUG-pr526-rebase" && bad "CHANGES_REQUESTED verb-as-topic minted a bogus rebase job (#526 regression)" || ok "no rebase job from a verb discussed in a review body"
[ "$(todo_count "$BARE_L")" -eq 1 ] && ok "the CHANGES_REQUESTED review minted exactly one deterministic 'review' job instead" || bad "CHANGES_REQUESTED review did not mint one review job (todo=$(todo_count "$BARE_L"))"

hr; echo "M — @-mention WITH a bare verb ('@bot rebase #57') still fires the table"; hr
BARE_M="$TR/m.git"; seed_bare "$BARE_M"
FIX_M="$TR/fix-m.tsv"; RLOG_M="$TR/react-m.log"; : > "$RLOG_M"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T12:00:00Z issue-comment 999 57 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/57#issuecomment-999 \
  '@kriscendobot rebase #475' > "$FIX_M"
run_watcher "$TR/state-m" "$BARE_M" "$FIX_M" "$RLOG_M"
board_has "$BARE_M" "$SLUG-pr57-rebase" && ok "an @-mention licenses the verb table even without 'please'" || bad "@-mention + verb did not mint a rebase job"

# ============================================================================
# N/O/P — a TRUSTED maintainer's REVIEW carrying inline comments is ALWAYS
# actionable, regardless of body/verb/phrasing (the gap behind endo-but-for-bots
# #503/#96 and kriskowal/garden #4). The source marks such reviews [INLINE-REVIEW];
# the classifier mints exactly one deterministic `review` job (keyed per review id)
# that enumerates ALL inline comments. The sender gate still applies: untrusted →
# dropped. A review with no inline marker and no body → nothing.
todo_glob() {  # todo_glob <bare> <ere>  -> count of jobs/todo entries matching ERE
  local v n; v="$(mktemp -d "$TR/tg.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" 2>/dev/null | grep -Ec "$2" || true); rm -rf "$v"; printf '%s' "$n"
}

hr; echo "N — trusted empty-body review WITH inline comments → exactly one 'review' job"; hr
BARE_N="$TR/n.git"; seed_bare "$BARE_N"
FIX_N="$TR/fix-n.tsv"; RLOG_N="$TR/react-n.log"; : > "$RLOG_N"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T13:00:00Z pr-review-body 4573331488 4 kriskowal \
  https://github.com/kriskowal/garden/pull/4#pullrequestreview-4573331488 \
  '[INLINE-REVIEW] ' > "$FIX_N"
run_directive "$TR/state-n" "$BARE_N" "$FIX_N" "$RLOG_N"
[ "$(todo_count "$BARE_N")" -eq 1 ] && ok "trusted inline-bearing review posted exactly one job" || bad "review dropped or duplicated (todo=$(todo_count "$BARE_N"))"
[ "$(todo_glob "$BARE_N" "^$SLUG-pr4-review-")" -eq 1 ] && ok "the job is a per-review 'review' job ($SLUG-pr4-review-…)" || bad "no per-review 'review' job minted"
[ ! -s "$RLOG_N" ] && ok "no reactji on a review body (the job is the response)" || bad "reactji posted on a review body: $(cat "$RLOG_N")"
[ "$(cursor_seen "$TR/state-n" "$BARE_N")" = 2026-06-25T13:00:00Z ] && ok "cursor advanced past the actioned review" || bad "cursor not advanced"
# re-poll → idempotent (same review id → same base → no dup)
run_directive "$TR/state-n" "$BARE_N" "$FIX_N" "$RLOG_N"
[ "$(todo_glob "$BARE_N" "^$SLUG-pr4-review-")" -eq 1 ] && ok "re-poll of the same review is idempotent (still one job)" || bad "review job duplicated on re-poll"

hr; echo "O — SAME inline-bearing review from an UNTRUSTED sender → dropped"; hr
BARE_O="$TR/o.git"; seed_bare "$BARE_O"
FIX_O="$TR/fix-o.tsv"; RLOG_O="$TR/react-o.log"; : > "$RLOG_O"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T13:30:00Z pr-review-body 4573434772 4 drive-by-rando \
  https://github.com/kriskowal/garden/pull/4#pullrequestreview-4573434772 \
  '[INLINE-REVIEW] ' > "$FIX_O"
run_directive "$TR/state-o" "$BARE_O" "$FIX_O" "$RLOG_O"
[ "$(todo_count "$BARE_O")" -eq 0 ] && ok "untrusted reviewer's inline-bearing review dropped (no job)" || bad "untrusted review posted a job"
[ ! -s "$RLOG_O" ] && ok "no reactji for an untrusted reviewer" || bad "reactji posted for untrusted"
[ "$(cursor_seen "$TR/state-o" "$BARE_O")" = 2026-06-25T13:30:00Z ] && ok "cursor slid past the dropped untrusted review" || bad "cursor did not slide"

hr; echo "P — trusted review, NO inline marker AND empty body → nothing"; hr
BARE_P="$TR/p.git"; seed_bare "$BARE_P"
FIX_P="$TR/fix-p.tsv"; RLOG_P="$TR/react-p.log"; : > "$RLOG_P"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T14:00:00Z pr-review-body 4573500000 4 kriskowal \
  https://github.com/kriskowal/garden/pull/4#pullrequestreview-4573500000 \
  '' > "$FIX_P"
run_directive "$TR/state-p" "$BARE_P" "$FIX_P" "$RLOG_P"
[ "$(todo_count "$BARE_P")" -eq 0 ] && ok "an empty review with no inline comments produced no job" || bad "empty no-inline review posted a job"

# ============================================================================
# Q — SOURCE-level: comment-source-gh.sh must SURFACE an empty-body review that
# carries inline comments (marked [INLINE-REVIEW]), and must DROP an empty-body
# review with no inline comments. A compact gh stub answers the four endpoints the
# handler hits; the REAL jq processes the JSON.
hr; echo "Q — comment-source-gh.sh surfaces empty-body inline-bearing reviews"; hr
# The handler clamps `since` to a 24h floor, so the SOURCE-level tests (Q/Z/EE)
# must use timestamps RELATIVE TO NOW or they rot the moment "today" drifts >24h
# past a hardcoded fixture date (the latent failure these three used to ship).
# REV_TS — a review/activity time inside the window; SINCE_TS — the cursor (older);
# OLD_TS — well before the window, to exercise the activity-bound early-stop.
REV_TS="$(date -u -d '-1 hour'  +%FT%TZ)"
SINCE_TS="$(date -u -d '-3 hours' +%FT%TZ)"
OLD_TS="$(date -u -d '-30 days' +%FT%TZ)"
command -v jq >/dev/null 2>&1 && have_jq_q=1 || have_jq_q=0
if [ "$have_jq_q" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHQ="$TR/gh-q"; mkdir -p "$GHQ"
  cat > "$GHQ/gh" <<'EOF'
#!/bin/bash
# minimal gh stub for the comment-source review-surfacing test. Recognizes the
# four call shapes comment-source-gh.sh makes; everything else → empty array.
# TS (review/activity time, inside the 24h window) is injected via the environment
# so the fixture never rots against the handler's floor clamp.
args="$*"; ts="${TS:?TS must be set}"
case "$args" in
  *"/pulls?state=open"*)         # authoritative paginated open-PR list: one PR, #4
    printf '[{"number":4,"updated_at":"%s"}]\n' "$ts"; exit 0;;
  *"/issues/comments"*)          printf '[]\n'; exit 0;;
  *"/pulls/comments"*)           printf '[]\n'; exit 0;;        # repo-wide inline feed (unused here)
  *"/pulls/4/comments"*)         # inline comments on #4: two tied to review 9001, none to 9002
    printf '%s\n' '[{"pull_request_review_id":9001},{"pull_request_review_id":9001}]'; exit 0;;
  *"/pulls/4/reviews"*)          # one inline-bearing empty-body review, one empty no-inline review
    printf '[{"id":9001,"state":"COMMENTED","body":"","submitted_at":"%s","user":{"login":"kriskowal"},"html_url":"https://x/pull/4#r9001"},{"id":9002,"state":"COMMENTED","body":"","submitted_at":"%s","user":{"login":"kriskowal"},"html_url":"https://x/pull/4#r9002"}]\n' "$ts" "$ts"; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHQ/gh"
  Q_OUT="$TR/q.out"
  env PATH="$GHQ:$PATH" TS="$REV_TS" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-q" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > "$Q_OUT" 2>/dev/null || true
  grep -q $'\t9001\t' "$Q_OUT" && grep -q 'INLINE-REVIEW' "$Q_OUT" \
    && ok "inline-bearing empty-body review 9001 surfaced with [INLINE-REVIEW]" \
    || bad "review 9001 not surfaced (out: $(cat "$Q_OUT"))"
  grep -q $'\t9002\t' "$Q_OUT" \
    && bad "empty no-inline review 9002 was surfaced (should be dropped)" \
    || ok "empty review 9002 with no inline comments correctly dropped"
fi

# ============================================================================
# R/S — the WHOLE review is the unit: a trusted review whose body carries a VERB
# plus other asks must mint ONE per-review `review` job (body + enumerate-ALL-inline
# instruction, the verb noted as PRIMARY) — NOT a verb-only job that drops the rest.
# Canonical case: endo-but-for-bots #528 (review 4573773954) said "Reconstruct the
# original title and description. Run the gauntlet once more." with an inline
# banner-comment note; the watcher mapped `gauntlet` and dropped the rest.
review_job_body() {  # review_job_body <bare> <pr>  -> cat the single per-review job
  local v f; v="$(mktemp -d "$TR/rj.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  f="$(ls -1 "$v"/jobs/todo/"$SLUG-pr$2-review-"*.md 2>/dev/null | head -1)"
  [ -n "$f" ] && cat "$f"
  rm -rf "$v"
}

hr; echo "R — trusted review with a VERB in body → ONE bundle job, not a verb-only job"; hr
BARE_R="$TR/r.git"; seed_bare "$BARE_R"
FIX_R="$TR/fix-r.tsv"; RLOG_R="$TR/react-r.log"; : > "$RLOG_R"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T15:00:00Z pr-review-body 4573773954 528 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/528#pullrequestreview-4573773954 \
  '[INLINE-REVIEW] Reconstruct the original title and description. Run the gauntlet once more.' > "$FIX_R"
run_directive "$TR/state-r" "$BARE_R" "$FIX_R" "$RLOG_R"
board_has "$BARE_R" "$SLUG-pr528-gauntlet" && bad "minted a verb-only gauntlet job (dropped the rest of the review)" || ok "no verb-only gauntlet job (the verb did not short-circuit the review)"
[ "$(todo_glob "$BARE_R" "^$SLUG-pr528-review-")" -eq 1 ] && ok "exactly one per-review 'review' job minted" || bad "no per-review 'review' job (todo=$(todo_count "$BARE_R"))"
[ "$(todo_count "$BARE_R")" -eq 1 ] && ok "exactly one job total for the review" || bad "expected one job, got $(todo_count "$BARE_R")"
RBODY="$(review_job_body "$BARE_R" 528)"
printf '%s' "$RBODY" | grep -qi 'WHOLE review' && ok "review job frames the WHOLE review as the unit" || bad "review job not framed as whole-review"
printf '%s' "$RBODY" | grep -qi 'gauntlet' && ok "review job notes the verb (gauntlet) as the primary action" || bad "review job dropped the verb action"
printf '%s' "$RBODY" | grep -qi 'primary action' && ok "the verb is labelled PRIMARY (one item, not the whole job)" || bad "verb not labelled primary"
printf '%s' "$RBODY" | grep -q 'pull_request_review_id' && ok "review job instructs enumerating ALL inline comments" || bad "review job missing inline-enumeration instruction"
# The #721 false-peer no-op: a pre-correlation preflight exit 2 matched an unrelated
# commit, the job closed as a "clean no-op" asserting a peer had done the work, and a
# maintainer directive sat unactioned for two weeks. Exit 2 must therefore reach the
# gardener as a HINT REQUIRING CORROBORATION, never as a licence to close.
printf '%s' "$RBODY" | grep -qi 'Exit 2 is a HINT' \
  && ok "the preflight instruction frames exit 2 as a hint, not an authority" \
  || bad "exit 2 still reads as a licence to close (the #721 false-peer no-op)"
printf '%s' "$RBODY" | grep -qi 'name the artifact that resolves it' \
  && ok "exit 2 requires naming the resolving artifact per ask" \
  || bad "exit 2 does not require positive evidence per ask"
printf '%s' "$RBODY" | grep -qi 'check the board itself' \
  && ok "a BOARD deliverable must be verified against the board, not inferred" \
  || bad "board-artifact deliverables may still be inferred from the preflight"
printf '%s' "$RBODY" | grep -qi 'treat exit 2 as PROCEED' \
  && ok "an uncorroborated exit 2 falls back to PROCEED (fail toward doing the work)" \
  || bad "an uncorroborated exit 2 does not fall back to PROCEED"
printf '%s' "$RBODY" | grep -qi 'did not verify' \
  && ok "the job is forbidden to report unverified peer work" \
  || bad "nothing forbids asserting unverified peer completion"
[ ! -s "$RLOG_R" ] && ok "no reactji on a review body (the job is the response)" || bad "reactji posted on a review body: $(cat "$RLOG_R")"
[ "$(cursor_seen "$TR/state-r" "$BARE_R")" = 2026-06-25T15:00:00Z ] && ok "cursor advanced past the actioned review" || bad "cursor not advanced"
# re-poll → idempotent (same review id → same base → no dup)
run_directive "$TR/state-r" "$BARE_R" "$FIX_R" "$RLOG_R"
[ "$(todo_glob "$BARE_R" "^$SLUG-pr528-review-")" -eq 1 ] && ok "re-poll of the same review is idempotent (still one job)" || bad "review job duplicated on re-poll"

hr; echo "S — trusted CHANGES_REQUESTED review (no verb) → ONE bundle job, not a reader-fallback"; hr
BARE_S="$TR/s.git"; seed_bare "$BARE_S"
FIX_S="$TR/fix-s.tsv"; RLOG_S="$TR/react-s.log"; : > "$RLOG_S"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T15:30:00Z pr-review-body 4573800000 530 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/530#pullrequestreview-4573800000 \
  '[CHANGES_REQUESTED] Please also update the changelog and rename the helper.' > "$FIX_S"
run_directive "$TR/state-s" "$BARE_S" "$FIX_S" "$RLOG_S"
[ "$(todo_glob "$BARE_S" "^$SLUG-pr530-review-")" -eq 1 ] && ok "CHANGES_REQUESTED review bundled into one per-review job" || bad "CHANGES_REQUESTED review not bundled (todo=$(todo_count "$BARE_S"))"
[ "$(todo_count "$BARE_S")" -eq 1 ] && ok "exactly one job for the CHANGES_REQUESTED review" || bad "expected one job, got $(todo_count "$BARE_S")"
SBODY="$(review_job_body "$BARE_S" 530)"
printf '%s' "$SBODY" | grep -q 'pull_request_review_id' && ok "the bundle instructs enumerating every inline comment" || bad "bundle missing inline-enumeration instruction"

# ============================================================================
# T/U/V/W/X/Y — APPROVAL → finalization-to-merge. A trusted maintainer's APPROVED
# review on a mergeable bot-repo PR mints exactly one idempotent conductor job
# (<slug>-pr<N>-conduct). An approval bundled with asks routes the WHOLE review
# FIRST (no conduct job yet). Guards: non-bot repo OR untrusted sender → no merge
# dispatch; already-merged → nothing; not-green → shepherd, never a forced merge.
# The mergeable probe is stubbed by exit code (0 ready / 2 merged-or-closed / 1 not
# ready); trust is granted via the allowlist file (kriskowal) and DENIED org-wide.
MERGEABLE="$TR/mergeable.sh";  printf '#!/bin/bash\nexit 0\n' > "$MERGEABLE";  chmod +x "$MERGEABLE"
MERGEDST="$TR/merged.sh";      printf '#!/bin/bash\nexit 2\n' > "$MERGEDST";   chmod +x "$MERGEDST"
NOTGREEN="$TR/notgreen.sh";    printf '#!/bin/bash\nexit 1\n' > "$NOTGREEN";   chmod +x "$NOTGREEN"
run_approval() {  # <state> <bare> <fixture> <reactlog> <mergeable-probe> [slug]
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_REPLY="$REPLYSTUB" CW_REPLY_LOG="${CW_REPLY_LOG:-/dev/null}" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_TRUST=/bin/false \
      GARDEN_TRUSTED_ALLOWLIST="$ALLOW" \
      GARDEN_PR_MERGEABLE="$5" \
      "$JOBS/comment-watcher.sh" "${6:-$SLUG}" >/dev/null 2>&1
}

hr; echo "T — trusted clean APPROVED on a mergeable bot PR → one conductor job, idempotent"; hr
BARE_T="$TR/t.git"; seed_bare "$BARE_T"
FIX_T="$TR/fix-t.tsv"; RLOG_T="$TR/react-t.log"; : > "$RLOG_T"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T16:00:00Z pr-review-body 4574000000 540 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/540#pullrequestreview-4574000000 \
  '[APPROVED] Looks great, ship it.' > "$FIX_T"
run_approval "$TR/state-t" "$BARE_T" "$FIX_T" "$RLOG_T" "$MERGEABLE"
board_has "$BARE_T" "$SLUG-pr540-conduct" && ok "clean approval minted the conductor job ($SLUG-pr540-conduct)" || bad "no conductor job for a mergeable clean approval"
[ "$(todo_count "$BARE_T")" -eq 1 ] && ok "exactly one job for the approval" || bad "expected one job, got $(todo_count "$BARE_T")"
[ ! -s "$RLOG_T" ] && ok "no reactji on a review body (the job is the response)" || bad "reactji posted on an approval review: $(cat "$RLOG_T")"
TBODY="$(mktemp -d "$TR/tb.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_T" "$TBODY" 2>/dev/null
grep -qi 'conductor' "$TBODY/jobs/todo/$SLUG-pr540-conduct.md" && ok "conduct job names the conductor" || bad "conduct job does not name the conductor"
grep -qi 'merge method' "$TBODY/jobs/todo/$SLUG-pr540-conduct.md" && ok "conduct job declines to name a merge method" || bad "conduct job should defer the merge method to the conductor"; rm -rf "$TBODY"
[ "$(cursor_seen "$TR/state-t" "$BARE_T")" = 2026-06-25T16:00:00Z ] && ok "cursor advanced past the actioned approval" || bad "cursor not advanced"
run_approval "$TR/state-t" "$BARE_T" "$FIX_T" "$RLOG_T" "$MERGEABLE"   # re-poll
[ "$(todo_glob "$BARE_T" "^$SLUG-pr540-conduct")" -eq 1 ] && ok "re-poll is idempotent (still one conductor job)" || bad "conductor job duplicated on re-poll"

hr; echo "U — APPROVED bundled with inline asks → asks route FIRST (review), no conduct yet"; hr
BARE_U="$TR/u.git"; seed_bare "$BARE_U"
FIX_U="$TR/fix-u.tsv"; RLOG_U="$TR/react-u.log"; : > "$RLOG_U"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T16:30:00Z pr-review-body 4574100000 528 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/528#pullrequestreview-4574100000 \
  '[INLINE-REVIEW] [APPROVED] Please also express the types in the .d.ts.' > "$FIX_U"
run_approval "$TR/state-u" "$BARE_U" "$FIX_U" "$RLOG_U" "$MERGEABLE"
board_has "$BARE_U" "$SLUG-pr528-conduct" && bad "approval-with-asks minted a conductor job before the asks were addressed" || ok "no premature conductor job (asks come first)"
[ "$(todo_glob "$BARE_U" "^$SLUG-pr528-review-")" -eq 1 ] && ok "the asks routed as exactly one per-review job" || bad "asks not routed as a review job (todo=$(todo_count "$BARE_U"))"
UBODY="$(review_job_body "$BARE_U" 528)"
printf '%s' "$UBODY" | grep -qi 'APPROVAL bundled with asks' && ok "review job notes the finalize-after-asks step" || bad "review job missing the finalize-after note"
printf '%s' "$UBODY" | grep -qi 'conductor' && ok "review job names the conductor for the finalize step" || bad "review job omits the conductor finalize"

hr; echo "V — APPROVED from an UNTRUSTED sender → no merge dispatch"; hr
BARE_V="$TR/v.git"; seed_bare "$BARE_V"
FIX_V="$TR/fix-v.tsv"; RLOG_V="$TR/react-v.log"; : > "$RLOG_V"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T17:00:00Z pr-review-body 4574200000 542 drive-by-rando \
  https://github.com/endojs/endo-but-for-bots/pull/542#pullrequestreview-4574200000 \
  '[APPROVED] LGTM' > "$FIX_V"
run_approval "$TR/state-v" "$BARE_V" "$FIX_V" "$RLOG_V" "$MERGEABLE"
[ "$(todo_count "$BARE_V")" -eq 0 ] && ok "untrusted approval minted no job" || bad "untrusted approval posted a job"
[ "$(cursor_seen "$TR/state-v" "$BARE_V")" = 2026-06-25T17:00:00Z ] && ok "cursor slid past the dropped untrusted approval" || bad "cursor did not slide"

hr; echo "W — APPROVED on a NON-bot repo (endojs/endo) → no merge dispatch"; hr
BARE_W="$TR/w.git"; seed_bare "$BARE_W"
FIX_W="$TR/fix-w.tsv"; RLOG_W="$TR/react-w.log"; : > "$RLOG_W"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T17:30:00Z pr-review-body 4574300000 543 kriskowal \
  https://github.com/endojs/endo/pull/543#pullrequestreview-4574300000 \
  '[APPROVED] Approving.' > "$FIX_W"
run_approval "$TR/state-w" "$BARE_W" "$FIX_W" "$RLOG_W" "$MERGEABLE" "endojs-endo"
nW=$(git clone -q --single-branch --branch "$BRANCH" "$BARE_W" "$TR/wv" && ls -1 "$TR/wv/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$TR/wv"
[ "$nW" -eq 0 ] && ok "approval on endojs/endo upstream minted no merge job" || bad "autonomous merge dispatched on a non-bot repo ($nW)"

hr; echo "X — APPROVED but the PR is ALREADY MERGED → nothing"; hr
BARE_X="$TR/x.git"; seed_bare "$BARE_X"
FIX_X="$TR/fix-x.tsv"; RLOG_X="$TR/react-x.log"; : > "$RLOG_X"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T18:00:00Z pr-review-body 4574400000 544 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/544#pullrequestreview-4574400000 \
  '[APPROVED] Done.' > "$FIX_X"
run_approval "$TR/state-x" "$BARE_X" "$FIX_X" "$RLOG_X" "$MERGEDST"
[ "$(todo_count "$BARE_X")" -eq 0 ] && ok "already-merged PR minted nothing" || bad "posted a job for an already-merged PR"
[ "$(cursor_seen "$TR/state-x" "$BARE_X")" = 2026-06-25T18:00:00Z ] && ok "cursor slid past the already-merged approval" || bad "cursor did not slide"

hr; echo "Y — APPROVED but NOT mergeable/green → shepherd, not a forced merge"; hr
BARE_Y="$TR/y.git"; seed_bare "$BARE_Y"
FIX_Y="$TR/fix-y.tsv"; RLOG_Y="$TR/react-y.log"; : > "$RLOG_Y"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T18:30:00Z pr-review-body 4574500000 545 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/545#pullrequestreview-4574500000 \
  '[APPROVED] Approving; CI should settle.' > "$FIX_Y"
run_approval "$TR/state-y" "$BARE_Y" "$FIX_Y" "$RLOG_Y" "$NOTGREEN"
board_has "$BARE_Y" "$SLUG-pr545-conduct" && bad "forced a conductor merge on a not-green PR" || ok "no conductor job when not mergeable/green"
board_has "$BARE_Y" "$SLUG-pr545-shepherd" && ok "dispatched the shepherd to drive green instead" || bad "no shepherd job for a not-green approval"

# ============================================================================
# Z — SOURCE-level: comment-source-gh.sh must SURFACE a CLEAN APPROVED review even
# when its body is empty AND it carries no inline comments (so the watcher can
# notice the approval), prefixed [APPROVED]. A COMMENTED empty no-inline review is
# still dropped. Same compact-gh-stub shape as Q; the REAL jq processes the JSON.
hr; echo "Z — comment-source-gh.sh surfaces empty-body APPROVED reviews with [APPROVED]"; hr
command -v jq >/dev/null 2>&1 && have_jq_z=1 || have_jq_z=0
if [ "$have_jq_z" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHZ="$TR/gh-z"; mkdir -p "$GHZ"
  cat > "$GHZ/gh" <<'EOF'
#!/bin/bash
# minimal gh stub: PR #7 has one empty-body APPROVED review (id 7001, no inline)
# and one empty-body COMMENTED review (id 7002, no inline → must stay dropped).
# TS (inside the 24h window) injected via the environment so it never rots.
args="$*"; ts="${TS:?TS must be set}"
case "$args" in
  *"/pulls?state=open"*)         printf '[{"number":7,"updated_at":"%s"}]\n' "$ts"; exit 0;;
  *"/issues/comments"*)          printf '[]\n'; exit 0;;
  *"/pulls/comments"*)           printf '[]\n'; exit 0;;
  *"/pulls/7/comments"*)         printf '[]\n'; exit 0;;     # no inline comments at all
  *"/pulls/7/reviews"*)
    printf '[{"id":7001,"state":"APPROVED","body":"","submitted_at":"%s","user":{"login":"kriskowal"},"html_url":"https://x/pull/7#r7001"},{"id":7002,"state":"COMMENTED","body":"","submitted_at":"%s","user":{"login":"kriskowal"},"html_url":"https://x/pull/7#r7002"}]\n' "$ts" "$ts"; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHZ/gh"
  Z_OUT="$TR/z.out"
  env PATH="$GHZ:$PATH" TS="$REV_TS" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-z" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > "$Z_OUT" 2>/dev/null || true
  grep -q $'\t7001\t' "$Z_OUT" && grep -q 'APPROVED' "$Z_OUT" \
    && ok "empty-body APPROVED review 7001 surfaced with [APPROVED]" \
    || bad "APPROVED review 7001 not surfaced (out: $(cat "$Z_OUT"))"
  grep -q $'\t7002\t' "$Z_OUT" \
    && bad "empty no-inline COMMENTED review 7002 was surfaced (should be dropped)" \
    || ok "empty no-inline COMMENTED review 7002 correctly dropped"
fi

# ============================================================================
# AA/BB/CC/DD — MENTION-ONLY PR-author filter. A contributor (0xpatrickdev for
# 0xpatrickbot) asked the bot to IGNORE feedback on PRs/issues THEY author unless
# it directly @-mentions the bot. Driven by the journal mention-only-pr-authors/
# allowlist (here a file fixture). The PR/issue AUTHOR is looked up via a stubbed
# GARDEN_PR_AUTHOR (maps pr-number → login). The filter is an ADDITIONAL gate
# applied BEFORE classify, so a drop never triages or reacts.
MOLIST="$TR/mention-only-allowlist"; printf '# header\n0xpatrickbot\n0xpatrickdev\n' > "$MOLIST"
PRAUTHOR="$TR/pr-author-stub.sh"
cat > "$PRAUTHOR" <<'EOF'
#!/bin/bash
# test fixture: map a PR/issue number to its author login.
case "$2" in
  600) echo 0xpatrickbot ;;   # listed
  601) echo someoutsider ;;   # NOT listed
  602) echo 0xPatrickBot ;;   # listed, mixed-case (case-insensitivity check)
  *)   echo "" ;;
esac
EOF
chmod +x "$PRAUTHOR"
run_mentiononly() {  # run_mentiononly <state> <bare> <fixture> <reactlog>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_MENTION_ONLY_ALLOWLIST="$MOLIST" \
      GARDEN_PR_AUTHOR="$PRAUTHOR" \
      GARDEN_PR_MERGEABLE="${CW_MERGEABLE:-$MERGEABLE_OPEN}" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1
}

hr; echo "AA — directive WITHOUT @bot on a listed author's PR → dropped"; hr
BARE_AA="$TR/aa.git"; seed_bare "$BARE_AA"
FIX_AA="$TR/fix-aa.tsv"; RLOG_AA="$TR/react-aa.log"; : > "$RLOG_AA"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-26T10:00:00Z issue-comment 1600 600 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-1600 \
  'Please rebase #475' > "$FIX_AA"
run_mentiononly "$TR/state-aa" "$BARE_AA" "$FIX_AA" "$RLOG_AA"
board_has "$BARE_AA" "$SLUG-pr600-rebase" && bad "dispatched on a mention-only author's PR without @bot" || ok "dropped: no job for a listed author's PR without @bot"
[ ! -s "$RLOG_AA" ] && ok "no reactji on a mention-only drop" || bad "reactji posted on a mention-only drop: $(cat "$RLOG_AA")"
[ "$(cursor_seen "$TR/state-aa" "$BARE_AA")" = 2026-06-26T10:00:00Z ] && ok "cursor slid past the dropped comment" || bad "cursor did not slide"

hr; echo "BB — SAME directive WITH @bot on the listed author's PR → dispatched"; hr
BARE_BB="$TR/bb.git"; seed_bare "$BARE_BB"
FIX_BB="$TR/fix-bb.tsv"; RLOG_BB="$TR/react-bb.log"; : > "$RLOG_BB"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-26T10:30:00Z issue-comment 1601 600 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-1601 \
  '@kriscendobot please rebase #475' > "$FIX_BB"
run_mentiononly "$TR/state-bb" "$BARE_BB" "$FIX_BB" "$RLOG_BB"
board_has "$BARE_BB" "$SLUG-pr600-rebase" && ok "an @bot mention overrides the filter (job dispatched)" || bad "@bot mention did not override the mention-only filter"
grep -qx "issue-comment 1601 eyes" "$RLOG_BB" && ok "reactji acked the @bot comment" || bad "no reactji on the @bot override ($(cat "$RLOG_BB"))"

hr; echo "CC — directive on a NON-listed author's PR → unaffected"; hr
BARE_CC="$TR/cc.git"; seed_bare "$BARE_CC"
FIX_CC="$TR/fix-cc.tsv"; RLOG_CC="$TR/react-cc.log"; : > "$RLOG_CC"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-26T11:00:00Z issue-comment 1602 601 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/601#issuecomment-1602 \
  'Please rebase #475' > "$FIX_CC"
run_mentiononly "$TR/state-cc" "$BARE_CC" "$FIX_CC" "$RLOG_CC"
board_has "$BARE_CC" "$SLUG-pr601-rebase" && ok "non-listed author's PR is unaffected (job dispatched)" || bad "filter wrongly dropped a non-listed author's PR"

hr; echo "DD — listed author match is CASE-INSENSITIVE → dropped"; hr
BARE_DD="$TR/dd.git"; seed_bare "$BARE_DD"
FIX_DD="$TR/fix-dd.tsv"; RLOG_DD="$TR/react-dd.log"; : > "$RLOG_DD"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-26T11:30:00Z issue-comment 1603 602 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/602#issuecomment-1603 \
  'Please rebase #475' > "$FIX_DD"
run_mentiononly "$TR/state-dd" "$BARE_DD" "$FIX_DD" "$RLOG_DD"
board_has "$BARE_DD" "$SLUG-pr602-rebase" && bad "mixed-case listed author was not matched (dispatched)" || ok "mixed-case author matched case-insensitively (dropped)"

# ============================================================================
# EE — SOURCE-level: comment-source-gh.sh must enumerate ALL open PRs (paginated
# REST), not gh's default 30. Regression-pins endo-but-for-bots #284: a trusted
# COMMENTED body-only review ("Please refresh.") on an OPEN PR that sits BELOW the
# 30-most-recent-by-number cutoff was never surfaced by the old `gh pr list`. The
# stub returns >30 open PRs sorted by activity (updated desc) with #284 carrying a
# FRESH updated_at at the TOP (its review just landed) and a long tail of PRs older
# than the cursor (to exercise the activity-bound early-stop). Assert the source
# EMITS a pr-review-body row for #284 and that the early-stop still reaches it.
hr; echo "EE — comment-source enumerates ALL open PRs (paginated), surfaces a review on an old PR (#284)"; hr
command -v jq >/dev/null 2>&1 && have_jq_ee=1 || have_jq_ee=0
if [ "$have_jq_ee" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHEE="$TR/gh-ee"; mkdir -p "$GHEE"
  cat > "$GHEE/gh" <<'EOF'
#!/bin/bash
# >30 open PRs, sorted by activity (updated desc). #284 is FRESH (top of the list,
# updated_at = TS inside the window) though its number is low; a long tail of
# high-numbered PRs is OLDER (updated_at = OLD, predating the cursor) so the
# activity bound early-stops past them. Only #284 carries a review since the
# cursor; the older tail must never be polled for it to be found — proving
# enumeration is by activity across ALL open PRs, not number. TS/OLD via env so
# the fixture never rots against the handler's 24h floor clamp.
args="$*"; ts="${TS:?TS must be set}"; old="${OLD:?OLD must be set}"
case "$args" in
  *"/pulls?state=open"*)
    # #284 fresh at the top, then 40 older PRs (#460..#421) predating the cursor.
    { printf '[{"number":284,"updated_at":"%s"}' "$ts"
      for i in $(seq 460 -1 421); do printf ',{"number":%s,"updated_at":"%s"}' "$i" "$old"; done
      printf ']\n'; }
    exit 0;;
  *"/pulls/284/comments"*)       printf '[]\n'; exit 0;;     # body-only review, no inline
  *"/pulls/284/reviews"*)        # the missed #284 review: trusted COMMENTED body-only
    printf '[{"id":4587189118,"state":"COMMENTED","body":"Please refresh.","submitted_at":"%s","user":{"login":"kriskowal"},"html_url":"https://x/pull/284#r4587189118"}]\n' "$ts"; exit 0;;
  *"/issues/comments"*)          printf '[]\n'; exit 0;;
  *"/pulls/comments"*)           printf '[]\n'; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHEE/gh"
  EE_OUT="$TR/ee.out"; EE_ERR="$TR/ee.err"
  env PATH="$GHEE:$PATH" TS="$REV_TS" OLD="$OLD_TS" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-ee" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > "$EE_OUT" 2> "$EE_ERR" || true
  grep -q $'\t284\t' "$EE_OUT" && grep -q 'Please refresh.' "$EE_OUT" \
    && ok "review on the low-numbered, recently-active PR #284 is surfaced (no default-30 blindness)" \
    || bad "#284 review not surfaced (out: $(cat "$EE_OUT"))"
  grep -q $'\tpr-review-body\t4587189118\t284\t' "$EE_OUT" \
    && ok "the #284 row is a pr-review-body keyed on the review id 4587189118" \
    || bad "#284 pr-review-body row malformed (out: $(cat "$EE_OUT"))"
  grep -qi 'polled .* open PR' "$EE_ERR" \
    && ok "the activity-bound scan logs how many open PRs it polled (no silent cap)" \
    || bad "no scan-bound log line emitted (err: $(cat "$EE_ERR"))"
fi

# ============================================================================
# FF — SIGNAL REAPING: a systemd stop/restart that SIGTERMs the watcher mid-tick
# must leave NO source descendants behind. The source's `gh --paginate` forks git
# credential helpers; the prior EXIT-only trap never ran on a signalled stop, so
# those gh/git children orphaned into the unit cgroup and the next start flagged
# "Found left-over process (git) in control group while starting unit". Even the
# trap-based shape kept leaking (the 20:57:54 tick logged three left-over git):
# it signalled only the timeout pid and `exit`ed IMMEDIATELY, so the watcher was
# gone while the subtree was still dying asynchronously, and the next 90s tick
# raced that drain. The hardened reap signals the negated PGID directly and then
# WAITS for the group to drain before exiting. Here a source stub stands in for
# the hung fetch: it spawns a long-lived child (recording its pid), then blocks —
# so the watcher is parked in the source call when the SIGTERM lands. The key
# assertion is that the child is gone the INSTANT the watcher exits (a SYNCHRONOUS
# reap), with no grace loop — a regression to the fire-and-forget shape, where the
# child dies a beat AFTER the watcher exits, fails this.
hr; echo "FF — SIGTERM mid-tick SYNCHRONOUSLY reaps the source subtree (no left-over gh/git)"; hr
SIGSRC="$TR/sig-source.sh"; CHILDPID="$TR/sig-child.pid"; rm -f "$CHILDPID"
cat > "$SIGSRC" <<EOF
#!/bin/bash
# stand in for a hung \`gh --paginate\`: fork a long-lived child in this process
# group (as gh forks git credential helpers), record its pid, then block.
sleep 600 &
echo \$! > "$CHILDPID"
wait
EOF
chmod +x "$SIGSRC"
BARE_FF="$TR/ff.git"; seed_bare "$BARE_FF"
env GARDEN_STATE="$TR/state-ff" JOURNAL_REMOTE="$BARE_FF" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$TR/norepos" \
    CW_FIXTURE="$EMPTY_FIX" CW_REACTJI_LOG="$TR/react-ff.log" \
    GARDEN_COMMENT_SOURCE="$SIGSRC" \
    GARDEN_COMMENT_REACTJI="$REACTSTUB" \
    GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
    GARDEN_COMMENT_TRUST=/bin/false \
    GARDEN_TRUSTED_ALLOWLIST=/dev/null \
    "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1 &
WPID=$!
# Wait (bounded) for the source to spawn its long-lived child.
for _ in $(seq 1 100); do [ -s "$CHILDPID" ] && break || sleep 0.1; done
CPID="$(cat "$CHILDPID" 2>/dev/null || true)"
if [ -n "$CPID" ] && kill -0 "$CPID" 2>/dev/null; then
  ok "source subtree alive mid-tick (child pid $CPID)"
else
  bad "source child never started — cannot exercise the reap (CPID='$CPID')"
fi
# SIGTERM the watcher (the systemd-stop signal under KillMode=mixed) and let it
# drain. The watcher's trap must not return until the whole source group is gone,
# so when `wait "$WPID"` returns the child is ALREADY reaped — assert that with NO
# grace loop (a fire-and-forget regression leaves the child briefly alive here).
kill -TERM "$WPID" 2>/dev/null || true
wait "$WPID" 2>/dev/null || true
if [ -n "$CPID" ]; then
  if reaped_within "$CPID"; then
    ok "no left-over gh/git child once the watcher exited (source subtree reaped)"
  else
    bad "left-over child still running after the watcher exited (pid $CPID) — not reaped"
    kill -KILL "$CPID" 2>/dev/null || true
  fi
fi

# ----------------------------------------------------------------------------
# FF2 — the same reap, but the source child IGNORES SIGTERM (a git mid-network
# syscall that outraces TERM). The trap's process-group TERM alone cannot fell it;
# the `timeout` wrapping the source escalates the group to SIGKILL via --kill-after
# and the watcher's `wait` blocks until that lands — so the child is STILL gone
# when the watcher exits. This pins the escalation path the leak depended on.
hr; echo "FF2 — a TERM-ignoring source child is SIGKILL-escalated and reaped before exit"; hr
SIGSRC2="$TR/sig-source2.sh"; CHILDPID2="$TR/sig-child2.pid"; rm -f "$CHILDPID2"
cat > "$SIGSRC2" <<EOF
#!/bin/bash
# stand in for a git child that ignores TERM mid-syscall: fork a child that traps
# and ignores SIGTERM, record its pid, then block. Only a SIGKILL fells it.
( trap '' TERM; exec sleep 600 ) &
echo \$! > "$CHILDPID2"
wait
EOF
chmod +x "$SIGSRC2"
BARE_FF2="$TR/ff2.git"; seed_bare "$BARE_FF2"
# Shorten the source timeout's SIGKILL escalation so the test does not wait the
# full 10s default; the watcher reads --kill-after from GARDEN_COMMENT_KILL_AFTER.
env GARDEN_STATE="$TR/state-ff2" JOURNAL_REMOTE="$BARE_FF2" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$TR/norepos" \
    CW_FIXTURE="$EMPTY_FIX" CW_REACTJI_LOG="$TR/react-ff2.log" \
    GARDEN_COMMENT_SOURCE="$SIGSRC2" \
    GARDEN_COMMENT_KILL_AFTER=2s \
    GARDEN_COMMENT_REACTJI="$REACTSTUB" \
    GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
    GARDEN_COMMENT_TRUST=/bin/false \
    GARDEN_TRUSTED_ALLOWLIST=/dev/null \
    "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1 &
WPID2=$!
for _ in $(seq 1 100); do [ -s "$CHILDPID2" ] && break || sleep 0.1; done
CPID2="$(cat "$CHILDPID2" 2>/dev/null || true)"
[ -n "$CPID2" ] && proc_running "$CPID2" \
  && ok "TERM-ignoring source child alive mid-tick (child pid $CPID2)" \
  || bad "TERM-ignoring source child never started (CPID2='$CPID2')"
kill -TERM "$WPID2" 2>/dev/null || true
wait "$WPID2" 2>/dev/null || true
if [ -n "$CPID2" ]; then
  if reaped_within "$CPID2"; then
    ok "TERM-ignoring child SIGKILL-escalated and reaped after the watcher's stop"
  else
    bad "TERM-ignoring child still running (pid $CPID2) — SIGKILL escalation did not reap it"
    kill -KILL "$CPID2" 2>/dev/null || true
  fi
fi

# ============================================================================
# GI1..GI6 — NO OVERLAP WITH THE ISSUE-INBOX (PR-ONLY mode). When an issue-inbox
# covers this repo, the comment-watcher must SKIP surface=issue-comment (the
# issue-inbox is the sole handler of true-issue comments) while still processing its
# UNIQUE surfaces: a PR's conversation comments (pr-comment), inline review comments,
# and review bodies. Regression-pins kriskowal/garden #9, where BOTH watchers
# dispatched on one issue comment → duplicate responses. PR-only is forced via
# GARDEN_COMMENT_PR_ONLY for the deterministic cases and AUTO-DERIVED from a seeded
# config/garden-repo for the detection case.
run_pronly() {  # run_pronly <state> <bare> <fixture> <reactlog> [logfile] [pr-only]
  local logf="${5:-/dev/null}"
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_TRUST=/bin/false \
      GARDEN_TRUSTED_ALLOWLIST="$ALLOW" \
      GARDEN_COMMENT_PR_ONLY="${6:-1}" \
      GARDEN_PR_MERGEABLE="${CW_MERGEABLE:-$MERGEABLE_OPEN}" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$logf"
}
# auto-derive PR-only from journal state: leave GARDEN_COMMENT_PR_ONLY UNSET.
run_autopronly() {  # run_autopronly <state> <bare> <fixture> <reactlog> [logfile]
  local logf="${5:-/dev/null}"
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_TRUST=/bin/false \
      GARDEN_TRUSTED_ALLOWLIST="$ALLOW" \
      GARDEN_PR_MERGEABLE="${CW_MERGEABLE:-$MERGEABLE_OPEN}" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$logf"
}
seed_inbox_repo() {  # seed_inbox_repo <bare> <owner/name>  (write config/garden-repo)
  local v; v="$(mktemp -d "$TR/sir.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  mkdir -p "$v/config"; printf '%s\n' "$2" > "$v/config/garden-repo"
  git -C "$v" add -A; git -C "$v" "${git_id[@]}" commit -q -m "set garden-repo"
  git -C "$v" push -q origin "$BRANCH" 2>/dev/null
  rm -rf "$v"
}

hr; echo "GI1 — PR-only: a true-issue comment is SKIPPED (issue-inbox owns it), logged, cursor slides"; hr
BARE_GI1="$TR/gi1.git"; seed_bare "$BARE_GI1"
FIX_GI1="$TR/fix-gi1.tsv"; RLOG_GI1="$TR/react-gi1.log"; : > "$RLOG_GI1"; GI1LOG="$TR/gi1.stderr"; : > "$GI1LOG"
# a real directive ('please rebase') from a trusted sender — would normally mint a
# job; in PR-only on surface=issue-comment it must be skipped before classify.
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T10:00:00Z issue-comment 4839300009 9 kriskowal \
  https://github.com/kriskowal/garden/issues/9#issuecomment-4839300009 \
  'Please rebase #5' > "$FIX_GI1"
run_pronly "$TR/state-gi1" "$BARE_GI1" "$FIX_GI1" "$RLOG_GI1" "$GI1LOG"
[ "$(todo_count "$BARE_GI1")" -eq 0 ] && ok "PR-only skipped the true-issue comment (no job)" || bad "issue-comment dispatched in PR-only mode (todo=$(todo_count "$BARE_GI1"))"
[ ! -s "$RLOG_GI1" ] && ok "no reactji on a PR-only-skipped issue comment" || bad "reactji posted on a skipped issue comment: $(cat "$RLOG_GI1")"
grep -q 'PR-only: skipping issue-comment' "$GI1LOG" && ok "the skip is LOGGED (deterministic, not silent)" || bad "no PR-only skip log ($(cat "$GI1LOG"))"
[ "$(cursor_seen "$TR/state-gi1" "$BARE_GI1")" = 2026-06-30T10:00:00Z ] && ok "cursor slid past the skipped issue comment" || bad "cursor did not slide ($(cursor_seen "$TR/state-gi1" "$BARE_GI1"))"

hr; echo "GI2 — PR-only: a PR REVIEW on the same repo IS processed (unique surface kept)"; hr
BARE_GI2="$TR/gi2.git"; seed_bare "$BARE_GI2"
FIX_GI2="$TR/fix-gi2.tsv"; RLOG_GI2="$TR/react-gi2.log"; : > "$RLOG_GI2"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T10:30:00Z pr-review-body 4574900000 5 kriskowal \
  https://github.com/kriskowal/garden/pull/5#pullrequestreview-4574900000 \
  '[CHANGES_REQUESTED] Please convert this to a job.' > "$FIX_GI2"
run_pronly "$TR/state-gi2" "$BARE_GI2" "$FIX_GI2" "$RLOG_GI2"
[ "$(todo_glob "$BARE_GI2" "^$SLUG-pr5-review-")" -eq 1 ] && ok "the PR review IS processed in PR-only mode (per-review job minted)" || bad "PR review dropped in PR-only mode (todo=$(todo_count "$BARE_GI2"))"

hr; echo "GI3 — PR-only: a PR CONVERSATION comment (surface pr-comment) IS processed (not dropped)"; hr
BARE_GI3="$TR/gi3.git"; seed_bare "$BARE_GI3"
FIX_GI3="$TR/fix-gi3.tsv"; RLOG_GI3="$TR/react-gi3.log"; : > "$RLOG_GI3"
# a PR's conversation comment is surface=pr-comment (the source splits it from a
# true-issue comment by html_url) — PR-only keeps it, it is the watcher's domain.
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T11:00:00Z pr-comment 4840000001 5 kriskowal \
  https://github.com/kriskowal/garden/pull/5#issuecomment-4840000001 \
  'Please rebase #5' > "$FIX_GI3"
run_pronly "$TR/state-gi3" "$BARE_GI3" "$FIX_GI3" "$RLOG_GI3"
board_has "$BARE_GI3" "$SLUG-pr5-rebase" && ok "PR-conversation comment processed in PR-only mode (rebase job)" || bad "pr-comment wrongly dropped in PR-only mode"
grep -qx "pr-comment 4840000001 eyes" "$RLOG_GI3" && ok "reactji acked the PR-conversation comment" || bad "no reactji on the pr-comment ($(cat "$RLOG_GI3"))"

hr; echo "GI4 — PR-only AUTO-DERIVED from config/garden-repo → issue-comment skipped"; hr
BARE_GI4="$TR/gi4.git"; seed_bare "$BARE_GI4"; seed_inbox_repo "$BARE_GI4" "endojs/endo-but-for-bots"
FIX_GI4="$TR/fix-gi4.tsv"; RLOG_GI4="$TR/react-gi4.log"; : > "$RLOG_GI4"; GI4LOG="$TR/gi4.stderr"; : > "$GI4LOG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T12:00:00Z issue-comment 4841000001 9 kriskowal \
  https://github.com/endojs/endo-but-for-bots/issues/9#issuecomment-4841000001 \
  'Please rebase #5' > "$FIX_GI4"
run_autopronly "$TR/state-gi4" "$BARE_GI4" "$FIX_GI4" "$RLOG_GI4" "$GI4LOG"
[ "$(todo_count "$BARE_GI4")" -eq 0 ] && ok "auto-derived PR-only skipped the issue comment (no job)" || bad "issue-comment dispatched despite config/garden-repo match (todo=$(todo_count "$BARE_GI4"))"
grep -q 'issue-inbox covers' "$GI4LOG" && ok "the auto-derivation is logged (config/garden-repo signal)" || bad "no auto-derivation log ($(cat "$GI4LOG"))"

hr; echo "GI5 — NO issue-inbox (full coverage): a true-issue comment IS processed"; hr
BARE_GI5="$TR/gi5.git"; seed_bare "$BARE_GI5"
FIX_GI5="$TR/fix-gi5.tsv"; RLOG_GI5="$TR/react-gi5.log"; : > "$RLOG_GI5"
# same fixture as GI1 but no PR-only (no config/garden-repo, no force): full coverage.
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T13:00:00Z issue-comment 4842000001 9 kriskowal \
  https://github.com/endojs/endo-but-for-bots/issues/9#issuecomment-4842000001 \
  'Please rebase #5' > "$FIX_GI5"
run_autopronly "$TR/state-gi5" "$BARE_GI5" "$FIX_GI5" "$RLOG_GI5"
board_has "$BARE_GI5" "$SLUG-pr9-rebase" && ok "with no issue-inbox the issue comment is processed (full coverage)" || bad "issue-comment dropped despite no issue-inbox"

hr; echo "GI6 — cursor advances PAST a DROPPED newest comment (not re-dropped each tick)"; hr
# Secondary fix: a dropped (not-actionable) newest comment must not be re-processed
# on the next tick — its created_at persists as the cursor and the boundary dedup
# then skips it. Regression-pins the re-dropped cid=4839300009 loop. Use an UNTRUSTED
# sender so the comment drops (rc 1), and run TWICE: the DROP is logged on tick 1 but
# NOT on tick 2 (boundary dedup skips it before the classify/drop path).
BARE_GI6="$TR/gi6.git"; seed_bare "$BARE_GI6"
FIX_GI6="$TR/fix-gi6.tsv"; RLOG_GI6="$TR/react-gi6.log"; : > "$RLOG_GI6"
GI6LOG1="$TR/gi6-1.stderr"; : > "$GI6LOG1"; GI6LOG2="$TR/gi6-2.stderr"; : > "$GI6LOG2"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T14:00:00Z issue-comment 4839300009 9 drive-by-rando \
  https://github.com/endojs/endo-but-for-bots/issues/9#issuecomment-4839300009 \
  'just some chatter' > "$FIX_GI6"
run_directive "$TR/state-gi6" "$BARE_GI6" "$FIX_GI6" "$RLOG_GI6" "$GI6LOG1"
grep -q 'DROP:' "$GI6LOG1" && ok "tick 1 drops the not-actionable newest comment" || bad "tick 1 did not drop ($(cat "$GI6LOG1"))"
seen_gi6="$(cursor_seen "$TR/state-gi6" "$BARE_GI6")"
[ "$seen_gi6" = 2026-06-30T14:00:00Z ] && ok "the drop's high-water mark persisted as the cursor" || bad "cursor not advanced past the drop ($seen_gi6)"
run_directive "$TR/state-gi6" "$BARE_GI6" "$FIX_GI6" "$RLOG_GI6" "$GI6LOG2"
grep -q 'DROP:' "$GI6LOG2" && bad "tick 2 RE-DROPPED the same comment (boundary dedup missing)" || ok "tick 2 does NOT re-process the dropped comment (boundary dedup at-or-before cursor)"
[ "$(cursor_seen "$TR/state-gi6" "$BARE_GI6")" = 2026-06-30T14:00:00Z ] && ok "cursor stable on the second tick" || bad "cursor moved on the idempotent second tick"

# ============================================================================
# SS1 — SOURCE-level: comment-source-gh.sh splits the issues/comments stream into
# surface=pr-comment (a PR's conversation comment; html_url .../pull/<n>) vs
# surface=issue-comment (a true issue; html_url .../issues/<n>), with NO extra API
# call. This is what lets PR-only drop ONLY true-issue comments while keeping a PR's
# conversation comments. Same compact-gh-stub shape as Q/Z; the REAL jq processes it.
hr; echo "SS1 — comment-source splits issues/comments into pr-comment vs issue-comment by html_url"; hr
command -v jq >/dev/null 2>&1 && have_jq_ss=1 || have_jq_ss=0
if [ "$have_jq_ss" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHSS="$TR/gh-ss"; mkdir -p "$GHSS"
  cat > "$GHSS/gh" <<'EOF'
#!/bin/bash
# issues/comments returns one comment on a PR (#5, html_url .../pull/5) and one on a
# true issue (#9, html_url .../issues/9). No open PRs / inline feeds for this test.
args="$*"; ts="${TS:?TS must be set}"
case "$args" in
  *"/issues/comments"*)
    printf '[{"id":555001,"created_at":"%s","issue_url":"https://api.github.com/repos/x/y/issues/5","user":{"login":"kriskowal"},"html_url":"https://github.com/x/y/pull/5#issuecomment-555001","body":"on a PR"},{"id":555002,"created_at":"%s","issue_url":"https://api.github.com/repos/x/y/issues/9","user":{"login":"kriskowal"},"html_url":"https://github.com/x/y/issues/9#issuecomment-555002","body":"on an issue"}]\n' "$ts" "$ts"; exit 0;;
  *"/pulls?state=open"*)         printf '[]\n'; exit 0;;
  *"/pulls/comments"*)           printf '[]\n'; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHSS/gh"
  SS_OUT="$TR/ss.out"
  env PATH="$GHSS:$PATH" TS="$REV_TS" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-ss" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > "$SS_OUT" 2>/dev/null || true
  grep -q $'\tpr-comment\t555001\t' "$SS_OUT" \
    && ok "a PR conversation comment is surfaced as pr-comment" \
    || bad "PR conversation comment not classified pr-comment (out: $(cat "$SS_OUT"))"
  grep -q $'\tissue-comment\t555002\t' "$SS_OUT" \
    && ok "a true-issue comment is surfaced as issue-comment" \
    || bad "true-issue comment not classified issue-comment (out: $(cat "$SS_OUT"))"
fi

# ============================================================================
# RCF — SOURCE-level LOST-FETCH invariant: if ANY comment surface fails to enumerate,
# the source must FAIL the tick (exit nonzero), NOT emit a partial subset with rc 0.
# This is the ROOT cause of the r3566529028 inline-review-comment drop: a transient
# blip on `pulls/comments` (the inline review-comment surface) used to be swallowed by
# `| jq … || true`, so the source returned only the surfaces that SUCCEEDED (e.g. the
# issue-comment) with rc 0, the watcher advanced its cursor over them, and the inline
# review comment below the new cursor was never re-polled. Post-fix the source detects
# the failed surface and exits nonzero so the watcher freezes the cursor.
hr; echo "RCF — a FAILED inline-comment surface fails the WHOLE source tick (no silent partial subset)"; hr
command -v jq >/dev/null 2>&1 && have_jq_rcf=1 || have_jq_rcf=0
if [ "$have_jq_rcf" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHRCF="$TR/gh-rcf"; mkdir -p "$GHRCF"
  cat > "$GHRCF/gh" <<'EOF'
#!/bin/bash
# The issue-comment surface SUCCEEDS (returns one comment); the inline review-comment
# surface (repo-wide /pulls/comments) FAILS with a transient signature. Everything
# else is empty-but-successful. The multi-surface "one fails, others succeed" case.
args="$*"; ts="${TS:?TS must be set}"
case "$args" in
  *"/issues/comments"*)
    printf '[{"id":100,"created_at":"%s","issue_url":"https://api.github.com/repos/x/y/issues/678","user":{"login":"kriskowal"},"html_url":"https://github.com/x/y/pull/678#issuecomment-100","body":"unrelated chatter"}]\n' "$ts"; exit 0;;
  *"/pulls?state=open"*)     printf '[{"number":678,"updated_at":"%s"}]\n' "$ts"; exit 0;;
  *"/pulls/678/comments"*)   printf '[]\n'; exit 0;;
  *"/pulls/678/reviews"*)    printf '[]\n'; exit 0;;
  *"/pulls/comments"*)       echo "HTTP 503: Service Unavailable (pulls/comments)" >&2; exit 1;;   # the inline surface FAILS
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHRCF/gh"
  RCF_OUT="$TR/rcf.out"; RCF_ERR="$TR/rcf.err"
  set +e
  env PATH="$GHRCF:$PATH" TS="$REV_TS" GARDEN_GH_API_ATTEMPTS=1 GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-rcf" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > "$RCF_OUT" 2> "$RCF_ERR"
  rcf_rc=$?
  set -e
  [ "$rcf_rc" -ne 0 ] && ok "the source exits NONZERO when one surface fails (rc=$rcf_rc) — the tick fails, cursor cannot advance" || bad "source returned 0 despite a failed surface (silent-partial regression!)"
  grep -qi 'FETCH INCOMPLETE\|FETCH-FAIL' "$RCF_ERR" && ok "the incomplete enumeration is LOGGED (diagnosable, not silent)" || bad "no FETCH-INCOMPLETE log ($(cat "$RCF_ERR"))"
  grep -qiE 'HTTP 50[0-9]|503' "$RCF_ERR" && ok "the underlying transient gh signature reaches stderr (so the watcher classifies it transient → skip, not die)" || bad "transient signature not surfaced ($(cat "$RCF_ERR"))"
fi

# ============================================================================
# RATE — GitHub PRIMARY quota exhaustion is not a millisecond-scale transient.
# The source must make one request total (one helper attempt, then short-circuit
# every remaining surface), return EX_TEMPFAIL, and leave the watcher cursor frozen.
hr; echo "RATE — primary GitHub quota short-circuits surfaces and propagates rc 75 with a frozen cursor"; hr
command -v jq >/dev/null 2>&1 && have_jq_rate=1 || have_jq_rate=0
if [ "$have_jq_rate" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHRATE="$TR/gh-rate"; mkdir -p "$GHRATE"
  RATE_CALLS="$TR/rate.calls"; : > "$RATE_CALLS"
  cat > "$GHRATE/gh" <<'EOF'
#!/bin/bash
if [ "${1:-}" = auth ]; then
  printf 'test-token\n'
  exit 0
fi
echo "$*" >> "${RATE_CALLS:?}"
if [ "${RATE_LATE:-0}" = 1 ]; then
  case "$*" in
    *"/issues/comments"*) printf '[]\n'; exit 0 ;;
    *"/pulls?state=open"*) printf '[{"number":1,"updated_at":"2099-01-01T00:00:00Z"},{"number":2,"updated_at":"2099-01-01T00:00:00Z"}]\n'; exit 0 ;;
  esac
fi
echo "gh: API rate limit exceeded for user ID 279080640 (HTTP 403)" >&2
exit 1
EOF
  chmod +x "$GHRATE/gh"
  RATE_SOURCE_ERR="$TR/rate-source.err"
  set +e
  env PATH="$GHRATE:$PATH" RATE_CALLS="$RATE_CALLS" GARDEN_GH_API_ATTEMPTS=4 \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-rate-source" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    >/dev/null 2>"$RATE_SOURCE_ERR"
  rate_source_rc=$?
  set -e
  [ "$rate_source_rc" -eq 75 ] \
    && ok "primary-quota source exits rc 75" \
    || bad "primary-quota source exited $rate_source_rc (want 75)"
  [ "$(wc -l < "$RATE_CALLS")" -eq 1 ] \
    && ok "primary quota made exactly one gh attempt, then short-circuited all remaining surfaces" \
    || bad "primary quota made $(wc -l < "$RATE_CALLS") gh requests (want 1): $(cat "$RATE_CALLS")"
  grep -qi 'RATE LIMITED' "$RATE_SOURCE_ERR" \
    && ok "primary-quota degrade emits a RATE LIMITED log" \
    || bad "primary-quota degrade did not log RATE LIMITED ($(cat "$RATE_SOURCE_ERR"))"

  # Let two early surfaces succeed, then exhaust quota on PR #1's review-id map.
  # The source must not request that PR's reviews, PR #2, repo-wide inline comments,
  # or the repo-gone probe after the quota signature has been recorded.
  : > "$RATE_CALLS"
  set +e
  env PATH="$GHRATE:$PATH" RATE_CALLS="$RATE_CALLS" RATE_LATE=1 GARDEN_GH_API_ATTEMPTS=4 \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-rate-late" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    >/dev/null 2>"$TR/rate-late.err"
  rate_late_rc=$?
  set -e
  [ "$rate_late_rc" -eq 75 ] && [ "$(wc -l < "$RATE_CALLS")" -eq 3 ] \
    && ok "quota discovered inside the PR walk stops all later PR/surface requests" \
    || bad "late quota did not short-circuit (rc=$rate_late_rc calls=$(wc -l < "$RATE_CALLS")): $(cat "$RATE_CALLS")"
fi

BARE_RATE="$TR/rate.git"; seed_bare "$BARE_RATE"
RATE_WATCH_SOURCE="$TR/rate-watch-source.sh"
cat > "$RATE_WATCH_SOURCE" <<'EOF'
#!/bin/bash
# A partial row must be discarded because rc 75 means enumeration was incomplete.
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-08-06T13:30:50Z pr-comment 403001 678 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/678#issuecomment-403001 \
  'Please rebase.'
echo 'RATE LIMITED: GitHub primary API quota exhausted' >&2
exit 75
EOF
chmod +x "$RATE_WATCH_SOURCE"
RATE_WATCH_ERR="$TR/rate-watch.err"
set +e
env GARDEN_STATE="$TR/state-rate-watch" JOURNAL_REMOTE="$BARE_RATE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$TR/norepos" GARDEN_COMMENT_SOURCE="$RATE_WATCH_SOURCE" \
    GARDEN_NO_MAINTAINER_ALERT=1 \
    "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$RATE_WATCH_ERR"
rate_watch_rc=$?
set -e
[ "$rate_watch_rc" -eq 75 ] \
  && ok "watcher propagates source rc 75 for self-heal normalization" \
  || bad "watcher returned $rate_watch_rc (want propagated 75)"
[ -z "$(cursor_seen "$TR/state-rate-watch" "$BARE_RATE")" ] \
  && ok "rc 75 freezes the cursor below the partially enumerated row" \
  || bad "rc 75 advanced the cursor ($(cursor_seen "$TR/state-rate-watch" "$BARE_RATE"))"
if bash -c 'source "$1"; is_nonattributable_rc "$2"' _ "$JOBS/common.sh" "$rate_watch_rc"; then
  ok "rc 75 is accepted by is_nonattributable_rc"
else
  bad "rc 75 was not accepted by is_nonattributable_rc"
fi

# Exercise the watcher's generic stderr classifier with the production failure
# shape: a transient signature on the first line followed by enough output to make
# the former `printf | grep -q` producer hit EPIPE under pipefail. This path must
# absorb the tick directly (WARN + exit 0), never reach FATAL.
RATE_BLOB_SOURCE="$TR/rate-blob-source.sh"
cat > "$RATE_BLOB_SOURCE" <<'EOF'
#!/bin/bash
printf '%s\n' 'gh: API rate limit exceeded for user ID 279080640 (HTTP 403)' >&2
dd if=/dev/zero bs=1M count=3 2>/dev/null | tr '\0' x >&2
exit 1
EOF
chmod +x "$RATE_BLOB_SOURCE"
RATE_BLOB_ERR="$TR/rate-blob.err"
set +e
env GARDEN_STATE="$TR/state-rate-blob" JOURNAL_REMOTE="$BARE_RATE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$TR/norepos" GARDEN_COMMENT_SOURCE="$RATE_BLOB_SOURCE" \
    GARDEN_NO_MAINTAINER_ALERT=1 \
    "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$RATE_BLOB_ERR"
rate_blob_rc=$?
set -e
[ "$rate_blob_rc" -eq 0 ] \
  && ok "multi-megabyte rate-limit stderr is absorbed with watcher exit 0" \
  || bad "multi-megabyte rate-limit stderr crashed watcher (rc=$rate_blob_rc)"
grep -q 'WARN: comment source hit a transient gh-api blip' "$RATE_BLOB_ERR" \
  && ok "rate-limited source emits the transient gh-api skip WARN" \
  || bad "rate-limited source missed transient WARN ($(tail -c 500 "$RATE_BLOB_ERR"))"
grep -q 'FATAL:' "$RATE_BLOB_ERR" \
  && bad "rate-limited source emitted FATAL" \
  || ok "rate-limited source did not emit FATAL"

# ============================================================================
# GONE — SOURCE-level REPO-GONE degrade: when the REPO ITSELF is definitively 404,
# every surface fails, so the LOST-FETCH invariant (RCF above) would exit nonzero on
# EVERY tick forever — the watcher dies structurally, systemd re-runs it, and the unit
# fails in perpetuity against a repo that will never come back (the kriscendobot/garden
# crash-loop). A gone repo must DEACTIVATE gracefully instead: exit 0, log it, and
# alert the maintainer ONCE. The narrowness matters as much as the degrade, so the
# second half asserts a repo that still ANSWERS keeps the exit-1 freeze.
hr; echo "GONE — a definitive repo-level 404 DEACTIVATES the watch (exit 0), never crash-loops"; hr
command -v jq >/dev/null 2>&1 && have_jq_gone=1 || have_jq_gone=0
if [ "$have_jq_gone" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHGONE="$TR/gh-gone"; mkdir -p "$GHGONE"
  cat > "$GHGONE/gh" <<'EOF'
#!/bin/bash
# The repo does not exist: EVERY surface — and the repo probe itself — returns the
# definitive gh 404 signature. GONE_PROBE_OK=1 flips ONLY the repo probe to success,
# standing in for "the repo is fine, one surface is merely broken".
args="$*"
case "$args" in
  *"--jq .full_name"*|*"--jq"*"full_name"*)
    if [ "${GONE_PROBE_OK:-0}" = 1 ]; then printf 'endojs/endo-but-for-bots\n'; exit 0; fi
    echo "gh: Not Found (HTTP 404)" >&2; exit 1;;
esac
echo "gh: Not Found (HTTP 404)" >&2; exit 1
EOF
  chmod +x "$GHGONE/gh"
  GONE_ALERTS="$TR/gone-alerts.log"; : > "$GONE_ALERTS"
  GONE_ALERT_CMD="$TR/gone-alert.sh"
  cat > "$GONE_ALERT_CMD" <<EOF
#!/bin/bash
printf '%s\t%s\n' "\$1" "\$2" >> "$GONE_ALERTS"
EOF
  chmod +x "$GONE_ALERT_CMD"
  GONE_OUT="$TR/gone.out"; GONE_ERR="$TR/gone.err"
  set +e
  env PATH="$GHGONE:$PATH" GARDEN_GH_API_ATTEMPTS=1 GARDEN_STATE="$TR/state-gone" \
    GARDEN_ALERT_CMD="$GONE_ALERT_CMD" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > "$GONE_OUT" 2> "$GONE_ERR"
  gone_rc=$?
  set -e
  [ "$gone_rc" -eq 0 ] && ok "a definitive repo-level 404 exits 0 (deactivated) — no systemd crash-loop" || bad "repo-level 404 exited $gone_rc (crash-loop regression: the unit fails every tick forever)"
  [ ! -s "$GONE_OUT" ] && ok "the gone repo emits NO comment rows (the watcher simply goes quiet)" || bad "gone repo emitted rows ($(cat "$GONE_OUT"))"
  grep -qi 'REPO GONE' "$GONE_ERR" && ok "the deactivation is LOGGED (diagnosable, not a silent no-op)" || bad "no REPO-GONE log ($(cat "$GONE_ERR"))"
  grep -q 'comment-watch-repo-gone-endojs-endo-but-for-bots' "$GONE_ALERTS" && ok "the maintainer is alerted under the per-slug dedup key" || bad "no maintainer alert ($(cat "$GONE_ALERTS"))"

  # Alert ONCE: a second tick against the same state must be throttled, so a
  # per-minute timer cannot flood the inbox with the same dead repo.
  set +e
  env PATH="$GHGONE:$PATH" GARDEN_GH_API_ATTEMPTS=1 GARDEN_STATE="$TR/state-gone" \
    GARDEN_ALERT_CMD="$GONE_ALERT_CMD" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    >/dev/null 2>&1
  gone_rc2=$?
  set -e
  [ "$gone_rc2" -eq 0 ] && ok "a repeat tick on the gone repo still exits 0" || bad "repeat tick exited $gone_rc2"
  [ "$(grep -c 'comment-watch-repo-gone' "$GONE_ALERTS")" -eq 1 ] && ok "the alert fires ONCE (throttled per slug), not every tick" || bad "alert not throttled ($(grep -c 'comment-watch-repo-gone' "$GONE_ALERTS") copies)"

  # Narrowness: the repo ANSWERS, only the surfaces are broken → the LOST-FETCH
  # invariant must still freeze the cursor (exit 1). The degrade must not become a
  # blanket "any 404 is fine" that silently drops real comments.
  set +e
  env PATH="$GHGONE:$PATH" GONE_PROBE_OK=1 GARDEN_GH_API_ATTEMPTS=1 GARDEN_STATE="$TR/state-gone-live" \
    GARDEN_NO_MAINTAINER_ALERT=1 \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > /dev/null 2> "$TR/gone-live.err"
  gone_live_rc=$?
  set -e
  [ "$gone_live_rc" -ne 0 ] && ok "a LIVE repo with failing surfaces still exits nonzero (cursor frozen, LOST-FETCH intact)" || bad "the repo-gone degrade swallowed a real lost fetch (silent-drop regression!)"
  grep -qi 'FETCH INCOMPLETE' "$TR/gone-live.err" && ok "the live-repo path still logs FETCH INCOMPLETE" || bad "live-repo path lost its FETCH-INCOMPLETE log ($(cat "$TR/gone-live.err"))"
fi

# ============================================================================
# CD — all per-repo comment watchers on a host share one bounded GitHub API
# cooldown. The first 5xx/HTML/rate-limit detector records the window and emits the
# warning; a sibling tick skips before invoking its source and is completely quiet.
# Expiry re-arms detection, proving the window cannot become an unbounded blackout.
hr; echo "CD — one API blip warns once and quietly cools sibling repo ticks"; hr
BARE_CD="$TR/cd.git"; seed_bare "$BARE_CD"
CD_SOURCE="$TR/cd-source.sh"; CD_COUNT="$TR/cd-source.count"; : > "$CD_COUNT"
cat > "$CD_SOURCE" <<'EOF'
#!/bin/bash
n=$(( $(cat "${CD_COUNT:?}" 2>/dev/null || echo 0) + 1 ))
printf '%s\n' "$n" > "$CD_COUNT"
printf '%s\n' 'HTTP 503: Service Unavailable' >&2
exit 1
EOF
chmod +x "$CD_SOURCE"
run_cd() {  # run_cd <slug> <stderr-file>
  env GARDEN_STATE="$TR/state-cd" JOURNAL_REMOTE="$BARE_CD" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" GARDEN_COMMENT_SOURCE="$CD_SOURCE" CD_COUNT="$CD_COUNT" \
      GARDEN_COMMENT_API_COOLDOWN_SECS=300 GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/comment-watcher.sh" "$1" >/dev/null 2>"$2"
}
CD_LOG1="$TR/cd-1.stderr"; CD_LOG2="$TR/cd-2.stderr"; CD_LOG3="$TR/cd-3.stderr"
run_cd endojs-endo-but-for-bots "$CD_LOG1"
[ "$(cat "$CD_COUNT")" -eq 1 ] && ok "initial detector invoked its source once" || bad "initial source count $(cat "$CD_COUNT")"
[ "$(grep -c 'WARN: comment source hit a transient gh-api blip' "$CD_LOG1" || true)" -eq 1 ] \
  && ok "initial detector emitted exactly one API-blip warning" || bad "initial warning output ($(cat "$CD_LOG1"))"
grep -q 'source:.*HTTP 503' "$CD_LOG1" && bad "initial transient leaked an extra source warning" || ok "initial warning is consolidated (raw transient stderr suppressed)"

# Different slug, same GARDEN_STATE: it must stop at the shared marker, before even
# deriving/fetching repo state. Quiet means no source call and zero stderr bytes.
run_cd kriscendobot-garden "$CD_LOG2"
[ "$(cat "$CD_COUNT")" -eq 1 ] && ok "sibling tick skipped without invoking its source" || bad "sibling invoked source (count $(cat "$CD_COUNT"))"
[ ! -s "$CD_LOG2" ] && ok "sibling cooldown skip was quiet" || bad "sibling emitted output ($(cat "$CD_LOG2"))"

# Expire the marker deterministically (no sleep); the next tick must probe again and
# own a fresh warning, demonstrating that sibling observations never extend a window.
printf '0\nexpired-test\n' > "$TR/state-cd/comment-watcher/api-cooldown"
run_cd kriscendobot-garden "$CD_LOG3"
[ "$(cat "$CD_COUNT")" -eq 2 ] && ok "expired cooldown re-enabled source polling" || bad "expired window did not re-arm (count $(cat "$CD_COUNT"))"
[ "$(grep -c 'WARN: comment source hit a transient gh-api blip' "$CD_LOG3" || true)" -eq 1 ] \
  && ok "the first detector after expiry emitted one fresh warning" || bad "post-expiry warning output ($(cat "$CD_LOG3"))"

# ----------------------------------------------------------------------------
# RCF2 — WATCHER-level freeze-then-recover: a tick whose source fails (a surface
# blip) must NOT advance the cursor; a subsequent HEALTHY tick then observes the
# previously-un-enumerated inline review comment and posts its job. This closes the
# full loop the r3566529028 drop exposed: a lost FETCH re-polls, never drops. A
# toggle stub stands in for comment-source-gh.sh: tick 1 exits nonzero with a
# transient signature (having emitted only a partial subset); tick 2 succeeds and
# emits the inline review comment that tick 1 could not enumerate.
hr; echo "RCF2 — source-fetch failure freezes the cursor; the next healthy tick recovers the review comment"; hr
BARE_RCF="$TR/rcf2.git"; seed_bare "$BARE_RCF"
RCF_MARKER="$TR/rcf2.marker"; rm -f "$RCF_MARKER"
RLOG_RCF="$TR/react-rcf2.log"; : > "$RLOG_RCF"
RCF_LOG1="$TR/rcf2-1.stderr"; : > "$RCF_LOG1"; RCF_LOG2="$TR/rcf2-2.stderr"; : > "$RCF_LOG2"
RCF_SRC="$TR/rcf2-source.sh"
cat > "$RCF_SRC" <<EOF
#!/bin/bash
# Tick 1 (no marker): the inline review-comment surface failed — exit nonzero with a
# transient signature, having emitted only the SUBSET that succeeded. The watcher must
# DISCARD this and NOT advance the cursor. Tick 2 (marker present): healthy — emit the
# inline review comment tick 1 could not enumerate (folds to one 'review' job).
if [ ! -f "$RCF_MARKER" ]; then
  : > "$RCF_MARKER"
  printf '%s\n' 'HTTP 503: Service Unavailable (pulls/comments)' >&2
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \\
    2026-07-12T13:00:00Z issue-comment 100 678 kriskowal \\
    https://github.com/endojs/endo-but-for-bots/pull/678#issuecomment-100 'unrelated chatter'
  exit 1
fi
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \\
  2026-07-12T14:56:18Z pr-review-comment 3566529028 678 kriskowal \\
  https://github.com/endojs/endo-but-for-bots/pull/678#discussion_r3566529028 \\
  'Rename search-powers.js.' 4600000000
EOF
chmod +x "$RCF_SRC"
run_rcf() {  # run_rcf <logfile>
  env GARDEN_STATE="$TR/state-rcf2" JOURNAL_REMOTE="$BARE_RCF" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      GARDEN_COMMENT_API_COOLDOWN_SECS=0 \
      CW_FIXTURE=/dev/null CW_REACTJI_LOG="$RLOG_RCF" \
      GARDEN_COMMENT_SOURCE="$RCF_SRC" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_REPLY="$REPLYSTUB" CW_REPLY_LOG=/dev/null \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_TRUST=/bin/false \
      GARDEN_TRUSTED_ALLOWLIST="$ALLOW" \
      GARDEN_PR_MERGEABLE="$MERGEABLE_OPEN" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$1"
}
# Tick 1: the source fails (transient) → the watcher skips the tick, cursor frozen.
run_rcf "$RCF_LOG1"
grep -qi 'transient\|skipping tick' "$RCF_LOG1" && ok "tick 1: the failed source is absorbed as transient (tick skipped)" || bad "tick 1 did not skip on a failed source ($(cat "$RCF_LOG1"))"
[ "$(todo_glob "$BARE_RCF" "^$SLUG-pr678-review-")" -eq 0 ] && ok "tick 1: no review job posted (the surface never enumerated it)" || bad "tick 1 posted a job despite the failed fetch"
[ -z "$(cursor_seen "$TR/state-rcf2" "$BARE_RCF")" ] && ok "tick 1: cursor did NOT advance past the un-enumerated review comment (frozen)" || bad "tick 1 advanced the cursor despite the failed fetch ($(cursor_seen "$TR/state-rcf2" "$BARE_RCF"))"
# Tick 2: healthy source now surfaces the inline review comment → it becomes a job.
run_rcf "$RCF_LOG2"
[ "$(todo_glob "$BARE_RCF" "^$SLUG-pr678-review-")" -eq 1 ] && ok "tick 2: the recovered inline review comment posted exactly one 'review' job" || bad "tick 2 did not recover the dropped review comment (todo=$(todo_count "$BARE_RCF"))"
[ "$(cursor_seen "$TR/state-rcf2" "$BARE_RCF")" = 2026-07-12T14:56:18Z ] && ok "tick 2: cursor advanced past the now-enumerated review comment" || bad "tick 2 cursor wrong ($(cursor_seen "$TR/state-rcf2" "$BARE_RCF"))"

# ============================================================================
# DEDUP1 (watcher) — an inline-bearing review and its SUBSUMED inline comment in the
# SAME poll must yield EXACTLY ONE job (the per-review `review` job), not two. The
# source marks the standalone comment surface=pr-review-comment-subsumed; the watcher
# logs it and slides the cursor past it WITHOUT minting a second job. Regression-pins
# endo-but-for-bots #548, where THREE inline comments minted SIX racing jobs.
hr; echo "DEDUP1 — inline review + its subsumed comment → exactly ONE job, slide logged"; hr
BARE_DUP="$TR/dup.git"; seed_bare "$BARE_DUP"
FIX_DUP="$TR/fix-dup.tsv"; RLOG_DUP="$TR/react-dup.log"; : > "$RLOG_DUP"; DUPLOG="$TR/dup.stderr"; : > "$DUPLOG"
{
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    2026-06-30T20:00:00Z pr-review-body 4597002890 548 kriskowal \
    https://github.com/endojs/endo-but-for-bots/pull/548#pullrequestreview-4597002890 \
    '[INLINE-REVIEW] '
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    2026-06-30T20:00:01Z pr-review-comment-subsumed 4597002999 548 kriskowal \
    https://github.com/endojs/endo-but-for-bots/pull/548#discussion_r4597002999 \
    'Consider a plain re-export here.'
} > "$FIX_DUP"
run_directive "$TR/state-dup" "$BARE_DUP" "$FIX_DUP" "$RLOG_DUP" "$DUPLOG"
[ "$(todo_count "$BARE_DUP")" -eq 1 ] && ok "exactly ONE job for an inline review + its subsumed comment (not two)" || bad "expected one job, got $(todo_count "$BARE_DUP")"
[ "$(todo_glob "$BARE_DUP" "^$SLUG-pr548-review-")" -eq 1 ] && ok "the one job is the per-review 'review' job" || bad "no per-review 'review' job minted"
grep -q 'SUBSUMED:' "$DUPLOG" && ok "the subsumed comment is LOGGED (no silent drop)" || bad "no SUBSUMED log line ($(cat "$DUPLOG"))"
[ ! -s "$RLOG_DUP" ] && ok "no reactji (review body unreactable; subsumed comment gets none)" || bad "unexpected reactji: $(cat "$RLOG_DUP")"
[ "$(cursor_seen "$TR/state-dup" "$BARE_DUP")" = 2026-06-30T20:00:01Z ] && ok "cursor advanced past BOTH the review and the subsumed comment" || bad "cursor not advanced past the subsumed comment ($(cursor_seen "$TR/state-dup" "$BARE_DUP"))"

# ============================================================================
# DEDUP2 (source) — comment-source-gh.sh must mark an inline comment whose parent
# review is inline-surfaced this poll as pr-review-comment-subsumed, while KEEPING the
# actionable pr-review-comment surface for a comment whose review is NOT surfaced
# (here, tied to a review on a CLOSED PR not in the open list). Same compact-gh-stub
# shape as Q/Z; the REAL jq processes the JSON.
hr; echo "DEDUP2 — comment-source marks an inline-surfaced review's comment subsumed, keeps the rest"; hr
command -v jq >/dev/null 2>&1 && have_jq_dd=1 || have_jq_dd=0
if [ "$have_jq_dd" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHDD="$TR/gh-dd"; mkdir -p "$GHDD"
  cat > "$GHDD/gh" <<'EOF'
#!/bin/bash
# PR #4 is open with an inline-bearing empty-body review 9001 (surfaced
# [INLINE-REVIEW]) and a no-inline review 9002. The repo-wide pulls/comments feed
# returns TWO inline comments: id 111 tied to review 9001 (SUBSUMED — its review is
# surfaced this poll) and id 222 tied to review 9003 on a CLOSED PR #99 NOT in the
# open list (so 9003 is never surfaced → the comment is KEPT actionable). TS via env.
args="$*"; ts="${TS:?TS must be set}"
case "$args" in
  *"/pulls?state=open"*)         printf '[{"number":4,"updated_at":"%s"}]\n' "$ts"; exit 0;;
  *"/issues/comments"*)          printf '[]\n'; exit 0;;
  *"/pulls/4/comments"*)         printf '%s\n' '[{"pull_request_review_id":9001}]'; exit 0;;
  *"/pulls/4/reviews"*)
    printf '[{"id":9001,"state":"COMMENTED","body":"","submitted_at":"%s","user":{"login":"kriskowal"},"html_url":"https://x/pull/4#r9001"},{"id":9002,"state":"COMMENTED","body":"","submitted_at":"%s","user":{"login":"kriskowal"},"html_url":"https://x/pull/4#r9002"}]\n' "$ts" "$ts"; exit 0;;
  *"/pulls/comments"*)
    printf '[{"id":111,"created_at":"%s","pull_request_review_id":9001,"pull_request_url":"https://api.github.com/repos/x/y/pulls/4","user":{"login":"kriskowal"},"html_url":"https://github.com/x/y/pull/4#discussion_r111","body":"subsumed inline"},{"id":222,"created_at":"%s","pull_request_review_id":9003,"pull_request_url":"https://api.github.com/repos/x/y/pulls/99","user":{"login":"kriskowal"},"html_url":"https://github.com/x/y/pull/99#discussion_r222","body":"standalone inline"}]\n' "$ts" "$ts"; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHDD/gh"
  DD_OUT="$TR/dd.out"
  env PATH="$GHDD:$PATH" TS="$REV_TS" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-dd" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots "$SINCE_TS" kriscendobot \
    > "$DD_OUT" 2>/dev/null || true
  grep -q $'\tpr-review-comment-subsumed\t111\t' "$DD_OUT" \
    && ok "an inline comment whose review is inline-surfaced is marked subsumed" \
    || bad "comment 111 not marked subsumed (out: $(cat "$DD_OUT"))"
  grep -q $'\tpr-review-comment\t111\t' "$DD_OUT" \
    && bad "comment 111 ALSO emitted as a plain pr-review-comment (the duplicate the fix removes)" \
    || ok "the subsumed comment is NOT also emitted as a plain pr-review-comment"
  grep -q $'\tpr-review-comment\t222\t' "$DD_OUT" \
    && ok "a comment whose review is NOT inline-surfaced keeps the actionable pr-review-comment surface" \
    || bad "comment 222 wrongly suppressed or mis-surfaced (out: $(cat "$DD_OUT"))"
fi

# ============================================================================
# DEDUP3 (watcher) — the CROSS-SURFACE key collapse. A pr-review-comment (the inline
# comment, NON-subsumed) and its parent review's [INLINE-REVIEW] pr-review-body, both
# reaching the watcher for ONE review id, must yield EXACTLY ONE job basename — the
# per-review `review` job keyed on the review id. Before the fix, the comment took the
# `*` fallback (keyed on the comment id) while the review-body took `review)` (keyed on
# the review id), so two differently-keyed jobs minted for one review (the #548
# erights duplicate-fold: gardener d6db5f + designer b93848 both folded review
# 4597029908). The fix surfaces the inline comment's pull_request_review_id as the 8th
# TSV column and keys its job on that review id, so verify_posted collapses both
# surfaces onto the single review job. (In a live poll the source would mark the
# co-surfaced comment subsumed; this case proves the KEY collapse regardless, which is
# what the across-tick dedup relies on.)
hr; echo "DEDUP3 — a pr-review-comment + its review's pr-review-body (one review id) → exactly ONE job"; hr
BARE_DUP3="$TR/dup3.git"; seed_bare "$BARE_DUP3"
FIX_DUP3="$TR/fix-dup3.tsv"; RLOG_DUP3="$TR/react-dup3.log"; : > "$RLOG_DUP3"; DUP3LOG="$TR/dup3.stderr"; : > "$DUP3LOG"
{
  # the parent review (review id 4597029908) surfaced as an inline-bearing body.
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    2026-06-30T21:00:00Z pr-review-body 4597029908 548 kriskowal \
    https://github.com/endojs/endo-but-for-bots/pull/548#pullrequestreview-4597029908 \
    '[INLINE-REVIEW] '
  # the standalone inline comment (NON-subsumed) — 8 columns, the 8th the review id.
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    2026-06-30T21:00:01Z pr-review-comment 4597029999 548 kriskowal \
    https://github.com/endojs/endo-but-for-bots/pull/548#discussion_r4597029999 \
    'Consider a plain re-export here.' 4597029908
} > "$FIX_DUP3"
run_directive "$TR/state-dup3" "$BARE_DUP3" "$FIX_DUP3" "$RLOG_DUP3" "$DUP3LOG"
[ "$(todo_count "$BARE_DUP3")" -eq 1 ] && ok "exactly ONE job for a review-body + its inline comment keyed on one review id (not two)" || bad "expected one job, got $(todo_count "$BARE_DUP3")"
[ "$(todo_glob "$BARE_DUP3" "^$SLUG-pr548-review-")" -eq 1 ] && ok "the one job is the per-review 'review' job keyed on the review id" || bad "no per-review 'review' job, or duplicated (todo_glob=$(todo_glob "$BARE_DUP3" "^$SLUG-pr548-review-"))"
grep -q 'FOLD:' "$DUP3LOG" && ok "the inline comment fold onto the review job is LOGGED (not silent)" || bad "no FOLD log line ($(cat "$DUP3LOG"))"
[ "$(cursor_seen "$TR/state-dup3" "$BARE_DUP3")" = 2026-06-30T21:00:01Z ] && ok "cursor advanced past BOTH surfaces" || bad "cursor not advanced past both ($(cursor_seen "$TR/state-dup3" "$BARE_DUP3"))"

# DEDUP4 (watcher) — the #544 ACROSS-TICK canonical-key collapse. A COMMENTED review
# with an EMPTY top-level body and ONE inline comment is the exact #544 fan-out: the
# review-body surface ([INLINE-REVIEW] + empty body) mints a per-review `review` job in
# one tick, and in a LATER tick the same review's inline comment surfaces ALONE
# (NON-subsumed, because the review-body was not re-surfaced that poll). Both must
# resolve to the SAME canonical (repo, pr, review_id) base, so the second producer's
# post is an idempotent verify_posted SKIP — never a duplicate `attention`/comment-id
# sibling (the #544 jobs were review-* AND comment-id-keyed siblings for one review).
hr; echo "DEDUP4 — #544 across-tick: empty-body review then its inline comment → one job, idempotent skip"; hr
BARE_DUP4="$TR/dup4.git"; seed_bare "$BARE_DUP4"
RLOG_DUP4="$TR/react-dup4.log"; : > "$RLOG_DUP4"; DUP4LOG="$TR/dup4.stderr"; : > "$DUP4LOG"
# tick 1 — the empty-body COMMENTED review surfaces as an inline-bearing review-body
# (cid == the review id 4604000111). A 'gauntlet'-returning fallback stub would still
# never be consulted (review-body classifies as `review` directly).
FIX_DUP4A="$TR/fix-dup4a.tsv"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T22:00:00Z pr-review-body 4604000111 544 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/544#pullrequestreview-4604000111 \
  '[INLINE-REVIEW] ' > "$FIX_DUP4A"
run_directive "$TR/state-dup4" "$BARE_DUP4" "$FIX_DUP4A" "$RLOG_DUP4" "$DUP4LOG"
[ "$(todo_count "$BARE_DUP4")" -eq 1 ] && ok "tick 1: the empty-body review minted exactly one job" || bad "tick 1 job count $(todo_count "$BARE_DUP4")"
[ "$(todo_glob "$BARE_DUP4" "^$SLUG-pr544-review-")" -eq 1 ] && ok "tick 1: the job is the per-review 'review' job keyed on the review id" || bad "tick 1: not the per-review job (glob=$(todo_glob "$BARE_DUP4" "^$SLUG-pr544-review-"))"
# tick 2 — the SAME review's inline comment surfaces alone, NON-subsumed, carrying the
# parent review id 4604000111 in the 8th column. It must FOLD onto the existing review
# job's base and be an idempotent skip (NO second job).
FIX_DUP4B="$TR/fix-dup4b.tsv"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T22:00:01Z pr-review-comment 4604000999 544 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/544#discussion_r4604000999 \
  'Keep this indefinitely.' 4604000111 > "$FIX_DUP4B"
run_directive "$TR/state-dup4" "$BARE_DUP4" "$FIX_DUP4B" "$RLOG_DUP4" "$DUP4LOG"
[ "$(todo_count "$BARE_DUP4")" -eq 1 ] && ok "tick 2: still exactly ONE job — the inline comment collapsed onto the review's canonical key" || bad "tick 2 fanned out a second job (todo=$(todo_count "$BARE_DUP4"))"
[ "$(todo_glob "$BARE_DUP4" "^$SLUG-pr544-review-")" -eq 1 ] && ok "tick 2: the single job is still the per-review 'review' job" || bad "tick 2: review job duplicated or lost (glob=$(todo_glob "$BARE_DUP4" "^$SLUG-pr544-review-"))"
[ "$(todo_glob "$BARE_DUP4" "^$SLUG-pr544-[0-9a-f]")" -eq 0 ] && ok "tick 2: NO comment-id-keyed sibling job was minted (the #544 fan-out)" || bad "tick 2: a comment-id-keyed sibling leaked (glob=$(todo_glob "$BARE_DUP4" "^$SLUG-pr544-[0-9a-f]"))"
grep -q 'FOLD:' "$DUP4LOG" && ok "tick 2: the inline-comment fold is LOGGED" || bad "tick 2: no FOLD log line ($(cat "$DUP4LOG"))"
[ "$(cursor_seen "$TR/state-dup4" "$BARE_DUP4")" = 2026-06-30T22:00:01Z ] && ok "cursor advanced past the inline comment" || bad "cursor not advanced ($(cursor_seen "$TR/state-dup4" "$BARE_DUP4"))"

# ============================================================================
# REPLY1–REPLY5 — an ACKNOWLEDGED comment gets AT LEAST a REPLY, not just a reactji
# (kriskowal directive, 2026-06-30, re endo-but-for-bots #58 comment 4848100199 — a
# status question that got only a 👀). Now that the observe→post-job path is fully
# deterministic, a trusted ambiguous comment ALWAYS mints an `attention` (triage) job
# AND gets a reply naming that job (never a silent reactji-and-slide, never an LLM
# skip); a re-poll must NOT double-reply; the bot's OWN comments mint NOTHING (the
# self-trigger + spiral guard); an untrusted sender gets neither reactji nor reply;
# an ACTIONABLE comment gets a reply naming the active job in addition to its job. The
# reply poster is stubbed (CW_REPLY_LOG logs "<surface> <cid> <pr>" per call) so the
# property is deterministic.

hr; echo "REPLY1 — trusted status question → an attention job AND a reply naming it (not a silent slide)"; hr
BARE_RP1="$TR/rp1.git"; seed_bare "$BARE_RP1"
FIX_RP1="$TR/fix-rp1.tsv"; RLOG_RP1="$TR/react-rp1.log"; : > "$RLOG_RP1"
RPLOG_RP1="$TR/reply-rp1.log"; : > "$RPLOG_RP1"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T17:00:00Z issue-comment 4848100199 58 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4848100199 \
  "What's the status of this effort?" > "$FIX_RP1"
CW_REPLY_LOG="$RPLOG_RP1" run_directive "$TR/state-rp1" "$BARE_RP1" "$FIX_RP1" "$RLOG_RP1"
[ "$(todo_count "$BARE_RP1")" -eq 1 ] && ok "the status question minted a deterministic attention job (its deliverable is the substantive reply)" || bad "no job posted for the status question (todo=$(todo_count "$BARE_RP1"))"
grep -qx "issue-comment 4848100199 eyes" "$RLOG_RP1" && ok "the comment still got its 👀 reactji" || bad "no reactji ($(cat "$RLOG_RP1"))"
grep -qx "issue-comment 4848100199 58" "$RPLOG_RP1" && ok "a REPLY comment was produced (not just the reactji)" || bad "no reply produced for an acknowledged comment ($(cat "$RPLOG_RP1"))"
[ "$(grep -c . "$RPLOG_RP1")" -eq 1 ] && ok "exactly one reply" || bad "reply count $(grep -c . "$RPLOG_RP1")"
[ "$(cursor_seen "$TR/state-rp1" "$BARE_RP1")" = 2026-06-30T17:00:00Z ] && ok "cursor advanced past the engaged comment" || bad "cursor not advanced"

hr; echo "REPLY2 — re-poll of REPLY1 → NO double reply (idempotent)"; hr
CW_REPLY_LOG="$RPLOG_RP1" run_directive "$TR/state-rp1" "$BARE_RP1" "$FIX_RP1" "$RLOG_RP1"
[ "$(grep -c . "$RPLOG_RP1")" -eq 1 ] && ok "still exactly one reply after a re-poll (no double-reply)" || bad "reply duplicated on re-poll ($(grep -c . "$RPLOG_RP1"))"

hr; echo "REPLY3 — the bot's OWN comment → mints NOTHING (no job, no reactji, no reply)"; hr
# The bot must never act on its own words. Even when the bot login is trusted
# (allowlisted), the SELF guard skips it before classify — so no attention job is
# minted (the self-trigger guard) and post_reply's author==bot refusal is the
# defense in depth (no reply→reply spiral).
SELFALLOW="$TR/self-allowlist"; printf 'kriskowal\nkriscendobot\n' > "$SELFALLOW"
BARE_RP3="$TR/rp3.git"; seed_bare "$BARE_RP3"
FIX_RP3="$TR/fix-rp3.tsv"; RLOG_RP3="$TR/react-rp3.log"; : > "$RLOG_RP3"
RPLOG_RP3="$TR/reply-rp3.log"; : > "$RPLOG_RP3"; RP3LOG="$TR/rp3.stderr"; : > "$RP3LOG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T18:00:00Z issue-comment 4848200000 58 kriscendobot \
  https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4848200000 \
  'On it — I have posted a job and will follow up here.' > "$FIX_RP3"
CW_ALLOW="$SELFALLOW" CW_REPLY_LOG="$RPLOG_RP3" run_directive "$TR/state-rp3" "$BARE_RP3" "$FIX_RP3" "$RLOG_RP3" "$RP3LOG"
[ "$(todo_count "$BARE_RP3")" -eq 0 ] && ok "the bot's own comment minted NO job (no self-triggered work spiral)" || bad "the bot's own comment posted a job (todo=$(todo_count "$BARE_RP3"))"
[ ! -s "$RLOG_RP3" ] && ok "the bot's own comment got NO reactji" || bad "reactji posted on the bot's own comment ($(cat "$RLOG_RP3"))"
[ ! -s "$RPLOG_RP3" ] && ok "the bot's own comment got NO reply (no reply→reply spiral)" || bad "replied to the bot's own comment ($(cat "$RPLOG_RP3"))"
grep -q 'SELF:' "$RP3LOG" && ok "the self-comment skip is LOGGED (deterministic, not silent)" || bad "no SELF log line ($(cat "$RP3LOG"))"

hr; echo "REPLY4 — UNTRUSTED non-actionable comment → no reactji AND no reply"; hr
BARE_RP4="$TR/rp4.git"; seed_bare "$BARE_RP4"
FIX_RP4="$TR/fix-rp4.tsv"; RLOG_RP4="$TR/react-rp4.log"; : > "$RLOG_RP4"
RPLOG_RP4="$TR/reply-rp4.log"; : > "$RPLOG_RP4"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T19:00:00Z issue-comment 4848300000 58 drive-by-rando \
  https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4848300000 \
  'random chatter from a stranger' > "$FIX_RP4"
CW_REPLY_LOG="$RPLOG_RP4" run_directive "$TR/state-rp4" "$BARE_RP4" "$FIX_RP4" "$RLOG_RP4"
[ ! -s "$RLOG_RP4" ] && ok "no reactji for an untrusted sender" || bad "reactji posted for untrusted"
[ ! -s "$RPLOG_RP4" ] && ok "no reply for an untrusted sender (engage trusted only)" || bad "replied to an untrusted sender ($(cat "$RPLOG_RP4"))"

hr; echo "REPLY5 — ACTIONABLE trusted comment → a job AND a reply naming the active job"; hr
BARE_RP5="$TR/rp5.git"; seed_bare "$BARE_RP5"
FIX_RP5="$TR/fix-rp5.tsv"; RLOG_RP5="$TR/react-rp5.log"; : > "$RLOG_RP5"
RPLOG_RP5="$TR/reply-rp5.log"; : > "$RPLOG_RP5"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T20:00:00Z issue-comment 4848400000 58 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4848400000 \
  'Please apply this feedback' > "$FIX_RP5"
CW_REPLY_LOG="$RPLOG_RP5" run_directive "$TR/state-rp5" "$BARE_RP5" "$FIX_RP5" "$RLOG_RP5"   # ambiguous trusted → deterministic attention job
[ "$(todo_count "$BARE_RP5")" -eq 1 ] && ok "the actionable directive posted a job" || bad "no job posted (todo=$(todo_count "$BARE_RP5"))"
grep -qx "issue-comment 4848400000 58" "$RPLOG_RP5" && ok "the actionable comment ALSO got a reply naming the work" || bad "no reply on an actionable comment ($(cat "$RPLOG_RP5"))"
# re-poll → the job is already on the board (verify_posted short-circuit) → no second reply
CW_REPLY_LOG="$RPLOG_RP5" run_directive "$TR/state-rp5" "$BARE_RP5" "$FIX_RP5" "$RLOG_RP5"
[ "$(grep -c . "$RPLOG_RP5")" -eq 1 ] && ok "re-poll of the actionable comment does not double-reply" || bad "reply duplicated on re-poll ($(grep -c . "$RPLOG_RP5"))"

# ============================================================================
# DET — the observe→post-job path invokes NO LLM. Even with an LLM fallback wired
# into the (now-dead) GARDEN_COMMENT_FALLBACK env var — set to a NEVER-CALL sentinel
# that would fail the run and drop a sentinel file if ever exec'd — a trusted
# ambiguous comment STILL becomes a deterministic `attention` job, and the sentinel
# is never touched. This is the direct proof of the maintainer directive (2026-07-01):
# an LLM being unavailable / erroring can no longer drop a trusted comment, because
# no LLM runs between observing and posting at all.
hr; echo "DET — LLM fallback wired but UNAVAILABLE/never-consulted → STILL a posted attention job"; hr
BARE_DET="$TR/det.git"; seed_bare "$BARE_DET"
FIX_DET="$TR/fix-det.tsv"; RLOG_DET="$TR/react-det.log"; : > "$RLOG_DET"
DET_SENTINEL="$TR/det-fallback-was-called"; rm -f "$DET_SENTINEL"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-01T09:00:00Z issue-comment 5000000001 503 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-5000000001 \
  'Getting there — I would like the panels grouped and the stray heading removed.' > "$FIX_DET"
# Wire the dead fallback var + a broken org-trust check; trust is via the allowlist.
env GARDEN_STATE="$TR/state-det" JOURNAL_REMOTE="$BARE_DET" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$TR/norepos" \
    CW_FIXTURE="$FIX_DET" CW_REACTJI_LOG="$RLOG_DET" \
    GARDEN_COMMENT_SOURCE="$SRCSTUB" \
    GARDEN_COMMENT_REACTJI="$REACTSTUB" \
    GARDEN_COMMENT_REPLY="$REPLYSTUB" \
    GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
    GARDEN_COMMENT_FALLBACK="$NEVERCALL" CW_NEVERCALL_SENTINEL="$DET_SENTINEL" \
    GARDEN_COMMENT_TRUST=/bin/false \
    GARDEN_TRUSTED_ALLOWLIST="$ALLOW" \
    GARDEN_PR_MERGEABLE="$MERGEABLE_OPEN" \
    "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>"$TR/det.stderr" || true
[ "$(todo_count "$BARE_DET")" -eq 1 ] && ok "a trusted ambiguous comment STILL posted a job with the LLM fallback wired (never dropped)" || bad "no job posted (todo=$(todo_count "$BARE_DET"))"
[ ! -e "$DET_SENTINEL" ] && ok "the LLM fallback was NEVER exec'd (observe→post-job path is deterministic)" || bad "the LLM fallback WAS invoked — the path is not deterministic"
grep -q 'attention on #503' "$TR/det.stderr" && ok "the posted job is a deterministic 'attention' (triage) job" || bad "no attention job logged ($(cat "$TR/det.stderr"))"
[ "$(cursor_seen "$TR/state-det" "$BARE_DET")" = 2026-07-01T09:00:00Z ] && ok "cursor advanced past the actioned comment" || bad "cursor not advanced"

# ============================================================================
# MP/CN/SQ — the ACTION FLOOR: a clear maintainer directive must reliably become a
# JOB (not slide to a bare 👀). The verb-gate is broadened to (a) recognize a bare
# imperative verb ("Shepherd.", "conduct #N"), (b) trust-gate an explicit
# conduct/merge onto the finalization path, and (c) triage a MULTI-PART direction
# WHOLE instead of reducing it to its first verb. Regression shapes: #442 (a
# multi-part "refactor … But first, rebase." that became no job), #58 (a status
# question that got only a reactji), and #277/#284/#7 (bare "Shepherd."/"conduct").

hr; echo "MP1 — #442 multi-part 'refactor … But first, rebase.' → ONE attention job, NOT a rebase-only job"; hr
BARE_MP1="$TR/mp1.git"; seed_bare "$BARE_MP1"
FIX_MP1="$TR/fix-mp1.tsv"; RLOG_MP1="$TR/react-mp1.log"; : > "$RLOG_MP1"; MP1LOG="$TR/mp1.stderr"; : > "$MP1LOG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T08:00:00Z issue-comment 4900000442 442 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/442#issuecomment-4900000442 \
  'Assume @endo/daemon-cas stands on @endo/platform and refactor accordingly. But first, rebase.' > "$FIX_MP1"
run_directive "$TR/state-mp1" "$BARE_MP1" "$FIX_MP1" "$RLOG_MP1" "$MP1LOG"
[ "$(todo_count "$BARE_MP1")" -eq 1 ] && ok "the multi-part direction minted exactly one job (never dropped to a bare 👀)" || bad "multi-part direction dropped or fanned out (todo=$(todo_count "$BARE_MP1"))"
board_has "$BARE_MP1" "$SLUG-pr442-rebase" && bad "multi-part reduced to a rebase-only job (dropped the refactor — the #442 regression)" || ok "no rebase-only job — the compound direction was NOT reduced to its first verb"
grep -q 'attention on #442' "$MP1LOG" && ok "the whole multi-part routes to a deterministic 'attention' (triage) job" || bad "not routed to attention ($(cat "$MP1LOG"))"
grep -qx "issue-comment 4900000442 eyes" "$RLOG_MP1" && ok "eyes reactji acked the directive" || bad "no reactji ($(cat "$RLOG_MP1"))"
[ "$(cursor_seen "$TR/state-mp1" "$BARE_MP1")" = 2026-06-30T08:00:00Z ] && ok "cursor advanced past the actioned directive" || bad "cursor not advanced"
# re-poll → idempotent (same comment id → same base → no dup, no double reactji)
run_directive "$TR/state-mp1" "$BARE_MP1" "$FIX_MP1" "$RLOG_MP1"
[ "$(todo_count "$BARE_MP1")" -eq 1 ] && ok "re-poll of the multi-part directive is idempotent (still one job)" || bad "multi-part job duplicated on re-poll (todo=$(todo_count "$BARE_MP1"))"
[ "$(grep -c . "$RLOG_MP1")" -eq 1 ] && ok "no duplicate reactji on re-poll" || bad "reactji duplicated ($(grep -c . "$RLOG_MP1"))"

hr; echo "MP2 — a BARE imperative verb ('Shepherd.') → the corresponding shepherd job (no 'please' needed)"; hr
# Trust-independent (run_watcher denies trust), proving the mechanical verb fires on
# the verb itself — the #277/#284 'Shepherd.' shape — not on a trust decision.
BARE_MP2="$TR/mp2.git"; seed_bare "$BARE_MP2"
FIX_MP2="$TR/fix-mp2.tsv"; RLOG_MP2="$TR/react-mp2.log"; : > "$RLOG_MP2"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T09:00:00Z issue-comment 4900000277 277 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/277#issuecomment-4900000277 \
  'Shepherd.' > "$FIX_MP2"
run_watcher "$TR/state-mp2" "$BARE_MP2" "$FIX_MP2" "$RLOG_MP2"
board_has "$BARE_MP2" "$SLUG-pr277-shepherd" && ok "bare 'Shepherd.' minted the shepherd job" || bad "bare imperative verb did not mint its job"
[ "$(todo_count "$BARE_MP2")" -eq 1 ] && ok "exactly one job for the bare directive" || bad "expected one job (todo=$(todo_count "$BARE_MP2"))"
[ "$(cursor_seen "$TR/state-mp2" "$BARE_MP2")" = 2026-06-30T09:00:00Z ] && ok "cursor advanced past the actioned directive" || bad "cursor not advanced"

hr; echo "MP2b — 'Run the gauntlet.' → a staged-gauntlet RECORD (not a monolithic job)"; hr
# The gauntlet is now walked one claim-sized stage at a time by the deterministic
# gauntlet.sh driver (designs/staged-gauntlet.md), so `run the gauntlet` creates a
# gauntlet RECORD (jobs/gauntlet/<g>.md), NOT a monolithic todo job whose handler had
# to span the whole clean→panel→fix→un-draft chain (nine deadline-overrun dooms).
BARE_MP2B="$TR/mp2b.git"; seed_bare "$BARE_MP2B"
FIX_MP2B="$TR/fix-mp2b.tsv"; RLOG_MP2B="$TR/react-mp2b.log"; : > "$RLOG_MP2B"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T09:15:00Z issue-comment 4900000278 278 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/278#issuecomment-4900000278 \
  'Run the gauntlet.' > "$FIX_MP2B"
run_watcher "$TR/state-mp2b" "$BARE_MP2B" "$FIX_MP2B" "$RLOG_MP2B"
board_has_gauntlet "$BARE_MP2B" "$SLUG-pr278-gauntlet" \
  && ok "run-the-gauntlet recorded a staged gauntlet" \
  || bad "run-the-gauntlet did not record a gauntlet"
board_has "$BARE_MP2B" "$SLUG-pr278-gauntlet" \
  && bad "a monolithic gauntlet todo job was minted (should be a record now)" \
  || ok "no monolithic todo job — the record replaces it"
GREC_MP2B="$(gauntlet_record_body "$BARE_MP2B" "$SLUG-pr278-gauntlet")"
printf '%s\n' "$GREC_MP2B" | grep -qx 'pr_number: 278' \
  && ok "the gauntlet record carries the PR number" \
  || bad "the gauntlet record is missing pr_number: 278"
printf '%s\n' "$GREC_MP2B" | grep -qx 'stage: clean' \
  && ok "the gauntlet record starts at the clean stage" \
  || bad "the gauntlet record does not start at stage: clean"
# still acked the source comment (the 👀 receipt invariant holds for the record path)
grep -q '4900000278' "$RLOG_MP2B" \
  && ok "run-the-gauntlet still acks the source comment" \
  || bad "run-the-gauntlet did not ack the source comment"

hr; echo "MP3 — a future-tense/subject-matter 'refactor'/'rebase' (no @, no imperative pos) → STILL no verb job"; hr
# The broadened gate must NOT reintroduce the #513 verb-as-subject-matter false
# positive: a verb used as a NOUN or a future intention stays inert for an untrusted
# sender. (run_watcher denies trust, so only a DETECTED VERB could post a job.)
BARE_MP3="$TR/mp3.git"; seed_bare "$BARE_MP3"
FIX_MP3="$TR/fix-mp3.tsv"; RLOG_MP3="$TR/react-mp3.log"; : > "$RLOG_MP3"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T09:30:00Z issue-comment 4900000513 513 someoutsider \
  https://github.com/endojs/endo-but-for-bots/pull/513#issuecomment-4900000513 \
  'A subsequent rebase and a later refactor of this module will pick these up automatically.' > "$FIX_MP3"
run_watcher "$TR/state-mp3" "$BARE_MP3" "$FIX_MP3" "$RLOG_MP3"
[ "$(todo_count "$BARE_MP3")" -eq 0 ] && ok "verb-as-subject-matter minted no job (no #513-style false positive)" || bad "a noun/future-tense verb minted a job (todo=$(todo_count "$BARE_MP3"))"
[ ! -s "$RLOG_MP3" ] && ok "no reactji on the non-directive verb mention" || bad "reactji posted: $(cat "$RLOG_MP3")"

hr; echo "CN1 — a trusted 'conduct #57' on a mergeable bot PR → the conductor (finalize) job"; hr
BARE_CN1="$TR/cn1.git"; seed_bare "$BARE_CN1"
FIX_CN1="$TR/fix-cn1.tsv"; RLOG_CN1="$TR/react-cn1.log"; : > "$RLOG_CN1"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T10:00:00Z issue-comment 4900000057 57 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/57#issuecomment-4900000057 \
  'Conduct #57.' > "$FIX_CN1"
run_directive "$TR/state-cn1" "$BARE_CN1" "$FIX_CN1" "$RLOG_CN1"
board_has "$BARE_CN1" "$SLUG-pr57-conduct" && ok "'conduct' minted the conductor (finalize) job" || bad "'conduct' did not mint the conductor job"
CN1BODY="$(mktemp -d "$TR/cn1b.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_CN1" "$CN1BODY" 2>/dev/null
grep -qi 'conductor' "$CN1BODY/jobs/todo/$SLUG-pr57-conduct.md" && ok "the conduct job names the conductor" || bad "conduct job does not name the conductor"; rm -rf "$CN1BODY"
[ "$(cursor_seen "$TR/state-cn1" "$BARE_CN1")" = 2026-06-30T10:00:00Z ] && ok "cursor advanced past the actioned conduct directive" || bad "cursor not advanced"

hr; echo "CN2 — an UNTRUSTED 'please merge #57' → NO finalize (merge authority is trust-gated), dropped"; hr
BARE_CN2="$TR/cn2.git"; seed_bare "$BARE_CN2"
FIX_CN2="$TR/fix-cn2.tsv"; RLOG_CN2="$TR/react-cn2.log"; : > "$RLOG_CN2"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T10:30:00Z issue-comment 4900000058 57 drive-by-rando \
  https://github.com/endojs/endo-but-for-bots/pull/57#issuecomment-4900000058 \
  'Please merge #57.' > "$FIX_CN2"
run_directive "$TR/state-cn2" "$BARE_CN2" "$FIX_CN2" "$RLOG_CN2"
board_has "$BARE_CN2" "$SLUG-pr57-conduct" && bad "an untrusted sender triggered an autonomous merge (security hole)" || ok "untrusted merge directive did NOT dispatch the conductor"
[ "$(todo_count "$BARE_CN2")" -eq 0 ] && ok "untrusted merge directive minted no job at all" || bad "untrusted merge posted a job (todo=$(todo_count "$BARE_CN2"))"
[ ! -s "$RLOG_CN2" ] && ok "no reactji for an untrusted sender" || bad "reactji posted for untrusted: $(cat "$RLOG_CN2")"

hr; echo "SQ1 — #58 status question 'What's the status of this effort?' (trusted) → an attention job (not a bare 👀)"; hr
BARE_SQ1="$TR/sq1.git"; seed_bare "$BARE_SQ1"
FIX_SQ1="$TR/fix-sq1.tsv"; RLOG_SQ1="$TR/react-sq1.log"; : > "$RLOG_SQ1"; SQ1LOG="$TR/sq1.stderr"; : > "$SQ1LOG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T11:00:00Z issue-comment 4848100199 58 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4848100199 \
  "What's the status of this effort? I'd like it to render in a real browser." > "$FIX_SQ1"
run_directive "$TR/state-sq1" "$BARE_SQ1" "$FIX_SQ1" "$RLOG_SQ1" "$SQ1LOG"
[ "$(todo_count "$BARE_SQ1")" -eq 1 ] && ok "the status question warrants continued work → posted a job (not just a reactji)" || bad "status question dropped to a bare reactji (todo=$(todo_count "$BARE_SQ1"))"
grep -q 'attention on #58' "$SQ1LOG" && ok "the status question routes to a deterministic 'attention' job" || bad "not routed to attention ($(cat "$SQ1LOG"))"
grep -qx "issue-comment 4848100199 eyes" "$RLOG_SQ1" && ok "eyes reactji acked the status question" || bad "no reactji on the status question ($(cat "$RLOG_SQ1"))"
[ "$(cursor_seen "$TR/state-sq1" "$BARE_SQ1")" = 2026-06-30T11:00:00Z ] && ok "cursor advanced past the actioned status question" || bad "cursor not advanced"

hr; echo "SELF1 — the BOT's OWN bare imperative ('Shepherd.') → mints NOTHING (no self-trigger loop)"; hr
# The broadened verb-gate must never let the watcher act on the bot's OWN words: a
# bare 'Shepherd.' authored by the bot is skipped by the self-guard BEFORE classify.
BARE_SELF1="$TR/self1.git"; seed_bare "$BARE_SELF1"
FIX_SELF1="$TR/fix-self1.tsv"; RLOG_SELF1="$TR/react-self1.log"; : > "$RLOG_SELF1"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-30T12:00:00Z issue-comment 4900000999 277 kriscendobot \
  https://github.com/endojs/endo-but-for-bots/pull/277#issuecomment-4900000999 \
  'Shepherd.' > "$FIX_SELF1"
run_watcher "$TR/state-self1" "$BARE_SELF1" "$FIX_SELF1" "$RLOG_SELF1"
[ "$(todo_count "$BARE_SELF1")" -eq 0 ] && ok "the bot's own bare imperative minted no job" || bad "self-triggered a job off the bot's own comment (todo=$(todo_count "$BARE_SELF1"))"
[ ! -s "$RLOG_SELF1" ] && ok "no reactji on the bot's own comment" || bad "reacted to the bot's own comment: $(cat "$RLOG_SELF1")"
[ "$(cursor_seen "$TR/state-self1" "$BARE_SELF1")" = 2026-06-30T12:00:00Z ] && ok "cursor slid past the bot's own comment" || bad "cursor did not slide"

# ============================================================================
# ===== review-retrospective double loop (stage 2 wiring) ====================
# The comment-watcher mints a SECOND, deferred `<primary-base>-retro` plan job
# alongside a substantive-feedback primary, gated deterministically on the verb
# class (design designs/review-retrospective-loop.md Q1/Q6). These cases assert
# the gate: retro for review + directive-attention; NO retro for branch ops,
# chatter-attention, finalize, or untrusted; idempotent on re-poll; a lost retro
# WARNs and never freezes the cursor (the primary still lands).
plan_glob() {  # plan_glob <bare> <regex>  -> count of jobs/plan entries matching
  local v n; v="$(mktemp -d "$TR/pg.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/plan" 2>/dev/null | grep -c "$2" || true); rm -rf "$v"; printf '%s' "$n"
}

hr; echo "RETRO-REVIEW — a trusted review mints the primary AND a paired -retro plan job"; hr
BARE_RR="$TR/rr.git"; seed_bare "$BARE_RR"
FIX_RR="$TR/fix-rr.tsv"; RLOG_RR="$TR/react-rr.log"; : > "$RLOG_RR"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-03T09:00:00Z pr-review-body 4700000001 594 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/594#pullrequestreview-4700000001 \
  '[CHANGES_REQUESTED] Guard the empty-input boundary; the panel should have caught this.' > "$FIX_RR"
run_directive "$TR/state-rr" "$BARE_RR" "$FIX_RR" "$RLOG_RR"
[ "$(todo_glob "$BARE_RR" "^$SLUG-pr594-review-")" -eq 1 ] && ok "primary review job minted (unchanged loop)" || bad "primary review job missing"
[ "$(plan_glob "$BARE_RR" "^$SLUG-pr594-review-.*-retro\.md$")" -eq 1 ] && ok "paired -retro plan job parked" || bad "retro plan job missing (plan=$(plan_count "$BARE_RR"))"
# The retro is deferred + role prosecutor.
RRV="$(mktemp -d "$TR/rrv.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_RR" "$RRV"
RETROF="$(ls -1 "$RRV"/jobs/plan/"$SLUG-pr594-review-"*-retro.md | head -1)"
grep -q '^gate: deferred' "$RETROF" && ok "retro parked as gate: deferred" || bad "retro not deferred"
grep -q '^role: prosecutor' "$RETROF" && ok "retro carries role: prosecutor" || bad "retro role wrong"
grep -qi 'review-retrospective/SKILL.md' "$RETROF" && ok "retro body names the review-retrospective skill" || bad "retro body missing skill reference"
grep -qi ':retro' "$RETROF" && ok "retro records the :retro directive identity" || bad "retro identity missing"
# The #721 lesson: the retro must GROUND ITSELF IN THE WORLD, not restate the
# primary's claims. The primary there asserted a peer had posted the requested plans
# (it had not) and the retro repeated that premise verbatim, ratifying the miss.
grep -qi 'not in the primary job report' "$RETROF" \
  && ok "retro body forbids grounding in the primary's report" \
  || bad "retro body does not require independent grounding (the #721 inherited-premise miss)"
grep -qi 'deliverable actually EXISTS' "$RETROF" \
  && ok "retro body requires confirming the deliverable exists behind a primary no-op" \
  || bad "retro body does not require confirming a no-op primary's deliverable"
rm -rf "$RRV"
# re-poll → idempotent: still exactly one retro.
run_directive "$TR/state-rr" "$BARE_RR" "$FIX_RR" "$RLOG_RR"
[ "$(plan_glob "$BARE_RR" "^$SLUG-pr594-review-.*-retro\.md$")" -eq 1 ] && ok "re-poll is idempotent (still one retro)" || bad "retro duplicated on re-poll"

hr; echo "RETRO-ATTN — a trusted directive-attention comment mints a -retro"; hr
BARE_RA="$TR/ra.git"; seed_bare "$BARE_RA"
FIX_RA="$TR/fix-ra.tsv"; RLOG_RA="$TR/react-ra.log"; : > "$RLOG_RA"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-03T09:10:00Z issue-comment 4700000100 595 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/595#issuecomment-4700000100 \
  'Please take a look at the empty-input handling here.' > "$FIX_RA"
run_directive "$TR/state-ra" "$BARE_RA" "$FIX_RA" "$RLOG_RA"
[ "$(todo_count "$BARE_RA")" -eq 1 ] && ok "primary attention job minted" || bad "primary attention job missing"
[ "$(plan_glob "$BARE_RA" "^$SLUG-pr595-.*-retro\.md$")" -eq 1 ] && ok "directive-attention minted a -retro" || bad "no retro for a directive-attention (plan=$(plan_count "$BARE_RA"))"

hr; echo "RETRO-BRANCHOP — a rebase directive mints NO retro (maintenance, not a review miss)"; hr
BARE_RB="$TR/rb.git"; seed_bare "$BARE_RB"
FIX_RB="$TR/fix-rb.tsv"; RLOG_RB="$TR/react-rb.log"; : > "$RLOG_RB"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-03T09:20:00Z issue-comment 4700000200 596 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/596#issuecomment-4700000200 \
  'Please rebase on #475' > "$FIX_RB"
run_directive "$TR/state-rb" "$BARE_RB" "$FIX_RB" "$RLOG_RB"
board_has "$BARE_RB" "$SLUG-pr596-rebase" && ok "primary rebase job minted" || bad "rebase job missing"
[ "$(plan_count "$BARE_RB")" -eq 0 ] && ok "no retro for a branch op" || bad "a branch op wrongly minted a retro (plan=$(plan_count "$BARE_RB"))"

hr; echo "RETRO-CHATTER — trusted chatter mints an attention reply but NO retro"; hr
BARE_RC="$TR/rc.git"; seed_bare "$BARE_RC"
FIX_RC="$TR/fix-rc.tsv"; RLOG_RC="$TR/react-rc.log"; : > "$RLOG_RC"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-03T09:30:00Z issue-comment 4700000300 597 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/597#issuecomment-4700000300 \
  'Thanks, this looks great!' > "$FIX_RC"
run_directive "$TR/state-rc" "$BARE_RC" "$FIX_RC" "$RLOG_RC"
[ "$(todo_count "$BARE_RC")" -eq 1 ] && ok "chatter still mints its attention (reply) job" || bad "chatter attention missing"
[ "$(plan_count "$BARE_RC")" -eq 0 ] && ok "no retro for non-directive chatter" || bad "chatter wrongly minted a retro (plan=$(plan_count "$BARE_RC"))"

hr; echo "RETRO-FINALIZE — a clean approval (finalize) mints NO retro"; hr
BARE_RF="$TR/rf.git"; seed_bare "$BARE_RF"
FIX_RF="$TR/fix-rf.tsv"; RLOG_RF="$TR/react-rf.log"; : > "$RLOG_RF"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-03T09:40:00Z pr-review-body 4700000400 598 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/598#pullrequestreview-4700000400 \
  '[APPROVED] Looks good.' > "$FIX_RF"
run_directive "$TR/state-rf" "$BARE_RF" "$FIX_RF" "$RLOG_RF"
board_has "$BARE_RF" "$SLUG-pr598-conduct" && ok "clean approval mints the conductor (finalize)" || bad "finalize/conduct job missing"
[ "$(plan_count "$BARE_RF")" -eq 0 ] && ok "no retro for a clean approval" || bad "finalize wrongly minted a retro (plan=$(plan_count "$BARE_RF"))"

hr; echo "RETRO-UNTRUSTED — an untrusted review mints neither a primary nor a retro"; hr
BARE_RU="$TR/ru.git"; seed_bare "$BARE_RU"
FIX_RU="$TR/fix-ru.tsv"; RLOG_RU="$TR/react-ru.log"; : > "$RLOG_RU"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-03T09:50:00Z pr-review-body 4700000500 599 drive-by-rando \
  https://github.com/endojs/endo-but-for-bots/pull/599#pullrequestreview-4700000500 \
  '[CHANGES_REQUESTED] Fix the empty-input guard.' > "$FIX_RU"
run_directive "$TR/state-ru" "$BARE_RU" "$FIX_RU" "$RLOG_RU"
[ "$(todo_count "$BARE_RU")" -eq 0 ] && ok "untrusted review mints no primary" || bad "untrusted review minted a primary"
[ "$(plan_count "$BARE_RU")" -eq 0 ] && ok "untrusted review mints no retro" || bad "untrusted review minted a retro"

hr; echo "RETRO-LOSTWARN — a lost retro WARNs and never freezes the cursor (primary still lands)"; hr
BARE_RL="$TR/rl.git"; seed_bare "$BARE_RL"
FIX_RL="$TR/fix-rl.tsv"; RLOG_RL="$TR/react-rl.log"; : > "$RLOG_RL"; LOG_RL="$TR/log-rl.txt"; : > "$LOG_RL"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-03T10:00:00Z pr-review-body 4700000600 600 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/600#pullrequestreview-4700000600 \
  '[CHANGES_REQUESTED] Guard the empty-input boundary.' > "$FIX_RL"
# A retro poster that always fails (never lands the plan job).
LIE_RETRO="$TR/lie-retro.sh"; printf '#!/bin/bash\nexit 1\n' > "$LIE_RETRO"; chmod +x "$LIE_RETRO"
CW_RETRO_POST="$LIE_RETRO" run_directive "$TR/state-rl" "$BARE_RL" "$FIX_RL" "$RLOG_RL" "$LOG_RL"
[ "$(todo_glob "$BARE_RL" "^$SLUG-pr600-review-")" -eq 1 ] && ok "primary review job STILL landed despite the lost retro" || bad "primary lost when retro failed"
[ "$(plan_count "$BARE_RL")" -eq 0 ] && ok "no retro parked (the poster failed)" || bad "retro somehow parked"
grep -qi 'WARN: retro post lost' "$LOG_RL" && ok "the lost retro is a loud WARN" || bad "lost retro not WARNed ($(cat "$LOG_RL"))"
[ "$(cursor_seen "$TR/state-rl" "$BARE_RL")" = 2026-07-03T10:00:00Z ] && ok "cursor advanced past the primary (retro loss did NOT freeze it)" || bad "cursor frozen by a lost retro ($(cursor_seen "$TR/state-rl" "$BARE_RL"))"

# ============================================================================
hr; echo "SG — own-fork SENDER GATE: untrusted author dropped BEFORE the verb table"; hr
# On a sender-gated repo (an auto-provisioned own fork, possibly public; arming
# file declares `sender-gate: required`), an untrusted author's comment must be
# dropped before ANY dispatch — even a clear mechanical verb that would mint a
# job on an ungated repo (case A proves "please rebase" mints trust-independently
# there). No job, no reactji, a logged DROP, and the cursor still slides. The
# gate mode is DERIVED from the arming file (GARDEN_COMMENT_SENDER_GATE unset),
# so this also exercises the detection path.
BARE_SG="$TR/sg.git"; seed_bare "$BARE_SG"
sgv="$TR/sg-seed"; git clone -q --single-branch --branch "$BRANCH" "$BARE_SG" "$sgv"
mkdir -p "$sgv/comment-repos"
printf 'repo: endojs/endo-but-for-bots\nsender-gate: required\n' > "$sgv/comment-repos/$SLUG"
git -C "$sgv" add -A; git -C "$sgv" "${git_id[@]}" commit -q -m "arm sender gate"
git -C "$sgv" push -q origin "HEAD:$BRANCH"; rm -rf "$sgv"
FIX_SG="$TR/fix-sg.tsv"; RLOG_SG="$TR/react-sg.log"; : > "$RLOG_SG"
LOG_SG="$TR/log-sg.txt"; : > "$LOG_SG"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-09T23:00:00Z issue-comment 990 3 drive-by-rando \
  https://github.com/kriscendobot/minion.town/pull/3#issuecomment-990 \
  'Please rebase this on #3' > "$FIX_SG"
CW_LOG="$LOG_SG" run_watcher "$TR/state-sg" "$BARE_SG" "$FIX_SG" "$RLOG_SG"
[ "$(todo_count "$BARE_SG")" -eq 0 ] && ok "untrusted verb comment minted NO job behind the gate" || bad "gate leaked a job (todo=$(todo_count "$BARE_SG"))"
[ ! -s "$RLOG_SG" ] && ok "no reactji for the untrusted author" || bad "reactji posted: $(cat "$RLOG_SG")"
grep -q 'DROP (sender-gate)' "$LOG_SG" && ok "drop is logged with the sender-gate reason" || bad "no sender-gate DROP log ($(cat "$LOG_SG"))"
[ "$(cursor_seen "$TR/state-sg" "$BARE_SG")" = 2026-07-09T23:00:00Z ] && ok "cursor slid past the gated drop" || bad "cursor frozen ($(cursor_seen "$TR/state-sg" "$BARE_SG"))"

hr; echo "SG2 — sender gate: maintainers/allowlist author passes; same verb mints the job"; hr
# The same repo/gate, but the author is on maintainers/allowlist (the gate's
# third trust source, beyond trusted-senders + org membership — both denied here:
# empty sender allowlist, /bin/false org probe). The verb path must work normally.
BARE_S2="$TR/s2.git"; seed_bare "$BARE_S2"
s2v="$TR/s2-seed"; git clone -q --single-branch --branch "$BRANCH" "$BARE_S2" "$s2v"
mkdir -p "$s2v/comment-repos"
printf 'repo: endojs/endo-but-for-bots\nsender-gate: required\n' > "$s2v/comment-repos/$SLUG"
git -C "$s2v" add -A; git -C "$s2v" "${git_id[@]}" commit -q -m "arm sender gate"
git -C "$s2v" push -q origin "HEAD:$BRANCH"; rm -rf "$s2v"
MAINT_SG="$TR/maintainers-sg"; printf 'kriskowal\n' > "$MAINT_SG"
FIX_S2="$TR/fix-s2.tsv"; RLOG_S2="$TR/react-s2.log"; : > "$RLOG_S2"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-09T23:10:00Z issue-comment 991 3 kriskowal \
  https://github.com/kriscendobot/minion.town/pull/3#issuecomment-991 \
  'Please rebase this on #3' > "$FIX_S2"
env GARDEN_STATE="$TR/state-s2" JOURNAL_REMOTE="$BARE_S2" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$TR/norepos" \
    CW_FIXTURE="$FIX_S2" CW_REACTJI_LOG="$RLOG_S2" \
    GARDEN_COMMENT_SOURCE="$SRCSTUB" \
    GARDEN_COMMENT_REACTJI="$REACTSTUB" \
    GARDEN_COMMENT_REPLY="$REPLYSTUB" \
    GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
    GARDEN_RETRO_POST="$JOBS/post-plan.sh" \
    GARDEN_COMMENT_TRUST=/bin/false \
    GARDEN_TRUSTED_ALLOWLIST=/dev/null \
    GARDEN_MAINTAINERS_ALLOWLIST="$MAINT_SG" \
    GARDEN_PR_MERGEABLE="$MERGEABLE_OPEN" \
    "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1
[ "$(todo_count "$BARE_S2")" -eq 1 ] && ok "maintainers/allowlist author's verb minted the job through the gate" || bad "gated maintainer's directive dropped (todo=$(todo_count "$BARE_S2"))"
grep -qx "issue-comment 991 eyes" "$RLOG_S2" && ok "reactji posted for the gate-passing author" || bad "reactji missing ($(cat "$RLOG_S2"))"

# ============================================================================
hr; echo "TADA — a FRESH verb directive whose (PR,verb) base sits COMPLETED in tada/ must still post"; hr
# Regression for the dropped #671 "Shepherd." (kriskowal, 2026-07-15, issuecomment
# 4977246906): the derived base `<slug>-pr671-shepherd` is keyed on (PR,verb), NOT the
# comment id, so it collided with a 2026-07-10 auto-shepherd already sitting in
# jobs/tada/. The old idempotency pre-check (and post-job.sh's basename check) counted
# tada, so the FRESH directive deduped against the FINISHED job and was silently
# dropped — zero reactji, no job, and the PR sat conflicting for three days. The fix:
# the pre-check is live-only (todo/doin) and post-job.sh's tada-basename dedup yields to
# the comment-id identity index. A fresh directive of the same base must now post a NEW
# live job + reactji + advance the cursor. (shepherd is a branch-op verb → trust-
# independent, so run_watcher's denied-trust wiring still mints it, like case A/D.)
BARE_TADA="$TR/tada.git"; seed_bare "$BARE_TADA"
# Pre-seed a COMPLETED shepherd of the SAME base into tada/ (the finished 2026-07-10 run).
tv="$TR/tada-seed"; git clone -q --single-branch --branch "$BRANCH" "$BARE_TADA" "$tv"
printf '# shepherd (auto, completed)\n\ngarden-job-complete: true\n' > "$tv/jobs/tada/$SLUG-pr671-shepherd.md"
git -C "$tv" add -A; git -C "$tv" "${git_id[@]}" commit -q -m "seed completed shepherd in tada"
git -C "$tv" push -q origin "HEAD:$BRANCH"; rm -rf "$tv"
FIX_TADA="$TR/fix-tada.tsv"; RLOG_TADA="$TR/react-tada.log"; : > "$RLOG_TADA"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-15T05:40:00Z issue-comment 4977246906 671 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/671#issuecomment-4977246906 \
  'Shepherd.' > "$FIX_TADA"
run_watcher "$TR/state-tada" "$BARE_TADA" "$FIX_TADA" "$RLOG_TADA"
# rc 0 iff a LIVE shepherd job (todo|doin) of the base is on the board — the fresh post,
# distinct from the pre-seeded tada entry that board_has() would otherwise mask.
tada_live() {
  local v rc=1; v="$(mktemp -d "$TR/tht.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE_TADA" "$v" 2>/dev/null
  { [ -e "$v/jobs/todo/$SLUG-pr671-shepherd.md" ] || [ -e "$v/jobs/doin/$SLUG-pr671-shepherd.md" ]; } && rc=0
  rm -rf "$v"; return $rc
}
tada_live && ok "a FRESH shepherd job was posted despite a COMPLETED same-base job in tada/" || bad "fresh directive swallowed by the tada entry (the #671 silent drop)"
grep -qx "issue-comment 4977246906 eyes" "$RLOG_TADA" && ok "the fresh directive got its 👀 receipt (no more zero-reaction drop)" || bad "no reactji on the fresh directive ($(cat "$RLOG_TADA"))"
[ "$(cursor_seen "$TR/state-tada" "$BARE_TADA")" = 2026-07-15T05:40:00Z ] && ok "cursor advanced past the actioned fresh directive" || bad "cursor not advanced ($(cursor_seen "$TR/state-tada" "$BARE_TADA"))"

hr; echo "TADA2 — re-poll of the fresh directive is idempotent (no duplicate live job)"; hr
# Reuse TADA's board + state + fixture: a second tick must not fan out a second job
# (the boundary dedup skips the at-cursor comment; the identity index would collapse it
# even if re-processed). Exactly one live copy must remain.
run_watcher "$TR/state-tada" "$BARE_TADA" "$FIX_TADA" "$RLOG_TADA"
ndup=$(git clone -q --single-branch --branch "$BRANCH" "$BARE_TADA" "$TR/tada-dup" 2>/dev/null && { cat <(ls -1 "$TR/tada-dup/jobs/todo" 2>/dev/null) <(ls -1 "$TR/tada-dup/jobs/doin" 2>/dev/null) | grep -c "^$SLUG-pr671-shepherd.md$"; } || true); rm -rf "$TR/tada-dup"
[ "${ndup:-0}" -le 1 ] && ok "no duplicate live job on re-poll (still exactly one)" || bad "re-poll duplicated the job (live copies=$ndup)"
[ "$(cursor_seen "$TR/state-tada" "$BARE_TADA")" = 2026-07-15T05:40:00Z ] && ok "cursor stable on idempotent re-poll" || bad "cursor moved on re-poll"

# ============================================================================
hr; echo "PK — a directive whose base is PARKED in plan/ ANNOTATES it (no lost push, no lost comment)"; hr
# A derived base is not comment-unique (the mechanical verbs key on (PR,verb)), so a
# follow-up comment can land on a base that is currently PARKED in plan/ — the proxy
# parked it as blocked, or a producer deferred it. post-job.sh is idempotent on the
# basename and correctly no-ops there, and the watcher used to misread that deliberate
# no-op as a lost push: cursor frozen below the comment forever, the follow-up never
# recorded anywhere. It must instead annotate the parked job (annotate-plan.sh), ack,
# and slide. (rebase is a branch-op verb → trust-independent, like case A.)
BARE_PK="$TR/pk.git"; seed_bare "$BARE_PK"
PK_BASE="$SLUG-pr700-rebase"
pkv="$TR/pk-seed"; git clone -q --single-branch --branch "$BRANCH" "$BARE_PK" "$pkv"
mkdir -p "$pkv/jobs/plan"
printf -- '---\nrole: weaver\npriority: normal\nmodel: opus\n---\n\n# rebase #700 (parked)\n' \
  > "$pkv/jobs/plan/$PK_BASE.md"
git -C "$pkv" add -A; git -C "$pkv" "${git_id[@]}" commit -q -m "park a rebase job in plan/"
git -C "$pkv" push -q origin "HEAD:$BRANCH"; rm -rf "$pkv"
plan_body() {  # plan_body <bare> <base>  -> prints the parked job body
  local v f; v="$(mktemp -d "$TR/pb.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  f="$v/jobs/plan/$2.md"; [ -f "$f" ] && cat "$f"; rm -rf "$v"
}
FIX_PK="$TR/fix-pk.tsv"; RLOG_PK="$TR/react-pk.log"; : > "$RLOG_PK"
LOG_PK="$TR/log-pk.txt"; : > "$LOG_PK"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-29T09:00:00Z issue-comment 4990000700 700 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/700#issuecomment-4990000700 \
  'Please rebase on #789' > "$FIX_PK"
CW_LOG="$LOG_PK" run_watcher "$TR/state-pk" "$BARE_PK" "$FIX_PK" "$RLOG_PK"
[ "$(todo_count "$BARE_PK")" -eq 0 ] && ok "no live job minted onto the parked base (post-job's no-op respected)" || bad "a live job was forked beside the parked one (todo=$(todo_count "$BARE_PK"))"
[ "$(plan_count "$BARE_PK")" -eq 1 ] && ok "still exactly one parked entry (no fork)" || bad "plan/ count is $(plan_count "$BARE_PK")"
PK_BODY="$(plan_body "$BARE_PK" "$PK_BASE")"
printf '%s' "$PK_BODY" | grep -qF 'garden-annotation: key=endojs/endo-but-for-bots#700:comment:4990000700 ' \
  && ok "the parked job carries the annotation keyed on the directive identity" || bad "no identity-keyed annotation marker on the parked job"
printf '%s' "$PK_BODY" | grep -qF 'https://github.com/endojs/endo-but-for-bots/pull/700#issuecomment-4990000700' \
  && ok "the annotation names the source comment URL" || bad "annotation does not cite the comment"
printf '%s' "$PK_BODY" | grep -qF 'Please rebase on #789' \
  && bad "the annotation pasted the UNTRUSTED comment body into the plan file" || ok "no untrusted comment text reproduced in the plan file"
printf '%s' "$PK_BODY" | grep -q '^model: opus$' && ok "the parked job's execution keys survived the annotation" || bad "annotation clobbered the plan frontmatter"
grep -qx "issue-comment 4990000700 eyes" "$RLOG_PK" && ok "the follow-up comment got its 👀 receipt (annotation counts as a recorded job)" || bad "no reactji ($(cat "$RLOG_PK"))"
grep -q 'ANNOTATED parked job' "$LOG_PK" && ok "the annotate path is LOGGED (not mistaken for a lost push)" || bad "annotate not logged ($(cat "$LOG_PK"))"
grep -q 'POST LOST' "$LOG_PK" && bad "the deliberate parked no-op was still misread as a lost push" || ok "no POST LOST for a correctly-deduped parked base"
[ "$(cursor_seen "$TR/state-pk" "$BARE_PK")" = 2026-07-29T09:00:00Z ] && ok "cursor advanced past the annotated comment (no head-of-line freeze)" || bad "cursor frozen ($(cursor_seen "$TR/state-pk" "$BARE_PK"))"

hr; echo "PK2 — a SECOND follow-up on the same parked base appends once more, keyed on ITS comment"; hr
# The dedup identity is the comment, not the note text: a genuinely new comment
# appends a second annotation, while a re-poll of either would be a no-op success.
FIX_PK2="$TR/fix-pk2.tsv"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-29T10:00:00Z issue-comment 4990000701 700 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/700#issuecomment-4990000701 \
  'Please rebase on #790 instead' > "$FIX_PK2"
run_watcher "$TR/state-pk" "$BARE_PK" "$FIX_PK2" "$RLOG_PK"
PK2_BODY="$(plan_body "$BARE_PK" "$PK_BASE")"
[ "$(printf '%s\n' "$PK2_BODY" | grep -c 'garden-annotation: key=')" -eq 2 ] \
  && ok "two annotations, one per comment" || bad "annotation count $(printf '%s\n' "$PK2_BODY" | grep -c 'garden-annotation: key=')"
printf '%s' "$PK2_BODY" | grep -qF 'key=endojs/endo-but-for-bots#700:comment:4990000701 ' \
  && ok "the second comment appended under its own key" || bad "second comment's annotation missing"
[ "$(todo_count "$BARE_PK")" -eq 0 ] && ok "still no live job forked beside the parked one" || bad "second follow-up forked a live job"
[ "$(cursor_seen "$TR/state-pk" "$BARE_PK")" = 2026-07-29T10:00:00Z ] && ok "cursor advanced past the second follow-up" || bad "cursor not advanced ($(cursor_seen "$TR/state-pk" "$BARE_PK"))"

hr; echo "PK3 — re-poll of an annotated comment is idempotent (no third marker, no second ack)"; hr
run_watcher "$TR/state-pk" "$BARE_PK" "$FIX_PK2" "$RLOG_PK"
[ "$(printf '%s\n' "$(plan_body "$BARE_PK" "$PK_BASE")" | grep -c 'garden-annotation: key=')" -eq 2 ] \
  && ok "re-poll appended nothing (still two annotations)" || bad "re-poll double-appended"
[ "$(grep -c . "$RLOG_PK")" -eq 2 ] && ok "exactly two reactji across all three ticks (one per comment)" || bad "reactji count $(grep -c . "$RLOG_PK")"
[ "$(cursor_seen "$TR/state-pk" "$BARE_PK")" = 2026-07-29T10:00:00Z ] && ok "cursor stable on idempotent re-poll" || bad "cursor moved on re-poll"

# ============================================================================
hr; echo "PKR — a follow-up review whose RETRO is already parked annotates it (second loop keeps the comment)"; hr
# The retro base is derived from the PRIMARY base, so several comments fold onto one
# retro. post-plan.sh is basename-idempotent, so re-posting an already-parked retro
# silently dropped the new comment from the prosecutor's brief. It must annotate the
# parked retro instead. Setup: the FIRST round's review job already completed into
# tada/ and left its retro parked in plan/; a fresh review on the same PR then mints a
# new primary (the #671 tada fix) and must ANNOTATE — not re-post — the parked retro.
BARE_PKR="$TR/pkr.git"; seed_bare "$BARE_PKR"
PKR_RID=4700000800
PKR_BASE="$SLUG-pr800-review-$(printf '%s' "$PKR_RID" | sha1sum | cut -c1-8)"
pkrv="$TR/pkr-seed"; git clone -q --single-branch --branch "$BRANCH" "$BARE_PKR" "$pkrv"
mkdir -p "$pkrv/jobs/plan"
printf '# review (completed)\n\ngarden-job-complete: true\n' > "$pkrv/jobs/tada/$PKR_BASE.md"
printf -- '---\nrole: prosecutor\npriority: low\n---\n\n# Retrospective (parked)\n' \
  > "$pkrv/jobs/plan/$PKR_BASE-retro.md"
git -C "$pkrv" add -A; git -C "$pkrv" "${git_id[@]}" commit -q -m "seed a completed review + its parked retro"
git -C "$pkrv" push -q origin "HEAD:$BRANCH"; rm -rf "$pkrv"
FIX_PKR="$TR/fix-pkr.tsv"; RLOG_PKR="$TR/react-pkr.log"; : > "$RLOG_PKR"
LOG_PKR="$TR/log-pkr.txt"; : > "$LOG_PKR"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-07-29T11:00:00Z pr-review-body "$PKR_RID" 800 kriskowal \
  "https://github.com/endojs/endo-but-for-bots/pull/800#pullrequestreview-$PKR_RID" \
  '[CHANGES_REQUESTED] Guard the empty-input boundary.' > "$FIX_PKR"
run_directive "$TR/state-pkr" "$BARE_PKR" "$FIX_PKR" "$RLOG_PKR" "$LOG_PKR"
[ "$(todo_count "$BARE_PKR")" -eq 1 ] && ok "the fresh review minted its primary job" || bad "primary missing (todo=$(todo_count "$BARE_PKR"))"
[ "$(plan_count "$BARE_PKR")" -eq 1 ] && ok "no second retro forked (still exactly one parked)" || bad "plan/ count is $(plan_count "$BARE_PKR")"
PKR_BODY="$(plan_body "$BARE_PKR" "$PKR_BASE-retro")"
printf '%s' "$PKR_BODY" | grep -qF "garden-annotation: key=endojs/endo-but-for-bots#800:review:$PKR_RID:retro " \
  && ok "the parked retro carries the follow-up annotation, keyed on the retro identity" || bad "parked retro not annotated"
printf '%s' "$PKR_BODY" | grep -qF "pull/800#pullrequestreview-$PKR_RID" \
  && ok "the retro annotation names the source review" || bad "retro annotation does not cite the review"
printf '%s' "$PKR_BODY" | grep -qF 'Guard the empty-input boundary' \
  && bad "the retro annotation pasted the UNTRUSTED review body" || ok "no untrusted review text reproduced in the parked retro"
grep -qi 'annotated parked retro' "$LOG_PKR" && ok "the retro annotate path is LOGGED" || bad "retro annotate not logged ($(cat "$LOG_PKR"))"
[ "$(cursor_seen "$TR/state-pkr" "$BARE_PKR")" = 2026-07-29T11:00:00Z ] && ok "cursor advanced past the review" || bad "cursor not advanced ($(cursor_seen "$TR/state-pkr" "$BARE_PKR"))"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
