#!/bin/bash
# cgroup-drain.sh — ExecStopPost backstop that holds a timer-driven oneshot unit in
# "deactivating" until its cgroup is actually EMPTY, so the next timer firing can
# never find "left-over process (git) in control group while starting unit". NO LLM.
#
# Usage:
#   cgroup-drain.sh <unit-name>        # as ExecStopPost=-/bin/bash …/cgroup-drain.sh %n
#   cgroup-drain.sh --describe <pid>…  # one diagnostic line per pid (used by the
#                                      # watchers' in-script reap on a deadline WARN)
#
# Why this exists (the third recurrence, 2026-09-24T10:57:28Z on
# garden-comment-watcher@kriscendobot-endo-but-for-bots). Measured on this host's
# systemd: when a Type=oneshot, KillMode=mixed unit's main process exits, cleanly or
# not (and likewise when an ExecCondition= skips the start), systemd at once SIGKILLs
# every process still in the cgroup. It does NOT wait for them to leave. The unit
# goes inactive while the SIGKILLed pids are still being torn down, and a pid in
# uninterruptible I/O (D-state: a git writing a pack, unlinking, fsyncing into a
# bloated clone) takes the signal only when that I/O returns. Nothing then holds
# the next start back: the timer is OnUnitActiveSec=90s, anchored to the previous
# ACTIVATION, so a tick that ran ~90s or longer (a slow GitHub, the 180s source
# timeout) has its next elapse already in the past, and the next instance starts
# the instant the previous one goes inactive. So the in-script reap cannot close
# this by itself: anything alive when the watcher exits (the self-heal wrapper's
# post-failure git capture, a straggler that beat its 3s deadline) goes into
# systemd's kill-and-forget sweep, and so does anything still dying from it.
#
# ExecStopPost runs AFTER that sweep, inside the same cgroup, and the unit stays
# "deactivating" (so the timer cannot start it again) until this script returns. So:
# re-read cgroup.procs, SIGKILL any live process other than this script and its own
# children, and return once two consecutive reads, 0.1s apart, find none. The loop is
# bounded by GARDEN_CGROUP_DRAIN_DEADLINE_SECS (default 15s, inside the units'
# TimeoutStopSec=20s so systemd never times the stop out). Every straggler is logged
# ONCE with /proc state, wchan, age and cmdline when first seen, and any survivor
# again at the deadline, so the next occurrence names its culprit rather than
# systemd's bare "(git)".
#
# Safety: a strict no-op unless /proc/self/cgroup's unified leaf is exactly the
# <unit-name> argument (so a shell or test harness can never sweep a shared
# session/scope cgroup). Never fails the unit: every path exits 0, and the unit
# prefixes the line with `-` as well.
set -uo pipefail

: "${GARDEN_CGROUP_DRAIN_DEADLINE_SECS:=15}"

_drain_log() { printf 'cgroup-drain[%s]: %s\n' "${UNIT:-?}" "$*" >&2; }

# _stat_fields <pid> — set ST (state letter), PP (ppid) and START (starttime in
# clock ticks) from /proc/<pid>/stat using builtins only (no fork, so a scan never
# adds a process to the cgroup it is reading). rc 1 if the pid is gone.
_stat_fields() {
  local line rest
  { read -r line < "/proc/$1/stat"; } 2>/dev/null || return 1
  rest="${line##*) }"              # comm may contain spaces/parens; state follows the LAST ") "
  # shellcheck disable=SC2034  # f4..f21 are placeholders to reach field 22 (starttime)
  read -r ST PP f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 START _ <<< "$rest"
  return 0
}

