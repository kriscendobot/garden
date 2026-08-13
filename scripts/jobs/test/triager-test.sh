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
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
# Per-run temp root (mktemp), NOT a fixed shared path: ~20 gardeners can race this
# suite concurrently (the env-scrub below exists precisely because it runs under a
# live fleet), and a fixed dir makes each run's `rm -rf; mkdir` collide with a peer's
# live writes (ENOTEMPTY). A unique dir + EXIT-trap teardown isolates each run.
# Location matters on two axes: (1) NOT /tmp — it is mounted noexec here and this
# suite runs executable handler stubs from under $TR ("Permission denied" otherwise);
# (2) NOT inside a git repo — case J asserts a corrupt bare dir is "not a git repo"
# via a bare `git rev-parse`, which walks UP the tree, so a $TR under the garden
# checkout ($HOME is /home/<bot>/garden2, a repo) would falsely resolve to the garden
# .git. `dirname "$HOME"` (the bot's real home, /home/<bot>) is exec-capable and
# outside any git tree — exactly where the old fixed path lived.
TR="$(mktemp -d "$(dirname "$HOME")/.garden-triager-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
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
hr; echo "F — doomed multi-line new_sha trips the ^[0-9a-f]{40}$ guard (dies loudly, no handler)"; hr
# Defense-in-depth for the fix in E: if a future edit ever reintroduces a two-line
# new_sha (e.g. a dropped `-q` gluing 'refs/remotes/origin/<ref>\n<sha>' together),
# the guard must FAIL LOUDLY at the source, not pass a bad revision to the handler.
# We reproduce that exact dooming with a scoped `git` shim: it emits the corrupted
# two-line output for ONLY the primary `rev-parse … refs/remotes/origin/<ref>` call
# and passes every other git invocation through to the real binary.
rm -rf "$TR/state5"; STATE="$TR/state5"
rm -rf "$BARE"; seed_journal
seed_watched_bare   # restore the well-formed fetch-tracking bare (E left a plain clone)
REAL_GIT="$(command -v git)"
SHIMDIR="$TR/shimbin"; mkdir -p "$SHIMDIR"
cat > "$SHIMDIR/git" <<EOF
#!/bin/bash
# doom ONLY the triager's primary verify-rev-parse of refs/remotes/origin/$REF;
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
[ ! -s "$CALLS" ] && ok "handler never invoked (guard fails before the triage handoff)" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0 — a doomed revision must not reach the handler)"
[ -z "$(cursor_field "activity/$SLUG" last_sha)" ] && ok "activity cursor NOT advanced past the doomed change" || bad "cursor advanced to $(cursor_field "activity/$SLUG" last_sha) (want empty; a bad sha must not be committed)"

# ============================================================================
hr; echo "G — cold-start, ref DERIVED from HEAD (no GARDEN_WATCH_REF): remote-tracking ref absent, local heads/master present"; hr
# The production shape that first tripped the bug (garden-triager on a fresh bare):
# GARDEN_WATCH_REF is UNSET, so the triager derives `ref` from the bare's HEAD via
# `symbolic-ref --short HEAD` (→ master). On a cold-start `git clone --bare`, the bare
# has refs/heads/master but NO refs/remotes/origin/master, so the PRIMARY verify-rev-parse
# (refs/remotes/origin/master^{commit}) fails and the FALLBACK (master^{commit}) resolves.
# E exercises the fallback but pins the ref with GARDEN_WATCH_REF, so it never covers the
# symbolic-ref derivation path (lines ~56-58). This case leaves GARDEN_WATCH_REF empty and
# uses the `master` default branch, exactly matching the reported cold-start failure.
rm -rf "$TR/state6"; STATE="$TR/state6"
rm -rf "$BARE"; seed_journal
# A dedicated source on `master` (the earlier SRC is on $REF=main); its HEAD becomes the
# bare's HEAD after a bare clone, so symbolic-ref --short HEAD resolves to `master`.
SRCM="$TR/src-master"
git init -q "$SRCM"; git -C "$SRCM" checkout -q -b master
echo cold > "$SRCM/f"; git -C "$SRCM" add -A; git -C "$SRCM" "${git_id[@]}" commit -q -m cold
MSHA="$(git -C "$SRCM" rev-parse HEAD)"
rm -rf "$REPOS/$SLUG.git"
git clone -q --bare "$SRCM" "$REPOS/$SLUG.git"
# sanity: HEAD derives to master, the local head is present, the remote-tracking ref is not
[ "$(git -C "$REPOS/$SLUG.git" symbolic-ref --short HEAD)" = master ] \
  && ok "fixture: bare HEAD derives to master (symbolic-ref path exercised)" || bad "fixture: bare HEAD is not master"
git -C "$REPOS/$SLUG.git" rev-parse --verify -q refs/heads/master >/dev/null \
  && ok "fixture: local refs/heads/master present" || bad "fixture: refs/heads/master missing"
git -C "$REPOS/$SLUG.git" rev-parse --verify -q "refs/remotes/origin/master" >/dev/null 2>&1 \
  && bad "fixture invalid: refs/remotes/origin/master unexpectedly present" \
  || ok "fixture: remote-tracking refs/remotes/origin/master absent (cold-start shape)"
