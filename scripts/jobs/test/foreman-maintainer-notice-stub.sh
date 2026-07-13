#!/bin/bash
# foreman-maintainer-notice-stub.sh — deterministic foreman handler for the
# maintainer-notice dedup test. Emits ONE MAINTAINER block whose body is read
# from $GARDEN_TEST_NOTICE_BODY (a file). The body is REWORDED between ticks that
# describe the SAME substance to prove the dedup keys on substance, not prose.
set -euo pipefail
: "${1:?usage: foreman-maintainer-notice-stub.sh <digest-file>}"
body="$(cat "${GARDEN_TEST_NOTICE_BODY:?set GARDEN_TEST_NOTICE_BODY}")"
printf 'MAINTAINER\n%s\nENDMAINTAINER\n' "$body"
