#!/bin/bash
# journal-remote-origin-rewrite-guard-test.sh — regression guard for the
# root-checkout origin-rewrite refusal in common.sh (journal_remote +
# _is_foreign_github_remote + _reheal_root_origin). Incident 2026-07-21.
#
# THE INCIDENT. A worker misused the DEPLOYED root checkout as an
# endojs/endo-but-for-bots project working tree and left the root's
# remote.origin.url rewritten to the FORK. Because a linked worktree SHARES repo
# config with its root, that single rewrite doomed every source journal_remote
# reads — the journal-worktree origin, the $GARDEN_ROOT origin fallback, and (once
# resolved and cached) the per-host cache — so journal_remote handed a FORK url to
# every FRESH doer clone, which then cloned the wrong repo and pushed the job-board
# CAS at the fork. State was sandboxed; the remote was not.
#
# THE FIX (mirrors guard_no_production_push_in_test's structural-refusal shape):
# journal_remote REFUSES to return any resolved remote that is a FOREIGN github
# repo (_is_foreign_github_remote: a github.com repo that is not the canonical
# garden repo or one of its migration aliases)
# — the exact doom signature. A doomed source is skipped with a loud REFUSED
# log; journal_remote falls through to a clean source, and from a non-shared clean
# source (cache / per-instance clone) re-asserts the correct root origin
# (_reheal_root_origin) so the doom is repaired at the source. If EVERY source is
# doomed it dies loudly naming the repair, never returning a fork url. A local
# throwaway test upstream / operator JOURNAL_REMOTE bare repo is NOT github-shaped,
# so it flows through untouched (proven here and by journal-worktree-relink-test).
#
# Cases:
#   * _is_foreign_github_remote unit table (fork -> yes; garden -> no;
#     local path -> no; empty -> no; https + scp-ssh fork forms -> yes;
#     the pre-transfer kriskowal/garden alias -> no; a SIBLING repo under the
#     garden's own new owner -> still yes, so accepting kriscendobot/garden
#     did not widen the guard to every kriscendobot repo)
#   * root origin rewritten to a fork, cache holds the garden url -> REFUSED on the
#     shared config, self-heals FROM the cache, and REPAIRS the root origin back to
#     garden (the doom is gone after one resolution)
#   * EVERY source is a fork (root/worktree + cache, no clean clone) -> die loudly,
#     message names the foreign-github diagnosis + the restore command
#   * a clean garden origin is returned unchanged (the guard never rejects the real
#     garden remote)
#
# Hermetic: a throwaway bare upstream on branch journal2 + a real clone standing in
# for $GARDEN_ROOT with a linked `journal` worktree. Fork/garden urls are validated
# as STRINGS (journal_remote only READS remote.origin.url; it never contacts it), so
# no network and no real fork are touched.
#
# Usage: journal-remote-origin-rewrite-guard-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-journal-origin-guard-test
git_id=(-c user.name=test -c user.email=test@localhost)
UP="$TR/upstream.git"      # the shared origin (a LOCAL bare repo — legit, not github)
GR="$TR/gr"                # stands in for $GARDEN_ROOT
JW="$GR/journal"           # the linked journal worktree
FORK="git@github.com:endojs/endo-but-for-bots.git"   # the doom
GARDEN_URL="git@github.com:kriscendobot/garden.git"  # the canonical garden remote
# The pre-transfer path (kriskowal/garden -> kriscendobot/garden, 2026-07-28). Still
# accepted as a MIGRATION ALIAS so a host whose origin has not been migrated is not
# stranded; GitHub redirects the old endpoint indefinitely.
GARDEN_URL_ALIAS="git@github.com:kriskowal/garden.git"

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR"
  git init -q --bare "$UP"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b main
  printf 'a\n' > "$SEED/f"; git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m m1
  git -C "$SEED" checkout -q -b journal2
  printf 'j\n' > "$SEED/f"; git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m j1
  git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin main journal2
  git -C "$UP" symbolic-ref HEAD refs/heads/main
  rm -rf "$SEED"
  git clone -q "$UP" "$GR"
  git -C "$GR" fetch -q origin journal2
  git -C "$GR" worktree add -q "$JW" journal2
}

