#!/bin/bash
# improver-stub.sh — deterministic improver handler for tests. If the digest
# mentions an error, post one improvement job.
set -euo pipefail
digest="${1:?digest}"
JOBS="$(cd "$(dirname "$0")/.." && pwd)"
if grep -qi 'error' "$digest"; then
  echo "harden the failing automation observed in the log" | "$JOBS/post-job.sh" "improve-fromtest"
fi
