#!/bin/bash
# root-repo-guard-test.sh — coverage for the deployed-root-repo invariant guard
# (root-repo-guard.sh), the durable fix for the 2026-07-17/07-21 job-escape incidents
# that corrupted the shared $GARDEN_ROOT/.git (HEAD moved onto a fixture `feature`
# branch; origin rewritten to an unrelated project remote).
#
# Hermetic: a throwaway bare "origin" with a main2 branch, a throwaway root checkout,
# and a per-instance state clone. GARDEN_PRODUCTION_JOURNAL_REMOTE_RE is overridden to
# match the throwaway origin path, so `is_production_journal_remote` classifies the
# fixtures without touching the real kriskowal/garden. Alerts are captured via
# GARDEN_ALERT_CMD. No real garden, journal, or network is touched.
#
# Usage: root-repo-guard-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
GUARD="$JOBS/root-repo-guard.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its own
# GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh / clone-keeper).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-root-guard-test
git_id=(-c user.name=test -c user.email=test@localhost)
rm -rf "$TR"; mkdir -p "$TR"

# --- fixtures ---------------------------------------------------------------
BARE="$TR/origin.git"
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b main2
echo "one"   > "$SEED/a.md"; git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m "c1"
echo "two"   > "$SEED/a.md"; git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m "c2"
echo "three" > "$SEED/a.md"; git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m "c3"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin main2
git -C "$BARE" symbolic-ref HEAD refs/heads/main2   # silence clone's "remote HEAD" warning
UP="$(git -C "$SEED" rev-parse HEAD)"         # main2 tip (c3)
MID="$(git -C "$SEED" rev-parse HEAD~1)"      # an older main2 ancestor (c2)

# The environment every guard run shares.
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
export GARDEN_ROOT="$TR/root"                 # deployed_sha() reads $GARDEN_ROOT, so pin it here
export GARDEN_MAIN_BRANCH=main2
# Classify the throwaway origin path as "the production journal remote" for this test.
export GARDEN_PRODUCTION_JOURNAL_REMOTE_RE='garden-root-guard-test/origin\.git$'
# Capture alerts instead of posting to a journal inbox.
ALERTS="$TR/alerts.log"; : > "$ALERTS"
STUB="$TR/alert-stub.sh"
printf '#!/bin/bash\nprintf "%%s\\n" "$1" >> "%s"\n' "$ALERTS" > "$STUB"; chmod +x "$STUB"
export GARDEN_ALERT_CMD="$STUB"
export GARDEN_ALERT_THROTTLE_SECS=0           # fire every alert (isolate cases; production throttles per key)
export GARDEN_FETCH_RETRIES=1                 # fast, local fetches never need retry

# A per-instance clone carrying the CANONICAL origin — the escape-proof repair source.
mkdir -p "$GARDEN_STATE/producer"
git clone -q "$BARE" "$GARDEN_STATE/producer/journal"

# The deployed-sha marker: the recorded deploy point == main2 tip.
mkdir -p "$GARDEN_STATE/deploy"
printf '%s\n' "$UP" > "$GARDEN_STATE/deploy/deployed-sha"

# (Re)build a fresh detached root checkout at the main2 tip.
fresh_root() {
  rm -rf "$GARDEN_ROOT"
  git clone -q "$BARE" "$GARDEN_ROOT"
  git -C "$GARDEN_ROOT" checkout -q --detach "$UP"
  # drop the local main2 branch so the deployed root looks like a real detached deploy
  git -C "$GARDEN_ROOT" branch -q -D main2 2>/dev/null || true
}
run_guard() { : > "$ALERTS"; "$GUARD" >/dev/null 2>&1 || true; }
head_detached() { ! git -C "$GARDEN_ROOT" symbolic-ref -q HEAD >/dev/null 2>&1; }
head_is_main2_ancestor() {
  local h; h="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet HEAD)"
  git -C "$GARDEN_ROOT" merge-base --is-ancestor "$h" \
    "$(git -C "$GARDEN_ROOT" rev-parse refs/remotes/origin/main2)" 2>/dev/null
}
alerted() { grep -q "^$1" "$ALERTS"; }

# ============================================================================
hr; echo "CASE 1 — HEALTHY: detached at main2 tip, canonical origin → no repair"; hr
fresh_root
before="$(git -C "$GARDEN_ROOT" rev-parse HEAD)"
run_guard
after="$(git -C "$GARDEN_ROOT" rev-parse HEAD)"
{ [ "$before" = "$after" ] && head_detached && head_is_main2_ancestor; } \
  && ok "healthy root untouched (still detached at the main2 tip)" || bad "healthy root disturbed ($before → $after)"
[ ! -s "$ALERTS" ] && ok "no alert on the healthy path" || bad "spurious alert(s): $(tr '\n' '|' < "$ALERTS")"

# ============================================================================
hr; echo "CASE 2 — ORIGIN DRIFT: origin rewritten to an unrelated remote → repaired"; hr
fresh_root
git -C "$GARDEN_ROOT" remote set-url origin "ssh://git@github.com/endojs/endo-but-for-bots.git"
run_guard
url="$(git -C "$GARDEN_ROOT" config --get remote.origin.url)"
printf '%s' "$url" | grep -qE "$GARDEN_PRODUCTION_JOURNAL_REMOTE_RE" \
  && ok "drifted origin repaired to the canonical remote ($url)" || bad "origin not repaired (still $url)"
alerted "root-repo-origin-repaired" && ok "origin repair alerted the maintainer" || bad "no origin-repaired alert"