export GARDEN_ROOT="$GR" GARDEN_STATE="$TR/state" GARDEN=testhost
export JOURNAL_BRANCH=journal2 JOURNAL_REMOTE=
CACHE="$GARDEN_STATE/config/journal-remote"

setup_fixture
# shellcheck source=../common.sh
source "$JOBS/common.sh"

# journal_remote may call die -> exit 1; run it in a subshell so the test survives.
run_journal_remote() {
  set +e
  JR_OUT="$( journal_remote 2>"$TR/jr.err" )"; JR_RC=$?
  JR_ERR="$(cat "$TR/jr.err" 2>/dev/null)"
  set -e
}

# ============================================================================
hr; echo "STATIC — common.sh parses (bash -n)"; hr
bash -n "$JOBS/common.sh" && ok "common.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "UNIT — _is_foreign_github_remote classifies the doom signature"; hr
_is_foreign_github_remote "$FORK"                         && ok "fork (scp-ssh) -> foreign" || bad "fork (scp-ssh) not flagged"
_is_foreign_github_remote "https://github.com/endojs/endo-but-for-bots.git" && ok "fork (https) -> foreign" || bad "fork (https) not flagged"
_is_foreign_github_remote "https://github.com/kriscendobot/endo-but-for-bots.git" && ok "sibling repo under the garden's OWN owner -> foreign" || bad "kriscendobot sibling repo not flagged (the guard was widened to a bare owner prefix)"
_is_foreign_github_remote "https://github.com/kriscendobot/garden-transcripts.git" && ok "owner+name PREFIX of the garden repo -> foreign" || bad "kriscendobot/garden-transcripts not flagged (the repo anchor is not exact)"
! _is_foreign_github_remote "$GARDEN_URL"                 && ok "garden remote -> NOT foreign" || bad "garden remote wrongly flagged"
! _is_foreign_github_remote "https://github.com/kriscendobot/garden"        && ok "garden (https, no .git) -> NOT foreign" || bad "garden https wrongly flagged"
! _is_foreign_github_remote "$GARDEN_URL_ALIAS"                             && ok "pre-transfer alias -> NOT foreign" || bad "migration alias wrongly flagged (a non-migrated host would be stranded)"
! _is_foreign_github_remote "https://github.com/kriskowal/garden"           && ok "pre-transfer alias (https) -> NOT foreign" || bad "migration alias https wrongly flagged"
! _is_foreign_github_remote "$UP"                         && ok "local bare upstream -> NOT foreign" || bad "local upstream wrongly flagged"
! _is_foreign_github_remote ""                            && ok "empty -> NOT foreign" || bad "empty wrongly flagged"

# ============================================================================
hr; echo "REFUSE+SELF-HEAL — root origin rewritten to a fork, cache holds garden"; hr
# The exact incident shape: the root (and thus the shared-config worktree read) is
# a fork; the per-host cache still holds the real garden url from before the doom.
# journal_remote must REFUSE the fork, self-heal from the cache, and REPAIR the root
# origin back to the garden url so the doom does not recur next tick.
setup_fixture
git -C "$GR" remote set-url origin "$FORK"               # doom the root (shared config)
mkdir -p "$(dirname "$CACHE")"; printf '%s\n' "$GARDEN_URL" > "$CACHE"   # clean cached value
run_journal_remote
[ "$JR_RC" -eq 0 ] && ok "journal_remote did NOT die (self-healed from the cache)" || bad "journal_remote died (rc=$JR_RC)"
[ "$JR_OUT" = "$GARDEN_URL" ] && ok "returned the clean garden url, NOT the fork" || bad "returned '$JR_OUT' (expected $GARDEN_URL)"
grep -qF "REFUSED" <<<"$JR_ERR" && ok "a REFUSED was logged for the fork source" || bad "no REFUSED logged: $JR_ERR"
grep -qF "$FORK" <<<"$JR_ERR" && ok "the REFUSED log names the offending fork url" || bad "REFUSED log does not name the fork: $JR_ERR"
[ "$(git -C "$GR" config --get remote.origin.url)" = "$GARDEN_URL" ] \
  && ok "root origin REPAIRED back to the garden remote" \
  || bad "root origin still doomed ($(git -C "$GR" config --get remote.origin.url))"
