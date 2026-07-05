#!/bin/bash
# follow-up.sh — the follow-up service: watch completed job reports in
# jobs/tada/, and convert each report's follow-ups into action (one-time jobs,
# scheduled jobs, or maintainer messages). Wears the LIAISON role via its
# handler.
#
# Usage: follow-up.sh
#
# Part of the garden's autonomous posture (silent until an error). Each tick:
#   1. sync a dedicated journal clone,
#   2. find tada reports new since a seen-marker (keyed by jobs/tada/<base>.md,
#      exactly like mentor's SEEN),
#   3. extract each new report's `## Follow-ups` (escalated-to-liaison) section;
#      a report with no actionable follow-ups is skipped but still marked seen,
#   4. hand a digest of the actionable follow-ups to a pluggable handler
#      (an autonomous liaison) that classifies and executes each one.
# The seen-marker advances only on handler success, so a failed tick retries.
#
# BOUNDED RETRY: a handler that keeps failing on the SAME pending set must not
# re-run `claude -p` every cadence forever (the 2026-06-27 07:53–08:44 episode:
# ~6 ticks of 200–370 MB each plus repeated self-heal-responder invocations). A
# consecutive-failure counter is keyed by a hash of the unchanged new-report set
# ($GARDEN_STATE/follow-up/fail-count, holding "<count> <sha-of-new-list>"). It
# increments on each failed tick whose pending set is unchanged and resets to 0
# on success or when the pending set changes. After GARDEN_FOLLOWUP_MAX_RETRIES
# (default 5) we escalate ONCE to the maintainer inbox with the digest + last
# failure signature, advance the seen-marker to QUARANTINE those reports, and
# exit 0 — so a wedged digest stops burning ticks/CPU/API spend and stops
# re-triggering the self-heal responder. Below the threshold the leave-marker-
# and-retry behavior holds, so a transient rate-limit/usage-cap window still
# self-resolves.
#
# COLD START: on the very first tick (no seen-marker yet) we record every
# existing tada report as seen WITHOUT acting. This bounds the autonomous
# surface to follow-ups produced AFTER the service is installed, rather than
# replaying the entire historical backlog — consistent with the tightly-bound
# authority the liaison role carries here.
#
# Pluggable for tests: GARDEN_FOLLOWUP_HANDLER <digest-file>.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="follow-up"
: "${GARDEN_FOLLOWUP_HANDLER:=$HERE/handlers/follow-up-claude.sh}"
# Consecutive-failure ceiling before a wedged digest is quarantined (see below).
: "${GARDEN_FOLLOWUP_MAX_RETRIES:=5}"

fleet_draining && exit 0

DIR="${GARDEN_FOLLOWUP_CLONE:-$GARDEN_STATE/follow-up/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

SEEN="$GARDEN_STATE/follow-up/seen"
FAILCOUNT="$GARDEN_STATE/follow-up/fail-count"
mkdir -p "$(dirname "$SEEN")"
cold_start=0; [ -e "$SEEN" ] || cold_start=1
touch "$SEEN"

# new tada reports since last run (keyed by the jobs/tada/<base>.md rel path)
new=()
while IFS= read -r f; do
  rel="${f#"$DIR"/}"
  grep -qxF "$rel" "$SEEN" && continue
  new+=("$f")
done < <(find "$DIR/$JOBS_TADA" -type f -name '*.md' 2>/dev/null | sort)

# Record the whole new set as seen (used on success, on no-op, and to quarantine
# a wedged digest). Appends each new report's rel-path to the seen-marker.
mark_new_seen() { local f; for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done; }

# A content hash of the (sorted) new-report rel-path set — the key the
# consecutive-failure counter is bound to, so an UNCHANGED pending set increments
# the streak while any change (a new report arrives, or some clear) resets it.
new_list_sha() { local f; for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}"; done | sort | git -C "$DIR" hash-object --stdin; }

# cold start: record everything seen without acting, then stay silent
if [ "$cold_start" -eq 1 ]; then
  mark_new_seen
  [ "${#new[@]}" -gt 0 ] && log "cold start: marked ${#new[@]} existing tada report(s) seen without acting"
  exit 0
fi

# nothing new → stay silent
[ "${#new[@]}" -eq 0 ] && exit 0

# Extract a report's follow-up section: the lines under a `## Follow-ups…`
# heading, up to the next `## ` heading or EOF. Sub-headings (`### …`) do not
# terminate it.
extract_followups() {
  awk '
    /^##[[:space:]]+[Ff]ollow-?[Uu]ps/ { grab=1; next }
    grab && /^##[[:space:]]/           { grab=0 }
    grab                               { print }
  ' "$1"
}

