#!/bin/bash
# Deterministic roster/report for the standing Claude-on-minion.town completion press.
# Usage: claude-on-minion-town-completion-report.sh --since ISO [--until ISO]
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# The report's git calls go through the fleet git wrapper, which waits only
# GARDEN_REPO_LOCK_WAIT (default 10s in common.sh) for the shared journal clone
# lock. A briefly contended lock failed the scheduled report twice with rc 124;
# a 240s wait succeeded in 26s. Raise inherited values (a caller that sourced
# common.sh may export the 10s default) to a 240s floor, keeping larger overrides.
lock_wait="${GARDEN_REPO_LOCK_WAIT:-0}"
[[ "$lock_wait" =~ ^[0-9]+$ ]] || lock_wait=0
export GARDEN_REPO_LOCK_WAIT=$(( lock_wait > 240 ? lock_wait : 240 ))

window=(--schedule claude-on-minion-town-completion-press)
for arg in "$@"; do
  case "$arg" in --since|--since=*|--schedule|--schedule=*) window=(); break;; esac
done

args=("${window[@]}" "$@" --format json --expand-job-references
  --select-orchestration claude-on-minion-town-designs
  --select-prefix claude-on-minion-town-press-
  --select-prefix claude-on-minion-town-completion-press-
  --select-base design-minion-town-claude-harness-provisioning
  --select-base design-minion-town-claude-agents-root-endowment
  --select-base design-claude-agent-credential-reauth
  --select-base design-endo-claude-bare-caplet
  --select-base design-endo-guest-stdio-mcp
  --select-base design-endo-daemon-guest-bot-incarnation
  --select-base design-claude-on-minion-town-evaluation
  --select-text https://github.com/kriscendobot/garden/issues/89
  --select-text https://github.com/kriscendobot/minion.town/pull/87
  --select-text https://github.com/endojs/endo-but-for-bots/pull/1015
  --select-text https://github.com/endojs/endo-but-for-bots/pull/1125
  --select-text claude-agents-capability.md
  --select-text endo-claude.md
  --select-text mcp-daemon-guest-tools.md
  --select-text endo-gateway-mcp.md
  --select-text https://github.com/kriscendobot/minion.town/pull/96
  --select-text https://github.com/kriscendobot/minion.town/pull/97
  --select-text https://github.com/kriscendobot/minion.town/pull/98
  --select-text https://github.com/kriscendobot/minion.town/pull/99
  --select-text https://github.com/endojs/endo-but-for-bots/pull/1226
  --select-text https://github.com/endojs/endo-but-for-bots/pull/1227
  --select-text https://github.com/endojs/endo-but-for-bots/pull/1228)

# Retry once on rc 124 (a lock or git timeout) so a scheduled report needs no
# human rerun. Buffer stdout so a failed attempt's partial output never precedes
# the retry's report.
out="$(mktemp)"
trap 'rm -f "$out"' EXIT
for attempt in 1 2; do
  rc=0
  "$HERE/completion-window-report.py" "${args[@]}" > "$out" || rc=$?
  [ "$rc" -eq 124 ] && [ "$attempt" -eq 1 ] || break
  printf 'claude-on-minion-town-completion-report: rc 124; retrying once\n' >&2
done
cat "$out"
exit "$rc"
