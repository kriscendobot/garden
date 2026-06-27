#!/bin/bash
# comment-watcher-test.sh — validate the PR/issue comment watcher on throwaway
# fixtures, with no GitHub and no claude. The comment SOURCE, the REACTJI poster,
# and (for the lost-post case) the JOB POSTER are stubbed deterministically; the
# verb mapping, reactji-before-post sequencing, idempotency, and cursor-advance
# logic under test run for real against a throwaway journal.
#
# Asserts:
#   A. a "rebase #N" comment → a rebase job + an eyes reactji + cursor advance
#   B. a non-directive comment → no job, no reactji, cursor still slides past it
#   C. re-polling an already-actioned comment → idempotent (no dup job/reactji)
#   D. a post that did NOT land on origin/journal2 → cursor does NOT advance
#
# Usage: comment-watcher-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-cw-test
SLUG=endojs-endo-but-for-bots
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

rm -rf "$TR"; mkdir -p "$TR"
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

LIESTUB="$TR/lying-post-stub.sh"
cat > "$LIESTUB" <<'EOF'
#!/bin/bash
# the observed failure mode: claims success but never lands the job on the board.
echo "posted (lie)"; exit 0
EOF
chmod +x "$LIESTUB"

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

run_watcher() {  # run_watcher <state> <bare> <fixture> <reactlog> [post-cmd]
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_POST="${5:-$JOBS/post-job.sh}" \
      GARDEN_COMMENT_FALLBACK=/bin/false \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1
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
hr; echo "D — post that did not land → cursor does NOT advance"; hr
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
FIX_D="$TR/fix-d.tsv"; RLOG_D="$TR/react-d.log"; : > "$RLOG_D"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T12:00:00Z issue-comment 333 59 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/59#issuecomment-333 \
  'please shepherd #59' > "$FIX_D"
run_watcher "$TR/state-d" "$BARE_D" "$FIX_D" "$RLOG_D" "$LIESTUB"
board_has "$BARE_D" "$SLUG-pr59-shepherd" && bad "lying poster somehow landed the job" || ok "job correctly absent (push was lost)"
seen_d="$(cursor_seen "$TR/state-d" "$BARE_D")"
[ -z "$seen_d" ] && ok "cursor did NOT advance past a lost post (will re-poll)" || bad "cursor advanced despite lost post ($seen_d)"

# ============================================================================
# Bug 2 — a trusted sender's plain-language directive (no @-mention, no verb) must
# fall back to the triager, while the same comment from an untrusted sender, and a
# non-directive from a trusted sender, stay dropped. A fallback stub stands in for
# the claude triager (returns 'attention'); trust is granted via the allowlist file
# override and DENIED by a /bin/false org-membership handler.
ALLOW="$TR/allowlist"; printf 'kriskowal\n' > "$ALLOW"
FBSTUB="$TR/attention-fallback.sh"
cat > "$FBSTUB" <<'EOF'
#!/bin/bash
# stand in for the claude triager: a directive routes to 'attention'.
echo attention
EOF
chmod +x "$FBSTUB"
# run the watcher with the directive-aware trust wiring (allowlist + deny org).
run_directive() {  # run_directive <state> <bare> <fixture> <reactlog>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$3" CW_REACTJI_LOG="$4" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_FALLBACK="$FBSTUB" \
      GARDEN_COMMENT_TRUST=/bin/false \
      GARDEN_TRUSTED_ALLOWLIST="$ALLOW" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1
}
todo_count() {  # todo_count <bare>  -> non-gitkeep entries in jobs/todo
  local v n; v="$(mktemp -d "$TR/tc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}

hr; echo "E — trusted sender plain directive (no @, no verb) → triager fallback job"; hr
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

hr; echo "G — non-directive from a TRUSTED sender → dropped"; hr
BARE_G="$TR/g.git"; seed_bare "$BARE_G"
FIX_G="$TR/fix-g.tsv"; RLOG_G="$TR/react-g.log"; : > "$RLOG_G"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-24T15:00:00Z issue-comment 666 503 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-666 \
  'Thanks for the help here!' > "$FIX_G"
run_directive "$TR/state-g" "$BARE_G" "$FIX_G" "$RLOG_G"
[ "$(todo_count "$BARE_G")" -eq 0 ] && ok "non-directive from a trusted sender dropped (no job)" || bad "non-directive posted a job"
[ ! -s "$RLOG_G" ] && ok "no reactji on a non-directive" || bad "reactji posted on chatter"

# ============================================================================
# H — the ROOT CAUSE: a missing jq must make the comment SOURCE fail LOUD, not
# emit empty. Simulate by PATH-masking jq (a shimdir of every /usr/bin tool EXCEPT
# jq; common.sh re-prepends its own gh wrapper, so gh stays resolvable). Assert the
# handler exits NONZERO, names jq on stderr, and produces NO stdout — the opposite
# of the silent-empty behaviour that hid the 2026-06-24 outage.
hr; echo "H — missing jq → comment-source-gh.sh fails LOUD (no silent empty)"; hr
SHIMDIR="$TR/nojq-bin"; mkdir -p "$SHIMDIR"
for f in /usr/bin/*; do ln -sf "$f" "$SHIMDIR/$(basename "$f")" 2>/dev/null || true; done
rm -f "$SHIMDIR/jq"   # the only tool removed
command -v jq >/dev/null 2>&1 && have_jq=1 || have_jq=0   # sanity: jq exists on the real host
SRC_OUT="$TR/h.out"; SRC_ERR="$TR/h.err"
set +e
env -i HOME="$HOME" PATH="$SHIMDIR" GARDEN_NO_MAINTAINER_ALERT=1 \
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
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_FALLBACK=/bin/false \
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
BARE_K="$TR/k.git"; seed_bare "$BARE_K"
FIX_K="$TR/fix-k.tsv"; RLOG_K="$TR/react-k.log"; : > "$RLOG_K"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T10:00:00Z issue-comment 777 513 kriscendobot \
  https://github.com/endojs/endo-but-for-bots/pull/513#issuecomment-4800685785 \
  'A subsequent rebase of this PR onto a fresh `llm` snapshot will pick it up. No action needed here until #528 merges.' > "$FIX_K"
run_watcher "$TR/state-k" "$BARE_K" "$FIX_K" "$RLOG_K"
board_has "$BARE_K" "$SLUG-pr513-rebase" && bad "verb-as-subject-matter minted a bogus rebase job (#513 regression)" || ok "no rebase job from a future-tense 'rebase' mention"
[ "$(todo_count "$BARE_K")" -eq 0 ] && ok "non-imperative verb mention posted no job at all" || bad "posted a job for verb-as-topic (todo=$(todo_count "$BARE_K"))"
[ ! -s "$RLOG_K" ] && ok "no reactji on a non-directive verb mention" || bad "reactji posted: $(cat "$RLOG_K")"
[ "$(cursor_seen "$TR/state-k" "$BARE_K")" = 2026-06-25T10:00:00Z ] && ok "cursor slid past the non-actionable verb mention" || bad "cursor did not slide"

hr; echo "L — CHANGES_REQUESTED body discussing a 'rebase' design → reader path, NOT a verb job"; hr
BARE_L="$TR/l.git"; seed_bare "$BARE_L"
FIX_L="$TR/fix-l.tsv"; RLOG_L="$TR/react-l.log"; : > "$RLOG_L"
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  2026-06-25T11:00:00Z pr-review-body 888 526 kriskowal \
  https://github.com/endojs/endo-but-for-bots/pull/526#pullrequestreview-888 \
  '[CHANGES_REQUESTED] The clean-rebase git code-mode eval scenario needs deeper folders.' > "$FIX_L"
run_directive "$TR/state-l" "$BARE_L" "$FIX_L" "$RLOG_L"
board_has "$BARE_L" "$SLUG-pr526-rebase" && bad "CHANGES_REQUESTED verb-as-topic minted a bogus rebase job (#526 regression)" || ok "no rebase job from a verb discussed in a review body"
[ "$(todo_count "$BARE_L")" -eq 1 ] && ok "review body routed to the reader (triager fallback) instead" || bad "review body not routed to reader (todo=$(todo_count "$BARE_L"))"

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
command -v jq >/dev/null 2>&1 && have_jq_q=1 || have_jq_q=0
if [ "$have_jq_q" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHQ="$TR/gh-q"; mkdir -p "$GHQ"
  cat > "$GHQ/gh" <<'EOF'
#!/bin/bash
# minimal gh stub for the comment-source review-surfacing test. Recognizes the
# four call shapes comment-source-gh.sh makes; everything else → empty array.
args="$*"
case "$args" in
  "pr list"*"--json number"*)   printf '4\n'; exit 0;;          # one open PR: #4
  *"/issues/comments"*)          printf '[]\n'; exit 0;;
  *"/pulls/comments"*)           printf '[]\n'; exit 0;;        # repo-wide inline feed (unused here)
  *"/pulls/4/comments"*)         # inline comments on #4: two tied to review 9001, none to 9002
    printf '%s\n' '[{"pull_request_review_id":9001},{"pull_request_review_id":9001}]'; exit 0;;
  *"/pulls/4/reviews"*)          # one inline-bearing empty-body review, one empty no-inline review
    printf '%s\n' '[{"id":9001,"state":"COMMENTED","body":"","submitted_at":"2026-06-25T13:00:00Z","user":{"login":"kriskowal"},"html_url":"https://x/pull/4#r9001"},{"id":9002,"state":"COMMENTED","body":"","submitted_at":"2026-06-25T13:00:00Z","user":{"login":"kriskowal"},"html_url":"https://x/pull/4#r9002"}]'; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHQ/gh"
  Q_OUT="$TR/q.out"
  env PATH="$GHQ:$PATH" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-q" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots 2026-06-25T00:00:00Z kriscendobot \
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
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_FALLBACK=/bin/false \
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
args="$*"
case "$args" in
  "pr list"*"--json number"*)   printf '7\n'; exit 0;;
  *"/issues/comments"*)          printf '[]\n'; exit 0;;
  *"/pulls/comments"*)           printf '[]\n'; exit 0;;
  *"/pulls/7/comments"*)         printf '[]\n'; exit 0;;     # no inline comments at all
  *"/pulls/7/reviews"*)
    printf '%s\n' '[{"id":7001,"state":"APPROVED","body":"","submitted_at":"2026-06-25T19:00:00Z","user":{"login":"kriskowal"},"html_url":"https://x/pull/7#r7001"},{"id":7002,"state":"COMMENTED","body":"","submitted_at":"2026-06-25T19:00:00Z","user":{"login":"kriskowal"},"html_url":"https://x/pull/7#r7002"}]'; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHZ/gh"
  Z_OUT="$TR/z.out"
  env PATH="$GHZ:$PATH" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$TR/state-z" \
    "$JOBS/handlers/comment-source-gh.sh" endojs/endo-but-for-bots 2026-06-25T00:00:00Z kriscendobot \
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
      GARDEN_COMMENT_FALLBACK=/bin/false \
      GARDEN_MENTION_ONLY_ALLOWLIST="$MOLIST" \
      GARDEN_PR_AUTHOR="$PRAUTHOR" \
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
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
