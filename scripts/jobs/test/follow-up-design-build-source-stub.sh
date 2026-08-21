#!/bin/bash
set -euo pipefail
[ "${FDB_STATE:?set FDB_STATE}" != FAIL ] || exit 1
printf '%s\n' "${FDB_STATE:?set FDB_STATE}"
