#!/bin/bash
# is-main-host.sh — the leader/follower predicate as an executable. NO LLM.
#
# Usage: is-main-host.sh
#   exit 0 → this host IS the leader (the singletons should run here)
#   exit 1 → this host is a follower (the singletons skip here)
#
# This is the systemd `ExecCondition=` for every leader-only singleton service:
# on a follower the timer still fires but the oneshot is SKIPPED CLEANLY
# (condition-failed, never marked Failed), which IS "follower mode — wait until
# promoted." Because each timer firing re-evaluates the condition, promotion and
# demotion are picked up at the next tick with no restart needed. The continuous
# bulletin singleton and the watchman broadcast gate the SAME predicate in-process
# (is_main_host in common.sh) rather than at start, so they promote/demote without
# a restart too. See issue kriskowal/garden#11 and designs/multibot-leader-follower.md.
#
# Deliberately NOT `set -e`: the final test's non-zero exit IS the follower answer,
# not an error. Everything is wrapped so the script never exits 255 or dies, which
# systemd would treat as a genuine ExecCondition FAILURE rather than a clean skip.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="is-main-host"

if is_main_host; then exit 0; else exit 1; fi
