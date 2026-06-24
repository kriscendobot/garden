#!/bin/bash
# mock-systemctl.sh — emulate the `systemctl --user` subset repo-watcher uses,
# so the watch-set→unit reconciliation can be tested without real systemd.
# Tracks the "armed" unit set in $GARDEN_MOCK_STATE and logs calls to
# $GARDEN_MOCK_LOG.
set -euo pipefail
STATE="${GARDEN_MOCK_STATE:?set GARDEN_MOCK_STATE}"
LOG="${GARDEN_MOCK_LOG:?set GARDEN_MOCK_LOG}"
touch "$STATE" "$LOG"
cmd="${1:-}"; shift || true
echo "systemctl --user $cmd $*" >> "$LOG"

# extract a unit argument (the non-flag token)
unit_arg() { for a in "$@"; do case "$a" in --*) ;; *) printf '%s' "$a"; return;; esac; done; }

case "$cmd" in
  daemon-reload|reset-failed|status) : ;;
  list-units|list-unit-files)
    # print "<unit> enabled" for each armed unit matching the glob pattern arg
    pat=""; for a in "$@"; do case "$a" in --*) ;; *) pat="$a";; esac; done
    while read -r u; do
      [ -n "$u" ] || continue
      if [ -z "$pat" ]; then printf '%s enabled\n' "$u"
      else case "$u" in $pat) printf '%s enabled\n' "$u";; esac; fi
    done < "$STATE"
    ;;
  enable)
    u="$(unit_arg "$@")"; grep -qxF "$u" "$STATE" 2>/dev/null || echo "$u" >> "$STATE" ;;
  disable)
    u="$(unit_arg "$@")"; grep -vxF "$u" "$STATE" > "$STATE.tmp" 2>/dev/null || true; mv "$STATE.tmp" "$STATE" ;;
  *) : ;;
esac
