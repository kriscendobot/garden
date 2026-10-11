#!/bin/bash
# claim-aging-priority-test.sh — a job that has waited in todo/ past the aging
# threshold is claimed before younger work, whatever the worker's offset, while
# canary probes still go first and host eligibility still applies.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-claim-aging.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
now="$(date -u +%s)"
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" "$SEED/work" "$SEED/inbox/maintainer/unread" "$SEED/inbox/maintainer/read"
for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do touch "$SEED/$d/.gitkeep"; done
commit_at() { # <epoch> <msg>
  git -C "$SEED" add -A
  GIT_AUTHOR_DATE="@$1" GIT_COMMITTER_DATE="@$1" git -C "$SEED" -c user.name=t -c user.email=t@l commit -qm "$2"
}
# Old work: one job only another host may run, one any host may run.
printf -- '---\nrequires: host=host-z\n---\n# old, host-z only\n' > "$SEED/jobs/todo/m-old-hostz.md"
printf '# old ordinary job\n' > "$SEED/jobs/todo/n-old-plain.md"
commit_at $(( now - 12 * 3600 )) "old posts"
# Young work, posted well inside the threshold.
for j in a-young b-young c-young y-young z-young; do printf '# young job\n' > "$SEED/jobs/todo/$j.md"; done
# A header-stamped posted_at overrides the commit time in both directions.
printf -- '---\nposted_at: %s\n---\n# stamped young\n' "$(date -u -d "@$now" +%FT%TZ)" > "$SEED/jobs/todo/d-stamped-young.md"
commit_at $(( now - 60 )) "young posts"
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"

claim() { env -u GARDEN_JOB_BASE -u GARDEN_COMPLETION_SENTINEL GARDEN="$1" GARDEN_STATE="$TR/state-$1-$2" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_WORKER_CLONE="$TR/clone-$1-$2" "$JOBS/claim-job.sh" "$2"; }
# Rewind the board to a snapshot between claims (a requeue would re-add the job to
# todo/ and so, by design, restart its clock). Each worker id gets a fresh clone.
snapshot() { git -C "$BARE" rev-parse "$BRANCH"; }
rewind() { git -C "$BARE" update-ref "refs/heads/$BRANCH" "$1"; }

snap="$(snapshot)"; all=1
for id in 1 2 3 4 5 6 7 8 9; do
  got="$(claim host-a "$id" 2>/dev/null || true)"
  [ "$got" = n-old-plain ] || { all=0; bad "host-a worker $id claimed '$got' before the aged job"; }
  rewind "$snap"
done
[ "$all" = 1 ] && ok "every worker offset claims the eligible aged job first (the ineligible aged job is skipped)"

# Drop the commit-aged job, then add one just now whose posted_at header is old:
# the header outranks the add commit.
V="$TR/v"; rm -rf "$V"; git clone -q --branch "$BRANCH" "$BARE" "$V"
git -C "$V" rm -q jobs/todo/n-old-plain.md
printf -- '---\nposted_at: %s\n---\n# stamped old\n' "$(date -u -d "@$(( now - 5 * 3600 ))" +%FT%TZ)" > "$V/jobs/todo/x-stamped-old.md"
git -C "$V" add -A; git -C "$V" -c user.name=t -c user.email=t@l commit -qm "stamped old"; git -C "$V" push -q
snap="$(snapshot)"; all=1
for id in 1 2 3 4 5 6 7 8 9; do
  got="$(claim host-a "$id" 2>/dev/null || true)"
  [ "$got" = x-stamped-old ] || { all=0; bad "host-a worker $id claimed '$got' before the posted_at-aged job"; }
  rewind "$snap"
done
[ "$all" = 1 ] && ok "a posted_at header older than the threshold makes a freshly-added job aged"

# A canary probe still outranks aged work.
rm -rf "$V"; git clone -q --branch "$BRANCH" "$BARE" "$V"
printf -- '---\nrequires: host=host-a\ncanary-probe: true\nhandler-timeout: 120\n---\n# probe\n' > "$V/jobs/todo/q-canary-probe-host-a.md"
git -C "$V" add -A; git -C "$V" -c user.name=t -c user.email=t@l commit -qm probe; git -C "$V" push -q
got="$(claim host-a 3 2>/dev/null || true)"
if [ "$got" = q-canary-probe-host-a ]; then ok "a canary probe is still claimed before aged work"; else bad "claimed '$got' ahead of the canary probe"; fi

# With aging disabled the plain rotation decides.
got="$(GARDEN_CLAIM_AGING_SECONDS=0 claim host-a 1 2>/dev/null || true)"
case "$got" in
  x-stamped-old|'') bad "aging disabled still claimed '$got'" ;;
  *) ok "GARDEN_CLAIM_AGING_SECONDS=0 falls back to the rotation ($got)" ;;
esac

echo "claim-aging-priority-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
