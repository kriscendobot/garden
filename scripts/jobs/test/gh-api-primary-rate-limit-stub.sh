#!/bin/bash
# GARDEN_GH fixture: model gh's client-side primary-quota preflight refusal.
echo x >>"$GH_STUB_CALLS"
echo "gh: API rate limit already exceeded for user ID 279080640." >&2
exit 1
