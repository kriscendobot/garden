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
#   2. find tada reports new since a seen-marker (keyed by stable basename),
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
# WHAT THE BUDGET IS FOR (and what must not spend it): quarantine DISCARDS work —
# it advances the seen-marker over reports whose follow-ups were never executed —
# so it is only ever the right answer for a digest that is ITSELF wedged. A
# correlated outage fails every tick for a reason that has nothing to do with the
# digest, and a counter that cannot tell the two apart silently spends the whole
# budget on the outage and then throws good follow-ups away (2026-07-28: four
# consecutive `garden-follow-up` failures at 08:48–09:18, one short of the ceiling,
# inside the storm that took down ~30 gardener handlers from 08:04). So a failed
# tick is charged to the digest ONLY when it is ATTRIBUTABLE to it. Not
# attributable, and therefore NOT counted (see uncounted_cause below):
#   * the handler exited a not-attributable rc (is_nonattributable_rc — the
#     explicit signal: follow-up-claude.sh `die_transient`s its API-blip and
#     push-contention arms, and `die_environmental`s an absent agent CLI);
#   * the shared fleet brake is engaged (fleet_brake_engaged — this host's pool is
#     in a correlated transient-failure storm);
#   * the handler's output carries a transient `claude -p` signature
#     (is_transient_claude_signature) — the text fallback for a third-party handler
#     that does not use the rc convention;
#   * the handler produced NO output and died on a signal/offline code
#     (is_transient_empty_failure).
# An uncounted tick leaves BOTH markers alone and exits GARDEN_TRANSIENT_RC, which
# self-heal-run.sh normalizes to a clean exit — so an outage costs no budget, no
# unit-failure noise, and no self-heal responder.
#
# UNCOUNTED IS NOT UNBOUNDED: a host that is permanently broken (rather than
# transiently) would otherwise retry silently forever. The uncounted stretch is
# bounded by WALL CLOCK instead of by tick count — after
# GARDEN_FOLLOWUP_TRANSIENT_MAX_SECS (default 6h) of unbroken not-attributable
# failures on the same pending set, we escalate ONCE to the maintainer
# ($GARDEN_STATE/follow-up/transient holds "<first-epoch> <sha> <notified>") and
# then KEEP RETRYING. Deliberately no quarantine on this path: the cause is
# environmental, so discarding the follow-ups would destroy work a human can still
# recover simply by fixing the host.
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
# Wall-clock bound on an UNCOUNTED (not-attributable) failure stretch before the
# maintainer is told once that this host is not recovering. 0 disables the notice.
: "${GARDEN_FOLLOWUP_TRANSIENT_MAX_SECS:=21600}"   # 6h
case "$GARDEN_FOLLOWUP_TRANSIENT_MAX_SECS" in ''|*[!0-9]*) GARDEN_FOLLOWUP_TRANSIENT_MAX_SECS=0 ;; esac

fleet_draining && exit 0

DIR="${GARDEN_FOLLOWUP_CLONE:-$GARDEN_STATE/follow-up/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

SEEN="$GARDEN_STATE/follow-up/seen"
FAILCOUNT="$GARDEN_STATE/follow-up/fail-count"
# The uncounted-stretch marker: "<first-epoch> <sha-of-new-list> <notified 0|1>".
TRANSIENT="$GARDEN_STATE/follow-up/transient"
mkdir -p "$(dirname "$SEEN")"
cold_start=0; [ -e "$SEEN" ] || cold_start=1
touch "$SEEN"

# Normalize the pre-sharding rel-path marker in place before comparing. This is
# deliberately basename-keyed so moving a report between flat and date-sharded
# layouts never makes thousands of old reports look new.
seen_normalized="$SEEN.normalized.$$"
awk -F/ '{ leaf=$NF; sub(/\.md$/, "", leaf); if (leaf != "") print leaf }' "$SEEN" \
  | sort -u > "$seen_normalized"
mv "$seen_normalized" "$SEEN"

# New tada reports since last run, resolved through the centralized lister.
new=()
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  f="$DIR/$rel"
  base="$(basename "$f" .md)"
  grep -qxF "$base" "$SEEN" && continue
  new+=("$f")
done < <(tada_list "$DIR")

# Record the whole new set as seen (used on success, on no-op, and to quarantine
# a wedged digest). Appends each new report's stable basename to the seen-marker.
mark_new_seen() { local f; for f in "${new[@]}"; do basename "$f" .md; done >> "$SEEN"; }

# A content hash of the (sorted) new-report basename set — the key the
# consecutive-failure counter is bound to, so an UNCHANGED pending set increments
# the streak while any change (a new report arrives, or some clear) resets it.
new_list_sha() { local f; for f in "${new[@]}"; do basename "$f" .md; done | sort | git -C "$DIR" hash-object --stdin; }

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
  base="$(basename "$f" .md)"
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
  rm -f "$FAILCOUNT" "$TRANSIENT" "$digest"
  exit 0
fi

