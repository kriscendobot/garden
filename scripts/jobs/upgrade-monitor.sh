#!/bin/bash
# upgrade-monitor.sh — deterministic "Upgrade ready" detector. NO LLM.
#
# Usage: upgrade-monitor.sh
#
# Sole job: detect that the dev branch (origin/$GARDEN_MAIN_BRANCH) has advanced
# BEYOND the root checkout's recorded DEPLOYED sha, and signal it. It fetches,
# compares two shas, and writes (or clears) a state signal plus one log line. It
# never touches the tree and has no other side effects. Silent when the deployed
# version is current. See designs/deliberate-deploy.md § The "Upgrade ready" monitor.
#
# The signal ($GARDEN_UPGRADE_READY_MARKER) is what the liaison's Claude Code
# Monitor watches; on seeing it the liaison invokes deploy-garden.sh. The signal
# is rewritten while behind and REMOVED when the host catches up, so it is never
# stale: its mere presence means "a deploy would advance this host right now".

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="upgrade-monitor"

git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" 2>/dev/null \
  || { log "fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?); skipping tick"; exit 0; }

up_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "origin/$GARDEN_MAIN_BRANCH" || true)"
[ -n "$up_sha" ] || { log "cannot resolve origin/$GARDEN_MAIN_BRANCH; skipping tick"; exit 0; }

dep_sha="$(deployed_sha)"
[ -n "$dep_sha" ] || { log "no deployed sha recorded and no tree HEAD; skipping tick"; exit 0; }

# Up to date (or the recorded deploy is somehow AHEAD of origin — also "nothing to
# upgrade to"): clear any stale signal and stay silent.
if [ "$up_sha" = "$dep_sha" ] || git -C "$GARDEN_ROOT" merge-base --is-ancestor "$up_sha" "$dep_sha" 2>/dev/null; then
  if [ -e "$GARDEN_UPGRADE_READY_MARKER" ]; then
    rm -f "$GARDEN_UPGRADE_READY_MARKER"
    log "deployed version is current ($dep_sha); cleared stale Upgrade-ready signal"
  fi
  exit 0
fi

# origin is strictly ahead of the deployed sha → an upgrade is ready. Emit the
# signal (deployed→available shas + the ahead-by commit count) and one log line.
ahead="$(git -C "$GARDEN_ROOT" rev-list --count "$dep_sha..$up_sha" 2>/dev/null || echo '?')"
mkdir -p "$(dirname "$GARDEN_UPGRADE_READY_MARKER")" 2>/dev/null || true
{
  echo "Upgrade ready"
  echo
  echo "The dev branch ($GARDEN_MAIN_BRANCH) is ahead of this host's deployed version."
  echo "deployed:  $dep_sha"
  echo "available: $up_sha"
  echo "ahead_by:  $ahead commit(s)"
  echo "host:      $GARDEN_HOST"
  echo "detected:  $(date -u +%FT%TZ)"
  echo
  echo "The liaison's deploy-on-upgrade Monitor invokes deploy-garden.sh on this signal."
  echo "Or deploy by hand: scripts/jobs/deploy-garden.sh"
} > "$GARDEN_UPGRADE_READY_MARKER"
log "Upgrade ready: $GARDEN_MAIN_BRANCH ahead by $ahead commit(s) ($dep_sha -> $up_sha); signal at $GARDEN_UPGRADE_READY_MARKER"
