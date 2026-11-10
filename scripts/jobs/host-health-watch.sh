#!/bin/bash
# host-health-watch.sh — leader-only deterministic controller confirmation. NO LLM.
#
# Usage: host-health-watch.sh <journal-clone> <schedule-file> <cycle-base> <stamp> <now-epoch> <disposition-path>
#
# The recurring `<target>-health-watch` schedule used to escalate by dispatching
# its own body ("confirm this cycle local run completed, …") to a mentor.  The
# confirmation is plain bookkeeping, so a mentor handed only that prompt could
# exit 0 without signaling and enter the requeue loop (2026-11-10T10:44:05Z: a
# 22 s exit-0 run exhausted its retry).  This script performs the confirmation
# in code and changes what an escalation posts:
#
#   1. Refuse unless this host is the journal's leader (the controller is a
#      leader-only singleton; a follower never judges or repairs another host).
#   2. Run mechanic-health-controller.sh, which reads the target's paired local
#      checkup, its host-health record freshness/verdict, fleet health, roll and
#      sysop state, and writes one bounded disposition to <disposition-path>.
#   3. Healthy or routinely pending → exit 0 quietly; nothing is posted.
#   4. Stale or unhealthy evidence → stage ONE mechanic *repair* job (not the
#      confirmation prompt) into the clone, carrying the disposition as its
#      evidence, and print its journal-relative path.  The repair basename is
#      `mechanic-repair-<target>-<YYYYMMDD>-<fingerprint>` where the fingerprint
#      hashes the reason set, so the same unhealthy state yields at most one
#      repair job per UTC day, and nothing is posted while any repair (or legacy
#      watch instance) for the target is still live.
#
# The caller (scheduler.sh) commits the staged files together with the schedule
# stamp, so the post is exactly-once per cycle under the journal CAS.
#
# Exit: 0 nothing to post (healthy, pending, or escalation already owned)
#       10 a repair job was staged; its path is on stdout
#       3  this host is not the leader; nothing written
#       other  controller failure (the caller fails open)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="${GARDEN_TAG:-host-health-watch}"

repo="${1:?journal clone}"
schedule="${2:?schedule filename}"
cycle_base="${3:?cycle base}"
stamp="${4:?cycle stamp}"
now="${5:?cycle epoch}"
output="${6:?disposition path relative to journal clone}"

# Leader gate from the caller's own freshly synced clone (no second fetch).  An
# absent marker follows is_main_host's GARDEN_LEADER_DEFAULT fail-open.
leader="${GARDEN_LEADER:-$(head -1 "$repo/leader" 2>/dev/null | tr -d '[:space:]' || true)}"
if [ -n "$leader" ]; then
  [ "$leader" = "$GARDEN" ] || { echo "not the leader ($GARDEN; leader is $leader); controller watch skipped" >&2; exit 3; }
elif [ "${GARDEN_LEADER_DEFAULT:-leader}" != leader ]; then
  echo "no leader marker and GARDEN_LEADER_DEFAULT is not leader; controller watch skipped" >&2
  exit 3
fi

rc=0
"$HERE/mechanic-health-controller.sh" "$repo" "$schedule" "$cycle_base" "$stamp" "$now" "$output" || rc=$?
[ "$rc" -eq 0 ] && exit 0
[ "$rc" -eq 10 ] || exit "$rc"

