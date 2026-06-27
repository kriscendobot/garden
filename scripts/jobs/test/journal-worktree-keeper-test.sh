#!/bin/bash
# journal-worktree-keeper-test.sh — coverage for the shared-journal-worktree
# freshness keeper (journal-worktree-keeper.sh).
#
# The journal/ worktree drifts unbounded (observed 2331 behind, 3 stray unpushed
# local-only commits) because the scripted pipeline works only in per-instance
# clones and common.sh intentionally never touches it. The keeper fast-forwards
# it on a cadence, but CONSERVATIVELY: it advances only a clean, non-ahead tree
# via `merge --ff-only`, and surfaces (never clobbers) a dirty or local-ahead
# worktree with a throttled alert.
#
# Three cases, mirroring the job spec:
#   * clean + behind  -> fast-forwarded to origin/journal2, no alert
#   * dirty           -> left untouched + alert (no reset/pull/stash)
#   * local-ahead     -> left untouched + alert (the 3-stray-commits shape)
#
# Hermetic: a throwaway upstream bare repo on branch journal2 + a real checkout
# of it standing in for the journal worktree. alert_maintainer is captured via
# GARDEN_ALERT_CMD so the inbox is never touched. No real garden/journal/network.
#
# Usage: journal-worktree-keeper-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
KEEPER="$JOBS/journal-worktree-keeper.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-journal-worktree-keeper-test
git_id=(-c user.name=test -c user.email=test@localhost)

UP="$TR/upstream.git"     # the shared origin (carries branch journal2)
JW="$TR/journal"          # stands in for $GARDEN_ROOT/journal
ALERTS="$TR/alerts.log"   # GARDEN_ALERT_CMD appends "<key>|<msg>" here

# Push a fresh commit onto upstream journal2 (so the worktree falls behind).
upstream_commit() {  # upstream_commit <content> <msg>
  local wt; wt="$(mktemp -d "$TR/push.XXXXXX")"
  git clone -q --branch journal2 "$UP" "$wt"
  printf '%s\n' "$1" > "$wt/f"
  git -C "$wt" add -A
  git -C "$wt" "${git_id[@]}" commit -q -m "$2"
  git -C "$wt" push -q origin journal2
  rm -rf "$wt"
}

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR/state"
  git init -q --bare "$UP"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b journal2
  printf 'a\n' > "$SEED/f"
  git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
  git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin journal2
  # Make journal2 the bare repo's HEAD so a plain clone checks it out.
  git -C "$UP" symbolic-ref HEAD refs/heads/journal2
  rm -rf "$SEED"
  # The standing journal worktree: a real checkout of journal2 with origin->UP.
  git clone -q --branch journal2 "$UP" "$JW"
  : > "$ALERTS"
}

# A tiny alert capture: GARDEN_ALERT_CMD receives (<dedup-key> <message>).
ALERT_STUB="$TR/alert-stub.sh"
write_alert_stub() {
  mkdir -p "$TR"
  cat > "$ALERT_STUB" <<EOF
#!/bin/bash
printf '%s|%s\n' "\$1" "\$2" >> "$ALERTS"
EOF
  chmod +x "$ALERT_STUB"
}

run_keeper() {  # run_keeper ; fills $OUT, $RC
  set +e
  OUT="$(env GARDEN_ROOT="$TR" GARDEN_STATE="$TR/state" \
             GARDEN_JOURNAL_WORKTREE="$JW" GARDEN_HOST=testhost \
             JOURNAL_BRANCH=journal2 \
             GARDEN_FETCH_TIMEOUT=10 GARDEN_FETCH_RETRIES=1 \
             GARDEN_ALERT_CMD="$ALERT_STUB" \
             bash "$KEEPER" 2>&1)"
  RC=$?
  set -e
}
head_sha()   { git -C "$JW" rev-parse HEAD; }
remote_sha() { git -C "$JW" rev-parse refs/remotes/origin/journal2; }
alert_count(){ local n; n="$(grep -c . "$ALERTS" 2>/dev/null)" || true; printf '%s\n' "${n:-0}"; }

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$KEEPER" && ok "journal-worktree-keeper.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "FRESH — worktree == origin: no-op, no alert"; hr
setup_fixture; write_alert_stub
before="$(head_sha)"
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 when already fresh" || bad "exit $RC when already fresh"
[ "$(head_sha)" = "$before" ] && ok "HEAD unchanged when fresh" || bad "HEAD moved when already fresh"
grep -qF "already fresh" <<<"$OUT" && ok "logged 'already fresh'" || bad "did not log already-fresh"
[ "$(alert_count)" -eq 0 ] && ok "no alert when fresh" || bad "alerted when fresh"

# ============================================================================
hr; echo "CLEAN+BEHIND — upstream advanced: worktree fast-forwarded"; hr
setup_fixture; write_alert_stub
old="$(head_sha)"
upstream_commit b c2
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 on fast-forward" || bad "exit $RC on fast-forward"
[ "$(head_sha)" = "$(remote_sha)" ] && ok "HEAD advanced to origin/journal2" || bad "HEAD did NOT advance ($(head_sha) != $(remote_sha))"
[ "$(head_sha)" != "$old" ] && ok "HEAD actually moved off the old tip" || bad "HEAD did not move"
grep -qF "fast-forwarded" <<<"$OUT" && ok "logged the fast-forward" || bad "did not log the fast-forward"
[ "$(alert_count)" -eq 0 ] && ok "no alert on a clean fast-forward" || bad "alerted on a clean fast-forward"

# ============================================================================
hr; echo "DIRTY — uncommitted change present: untouched + alert"; hr
setup_fixture; write_alert_stub
upstream_commit b c2            # something to fast-forward TO
before="$(head_sha)"
printf 'local edit\n' >> "$JW/f"   # dirty the worktree
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 on a dirty tree (never wedged)" || bad "exit $RC on dirty tree"
[ "$(head_sha)" = "$before" ] && ok "HEAD untouched on a dirty tree" || bad "HEAD moved despite dirty tree"
grep -q "local edit" "$JW/f" && ok "dirty edit preserved (no reset/clobber)" || bad "dirty edit was clobbered"
grep -qF "DIVERGED:" <<<"$OUT" && ok "logged a DIVERGED anomaly" || bad "dirty divergence not surfaced"
[ "$(alert_count)" -ge 1 ] && ok "emitted a maintainer alert" || bad "no alert on a dirty tree"
grep -qF "journal-worktree-divergence-testhost" "$ALERTS" && ok "alert carries the divergence dedup-key" || bad "alert dedup-key wrong/missing"

# ============================================================================
hr; echo "LOCAL-AHEAD — unpushed local commits: untouched + alert"; hr
setup_fixture; write_alert_stub
upstream_commit b c2            # upstream moved (so we are also behind)
printf 'stray\n' > "$JW/f"
git -C "$JW" add -A; git -C "$JW" "${git_id[@]}" commit -q -m "aborted local work"
before="$(head_sha)"
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 on local-ahead (never wedged)" || bad "exit $RC on local-ahead"
[ "$(head_sha)" = "$before" ] && ok "HEAD untouched on local-ahead (commit preserved)" || bad "local commit was clobbered"
grep -qF "DIVERGED:" <<<"$OUT" && ok "logged a DIVERGED anomaly" || bad "local-ahead divergence not surfaced"
grep -qF "local-ahead commit" <<<"$OUT" && ok "named the local-ahead divergence" || bad "did not name local-ahead commits"
[ "$(alert_count)" -ge 1 ] && ok "emitted a maintainer alert" || bad "no alert on local-ahead"

# ============================================================================
hr
echo "journal-worktree-keeper-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