: > "$CALLS"
# NOTE: no GARDEN_WATCH_REF in this env — the triager must derive the ref itself.
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$TR/triager.out" 2>&1
rc=$?
set -e
[ "$rc" -eq 0 ] && ok "cold-start tick derives ref=master and resolves via fallback (exit 0)" || bad "tick exit = $rc (a corrupted two-line new_sha would die 'ambiguous argument')"
[ "$(calls)" -eq 1 ] && ok "handler invoked exactly once (single-line CALL_LOG → new_sha carried no newline)" || bad "CALL_LOG line count = $(calls) (want 1; >1 means new_sha injected a newline)"
handler_new_sha="$(cut -f3 "$CALLS" | head -1)"
[ "$handler_new_sha" = "$MSHA" ] && ok "new_sha passed to the handler is the clean resolved SHA" || bad "new_sha = [$handler_new_sha] (want $MSHA — corrupted 'refs/remotes/origin/master\\n<sha>')"
[ "$(cursor_field "activity/$SLUG" ref)" = master ] && ok "cursor records the DERIVED ref (master)" || bad "cursor ref = $(cursor_field "activity/$SLUG" ref) (want master)"
[ "$(cursor_field "activity/$SLUG" last_sha)" = "$MSHA" ] && ok "activity cursor advanced to the clean sha" || bad "cursor = $(cursor_field "activity/$SLUG" last_sha) (want $MSHA)"

# ============================================================================
hr; echo "H — missing bare clone: default clean skip; opt-in self-provision, never a hard die"; hr
# The watch set is journal-shared across hosts, but bare clones are host-local, so a
# host that arms this timer need not already hold the clone (the live crash-loop of
# garden-triager@* on hosts whose worktrees/ held no clone for a watched slug). A
# missing clone must be NON-FATAL — never the old hard die that drove an every-tick
# systemd failure/restart. By DEFAULT a clone-less host cleanly SKIPS (the clone-holder
# triages; case I guards the default resolving under worktrees/). Some watched repos
# (ocapn, agoric-3-proposals, cosgov) have no clone on ANY host, so a plain skip leaves
# them un-triaged forever; a host may OPT IN (GARDEN_TRIAGE_SELF_PROVISION=1) to
# SELF-PROVISION the standing bare clone (clone-keeper's derive-URL + bounded-atomic-clone
# logic) and then triage. An unreachable/underivable source under opt-in skips cleanly
# (exit 0, retry next tick) and escalates to the maintainer inbox — no crash loop.

# A capture stub for alert_maintainer (GARDEN_ALERT_CMD): records "<key>|<msg>" so the
# escalation paths are asserted OFFLINE instead of routing to the real inbox (mirrors
# clone-keeper-test.sh). The derived clone URL resolves against a LOCAL upstream
# registry ($UPSTREAMS/<owner>/<name>.git = GARDEN_CLONE_URL_BASE/<owner>/<name>.git),
# so provisioning clones with no network.
ALERTS="$TR/alerts.log"; : > "$ALERTS"
ALERT_STUB="$TR/alert-stub.sh"
cat > "$ALERT_STUB" <<EOF
#!/bin/bash
printf '%s|%s\n' "\$1" "\$2" >> "$ALERTS"
EOF
chmod +x "$ALERT_STUB"
# Read-only GitHub repository probe stub used by the fetch-verdict tests. The
# production classifier invokes it as `gh api repos/<owner>/<name> --jq ...`.
GH_STUB="$TR/gh-stub.sh"
cat > "$GH_STUB" <<'EOF'
#!/bin/bash
case "${GH_REPO_PROBE_RESULT:-exists}" in
  exists) printf '%s\n' 'kriscendobot/minion.town'; exit 0 ;;
  gone)   printf '%s\n' 'gh: Not Found (HTTP 404)' >&2; exit 1 ;;
  *)      printf '%s\n' 'dial tcp: i/o timeout' >&2; exit 1 ;;
esac
EOF
chmod +x "$GH_STUB"
UPSTREAMS="$TR/upstreams"
NOSLUG=kriscendobot-finbot                      # a watched slug with NO local clone
UPBARE="$UPSTREAMS/kriscendobot/finbot.git"     # the URL derive_clone_url resolves to
mkdir -p "$UPSTREAMS/kriscendobot"
git init -q --bare "$UPBARE"
UPSEED="$(mktemp -d "$TR/upseed.XXXXXX")"
git init -q "$UPSEED"; git -C "$UPSEED" checkout -q -b master
echo prov > "$UPSEED/f"; git -C "$UPSEED" add -A; git -C "$UPSEED" "${git_id[@]}" commit -q -m prov
PSHA="$(git -C "$UPSEED" rev-parse HEAD)"
git -C "$UPSEED" remote add origin "$UPBARE"; git -C "$UPSEED" push -q -u origin master
rm -rf "$UPSEED"

# --- H1: opt-in self-provision SUCCEEDS from the derived (local) upstream, then triages
rm -rf "$TR/state7"; STATE="$TR/state7"; rm -rf "$BARE"; seed_journal
rm -rf "$REPOS/$NOSLUG.git"
[ ! -d "$REPOS/$NOSLUG.git" ] && ok "fixture: no bare clone at \$GARDEN_REPOS/$NOSLUG.git (clone-less host shape)" || bad "fixture invalid: $NOSLUG.git unexpectedly present"
: > "$CALLS"; H1OUT="$TR/triager-h1.out"; : > "$H1OUT"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF=master \
    GARDEN_TRIAGE_SELF_PROVISION=1 \
    GARDEN_CLONE_URL_BASE="$UPSTREAMS" GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$NOSLUG" >>"$H1OUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "self-provision tick exits 0 (not a crash-looping die)" || bad "provision tick exit = $rc (want 0)"
