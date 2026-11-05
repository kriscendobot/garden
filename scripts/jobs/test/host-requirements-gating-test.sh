#!/bin/bash
# host-requirements-gating-test.sh — requirements claim/runtime/watch regression.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
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
claim() { env GARDEN=host-a GARDEN_STATE="$TR/state-$1" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_WORKER_CLONE="$TR/clone-$1" GARDEN_AWS_VERIFY="$VERIFY" AWS_OK="$2" "$JOBS/claim-job.sh" 1; }

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
  GARDEN_WORKER_KIND=monk GARDEN_WORKER_CLONE="$TR/post-clone" \
  GARDEN_AWS_VERIFY="$LAPSE" AWS_PROBE_COUNT="$TR/probes" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=0 \
  GARDEN_JOB_HANDLER="$HERE/stub-handler.sh" "$JOBS/gardener.sh" 1 >"$TR/post.log" 2>&1 || true
rm -rf "$V"; git clone -q --branch "$BRANCH" "$BARE" "$V"
grep -rq 'blocked: host requirements' "$V/jobs/tada" 2>/dev/null \
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

# A host pin whose pools are at high water is budget pacing, not a missing
# capability; the notice must say so, and name only the backed-off pool.
W="$TR/budget-seed"; git clone -q --branch "$BRANCH" "$BARE" "$W"
mkdir -p "$W/config" "$W/budget/live/pool-hot" "$W/budget/live/pool-cool"
printf 'pool-hot\topenai\tpercent\t95\tt\t2026-01-01\npool-cool\topenai\tpercent\t95\tt\t2026-01-01\n' > "$W/config/budget-pools"
printf 'pool-hot\thost-hot\tmonk\npool-cool\thost-cool\tmonk\n' > "$W/config/subscription-mapping"
printf '0.90\n' > "$W/config/token-backoff-initial"
live_now="$(date -u +%s)"
for pair in pool-hot:host-hot:99 pool-cool:host-cool:10; do
  IFS=: read -r p h u <<<"$pair"
  printf 'subscription: %s\nhost: %s\nspend: 1\ncap: 1000\nstatus: ok\nsampled_at_epoch: %s\nused_percent: %s\n' "$p" "$h" "$live_now" "$u" > "$W/budget/live/$p/$h"
done
printf '%s\n' '---' 'requires: host=host-hot' '---' > "$W/jobs/todo/pinned-hot.md"
printf '%s\n' '---' 'requires: host=host-cool' '---' > "$W/jobs/todo/pinned-cool.md"
git -C "$W" add -A; git -C "$W" -c user.name=t -c user.email=t@l commit -qm pinned; git -C "$W" push -q; rm -rf "$W"
ALERT2="$TR/alert2"; printf '#!/bin/sh\nprintf "%%s\\n%%s\\n" "$1" "$2" >> "$ALERT_OUT"\n' > "$ALERT2"; chmod +x "$ALERT2"
env -u GARDEN_NO_MAINTAINER_ALERT GARDEN=leader GARDEN_STATE="$TR/watch-state2" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN_REQUIREMENTS_DWELL_SECS=0 GARDEN_REQUIREMENTS_WATCH_CLONE="$TR/watch-clone2" \
  GARDEN_ALERT_CMD="$ALERT2" ALERT_OUT="$TR/alert2.out" "$JOBS/requirements-watch.sh" >"$TR/watch2.log" 2>&1
grep "job 'pinned-hot'" "$TR/alert2.out" | grep -q 'Budget pacing.*pool-hot' && ok "backed-off pinned host: notice names budget pacing and the pool" || bad "hot notice: $(grep pinned-hot "$TR/alert2.out")"
grep "job 'pinned-cool'" "$TR/alert2.out" | grep -q 'Budget pacing' && bad "healthy pinned host wrongly blamed on budget" || ok "healthy pinned host: notice keeps the plain capability wording"
grep "job 'pinned-cool'" "$TR/alert2.out" | grep -q 'requires: host=host-cool' && ok "healthy pinned host still notifies" || bad "no notice for pinned-cool"