# describe_pid <pid> — one line: pid, state, ppid, pgid, age, wchan, cmdline.
describe_pid() {
  local p="$1" ST="" PP="" START="" pgid="" wchan="" cmd="" age="?" hz up
  if ! _stat_fields "$p"; then printf 'pid=%s gone\n' "$p"; return 0; fi
  pgid="$(ps -o pgid= -p "$p" 2>/dev/null | tr -d ' ')"
  { read -r wchan < "/proc/$p/wchan"; } 2>/dev/null || wchan="?"
  cmd="$(tr '\0' ' ' < "/proc/$p/cmdline" 2>/dev/null)"
  [ -n "$cmd" ] || cmd="[$(cat "/proc/$p/comm" 2>/dev/null)]"
  hz="$(getconf CLK_TCK 2>/dev/null || echo 100)"
  { read -r up _ < /proc/uptime; } 2>/dev/null || up=""
  if [ -n "$up" ] && [ -n "$START" ] && [ "$hz" -gt 0 ] 2>/dev/null; then
    age="$(( ${up%.*} - START / hz ))s"
  fi
  printf 'pid=%s state=%s ppid=%s pgid=%s age=%s wchan=%s cmd=%.240s\n' \
    "$p" "$ST" "$PP" "${pgid:-?}" "$age" "${wchan:-?}" "$cmd"
}

if [ "${1:-}" = --describe ]; then
  shift
  for p in "$@"; do describe_pid "$p"; done
  exit 0
fi

UNIT="${1:-}"
[ -n "$UNIT" ] || { _drain_log "no unit name given; nothing to drain"; exit 0; }

# Test-only override: drain a FIXTURE cgroup.procs file (honored only under
# GARDEN_TEST=1), bypassing the own-unit guard; the self/child keep-set still applies.
if [ -n "${GARDEN_CGROUP_DRAIN_PROCS_FILE:-}" ] && [ "${GARDEN_TEST:-0}" = 1 ]; then
  procs="$GARDEN_CGROUP_DRAIN_PROCS_FILE"
else
  line="$(grep '^0::' /proc/self/cgroup 2>/dev/null)" || exit 0
  cgpath="${line#0::}"
  [ "${cgpath##*/}" = "$UNIT" ] || exit 0
  procs="/sys/fs/cgroup${cgpath}/cgroup.procs"
fi
[ -r "$procs" ] || exit 0

seen=" "          # stragglers already described (log each one once)
killed=0
zero_reads=0
start=$SECONDS
while :; do
  remaining=0
  survivors=""
  while read -r pid; do
    [ -n "$pid" ] || continue
    [ "$pid" = "$$" ] && continue
    ST="" PP="" START=""
    _stat_fields "$pid" || continue          # already gone
    [ "$ST" = Z ] && continue                # a zombie has already left the cgroup
    [ "$PP" = "$$" ] && continue             # our own short-lived child (sleep/describe)
    case "$seen" in
      *" $pid "*) ;;
      *) seen="$seen$pid "; killed=$((killed + 1))
         _drain_log "straggler after main exit: $(describe_pid "$pid")" ;;
    esac
    kill -KILL "$pid" 2>/dev/null || true
    remaining=$((remaining + 1))
    survivors="$survivors $pid"
  done < "$procs"
  if [ "$remaining" -eq 0 ]; then
    zero_reads=$((zero_reads + 1))
    if [ "$zero_reads" -ge 2 ]; then
      [ "$killed" -gt 0 ] && _drain_log "cgroup drained: $killed straggler(s) gone after $((SECONDS - start))s"
      exit 0
    fi
  else
    zero_reads=0
  fi
  if [ $((SECONDS - start)) -ge "$GARDEN_CGROUP_DRAIN_DEADLINE_SECS" ]; then
    [ "$remaining" -eq 0 ] && exit 0
    _drain_log "WARN: $remaining straggler(s) survived SIGKILL for ${GARDEN_CGROUP_DRAIN_DEADLINE_SECS}s (uninterruptible I/O?); next start may see them:"
    for pid in $survivors; do _drain_log "  $(describe_pid "$pid")"; done
    exit 0
  fi
  sleep 0.1 2>/dev/null || sleep 1
done