grep -q "provisioned missing bare clone $NOSLUG" "$H1OUT" && ok "logs the provisioning of the missing clone" || bad "provisioning log missing"
[ -d "$REPOS/$NOSLUG.git" ] && ok "the bare clone now exists on this host" || bad "clone not provisioned at $REPOS/$NOSLUG.git"
[ "$(git -C "$REPOS/$NOSLUG.git" config --get remote.origin.fetch 2>/dev/null)" = '+refs/heads/*:refs/remotes/origin/*' ] \
  && ok "provisioned clone carries the origin/* fetch refspec (WORKTREES.md shape)" || bad "fetch refspec not set on the provisioned clone"
[ "$(calls)" -eq 1 ] && ok "handler invoked once after provisioning (repo now triageable)" || bad "handler calls = $(calls) (want 1)"
[ "$(cut -f3 "$CALLS" | head -1)" = "$PSHA" ] && ok "new_sha is the provisioned upstream HEAD" || bad "new_sha = [$(cut -f3 "$CALLS" | head -1)] (want $PSHA)"
[ ! -s "$ALERTS" ] && ok "no maintainer escalation on a successful provision" || bad "unexpected escalation: $(cat "$ALERTS")"

# --- H2: DEFAULT (self-provision OFF) → clean skip, the clone-holder triages --------
# With GARDEN_TRIAGE_SELF_PROVISION unset (the fleet default), a clone-less host is a
# benign no-op — it must NOT auto-clone (no surprise network / disk on every host) and
# must NOT die. This is the skip-model case I guards, asserted here with the handler +
# clone + escalation checks case I does not make.
rm -rf "$TR/state8"; STATE="$TR/state8"; rm -rf "$BARE"; seed_journal
rm -rf "$REPOS/$NOSLUG.git"
: > "$CALLS"; : > "$ALERTS"; H2OUT="$TR/triager-h2.out"; : > "$H2OUT"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF=master \
    GARDEN_CLONE_URL_BASE="$UPSTREAMS" GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$NOSLUG" >>"$H2OUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "default clone-less tick exits 0 (benign skip, not a die)" || bad "tick exit = $rc (want 0)"
grep -q "no bare clone at .*$NOSLUG.git on this host; skipping triage (a host that holds the clone triages this repo)" "$H2OUT" \
  && ok "default skip log names the missing clone and the clone-holder reason" || bad "default-skip log missing"
[ ! -d "$REPOS/$NOSLUG.git" ] && ok "no clone auto-created by default (self-provision is opt-in)" || bad "clone unexpectedly created without opt-in"
[ ! -s "$CALLS" ] && ok "handler never invoked (nothing to diff without a clone)" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0)"
[ ! -s "$ALERTS" ] && ok "no maintainer escalation on the default clean skip" || bad "unexpected escalation: $(cat "$ALERTS")"

# --- H3: source UNREACHABLE → skip + retry, escalate (no crash loop) ----------------
rm -rf "$TR/state9"; STATE="$TR/state9"; rm -rf "$BARE"; seed_journal
rm -rf "$REPOS/$NOSLUG.git"
: > "$CALLS"; : > "$ALERTS"; H3OUT="$TR/triager-h3.out"; : > "$H3OUT"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF=master \
    GARDEN_TRIAGE_SELF_PROVISION=1 \
    GARDEN_CLONE_URL_BASE="$TR/no-such-upstreams" GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_TIMEOUT=5 \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$NOSLUG" >>"$H3OUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "unreachable-source tick exits 0 (skip + retry next tick, no crash loop)" || bad "tick exit = $rc (want 0)"
grep -q "self-provision clone from .* failed" "$H3OUT" && ok "logs the failed provision (retried next tick)" || bad "provision-failed log missing"
[ ! -d "$REPOS/$NOSLUG.git" ] && ok "no partial clone left behind on a failed provision" || bad "partial clone left at $REPOS/$NOSLUG.git"
[ ! -s "$CALLS" ] && ok "handler never invoked when the clone could not be provisioned" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0)"
grep -q "^triager-provision-failed-" "$ALERTS" && ok "escalates a persistently-unreachable source to the maintainer inbox" || bad "no maintainer escalation recorded ($(cat "$ALERTS"))"

# --- H4: slug not <owner>-<name> → no derivable URL, escalate --------------------
rm -rf "$TR/state10"; STATE="$TR/state10"; rm -rf "$BARE"; seed_journal
BADSLUG=finbot                                   # no '-', so no <owner>-<name> to derive
rm -rf "$REPOS/$BADSLUG.git"
: > "$CALLS"; : > "$ALERTS"; H4OUT="$TR/triager-h4.out"; : > "$H4OUT"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF=master \
    GARDEN_TRIAGE_SELF_PROVISION=1 \
    GARDEN_CLONE_URL_BASE="$UPSTREAMS" GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$BADSLUG" >>"$H4OUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "underivable-slug tick exits 0 (no die)" || bad "tick exit = $rc (want 0)"
