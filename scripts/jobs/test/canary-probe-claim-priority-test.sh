#!/bin/bash
# canary-probe-claim-priority-test.sh — a rolling-deploy canary probe pinned to
# this host is claimed before ordinary todo work, whatever the worker's offset.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-probe-prio.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" "$SEED/work" "$SEED/inbox/maintainer/unread" "$SEED/inbox/maintainer/read"
for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do touch "$SEED/$d/.gitkeep"; done
for j in a-plain b-plain c-plain y-plain z-plain; do printf '# ordinary job\n' > "$SEED/jobs/todo/$j.md"; done
probe() {
  printf -- '---\nrequires: host=%s\ncanary-probe: true\nhandler-timeout: 120\n---\n# probe\n' "$1"
}
probe host-a > "$SEED/jobs/todo/m-canary-probe-host-a.md"
probe host-b > "$SEED/jobs/todo/n-canary-probe-host-b.md"
git -C "$SEED" add -A; git -C "$SEED" -c user.name=t -c user.email=t@l commit -qm seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"
claim() { env -u GARDEN_JOB_BASE -u GARDEN_COMPLETION_SENTINEL GARDEN="$1" GARDEN_STATE="$TR/state-$1-$2" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_WORKER_CLONE="$TR/clone-$1-$2" "$JOBS/claim-job.sh" "$2"; }
requeue() {
  local V="$TR/v"; rm -rf "$V"; git clone -q --branch "$BRANCH" "$BARE" "$V"
  git -C "$V" mv "jobs/doin/$1.md" "jobs/todo/$1.md"; rm -f "$V/work/$1"
  git -C "$V" add -A; git -C "$V" -c user.name=t -c user.email=t@l commit -qm "requeue $1"; git -C "$V" push -q
}

all=1
for id in 1 2 3 4 5 6 7; do
  got="$(claim host-a "$id" 2>/dev/null || true)"
  [ "$got" = m-canary-probe-host-a ] || { all=0; bad "host-a worker $id claimed '$got' before its canary probe"; }
  [ -n "$got" ] && requeue "$got"
done
[ "$all" = 1 ] && ok "every host-a worker offset claims its canary probe first"

got="$(claim host-c 1 2>/dev/null || true)"
case "$got" in
  *-plain) ok "a host not named by any probe still claims ordinary work ($got)" ;;
  *) bad "host-c claimed '$got' (wanted an ordinary job)" ;;
esac

echo "canary-probe-claim-priority-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
