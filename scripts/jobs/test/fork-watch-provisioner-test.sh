#!/bin/bash
# fork-watch-provisioner-test.sh — validate own-fork watch auto-provisioning on
# throwaway fixtures, with no GitHub and no systemd. The journal is a local bare;
# the "worktrees shelf" and the materialization clone source are local dirs.
#
# Asserts:
#   A. no config/fork-owners on the journal → INERT (no arming, no commit)
#   B. a listed owner's bare clone → repos/<slug> + comment-repos/<slug> landed,
#      the comment record carries `sender-gate: required`, and an UNLISTED
#      owner's clone is NOT added (own-fork vs third-party distinction)
#   C. re-run → idempotent (no second commit)
#   D. watch-optout/<slug> tombstone (+ deleted arming files) → NOT re-added
#   E. materialization → the triager bare clone appears at $GARDEN_REPOS/<slug>.git
#      (staged+atomic), and is not re-cloned when already present
#   F. a dashed fork-owners entry is skipped with a warning (never misparsed)
#   G. a bare clone whose UPSTREAM 404s is NOT armed and IS auto-tombstoned
#      (watch-optout/<slug>), while a live-upstream own fork still arms normally
#   H. a FULLY armed fork whose upstream later 404s is tombstoned and disarmed
#   I. an inconclusive liveness check leaves a fully armed fork untouched; a
#      tombstone is never probed; a live fully armed fork stays untouched
#   J. retiring an ARMED fork is harder than declining to arm: an unconfirmed
#      one-off 404 is absorbed by a confirm re-check, an all-armed-forks-404 tick
#      is treated as a read-side failure and retires nothing, and a mixed tick
#      still retires the genuinely dead ones
#   K. END TO END through repo-watcher.sh: retiring an armed fork STOPS AND
#      DISABLES all four per-repo unit families in the same tick (a tombstone
#      that only silenced the journal record would leave the units flapping)
#   L. one shared inconclusive condition → ONE probe, ONE coalesced WARN, and a
#      host-local cooldown that silently defers later ticks; a repo-specific 403
#      defers only that fork; a halted tick never retires an armed fork
#   M. the production upstream probe routes through gh_api_retry, so a primary
#      quota 429 arms the host-shared cooldown and suppresses a sibling poller
#   N. silent rc=2 probes retain their status and use a bounded escalating
#      cooldown that resets after a successful probe
#   O. a silent rc=75 (GARDEN_OFFLINE_RC) probe is a quiet host-wide outage:
#      class `offline`, ONE probe, no WARN, a fixed base window (no escalation),
#      quiet deferral while live, fail-open, and a normal retry once it expires
#
# Usage: fork-watch-provisioner-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
# The fleet git wrapper skips "fresh" fetches; fixture reads must see every push.
export GARDEN_FETCH_MAX_AGE_OVERRIDE=0
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-fwp-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

BARE="$TR/journal.git"
seed="$TR/seed"
git init -q --bare "$BARE"
git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
( cd "$seed"
  mkdir -p repos comment-repos config jobs/todo
  touch repos/.gitkeep comment-repos/.gitkeep jobs/todo/.gitkeep )
git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
git -C "$seed" remote add origin "$BARE"; git -C "$seed" push -q -u origin "$BRANCH"

# journal helpers -------------------------------------------------------------
jpush() {  # jpush <path> <content...>  (write file at tip and push)
  local p="$1"; shift
  ( cd "$seed" && git pull -q origin "$BRANCH" )
  mkdir -p "$seed/$(dirname "$p")"; printf '%s\n' "$*" > "$seed/$p"
  git -C "$seed" add "$p"; git -C "$seed" "${git_id[@]}" commit -q -m "seed $p"
  git -C "$seed" push -q origin "HEAD:$BRANCH"
}
jrm() {  # jrm <path>
  ( cd "$seed" && git pull -q origin "$BRANCH" )
  git -C "$seed" rm -q "$1"; git -C "$seed" "${git_id[@]}" commit -q -m "rm $1"
  git -C "$seed" push -q origin "HEAD:$BRANCH"
}
jtip() {  # jtip <path> -> file content at tip (empty if absent)
  ( cd "$seed" && git fetch -q origin "$BRANCH" \
      && git show "origin/$BRANCH:$1" 2>/dev/null ) || true
}
jcommits() { ( cd "$seed" && git fetch -q origin "$BRANCH" && git rev-list --count "origin/$BRANCH" ); }

# fake worktrees shelf: one own-fork clone, one third-party clone --------------
WTS="$TR/worktrees"; mkdir -p "$WTS"
git init -q --bare "$WTS/kriscendobot-minion.town.git"
git init -q --bare "$WTS/thirdparty-somerepo.git"

# fake clone-source base for materialization: <base>/<owner>/<name>.git --------
GHBASE="$TR/github"; mkdir -p "$GHBASE/kriscendobot"
srcrepo="$TR/src"; git init -q "$srcrepo"
( cd "$srcrepo" && echo hi > README && git add README && git "${git_id[@]}" commit -q -m init )
git clone -q --bare "$srcrepo" "$GHBASE/kriscendobot/minion.town.git"