grep -q "no upstream URL could be derived" "$H4OUT" && ok "logs that no upstream URL is derivable from the slug" || bad "underivable log missing"
[ ! -s "$CALLS" ] && ok "handler never invoked for an underivable slug" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0)"
grep -q "^triager-provision-nourl-" "$ALERTS" && ok "escalates an underivable clone to the maintainer inbox" || bad "no maintainer escalation recorded ($(cat "$ALERTS"))"

# ============================================================================
hr; echo "I — default GARDEN_REPOS resolves to \$GARDEN_ROOT/worktrees, not /repos"; hr
# Regression guard for the original defect: GARDEN_REPOS defaulted to
# \$GARDEN_ROOT/repos, a path nothing provisions, so BARE was unresolvable and EVERY
# tick died. The canonical standing-bare-clone location is \$GARDEN_ROOT/worktrees
# (ensure-project-worktree.sh, clone-keeper.sh, WORKTREES.md). Run with GARDEN_REPOS
# UNSET and a controlled GARDEN_ROOT; the resolved $BARE the skip log names must sit
# under worktrees/, never repos/. (Every other case sets GARDEN_REPOS explicitly, so
# without this case the default could silently regress to /repos undetected.)
rm -rf "$TR/state8"; STATE="$TR/state8"
GROOT="$TR/groot"; rm -rf "$GROOT"; mkdir -p "$GROOT/worktrees"   # canonical clone dir exists, empty
DEFOUT="$TR/triager-default.out"; : > "$DEFOUT"; : > "$CALLS"
set +e
env GARDEN=testhost GARDEN_ROOT="$GROOT" GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_WATCH_REF="$REF" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$DEFOUT" 2>&1   # NOTE: GARDEN_REPOS deliberately unset
rc=$?
set -e
[ "$rc" -eq 0 ] && ok "default-path tick exits 0" || bad "tick exit = $rc (want 0)"
grep -q "no bare clone at $GROOT/worktrees/$SLUG.git" "$DEFOUT" \
  && ok "default resolved BARE under worktrees/ (\$GARDEN_ROOT/worktrees/$SLUG.git)" \
  || bad "default did NOT resolve under worktrees/ (log: $(grep 'no bare clone' "$DEFOUT" || echo '<none>'))"
! grep -q "no bare clone at $GROOT/repos/$SLUG.git" "$DEFOUT" \
  && ok "default did NOT resolve under the un-provisioned repos/ (the original bug)" \
  || bad "default still resolves under repos/ — the wrong-default regression is back"

# ============================================================================
hr; echo "J — present-but-corrupt bare dir: surface (STALE + escalate), never clobber, never die"; hr
# The guard is `! is_own_git_repo "$BARE"`, not `[ ! -d "$BARE" ]`, so a path that
# EXISTS but is not its own bare git repo (a half-populated clone, a leftover dir, a
# plain file) is caught too. Such a dir may hold un-pushed local state, so the triager
# must SURFACE it and NEVER clobber it with a re-clone (exactly as clone-keeper's
# keep_clone does) and skip cleanly rather than fall through to a `git fetch` that
# would hard-die every tick and crash-loop the unit. Run with self-provision ON to
# prove even an opted-in host does NOT clobber a corrupt dir.
rm -rf "$TR/state11"; STATE="$TR/state11"; rm -rf "$BARE"; seed_journal
rm -rf "$REPOS/$NOSLUG.git"; mkdir -p "$REPOS/$NOSLUG.git"
echo garbage > "$REPOS/$NOSLUG.git/not-a-git-object"   # exists, but not its own git repo
: > "$CALLS"; : > "$ALERTS"; H5OUT="$TR/triager-corrupt.out"; : > "$H5OUT"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF=master \
    GARDEN_TRIAGE_SELF_PROVISION=1 \
    GARDEN_CLONE_URL_BASE="$UPSTREAMS" GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$NOSLUG" >>"$H5OUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "corrupt-dir tick exits 0 (clean skip, not a crash-looping die)" || bad "tick exit = $rc (want 0)"
grep -qi "exists but is not a git repo" "$H5OUT" && ok "logs STALE: dir exists but is not a git repo" || bad "STALE corrupt-dir log missing"
[ -f "$REPOS/$NOSLUG.git/not-a-git-object" ] && ok "the corrupt dir is NOT clobbered (its contents survive)" || bad "corrupt dir was clobbered/re-cloned"
git -C "$REPOS/$NOSLUG.git" rev-parse --absolute-git-dir >/dev/null 2>&1 \
  && bad "corrupt dir was replaced by a fresh clone (clobbered)" \
  || ok "no re-clone attempted over the corrupt dir (still not a git repo)"
[ ! -s "$CALLS" ] && ok "handler never invoked on a corrupt clone (nothing to diff)" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0)"
grep -q "^triager-clone-corrupt-" "$ALERTS" && ok "escalates the corrupt clone to the maintainer inbox" || bad "no maintainer escalation recorded ($(cat "$ALERTS"))"