# Hand the digest to the inner agent. On success: advance the seen-marker and
# clear the failure streak. On failure: bound the retries (see the BOUNDED RETRY
# note at the top) so a permanently-wedged digest cannot re-run `claude -p` every
# cadence forever. We capture the handler's combined output so the escalation can
# carry the LAST FAILURE SIGNATURE without re-running it.
handler_out="$(mktemp "${TMPDIR:-/tmp}/garden-follow-up-handler.XXXXXX")"
handler_rc=0
"$GARDEN_FOLLOWUP_HANDLER" "$digest" >"$handler_out" 2>&1 || handler_rc=$?
if [ "$handler_rc" -eq 0 ]; then
  mark_new_seen
  rm -f "$FAILCOUNT" "$TRANSIENT" "$digest" "$handler_out"
  exit 0
fi

cur_sha="$(new_list_sha)"

# Is this failure NOT ATTRIBUTABLE to the digest (see the WHAT THE BUDGET IS FOR
# note at the top)? Prints the cause and returns 0 when so. Ordered cheapest-first
# and by strength of evidence: the handler's own exit-code signal, then the
# host-wide storm brake, then the two output-derived fallbacks.
uncounted_cause() {
  if is_nonattributable_rc "$handler_rc"; then
    printf 'handler signalled a transient/environmental failure (rc=%s)\n' "$handler_rc"; return 0
  fi
  if fleet_brake_engaged; then
    printf 'the fleet brake is engaged (a host-wide transient-failure storm)\n'; return 0
  fi
  if is_transient_claude_signature "$(cat "$handler_out" 2>/dev/null || true)"; then
    printf 'handler output carries a transient `claude -p` signature (rc=%s)\n' "$handler_rc"; return 0
  fi
  if [ ! -s "$handler_out" ] && is_transient_empty_failure "$handler_rc"; then
    printf 'handler died with no output on a transient code (rc=%s)\n' "$handler_rc"; return 0
  fi
  return 1
}

if cause="$(uncounted_cause)"; then
  # NOT the digest's fault: leave BOTH markers untouched so the next tick retries
  # the same digest with the retry budget unspent, and bound the stretch by wall
  # clock so a permanently-broken host still reaches a human.
  now="$(date +%s 2>/dev/null || echo 0)"
  # A stretch is keyed by the pending set, exactly like the failure streak: any
  # change to it starts a fresh stretch (and re-arms the one-shot notice).
  since="$now"; notified=0
  prev_since=""; prev_t_sha=""; prev_notified=""
  if [ -f "$TRANSIENT" ]; then
    read -r prev_since prev_t_sha prev_notified _ < "$TRANSIENT" 2>/dev/null || true
    case "$prev_since" in ''|*[!0-9]*) prev_since="$now" ;; esac
    if [ "$prev_t_sha" = "$cur_sha" ]; then
      since="$prev_since"
      [ "$prev_notified" = 1 ] && notified=1
    fi
  fi
  elapsed=$(( now - since )); [ "$elapsed" -lt 0 ] && elapsed=0
  if [ "$notified" -eq 0 ] && [ "${GARDEN_FOLLOWUP_TRANSIENT_MAX_SECS:-0}" -gt 0 ] \
     && [ "$elapsed" -ge "$GARDEN_FOLLOWUP_TRANSIENT_MAX_SECS" ]; then
    {
      printf 'The garden-follow-up handler has failed for %sh on causes NOT attributable to the pending tada reports (latest: %s). Those follow-ups are being RETRIED, not quarantined — no retry budget has been spent — but this host has not recovered on its own, so it likely needs a human: check the agent CLI, connectivity, and quota/usage state on %s.\n\n' \
        "$(( elapsed / 3600 ))" "$cause" "${GARDEN:-this host}"
      printf '===== PENDING REPORTS (still un-actioned, NOT discarded) =====\n'
      for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}"; done
      printf '\n===== FOLLOW-UP DIGEST =====\n'
      cat "$digest"
      printf '\n===== LAST FAILURE SIGNATURE =====\n%s\n' "$(tail -c 800 "$handler_out" 2>/dev/null || true)"
    } | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="follow-up:stalled" "$GARDEN_ROOT/scripts/jobs/inbox-send.sh" maintainer >/dev/null 2>&1 \
      && notified=1 \
      || log "could not tell the maintainer about the ${elapsed}s not-attributable failure stretch (still retrying)"
  fi
  mkdir -p "$(dirname "$TRANSIENT")"
  printf '%s %s %s\n' "$since" "$cur_sha" "$notified" > "$TRANSIENT"
  rm -f "$digest" "$handler_out"
  log "follow-up handler failed but the cause is not attributable to the digest ($cause); retrying next tick, retry budget unspent (${elapsed}s into this stretch)"
  exit "${GARDEN_TRANSIENT_RC:-75}"
fi

# Attributable to the digest. Increment the streak iff the pending set is unchanged
# from the last failed tick; reset it to 1 otherwise. The counter is keyed by a
# hash of the new-report set so a genuinely transient window keeps retrying the
# same digest, but a digest that NEVER succeeds is bounded.
rm -f "$TRANSIENT"
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
  } | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="follow-up:quarantine" "$GARDEN_ROOT/scripts/jobs/inbox-send.sh" maintainer >/dev/null 2>&1 \
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
