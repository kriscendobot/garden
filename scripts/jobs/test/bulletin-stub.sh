#!/bin/bash
# bulletin-stub.sh — deterministic journalist handler for tests. Records that it
# was invoked (so the cost gate can be asserted: an unchanged board must make NO
# call) and the digest it received (so resume/delta behavior can be inspected),
# then prints a fixed `## Latest` narrative body.
set -euo pipefail
digest="${1:?usage: bulletin-stub.sh <digest-file>}"
[ -n "${GARDEN_BULLETIN_STUB_CALLS:-}" ]   && echo "called" >> "$GARDEN_BULLETIN_STUB_CALLS"
[ -n "${GARDEN_BULLETIN_STUB_CAPTURE:-}" ] && cp "$digest" "$GARDEN_BULLETIN_STUB_CAPTURE"
echo "Stub narrative: the board advanced."