# ============================================================================
hr; echo "K — empty / unborn-HEAD bare clone (zero refs): skip this tick (exit 0), never die"; hr
# The own-fork auto-provisioning path (fork-watch-provisioner) can race a fork that was
# created upstream but not yet populated: the bare clone has ZERO refs, so `fetch origin`
# is a clean no-op and the rev-parse of the watched ref fails on BOTH the primary
# and fallback. Before the fix this hit the `die "cannot resolve ref"` → exit 1, failing
# the systemd unit and driving self-heal churn EVERY tick until the fork got its first
# commit. The guard must detect the empty-repo case (for-each-ref empty) and skip the tick
# with exit 0 ("no content to triage yet"), self-healing the moment a commit lands.
rm -rf "$TR/state12"; STATE="$TR/state12"; rm -rf "$BARE"; seed_journal
rm -rf "$REPOS/$SLUG.git"
git init -q --bare "$REPOS/$SLUG.git"             # a real bare git repo with NO refs
EMPTY_SRC="$TR/empty-source.git"
git init -q --bare "$EMPTY_SRC"                    # origin also has no refs, so fetch succeeds
git -C "$REPOS/$SLUG.git" remote add origin "$EMPTY_SRC"
[ -z "$(git --git-dir="$REPOS/$SLUG.git" for-each-ref --count=1 2>/dev/null)" ] \
  && ok "fixture: bare clone has zero refs (unborn HEAD, no commits)" || bad "fixture invalid: bare unexpectedly has refs"
: > "$CALLS"; KOUT="$TR/triager-empty.out"; : > "$KOUT"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$KOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "empty-clone tick exits 0 (skip this tick, not a crash-looping die)" || bad "tick exit = $rc (want 0; the die 'cannot resolve ref' bug is back)"
grep -qi "empty (unborn HEAD" "$KOUT" && ok "logs the empty/unborn-HEAD skip reason" || bad "empty-clone skip log missing (out: $(cat "$KOUT"))"
[ ! -s "$CALLS" ] && ok "handler never invoked (nothing to triage yet)" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0)"
[ -z "$(cursor_field "activity/$SLUG" last_sha)" ] && ok "activity cursor NOT advanced (nothing observed)" || bad "cursor advanced on an empty clone"

# ============================================================================
hr; echo "L — refs present but watched ref unresolvable: still dies loudly (misconfig not masked)"; hr
# The empty-repo guard (case K) must NOT swallow the genuine misconfiguration the fallback
# die targets: a clone that HAS refs but still cannot resolve the watched ref (wrong
# GARDEN_WATCH_REF, a deleted branch). for-each-ref is non-empty there, so the guard falls
# through to `die` and the tick fails loudly — a real bad config is surfaced, not skipped.
rm -rf "$TR/state13"; STATE="$TR/state13"; rm -rf "$BARE"; seed_journal
seed_watched_bare                                  # a bare WITH refs (origin/$REF resolves)
: > "$CALLS"; LOUT="$TR/triager-badref.out"; : > "$LOUT"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF=no-such-branch \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$LOUT" 2>&1
rc=$?; set -e
[ "$rc" -ne 0 ] && ok "unresolvable-ref-with-refs-present dies non-zero (misconfig not masked)" || bad "tick exit = $rc (want non-zero; the empty-guard must not swallow a real bad ref)"
grep -qi "cannot resolve ref 'no-such-branch'" "$LOUT" && ok "die names the unresolvable ref" || bad "die message missing (out: $(cat "$LOUT"))"
! grep -qi "empty (unborn HEAD" "$LOUT" && ok "did NOT take the empty-clone skip path (refs are present)" || bad "took the empty-clone path despite refs being present"
[ ! -s "$CALLS" ] && ok "handler never invoked on an unresolvable ref" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0)"

# ============================================================================
hr; echo "M — steady-state fetch failure: soft-skip, CLASSIFIED alert"; hr
# The failure is CLASSIFIED before it escalates (2026-07-28): a gone upstream
# reports immediately with the disarm remedy, a transient blip stays quiet until it
# has persisted GARDEN_TRIAGE_OFFLINE_ALERT_STREAK ticks, and any other failure
# reports at once carrying git's own words. Pre-classification every cause paged
# identically with no diagnosis attached, which is how one 20-minute network outage
# on 2026-07-24 put 9 near-identical notices across 9 repos in the maintainer inbox.
# git has NO IO timeout of its own, so an unguarded `git fetch` against a half-open SSH
# upstream (ssh://git@github.com/kriscendobot/agoric-3-proposals.git) hangs until systemd's
# TimeoutStartSec=900 SIGKILLs it — a `Terminated` + FATAL + exit-1 signature that marks the
# unit Failed and self-heal-flaps on every transient network blip (observed live for
# kriscendobot-cosgov). The steady-state fetch is bounded (timeout + SIGKILL escalation), and
# every failure exits 0 so the systemd unit cannot crash-loop. A throttled maintainer
# alert makes a persistently unreachable or gone remote visible.
# We drive each case with a scoped `git` shim (real for everything except the steady-state
# `fetch --all`), reproducing a failure without any real hang.
mk_fetch_shim() {  # mk_fetch_shim <dir> <fetch-rc> <fetch-stderr>
  local d="$1" frc="$2" ferr="$3"; mkdir -p "$d"
  cat > "$d/git" <<EOF
#!/bin/bash
# fail ONLY the steady-state clone refresh 'git --git-dir=… fetch -q --prune origin'
# (rc $frc); pass every OTHER git call — crucially the journal/cursor fetch, which is
# 'git -C … fetch origin <branch>' and carries no --all — straight through to real git.
has_git_dir=0; has_fetch=0
for _a in "\$@"; do
  [[ "\$_a" = --git-dir=* ]] && has_git_dir=1
  [ "\$_a" = fetch ] && has_fetch=1
done
[ "\$has_git_dir" -eq 1 ] && [ "\$has_fetch" -eq 1 ] && { echo fetch >> "\$GIT_FETCH_CALLS"; printf '%s\n' "$ferr" >&2; exit $frc; }
exec "$REAL_GIT" "\$@"
EOF
  chmod +x "$d/git"
}

