#!/bin/bash
# GARDEN_GH fixture: model gh's client-side primary-quota preflight refusal.
echo x >>"$GH_STUB_CALLS"
# Optional latency, so concurrent callers genuinely overlap the in-flight request.
[ -z "${GH_STUB_SLEEP:-}" ] || sleep "$GH_STUB_SLEEP"
echo "gh: API rate limit already exceeded for user ID 279080640." >&2
exit 1
