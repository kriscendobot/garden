#!/bin/bash
# test_state_clone_keeper.sh — state-clone-keeper.sh must reclaim LEAKED
# per-identity journal clones under $GARDEN_STATE without ever touching a live
# one.
#
# Regression for two inode-starvation incidents three days apart. Every
# per-identity actor gets a full journal2 clone at $GARDEN_STATE/<kind>/<id>/journal
# (~17k-29k inodes) and nothing pruned them: on 2026-08-28
# endolin-garden-ece02cb4 reached ZERO free inodes with 3972 leaked clones and
# its whole fleet wedged (every `git clone` of journal2 ENOSPC, so no gardener
# could claim or report); on 2026-08-31 endolin-garden2-5bcdff64 held 2851
# clones — 69,052,121 inodes, 28% of the filesystem — at 1.11% free.
#
# The danger in the remedy is the mirror image of the leak: a sweeper that
# mis-identifies a LIVE clone deletes a working actor's journal out from under
# it. So most of what follows asserts what must SURVIVE.
#
# Asserts, on a throwaway journal + state tree with no network:
#   A. a dead doer's inbox clone is reclaimed;
#   B. a doer live in jobs/doin is KEPT (and one live in jobs/todo);
#   C. a clone inside the idle floor is KEPT even though its doer is dead;
#   D. a clone whose journal.lock is fresh is KEPT (a peer is mid-operation);
#   E. an unmodelled state kind is NEVER touched, by TWO independent guards;
#   F. the per-tick cap is enforced AND reported, never a silent truncation;
#   G. an unreachable journal keeps EVERYTHING (fail-safe: a board we could not
#      read must not make every doer look dead);
#   H. --dry-run removes nothing;
#   I. with systemd unreachable the unit-keyed kinds are spared, while the
#      board-keyed inbox is still reclaimed.
#
# DISCRIMINATING POWER. Verified by mutation, not assumed — every guard below was
# deliberately broken and the suite re-run:
#   caught  — dropping the `.md` strip on board files (fails B, and G);
#   caught  — dropping the idle floor (fails C);
#   caught  — ignoring a fresh journal.lock (fails D);
#   caught  — capping silently without reporting the remainder (fails F);
#   caught  — removing the systemd-reachability probe (fails I, 4 assertions);
#   caught  — removing BOTH unmodelled-kind guards at once (fails E);
#   no-op   — removing EITHER unmodelled-kind guard alone. That is deliberate
#             defence in depth, not a gap: the closed kind list and
#             kind_is_live's unknown-kind default each independently suffice, so
#             a clone of an unmodelled kind survives losing one of them.
#   no-op   — deleting the `if ! load_live_doers` bail-out. Also correct: on the
#             offline path sync_clone `exit`s the process itself, so behaviour is
#             unchanged. The keeper says so at that guard rather than claiming
#             credit for protection it does not provide.
#
# Usage: test_state_clone_keeper.sh
set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
JOBS="$PROJECT_ROOT/scripts/jobs"
KEEPER="$JOBS/state-clone-keeper.sh"
BRANCH=journal2

PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko()  { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_state_clone_keeper ==="
[ -f "$KEEPER" ] || { echo "missing $KEEPER"; exit 2; }

# Scrub ambient fleet env so a live gardener running this suite cannot splice the
# real journal/state under the fixture (the run-test.sh isolation rationale).
# shellcheck disable=SC2046  # deliberate word-splitting: unset takes many names
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# Not /tmp (may be noexec here) and not inside a git repo.
TR="$(mktemp -d "$HOME/.garden-state-keeper-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

BARE="$TR/journal.git"
STATE="$TR/state"

# --- fixture journal: a board with one live doer in doin and one in todo ------
seed_journal() {
  rm -rf "$BARE"
  git init -q --bare "$BARE"
  local seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed" || exit 1
    mkdir -p jobs/todo jobs/doin
    # Board files carry a .md extension — the liveness check must strip it. A
    # sweeper that compares the bare directory name against `live-doer.md` finds
    # NO match, concludes every doer is dead, and deletes the entire board's
    # worth of live clones. That mistake was made by hand on 2026-08-31 and is
    # the single most dangerous way to get this wrong, so it is pinned here.
    printf 'body\n' > jobs/doin/live-doin-doer.md
    printf 'body\n' > jobs/todo/live-todo-doer.md )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$BARE"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}
seed_journal

# --- fixture state: one directory per case, each a plausible clone ------------
# Real clones are git repos; the keeper only stats them, so a directory with the
# right shape is enough and keeps the fixture fast.
mk_clone() {  # mk_clone <kind> <id> <age-seconds> [lock-age-seconds]
  local kind="$1" id="$2" age="$3" lock_age="${4:-}"
  local d="$STATE/$kind/$id/journal"
  mkdir -p "$d/.git"
  printf 'x\n' > "$d/.git/HEAD"
  if [ -n "$lock_age" ]; then
    : > "$STATE/$kind/$id/journal.lock"
    touch -d "@$(( $(date +%s) - lock_age ))" "$STATE/$kind/$id/journal.lock"
  fi
  touch -d "@$(( $(date +%s) - age ))" "$d"
}

DAY=86400; MIN=60
mk_clone inbox dead-doer-1          "$DAY"
mk_clone inbox dead-doer-2          "$DAY"
mk_clone inbox live-doin-doer       "$DAY"
mk_clone inbox live-todo-doer       "$DAY"
mk_clone inbox recently-used-doer   "$MIN"
mk_clone inbox locked-doer          "$DAY" "$MIN"

# Unmodelled kinds. TWO fixtures, because they are protected by DIFFERENT
# things and only one of them actually exercises the closed kind list:
#   * $STATE/maintainer/journal is protected STRUCTURALLY — it is one level
#     shallower than the $STATE/<kind>/*/journal glob and could never match.
#   * $STATE/producer/<id>/journal has EXACTLY the swept shape and is dead by
#     every other predicate, so the ONLY thing standing between it and deletion
#     is that `producer` is absent from the closed kind list. Widen that list and
#     this fixture dies — which is the point.
mkdir -p "$STATE/maintainer/journal/.git"
touch -d "@$(( $(date +%s) - DAY ))" "$STATE/maintainer/journal"
mk_clone producer some-producer-id "$DAY"

run_keeper() {  # run_keeper [extra env assignments...] -- [args]
  env GARDEN=testhost GARDEN_ROOT="$TR/root" GARDEN_STATE="$STATE" \
      GARDEN_STATE_CLONE_KEEPER_CLONE="$TR/keeper-clone/journal" \
      JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      "$@" bash "$KEEPER" >>"$TR/keeper.out" 2>&1
}
gone()   { [ ! -e "$STATE/$1" ]; }
alive()  { [ -e "$STATE/$1/journal" ]; }

# --- H. dry-run removes nothing ----------------------------------------------
run_keeper -- --dry-run
if alive inbox/dead-doer-1; then ok "--dry-run removes nothing"; else ko "--dry-run deleted a clone"; fi

# --- A/B/C/D/E. the real sweep ------------------------------------------------
run_keeper
gone  inbox/dead-doer-1        && ok "A. dead doer's clone reclaimed"          || ko "A. dead doer's clone survived"
gone  inbox/dead-doer-2        && ok "A. second dead doer's clone reclaimed"   || ko "A. second dead doer's clone survived"
alive inbox/live-doin-doer     && ok "B. doer live in jobs/doin kept"          || ko "B. LIVE doin doer's clone was DELETED"
alive inbox/live-todo-doer     && ok "B. doer live in jobs/todo kept"          || ko "B. LIVE todo doer's clone was DELETED"
alive inbox/recently-used-doer && ok "C. clone inside the idle floor kept"     || ko "C. recently-used clone was DELETED"
alive inbox/locked-doer        && ok "D. clone with a fresh journal.lock kept" || ko "D. locked clone was DELETED"
[ -e "$STATE/maintainer/journal" ] && ok "E. unmodelled kind untouched (structurally out of glob reach)" || ko "E. \$GARDEN_STATE/maintainer was DELETED"
alive producer/some-producer-id && ok "E. unmodelled kind of the SWEPT SHAPE untouched (both guards)" || ko "E. \$GARDEN_STATE/producer/<id> was DELETED — both unmodelled-kind guards are gone"

# --- I. systemd unreachable: unit-keyed kinds are spared, inbox still swept ---
# Without systemd every worker id answers "not active", which after the idle
# floor would delete LIVE workers' clones. Same shape as an unreadable board, so
# the same fail-safe. inbox/ is keyed by the BOARD, not by systemd, so it must
# still be reclaimed — a host without systemd should not lose the largest kind.
mk_clone gardeners 4242 "$DAY"
mk_clone clerics   4242 "$DAY"
mk_clone monks     4242 "$DAY"
mk_clone monitors  gardener-4242 "$DAY"
mk_clone inbox     systemdless-dead-doer "$DAY"
: > "$TR/keeper.out"
# Simulate a systemd-less host by SHADOWING systemctl with a stub that always
# fails, first on PATH. Dropping /usr/bin from PATH instead does not work — that
# is where systemctl lives, but so do git/stat/date, so the keeper needs it.
STUB="$TR/nosystemd"; mkdir -p "$STUB"
printf '#!/bin/sh\nexit 1\n' > "$STUB/systemctl"; chmod +x "$STUB/systemctl"
run_keeper PATH="$STUB:$PATH"
alive gardeners/4242          && ok "I. systemd unreachable: gardeners kept"     || ko "I. LIVE-UNKNOWN gardener clone was DELETED without systemd"
alive clerics/4242            && ok "I. systemd unreachable: clerics kept"       || ko "I. cleric clone was DELETED without systemd"
alive monks/4242              && ok "I. systemd unreachable: monks kept"         || ko "I. monk clone was DELETED without systemd"
alive monitors/gardener-4242  && ok "I. systemd unreachable: monitors kept"      || ko "I. monitor clone was DELETED without systemd"
gone  inbox/systemdless-dead-doer && ok "I. board-keyed inbox still reclaimed"   || ko "I. inbox sweep stopped too (over-broad fail-safe)"
# Scope I's fixtures to I. They are dead by every predicate once systemd is
# reachable again, so leaving them in place would silently change how many
# candidates the cap in F has to choose from, and F asserts an EXACT remainder.
rm -rf "$STATE/gardeners/4242" "$STATE/clerics/4242" "$STATE/monks/4242" "$STATE/monitors/gardener-4242"

# --- F. the cap binds AND is reported ----------------------------------------
for i in $(seq 1 5); do mk_clone inbox "capped-doer-$i" "$DAY"; done
: > "$TR/keeper.out"
run_keeper GARDEN_STATE_CLONE_MAX_SWEEP=2
swept_now=0
for i in $(seq 1 5); do gone "inbox/capped-doer-$i" && swept_now=$((swept_now+1)); done
[ "$swept_now" -eq 2 ] && ok "F. cap enforced (2 of 5 reclaimed)" || ko "F. cap not enforced: $swept_now of 5 reclaimed"
grep -q 'CAP: 3 further clone(s)' "$TR/keeper.out" \
  && ok "F. remainder reported, not silently truncated" \
  || ko "F. cap bound without reporting the remainder (see $TR/keeper.out)"

# --- G. unreachable journal keeps everything ---------------------------------
# A board the keeper cannot read must never be treated as an EMPTY board: an
# empty board makes EVERY doer look dead, which would delete the whole host's
# live state in one tick. This is the single worst failure this script could
# have, so the fixture has to reach the guard that prevents it.
#
# Reaching it takes care. Pointing JOURNAL_REMOTE at a missing path with NO
# pre-existing clone does not test this at all: ensure_clone `die`s on the failed
# initial clone and the script exits long before the guard runs. That fixture
# passed even with the guard deleted outright. The reachable shape — and the
# realistic one, a network blip on a host that already has its clone — is a VALID
# existing clone whose remote has gone away, so ensure_clone is satisfied and
# sync_clone's fetch is what fails.
#
# The keeper clone from the runs above is deliberately left in place; destroying
# the BARE repo is what breaks the fetch.
[ -d "$TR/keeper-clone/journal/.git" ] || ko "G. fixture precondition: no keeper clone to reuse"
# Re-arm a dead doer so there is something the mutant COULD delete; without a
# fresh candidate the assertion could pass simply for want of a target.
mk_clone inbox g-canary-doer "$DAY"
rm -rf "$BARE"
: > "$TR/keeper.out"
run_keeper
if alive inbox/live-doin-doer && alive inbox/g-canary-doer; then
  ok "G. unreachable journal keeps every clone (fail-safe)"
else
  ko "G. unreachable journal caused deletions (see $TR/keeper.out)"
fi

echo
echo "test_state_clone_keeper: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
