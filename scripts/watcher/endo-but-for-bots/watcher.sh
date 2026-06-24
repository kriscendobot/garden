#!/bin/bash
# watcher.sh -- per-feed watcher daemon for the endojs/endo-but-for-bots
# webhook stream.
#
# Phase 1 stub. This script documents the contract every per-feed
# watcher implements (see skills/activity-feed-watcher/SKILL.md) and
# exits cleanly so the systemd unit and the daemon-management scripts
# can be exercised end to end before the substantive feed integration
# lands in Phase 2-5.
#
# Contract every watcher implements when fully wired:
#
#   1. Poll the feed (a webhook stream, a `gh api` poll loop, etc.).
#   2. Classify each event (push, review submission, comment, label,
#      assigned-issue, CI status).
#   3. Read the union of all driver subscriptions in
#      journal/drivers/<host>/<lane>.subscriptions and decide which
#      events route to which per-PR event log
#      (journal/events/<repo>--<pr>.log). Events with no subscribed
#      driver post a job to journal/jobs/open/ instead.
#   4. Post the deterministic :eyes: reactji on every new comment
#      *before* routing the event anywhere downstream.
#   5. Self-heal on transient failures via systemd's Restart=on-failure
#      policy; persistent failures escalate to journal/inboxes/<host>/
#      gardener.md per skills/gardener-inbox-error-reporting/SKILL.md.
#
# Invocation:
#
#   scripts/watcher/endo-but-for-bots/watcher.sh
#
# Environment overrides (honored by the eventual implementation; the
# stub ignores all but GARDEN_ROOT):
#
#   GARDEN_ROOT      default: script-location-relative grandparent's parent
#   GARDEN_JOURNAL   default: $GARDEN_ROOT/journal
#   GARDEN_HOST      default: $(hostname -s)
#   FEED_POLL_SECONDS  default: 30
#
# See scripts/watcher/README.md for the feed inventory.
# See scripts/watcher/endo-but-for-bots/README.md for this feed's
# specifics (subscription contract, reactji policy, event types).
# See designs/driver.md § Watcher subscription model and event
# routing for the design rationale.

set -uo pipefail

FEED_SLUG=endo-but-for-bots

SCRIPT_PATH=$(cd "$(dirname "$0")" && pwd)
DEFAULT_GARDEN_ROOT=$(cd "$SCRIPT_PATH/../../.." && pwd)
GARDEN_ROOT=${GARDEN_ROOT:-$DEFAULT_GARDEN_ROOT}

echo "watcher[$FEED_SLUG]: stub invocation (Phase 1; no feed integration)" >&2
echo "watcher[$FEED_SLUG]: GARDEN_ROOT=$GARDEN_ROOT" >&2
echo "watcher[$FEED_SLUG]: see scripts/watcher/$FEED_SLUG/README.md and" >&2
echo "watcher[$FEED_SLUG]: skills/activity-feed-watcher/SKILL.md" >&2
echo "watcher[$FEED_SLUG]: exiting cleanly; substantive implementation deferred" >&2

exit 0
