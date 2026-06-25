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
# I — SILENT-WATCHER ANOMALY: many consecutive zero-result ticks while the repo is
# demonstrably ACTIVE must surface a throttled maintainer alert (the failure mode
# that hid the outage for 16h). Source stub emits EMPTY; activity probe is stubbed
# active; alert is captured via GARDEN_ALERT_CMD. Threshold lowered to 3.
hr; echo "I — zero results + active source → throttled maintainer anomaly"; hr
BARE_I="$TR/i.git"; seed_bare "$BARE_I"
EMPTY_FIX="$TR/empty.tsv"; : > "$EMPTY_FIX"
ACTIVE="$TR/active.sh";   printf '#!/bin/bash\nexit 0\n' > "$ACTIVE";   chmod +x "$ACTIVE"
INACTIVE="$TR/inactive.sh"; printf '#!/bin/bash\nexit 1\n' > "$INACTIVE"; chmod +x "$INACTIVE"
ALERTLOG_I="$TR/alert-i.log"; : > "$ALERTLOG_I"
ALERTCAP="$TR/alert-cap.sh"
cat > "$ALERTCAP" <<EOF
#!/bin/bash
# capture key+message so the test can count alerts without touching the board.
printf '%s\t%s\n' "\$1" "\$2" >> "$ALERTLOG_I"
EOF
chmod +x "$ALERTCAP"
run_silent() {  # run_silent <state> <bare> <activity-probe> <alert-log-state>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" \
      CW_FIXTURE="$EMPTY_FIX" CW_REACTJI_LOG="$TR/react-i.log" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" \
      GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" \
      GARDEN_COMMENT_FALLBACK=/bin/false \
      GARDEN_COMMENT_ZERO_STREAK_THRESHOLD=3 \
      GARDEN_COMMENT_ACTIVITY="$3" \
      GARDEN_ALERT_CMD="$ALERTCAP" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1
}
# Three zero-result ticks against an ACTIVE source: streak reaches the threshold on
# the 3rd and fires exactly one alert (later ticks are throttled by the same key).
run_silent "$TR/state-i" "$BARE_I" "$ACTIVE"
run_silent "$TR/state-i" "$BARE_I" "$ACTIVE"
run_silent "$TR/state-i" "$BARE_I" "$ACTIVE"
nalert=$(grep -c "silent-comment-watcher-$SLUG" "$ALERTLOG_I" 2>/dev/null || echo 0)
[ "$nalert" -ge 1 ] && ok "anomaly surfaced once streak hit the threshold (alerts=$nalert)" || bad "no anomaly alert despite repeated zero ticks on an active source"
run_silent "$TR/state-i" "$BARE_I" "$ACTIVE"   # a 4th tick must be throttled
nalert2=$(grep -c "silent-comment-watcher-$SLUG" "$ALERTLOG_I" 2>/dev/null || echo 0)
[ "$nalert2" -eq "$nalert" ] && ok "alert is throttled (no flood: still $nalert2)" || bad "alert flooded ($nalert2 > $nalert)"

hr; echo "J — zero results while source is QUIET → NO false anomaly"; hr
BARE_J="$TR/j.git"; seed_bare "$BARE_J"
ALERTLOG_J="$TR/alert-j.log"; : > "$ALERTLOG_J"
ALERTCAP_J="$TR/alert-cap-j.sh"
cat > "$ALERTCAP_J" <<EOF
#!/bin/bash
printf '%s\t%s\n' "\$1" "\$2" >> "$ALERTLOG_J"
EOF
chmod +x "$ALERTCAP_J"
for _ in 1 2 3 4; do
  env GARDEN_STATE="$TR/state-j" JOURNAL_REMOTE="$BARE_J" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$TR/norepos" CW_FIXTURE="$EMPTY_FIX" CW_REACTJI_LOG="$TR/react-j.log" \
      GARDEN_COMMENT_SOURCE="$SRCSTUB" GARDEN_COMMENT_REACTJI="$REACTSTUB" \
      GARDEN_COMMENT_POST="$JOBS/post-job.sh" GARDEN_COMMENT_FALLBACK=/bin/false \
      GARDEN_COMMENT_ZERO_STREAK_THRESHOLD=3 GARDEN_COMMENT_ACTIVITY="$INACTIVE" \
      GARDEN_ALERT_CMD="$ALERTCAP_J" \
      "$JOBS/comment-watcher.sh" "$SLUG" >/dev/null 2>&1
done
[ ! -s "$ALERTLOG_J" ] && ok "no anomaly when the source is genuinely quiet" || bad "false anomaly on a quiet source: $(cat "$ALERTLOG_J")"

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
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
