#!/bin/bash
# namespace-clone-maintenance-test.sh - lock-contention diagnostic coalescing.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d /home/kris/.garden-namespace-maintenance.XXXXXX)"
trap 'rm -rf "$TR"' EXIT

make_clone() {
  local name="$1"
  mkdir -p "$TR/state/$name"
  git init -q "$TR/state/$name/journal"
}

make_clone alpha
make_clone beta
mkdir -p "$TR/busy-bin"
cat > "$TR/busy-bin/flock" <<'EOF'
#!/bin/bash
# Model the non-TTY capture handed to journald: log() prefixes warnings with
# <4>. Repeating the expected line beyond a pipe buffer catches a grep -q match
# that is accidentally replaced by the producer's SIGPIPE under pipefail.
for _ in $(seq 1 1024); do
  printf '<4>00:00:00 [fixture] WARN: clone lock /fixture/journal.lock busy >5s; abandoning this OPTIONAL refresh (fail-open, no retry ladder)\n' >&2
done
exit 1
EOF
chmod +x "$TR/busy-bin/flock"

PATH="$TR/busy-bin:$PATH" \
  GARDEN_STATE="$TR/state" \
  GARDEN_NS_CLONE_JITTER=0 \
  GARDEN_NS_CLONE_PACK_THRESHOLD=999 \
  GARDEN_LOCK_SOFT_WAIT=0 \
  GARDEN_LOCK_STEALS=0 \
  GARDEN_CONTENTION_INSTRUMENT=0 \
  "$JOBS/namespace-clone-maintenance.sh" 2>"$TR/busy.err"

[ "$(grep -c 'clone lock contention: skipped 2 busy clone(s) this tick:' "$TR/busy.err")" -eq 1 ] \
  || { echo 'FAIL: busy clones did not produce one coalesced summary'; cat "$TR/busy.err"; exit 1; }
if [ "$(wc -l < "$TR/busy.err")" -ne 1 ] \
   || grep -q '<4>\|abandoning this OPTIONAL refresh' "$TR/busy.err" \
   || ! grep -q '^<6>.*clone lock contention:' "$TR/busy.err"; then
  echo 'FAIL: non-TTY priority capture emitted more than the info-priority coalesced summary'
  cat "$TR/busy.err"
  exit 1
fi
if ! grep -q "$TR/state/alpha/journal" "$TR/busy.err" \
   || ! grep -q "$TR/state/beta/journal" "$TR/busy.err"; then
  echo 'FAIL: contention summary omitted a busy clone'
  cat "$TR/busy.err"
  exit 1
fi

mkdir -p "$TR/fail-bin"
cat > "$TR/fail-bin/ionice" <<'EOF'
#!/bin/bash
exit 124
EOF
chmod +x "$TR/fail-bin/ionice"

PATH="$TR/fail-bin:$PATH" \
  GARDEN_STATE="$TR/state" \
  GARDEN_NS_CLONE_JITTER=0 \
  GARDEN_NS_CLONE_PACK_THRESHOLD=-1 \
  GARDEN_NS_CLONE_NOTICE=/bin/true \
  GARDEN_CONTENTION_INSTRUMENT=0 \
  "$JOBS/namespace-clone-maintenance.sh" 2>"$TR/failure.err"

[ "$(grep -c 'repack failed or timed out' "$TR/failure.err")" -eq 2 ] \
  || { echo 'FAIL: real maintenance failures were not surfaced per clone'; cat "$TR/failure.err"; exit 1; }
! grep -q 'clone lock contention:' "$TR/failure.err" \
  || { echo 'FAIL: repack failures were misclassified as contention'; cat "$TR/failure.err"; exit 1; }

# The transcript-capture clone lives at transcripts/clone, not */journal; it
# must still get the stale-tmp prune and the over-threshold repack.
rm -rf "$TR/state"
mkdir -p "$TR/state/transcripts" "$TR/state/notrepo/journal"
git init -q "$TR/state/transcripts/clone"
tpack="$TR/state/transcripts/clone/.git/objects/pack"
for i in 1 2 3; do
  echo "$i" > "$TR/state/transcripts/clone/f$i"
  git -C "$TR/state/transcripts/clone" add "f$i"
  git -C "$TR/state/transcripts/clone" -c user.name=t -c user.email=t@t commit -qm "$i"
  git -C "$TR/state/transcripts/clone" repack -q
done
touch -d '-5 hours' "$tpack/tmp_pack_stale"
[ "$(find "$tpack" -name 'pack-*.pack' | wc -l)" -ge 2 ] \
  || { echo 'FAIL: transcripts fixture did not build multiple packs'; exit 1; }
GARDEN_STATE="$TR/state" \
  GARDEN_NS_CLONE_JITTER=0 \
  GARDEN_NS_CLONE_PACK_THRESHOLD=1 \
  GARDEN_NS_CLONE_NOTICE=/bin/true \
  GARDEN_CONTENTION_INSTRUMENT=0 \
  "$JOBS/namespace-clone-maintenance.sh" 2>"$TR/transcripts.err"
[ ! -e "$tpack/tmp_pack_stale" ] \
  || { echo 'FAIL: stale tmp_pack in the transcripts clone was not pruned'; cat "$TR/transcripts.err"; exit 1; }
[ "$(find "$tpack" -name 'pack-*.pack' | wc -l)" -eq 1 ] \
  || { echo 'FAIL: transcripts clone was not repacked'; cat "$TR/transcripts.err"; exit 1; }
! grep -q 'notrepo' "$TR/transcripts.err" \
  || { echo 'FAIL: a non-repo */journal dir was treated as a clone'; cat "$TR/transcripts.err"; exit 1; }

echo 'PASS: soft clone-lock contention is coalesced and maintenance failures stay visible'
