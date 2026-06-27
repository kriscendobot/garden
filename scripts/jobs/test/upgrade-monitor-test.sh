#!/bin/bash
# upgrade-monitor-test.sh — coverage for the deterministic "Upgrade ready"
# detector (upgrade-monitor.sh).
#
# The monitor fetches origin/main2, compares its tip to the recorded deployed sha,
# and emits the "Upgrade ready" signal ($GARDEN_STATE/deploy/upgrade-ready) EXACTLY
# when origin is strictly ahead of the deployed sha — and is silent (and clears a
# stale signal) otherwise. No LLM, no tree side effects. See
# designs/deliberate-deploy.md § The "Upgrade ready" monitor.
#
# Hermetic: a throwaway git origin+checkout stands in for the garden tree. No real
# systemd, no real journal.
#
# Usage: upgrade-monitor-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
MON="$JOBS/upgrade-monitor.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-upgrade-monitor-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/origin.git"
git_id=(-c user.name=test -c user.email=test@localhost)

setup_fixture() {
  rm -rf "$BARE" "$TR/root" "$TR/seed" "$TR/state"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b main2
  printf '# placeholder\n' > "$SEED/README.md"
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin main2
  git clone -q --branch main2 "$BARE" "$TR/root"
  mkdir -p "$TR/state/deploy"
}

origin_commit() {  # origin_commit <msg>  — advance origin/main2 by one commit
  local wt; wt="$(mktemp -d "$TR/push.XXXXXX")"
  git clone -q --branch main2 "$BARE" "$wt"
  printf '%s\n' "$1" >> "$wt/README.md"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "$1"
  git -C "$wt" push -q origin main2
  rm -rf "$wt"
}

set_marker() { mkdir -p "$TR/state/deploy"; printf '%s\n' "$1" > "$TR/state/deploy/deployed-sha"; }
origin_head() { git -C "$BARE" rev-parse main2; }
root_head()   { git -C "$TR/root" rev-parse HEAD; }
signal_file() { printf '%s' "$TR/state/deploy/upgrade-ready"; }
have_signal() { [ -e "$(signal_file)" ]; }

run_mon() {  # fills $OUT / $RC
  set +e
  OUT="$(env GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_MAIN_BRANCH=main2 \
             bash "$MON" 2>&1)"
  RC=$?
  set -e
}

# ============================================================================
hr; echo "STATIC — upgrade-monitor.sh parses (bash -n)"; hr
bash -n "$MON" && ok "upgrade-monitor.sh parses" || bad "upgrade-monitor.sh syntax error"

# ============================================================================
hr; echo "UP TO DATE — deployed == origin: silent, no signal"; hr
setup_fixture
set_marker "$(origin_head)"
run_mon
[ "$RC" -eq 0 ] && ok "exit 0 when current" || bad "exit $RC when current"
have_signal && bad "wrote an Upgrade-ready signal while current" || ok "no signal while current (silent)"
grep -qi "Upgrade ready" <<<"$OUT" && bad "logged 'Upgrade ready' while current" || ok "no 'Upgrade ready' log while current"

# ============================================================================
hr; echo "AHEAD — origin advanced beyond the deployed sha: emit the signal"; hr
setup_fixture
dep="$(origin_head)"; set_marker "$dep"
origin_commit "feature A"; origin_commit "feature B"
avail="$(origin_head)"
run_mon
[ "$RC" -eq 0 ] && ok "exit 0 when ahead" || bad "exit $RC when ahead"
have_signal && ok "Upgrade-ready signal written when ahead" || bad "no signal when ahead"
grep -qi "Upgrade ready" <<<"$OUT" && ok "'Upgrade ready' log line emitted" || bad "no 'Upgrade ready' log line"
grep -qF "$dep" "$(signal_file)"   && ok "signal carries the deployed sha" || bad "signal missing deployed sha"
grep -qF "$avail" "$(signal_file)" && ok "signal carries the available sha" || bad "signal missing available sha"
grep -qE "ahead_by:[[:space:]]*2 " "$(signal_file)" && ok "signal reports ahead_by: 2" || bad "ahead_by count wrong: $(grep ahead_by "$(signal_file)")"

# ============================================================================
hr; echo "CLEAR STALE — a prior signal is removed once the host catches up"; hr
# (continues from the AHEAD fixture: a signal is present)
have_signal || bad "precondition: expected a signal from the AHEAD case"
set_marker "$(origin_head)"   # the deploy caught us up
run_mon
[ "$RC" -eq 0 ] && ok "exit 0 after catching up" || bad "exit $RC after catching up"
have_signal && bad "stale Upgrade-ready signal not cleared" || ok "stale signal cleared when current"
grep -qi "cleared stale" <<<"$OUT" && ok "clearing logged" || bad "clearing not logged"

# ============================================================================
hr; echo "BOOTSTRAP — no deployed-sha marker: fall back to the tree HEAD"; hr
# (a) no marker, origin == tree → silent
setup_fixture
rm -f "$TR/state/deploy/deployed-sha"
run_mon
have_signal && bad "signalled with no marker while tree == origin" || ok "no marker + current tree → silent (fallback to HEAD)"
# (b) no marker, origin ahead of tree → signal (deployed falls back to tree HEAD)
origin_commit "feature C"
run_mon
have_signal && ok "no marker + origin ahead of tree → signal (HEAD fallback)" || bad "no signal on bootstrap-ahead"
grep -qF "$(root_head)" "$(signal_file)" && ok "bootstrap signal uses the tree HEAD as deployed" || bad "bootstrap signal missing tree HEAD"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