# The dwell is one unbroken stay in todo: leaving todo restarts it, and so does a
# plain-retry back-off. Each watch run below shares one state dir and clone, and
# backdate stands in for the dwell window having passed.
W3="$TR/dwell-seed"; git clone -q --branch "$BRANCH" "$BARE" "$W3"
git -C "$W3" config user.name t; git -C "$W3" config user.email t@l
rm -f "$W3"/jobs/todo/*.md
land3() { git -C "$W3" add -A; git -C "$W3" commit -qm "$1"; git -C "$W3" push -q; }
watch3() {
  : > "$TR/alert3.out"
  env -u GARDEN_NO_MAINTAINER_ALERT GARDEN=leader GARDEN_STATE="$TR/watch-state3" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_FETCH_MAX_AGE_OVERRIDE=0 GARDEN_REQUIREMENTS_DWELL_SECS=600 GARDEN_REQUIREMENTS_WATCH_CLONE="$TR/watch-clone3" \
    GARDEN_ALERT_CMD="$ALERT2" ALERT_OUT="$TR/alert3.out" "$JOBS/requirements-watch.sh" >"$TR/watch3.log" 2>&1
}
backdate() {
  local m
  for m in "$TR/watch-state3/requirements-watch"/*.first; do
    [ -e "$m" ] && printf '%s\n' "$(( $(date -u +%s) - 1000 ))" > "$m"
  done
  return 0
}
pinned() { printf '%s\n' '---' 'requires: host=host-dwell' '---'; }
pinned > "$W3/jobs/todo/dwell.md"; land3 'dwell posted'
watch3; grep -q dwell "$TR/alert3.out" && bad "fresh job alerted before the dwell window" || ok "fresh job waits out the dwell window"
backdate; git -C "$W3" mv jobs/todo/dwell.md jobs/doin/dwell.md; land3 'dwell claimed'
watch3; [ -z "$(ls "$TR/watch-state3/requirements-watch"/*.first 2>/dev/null)" ] && ok "claimed job loses its dwell marker" || bad "dwell marker survived the claim"
git -C "$W3" mv jobs/doin/dwell.md jobs/todo/dwell.md; land3 'dwell requeued'
watch3; grep -q dwell "$TR/alert3.out" && bad "requeued job alerted on its pre-claim dwell" || ok "requeued job starts a fresh dwell"
backdate; watch3; grep -q "job 'dwell'" "$TR/alert3.out" && ok "unbroken dwell past the window still alerts" || bad "real dwell did not alert: $(cat "$TR/watch3.log")"
watch3; grep -q "job 'dwell'" "$TR/alert3.out" && bad "alert repeated while the job kept dwelling" || ok "alert fires once per dwell"
git -C "$W3" rm -qf jobs/todo/dwell.md
{ pinned; printf '<!-- garden-plain-retry-not-before: %s -->\n' "$(date -u -d '+1 hour' +%Y-%m-%dT%H:%M:%SZ)"; } > "$W3/jobs/todo/backoff.md"; land3 'backoff requeued'
watch3; backdate; watch3; grep -q backoff "$TR/alert3.out" && bad "job in plain-retry back-off alerted" || ok "plain-retry back-off does not count as dwell"
{ pinned; printf '<!-- garden-plain-retry-not-before: %s -->\n' "$(date -u -d '-1 hour' +%Y-%m-%dT%H:%M:%SZ)"; } > "$W3/jobs/todo/backoff.md"; land3 'backoff expired'
watch3; grep -q backoff "$TR/alert3.out" && bad "expired back-off alerted before the dwell window" || ok "dwell starts when the back-off expires"
backdate; watch3; grep -q "job 'backoff'" "$TR/alert3.out" && ok "dwell after an expired back-off alerts" || bad "expired back-off did not alert: $(cat "$TR/watch3.log")"

# scholar-ingest-* jobs implicitly require `typesafe`, probed from the file store.
T="$TR/typesafe"; mkdir -p "$T"
printf '# ingest\n' > "$T/scholar-ingest-foo.md"
printf '%s\n' '---' 'requires: typesafe, aws' '---' > "$T/scholar-ingest-bar.md"
printf '%s\n' '---' 'requires: typesafe' '---' > "$T/other.md"
printf '# other\n' > "$T/plain.md"
reqs() { bash -c 'source "$1"; job_requirements "$2" | paste -sd, -' _ "$JOBS/common.sh" "$1"; }
[ "$(reqs "$T/scholar-ingest-foo.md")" = typesafe ] && ok "scholar-ingest-* implicitly requires typesafe" || bad "implicit requirement: '$(reqs "$T/scholar-ingest-foo.md")'"
[ "$(reqs "$T/scholar-ingest-bar.md")" = typesafe,aws ] && ok "explicit typesafe is not duplicated" || bad "duplicate requirement: '$(reqs "$T/scholar-ingest-bar.md")'"
[ -z "$(reqs "$T/plain.md")" ] && ok "ordinary job gains no implicit requirement" || bad "plain job requirements: '$(reqs "$T/plain.md")'"
TS_STORE="$TR/typesafe-store"; mkdir -m 700 "$TS_STORE"
avail() { env -u TYPESAFE_API_KEY GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/ts-state" GARDEN_SECRETS_DIR="$TS_STORE" bash -c 'source "$1"; job_requirements_available "$2" && job_requirements_available "$2" fresh' _ "$JOBS/common.sh" "$1"; }
avail "$T/scholar-ingest-foo.md" && bad "scholar ingest claimable without TypeSafe file" || ok "scholar ingest not claimable without TypeSafe file"
TYPESAFE_API_KEY=legacy-env-only avail "$T/scholar-ingest-foo.md" && bad "legacy env alone satisfied typesafe" || ok "legacy env alone does not satisfy typesafe"
printf '%s' 'typesafe-offline-fixture-0000000000' > "$TS_STORE/typesafe.key"; chmod 600 "$TS_STORE/typesafe.key"
avail "$T/scholar-ingest-foo.md" && ok "scholar ingest claimable with valid TypeSafe file" || bad "scholar ingest refused valid TypeSafe file"
printf '%s' 'bad!' > "$TS_STORE/typesafe.key"
avail "$T/scholar-ingest-foo.md" && bad "malformed TypeSafe file satisfied capability" || ok "malformed TypeSafe file fails capability"
printf '%s' 'typesafe-offline-fixture-0000000000' > "$TS_STORE/typesafe.key"; chmod 644 "$TS_STORE/typesafe.key"
avail "$T/scholar-ingest-foo.md" && bad "wrong-mode TypeSafe file satisfied capability" || ok "wrong-mode TypeSafe file fails capability"
chmod 600 "$TS_STORE/typesafe.key"
avail "$T/other.md" && ok "explicit requires: typesafe admits valid file" || bad "explicit typesafe refused valid file"
avail "$T/plain.md" && ok "ordinary job claimable without key" || bad "ordinary job refused"
rt() { bash -c 'source "$1"; job_requires_token "$2" typesafe' _ "$JOBS/common.sh" "$1"; }
rt "$T/scholar-ingest-foo.md" && ! rt "$T/plain.md" && ok "job_requires_token distinguishes typesafe jobs" || bad "job_requires_token wrong"

echo "host-requirements-gating-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