# hermetic upstream-existence check: exit 1 (404) for any "<owner>/<name>" listed
# in $DEADLIST, else exit 0. Keeps the whole test off GitHub — the real check is a
# `gh api` call, which run_prov never reaches because it points
# GARDEN_FORKWATCH_UPSTREAM_CHECK here.
DEADLIST="$TR/dead-upstreams"; : > "$DEADLIST"
UNKNOWNLIST="$TR/unknown-upstreams"; : > "$UNKNOWNLIST"
DENIEDLIST="$TR/denied-upstreams"; : > "$DENIEDLIST"
# a FLAKYLIST upstream 404s on its FIRST probe of a run and reads live after —
# the one-off 404 the armed-path confirm re-check exists to absorb.
FLAKYLIST="$TR/flaky-upstreams"; : > "$FLAKYLIST"
FLAKYSEEN="$TR/flaky-seen"; mkdir -p "$FLAKYSEEN"
PROBELOG="$TR/probes"; : > "$PROBELOG"
CHECK="$TR/upstream-check.sh"
cat > "$CHECK" <<'EOS'
#!/bin/bash
# args: <owner> <name>
[ -n "${PROBELOG:-}" ] && printf '%s/%s\n' "$1" "$2" >> "$PROBELOG"
if [ -f "$UNKNOWNLIST" ] && grep -qxF "$1/$2" "$UNKNOWNLIST"; then
  [ -n "${UNKNOWNMSG:-}" ] && printf '%s\n' "$UNKNOWNMSG" >&2
  exit "${UNKNOWNRC:-2}"
fi
if [ -f "${DENIEDLIST:-}" ] && grep -qxF "$1/$2" "$DENIEDLIST"; then
  echo "gh: Repository access blocked (HTTP 403)" >&2
  exit 2
fi
[ -f "$DEADLIST" ] && grep -qxF "$1/$2" "$DEADLIST" && exit 1
if [ -f "${FLAKYLIST:-}" ] && grep -qxF "$1/$2" "$FLAKYLIST"; then
  seen="$FLAKYSEEN/$1-$2"
  if [ ! -e "$seen" ]; then touch "$seen"; exit 1; fi
fi
exit 0
EOS
chmod +x "$CHECK"

run_prov() {  # run_prov [materialize] [logfile]
  env GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_WORKTREES="$WTS" GARDEN_REPOS="$TR/repos" \
      GARDEN_FORK_CLONE_URL_BASE="$GHBASE" \
      GARDEN_FORKWATCH_MATERIALIZE="${1:-0}" \
      GARDEN_FORKWATCH_UPSTREAM_CHECK="$CHECK" DEADLIST="$DEADLIST" \
      UNKNOWNLIST="$UNKNOWNLIST" PROBELOG="$PROBELOG" \
      FLAKYLIST="$FLAKYLIST" FLAKYSEEN="$FLAKYSEEN" \
      GARDEN_FORKWATCH_LIVENESS_INTERVAL="${GARDEN_FORKWATCH_LIVENESS_INTERVAL:-0}" \
      GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS="${GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS:-0}" \
      UNKNOWNMSG="${UNKNOWNMSG:-}" UNKNOWNRC="${UNKNOWNRC:-2}" DENIEDLIST="$DENIEDLIST" \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/fork-watch-provisioner.sh" >/dev/null 2>"${2:-/dev/null}"
}

# ============================================================================
hr; echo "A — no config/fork-owners → inert (no arming, no commit)"; hr
n0="$(jcommits)"
run_prov
[ "$(jcommits)" = "$n0" ] && ok "no commit landed while inert" || bad "commit landed while inert"
[ -z "$(jtip repos/kriscendobot-minion.town)" ] && ok "repos/ not armed while inert" || bad "repos/ armed while inert"

# ============================================================================
hr; echo "B — listed owner armed (sender-gated), unlisted owner NOT"; hr
jpush config/fork-owners "kriscendobot"
run_prov
[ -n "$(jtip repos/kriscendobot-minion.town)" ] && ok "repos/kriscendobot-minion.town landed" || bad "repos/ arming missing"
carm="$(jtip comment-repos/kriscendobot-minion.town)"
[ -n "$carm" ] && ok "comment-repos/kriscendobot-minion.town landed" || bad "comment-repos/ arming missing"
printf '%s' "$carm" | grep -Eqi '^sender-gate: required$' \
  && ok "comment arming record carries sender-gate: required" || bad "sender-gate line missing: $carm"
printf '%s' "$carm" | grep -q '20260709T225552Z-e61229' \
  && ok "arming record cites the authorization broadcast" || bad "authorization citation missing"
[ -z "$(jtip repos/thirdparty-somerepo)" ] && [ -z "$(jtip comment-repos/thirdparty-somerepo)" ] \
  && ok "unlisted (third-party) owner NOT auto-added" || bad "third-party repo was auto-added"

# ============================================================================
hr; echo "C — re-run → idempotent (no second commit)"; hr
n1="$(jcommits)"
run_prov
[ "$(jcommits)" = "$n1" ] && ok "idempotent re-run landed nothing" || bad "re-run landed a commit"

# ============================================================================
hr; echo "D — watch-optout tombstone → never re-added"; hr
jpush watch-optout/kriscendobot-minion.town "unwatched by test"
jrm repos/kriscendobot-minion.town
jrm comment-repos/kriscendobot-minion.town
run_prov
[ -z "$(jtip repos/kriscendobot-minion.town)" ] && [ -z "$(jtip comment-repos/kriscendobot-minion.town)" ] \
  && ok "tombstoned slug not re-added" || bad "tombstoned slug re-added"
