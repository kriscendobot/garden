#!/bin/bash
# drain-fleet.sh — start or stop draining this host's gardener fleet.
#
# Usage:
#   drain-fleet.sh on  [reason...]   write the draining marker (fleet drains)
#   drain-fleet.sh off               remove the draining marker (fleet resumes)
#   drain-fleet.sh status            report whether the fleet is draining
#
# Draining is a graceful, mundane pause: workers finish whatever they have
# already claimed but take no new claims while the marker is present. The marker
# is a host-local FILE under $GARDEN_STATE; its EXISTENCE is the programmatic
# signal (the fleet_draining predicate in common.sh keys on existence only). Its
# CONTENTS are a short prose note so anyone who finds the file understands what it
# does and how to clear it.
#
# The deprecated legacy marker ($GARDEN_KILLSWITCH, the old NOPE killswitch) is
# still honored by fleet_draining for backward compatibility. This helper writes
# and clears the NEW draining marker; clear an old NOPE marker by hand.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="drain-fleet"

action="${1:-status}"

case "$action" in
  on)
    shift || true
    reason="$*"
    mkdir -p "$(dirname "$GARDEN_DRAINING_MARKER")"
    {
      echo "This host's gardener fleet is DRAINING."
      echo
      echo "While this file exists, every gardener finishes its in-flight claim"
      echo "but takes no new ones. This is a graceful pause, not a kill — nothing"
      echo "is interrupted; the fleet simply stops accepting new work."
      echo
      echo "To resume the fleet, remove this file:"
      echo "    scripts/jobs/drain-fleet.sh off"
      echo "    (or just: rm '$GARDEN_DRAINING_MARKER')"
      echo
      echo "set_by: $GARDEN_HOST"
      echo "set_at: $(date -u +%FT%TZ)"
      [ -n "$reason" ] && echo "reason: $reason"
    } > "$GARDEN_DRAINING_MARKER"
    log "fleet draining ON — marker written at $GARDEN_DRAINING_MARKER"
    ;;
  off)
    if [ -e "$GARDEN_DRAINING_MARKER" ]; then
      rm -f "$GARDEN_DRAINING_MARKER"
      log "fleet draining OFF — marker removed; fleet resumes"
    else
      log "fleet was not draining (no marker at $GARDEN_DRAINING_MARKER)"
    fi
    if [ -e "$GARDEN_KILLSWITCH" ]; then
      log "NOTE: deprecated legacy marker still present at $GARDEN_KILLSWITCH; remove it by hand to fully resume"
    fi
    ;;
  status)
    if fleet_draining; then
      log "DRAINING"
      [ -e "$GARDEN_DRAINING_MARKER" ] && log "  draining marker: $GARDEN_DRAINING_MARKER"
      [ -e "$GARDEN_KILLSWITCH" ]      && log "  legacy marker (deprecated): $GARDEN_KILLSWITCH"
      exit 0
    fi
    log "not draining"
    ;;
  *)
    die "usage: drain-fleet.sh on [reason...] | off | status"
    ;;
esac
