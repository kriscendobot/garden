#!/bin/bash
# gauntlet-pin-gate-test.sh — the DETERMINISTIC merge-base-pinning pre-gate the
# gauntlet driver runs on a fresh record BEFORE spending any viability/clean/panel
# budget (review-misses/clusters/merge-base-pinning.md; endojs/endo-but-for-bots
# #719/#831/#836). A PR on a FLOATING base is halted before review spend; a pinned
# PR proceeds to the viability stage exactly as before.
#
# Hermetic: a throwaway bare journal and a STUB pin-gate (no network). The gate's
# own name/pr verdicts are proven in assert-pinned-base-test.sh; this proves the
# driver's disposition of each verdict.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

# /tmp is noexec in the container and the stub must be executable → root under $HOME.
TR="$(mktemp -d "$HOME/.garden-gauntlet-pin-test.XXXXXX")"
trap '[ "$FAIL" -eq 0 ] && rm -rf "$TR"' EXIT
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board + gauntlet structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_POST_ATTEMPTS=50
export GARDEN_CLAIM_TTL=14400 GARDEN_HANDLER_KILL_AFTER=60
export GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200

# Two fast stubs standing in for the deterministic sensor.
printf '#!/bin/bash\nexit 5\n' > "$TR/gate-floating.sh"   # shape (1): floating base
printf '#!/bin/bash\nexit 0\n' > "$TR/gate-pinned.sh"     # pinned + within delta
chmod +x "$TR/gate-floating.sh" "$TR/gate-pinned.sh"

V="$TR/verify"
board() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; \
  ls -1 "$V/$1" 2>/dev/null | grep -vx '.gitkeep' | sed 's/\.md$//' | sort | tr '\n' ' '; }
in_dir()   { board "$1" | tr ' ' '\n' | grep -qx "$2"; }
tada_body(){ rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; cat "$V/jobs/tada/$1.md" 2>/dev/null; }
tick() { "$JOBS/gauntlet.sh" >"$TR/tick.log" 2>&1 || { echo "  (gauntlet.sh rc=$? — see below)"; cat "$TR/tick.log"; }; }

hr; echo "HALT — a floating-base PR is refused before any review spend"; hr
"$JOBS/post-gauntlet.sh" --build-job build-1 gpin https://github.com/testowner/testrepo/pull/1 >/dev/null
GARDEN_ASSERT_PINNED_BASE="$TR/gate-floating.sh" tick
{ ! in_dir jobs/todo gpin-viability && ! in_dir jobs/gauntlet gpin; } \
  && ok "no viability stage posted; the gauntlet record is finished (halted)" \
  || bad "floating base did NOT halt: todo=[$(board jobs/todo)] gauntlet=[$(board jobs/gauntlet)]"
body="$(tada_body gpin)"
printf '%s' "$body" | grep -q 'gauntlet-status: halted' \
  && ok "the tada report is marked halted" || bad "tada not marked halted: $body"
printf '%s' "$body" | grep -qi 'floating\|pin the merge base' \
  && ok "the halt reason names the floating base / pin-the-merge-base disposition" \
  || bad "halt reason unclear: $body"

hr; echo "PROCEED — a pinned PR advances to the viability stage as before"; hr
"$JOBS/post-gauntlet.sh" --build-job build-2 gok https://github.com/testowner/testrepo/pull/2 >/dev/null
GARDEN_ASSERT_PINNED_BASE="$TR/gate-pinned.sh" tick
{ in_dir jobs/todo gok-viability && in_dir jobs/gauntlet gok; } \
  && ok "pinned base advances to viability (no regression to the normal flow)" \
  || bad "pinned base did not advance: todo=[$(board jobs/todo)] gauntlet=[$(board jobs/gauntlet)]"

hr
if [ "$FAIL" -eq 0 ]; then
  echo "PASS: gauntlet merge-base-pinning pre-gate ($PASS checks)"
else
  echo "FAIL: $FAIL check(s) failed, $PASS passed (fixtures kept at $TR)"
fi
[ "$FAIL" -eq 0 ]
