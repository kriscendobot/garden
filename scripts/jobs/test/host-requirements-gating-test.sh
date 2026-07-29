#!/bin/bash
# host-requirements-gating-test.sh — requirements claim/runtime/watch regression.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-req.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" "$SEED/work" "$SEED/inbox/maintainer/unread" "$SEED/inbox/maintainer/read"
for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do touch "$SEED/$d/.gitkeep"; done
cat > "$SEED/jobs/todo/aws.md" <<'EOF'
---
requires: aws
---
# aws job
EOF
printf '# ordinary job\n' > "$SEED/jobs/todo/plain.md"
git -C "$SEED" add -A; git -C "$SEED" -c user.name=t -c user.email=t@l commit -qm seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"
VERIFY="$TR/verify"; printf '#!/bin/sh\n[ "${AWS_OK:-0}" = 1 ]\n' > "$VERIFY"; chmod +x "$VERIFY"
claim() { env GARDEN=host-a GARDEN_STATE="$TR/state-$1" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_GARDENER_CLONE="$TR/clone-$1" GARDEN_AWS_VERIFY="$VERIFY" AWS_OK="$2" "$JOBS/claim-job.sh" 1; }

got="$(claim unavailable 0 2>/dev/null || true)"
[ "$got" = plain ] && ok "host without AWS skips requires: aws and claims unheadered plain job" || bad "without AWS claimed '$got' (wanted plain)"
V="$TR/v"; git clone -q --branch "$BRANCH" "$BARE" "$V"
[ -e "$V/jobs/todo/aws.md" ] && ok "AWS job remains todo on incapable host" || bad "AWS job was moved by incapable host"

# Requeue the ordinary claim so the next isolated claimant sees only the AWS job.
git -C "$V" mv jobs/doin/plain.md jobs/tada/plain.md; rm -f "$V/work/plain"; git -C "$V" add -A; git -C "$V" -c user.name=t -c user.email=t@l commit -qm clear; git -C "$V" push -q
got="$(claim available 1 2>/dev/null || true)"
[ "$got" = aws ] && ok "host with AWS claims requires: aws" || bad "with AWS claimed '$got' (wanted aws)"

# The authoritative probe is used both through the cache and freshly.
JOB="$TR/job"; printf '%s\n' '---' 'requires: aws' '---' > "$JOB"
fresh="$(env GARDEN_STATE="$TR/fresh" GARDEN_AWS_VERIFY="$VERIFY" AWS_OK=1 bash -c 'source "$1"; host_capability_available aws; AWS_OK=0 host_capability_available aws fresh; echo $?' _ "$JOBS/common.sh")"
[ "$fresh" = 1 ] && ok "post-claim fresh probe detects an AWS lapse despite cached claim verdict" || bad "fresh probe did not re-check capability (rc=$fresh)"

# Drive the shared fresh predicate through the real worker completion path: the
# first (claim) probe passes and the immediately following post-claim probe fails.
P="$TR/post"; git clone -q --branch "$BRANCH" "$BARE" "$P"
git -C "$P" mv jobs/doin/aws.md jobs/todo/aws.md; rm -f "$P/work/aws"; git -C "$P" add -A; git -C "$P" -c user.name=t -c user.email=t@l commit -qm requeue-aws; git -C "$P" push -q; rm -rf "$P"
LAPSE="$TR/lapse-verify"; cat > "$LAPSE" <<'EOF'
#!/bin/sh
n=$(cat "$AWS_PROBE_COUNT" 2>/dev/null || echo 0); n=$((n + 1)); echo "$n" > "$AWS_PROBE_COUNT"
[ "$n" -le 1 ]
EOF
chmod +x "$LAPSE"
env GARDEN=host-b GARDEN_STATE="$TR/post-state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN_WORKER_KIND=gardener GARDEN_GARDENER_CLONE="$TR/post-clone" \
  GARDEN_AWS_VERIFY="$LAPSE" AWS_PROBE_COUNT="$TR/probes" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=0 \
  GARDEN_JOB_HANDLER="$HERE/stub-handler.sh" "$JOBS/gardener.sh" 1 >"$TR/post.log" 2>&1 || true
rm -rf "$V"; git clone -q --branch "$BRANCH" "$BARE" "$V"
grep -q 'blocked: host requirements' "$V/jobs/tada/aws.md" 2>/dev/null \
  && ok "post-claim lapse completes a blocked report before the handler" \
  || bad "post-claim lapse was not completed as a blocked report ($(tr '\n' ' ' < "$TR/post.log" 2>/dev/null))"

# An opaque unknown requirement has no host probe and must surface, not silently wait.
W="$TR/watch"; git clone -q --branch "$BRANCH" "$BARE" "$W"
cat > "$W/jobs/todo/aws.md" <<'EOF'
---
requires: quantum
---
# unclaimable job
EOF
git -C "$W" add -A; git -C "$W" -c user.name=t -c user.email=t@l commit -qm unclaimable; git -C "$W" push -q; rm -rf "$W"
ALERT="$TR/alert"; cat > "$ALERT" <<'EOF'
#!/bin/sh
printf '%s\n%s\n' "$1" "$2" > "$ALERT_OUT"
EOF
chmod +x "$ALERT"
env -u GARDEN_NO_MAINTAINER_ALERT GARDEN=leader GARDEN_STATE="$TR/watch-state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN_REQUIREMENTS_DWELL_SECS=0 GARDEN_REQUIREMENTS_WATCH_CLONE="$TR/watch-clone" \
  GARDEN_ALERT_CMD="$ALERT" ALERT_OUT="$TR/alert.out" "$JOBS/requirements-watch.sh" >"$TR/watch.log" 2>&1
grep -q "job 'aws'.*requires: quantum" "$TR/alert.out" && ok "unclaimable requirement produces maintainer notice" || bad "no maintainer notice naming aws/quantum ($(tr '\n' ' ' < "$TR/watch.log" 2>/dev/null))"

echo "host-requirements-gating-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
