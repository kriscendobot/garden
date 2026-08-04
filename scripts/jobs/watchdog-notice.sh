#!/bin/bash
# watchdog-notice.sh — the COALESCING maintainer notice for a watchdog condition.
#
# Usage: watchdog-notice.sh [options] <key> [body-file]
#   <key>          a stable dedup key naming the CONDITION (unit + failure class),
#                  such as `triager-fetch-failed-kriscendobot-endo`, or `provider-quota`.
#                  Any string; sanitized into one ref/filesystem-safe token.
#   [body-file]    the human-readable notice body; if omitted, read from stdin.
#   --count N      fold N occurrences into this delivery (occurrences the caller
#                  observed while its own throttle window suppressed delivery).
#                  Default 1.
#   --first-seen T the ISO time of the FIRST occurrence in this episode. Used only
#                  when posting a fresh notice; an existing notice keeps its own.
#   --recovered    this is the CLOSING notice: the condition has cleared. Amends
#                  the open notice in place (so the maintainer reads one entry, now
#                  closed) or posts one short standalone recovery if it was already
#                  archived.
#
# WHY THIS EXISTS (dedup, 2026-07-28). Every `watchdog:*` maintainer message is
# written by common.sh's alert_maintainer, which THROTTLED per key but posted a
# FRESH message each time the window reopened. One environmental condition — the
# provider's weekly quota refusing every `claude -p` — therefore produced 94 unread
# maintainer messages in four days, burying a blocked build, two halted
# orchestrations, and an access request underneath it. 94 messages for one fact is
# a reporting defect, not 94 events.
#
# The garden already solved this shape once, in the reaper's doom notices
# (doom-notice.sh): keep ONE keyed message per open condition and AMEND it —
# bumping `notice_count`, preserving `first_seen`, refreshing `last_seen` — rather
# than appending a new one. This helper is that mechanism generalized to every
# watchdog path, and doom-notice.sh remains its job-scoped sibling (its key is
# job+signature; this one's key is the condition).
#
# THE DEDUP KEY is realized as a DETERMINISTIC filename in the maintainer inbox
# (inbox/maintainer/unread/watchdog-<key>.md), so amend-or-post is a plain
# file-exists test: present-and-unread ⇒ amend; absent ⇒ post fresh.
#
# ARCHIVE INTERACTION (same rule as doom-notice.sh). The notice is deduped only
# while it is still UNREAD. Once the maintainer (or the proxy's watchdog
# auto-clear) has archived it, the unread file is gone and the next occurrence
# posts a FRESH notice — a re-occurrence after the prior one was handled deserves
# to be seen again, not folded silently into an archived message.
#
# CROSS-HOST: the throttle/occurrence state that feeds --count is host-local, but
# the notice file is journal-shared, so two hosts observing the SAME condition
# amend the SAME entry and their counts add up. That is the intent for a
# fleet-level condition (`provider-quota`); a host-specific condition keys its host
# into the key.
#
# Posting is add-only / rewrite-in-place; a rejected push just re-syncs and retries
# under backoff, exactly like inbox-send.sh and doom-notice.sh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="${GARDEN_TAG:-watchdog-notice}"

count=1
first_seen=""
recovered=0
while [ $# -gt 0 ]; do
  case "$1" in
    --count)      count="${2:-1}"; shift 2;;
    --first-seen) first_seen="${2:-}"; shift 2;;
    --recovered)  recovered=1; shift;;
    --) shift; break;;
    -*) die "unknown option '$1'";;
    *) break;;
  esac
done

key="${1:?usage: watchdog-notice.sh [--count N] [--first-seen T] [--recovered] <key> [body-file]}"
body_src="${2:-}"
[[ "$count" =~ ^[0-9]+$ ]] || count=1
[ "$count" -lt 1 ] && count=1

# Sanitize into a single ref/filesystem-safe token, matching the charset
# doom-notice.sh uses. A watchdog key is normally already kebab-case (it carries
# a unit name or a repo slug), so this is usually a no-op; the tr is the guard that
# keeps the key from escaping the inbox directory.
skey="$(printf 'watchdog-%s' "$key" | tr -c 'A-Za-z0-9._-' '-')"
case "$skey" in -*|'') die "illegal watchdog key derived from '$key'";; esac
REL="inbox/maintainer/unread/$skey.md"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(no watchdog detail supplied)"; fi

