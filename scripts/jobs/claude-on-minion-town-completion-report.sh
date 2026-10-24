#!/bin/bash
# Deterministic roster/report for the standing Claude-on-minion.town completion press.
# Usage: claude-on-minion-town-completion-report.sh [--since ISO [--until ISO]]
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEDULE=claude-on-minion-town-completion-press

# The report's git calls go through the fleet git wrapper, which waits only
# GARDEN_REPO_LOCK_WAIT (default 10s in common.sh) for the shared journal clone
# lock. A briefly contended lock failed the scheduled report twice with rc 124;
# a 240s wait succeeded in 26s. Raise inherited values (a caller that sourced
# common.sh may export the 10s default) to a 240s floor, keeping larger overrides.
lock_wait="${GARDEN_REPO_LOCK_WAIT:-0}"
[[ "$lock_wait" =~ ^[0-9]+$ ]] || lock_wait=0
export GARDEN_REPO_LOCK_WAIT=$(( lock_wait > 240 ? lock_wait : 240 ))

window=(--schedule "$SCHEDULE")
pinned=1
for arg in "$@"; do
  case "$arg" in
    --since|--since=*|--schedule|--schedule=*) window=();;
    --repo|--repo=*|--ref|--ref=*) pinned=0;;
  esac
done

# The default window comes from the schedule's dispatch stamps, so it is only as
# current as the producer clone's origin/journal2. On 2026-10-24 a lagging ref
# reported the prior 01:35->07:35 window at 13:51, after the 13:50 dispatch.
# Refresh the clone under its clone lock, pin the fetched tip so later producer
# resets cannot move the ref under the report, and refuse a stale newest stamp
# rather than asking the agent to pass --since/--until.
if [ "${#window[@]}" -gt 0 ] && [ "$pinned" -eq 1 ]; then
  # shellcheck source=common.sh
  source "$HERE/common.sh"
  clone="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  ensure_clone "$clone"
  sync_clone "$clone"
  ref="$(git -C "$clone" rev-parse --verify "origin/$JOURNAL_BRANCH^{commit}")" \
    || die "cannot resolve origin/$JOURNAL_BRANCH in $clone after refresh"
  clone_unlock "$clone"
  sched="$(git -C "$clone" show "$ref:schedules/$SCHEDULE.md" 2>/dev/null)" \
    || die "schedule $SCHEDULE absent at origin/$JOURNAL_BRANCH $ref"
  cadence="$(sed -n 's/^cadence:[[:space:]]*//p' <<<"$sched" | head -1)"
  stamp="$(sed -n 's/^last_dispatched:[[:space:]]*//p' <<<"$sched" | head -1)"
  case "$cadence" in
    hourly) period=3600;; daily) period=86400;; weekly) period=604800;;
    [0-9]*s) period="${cadence%s}";; [0-9]*m) period=$(( ${cadence%m} * 60 ));;
    [0-9]*h) period=$(( ${cadence%h} * 3600 ));; [0-9]*d) period=$(( ${cadence%d} * 86400 ));;
    # Anchored cadences: one local day/week, plus an hour of DST slack.
    daily-at-*) period=$(( 86400 + 3600 ));; weekly-at-*) period=$(( 604800 + 3600 ));;
    *) die "schedule $SCHEDULE has unrecognized cadence '$cadence'; cannot verify its dispatch stamp is current";;
  esac
  [[ "$period" =~ ^[0-9]+$ ]] && [ "$period" -gt 0 ] \
    || die "schedule $SCHEDULE cadence '$cadence' does not parse to a positive period"
  stamp_epoch="$(date -u -d "$stamp" +%s 2>/dev/null)" \
    || die "schedule $SCHEDULE has no parseable last_dispatched at $ref (got '$stamp')"
  now="${GARDEN_REPORT_NOW:-$(date -u +%s)}"
  # The scheduler stamps last_dispatched in the same commit that posts this
  # press, so after a fresh fetch the newest stamp is within one cadence of now.
  # Anything older means the current dispatch is still not visible.
  if [ $(( now - stamp_epoch )) -ge "$period" ]; then
    die "schedule $SCHEDULE newest last_dispatched $stamp is older than its $cadence cadence at origin/$JOURNAL_BRANCH $ref; the current dispatch stamp is unavailable, refusing to report the prior window"
  fi
  window+=(--repo "$clone" --ref "$ref")
fi

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