jrm watch-optout/kriscendobot-minion.town
run_prov
[ -n "$(jtip repos/kriscendobot-minion.town)" ] \
  && ok "removing the tombstone re-enables auto-provisioning" || bad "not re-added after tombstone removal"

# ============================================================================
hr; echo "E — materialization: triager clone appears (leader-only step forced on)"; hr
run_prov 1
[ -f "$TR/repos/kriscendobot-minion.town.git/HEAD" ] \
  && ok "triager bare clone materialized at repos/<slug>.git" || bad "triager clone not materialized"
refspec="$(git -C "$TR/repos/kriscendobot-minion.town.git" config remote.origin.fetch 2>/dev/null || true)"
[ "$refspec" = '+refs/heads/*:refs/remotes/origin/*' ] \
  && ok "materialized clone carries the fetch refspec" || bad "fetch refspec wrong: $refspec"
sha1="$(git -C "$TR/repos/kriscendobot-minion.town.git" rev-parse HEAD)"
run_prov 1
sha2="$(git -C "$TR/repos/kriscendobot-minion.town.git" rev-parse HEAD)"
[ "$sha1" = "$sha2" ] && ok "existing clone left alone on re-run" || bad "clone clobbered on re-run"
# the third-party slug never got armed, so nothing tries to materialize it
[ ! -e "$TR/repos/thirdparty-somerepo.git" ] \
  && ok "no materialization for the unarmed third-party repo" || bad "third-party clone materialized"

# ============================================================================
hr; echo "F — a dashed fork-owners entry is skipped with a warning"; hr
jpush config/fork-owners "kriscendobot" "some-dashed-owner"
git init -q --bare "$WTS/some-dashed-owner-repo.git" 2>/dev/null || true
FLOG="$TR/f.log"
run_prov 0 "$FLOG"
grep -q "contains '-'" "$FLOG" && ok "dashed owner skipped with a warning" || bad "no warning for dashed owner ($(cat "$FLOG"))"
[ -z "$(jtip repos/some-dashed-owner-repo)" ] && ok "dashed owner's repo not armed" || bad "dashed owner's repo armed"

# ============================================================================
hr; echo "G — dead-upstream clone: not armed, auto-tombstoned; live fork still arms"; hr
# A leftover bare clone of a fork whose upstream was DELETED (gh 404). Owner is
# listed (own fork), so without the guard DISCOVER would arm it and the three
# per-repo watchers would FATAL-flap. The guard must skip + auto-tombstone it.
jpush config/fork-owners "kriscendobot"             # case F left a mangled entry; restore a clean own-fork owner set
git init -q --bare "$WTS/kriscendobot-deadfork.git"
echo "kriscendobot/deadfork" > "$DEADLIST"          # this upstream 404s
# ensure the live own fork is armable again for the co-existence assertion
[ -n "$(jtip watch-optout/kriscendobot-minion.town)" ] && jrm watch-optout/kriscendobot-minion.town || true
GLOG="$TR/g.log"
run_prov 0 "$GLOG"
[ -z "$(jtip repos/kriscendobot-deadfork)" ] && [ -z "$(jtip comment-repos/kriscendobot-deadfork)" ] \
  && ok "dead-upstream fork NOT armed" || bad "dead-upstream fork was armed"
[ -n "$(jtip watch-optout/kriscendobot-deadfork)" ] \
  && ok "dead-upstream fork auto-tombstoned (watch-optout landed)" || bad "no watch-optout tombstone for dead fork"
jtip watch-optout/kriscendobot-deadfork | grep -qi '404' \
  && ok "tombstone records the 404 reason" || bad "tombstone missing 404 reason"
[ -n "$(jtip repos/kriscendobot-minion.town)" ] \
  && ok "live-upstream own fork still armed alongside the dead one" || bad "live fork not armed"
# re-run: tombstoned dead fork is a no-op (never probed/armed again)
: > "$DEADLIST"   # even if the upstream 'came back', the tombstone wins
n_g="$(jcommits)"
run_prov
[ "$(jcommits)" = "$n_g" ] && ok "tombstoned dead fork not re-armed on re-run" || bad "dead fork re-armed after tombstone"

# ============================================================================
hr; echo "H — fully armed fork later 404s → tombstoned and disarmed"; hr
# minion.town has both records from B. Its later 404 must take the same DEAD[]
# path as an unarmed candidate, which drops both records in the tombstone commit.
echo "kriscendobot/minion.town" > "$DEADLIST"
: > "$PROBELOG"
run_prov
[ -n "$(jtip watch-optout/kriscendobot-minion.town)" ] \
  && ok "fully armed 404 fork auto-tombstoned" || bad "fully armed 404 fork was not tombstoned"
[ -z "$(jtip repos/kriscendobot-minion.town)" ] && [ -z "$(jtip comment-repos/kriscendobot-minion.town)" ] \
  && ok "fully armed 404 fork disarmed by removing both records" || bad "fully armed 404 fork retained an arming record"
grep -qxF "kriscendobot/minion.town" "$PROBELOG" \
  && ok "fully armed fork was liveness-probed" || bad "fully armed fork was not liveness-probed"