# Actionable iff the section's first content word is not "None". Looks at only
# the first whitespace-delimited token (after any leading list marker) so that
# "None.", "None — …", and "None. No embargo… (note)" are all treated as no-op,
# while "Reopen …" or "- weaver rebase #197" are actionable.
is_actionable() {
  local first word
  first="$(printf '%s' "$1" | grep -m1 '[^[:space:]]' || true)"
  [ -n "$first" ] || return 1
  word="$(printf '%s' "$first" | sed -E 's/^[[:space:]]*[-*•]?[[:space:]]*//' | awk '{print tolower($1)}')"
  case "$word" in none|none.|none,|none:|none\;) return 1;; esac
  return 0
}

digest="$(mktemp "${TMPDIR:-/tmp}/garden-follow-up.XXXXXX")"
actionable=0
for f in "${new[@]}"; do
  rel="${f#"$DIR"/}"; base="${rel#"$JOBS_TADA"/}"; base="${base%.md}"
  section="$(extract_followups "$f")"
  if is_actionable "$section"; then
    actionable=$((actionable+1))
    {
      printf '===== REPORT %s =====\n' "$base"
      printf '%s\n' "$section"
      printf '===== END REPORT %s =====\n\n' "$base"
    } >> "$digest"
  fi
done

# no actionable follow-ups → mark all new seen and stay silent
if [ "$actionable" -eq 0 ]; then
  mark_new_seen
  rm -f "$FAILCOUNT" "$digest"
  exit 0
fi

# Hand the digest to the inner agent. On success: advance the seen-marker and
# clear the failure streak. On failure: bound the retries (see the BOUNDED RETRY
# note at the top) so a permanently-wedged digest cannot re-run `claude -p` every
# cadence forever. We capture the handler's combined output so the escalation can
# carry the LAST FAILURE SIGNATURE without re-running it.
handler_out="$(mktemp "${TMPDIR:-/tmp}/garden-follow-up-handler.XXXXXX")"
if "$GARDEN_FOLLOWUP_HANDLER" "$digest" >"$handler_out" 2>&1; then
  mark_new_seen
  rm -f "$FAILCOUNT" "$digest" "$handler_out"
  exit 0
fi

# Handler failed. Increment the streak iff the pending set is unchanged from the
# last failed tick; reset it to 1 otherwise. The counter is keyed by a hash of
# the new-report set so a genuinely transient window keeps retrying the same
# digest, but a digest that NEVER succeeds is bounded.
cur_sha="$(new_list_sha)"
prev_count=0; prev_sha=""
[ -f "$FAILCOUNT" ] && read -r prev_count prev_sha _ < "$FAILCOUNT" 2>/dev/null || true
case "${prev_count:-}" in ''|*[!0-9]*) prev_count=0 ;; esac
if [ "$prev_sha" = "$cur_sha" ]; then count=$((prev_count + 1)); else count=1; fi

if [ "$count" -ge "$GARDEN_FOLLOWUP_MAX_RETRIES" ]; then
  # Wedged: escalate ONCE with the digest + last failure signature, QUARANTINE
  # the reports (advance the seen-marker), clear the streak, and exit 0 so the
  # tick stops failing — no more per-cadence `claude -p` burn, no more self-heal
  # responder re-triggers.
  sig="$(tail -c 800 "$handler_out" 2>/dev/null || true)"
  {
    printf 'The garden-follow-up handler failed %s consecutive ticks on the SAME pending set of tada reports (ceiling GARDEN_FOLLOWUP_MAX_RETRIES=%s). Quarantining them now (advancing the seen-marker) so they stop re-running `claude -p` every cadence and stop re-triggering the self-heal responder. Inspect the digest below and re-post the work manually if it is still wanted.\n\n' \
      "$count" "$GARDEN_FOLLOWUP_MAX_RETRIES"
    printf '===== QUARANTINED REPORTS =====\n'
    for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}"; done
    printf '\n===== FOLLOW-UP DIGEST =====\n'
    cat "$digest"
    printf '\n===== LAST FAILURE SIGNATURE =====\n%s\n' "${sig:-<empty>}"
  } | GARDEN_SENDER="follow-up:quarantine" "$GARDEN_ROOT/scripts/jobs/inbox-send.sh" maintainer >/dev/null 2>&1 \
    || log "could not escalate wedged follow-up digest to maintainer (quarantining anyway)"
  mark_new_seen
  rm -f "$FAILCOUNT" "$digest" "$handler_out"
  log "quarantined ${#new[@]} wedged tada report(s) after $count consecutive failures (escalated to maintainer)"
  exit 0
fi

# Below the ceiling: record the streak and leave the markers so the next tick
# retries the same digest (a transient back-off self-resolves here).
mkdir -p "$(dirname "$FAILCOUNT")"
printf '%s %s\n' "$count" "$cur_sha" > "$FAILCOUNT"
rm -f "$digest" "$handler_out"
die "follow-up handler failed ($count/$GARDEN_FOLLOWUP_MAX_RETRIES); leaving markers so the next tick retries"
