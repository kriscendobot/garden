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

# Optional failure injection: GARDEN_MOCK_FAIL_UNIT names a unit whose
# restart/start the mock reports as failed (exit 1), so tests can exercise the
# restart path's per-unit failure isolation. The call is still logged above.
if [ -n "${GARDEN_MOCK_FAIL_UNIT:-}" ]; then
  case "$cmd" in
    restart|start)
      for a in "$@"; do [ "$a" = "$GARDEN_MOCK_FAIL_UNIT" ] && exit 1; done ;;
  esac
fi

# Optional hang injection: GARDEN_MOCK_HANG_UNIT names a unit whose
# restart/start/stop/show the mock makes hang (a long sleep), so tests can exercise
# the caller's bounded-`timeout` per-unit skip path — the whole point of
# unit_ctl_bounded. These are the manager-talking (job-enqueuing) verbs the callers
# now wrap in unit_ctl_bounded; the cheap `enable`/`disable` file ops are issued
# unbounded (they do not block on a job), so they are deliberately NOT hangable
# here. The sleep is longer than any sane per-unit bound; the caller's `timeout -k`
# SIGTERMs (then SIGKILLs) this process, which returns rc 124/137.
if [ -n "${GARDEN_MOCK_HANG_UNIT:-}" ]; then
  case "$cmd" in
    restart|start|stop|show)
      for a in "$@"; do [ "$a" = "$GARDEN_MOCK_HANG_UNIT" ] && sleep 30; done ;;
  esac
fi

case "$cmd" in
  daemon-reload|reset-failed|status|restart|start|stop) : ;;
  show)
    # `show -p MainPID --value <unit>` → echo the unit's MainPID from the mock map
    # ($GARDEN_MOCK_PIDS/<unit>, one integer), or 0 when unset/absent. Only the
    # MainPID property the identity-reconcile step reads is emulated. Pick the
    # token that LOOKS like a unit (`-p`'s value `MainPID` is not one, and the unit
    # may appear before or after the flags), not unit_arg's first-non-flag token.
    u=""; for a in "$@"; do case "$a" in *.service|*.timer|*@*) u="$a";; esac; done
    if [ -n "${GARDEN_MOCK_PIDS:-}" ] && [ -f "$GARDEN_MOCK_PIDS/$u" ]; then
      cat "$GARDEN_MOCK_PIDS/$u"
    else
      echo 0
    fi
    ;;
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
    u="$(unit_arg "$@")"
    # Optional enable-failure injection for the arm-retry path. When
    # GARDEN_MOCK_FAIL_ENABLE_UNIT names this unit, fail `enable` (write a
    # systemctl-shaped diagnostic to stderr and exit 1) for the first
    # GARDEN_MOCK_FAIL_ENABLE_COUNT attempts, then succeed — modeling a transient
    # systemctl/XDG_RUNTIME_DIR hiccup the in-tick retry rides out. With COUNT
    # unset, every attempt fails (the persistent-failure WARN path). The attempt
    # tally persists in GARDEN_MOCK_FAIL_ENABLE_STATE across the retry's calls.
    if [ -n "${GARDEN_MOCK_FAIL_ENABLE_UNIT:-}" ] && [ "$u" = "$GARDEN_MOCK_FAIL_ENABLE_UNIT" ]; then
      cnt_file="${GARDEN_MOCK_FAIL_ENABLE_STATE:-$STATE.enfail}"
      n=0; [ -f "$cnt_file" ] && n="$(cat "$cnt_file")"
      n=$((n + 1)); echo "$n" > "$cnt_file"
      if [ -z "${GARDEN_MOCK_FAIL_ENABLE_COUNT:-}" ] || [ "$n" -le "${GARDEN_MOCK_FAIL_ENABLE_COUNT}" ]; then
        echo "Failed to enable unit $u: Failed to connect to bus: \$XDG_RUNTIME_DIR not set" >&2
        exit 1
      fi
    fi
    grep -qxF "$u" "$STATE" 2>/dev/null || echo "$u" >> "$STATE" ;;
  disable)
    u="$(unit_arg "$@")"; grep -vxF "$u" "$STATE" > "$STATE.tmp" 2>/dev/null || true; mv "$STATE.tmp" "$STATE" ;;
  is-enabled)
    # echo "enabled"/exit 0 for an armed unit, else "disabled"/exit 1 (mirrors systemctl)
    u="$(unit_arg "$@")"
    if grep -qxF "$u" "$STATE" 2>/dev/null; then echo enabled; else echo disabled; exit 1; fi ;;
  *) : ;;
esac