# ============================================================================
hr; echo "I — inconclusive/tombstoned/live liveness outcomes"; hr
git init -q --bare "$WTS/kriscendobot-inconclusive.git"
: > "$DEADLIST"; : > "$UNKNOWNLIST"
run_prov                              # first arm the new live fork
echo "kriscendobot/inconclusive" > "$UNKNOWNLIST"
: > "$PROBELOG"
n_i="$(jcommits)"
run_prov
[ -n "$(jtip repos/kriscendobot-inconclusive)" ] && [ -n "$(jtip comment-repos/kriscendobot-inconclusive)" ] \
  && ok "inconclusive fully armed fork retains both arming records" || bad "inconclusive check removed an arming record"
[ -z "$(jtip watch-optout/kriscendobot-inconclusive)" ] \
  && ok "inconclusive check never tombstones" || bad "inconclusive check falsely tombstoned"
[ "$(jcommits)" = "$n_i" ] && ok "inconclusive check lands no journal mutation" || bad "inconclusive check mutated the journal"

# An existing tombstone is checked before the API seam, even when rate limiting
# is disabled for this hermetic regression test.
git init -q --bare "$WTS/kriscendobot-never-probe.git"
jpush watch-optout/kriscendobot-never-probe "unwatched by test"
: > "$PROBELOG"
run_prov
grep -qxF "kriscendobot/never-probe" "$PROBELOG" \
  && bad "tombstoned slug was re-probed" || ok "tombstoned slug was never re-probed"

# Once a liveness probe succeeds, the local four-hour stamp avoids further API
# reads until stale. The live fork's records remain untouched in either case.
: > "$UNKNOWNLIST"; : > "$PROBELOG"
GARDEN_FORKWATCH_LIVENESS_INTERVAL=14400 run_prov
n_live="$(jcommits)"
: > "$PROBELOG"
GARDEN_FORKWATCH_LIVENESS_INTERVAL=14400 run_prov
[ ! -s "$PROBELOG" ] && ok "fresh successful liveness stamp rate-limits re-probes" || bad "fresh liveness stamp did not rate-limit probes"
[ -n "$(jtip repos/kriscendobot-inconclusive)" ] && [ -n "$(jtip comment-repos/kriscendobot-inconclusive)" ] \
  && ok "live fully armed fork remains armed" || bad "live fully armed fork changed"
[ "$(jcommits)" = "$n_live" ] && ok "live liveness probe does not mutate the journal" || bad "live liveness probe mutated the journal"

# ============================================================================
hr; echo "J — retiring an ARMED fork is harder than declining to arm"; hr
# Three more live own forks, armed normally, so the armed set is big enough to
# distinguish "one fork was deleted" from "every read failed".
for s in massa massb flaky; do git init -q --bare "$WTS/kriscendobot-$s.git"; done
: > "$DEADLIST"; : > "$UNKNOWNLIST"; : > "$FLAKYLIST"
run_prov
[ -n "$(jtip repos/kriscendobot-massa)" ] && [ -n "$(jtip repos/kriscendobot-flaky)" ] \
  && ok "J fixture: the new own forks armed" || bad "J fixture: new own forks not armed"

