#!/bin/bash
# Put the provider refusal well outside the final 64 KiB of a multi-megabyte
# handler transcript, reproducing the Ironhorse fuzz-repair failure shape.
set -euo pipefail
base="${1:?base required}"
report="${3:?report required}"

head -c 1048576 /dev/zero | tr '\0' x
printf '\nThis content was flagged for possible cybersecurity risk. See the Trusted Access for Cyber program.\n'
head -c 2097152 /dev/zero | tr '\0' y
printf '# failed %s\nprovider returned a terminal policy refusal\n' "$base" > "$report"
exit 1
