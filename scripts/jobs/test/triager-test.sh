#!/bin/bash
# triager-test.sh — validate the triager's consecutive-failure circuit breaker on
# throwaway fixtures, with no GitHub and no `claude -p`. The watched repo's bare
# clone is a real local git repo; the triage HANDLER is a deterministic stub whose
# exit code the test controls; the durable failure count (cursors/failcount/<slug>)
# and the maintainer-inbox report run for real against a throwaway journal.
#
# Asserts:
#   A. repeated handler failures on the SAME sha trip the breaker after exactly
#      GARDEN_TRIAGE_FAIL_THRESHOLD handler runs: subsequent ticks exit 0 WITHOUT
#      re-invoking the handler, the failcount reaches the threshold, and EXACTLY
#      ONE maintainer-inbox report is posted (naming the slug + failing range).
#   B. a newly-observed sha CLEARS the breaker (the handler runs again); a handler
#      SUCCESS then clears the failcount and advances the main activity cursor.
#   C. a single below-threshold failure preserves the old loud-retry behavior: the
#      run exits non-zero (die), the cursor is not advanced, and NO maintainer
#      report is posted (the breaker only surfaces at the threshold).
#   D. GARDEN_TRIAGE_FAIL_THRESHOLD=0 disables the breaker entirely: every failing
#      tick dies (non-zero) and no maintainer report is ever posted.
#
# Usage: triager-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-triager-test
SLUG=kriscendobot-minion.town
REF=main
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet GARDEN_*/JOURNAL_*/SELF_HEAL_* so a live gardener running this
# test cannot splice the real journal under the fixture (the run-test.sh isolation
# rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|HANDLER_|CALL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- throwaway journal (job board + cursors + standing maintainer inbox) ------
BARE="$TR/journal.git"
seed_journal() {
  git init -q --bare "$BARE"
  local seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada cursors \
             inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada cursors \
             inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$BARE"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}
seed_journal

# --- watched repo: a real source repo + a fetch-tracking bare -----------------
# The bare mirrors the production shape: an `origin` remote with the default
# +refs/heads/*:refs/remotes/origin/* refspec, so the triager resolves new_sha from
# refs/remotes/origin/<ref> (a `git clone --bare` of a local path would populate
# refs/heads/* instead and rev-parse would echo the unresolved ref name).
SRC="$TR/src"; REPOS="$TR/repos"; mkdir -p "$REPOS"
git init -q "$SRC"; git -C "$SRC" checkout -q -b "$REF"
echo one > "$SRC/f"; git -C "$SRC" add -A; git -C "$SRC" "${git_id[@]}" commit -q -m one
seed_watched_bare() {  # (re)create the fetch-tracking bare from the current SRC
  rm -rf "$REPOS/$SLUG.git"
  git init -q --bare "$REPOS/$SLUG.git"
  git -C "$REPOS/$SLUG.git" remote add origin "$SRC"
  git -C "$REPOS/$SLUG.git" fetch -q origin
}
seed_watched_bare
SHA1="$(git -C "$SRC" rev-parse HEAD)"

# --- deterministic triage handler stub --------------------------------------
# Records each invocation (one line per call) and exits with $HANDLER_RC.
HANDLER="$TR/handler-stub.sh"
cat > "$HANDLER" <<'EOF'
#!/bin/bash
printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" >> "${CALL_LOG:?set CALL_LOG}"
exit "${HANDLER_RC:-1}"
EOF
chmod +x "$HANDLER"
CALLS="$TR/calls.log"; : > "$CALLS"

STATE="$TR/state"
run_triager() {  # run_triager <handler-rc> <threshold>  -> exits with triager's rc
  env GARDEN=testhost GARDEN_STATE="$STATE" \
      JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC="$1" CALL_LOG="$CALLS" \
      GARDEN_TRIAGE_FAIL_THRESHOLD="$2" \
      "$JOBS/triager.sh" "$SLUG" >>"$TR/triager.out" 2>&1
}
calls() { grep -c . "$CALLS" 2>/dev/null || echo 0; }

# journal readers -------------------------------------------------------------
cursor_field() {  # cursor_field <cursor-key> <field>  -> value (empty if absent)
  local d; d="$(mktemp -d "$TR/cv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d" 2>/dev/null
  local v=""
  [ -f "$d/cursors/$1" ] && v="$(sed -n "s/^$2:[[:space:]]*//p" "$d/cursors/$1" | head -1)"
  rm -rf "$d"; printf '%s' "$v"
}
maint_unread() {  # maint_unread  -> count of non-gitkeep maintainer unread messages
  local d n; d="$(mktemp -d "$TR/mv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d" 2>/dev/null
  n=$(ls -1 "$d/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$d"; printf '%s' "$n"
}
maint_body() {  # maint_body  -> concatenated body of all maintainer unread messages
  local d; d="$(mktemp -d "$TR/mb.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d" 2>/dev/null
  cat "$d/inbox/maintainer/unread"/*.md 2>/dev/null; rm -rf "$d"
}

# ============================================================================
hr; echo "A — repeated failures trip the breaker after exactly threshold runs"; hr
# threshold=3: runs 1,2,3 invoke the handler (each fails); run 3 crosses the
# threshold → breaker OPENS (exit 0, one maintainer report). runs 4,5 take the
# already-open fast path and never re-invoke the handler.
: > "$CALLS"
rc_seen=""
for i in 1 2 3 4 5; do
  set +e; run_triager 1 3; rc=$?; set -e
  rc_seen="$rc_seen $rc"
done
[ "$(calls)" -eq 3 ] && ok "handler invoked exactly 3 times (threshold), not on the 2 post-trip ticks" || bad "handler call count = $(calls) (want 3)"
# runs 1,2 die (non-zero); runs 3,4,5 exit 0 (breaker tripped / already open)
[ "$rc_seen" = " 1 1 0 0 0" ] && ok "exit codes 1 1 0 0 0 (loud below threshold, quiet once open)" || bad "exit codes were [$rc_seen] (want ' 1 1 0 0 0')"
[ "$(cursor_field "failcount/$SLUG" fail_count)" = "3" ] && ok "durable failcount reached the threshold (3)" || bad "failcount = $(cursor_field "failcount/$SLUG" fail_count) (want 3)"
[ "$(cursor_field "failcount/$SLUG" fail_sha)" = "$SHA1" ] && ok "failcount keyed to the failing new_sha" || bad "fail_sha = $(cursor_field "failcount/$SLUG" fail_sha) (want $SHA1)"
[ -z "$(cursor_field "activity/$SLUG" last_sha)" ] && ok "main activity cursor NOT advanced (still re-triageable on a new change)" || bad "activity cursor advanced despite failures ($(cursor_field "activity/$SLUG" last_sha))"
[ "$(maint_unread)" -eq 1 ] && ok "exactly ONE maintainer-inbox report posted (deduped across ticks)" || bad "maintainer reports = $(maint_unread) (want 1)"
body="$(maint_body)"
{ grep -q "$SLUG" <<<"$body" && grep -qi "circuit-breaker" <<<"$body" && grep -q "$SHA1" <<<"$body"; } \
  && ok "report names the slug, the breaker, and the failing sha" || bad "maintainer report missing slug/breaker/sha"
grep -qi "Monitoring safety" <<<"$body" && ok "report flags the § Monitoring safety watch-set question" || bad "report omits the watch-set note"

# ============================================================================
hr; echo "B — a new sha clears the breaker; a success clears failcount + advances"; hr
# Advance the source one commit → a brand-new sha. The triager fetches it itself.
echo two > "$SRC/f"; git -C "$SRC" add -A; git -C "$SRC" "${git_id[@]}" commit -q -m two
SHA2="$(git -C "$SRC" rev-parse HEAD)"
calls_before="$(calls)"
set +e; run_triager 0 3; rc=$?; set -e
[ "$rc" -eq 0 ] && ok "success tick exits 0" || bad "success tick exit = $rc"
[ "$(calls)" -eq $((calls_before + 1)) ] && ok "handler re-invoked on the new sha (breaker cleared automatically)" || bad "handler not re-invoked on the new sha"
[ "$(cursor_field "activity/$SLUG" last_sha)" = "$SHA2" ] && ok "main activity cursor advanced to the new sha on success" || bad "activity cursor = $(cursor_field "activity/$SLUG" last_sha) (want $SHA2)"
[ "$(cursor_field "failcount/$SLUG" fail_count)" = "0" ] && ok "failcount cleared to 0 on success" || bad "failcount = $(cursor_field "failcount/$SLUG" fail_count) (want 0)"
[ "$(maint_unread)" -eq 1 ] && ok "no additional maintainer report on the recovery (still 1)" || bad "maintainer reports = $(maint_unread) (want 1)"

# ============================================================================
hr; echo "C — a below-threshold failure preserves the loud-retry behavior"; hr
# Fresh journal + fresh repo so no prior failcount bleeds in. threshold=5, one fail.
rm -rf "$TR/state2"; STATE="$TR/state2"
rm -f "$BARE"/* 2>/dev/null || true; rm -rf "$BARE"; seed_journal
# re-clone a fresh bare of the (now two-commit) source so SHA is well-defined
seed_watched_bare
SHATOP="$(git -C "$SRC" rev-parse HEAD)"
: > "$CALLS"
set +e; run_triager 1 5; rc=$?; set -e
[ "$rc" -ne 0 ] && ok "below-threshold failure exits non-zero (loud retry, systemd re-invokes)" || bad "below-threshold failure exited 0 (want non-zero)"
[ "$(calls)" -eq 1 ] && ok "handler invoked once" || bad "handler calls = $(calls) (want 1)"
[ "$(cursor_field "failcount/$SLUG" fail_count)" = "1" ] && ok "failcount recorded at 1" || bad "failcount = $(cursor_field "failcount/$SLUG" fail_count) (want 1)"
[ -z "$(cursor_field "activity/$SLUG" last_sha)" ] && ok "cursor left unadvanced on the failure" || bad "cursor advanced on a failure"
[ "$(maint_unread)" -eq 0 ] && ok "NO maintainer report below the threshold (surfaces only at the breaker)" || bad "maintainer reports = $(maint_unread) (want 0)"

# ============================================================================
hr; echo "D — GARDEN_TRIAGE_FAIL_THRESHOLD=0 disables the breaker"; hr
rm -rf "$TR/state3"; STATE="$TR/state3"
rm -rf "$BARE"; seed_journal
seed_watched_bare
: > "$CALLS"
disabled_ok=1
for i in 1 2 3 4 5 6; do
  set +e; run_triager 1 0; rc=$?; set -e
  [ "$rc" -ne 0 ] || disabled_ok=0   # every failing tick must die when disabled
done
[ "$disabled_ok" -eq 1 ] && ok "every failing tick dies non-zero (breaker never suppresses)" || bad "a tick exited 0 with the breaker disabled"
[ "$(calls)" -eq 6 ] && ok "handler invoked on every tick (never short-circuited)" || bad "handler calls = $(calls) (want 6)"
[ "$(maint_unread)" -eq 0 ] && ok "no maintainer report ever posted with the breaker disabled" || bad "maintainer reports = $(maint_unread) (want 0)"

# ============================================================================
hr; echo "E — primary ref unresolvable, fallback resolves: new_sha is a single clean SHA"; hr
# Reproduce garden-triager@kriscendobot-agoric-sdk: the bare has refs/heads/<ref> but
# NO refs/remotes/origin/<ref>, so rev-parse of the PRIMARY ref fails and the FALLBACK
# (rev-parse "<ref>") resolves. Without `--verify -q`, the failed primary rev-parse
# echoes its literal argument to STDOUT (exit 128, unsuppressed by 2>/dev/null) and the
# `||` fallback appends the real SHA — a corrupted TWO-LINE new_sha. The fix makes
# rev-parse silent + empty-on-failure so new_sha is one clean line.
rm -rf "$TR/state4"; STATE="$TR/state4"
rm -rf "$BARE"; seed_journal
# A plain `git clone --bare` of a local path populates refs/heads/* only (no
# refs/remotes/origin/*), and a subsequent `fetch --all --prune` is a clean no-op that
# leaves it that way — exactly the production shape that tripped the bug.
rm -rf "$REPOS/$SLUG.git"
git clone -q --bare "$SRC" "$REPOS/$SLUG.git"
# sanity: the primary ref really is absent and the fallback really is present
git -C "$REPOS/$SLUG.git" rev-parse --verify -q "refs/remotes/origin/$REF" >/dev/null 2>&1 \
  && bad "fixture invalid: refs/remotes/origin/$REF unexpectedly present" \
  || ok "fixture: primary ref refs/remotes/origin/$REF is absent (fallback path exercised)"
HEADSHA="$(git -C "$SRC" rev-parse HEAD)"
: > "$CALLS"
set +e; run_triager 0 5; rc=$?; set -e
[ "$rc" -eq 0 ] && ok "tick resolves via fallback and succeeds (exit 0)" || bad "tick exit = $rc (a corrupted two-line new_sha would die 'ambiguous argument')"
# calls() counts NON-EMPTY lines in CALL_LOG; a newline-injected new_sha would split the
# single handler-invocation record across TWO lines, so calls==1 IS the single-line guard.
[ "$(calls)" -eq 1 ] && ok "handler invoked exactly once (CALL_LOG is a single line → new_sha carried no newline)" || bad "CALL_LOG line count = $(calls) (want 1; >1 means new_sha injected a newline)"
handler_new_sha="$(cut -f3 "$CALLS" | head -1)"
[ "$handler_new_sha" = "$HEADSHA" ] && ok "new_sha passed to the handler is the clean resolved SHA" || bad "new_sha = [$handler_new_sha] (want $HEADSHA — corrupted 'refs/remotes/origin/$REF\\n<sha>')"
[ "$(cursor_field "activity/$SLUG" last_sha)" = "$HEADSHA" ] && ok "activity cursor advanced to the clean sha" || bad "cursor = $(cursor_field "activity/$SLUG" last_sha) (want $HEADSHA)"

# ============================================================================
hr; echo "F — poisoned multi-line new_sha trips the ^[0-9a-f]{40}$ guard (dies loudly, no handler)"; hr
# Defense-in-depth for the fix in E: if a future edit ever reintroduces a two-line
# new_sha (e.g. a dropped `-q` gluing 'refs/remotes/origin/<ref>\n<sha>' together),
# the guard must FAIL LOUDLY at the source, not pass a bad revision to the handler.
# We reproduce that exact poisoning with a scoped `git` shim: it emits the corrupted
# two-line output for ONLY the primary `rev-parse … refs/remotes/origin/<ref>` call
# and passes every other git invocation through to the real binary.
rm -rf "$TR/state5"; STATE="$TR/state5"
rm -rf "$BARE"; seed_journal
seed_watched_bare   # restore the well-formed fetch-tracking bare (E left a plain clone)
REAL_GIT="$(command -v git)"
SHIMDIR="$TR/shimbin"; mkdir -p "$SHIMDIR"
cat > "$SHIMDIR/git" <<EOF
#!/bin/bash
# poison ONLY the triager's primary verify-rev-parse of refs/remotes/origin/$REF;
# pass everything else (fallback, symbolic-ref, fetch, cursor clones) to real git.
# The triager peels with ^{commit}, so the primary arg is refs/remotes/origin/<ref>^{commit}.
for _a in "\$@"; do [ "\$_a" = rev-parse ] && _rp=1; done
if [ "\${_rp:-}" = 1 ] && [ "\${@: -1}" = "refs/remotes/origin/$REF^{commit}" ]; then
  printf 'refs/remotes/origin/$REF\n%s\n' "$SHA1"   # the exact production corruption
  exit 0
fi
exec "$REAL_GIT" "\$@"
EOF
chmod +x "$SHIMDIR/git"
: > "$CALLS"
set +e
env PATH="$SHIMDIR:$PATH" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$TR/triager.out" 2>&1
rc=$?
set -e
[ "$rc" -ne 0 ] && ok "tick dies non-zero on a malformed new_sha (guard fired)" || bad "tick exit = $rc (want non-zero: the guard must reject a multi-line new_sha)"
# CALLS is zero-size iff the handler never ran (calls() doubles "0" on an empty log).
[ ! -s "$CALLS" ] && ok "handler never invoked (guard fails before the triage handoff)" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0 — a poisoned revision must not reach the handler)"
[ -z "$(cursor_field "activity/$SLUG" last_sha)" ] && ok "activity cursor NOT advanced past the poisoned change" || bad "cursor advanced to $(cursor_field "activity/$SLUG" last_sha) (want empty; a bad sha must not be committed)"

# ============================================================================
hr
echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
