#!/bin/bash
# clone-keeper-test.sh — coverage for the standing-bare-clone freshness keeper
# (clone-keeper.sh).
#
# Regression for the 2026-05-12..06-27 outage: the endo standing bare clone sat
# pinned at master=052b0487 for SIX WEEKS because nothing fetched it, silently
# blocking endo upstream-drift re-ingestion until a scholar cycle fast-forwarded
# it by hand. clone-keeper.sh runs that fetch + strict fast-forward on a cadence
# so the block can never re-form, and surfaces (does NOT clobber) a clone that has
# diverged.
#
# Hermetic: a throwaway upstream bare repo + a bare "tracked clone" whose `origin`
# carries NO fetch refspec (mirrors the real endo clone, where `git fetch origin
# master` advances FETCH_HEAD only and the branch ref must be moved explicitly).
# No real garden, journal, or network is touched.
#
# Usage: clone-keeper-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
KEEPER="$JOBS/clone-keeper.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-clone-keeper-test
git_id=(-c user.name=test -c user.email=test@localhost)

UP="$TR/upstream.git"
CLONE="$TR/endojs-endo.git"

# Push a commit onto upstream master. Pass --amend to REWRITE the tip (a
# divergence: the new tip does not have the old as an ancestor).
upstream_commit() {  # upstream_commit <content> <msg> [--amend]
  local wt; wt="$(mktemp -d "$TR/push.XXXXXX")"
  git clone -q --branch master "$UP" "$wt"
  printf '%s\n' "$1" > "$wt/f"
  git -C "$wt" add -A
  if [ "${3:-}" = "--amend" ]; then
    git -C "$wt" "${git_id[@]}" commit -q --amend -m "$2"
    git -C "$wt" push -q -f origin master
  else
    git -C "$wt" "${git_id[@]}" commit -q -m "$2"
    git -C "$wt" push -q origin master
  fi
  rm -rf "$wt"
}

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR/state"
  git init -q --bare "$UP"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b master
  printf 'a\n' > "$SEED/f"
  git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
  git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin master
  rm -rf "$SEED"
  # The tracked bare clone, with origin's fetch refspec REMOVED so it behaves like
  # the real endo clone: `git fetch origin master` moves FETCH_HEAD only.
  git clone -q --bare "$UP" "$CLONE"
  git -C "$CLONE" config --unset-all remote.origin.fetch 2>/dev/null || true
}

run_keeper() {  # run_keeper [extra env...] ; fills $OUT, $RC
  set +e
  OUT="$(env GARDEN_ROOT="$TR" GARDEN_STATE="$TR/state" \
             GARDEN_TRACKED_CLONES="$CLONE|origin|master" \
             GARDEN_FETCH_TIMEOUT=10 GARDEN_FETCH_RETRIES=1 \
             "$@" bash "$KEEPER" 2>&1)"
  RC=$?
  set -e
}
local_master() { git -C "$CLONE" rev-parse refs/heads/master; }

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$KEEPER" && ok "clone-keeper.sh parses" || bad "clone-keeper.sh syntax error"

# ============================================================================
hr; echo "FRESH — local == upstream: no-op, ref unchanged"; hr
setup_fixture
before="$(local_master)"
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 when already fresh" || bad "exit $RC when already fresh"
[ "$(local_master)" = "$before" ] && ok "ref unchanged when fresh" || bad "ref moved when already fresh"
grep -qF "already fresh" <<<"$OUT" && ok "logged 'already fresh'" || bad "did not log already-fresh"

# ============================================================================
hr; echo "FAST-FORWARD — upstream advanced: local master moves to the new tip"; hr
setup_fixture
old="$(local_master)"
upstream_commit b c2
upstream_tip="$(git -C "$UP" rev-parse master)"
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 on fast-forward" || bad "exit $RC on fast-forward"
[ "$(local_master)" = "$upstream_tip" ] && ok "local master advanced to upstream tip" || bad "local master did NOT advance ($(local_master) != $upstream_tip)"
grep -qF "fast-forwarded master $old -> $upstream_tip" <<<"$OUT" && ok "logged the fast-forward" || bad "did not log the fast-forward"

# ============================================================================
hr; echo "DIVERGED — upstream rewrote the tip: surfaced, NOT clobbered"; hr
setup_fixture
before="$(local_master)"
upstream_commit z c1-rewritten --amend   # new tip does not have local's tip as ancestor
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 on divergence (does not abort the fleet)" || bad "exit $RC on divergence"
[ "$(local_master)" = "$before" ] && ok "ref NOT clobbered on divergence" || bad "ref was moved despite divergence"
grep -qF "STALE:" <<<"$OUT" && ok "logged a STALE divergence anomaly" || bad "divergence not surfaced as STALE"

# ============================================================================
hr; echo "OFFLINE — remote unreachable: logged, ref left in place, exit 0"; hr
setup_fixture
before="$(local_master)"
git -C "$CLONE" remote set-url origin "$TR/does-not-exist.git"
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 when the fetch fails (never wedged)" || bad "exit $RC when fetch fails"
[ "$(local_master)" = "$before" ] && ok "ref unchanged when offline" || bad "ref moved when offline"
grep -qF "failed (offline?)" <<<"$OUT" && ok "logged the offline skip" || bad "offline skip not logged"