now="$(date -u +%FT%TZ)"
[ -n "$first_seen" ] || first_seen="$now"

# Compose the message file. On a fresh post notice_count is the folded count (1
# unless the caller suppressed occurrences before this delivery); on an amend the
# caller's count is ADDED to the count already on record. The keyed field
# (watchdog_key) lets a later amend recognize the file; maintainer-watch.sh cats
# the whole file, so the header mirrors inbox-send.sh's shape and renders cleanly.
compose() {  # compose <count> <first_seen>
  local n="$1" first="$2"
  printf 'from_host: %s\n' "$GARDEN"
  printf 'from: %s\n'      "${GARDEN_SENDER:-watchdog:${GARDEN_TAG}}"
  printf 'sent_at: %s\n'   "$now"
  printf 'watchdog_key: %s\n' "$key"
  printf 'notice_count: %s\n' "$n"
  printf 'first_seen: %s\n'   "$first"
  printf 'last_seen: %s\n'    "$now"
  [ "$recovered" -eq 1 ] && printf 'recovered: true\n'
  printf -- '---\n'
  if [ "$recovered" -eq 1 ]; then
    printf 'RECOVERED — the watchdog condition `%s` has CLEARED (first seen %s, cleared %s).\n' \
      "$key" "$first" "$now"
    printf 'It was observed %s time(s) while open. Nothing further is required;\n' "$n"
    printf 'this notice closes the loop so the end of the condition is on the record.\n\n'
  elif [ "$n" -gt 1 ]; then
    printf 'WATCHDOG notice — occurrence #%s (first seen %s, latest %s).\n' "$n" "$first" "$now"
    printf 'The SAME condition (`%s`) has now been observed %s times; this is ONE\n' "$key" "$n"
    printf 'coalesced notice that updates in place, not %s messages. Latest detail:\n\n' "$n"
  fi
  printf '%s\n' "$BODY"
}

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  mkdir -p "$DIR/inbox/maintainer/unread"
  if [ -e "$DIR/$REL" ]; then
    # AMEND: an open (unread) notice for this exact condition already exists. Add
    # this delivery's occurrences to its count, preserve first_seen, refresh
    # last_seen, and replace the body with the latest detail. No new message.
    prev="$(sed -n 's/^notice_count: *//p' "$DIR/$REL" | head -1)"
    [ -n "${prev:-}" ] && [ "$prev" -eq "$prev" ] 2>/dev/null || prev=1
    prior_first="$(sed -n 's/^first_seen: *//p' "$DIR/$REL" | head -1)"
    [ -n "${prior_first:-}" ] || prior_first="$first_seen"
    if [ "$recovered" -eq 1 ]; then
      # A recovery reports the episode, it does not add an occurrence to it. The
      # count already on the entry is authoritative (it is the cross-host total);
      # the caller's --count is only used when the open entry is gone.
      total="$prev"
      [ "$count" -gt "$total" ] && total="$count"
    else
      total=$(( prev + count ))
    fi
    compose "$total" "$prior_first" > "$DIR/$REL"
    git -C "$DIR" add "$REL"
    if commit_and_push "$DIR" "watchdog-notice($skey) amended → #$total by $GARDEN"; then
      log "amended maintainer watchdog notice '$skey' (occurrence #$total)"; exit 0
    fi
  else
    if [ "$recovered" -eq 1 ] && [ "${GARDEN_WATCHDOG_RECOVERY_IF_OPEN_ONLY:-0}" = 1 ]; then
      # The open notice was already archived and the caller only wants to close an
      # entry that is still on the maintainer's desk: nothing to say.
      log "watchdog recovery for '$skey': no open notice (already archived); staying quiet"; exit 0
    fi
    compose "$count" "$first_seen" > "$DIR/$REL"
    git -C "$DIR" add "$REL"
    if commit_and_push "$DIR" "watchdog-notice($skey) posted by $GARDEN"; then
      log "posted fresh maintainer watchdog notice '$skey' (count $count)"; exit 0
    fi
  fi
  log "watchdog-notice '$skey' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not deliver watchdog notice '$skey' after retries"
