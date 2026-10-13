#!/bin/bash
# claim-stops-when-unit-stopping-test.sh — a claim pass whose own worker unit is
# being stopped (a deploy restart) abandons the pass instead of claiming a job the
# gardener would then hold the restart for; an active unit still claims.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-claim-stopping.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do mkdir -p "$SEED/$d"; touch "$SEED/$d/.gitkeep"; done
printf '# a job\n' > "$SEED/jobs/todo/a-job.md"
git -C "$SEED" add -A; git -C "$SEED" -c user.name=t -c user.email=t@l commit -qm seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"

# Mock unit_ctl: report $MOCK_STATE for is-active and record the queried unit.
MOCK="$TR/unit-ctl"
cat > "$MOCK" <<'M'
#!/bin/bash
[ "$1" = is-active ] && { printf '%s\n' "$2" >> "$MOCK_LOG"; printf '%s\n' "$MOCK_STATE"; }
exit 0
M
chmod +x "$MOCK"
claim() { # <state> <id>
  env -u GARDEN_JOB_BASE -u GARDEN_COMPLETION_SENTINEL GARDEN=host-a GARDEN_WORKER_KIND=monk \
    GARDEN_STATE="$TR/state-$2" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_WORKER_CLONE="$TR/clone-$2" GARDEN_UNIT_CTL="$MOCK" MOCK_STATE="$1" MOCK_LOG="$TR/log" \
    "$JOBS/claim-job.sh" "$2"
}

set +e; got="$(claim deactivating 5 2>/dev/null)"; rc=$?; set -e
if [ "$rc" = 3 ] && [ -z "$got" ]; then ok "a stopping unit abandons the claim pass (rc=3, nothing claimed)"; else bad "stopping unit: rc=$rc got='$got'"; fi
if git -C "$BARE" show "$BRANCH:jobs/todo/a-job.md" >/dev/null 2>&1; then ok "the job stays in todo/"; else bad "the job left todo/"; fi
if grep -qx 'garden-monk@5.service' "$TR/log"; then ok "the check queries the worker's own unit"; else bad "queried: $(tr '\n' ' ' < "$TR/log")"; fi

set +e; got="$(claim active 6 2>/dev/null)"; rc=$?; set -e
if [ "$rc" = 0 ] && [ "$got" = a-job ]; then ok "an active unit still claims"; else bad "active unit: rc=$rc got='$got'"; fi

echo "claim-stops-when-unit-stopping-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
