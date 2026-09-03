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
export GARDEN_TAG="upgrade-monitor"

# --- silent-skip watchdog (cybernetics-audit rec 10 / § 2.7) -----------------
# A tick that cannot even READ its two sensors — the fetch of origin/$GARDEN_MAIN_BRANCH,
# or the resolve of the available/deployed sha — used to exit 0 in SILENCE, its only
# backstop the multi-day stalled-deploy alert in root-repo-guard.sh. A silent detector
# is indistinguishable from a healthy one (audit § 2.7): the weeks-long 07-17..09-01
# deploy blockage read as a code regression instead of a blind sensor. So count
# CONSECUTIVE blind ticks and, past a threshold, raise ONE keyed maintainer alert via
# alert_maintainer → watchdog-notice.sh (the amend-while-unread discipline, so a
# persistent blindness never duplicates). At the :02/5 cadence the default threshold
# surfaces a blind sensor in ~an hour, not weeks. A transient one-off fetch blip stays
# silent (the counter resets on the next readable tick).
: "${GARDEN_UPGRADE_SILENT_SKIP_ALERT:=12}"
SS_DIR="$GARDEN_STATE/upgrade-monitor"
SS_COUNT="$SS_DIR/consecutive-silent-skips"
SS_KEY="upgrade-monitor-blind-$GARDEN"

silent_skip() {  # silent_skip <reason> — count a blind tick; alert past the threshold
  local reason="$1" n
  mkdir -p "$SS_DIR" 2>/dev/null || true
  n="$(cat "$SS_COUNT" 2>/dev/null || echo 0)"; [[ "$n" =~ ^[0-9]+$ ]] || n=0
  n=$(( n + 1 ))
  printf '%s\n' "$n" > "$SS_COUNT" 2>/dev/null || true
  log "silent skip #$n (of $GARDEN_UPGRADE_SILENT_SKIP_ALERT before alert): $reason"
  if [ "$n" -ge "$GARDEN_UPGRADE_SILENT_SKIP_ALERT" ]; then
    alert_maintainer "$SS_KEY" \
"upgrade-monitor on $GARDEN has been BLIND for $n consecutive tick(s) (~$(( n * 5 ))min): $reason.
The deploy-readiness sensor cannot read origin/$GARDEN_MAIN_BRANCH or resolve the
available/deployed sha, so it can neither RAISE nor CLEAR the Upgrade-ready signal —
a silent hole its only other backstop, the multi-day stalled-deploy alert, is slow to
fill. Investigate this host's git/network access to origin, or its recorded deploy
state under \$GARDEN_STATE/deploy. (host=$GARDEN)"
  fi
}

silent_skip_clear() {  # a tick that READ both sensors closes any open blindness episode
  local n
  n="$(cat "$SS_COUNT" 2>/dev/null || echo 0)"; [[ "$n" =~ ^[0-9]+$ ]] || n=0
  [ "$n" -gt 0 ] || return 0
  rm -f "$SS_COUNT" 2>/dev/null || true
  alert_maintainer_clear "$SS_KEY" \
    "upgrade-monitor on $GARDEN can read its sensors again (was blind for $n consecutive tick(s))."
}

git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" 2>/dev/null \
  || { silent_skip "fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?)"; exit 0; }

up_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "origin/$GARDEN_MAIN_BRANCH" || true)"
[ -n "$up_sha" ] || { silent_skip "cannot resolve origin/$GARDEN_MAIN_BRANCH after a successful fetch"; exit 0; }

dep_sha="$(deployed_sha)"
[ -n "$dep_sha" ] || { silent_skip "no deployed sha recorded and no tree HEAD"; exit 0; }

# Both sensors read cleanly this tick: close any open blindness episode.
silent_skip_clear

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
  echo "host:      $GARDEN"
  echo "detected:  $(date -u +%FT%TZ)"
  echo
  echo "The liaison's deploy-on-upgrade Monitor invokes deploy-garden.sh on this signal."
  echo "Or deploy by hand: scripts/jobs/deploy-garden.sh"
} > "$GARDEN_UPGRADE_READY_MARKER"
log "Upgrade ready: $GARDEN_MAIN_BRANCH ahead by $ahead commit(s) ($dep_sha -> $up_sha); signal at $GARDEN_UPGRADE_READY_MARKER"
