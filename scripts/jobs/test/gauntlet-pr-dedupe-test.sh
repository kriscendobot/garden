#!/bin/bash
# gauntlet-pr-dedupe-test.sh — at most ONE live gauntlet per PR. On 2026-10-05
# kriscendobot/minion.town#160 ran two gauntlets under two bases at once (a late
# auto-stage and a run-the-gauntlet request); both fix loops pushed to one head
# for 8 fix rounds and 9 panels. post-gauntlet.sh now refuses a second live run
# on the same PR, and gauntlet.sh retires a fresh duplicate that raced past it.
# Hermetic: throwaway bare journal, stub pin-gate, no network.

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
TR="$(mktemp -d "$HOME/.garden-gauntlet-dedupe-test.XXXXXX")"
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

export GARDEN_ASSERT_PINNED_BASE="$TR/gate-pinned.sh"
export GARDEN_TEST=1

V="$TR/verify"
board() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; \
  ls -1 "$V/$1" 2>/dev/null | grep -vx '.gitkeep' | sed 's/\.md$//' | sort | tr '\n' ' '; }
in_dir()   { board "$1" | tr ' ' '\n' | grep -qx "$2"; }
tada_body(){ rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; local f; f="$(find "$V/jobs/tada" -type f -name "$1.md" -print -quit 2>/dev/null)"; cat "${f:-/dev/null}"; }
tick() { "$JOBS/gauntlet.sh" >"$TR/tick.log" 2>&1 || { echo "  (gauntlet.sh rc=$? — see below)"; cat "$TR/tick.log"; }; }
# Record a fresh gauntlet straight into the journal, bypassing post-gauntlet.sh's
# check, the way two producers racing distinct bases would land.
inject() {  # <base> <pr> <created_at>
  local W="$TR/inject"; rm -rf "$W"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$W"
  printf -- '---\npr: https://github.com/testowner/testrepo/pull/%s\nrepo: testowner/testrepo\npr_number: %s\nbuild_job: \nkind: feature\nstage: viability\niteration: 0\nmax_iterations: 6\ncurrent_child: \nstate: pending\ncreated_by: test\ncreated_at: %s\n---\n' \
    "$2" "$2" "$3" > "$W/jobs/gauntlet/$1.md"
  git -C "$W" add -A && git -C "$W" "${git_id[@]}" commit -q -m "inject $1" && git -C "$W" push -q origin "HEAD:$BRANCH"
}
PR=https://github.com/testowner/testrepo/pull

hr; echo "REFUSE — post-gauntlet.sh will not record a second live gauntlet on one PR"; hr
"$JOBS/post-gauntlet.sh" --build-job build-a build-a-gauntlet "$PR/1" 2>/dev/null
"$JOBS/post-gauntlet.sh" testowner-testrepo-pr1-gauntlet "$PR/1" 2>"$TR/refuse.err" \
  && ok "the duplicate post exits 0 (coalesced, not an error)" || bad "duplicate post failed"
{ in_dir jobs/gauntlet build-a-gauntlet && ! in_dir jobs/gauntlet testowner-testrepo-pr1-gauntlet; } \
  && ok "only the first gauntlet is recorded" || bad "gauntlet board: [$(board jobs/gauntlet)]"
grep -q 'DUPLICATE GAUNTLET REFUSED.*build-a-gauntlet' "$TR/refuse.err" \
  && ok "the refusal is logged loudly and names the live gauntlet" || bad "no loud refusal: $(cat "$TR/refuse.err")"
"$JOBS/post-gauntlet.sh" build-b-gauntlet "$PR/2" 2>/dev/null
in_dir jobs/gauntlet build-b-gauntlet && ok "a different PR is unaffected" || bad "PR 2 not recorded"

hr; echo "ALLOW — a terminal gauntlet does not block a fresh run on the same PR"; hr
inject old-halted 3 2026-10-01T00:00:00Z
( W="$TR/inject"; sed -i 's/^state: pending$/state: halted/' "$W/jobs/gauntlet/old-halted.md"
  git -C "$W" add -A && git -C "$W" "${git_id[@]}" commit -q -m halt && git -C "$W" push -q origin "HEAD:$BRANCH" )
"$JOBS/post-gauntlet.sh" testowner-testrepo-pr3-gauntlet "$PR/3" 2>/dev/null
in_dir jobs/gauntlet testowner-testrepo-pr3-gauntlet \
  && ok "a halted record on the PR does not block a new run" || bad "halted record blocked: [$(board jobs/gauntlet)]"

hr; echo "COALESCE — the driver retires a fresh duplicate that raced past the post check"; hr
inject race-first 4 2026-10-05T10:00:00Z
inject race-second 4 2026-10-05T10:00:05Z
tick
{ in_dir jobs/todo race-first-viability && ! in_dir jobs/todo race-second-viability; } \
  && ok "only the earlier record spends a viability stage" || bad "todo=[$(board jobs/todo)]"
! in_dir jobs/gauntlet race-second && ok "the later duplicate is retired" || bad "race-second still live"
body="$(tada_body race-second)"
printf '%s' "$body" | grep -q 'gauntlet-status: coalesced' && printf '%s' "$body" | grep -q 'coalesced_into: race-first' \
  && ok "its tada report records the coalesce and the winner" || bad "tada body: $body"
grep -q 'DUPLICATE GAUNTLET COALESCED' "$TR/tick.log" && ok "the driver logs the coalesce loudly" || bad "no loud driver log"

inject race-early 4 2026-10-05T09:00:00Z
tick
{ ! in_dir jobs/gauntlet race-early && ! in_dir jobs/todo race-early-viability; } \
  && ok "a fresh record yields to a peer already in flight even if recorded earlier" \
  || bad "race-early ran: gauntlet=[$(board jobs/gauntlet)] todo=[$(board jobs/todo)]"

hr
if [ "$FAIL" -eq 0 ]; then
  echo "PASS: one live gauntlet per PR ($PASS checks)"
else
  echo "FAIL: $FAIL check(s) failed, $PASS passed (fixtures kept at $TR)"
fi
[ "$FAIL" -eq 0 ]