# ============================================================================
hr; echo "RECLONE — tracked clone deleted: next tick re-creates it from the source"; hr
setup_fixture
before="$(local_master)"
rm -rf "$CLONE"
[ ! -e "$CLONE" ] || bad "precondition: clone still present after rm"
# The source must be a URL/path (not a bare name) for a re-clone to be possible;
# $UP is the throwaway upstream, standing in for the real endo clone URL.
run_keeper GARDEN_TRACKED_CLONES="$CLONE|$UP|master"
[ "$RC" -eq 0 ] && ok "exit 0 on re-clone" || bad "exit $RC on re-clone"
git -C "$CLONE" rev-parse --git-dir >/dev/null 2>&1 && ok "missing clone re-created as a git repo" || bad "clone NOT re-created"
[ "$(local_master 2>/dev/null)" = "$before" ] && ok "re-cloned master matches upstream tip" || bad "re-cloned master wrong ($(local_master 2>/dev/null) != $before)"
grep -qF "REPAIRED:" <<<"$OUT" && ok "logged a REPAIRED line" || bad "re-clone not surfaced as REPAIRED"

# ============================================================================
hr; echo "CORRUPT — tracked dir present but not a git repo: STALE, NOT clobbered"; hr
setup_fixture
rm -rf "$CLONE"; mkdir -p "$CLONE"; printf 'junk\n' > "$CLONE/not-a-repo"
run_keeper GARDEN_TRACKED_CLONES="$CLONE|$UP|master"
[ "$RC" -eq 0 ] && ok "exit 0 on corrupt dir" || bad "exit $RC on corrupt dir"
grep -qF "STALE:" <<<"$OUT" && ok "corrupt dir surfaced as STALE" || bad "corrupt dir not surfaced as STALE"
[ -f "$CLONE/not-a-repo" ] && ok "corrupt dir NOT clobbered" || bad "corrupt dir was clobbered"

# ============================================================================
hr; echo "MISSING+UNREACHABLE — deleted clone, bad source: skip, no partial left"; hr
setup_fixture
rm -rf "$CLONE"
run_keeper GARDEN_TRACKED_CLONES="$CLONE|$TR/does-not-exist.git|master"
[ "$RC" -eq 0 ] && ok "exit 0 when re-clone source is unreachable (never wedged)" || bad "exit $RC on unreachable re-clone"
[ ! -e "$CLONE" ] && ok "no partial clone left behind" || bad "partial clone left at $CLONE"
{ grep -qF "re-clone from" <<<"$OUT" && grep -qiF "skipping" <<<"$OUT"; } && ok "logged the missing+unreachable skip" || bad "missing+unreachable skip not logged"

# ============================================================================
hr; echo "PROVISION — deleted clone, bare-name remote: URL derived from basename"; hr
setup_fixture
before="$(local_master)"
rm -rf "$CLONE"
# Lay out a local file:// "GitHub" mirror so the basename-derived URL resolves
# offline. The tracked dir basename is endojs-endo.git -> owner=endojs, name=endo,
# so with GARDEN_CLONE_URL_BASE=file://$TR/gh the keeper derives, and clones from,
# file://$TR/gh/endojs/endo.git — no network touched.
mkdir -p "$TR/gh/endojs"
git clone -q --bare "$UP" "$TR/gh/endojs/endo.git"
run_keeper GARDEN_TRACKED_CLONES="$CLONE|origin|master" \
           GARDEN_CLONE_URL_BASE="file://$TR/gh"
[ "$RC" -eq 0 ] && ok "exit 0 on provision" || bad "exit $RC on provision"
git -C "$CLONE" rev-parse --git-dir >/dev/null 2>&1 && ok "missing clone provisioned as a git repo" || bad "clone NOT provisioned"
[ "$(local_master 2>/dev/null)" = "$before" ] && ok "provisioned master matches upstream tip" || bad "provisioned master wrong ($(local_master 2>/dev/null) != $before)"
grep -qF "provisioned missing clone" <<<"$OUT" && ok "logged the provisioned line" || bad "provision not surfaced as 'provisioned missing clone'"
[ "$(git -C "$CLONE" config --get remote.origin.fetch)" = "+refs/heads/*:refs/remotes/origin/*" ] && ok "fetch refspec set on provisioned clone" || bad "fetch refspec not set on provisioned clone"

# ============================================================================
hr; echo "MISSING+UNDERIVABLE — bare name, basename not <owner>-<name>.git: skip"; hr
setup_fixture
# A tracked dir whose basename cannot be reversed into <owner>/<name> (no '-'):
# nothing to derive, so the keeper falls back to the WARN-and-skip. Offline: no
# clone is attempted at all.
NOHYPHEN="$TR/singleword.git"
run_keeper GARDEN_TRACKED_CLONES="$NOHYPHEN|origin|master" \
           GARDEN_CLONE_URL_BASE="file://$TR/gh"
[ "$RC" -eq 0 ] && ok "exit 0 when the basename cannot be derived" || bad "exit $RC on underivable basename"
[ ! -e "$NOHYPHEN" ] && ok "underivable missing clone left untouched" || bad "something was created for an underivable basename"
grep -qF "no upstream URL could be derived" <<<"$OUT" && ok "logged the underivable no-URL skip" || bad "underivable skip not logged"

# ============================================================================
hr
echo "clone-keeper-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