grep -qF "REPAIRED" <<<"$JR_ERR" && ok "the repair was logged" || bad "no REPAIRED log: $JR_ERR"

# Idempotence: a second call now reads the repaired origin straight through.
run_journal_remote
[ "$JR_RC" -eq 0 ] && [ "$JR_OUT" = "$GARDEN_URL" ] && ok "second call returns the repaired origin cleanly" || bad "second call rc=$JR_RC out='$JR_OUT'"
grep -qF "REFUSED" <<<"$JR_ERR" && bad "second call still refuses (repair did not take)" || ok "second call logs no REFUSED (doom gone)"

# ============================================================================
hr; echo "DIE — EVERY source is a fork: die loudly, never return a fork url"; hr
# Root/worktree origin is a fork AND the cache is a fork AND no clean per-instance
# clone exists. There is nothing clean to fall through to, so journal_remote must
# DIE (rc!=0) rather than hand back the fork.
setup_fixture
git -C "$GR" remote set-url origin "$FORK"
mkdir -p "$(dirname "$CACHE")"; printf '%s\n' "$FORK" > "$CACHE"
run_journal_remote
[ "$JR_RC" -ne 0 ] && ok "journal_remote died when every source is a fork" || bad "journal_remote did NOT die (rc=$JR_RC out='$JR_OUT')"
[ "$JR_OUT" != "$FORK" ] && ok "did NOT print the fork url on the die path" || bad "printed the fork url"
grep -qiF "foreign github" <<<"$JR_ERR" && ok "die message names the foreign-github diagnosis" || bad "die message missing the diagnosis: $JR_ERR"
grep -qF "remote set-url origin $GARDEN_URL" <<<"$JR_ERR" && ok "die message names the restore command" || bad "die message missing the restore command: $JR_ERR"

# ============================================================================
hr; echo "PASS-THROUGH — a clean garden origin is returned unchanged"; hr
# The guard must never reject the REAL garden remote.
setup_fixture
git -C "$GR" remote set-url origin "$GARDEN_URL"
run_journal_remote
[ "$JR_RC" -eq 0 ] && [ "$JR_OUT" = "$GARDEN_URL" ] && ok "clean garden origin returned unchanged" || bad "garden origin not returned (rc=$JR_RC out='$JR_OUT')"
grep -qF "REFUSED" <<<"$JR_ERR" && bad "clean garden origin wrongly refused: $JR_ERR" || ok "no REFUSED on the clean garden origin"

# ============================================================================
hr; echo "PASS-THROUGH — a local (non-github) upstream is returned unchanged"; hr
# Proves the guard targets ONLY foreign github repos: the hermetic local bare
# upstream (the shape every OTHER test uses) is never mistaken for the doom.
setup_fixture
run_journal_remote   # origin is $UP, a local bare repo
[ "$JR_RC" -eq 0 ] && [ "$JR_OUT" = "$UP" ] && ok "local upstream returned unchanged" || bad "local upstream not returned (rc=$JR_RC out='$JR_OUT')"
grep -qF "REFUSED" <<<"$JR_ERR" && bad "local upstream wrongly refused: $JR_ERR" || ok "no REFUSED on the local upstream"

# ============================================================================
hr
echo "journal-remote-origin-rewrite-guard-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
