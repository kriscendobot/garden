#!/bin/bash
# api-cooldown-test.sh - guard the host-shared GitHub API watcher cooldown.
#
# Systemd watcher instances share GARDEN_ROOT but may use independently namespaced
# GARDEN_STATE directories. The cooldown must therefore resolve below GARDEN_ROOT,
# serialize concurrent detectors on one lock inode, and remain visible to later ticks.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

unset GARDEN_API_COOLDOWN_DIR GARDEN_API_COOLDOWN_MARKER GARDEN_API_COOLDOWN_LOCK
TR="$(mktemp -d "${TMPDIR:-/tmp}/api-cooldown.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
ROOT="$TR/rendered-root"
mkdir -p "$ROOT"
MARKER="$ROOT/.garden-state/gh-api-cooldown/marker"

run_common() {  # run_common <state-namespace> <shell-body>
  # shellcheck disable=SC2016
  env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/$1" GARDEN_API_COOLDOWN_SECS=300 \
    bash -c 'source "$1"; eval "$2"' _ "$JOBS/common.sh" "$2"
}

# A detector in one service namespace must publish into the host root, not its own
# GARDEN_STATE. A sibling namespace must see the same live marker.
run_common ci 'start_api_cooldown "ci:first"'
if [ -s "$MARKER" ]; then
  ok "detector writes the cooldown below the shared GARDEN_ROOT"
else
  bad "detector did not write $MARKER"
fi
if [ ! -e "$TR/state/ci/gh-api-cooldown/marker" ]; then
  ok "cooldown is not stranded in the invocation-local GARDEN_STATE"
else
  bad "cooldown leaked into an invocation-local state namespace"
fi
if run_common comment 'api_cooldown_active'; then
  ok "a sibling watcher namespace sees the host cooldown"
else
  bad "a sibling watcher namespace missed the host cooldown"
fi

# Remove the first episode, then race independent unit-shaped ticks. flock must
# allow exactly one detector to open the episode while every process uses a distinct
# GARDEN_STATE directory. The resulting marker must survive after all ticks exit.
rm -f "$MARKER"
RESULTS="$TR/results"
mkdir -p "$RESULTS"
for n in 1 2 3 4 5 6 7 8; do
  (
    if run_common "race-$n" "start_api_cooldown race-$n"; then
      printf 'opened\n' > "$RESULTS/$n"
    else
      printf 'observed\n' > "$RESULTS/$n"
    fi
  ) &
done
wait
opened="$(grep -l '^opened$' "$RESULTS"/* | wc -l)"
if [ "$opened" -eq 1 ]; then
  ok "eight concurrent watcher ticks produce one cooldown-opening transition"
else
  bad "concurrent ticks produced $opened cooldown-opening transitions"
fi
if [ -s "$MARKER" ]; then
  ok "the shared marker survives all concurrent detector processes"
else
  bad "the shared marker disappeared after concurrent ticks"
fi

misses=0
for n in 1 2 3 4 5 6 7 8; do
  run_common "next-$n" 'api_cooldown_active' || misses=$((misses + 1))
done
if [ "$misses" -eq 0 ]; then
  ok "every next-tick namespace is suppressed by the concurrent episode"
else
  bad "$misses next-tick namespaces missed the concurrent episode"
fi

# A primary-quota detector requests the FULL hour (not the 300s default) so the shared
# latch outlives the whole quota window. The requested window is honored and reflected
# in the marker's expiry; the default (unrequested) window keeps its short clamp.
rm -f "$MARKER"
run_common quota 'start_api_cooldown "mc:primary-quota" "$(api_primary_quota_secs)"'
now="$(date +%s)"
expiry="$(sed -n '1p' "$MARKER" 2>/dev/null || echo 0)"
remaining=$(( expiry - now ))
if [ "$remaining" -gt 900 ] && [ "$remaining" -le 3600 ]; then
  ok "a primary-quota request arms the full-hour window (>900s default clamp), ${remaining}s"
else
  bad "primary-quota window was ${remaining}s (expected >900 and <=3600)"