# J1 — a ONE-OFF 404 on an armed fork is absorbed by the confirm re-check.
echo "kriscendobot/flaky" > "$FLAKYLIST"; rm -f "$FLAKYSEEN"/*
: > "$PROBELOG"; n_j1="$(jcommits)"
run_prov
[ -z "$(jtip watch-optout/kriscendobot-flaky)" ] \
  && ok "unconfirmed 404 does not retire an armed fork" || bad "one-off 404 retired an armed fork"
[ -n "$(jtip repos/kriscendobot-flaky)" ] && [ -n "$(jtip comment-repos/kriscendobot-flaky)" ] \
  && ok "unconfirmed 404 leaves both arming records" || bad "unconfirmed 404 dropped an arming record"
[ "$(grep -cxF 'kriscendobot/flaky' "$PROBELOG")" = 2 ] \
  && ok "a 404 on an armed fork triggers exactly one confirm re-check" || bad "confirm re-check probe count wrong: $(grep -cxF 'kriscendobot/flaky' "$PROBELOG")"
[ "$(jcommits)" = "$n_j1" ] && ok "unconfirmed 404 lands no journal mutation" || bad "unconfirmed 404 mutated the journal"

# J2 — EVERY armed fork 404ing at once is a read-side failure, not a fleet of
# deletions: retire none, alert instead.
: > "$FLAKYLIST"
printf '%s\n' kriscendobot/inconclusive kriscendobot/massa kriscendobot/massb kriscendobot/flaky > "$DEADLIST"
JLOG="$TR/j.log"; n_j2="$(jcommits)"
run_prov 0 "$JLOG"
grep -q "NO armed watch set was retired" "$JLOG" \
  && ok "mass 404 warns instead of retiring" || bad "no mass-404 warning ($(cat "$JLOG"))"
[ -z "$(jtip watch-optout/kriscendobot-massa)" ] && [ -z "$(jtip watch-optout/kriscendobot-inconclusive)" ] \
  && ok "mass 404 tombstones nothing" || bad "mass 404 tombstoned an armed fork"
[ -n "$(jtip repos/kriscendobot-massa)" ] && [ -n "$(jtip comment-repos/kriscendobot-inconclusive)" ] \
  && ok "mass 404 leaves every arming record intact" || bad "mass 404 dropped an arming record"
[ "$(jcommits)" = "$n_j2" ] && ok "mass 404 lands no journal mutation" || bad "mass 404 mutated the journal"

# J3 — the breaker is narrow: a MIXED tick (some armed forks still resolve) is the
# ordinary deleted-fork case and still retires, confirmed 404 by confirmed 404.
printf '%s\n' kriscendobot/massa kriscendobot/massb > "$DEADLIST"
run_prov
[ -n "$(jtip watch-optout/kriscendobot-massa)" ] && [ -n "$(jtip watch-optout/kriscendobot-massb)" ] \
  && ok "a mixed tick still retires the genuinely dead armed forks" || bad "mixed tick did not retire dead armed forks"
[ -z "$(jtip repos/kriscendobot-massa)" ] && [ -z "$(jtip comment-repos/kriscendobot-massb)" ] \
  && ok "retired armed forks are disarmed in both sets" || bad "retired armed fork kept an arming record"
[ -n "$(jtip repos/kriscendobot-inconclusive)" ] && [ -n "$(jtip repos/kriscendobot-flaky)" ] \
  && ok "the live armed forks in the same tick are untouched" || bad "a live armed fork was retired in a mixed tick"

# ============================================================================
hr; echo "K — end to end: a retirement disarms all four unit families"; hr
# The journal half of a retirement (tombstone + both arming records dropped) is
# only half the fix. What actually FATAL-flapped against the deleted upstream was
# the per-repo systemd units, and those are reconciled by repo-watcher.sh, which
# runs the provisioner at the top of its own tick. So drive the WHOLE path here —
# one repo-watcher tick, real script, mocked systemctl — and assert the units for
# a retired fork are stopped and disabled, not merely un-recorded. A reconciler
# that only ever ADDED units would pass every assertion above and still leave the
# four watchers flapping forever.
RWXDG="$TR/xdg-repo-watcher"; mkdir -p "$RWXDG/systemd/user"
UNIT_PREFIXES=(garden-triager garden-comment-watcher garden-ci-watcher garden-dependabot-watcher)
# Pre-render the four templates so the reconcile takes the no-drift path (its
# self-heal install is exercised by run-test.sh, not here).
for p in "${UNIT_PREFIXES[@]}"; do touch "$RWXDG/systemd/user/$p@.service"; done
MOCKSTATE="$TR/armed"; MOCKLOG="$TR/unitlog"; : > "$MOCKSTATE"; : > "$MOCKLOG"

RWLOG="$TR/repo-watcher.log"
run_rw() {  # run_rw — one repo-watcher tick (provisioner + reconcile), log to $RWLOG
  env GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_WORKTREES="$WTS" GARDEN_REPOS="$TR/repos" \
      GARDEN_FORK_CLONE_URL_BASE="$GHBASE" GARDEN_FORKWATCH_MATERIALIZE=0 \
      GARDEN_FORKWATCH_UPSTREAM_CHECK="$CHECK" DEADLIST="$DEADLIST" \
      UNKNOWNLIST="$UNKNOWNLIST" PROBELOG="$PROBELOG" \
      FLAKYLIST="$FLAKYLIST" FLAKYSEEN="$FLAKYSEEN" \
      GARDEN_FORKWATCH_LIVENESS_INTERVAL=0 GARDEN_NO_MAINTAINER_ALERT=1 \
      GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=0 DENIEDLIST="$DENIEDLIST" \
      XDG_CONFIG_HOME="$RWXDG" GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh" \
      GARDEN_MOCK_STATE="$MOCKSTATE" GARDEN_MOCK_LOG="$MOCKLOG" \
      GARDEN_INSTALL_UNITS=/bin/true \
      "$JOBS/repo-watcher.sh" >/dev/null 2>"$RWLOG"
}

git init -q --bare "$WTS/kriscendobot-teardown.git"
: > "$DEADLIST"; : > "$UNKNOWNLIST"; : > "$FLAKYLIST"
run_rw
armed_all=1
for p in "${UNIT_PREFIXES[@]}"; do
  grep -qxF "$p@kriscendobot-teardown.timer" "$MOCKSTATE" || { armed_all=0; break; }
done
[ "$armed_all" -eq 1 ] \
  && ok "K fixture: one tick armed all four unit families for the live own fork" \
  || bad "K fixture: not all four unit families armed ($(tr '\n' ' ' <"$MOCKSTATE"))"

# The upstream is deleted. The SAME tick must retire it in the journal and tear
# the units down: the provisioner runs before repo-watcher's own sync_clone, so
# the reconcile sees the removal it just landed.
echo "kriscendobot/teardown" > "$DEADLIST"
: > "$MOCKLOG"
run_rw
[ -n "$(jtip watch-optout/kriscendobot-teardown)" ] \
  && ok "retirement tombstoned through a repo-watcher tick" || bad "no tombstone from the repo-watcher tick"
[ -z "$(jtip repos/kriscendobot-teardown)" ] && [ -z "$(jtip comment-repos/kriscendobot-teardown)" ] \
  && ok "retirement dropped both arming records" || bad "retirement left an arming record"
for p in "${UNIT_PREFIXES[@]}"; do
  grep -qxF "$p@kriscendobot-teardown.timer" "$MOCKSTATE" \
    && bad "$p@kriscendobot-teardown.timer still armed after retirement" \
    || ok "$p@kriscendobot-teardown.timer disarmed by the retirement"
  grep -qxF "systemctl --user disable --now $p@kriscendobot-teardown.timer" "$MOCKLOG" \
    && ok "$p@kriscendobot-teardown issued disable --now (stopped, not just forgotten)" \
    || bad "$p@kriscendobot-teardown never issued disable --now"
done
# The teardown is surgical: the live armed forks keep every unit in the same tick.
still=1
for p in "${UNIT_PREFIXES[@]}"; do
  grep -qxF "$p@kriscendobot-flaky.timer" "$MOCKSTATE" || { still=0; break; }
done
[ "$still" -eq 1 ] \
  && ok "the live own fork's four units survive the same tick" \
  || bad "a live own fork lost units during another fork's retirement"

# ============================================================================
hr; echo "L — inconclusive probes coalesce behind a class-keyed cooldown"; hr
# Live armed forks at this point: flaky, inconclusive. Add a third so "one probe
# instead of N" is visible.
git init -q --bare "$WTS/kriscendobot-zeta.git"
: > "$DEADLIST"; : > "$UNKNOWNLIST"; : > "$FLAKYLIST"; : > "$DENIEDLIST"
run_prov
[ -n "$(jtip repos/kriscendobot-zeta)" ] && ok "L fixture: zeta armed" || bad "L fixture: zeta not armed"
COOLDIR="$TR/state/fork-watch/inconclusive-cooldown"
rm -rf "$COOLDIR"
printf '%s\n' kriscendobot/flaky kriscendobot/inconclusive kriscendobot/zeta > "$UNKNOWNLIST"
LLOG="$TR/l.log"; : > "$PROBELOG"; n_l="$(jcommits)"
UNKNOWNMSG="HTTP 502: Bad Gateway" GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=300 run_prov 0 "$LLOG"
[ "$(wc -l < "$PROBELOG")" = 1 ] \
  && ok "a shared inconclusive condition stops further probes this tick" || bad "probe count $(wc -l < "$PROBELOG") (want 1)"
[ "$(grep -c 'WARN' "$LLOG")" = 1 ] && grep -q "server (first seen" "$LLOG" \
  && ok "exactly one coalesced WARN naming the normalized class" || bad "warnings not coalesced: $(cat "$LLOG")"
grep -q "deferring 3 fork(s)" "$LLOG" \
  && ok "the coalesced WARN lists every deferred fork" || bad "coalesced WARN missing deferral count: $(cat "$LLOG")"
[ -f "$COOLDIR/server" ] && ok "host-local cooldown recorded under the class key" || bad "no server-class cooldown marker"
[ "$(jcommits)" = "$n_l" ] && ok "inconclusive deferral lands no journal mutation" || bad "deferral mutated the journal"

: > "$PROBELOG"; : > "$LLOG"
UNKNOWNMSG="HTTP 502: Bad Gateway" GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=300 run_prov 0 "$LLOG"
[ ! -s "$PROBELOG" ] && ok "a live window skips every probe on the next tick" || bad "probed inside a live window"
grep -q WARN "$LLOG" && bad "a live window re-warned: $(cat "$LLOG")" || ok "a live window stays silent"
[ -n "$(jtip repos/kriscendobot-zeta)" ] && [ -n "$(jtip comment-repos/kriscendobot-flaky)" ] \
  && ok "deferral is fail-open (armed forks keep their records)" || bad "deferral dropped an arming record"

# The window is bounded: once it expires, probing resumes.
printf '0\nexpired\n' > "$COOLDIR/server"
: > "$UNKNOWNLIST"; : > "$PROBELOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=300 run_prov
[ "$(wc -l < "$PROBELOG")" = 3 ] && ok "an expired window resumes probing every fork" || bad "post-expiry probe count $(wc -l < "$PROBELOG")"
[ ! -e "$COOLDIR/server" ] && ok "the expired marker is removed" || bad "expired marker lingered"

# A repo-specific 403 is keyed per slug: only that fork is deferred.
echo kriscendobot/inconclusive > "$DENIEDLIST"; : > "$PROBELOG"; : > "$LLOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=300 run_prov 0 "$LLOG"
[ "$(wc -l < "$PROBELOG")" = 3 ] && ok "a repo-specific refusal does not halt the other probes" || bad "repo-denied probe count $(wc -l < "$PROBELOG")"
[ -f "$COOLDIR/repo-denied@kriscendobot-inconclusive" ] && ok "repo-denied cooldown keyed per slug" || bad "no per-slug repo-denied marker"
: > "$PROBELOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=300 run_prov
grep -qxF kriscendobot/inconclusive "$PROBELOG" && bad "denied fork re-probed inside its window" || ok "denied fork deferred inside its window"
[ "$(wc -l < "$PROBELOG")" = 2 ] && ok "the other forks keep probing" || bad "other forks not probed ($(wc -l < "$PROBELOG"))"
: > "$DENIEDLIST"; rm -rf "$COOLDIR"

# A tick halted by a host-wide inconclusive class never retires an armed fork,
# even one whose 404 was confirmed before the halt (flaky sorts before zeta).
echo kriscendobot/flaky > "$DEADLIST"; echo kriscendobot/zeta > "$UNKNOWNLIST"
: > "$LLOG"; n_l5="$(jcommits)"
UNKNOWNMSG="API rate limit exceeded" GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=0 run_prov 0 "$LLOG"
[ -z "$(jtip watch-optout/kriscendobot-flaky)" ] && [ "$(jcommits)" = "$n_l5" ] \
  && ok "a halted tick defers retirement of a confirmed-404 armed fork" || bad "halted tick retired an armed fork"
grep -q "rate-limit (first seen" "$LLOG" && grep -q "stopped probing for this tick" "$LLOG" \
  && ok "cooldown 0 still coalesces for the tick without recording a window" || bad "tick-only coalescing wrong: $(cat "$LLOG")"
[ ! -e "$COOLDIR/rate-limit" ] && ok "cooldown 0 records no window" || bad "cooldown 0 recorded a window"
: > "$DEADLIST"; : > "$UNKNOWNLIST"

# ============================================================================
hr; echo "M — upstream 429 arms the shared API cooldown for sibling pollers"; hr
# Do not use the upstream-check seam here: this is specifically a regression for
# the production probe having bypassed gh_api_retry with a bare `gh api`. Model a
# primary-quota response that also carries HTTP 429, then ask a sibling poller's
# gh_api_retry call to read another endpoint. The shared admission latch must
# refuse that second call before the gh stub is invoked.
git init -q --bare "$WTS/kriscendobot-rate-limited.git"
APICALLS="$TR/api-calls"; : > "$APICALLS"
GH429="$TR/gh-429.sh"
cat > "$GH429" <<'EOS'
#!/bin/bash
printf '%s\n' "$*" >> "$GH_STUB_CALLS"
echo 'gh: API rate limit exceeded for user ID 279080640 (HTTP 429)' >&2
exit 1
EOS
chmod +x "$GH429"
rm -rf "$TR/state/gh-api-cooldown" "$TR/state/fork-watch/inconclusive-cooldown"
set +e
env GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_WORKTREES="$WTS" GARDEN_REPOS="$TR/repos" \
    GARDEN_FORKWATCH_MATERIALIZE=0 GARDEN_FORKWATCH_LIVENESS_INTERVAL=0 \
    GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=300 \
    GARDEN_GH="$GH429" GH_STUB_CALLS="$APICALLS" GARDEN_GH_API_ATTEMPTS=4 \
    GARDEN_API_COOLDOWN_DIR="$TR/state/gh-api-cooldown" \
    GARDEN_NO_MAINTAINER_ALERT=1 \
    "$JOBS/fork-watch-provisioner.sh" >/dev/null 2>"$TR/m.log"
mrc=$?
set -e
[ "$mrc" -eq 0 ] && ok "429 probe stays fail-open for the provisioner tick" \
  || bad "429 probe failed the provisioner tick (rc=$mrc; $(cat "$TR/m.log"))"
[ "$(wc -l < "$APICALLS")" -eq 1 ] \
  && ok "primary-quota 429 stops the provisioner's remaining probes after one request" \
  || bad "429 path made $(wc -l < "$APICALLS") requests (want 1)"
[ -s "$TR/state/gh-api-cooldown/marker" ] \
  && grep -q 'primary-quota' "$TR/state/gh-api-cooldown/marker" \
  && ok "upstream probe armed the host-shared GitHub API cooldown" \
  || bad "upstream probe did not arm a primary-quota cooldown marker"
[ -z "$(jtip repos/kriscendobot-rate-limited)" ] \
  && [ -z "$(jtip watch-optout/kriscendobot-rate-limited)" ] \
  && ok "inconclusive 429 neither arms nor tombstones the candidate" \
  || bad "inconclusive 429 mutated candidate watch membership"
set +e
env GARDEN_STATE="$TR/state" GARDEN_API_COOLDOWN_DIR="$TR/state/gh-api-cooldown" \
    GARDEN_GH="$GH429" GH_STUB_CALLS="$APICALLS" \
    bash -c 'source "$1"; gh_api_retry "repos/sibling/poller" >/dev/null' \
    _ "$JOBS/common.sh" 2>"$TR/m-sibling.log"
sibling_rc=$?
set -e
[ "$sibling_rc" -eq 75 ] && [ "$(wc -l < "$APICALLS")" -eq 1 ] \
  && ok "shared 429 cooldown suppresses a sibling GitHub poller without a request" \
  || bad "sibling poller escaped cooldown (rc=$sibling_rc calls=$(wc -l < "$APICALLS"))"

# ============================================================================
hr; echo "N — silent rc=2 probes escalate their cooldown and success resets it"; hr
rm -rf "$TR/state/fork-watch/inconclusive-cooldown"
printf '%s\n' kriscendobot/flaky kriscendobot/inconclusive kriscendobot/zeta > "$UNKNOWNLIST"
UNKNOWNMSG=""; : > "$PROBELOG"
NLOG="$TR/n.log"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov 0 "$NLOG"
[ "$(sed -n '4p' "$COOLDIR/unclassified")" = 10 ] \
  && ok "first silent rc=2 probe opens the base cooldown" || bad "first silent cooldown was not 10s"
grep -q 'rc=2 (no output)' "$NLOG" \
  && ok "silent probe diagnostic preserves rc=2" || bad "silent diagnostic dropped rc=2: $(cat "$NLOG")"
[ "$(cat "$COOLDIR/silent-failures")" = 1 ] \
  && ok "first silent probe records escalation level 1" || bad "first silent escalation level wrong"

# Expire only the window; the consecutive-failure level must survive to drive
# the next duration.
printf '0\nexpired\nrc=2 (no output)\n10\n' > "$COOLDIR/unclassified"
: > "$PROBELOG"; : > "$NLOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov 0 "$NLOG"
[ "$(sed -n '4p' "$COOLDIR/unclassified")" = 20 ] \
  && ok "second consecutive silent probe doubles the cooldown" || bad "second silent cooldown was not 20s"
[ "$(cat "$COOLDIR/silent-failures")" = 2 ] \
  && ok "second silent probe advances escalation level" || bad "second silent escalation level wrong"

# Force a high stored level and prove the computed window remains capped.
printf '31\n' > "$COOLDIR/silent-failures"
printf '0\nexpired\nrc=2 (no output)\n20\n' > "$COOLDIR/unclassified"
: > "$PROBELOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov
[ "$(sed -n '4p' "$COOLDIR/unclassified")" = 3600 ] \
  && ok "silent cooldown escalation is capped at 3600s" || bad "silent cooldown exceeded/missed its cap"

# A clean probe removes the escalation state; the next silent failure starts
# again from the configured base instead of continuing at the cap.
printf '0\nexpired\nrc=2 (no output)\n3600\n' > "$COOLDIR/unclassified"
: > "$UNKNOWNLIST"; : > "$PROBELOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov
[ ! -e "$COOLDIR/silent-failures" ] \
  && ok "a successful probe resets silent cooldown escalation" || bad "success left silent escalation state behind"
printf '%s\n' kriscendobot/flaky kriscendobot/inconclusive kriscendobot/zeta > "$UNKNOWNLIST"
: > "$PROBELOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov
[ "$(sed -n '4p' "$COOLDIR/unclassified")" = 10 ] \
  && ok "silent cooldown restarts at the base after success" || bad "post-success silent cooldown did not reset"
[ -n "$(jtip repos/kriscendobot-zeta)" ] && [ -z "$(jtip watch-optout/kriscendobot-zeta)" ] \
  && ok "silent inconclusive probes remain fail-open" || bad "silent probe armed/tombstoned/retired a fork"

# ============================================================================
hr; echo "O — a silent rc=75 probe is a quiet, bounded host-wide outage"; hr
rm -rf "$TR/state/fork-watch/inconclusive-cooldown"
printf '%s\n' kriscendobot/flaky kriscendobot/inconclusive kriscendobot/zeta > "$UNKNOWNLIST"
UNKNOWNMSG=""; : > "$PROBELOG"
OLOG="$TR/o.log"
UNKNOWNRC=75 GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov 0 "$OLOG"
[ "$(wc -l < "$PROBELOG")" -eq 1 ] \
  && ok "rc=75 halts probing after one probe" || bad "rc=75 probed $(wc -l < "$PROBELOG") forks"
[ -f "$COOLDIR/offline" ] && [ ! -e "$COOLDIR/unclassified" ] \
  && ok "rc=75 is classed offline, not unclassified" || bad "rc=75 class wrong: $(ls "$COOLDIR")"
[ "$(sed -n '4p' "$COOLDIR/offline")" = 10 ] \
  && ok "rc=75 opens the base cooldown" || bad "rc=75 cooldown was not 10s"
[ ! -e "$COOLDIR/silent-failures" ] \
  && ok "rc=75 does not advance silent escalation" || bad "rc=75 advanced silent escalation"
! grep -q 'WARN' "$OLOG" \
  && ok "rc=75 logs no WARN" || bad "rc=75 warned: $(cat "$OLOG")"
grep -q 'temporarily unavailable (rc=75' "$OLOG" \
  && ok "rc=75 deferral logs one informational line" || bad "rc=75 info line missing: $(cat "$OLOG")"
# A live window defers every later tick with no probe and no output.
: > "$PROBELOG"; : > "$OLOG"
UNKNOWNRC=75 GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov 0 "$OLOG"
[ ! -s "$PROBELOG" ] && ! grep -q 'WARN\|unavailable' "$OLOG" \
  && ok "live offline window defers quietly without probing" || bad "live offline window probed/logged"
# Expired: retry once, reopen at the SAME base length (bounded, no doubling).
printf '0\nexpired\nrc=75\n10\n' > "$COOLDIR/offline"
: > "$PROBELOG"; : > "$OLOG"
UNKNOWNRC=75 GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov 0 "$OLOG"
[ "$(wc -l < "$PROBELOG")" -eq 1 ] && [ "$(sed -n '4p' "$COOLDIR/offline")" = 10 ] \
  && ! grep -q WARN "$OLOG" \
  && ok "expired offline window retries once and reopens at the base length" \
  || bad "offline retry not bounded (probes=$(wc -l < "$PROBELOG") secs=$(sed -n '4p' "$COOLDIR/offline"))"
[ -n "$(jtip repos/kriscendobot-zeta)" ] && [ -z "$(jtip watch-optout/kriscendobot-zeta)" ] \
  && ok "offline probes remain fail-open" || bad "offline probe armed/tombstoned/retired a fork"
# Recovery: the outage clears, the next expired tick probes everything again.
printf '0\nexpired\nrc=75\n10\n' > "$COOLDIR/offline"
: > "$UNKNOWNLIST"; : > "$PROBELOG"
GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS=10 run_prov
[ "$(wc -l < "$PROBELOG")" -gt 1 ] && [ ! -e "$COOLDIR/offline" ] \
  && ok "after the outage clears the next tick probes normally" || bad "post-outage tick did not resume probing"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
