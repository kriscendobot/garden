#!/bin/bash
# leader-clone-tree-fallback-test.sh — config lookups that read an
# already-synced clone's working tree must not read the leader clone's. That
# clone is fetch-only, so its tree is frozen at clone time and would shadow the
# fresher root journal worktree.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d)"
trap 'rm -rf "$TR"' EXIT

mkdir -p "$TR/root/journal/config" "$TR/leader/config"
echo off > "$TR/root/journal/config/kimi-takes-opus-work"
echo on > "$TR/leader/config/kimi-takes-opus-work"
echo 'fresh routing' > "$TR/root/journal/config/model-routing"
echo 'stale routing' > "$TR/leader/config/model-routing"
echo 'fresh promos' > "$TR/root/journal/config/openrouter-promos"
echo 'stale promos' > "$TR/leader/config/openrouter-promos"

run() {
  env -u GARDEN_WORKER_CLONE -u GARDEN_PRODUCER_CLONE -u GARDEN_REAPER_CLONE \
    -u GARDEN_KIMI_FALLBACK_ENABLED -u GARDEN_MODEL_ROUTING_FILE \
    -u GARDEN_OPENROUTER_PROMOS_FILE \
    GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_LEADER_CLONE="$TR/leader" \
    bash -c "source '$JOBS/common.sh' >/dev/null 2>&1; $1"
}

if run kimi_fallback_enabled; then
  echo 'FAIL: kimi_fallback_enabled read the stale leader clone tree'; exit 1
fi
[ "$(run _model_routing_table)" = 'fresh routing' ] \
  || { echo 'FAIL: _model_routing_table read the stale leader clone tree'; exit 1; }
[ "$(run _openrouter_promos_file)" = "$TR/root/journal/config/openrouter-promos" ] \
  || { echo 'FAIL: _openrouter_promos_file chose the stale leader clone tree'; exit 1; }

echo 'PASS: tree-reading config lookups skip the fetch-only leader clone'