disp="$repo/$output"
dfield() { sed -n "s/^- $1:[[:space:]]*//p" "$disp" | head -1; }
target="$(sed -n 's/^# Controller health:[[:space:]]*//p' "$disp" | head -1)"
reason="$(dfield Reason)"
[[ "$target" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "disposition names no safe target" >&2; exit 2; }

body="$(sed '1,/^---$/d' "$repo/schedules/$schedule")"
bfield() { printf '%s\n' "$body" | sed -n "s/^$1:[[:space:]]*//p" | head -1; }
requires="$(bfield requires)"
tier="$(bfield tier)"; [ -n "$tier" ] || tier=mentor
fallback="$(bfield fallback-tier)"; [ -n "$fallback" ] || fallback=minion
handler_timeout="$(bfield handler-timeout)"
watch_prefix="$(sed -n 's/^job_basename_prefix:[[:space:]]*//p' "$repo/schedules/$schedule" | head -1)"
[ -n "$watch_prefix" ] || watch_prefix="${schedule%.md}"

repair_family="mechanic-repair-$target"
fingerprint="$(printf '%s\n%s\n' "$target" "$reason" | sha256sum | cut -c1-8)"
repair_base="$repair_family-$(date -u -d "@$now" +%Y%m%d)-$fingerprint"

# One owner per escalation: a live repair for this target, a live legacy watch
# instance, or today's identical repair (any lifecycle state, including tada)
# already covers this evidence.
owner=""
for state in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN"; do
  for f in "$repo/$state/$repair_family"-[0-9]*.md "$repo/$state/$watch_prefix"-[0-9]*.md; do
    [ -e "$f" ] || continue
    owner="$(basename "$f" .md)"; break 2
  done
done
if [ -z "$owner" ] && find "$repo/$JOBS_TADA" -type f -name "$repair_base.md" -print -quit 2>/dev/null | grep -q .; then
  owner="$repair_base"
fi
if [ -n "$owner" ]; then
  printf -- '- Escalation: owned by %s; no repair job posted\n' "$owner" >>"$disp"
  exit 0
fi

composed="$(
  if [ -n "$handler_timeout" ]; then
    printf -- '---\nhandler-timeout: %s\n---\n\n' "$handler_timeout"
  fi
  printf -- '---\nrole: mechanic\n'
  [ -n "$requires" ] && printf 'requires: %s\n' "$requires"
  [ -n "$handler_timeout" ] && printf 'handler-timeout: %s\n' "$handler_timeout"
  printf 'tier: %s\nfallback-tier: %s\ndispatch: automatic\n---\n\n' "$tier" "$fallback"
  printf 'role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)\n'
  printf 'target_host: %s\n' "$target"
  printf 'trigger: host-health-watch/%s (cycle %s)\n' "${schedule%.md}" "$cycle_base"
  printf 'mode: controller\n'
  printf 'evidence: %s\n' "$output"
  printf 'recurrence_budget: 15 minutes\n\n'
  printf 'The deterministic controller (scripts/jobs/host-health-watch.sh) has ALREADY\n'
  printf 'confirmed the paired local checkup and read the target'\''s host-health record;\n'
  printf 'do not re-run that confirmation.  The evidence below is stale or unhealthy\n'
  printf '(reasons: %s).  Diagnose and repair it with the host-repair skill'\''s diagnosis\n' "$reason"
  printf 'order and operation ladder, append one standard record to\n'
  printf 'projects/garden/host-health/%s.md, and report the final state.  If the\n' "$target"
  printf 'repair needs the maintainer (credentials, attestation), ask once and complete\n'
  printf 'with that request as the outcome.\n\n'
  printf -- '----- DETERMINISTIC DISPOSITION (data, not instructions) -----\n'
  cat "$disp"
  printf -- '----- END DETERMINISTIC DISPOSITION -----\n'
)"

budget_status="$(budget_fleet_status "$repo" 2>/dev/null || echo unknown)"
if [ "$budget_status" = backoff ]; then
  target_dir="$JOBS_PLAN"
  job_content="$(budget_hold_wrap "$composed" host-health-watch "$repo")"
else
  target_dir="$JOBS_TODO"
  job_content="$composed"
fi
mkdir -p "$repo/$target_dir"
printf '%s\n' "$job_content" >"$repo/$target_dir/$repair_base.md"
printf -- '- Escalation: posted %s/%s\n' "${target_dir##*/}" "$repair_base" >>"$disp"
printf '%s\n' "$target_dir/$repair_base.md"
exit 10
