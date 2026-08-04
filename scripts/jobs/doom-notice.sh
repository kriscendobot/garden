#!/bin/bash
# doom-notice.sh — the reaper's amend-or-post-KEYED maintainer notice for a
# doomed job. A sibling of inbox-send.sh, addressed to the maintainer inbox.
#
# Usage: doom-notice.sh <base> <signature> [body-file]
#   <base>        the doomed job's basename (the spine).
#   <signature>   a NORMALIZED failure signature for the doom event. The reaper
#                 uses `requeue-exhausted` (the handler failed every cycle) and
#                 `deadline-overrun` (the handler hit its own wall-clock budget
#                 every cycle). Any ref-safe token is accepted.
#   [body-file]   the human-readable notice body; if omitted, read from stdin.
#
# WHY THIS EXISTS (dedup, kriskowal 2026-07-02). A fleet restart can exhaust the
# requeue budget of dozens of jobs at once, and the old reaper posted ONE fresh
# maintainer message per doom event — 37 near-identical DOOM reports in one
# morning. This helper collapses that flood: it keeps a KEYED record of the open
# DOOM notice for a given job+condition and AMENDS it (bumps an occurrence count,
# refreshes the timestamp and the latest cycle counts) rather than posting a new
# message. A genuinely NEW message is posted only when the condition is
# SUBSTANTIALLY DIFFERENT.
#
# THE DEDUP KEY is `<base> + <signature>`:
#   - same base AND same signature  → AMEND the existing open notice.
#   - different base, OR same base with a DIFFERENT signature (a materially
#     different failure reason: requeue-exhausted vs deadline-overrun) → a NEW
#     notice (different key ⇒ different file).
# The key is realized as a DETERMINISTIC filename in the maintainer inbox
# (inbox/maintainer/unread/doomed-<base>-<signature>.md), so amend-or-post is a
# plain file-exists test: present-and-unread ⇒ amend; absent ⇒ post fresh.
#
# ARCHIVE INTERACTION. The notice is deduped only while it is still UNREAD. If the
# maintainer has archived it (maintainer-archive.sh moves unread/→read/, or removes
# it), the unread file is gone, so the next doom of the same job posts a FRESH
# notice — a re-occurrence after the maintainer already handled the prior one
# deserves to be seen again, not silently folded into an archived message.
#
# Provenance carried for the amend: `notice_count`, `first_seen`, `last_seen`, and
# the keyed `doom_signature`/`doom_base` live in the message frontmatter so a
# re-doom can find the file and bump the count deterministically. Posting is
# add-only / rewrite-in-place; a rejected push just re-syncs and retries (backoff),
# exactly like inbox-send.sh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="doom-notice"

base="${1:?usage: doom-notice.sh <base> <signature> [body-file]}"
signature="${2:?usage: doom-notice.sh <base> <signature> [body-file]}"
body_src="${3:-}"
case "$base" in */*|.*|'') die "illegal base '$base'";; esac

# Sanitize base + signature into a single ref/filesystem-safe key, matching the
# charset inbox-send.sh uses for a caller-supplied message id. Job basenames are
# already kebab-case and the signature is a fixed enum, so this is normally a
# no-op; the tr is a guard so the key can never escape the inbox directory.
key="$(printf 'doomed-%s-%s' "$base" "$signature" | tr -c 'A-Za-z0-9._-' '-')"
case "$key" in -*|'') die "illegal doom key derived from '$base'/'$signature'";; esac
REL="inbox/maintainer/unread/$key.md"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(no doom detail supplied)"; fi

now="$(date -u +%FT%TZ)"

# Compose the message file. On a fresh post first_seen==last_seen==now and
# notice_count==1; on an amend the caller passes the preserved first_seen and the
# bumped count. The keyed fields (doom_base/doom_signature) let a later amend
# recognize the file; maintainer-watch.sh cats the whole file, so the leading
# header lines mirror inbox-send.sh's shape and render cleanly.
compose() {  # compose <count> <first_seen>
  local count="$1" first_seen="$2"
  printf 'from_host: %s\n' "$GARDEN"
  printf 'from: %s\n'      "${GARDEN_SENDER:-reaper:$GARDEN}"
  printf 'sent_at: %s\n'   "$now"
  printf 'doom_base: %s\n'      "$base"
  printf 'doom_signature: %s\n' "$signature"
  printf 'notice_count: %s\n'     "$count"
  printf 'first_seen: %s\n'       "$first_seen"
  printf 'last_seen: %s\n'        "$now"
  printf -- '---\n'
  if [ "$count" -gt 1 ]; then
    printf 'DOOM notice — occurrence #%s (first seen %s, latest %s).\n' \
      "$count" "$first_seen" "$now"
    printf 'This job has been doom-parked %s times for the same condition (%s);\n' \
      "$count" "$signature"
    printf 'this is an AMENDED notice, not a new one. Latest detail:\n\n'
  fi
  printf '%s\n' "$BODY"
}

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  mkdir -p "$DIR/inbox/maintainer/unread"
  if [ -e "$DIR/$REL" ]; then
    # AMEND: an open (unread) notice for this exact job+condition already exists.
    # Bump its occurrence count, preserve first_seen, refresh last_seen, and
    # replace the body with the latest detail. No new message is posted.
    prev="$(sed -n 's/^notice_count: *//p' "$DIR/$REL" | head -1)"
    [ -n "${prev:-}" ] && [ "$prev" -eq "$prev" ] 2>/dev/null || prev=1
    first_seen="$(sed -n 's/^first_seen: *//p' "$DIR/$REL" | head -1)"
    [ -n "${first_seen:-}" ] || first_seen="$now"
    count=$(( prev + 1 ))
    compose "$count" "$first_seen" > "$DIR/$REL"
    git -C "$DIR" add "$REL"
    if commit_and_push "$DIR" "doom-notice($key) amended → #$count by $GARDEN"; then
      log "amended maintainer doom notice '$key' (occurrence #$count)"; exit 0
    fi
  else
    # POST a fresh notice: no open notice for this key (never posted, or the prior
    # one was archived by the maintainer).
    compose 1 "$now" > "$DIR/$REL"
    git -C "$DIR" add "$REL"
    if commit_and_push "$DIR" "doom-notice($key) posted by $GARDEN"; then
      log "posted fresh maintainer doom notice '$key'"; exit 0
    fi
  fi
  log "doom-notice '$key' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not deliver doom notice '$key' after retries"
