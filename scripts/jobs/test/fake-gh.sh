#!/bin/bash
# fake-gh.sh — a hermetic stand-in for the real `gh`, used by the gh-identity
# subtest. The fleet wrapper (scripts/jobs/bin/gh) resolves the *real* gh via
# `type -aP gh` (skipping itself) and exec's it; in the test this file is that
# "real" gh, so the wrapper's token-injection logic runs for real against a
# deterministic backend with no network and no ~/.config/gh.
#
# It models exactly the two gh behaviors the wrapper depends on:
#   * `gh auth token --user <login>` → prints a per-login fake token.
#   * anything else (we use `api user`) → prints the login implied by $GH_TOKEN
#     ("token-for-<login>" → "<login>"), or, when GH_TOKEN is unset, the
#     simulated *global active account* read from $FAKE_GH_ACTIVE. That second
#     branch is the leak the wrapper exists to close.
set -euo pipefail
: "${FAKE_GH_ACTIVE:?fake-gh: set FAKE_GH_ACTIVE to a file holding the active login}"

if [ "${1:-}" = "auth" ] && [ "${2:-}" = "token" ]; then
  shift 2; user=""
  while [ $# -gt 0 ]; do
    [ "$1" = "--user" ] && { user="${2:-}"; shift; }
    shift
  done
  if [ -n "$user" ]; then echo "token-for-$user"; else cat "$FAKE_GH_ACTIVE"; fi
  exit 0
fi

# identity resolution for any other invocation
if [ -n "${GH_TOKEN:-}" ]; then
  echo "${GH_TOKEN#token-for-}"
else
  cat "$FAKE_GH_ACTIVE"
fi
