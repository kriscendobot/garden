#!/bin/bash
# claim-probe-replay-test.sh — a canary probe's claim replays a lost CAS onto the
# fresh journal tip instead of falling back to the next candidate. On a slow clone
# every claim lost to some peer write, so the probe never left todo/ and the roll
# failed a healthy canary (oros 2026-10-14 00:52-01:04Z). The replay is still a CAS
# on the claim's own paths: a peer that claimed the probe first keeps it, and an
# ordinary job's claim still re-derives from the fresh tip.
set -euo pipefail
export GARDEN_TEST=1 GARDEN_NO_MAINTAINER_ALERT=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-claim-probe-replay.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=t -c user.email=t@l)

# Push stub: before the worker's FIRST push, a peer lands $PEER_MODE on the bare
# (a genuine non-fast-forward for the worker), then the real push runs.
PUSH="$TR/push"
cat > "$PUSH" <<'P'
#!/bin/bash
n="$(cat "$COUNT" 2>/dev/null || echo 0)"; n=$((n + 1)); printf '%s\n' "$n" > "$COUNT"
if [ "$n" -eq 1 ]; then
  rm -rf "$PEER"; git clone -q --single-branch --branch journal2 "$BARE" "$PEER"
  case "$PEER_MODE" in
    disjoint) printf 'peer\n' > "$PEER/msgs-peer" ;;
    claim) mkdir -p "$PEER/jobs/doin"; git -C "$PEER" mv "jobs/todo/$JOB.md" "jobs/doin/$JOB.md"
           printf 'claim: peer\n' >> "$PEER/jobs/doin/$JOB.md" ;;
  esac
  git -C "$PEER" add -A; git -C "$PEER" -c user.name=p -c user.email=p@l commit -qm "peer $PEER_MODE"
  git -C "$PEER" push -q origin HEAD:journal2
fi
git -C "$GARDEN_PUSH_DIR" push -q origin HEAD:journal2
P
chmod +x "$PUSH"

# run <case> <job-leaf> <job-body> <peer-mode> — fresh journal with one todo job;
# echoes "<rc> <claimed>" and leaves the bare at $TR/<case>/journal.git.
run() {
  local d="$TR/$1" rc
  mkdir -p "$d"; git init -q --bare "$d/journal.git"; git init -q "$d/seed"
  git -C "$d/seed" checkout -q -b journal2
  for x in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do mkdir -p "$d/seed/$x"; touch "$d/seed/$x/.gitkeep"; done
  printf '%b' "$3" > "$d/seed/jobs/todo/$2.md"
  git -C "$d/seed" add -A; git -C "$d/seed" "${git_id[@]}" commit -qm seed
  git -C "$d/seed" push -q "$d/journal.git" journal2
  set +e
  got="$(env -u GARDEN_JOB_BASE -u GARDEN_COMPLETION_SENTINEL -u GARDEN_JOURNAL_REPLAY_ATTEMPTS \
    GARDEN=host-a GARDEN_WORKER_KIND=monk GARDEN_STATE="$d/state" \
    JOURNAL_REMOTE="$d/journal.git" JOURNAL_BRANCH=journal2 GARDEN_WORKER_CLONE="$d/clone" \
    GARDEN_PUSH_CMD="$PUSH" COUNT="$d/count" PEER="$d/peer" BARE="$d/journal.git" \
    PEER_MODE="$4" JOB="$2" "$JOBS/claim-job.sh" 1 2>"$d/log")"; rc=$?
  set -e
  echo "$rc ${got:--}"
}
PROBE='---\ncanary-probe: true\nhandler-timeout: 120\n---\n# probe\n'

set -- $(run disjoint probe-x "$PROBE" disjoint)
if [ "$1" = 0 ] && [ "$2" = probe-x ]; then ok "a probe claim that lost to a disjoint write lands by replay"; else bad "disjoint probe: rc=$1 got=$2 ($(tail -3 "$TR/disjoint/log" | tr '\n' ' '))"; fi
B="$TR/disjoint/journal.git"
if git --git-dir="$B" cat-file -e journal2:msgs-peer && git --git-dir="$B" cat-file -e journal2:jobs/doin/probe-x.md \
   && ! git --git-dir="$B" cat-file -e journal2:jobs/todo/probe-x.md 2>/dev/null; then ok "both the peer write and the claim are on the tip"; else bad "disjoint tip is wrong"; fi

set -- $(run peerclaim probe-y "$PROBE" claim)
if [ "$1" = 3 ] && [ "$2" = - ]; then ok "a probe a peer already claimed is not replayed over"; else bad "peer claim: rc=$1 got=$2"; fi
if git --git-dir="$TR/peerclaim/journal.git" show journal2:jobs/doin/probe-y.md | grep -q '^claim: peer'; then ok "the peer keeps its claim"; else bad "the peer's claim was clobbered"; fi

set -- $(run ordinary job-z '# ordinary\n' disjoint)
if [ "$1" = 3 ] && [ "$(cat "$TR/ordinary/count")" = 1 ]; then ok "an ordinary claim is not replayed (one push, re-derives next pass)"; else bad "ordinary: rc=$1 pushes=$(cat "$TR/ordinary/count")"; fi

echo "claim-probe-replay-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
