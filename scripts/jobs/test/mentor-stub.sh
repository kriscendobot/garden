#!/bin/bash
# mentor-stub.sh — deterministic mentor handler for tests. Exercises the
# capture-by-hash interface: it receives the digest blob's SHA and the clone
# dir, reads the captured blob via `git cat-file -p`, and if it mentions an
# error, posts one improvement job.
set -euo pipefail
sha="${1:?digest-sha}"
dir="${2:?clone-dir}"
JOBS="$(cd "$(dirname "$0")/.." && pwd)"
# Read the captured blob into a variable, then grep — `git cat-file -p | grep -q`
# under `set -o pipefail` reports failure when grep short-circuits on first match
# and SIGPIPEs the upstream cat-file. A real responder inspects the same way.
blob="$(git -C "$dir" cat-file -p "$sha")"
if grep -qi 'error' <<<"$blob"; then
  echo "harden the failing automation observed in the log" | "$JOBS/post-job.sh" "improve-fromtest"
fi