# ============================================================================
hr; echo "CASE 3 — HEAD ESCAPE onto a branch (the 07-17 fixture): re-detached"; hr
fresh_root
git -C "$GARDEN_ROOT" checkout -q -b feature
echo "fixture feature commit" > "$GARDEN_ROOT/escape.txt"
git -C "$GARDEN_ROOT" add -A; git -C "$GARDEN_ROOT" "${git_id[@]}" commit -q -m "feature commit"
escaped="$(git -C "$GARDEN_ROOT" rev-parse HEAD)"
run_guard
{ head_detached && head_is_main2_ancestor; } \
  && ok "HEAD re-detached onto a main2 ancestor (off the fixture branch)" || bad "HEAD not restored (on=$(git -C "$GARDEN_ROOT" symbolic-ref -q HEAD || echo detached))"
git -C "$GARDEN_ROOT" for-each-ref --format='%(refname)' 'refs/heads/root-guard-backup' | grep -q . \
  && ok "prior HEAD preserved as a root-guard-backup/* branch" || bad "no backup ref created"
git -C "$GARDEN_ROOT" branch --contains "$escaped" 2>/dev/null | grep -q root-guard-backup \
  && ok "backup ref points at the escaped commit (lossless)" || bad "backup ref does not preserve the escaped commit"
alerted "root-repo-head-repaired" && ok "HEAD repair alerted the maintainer" || bad "no head-repaired alert"

# ============================================================================
hr; echo "CASE 4 — HEAD detached at a NON-main2 commit (fixture commit): re-detached"; hr
fresh_root
# a commit that is NOT reachable from main2
git -C "$GARDEN_ROOT" checkout -q --detach "$UP"
echo "orphan" > "$GARDEN_ROOT/orphan.txt"
git -C "$GARDEN_ROOT" add -A; git -C "$GARDEN_ROOT" "${git_id[@]}" commit -q -m "off-main2 fixture commit"
run_guard
{ head_detached && head_is_main2_ancestor; } \
  && ok "non-ancestor detached HEAD re-detached onto a main2 ancestor" || bad "non-ancestor HEAD not restored"
alerted "root-repo-head-repaired" && ok "non-ancestor HEAD repair alerted" || bad "no head-repaired alert for non-ancestor"

# ============================================================================
hr; echo "CASE 5 — DRAINING defers the HEAD repair (never fight a deploy)"; hr
fresh_root
git -C "$GARDEN_ROOT" checkout -q -b feature2
echo x > "$GARDEN_ROOT/x.txt"; git -C "$GARDEN_ROOT" add -A; git -C "$GARDEN_ROOT" "${git_id[@]}" commit -q -m "drain fixture"
mkdir -p "$GARDEN_STATE"; : > "$GARDEN_STATE/draining"
run_guard
{ ! head_detached && [ "$(git -C "$GARDEN_ROOT" symbolic-ref -q HEAD)" = "refs/heads/feature2" ]; } \
  && ok "HEAD left on its branch while draining (repair deferred)" || bad "HEAD repaired despite draining"
! alerted "root-repo-head-repaired" && ok "draining defer is a quiet skip (no repair alert, a deploy owns the tree)" || bad "repaired-alert fired despite draining"
rm -f "$GARDEN_STATE/draining"
run_guard
{ head_detached && head_is_main2_ancestor; } && ok "HEAD repaired on the next tick once draining cleared" || bad "HEAD not repaired after draining lifted"

# ============================================================================
hr; echo "CASE 6 — STALLED DEPLOY: deployed sha behind main2 past the threshold → alert once"; hr
fresh_root
# deployed at an older main2 ancestor (c2), main2 tip is c3 → behind by 1
printf '%s\n' "$MID" > "$GARDEN_STATE/deploy/deployed-sha"
rm -f "$GARDEN_STATE/root-repo-guard/behind-since" "$GARDEN_STATE/root-repo-guard/stall-alerted"
export GARDEN_DEPLOY_STALL_DAYS=3
# First tick: records behind-since, but not yet past threshold → no stall alert.
run_guard
{ [ -f "$GARDEN_STATE/root-repo-guard/behind-since" ] && ! alerted "root-repo-deploy-stalled"; } \
  && ok "first behind tick records behind-since, does not yet alert" || bad "stall alerted too eagerly / no stamp"
# Backdate the first-observed stamp beyond the threshold, then tick again.
printf '%s\n' "$(( $(date -u +%s) - 4*86400 ))" > "$GARDEN_STATE/root-repo-guard/behind-since"
run_guard
alerted "root-repo-deploy-stalled" && ok "stall past threshold alerts" || bad "no stall alert past threshold"
[ -f "$GARDEN_STATE/root-repo-guard/stall-alerted" ] && ok "stall marked alerted (once-per-window)" || bad "no stall-alerted flag"
# A second tick past threshold does NOT re-alert (deduped for the window).
run_guard
! alerted "root-repo-deploy-stalled" && ok "stall does not re-alert every tick (deduped)" || bad "stall re-alerted"
# Catching up clears the window state.
printf '%s\n' "$UP" > "$GARDEN_STATE/deploy/deployed-sha"
run_guard
{ [ ! -f "$GARDEN_STATE/root-repo-guard/behind-since" ] && [ ! -f "$GARDEN_STATE/root-repo-guard/stall-alerted" ]; } \
  && ok "catching up clears the stall window state" || bad "stall state not cleared after catch-up"
unset GARDEN_DEPLOY_STALL_DAYS

# ============================================================================
hr; echo "RESULT"; hr
echo "  PASS=$PASS FAIL=$FAIL"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
