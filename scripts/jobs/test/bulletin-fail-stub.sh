#!/bin/bash
# bulletin-fail-stub.sh — a journalist handler that always fails, for the
# graceful-degradation test: bulletin.sh must still ship the deterministic
# dashboard (preserving the prior `## Latest`) and advance the cursor.
set -euo pipefail
: "${1:?usage: bulletin-fail-stub.sh <digest-file>}"
exit 1
