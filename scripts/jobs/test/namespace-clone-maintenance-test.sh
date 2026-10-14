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

echo 'PASS: soft clone-lock contention is coalesced and maintenance failures stay visible'