fi
# api_primary_quota_secs is the one-hour policy, clamped to the requested-window cap.
got="$(run_common quota 'api_primary_quota_secs')"
[ "$got" = 3600 ] && ok "api_primary_quota_secs defaults to one hour" \
  || bad "api_primary_quota_secs was '$got' (expected 3600)"
got="$(env GARDEN_API_PRIMARY_QUOTA_SECS=99999 GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/cap" \
  GARDEN_API_COOLDOWN_SECS=300 bash -c 'source "$1"; api_primary_quota_secs' _ "$JOBS/common.sh")"
[ "$got" = 7200 ] && ok "a requested window is clamped to GARDEN_API_COOLDOWN_MAX_SECS (7200)" \
  || bad "requested window not clamped to the max: got '$got'"
# An out-of-range/garbage request falls back to the short default clamp, not the hour.
rm -f "$MARKER"
run_common defclamp 'start_api_cooldown "d" "not-a-number"'
now="$(date +%s)"; expiry="$(sed -n '1p' "$MARKER" 2>/dev/null || echo 0)"; remaining=$(( expiry - now ))
if [ "$remaining" -le 300 ] && [ "$remaining" -gt 0 ]; then
  ok "a non-numeric request falls back to the short default window (${remaining}s)"
else
  bad "non-numeric request produced a ${remaining}s window (expected <=300)"
fi
# The disable escape hatch (default window 0) wins over a request: still a no-op.
rm -f "$MARKER"
env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/off" GARDEN_API_COOLDOWN_SECS=0 \
  bash -c 'source "$1"; start_api_cooldown "d" 3600' _ "$JOBS/common.sh"
[ ! -e "$MARKER" ] && ok "the disable escape hatch (secs=0) no-ops even with a requested window" \
  || bad "a requested window bypassed the disable escape hatch"

# SCOPE — a GraphQL-only latch (the ci-watcher's `gh pr view` rollup refusal) must
# not blind REST-only watchers: GitHub meters the buckets separately. 2026-09-23: the
# host-wide latch re-armed hourly off a spent GraphQL bucket and kept the REST comment
# watchers silent ~2.5h past a trusted "Please conduct" (kriscendobot/minion.town #112).
GQL_MARKER="$ROOT/.garden-state/gh-api-cooldown/marker-graphql"
rm -f "$MARKER" "$GQL_MARKER"
run_common ci 'start_api_cooldown "ci:rollup" "$(api_primary_quota_secs)" graphql'
[ -s "$GQL_MARKER" ] && [ ! -e "$MARKER" ] \
  && ok "a graphql-scoped start writes only the GraphQL marker" \
  || bad "graphql-scoped start wrote the wrong marker(s)"
run_common comment 'api_cooldown_active rest' \
  && bad "a GraphQL-only latch blinded a REST-only watcher" \
  || ok "a REST-only watcher ignores the GraphQL-only latch"
run_common ci 'api_cooldown_active' \
  && ok "an unscoped (GraphQL-using) watcher still honors the GraphQL latch" \
  || bad "the unscoped check missed the GraphQL latch"
run_common comment 'api_cooldown_active graphql' \
  && ok "a GraphQL call site honors the GraphQL latch" \
  || bad "the graphql-scoped check missed the GraphQL latch"
# A REST blip still opens the host-wide window while the GraphQL latch is live.
run_common comment 'start_api_cooldown "comment:blip"' \
  && ok "a live GraphQL latch does not stop a REST blip opening the host-wide window" \
  || bad "the GraphQL latch suppressed the host-wide window"
run_common comment 'api_cooldown_active rest' \
  && ok "the host-wide window quiets REST-only watchers" \
  || bad "REST-only watcher missed the host-wide window"
# Expiry reaps each marker independently.
printf '0\nexpired\n' > "$GQL_MARKER"; printf '0\nexpired\n' > "$MARKER"
run_common ci 'api_cooldown_active' && bad "expired markers still read live" \
  || ok "expired host-wide and GraphQL markers read inactive"
[ ! -e "$GQL_MARKER" ] && [ ! -e "$MARKER" ] && ok "expired markers are reaped" \
  || bad "expired markers were not reaped"

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
