#!/bin/bash
# claim-host-ineligible-no-sync-test.sh — a job this host cannot run costs a claim
# pass no journal re-sync, so a board of jobs pinned elsewhere does not keep idle
# workers fetching or delay the eligible job behind them.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-claim-ineligible.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do
  mkdir -p "$SEED/$d"; touch "$SEED/$d/.gitkeep"
done
land() { git -C "$SEED" add -A; git -C "$SEED" -c user.name=t -c user.email=t@l commit -qm "$1"; git -C "$SEED" push -q origin "$BRANCH"; }
git -C "$SEED" remote add origin "$BARE"
pinned() { printf -- '---\nrequires: host=host-z\n---\n# pinned elsewhere\n' > "$SEED/jobs/todo/$1.md"; }
for j in a-pinned b-pinned c-pinned; do pinned "$j"; done
printf -- '---\nrequires: quantum\n---\n# no host has this\n' > "$SEED/jobs/todo/d-unknown-cap.md"
printf -- '---\nrequires: host=host-z\ncanary-probe: true\n---\n# probe for another host\n' > "$SEED/jobs/todo/e-other-probe.md"
land "ineligible only"

# Count real fetches with git's own trace. A PATH shim named git would re-enter the
# fleet wrapper (scripts/jobs/bin/git), which resolves the real git through PATH.
claim() { # <id> -> stdout: claimed base; log in $TR/claim-<id>.log
  : > "$TR/fetches"
  env -u GARDEN_JOB_BASE -u GARDEN_COMPLETION_SENTINEL GIT_TRACE="$TR/fetches" GARDEN_CLAIM_AGING_SECONDS=0 \
    GARDEN_FETCH_MAX_AGE_OVERRIDE=0 GARDEN=host-a GARDEN_STATE="$TR/state-$1" JOURNAL_REMOTE="$BARE" \
    JOURNAL_BRANCH="$BRANCH" GARDEN_WORKER_CLONE="$TR/clone-$1" "$JOBS/claim-job.sh" "$1" 2>"$TR/claim-$1.log"
}
fetches() { grep -c 'git fetch' "$TR/fetches" || true; }

rc=0; got="$(claim 1)" || rc=$?
ineligible_fetches="$(fetches)"
[ -z "$got" ] && [ "$rc" = 3 ] && ok "a board of only ineligible jobs claims nothing (rc=3)" || bad "claimed '$got' rc=$rc"
for j in a-pinned b-pinned c-pinned d-unknown-cap e-other-probe; do
  c="$(grep -c "'$j' requires host capability .*skipping (host-requirements)" "$TR/claim-1.log" || true)"
  [ "$c" = 1 ] && ok "'$j' is logged as skipped once" || bad "'$j' skip logged $c times"
done
grep -q 'appeared mid-pass' "$TR/claim-1.log" && bad "another host's probe was taken for a late arrival" || ok "another host's probe is not a late arrival"

# Baseline: the same pass over an empty board. Ineligible jobs add no fetch to it.
git -C "$SEED" rm -qr jobs/todo; mkdir -p "$SEED/jobs/todo"; touch "$SEED/jobs/todo/.gitkeep"; land "empty"
rc=0; got="$(claim 3)" || rc=$?
base_fetches="$(fetches)"
[ "$ineligible_fetches" = "$base_fetches" ] \
  && ok "ineligible jobs add no fetch to a pass ($ineligible_fetches, empty board $base_fetches)" \
  || bad "fetches with ineligible jobs $ineligible_fetches, empty board $base_fetches"

# An eligible job behind them costs what it costs on a board without them.
for j in a-pinned b-pinned c-pinned; do pinned "$j"; done
printf '# anyone may run this\n' > "$SEED/jobs/todo/z-plain.md"
land "eligible behind pinned"
before_claim="$(git -C "$BARE" rev-parse "$BRANCH")"
got="$(claim 4 || true)"
behind_pinned="$(fetches)"
[ "$got" = z-plain ] && ok "the eligible job is claimed" || bad "claimed '$got', wanted z-plain"
git -C "$BARE" update-ref "refs/heads/$BRANCH" "$before_claim"
git -C "$SEED" rm -q jobs/todo/a-pinned.md jobs/todo/b-pinned.md jobs/todo/c-pinned.md; land "plain only"
got="$(claim 5 || true)"
[ "$got" = z-plain ] || bad "plain-only board claimed '$got'"
[ "$behind_pinned" = "$(fetches)" ] \
  && ok "pinned jobs ahead of it add no fetch ($behind_pinned)" \
  || bad "fetches $behind_pinned behind pinned jobs, $(fetches) without them"

echo "claim-host-ineligible-no-sync-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