# M0 - direct classifier contract. Authentication rejection is retryable and must
# never yield the upstream-gone verdict; the narrow repository-not-found wording
# remains the candidate-gone verdict before an API confirmation is requested.
permission_verdict="$(
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  classify_fetch_failure 'git@github.com: Permission denied (publickey).'
)"
[ "$permission_verdict" = transient-auth ] \
  && ok "classifier: Permission denied (publickey) is transient authentication" \
  || bad "classifier: publickey rejection verdict = $permission_verdict (want transient-auth)"
repository_not_found_verdict="$(
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  classify_fetch_failure 'ERROR: Repository not found.'
)"
[ "$repository_not_found_verdict" = upstream-gone ] \
  && ok "classifier: Repository not found is an upstream-gone candidate" \
  || bad "classifier: repository-not-found verdict = $repository_not_found_verdict (want upstream-gone)"
api_veto_verdict="$(
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  GARDEN_GH="$GH_STUB" GH_REPO_PROBE_RESULT=exists \
    classify_fetch_failure 'ERROR: Repository not found.' 'kriscendobot/minion.town'
)"
[ "$api_veto_verdict" = transient-repository-exists ] \
  && ok "classifier: successful gh api confirmation vetoes upstream-gone" \
  || bad "classifier: API-veto verdict = $api_veto_verdict (want transient-repository-exists)"

# M1 — transient stderr signature (Connection timed out, rc 1): clean-skip, QUIET
# on the first ticks, escalating only once the blip has persisted.
rm -rf "$TR/state14"; STATE="$TR/state14"; rm -rf "$BARE"; seed_journal
seed_watched_bare                                  # a well-formed bare (fetch would normally succeed)
mk_fetch_shim "$TR/fetch-shim-transient" 1 "ssh: connect to host github.com port 22: Connection timed out"
: > "$CALLS"; : > "$ALERTS"; MOUT="$TR/triager-fetch-transient.out"; : > "$MOUT"
FETCH_CALLS="$TR/fetch-calls-transient"; : > "$FETCH_CALLS"
set +e
env PATH="$TR/fetch-shim-transient:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_FETCH_TIMEOUT=5 GARDEN_FETCH_RETRIES=1 GARDEN_TRIAGE_FETCH_ATTEMPTS=3 GARDEN_BACKOFF_CAP_MS=5 \
    GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "transient fetch failure exits 0 for the next tick" || bad "tick exit = $rc (want 0)"
[ "$(wc -l < "$FETCH_CALLS")" -eq 3 ] && ok "transient failure is retried with backoff inside the tick" || bad "fetch attempts = $(wc -l < "$FETCH_CALLS") (want 3)"
grep -q "transient fetch failure for $SLUG" "$MOUT" && ok "transient skip logs the verdict and streak" || bad "transient-skip log missing (out: $(cat "$MOUT"))"
! grep -q "FATAL: fetch failed for $SLUG" "$MOUT" && ok "no FATAL on a transient fetch failure" || bad "a transient failure still died FATAL (out: $(cat "$MOUT"))"
[ ! -s "$ALERTS" ] && ok "a ONE-TICK blip pages nobody (weather is not an alert)" || bad "a single transient tick alerted ($(cat "$ALERTS"))"
[ ! -s "$CALLS" ] && ok "handler never invoked (no refs resolved past a skipped fetch)" || bad "handler ran ($(grep -c . "$CALLS") calls; want 0 — a failed fetch must not reach triage)"
[ -z "$(cursor_field "activity/$SLUG" last_sha)" ] && ok "activity cursor NOT advanced on a transient fetch failure" || bad "cursor advanced despite a failed fetch"

# M1b — the SAME blip, sustained: ticks 2..5 reach the streak threshold and the
# fifth escalates ONCE, with the per-slug key and the persistence in the body.
for i in 2 3 4 5; do
  set +e
  env PATH="$TR/fetch-shim-transient:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
      GARDEN=testhost GARDEN_STATE="$STATE" \
      JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
      GARDEN_FETCH_TIMEOUT=5 GARDEN_FETCH_RETRIES=1 GARDEN_TRIAGE_FETCH_ATTEMPTS=3 GARDEN_BACKOFF_CAP_MS=5 \
      GARDEN_ALERT_CMD="$ALERT_STUB" \
      GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
      GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
      "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
  set -e
done
[ "$(grep -c "triager-fetch-failed-${SLUG//[^A-Za-z0-9._-]/_}" "$ALERTS")" -eq 1 ] \
  && ok "a SUSTAINED blip escalates exactly once, at the streak threshold" || bad "streak alerts = $(grep -c . "$ALERTS") (want exactly 1): $(cat "$ALERTS")"
grep -Fq "fetch for $SLUG at $REPOS/$SLUG.git" "$ALERTS" && ok "the alert identifies the bare clone" || bad "alert omitted the bare clone ($(cat "$ALERTS"))"
grep -q "5 consecutive ticks" "$ALERTS" && ok "the alert says how long it has persisted" || bad "alert omits the persistence ($(cat "$ALERTS"))"
grep -q "Connection timed out" "$ALERTS" && ok "the alert carries git's OWN words (diagnosable without a shell)" || bad "alert omits git's stderr ($(cat "$ALERTS"))"

# M1c — recovery: the next SUCCESSFUL fetch clears the condition and says so.
: > "$ALERTS"
set +e
env GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
set -e
grep -q "RECOVERED" "$ALERTS" && ok "a successful fetch closes the loop with a recovery notice" || bad "no recovery notice on the successful tick ($(cat "$ALERTS"))"
grep -q "SUCCEEDING again" "$ALERTS" && ok "the recovery names what recovered" || bad "recovery notice is unspecific ($(cat "$ALERTS"))"

# M2 — wall-clock kill (rc 124, the observed `Terminated` case): also clean-skips.
rm -rf "$TR/state14b"; STATE="$TR/state14b"; rm -rf "$BARE"; seed_journal
seed_watched_bare
mk_fetch_shim "$TR/fetch-shim-timeout" 124 "Terminated"
: > "$CALLS"; : > "$ALERTS"; MOUT="$TR/triager-fetch-timeout.out"; : > "$MOUT"
FETCH_CALLS="$TR/fetch-calls-timeout"; : > "$FETCH_CALLS"
set +e
env PATH="$TR/fetch-shim-timeout:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_FETCH_TIMEOUT=5 GARDEN_FETCH_RETRIES=1 GARDEN_BACKOFF_CAP_MS=5 \
    GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "rc-124 wall-clock kill exits 0 for the next tick" || bad "tick exit = $rc (want 0)"
grep -q "transient fetch failure for $SLUG" "$MOUT" && ok "rc-124 skip logs the transient classification" || bad "rc-124 skip log missing (out: $(cat "$MOUT"))"
! grep -q "FATAL: fetch failed for $SLUG" "$MOUT" && ok "no FATAL on an rc-124 wall-clock kill" || bad "an rc-124 kill still died FATAL (out: $(cat "$MOUT"))"
[ ! -s "$ALERTS" ] && ok "one rc-124 kill is weather: no alert" || bad "a single rc-124 kill alerted ($(cat "$ALERTS"))"

# M3 — SIGKILL escalation (rc 137) takes the same clean-skip branch.
rm -rf "$TR/state14c"; STATE="$TR/state14c"; rm -rf "$BARE"; seed_journal
seed_watched_bare
mk_fetch_shim "$TR/fetch-shim-kill" 137 "Killed"
: > "$CALLS"; : > "$ALERTS"; MOUT="$TR/triager-fetch-kill.out"; : > "$MOUT"
FETCH_CALLS="$TR/fetch-calls-kill"; : > "$FETCH_CALLS"
set +e
env PATH="$TR/fetch-shim-kill:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_FETCH_TIMEOUT=5 GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "rc-137 SIGKILL escalation exits 0 for the next tick" || bad "tick exit = $rc (want 0)"
grep -q "transient fetch failure for $SLUG" "$MOUT" && ok "rc-137 skip logs the transient classification" || bad "rc-137 skip log missing (out: $(cat "$MOUT"))"
! grep -q "FATAL: fetch failed for $SLUG" "$MOUT" && ok "no FATAL on an rc-137 kill" || bad "an rc-137 kill still died FATAL (out: $(cat "$MOUT"))"
[ ! -s "$ALERTS" ] && ok "one rc-137 kill is weather: no alert" || bad "a single rc-137 kill alerted ($(cat "$ALERTS"))"

# M4 - an authentication rejection is retried and stays quiet until the explicit
# persistence threshold. Its eventual notice says authentication is failing and
# never claims the upstream is gone.
rm -rf "$TR/state14c"; STATE="$TR/state14c"; rm -rf "$BARE"; seed_journal
seed_watched_bare
mk_fetch_shim "$TR/fetch-shim-auth" 128 "git@github.com: Permission denied (publickey)."
: > "$CALLS"; : > "$ALERTS"; MOUT="$TR/triager-fetch-auth.out"; : > "$MOUT"
FETCH_CALLS="$TR/fetch-calls-auth"; : > "$FETCH_CALLS"
set +e
env PATH="$TR/fetch-shim-auth:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_FETCH_TIMEOUT=5 GARDEN_FETCH_RETRIES=1 GARDEN_TRIAGE_FETCH_ATTEMPTS=3 GARDEN_BACKOFF_CAP_MS=5 \
    GARDEN_TRIAGE_TRANSIENT_ALERT_STREAK=2 \
    GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "authentication rejection exits 0 for the next tick" || bad "tick exit = $rc (want 0)"
[ "$(wc -l < "$FETCH_CALLS")" -eq 3 ] && ok "authentication rejection gets three backoff retries" || bad "fetch attempts = $(wc -l < "$FETCH_CALLS") (want 3)"
[ ! -s "$ALERTS" ] && ok "one authentication-rejection tick does not alert" || bad "one auth tick alerted ($(cat "$ALERTS"))"

set +e
env PATH="$TR/fetch-shim-auth:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_FETCH_TIMEOUT=5 GARDEN_FETCH_RETRIES=1 GARDEN_TRIAGE_FETCH_ATTEMPTS=3 GARDEN_BACKOFF_CAP_MS=5 \
    GARDEN_TRIAGE_TRANSIENT_ALERT_STREAK=2 \
    GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "persistent authentication rejection still exits 0" || bad "persistent auth tick exit = $rc (want 0)"
grep -q "triager-fetch-failed-${SLUG//[^A-Za-z0-9._-]/_}" "$ALERTS" && ok "persistent authentication failure alerts at its threshold" || bad "persistent auth alert missing ($(cat "$ALERTS"))"
grep -qi "authentication is failing" "$ALERTS" && ok "persistent notice names authentication failure" || bad "persistent notice does not name authentication ($(cat "$ALERTS"))"
! grep -q "triager-upstream-gone" "$ALERTS" && ok "authentication rejection never emits upstream-gone" || bad "authentication rejection emitted upstream-gone ($(cat "$ALERTS"))"
! grep -qi "upstream appears gone" "$ALERTS" && ok "authentication notice never claims the upstream appears gone" || bad "authentication notice contains a gone claim ($(cat "$ALERTS"))"
[ -z "$(cursor_field "activity/$SLUG" last_sha)" ] && ok "activity cursor NOT advanced on an authentication failure" || bad "cursor advanced despite a failed fetch"

# M5 — a GONE upstream is NOT weather. GitHub answers a deleted/renamed repo over
# SSH with "ERROR: Repository not found." followed by "fatal: Could not read from
# remote repository." — and that second line is an OFFLINE signature, so a
# classifier that tested offline first would read a dead fork as a network blip and
# retry it silently forever (the kriscendobot/chrome-native-… case, watched and
# flapping from 2026-07-17 until a human tombstoned it on 07-28). Assert the
# gone-upstream test wins, on the FIRST tick, with the disarm remedy attached.
rm -rf "$TR/state14d"; STATE="$TR/state14d"; rm -rf "$BARE"; seed_journal
seed_watched_bare
mk_fetch_shim "$TR/fetch-shim-gone" 128 \
  "ERROR: Repository not found.
fatal: Could not read from remote repository."
: > "$CALLS"; : > "$ALERTS"; MOUT="$TR/triager-fetch-gone.out"; : > "$MOUT"
FETCH_CALLS="$TR/fetch-calls-gone"; : > "$FETCH_CALLS"
set +e
env PATH="$TR/fetch-shim-gone:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_GH="$GH_STUB" GH_REPO_PROBE_RESULT=gone \
    GARDEN_FETCH_TIMEOUT=5 GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "gone upstream exits 0 (never crash-loops the unit)" || bad "tick exit = $rc (want 0)"
grep -q "triager-upstream-gone-${SLUG//[^A-Za-z0-9._-]/_}" "$ALERTS" \
  && ok "gone upstream gets its OWN key, distinct from a fetch blip" || bad "no upstream-gone alert ($(cat "$ALERTS"))"
! grep -q "triager-fetch-failed-${SLUG//[^A-Za-z0-9._-]/_}" "$ALERTS" \
  && ok "it is NOT filed as a transient fetch failure" || bad "gone upstream misfiled as a fetch blip ($(cat "$ALERTS"))"
grep -q "watch-optout/$SLUG" "$ALERTS" && ok "the alert states the durable disarm remedy" || bad "alert omits the disarm remedy ($(cat "$ALERTS"))"
grep -q "does NOT self-heal" "$ALERTS" && ok "the alert says retrying will not fix it" || bad "alert does not distinguish it from weather ($(cat "$ALERTS"))"

# M6 - the same git diagnostic is not a gone verdict when the repository API
# answers. This is the integration-level veto that would have suppressed the
# false notices even if git had supplied a candidate-gone diagnostic.
rm -rf "$TR/state14e"; STATE="$TR/state14e"; rm -rf "$BARE"; seed_journal
seed_watched_bare
: > "$CALLS"; : > "$ALERTS"; MOUT="$TR/triager-fetch-api-veto.out"; : > "$MOUT"
FETCH_CALLS="$TR/fetch-calls-api-veto"; : > "$FETCH_CALLS"
set +e
env PATH="$TR/fetch-shim-gone:$PATH" GIT_FETCH_CALLS="$FETCH_CALLS" \
    GARDEN=testhost GARDEN_STATE="$STATE" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_REPOS="$REPOS" GARDEN_WATCH_REF="$REF" \
    GARDEN_GH="$GH_STUB" GH_REPO_PROBE_RESULT=exists \
    GARDEN_FETCH_TIMEOUT=5 GARDEN_ALERT_CMD="$ALERT_STUB" \
    GARDEN_TRIAGE_HANDLER="$HANDLER" HANDLER_RC=0 CALL_LOG="$CALLS" \
    GARDEN_TRIAGE_FAIL_THRESHOLD=5 \
    "$JOBS/triager.sh" "$SLUG" >>"$MOUT" 2>&1
rc=$?; set -e
[ "$rc" -eq 0 ] && ok "API-vetoed candidate-gone fetch exits 0 for the next tick" || bad "API-veto tick exit = $rc (want 0)"
[ ! -s "$ALERTS" ] && ok "repository API success suppresses the first-tick notice" || bad "API-vetoed fetch alerted ($(cat "$ALERTS"))"
grep -q "verdict=transient-repository-exists" "$MOUT" && ok "API success routes the git failure to the transient streak" || bad "API-veto transient verdict missing (out: $(cat "$MOUT"))"
! grep -qi "upstream gone/unreachable" "$MOUT" && ok "API-vetoed fetch is not logged as upstream gone" || bad "API-vetoed fetch logged a gone claim (out: $(cat "$MOUT"))"

# ============================================================================
hr
echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
