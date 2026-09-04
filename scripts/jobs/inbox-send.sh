#!/bin/bash
# inbox-send.sh — CAS-post a message into a job doer's inbox (unread/).
#
# Usage: inbox-send.sh <doer> [<body-file>]
#   <doer> is the job basename whose doer you want to reach. The inbox exists
#   only while that doer is alive (created at claim, destroyed at completion).
#
# Parked-recipient staging: when the inbox dir is absent but a job named <doer> is
# still parked on the board (plan/ or todo/) — a queued/parked doer such as an
# orchestration supervisor that has not been claimed yet — the message is NOT
# dead-lettered. It is staged directly into inbox/<doer>/unread/, which claim-job.sh
# preserves (its inbox create is a non-clobbering mkdir -p + touch .gitkeep), so the
# doer drains it as a normal unread report the moment it claims. This lets a child
# report to a parked supervisor reliably instead of resorting to tada-only workarounds.
#
# Dead-mail fallback: a message sent to a recipient whose inbox is GONE — the doer
# already completed and tore down (the race the maintainer named: a reply to a
# torn-down doer would otherwise be lost) AND it exists in no board category — is
# NOT dropped. It is deposited into the dead-mail queue (inbox/dead/<id>.md, carrying
# the intended recipient, sender, and body) so garden-deadmail
# (scripts/jobs/deadmail.sh) can promote the intent into a fresh job a gardener
# claims. Delivery to a LIVE inbox stays the fast path; dead-lettering is the
# fallback. Set GARDEN_NO_DEADLETTER=1 to restore the legacy hard failure (used
# where a caller genuinely wants the send to error out).
#
# Posting is add-only; a rejected push just means re-sync and retry (backoff).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="inbox-send"

usage() {
  cat <<'EOF'
inbox-send.sh — CAS-post a message into a job doer's inbox.

Usage: inbox-send.sh <doer> [<body-file>]
  <doer>       the job basename whose doer you want to reach (must not start
               with '-'). The inbox exists only while that doer is alive.
  <body-file>  optional; the message body. If omitted, read from stdin (or a
               '(empty message)' placeholder).

A message to a parked-but-unclaimed doer is staged into its inbox; a message to
a doer whose inbox is gone is dead-lettered for garden-deadmail to promote.
EOF
}

# Intercept help BEFORE consuming the positional, so a '--help'/'-h' typo cannot
# be treated as a doer name and dead-lettered into a spurious job (the misfire
# that manufactured deadmail job deadmail-20260822T072116Z-cf8821). Mirrors the
# same guard in post-job.sh and journal-entry.sh.
case "${1:-}" in -h|--help) usage; exit 0;; esac

doer="${1:?usage: inbox-send.sh <doer> [body-file]}"
body_src="${2:-}"
case "$doer" in
  -*)        die "illegal doer '$doer' (names must not start with '-'; run --help for usage)";;
  */*|.*|'') die "illegal doer '$doer'";;
esac

# Body source guard: a non-empty $2 that is not a readable file is almost always
# a mistake (an inline body STRING passed where a body-FILE path is expected —
# e.g. block-job.sh handing an inline reason through). Without this, the body
# read falls through to `cat` on stdin — and with a non-tty stdin (every
# background / `claude -p` / systemd context) that blocks forever, wedging the
# shared producer lock (garden-harden-producer-body-read-hang). Fail fast,
# mirroring post-job.sh and journal-entry.sh.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave \$2 empty for '(empty message)')"
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(empty message)"; fi

# Forbid partially-qualified issue/PR references in an AUTHOR-written body: a bare
# `#N` never enters the bus, so rendering it downstream is unambiguous everywhere
# (see skills/message-bus/SKILL.md, check-issue-refs.sh). Machine/relay callers
# that post generated or forwarded bodies set GARDEN_SKIP_REF_CHECK=1 to bypass.
if [ "${GARDEN_SKIP_REF_CHECK:-0}" != "1" ]; then
  printf '%s\n' "$BODY" | "$HERE/check-issue-refs.sh" - \
    || die "message not posted — fully-qualify the issue/PR reference(s) reported above, then retry"
fi

# Message id: a caller can supply a DETERMINISTIC id via GARDEN_MSG_ID so a
# re-send of the SAME logical message (a re-polled GitHub comment, a coldstart or
# reset-cursor replay) maps to the SAME live-inbox and dead-letter path, making
# delivery idempotent: a live re-send finds its file already present and skips,
# and a dead-letter re-send rewrites an identical path that garden-deadmail
# promotes to a basename-idempotent job. When GARDEN_MSG_ID is unset we fall back
# to the legacy random id, so every send is a distinct message (the historical
# behavior). A caller-supplied id is sanitized to the filesystem/ref-safe charset
# (matching post-job.sh / deadmail.sh) so it can never escape the inbox directory.
if [ -n "${GARDEN_MSG_ID:-}" ]; then
  msgid="$(printf '%s' "$GARDEN_MSG_ID" | tr -c 'A-Za-z0-9._-' '-')"
  case "$msgid" in -*|'') die "illegal GARDEN_MSG_ID '$GARDEN_MSG_ID'";; esac
else
  msgid="$(date -u +%Y%m%dT%H%M%SZ)-$(od -An -N3 -tx1 /dev/urandom | tr -d ' \n')"
fi

# --- coalescing mode (audit rec 9): amend-while-unread for autonomous callers ---
#
# The default live-delivery path idempotent-SKIPS a re-send of the same stable id
# (the GitHub-comment re-poll case: the SAME logical event must not double-deliver
# and must not bump a count). GARDEN_MSG_COALESCE=1 opts a caller into the OTHER
# discipline instead — the one watchdog-notice.sh/doom-notice.sh already prove: a
# re-send of the same (sender, episode) key is a NEW occurrence of ONE condition,
# so it AMENDS the open unread entry in place (bumps notice_count, preserves
# first_seen, refreshes last_seen and the body) rather than accumulating a new file
# per call. This removes the duplicate mass the 2026-07-28 incidents made dominant
# on the raw inbox path (message-user / orchestrate / gauntlet / follow-up), while
# NEVER dropping a message (the count keeps the true occurrence total).
#
# The episode key is the caller-supplied GARDEN_MSG_ID: distinct messages from the
# same sender carry distinct ids (key on (sender, episode), not sender alone), so
# genuinely different notices still get their own entry.
COALESCE="${GARDEN_MSG_COALESCE:-0}"
if [ "$COALESCE" = 1 ] && [ -z "${GARDEN_MSG_ID:-}" ]; then
  die "GARDEN_MSG_COALESCE=1 requires a stable GARDEN_MSG_ID (the (sender,episode) amend key)"
fi

# compose_msg <count> <first_seen> — emit the full coalescing message file. Mirrors
# inbox-send's own header shape (from_host/from/reply_to/blocked_on/sent_at, all
# position-independent for the sed-based readers) plus the keyed coalescing fields
# (msg_key/notice_count/first_seen/last_seen) doom-notice.sh/watchdog-notice.sh use
# to recognize and amend the entry. A count>1 leads the body with a one-line "this
# is ONE coalesced entry" banner so the maintainer reads occurrences, not copies.
compose_msg() {  # compose_msg <count> <first_seen>
  local n="$1" first="$2" cnow
  cnow="$(date -u +%FT%TZ)"
  printf 'from_host: %s\n' "$GARDEN"
  printf 'from: %s\n'      "${GARDEN_SENDER:-$GARDEN_TAG}"
  [ -n "${GARDEN_REPLY_TO:-}" ] && printf 'reply_to: %s\n' "$GARDEN_REPLY_TO"
  [ -n "${GARDEN_BLOCKED_ON:-}" ] && printf 'blocked_on: %s\n' "$GARDEN_BLOCKED_ON"
  printf 'msg_key: %s\n'      "$msgid"
  printf 'notice_count: %s\n' "$n"
  printf 'first_seen: %s\n'   "$first"
  printf 'last_seen: %s\n'    "$cnow"
  printf 'sent_at: %s\n---\n' "$cnow"
  if [ "$n" -gt 1 ]; then
    printf 'COALESCED message — occurrence #%s (first seen %s, latest %s).\n' "$n" "$first" "$cnow"
    printf 'The SAME message (episode key `%s`) has now been sent %s times; this is\n' "$msgid" "$n"
    printf 'ONE entry that updates in place, not %s messages. Latest detail:\n\n' "$n"
  fi
  printf '%s\n' "$BODY"
}

# Occurrence counting + 1 h per-key delivery throttle (host-local state, exactly the
# split alert_maintainer uses): every invocation counts, but at most one push per
# window per key — a re-send inside the window folds its occurrence into the local
# count and skips the push (the open entry already carries the condition; its count
# catches up on the next past-window amend). Computed ONCE, before the retry loop.
co_suppress=0; co_count=1; co_first=""; co_now=0
co_last_f=""; co_count_f=""; co_first_f=""
if [ "$COALESCE" = 1 ]; then
  co_dir="$GARDEN_STATE/msg-coalesce"
  co_key="$(printf '%s.%s' "$doer" "$msgid" | tr -c 'A-Za-z0-9._-' '-')"
  co_last_f="$co_dir/$co_key.last"; co_count_f="$co_dir/$co_key.count"; co_first_f="$co_dir/$co_key.first"
  co_now="$(date +%s 2>/dev/null || echo 0)"
  mkdir -p "$co_dir" 2>/dev/null || true
  co_count="$(cat "$co_count_f" 2>/dev/null || echo 0)"; [[ "$co_count" =~ ^[0-9]+$ ]] || co_count=0
  co_count=$(( co_count + 1 )); printf '%s\n' "$co_count" > "$co_count_f" 2>/dev/null || true
  [ -s "$co_first_f" ] || date -u +%FT%TZ > "$co_first_f" 2>/dev/null || true
  co_first="$(cat "$co_first_f" 2>/dev/null || true)"
  if [ -f "$co_last_f" ]; then
    co_last="$(cat "$co_last_f" 2>/dev/null || echo 0)"; [[ "$co_last" =~ ^[0-9]+$ ]] || co_last=0
    [ $(( co_now - co_last )) -lt "${GARDEN_MSG_COALESCE_THROTTLE_SECS:-3600}" ] && co_suppress=1
  fi
fi

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  if [ ! -d "$DIR/inbox/$doer" ]; then
    # The recipient's inbox is absent. Distinguish two cases before dead-lettering:
    #
    #   (a) PARKED-BUT-UNCLAIMED: a job named <doer> is still sitting in plan/ or
    #       todo/ (e.g. a parked orchestration supervisor) — the doer has NOT run
    #       yet, so its inbox simply doesn't exist. This is NOT the completed-doer
    #       race. Pre-create inbox/<doer>/unread/ and deposit the message there
    #       idempotently. claim-job.sh creates the inbox with a non-clobbering
    #       `mkdir -p` + `touch .gitkeep`, so the staged message survives the claim
    #       and the doer drains it as a normal unread report at claim time. This
    #       moves the hand-carried "no-inbox-send-to-parked-supervisor" discipline
    #       off the sending agent and into the delivery primitive: a child can report
    #       to a parked supervisor reliably instead of the report being dead-lettered
    #       and mis-promoted into an orphan job with no supervisor to act on it.
    #
    #   (b) GONE/COMPLETED: <doer> exists in NO board category — the doer completed
    #       and tore down (the race the maintainer named), or never existed. Fall
    #       through to the dead-letter path below, preserving today's behavior.
    if [ -e "$DIR/$JOBS_PLAN/$doer.md" ] || [ -e "$DIR/$JOBS_TODO/$doer.md" ]; then
      # Idempotent stage to a parked doer's inbox: with a deterministic
      # GARDEN_MSG_ID, a re-send must not double-deposit. If the message is already
      # staged (still unread, or already moved to read/ once the doer claimed and
      # drained it) the send is a no-op success.
      if [ -e "$DIR/inbox/$doer/unread/$msgid.md" ] || [ -e "$DIR/inbox/$doer/read/$msgid.md" ]; then
        log "message $msgid already staged for parked inbox/$doer (idempotent skip)"; exit 0
      fi
      mkdir -p "$DIR/inbox/$doer/unread"
      {
        printf 'from_host: %s\n' "$GARDEN"
        printf 'from: %s\n'      "${GARDEN_SENDER:-$GARDEN_TAG}"
        [ -n "${GARDEN_REPLY_TO:-}" ] && printf 'reply_to: %s\n' "$GARDEN_REPLY_TO"
        [ -n "${GARDEN_BLOCKED_ON:-}" ] && printf 'blocked_on: %s\n' "$GARDEN_BLOCKED_ON"
        printf 'sent_at: %s\n---\n' "$(date -u +%FT%TZ)"
        printf '%s\n' "$BODY"
      } > "$DIR/inbox/$doer/unread/$msgid.md"
      git -C "$DIR" add "inbox/$doer/unread/$msgid.md"
      if commit_and_push "$DIR" "inbox($doer) ← $msgid from $GARDEN (staged to parked doer)"; then
        log "staged $msgid to parked inbox/$doer (drained when the doer claims)"; exit 0
      fi
      log "stage to parked '$doer' lost a push race (attempt $attempt); retrying"
      backoff "$attempt"
      continue
    fi
    # The recipient's inbox is gone (the doer completed/tore down, or never
    # existed). Don't drop the message — dead-letter it for garden-deadmail to
    # promote into a job. Legacy hard-fail is opt-in via GARDEN_NO_DEADLETTER=1.
    if [ "${GARDEN_NO_DEADLETTER:-0}" = "1" ]; then
      die "no live inbox for doer '$doer' (not currently working a job)"
    fi
    # Idempotent dead-letter: with a deterministic GARDEN_MSG_ID a re-poll lands on
    # the same path. If it is still queued (garden-deadmail has not yet promoted and
    # retired it), skip the rewrite — the pending entry already carries the intent.
    # If it was already promoted and retired, the file is gone and we re-create it;
    # deadmail re-promotes to the basename-idempotent job deadmail-<msgid>, so no
    # duplicate job results either way.
    if [ -e "$DIR/inbox/dead/$msgid.md" ]; then
      log "dead-letter $msgid already queued for '$doer' (idempotent skip)"; exit 0
    fi
    mkdir -p "$DIR/inbox/dead"
    {
      printf 'to: %s\n'        "$doer"
      printf 'from_host: %s\n' "$GARDEN"
      printf 'from: %s\n'      "${GARDEN_SENDER:-$GARDEN_TAG}"
      [ -n "${GARDEN_REPLY_TO:-}" ] && printf 'reply_to: %s\n' "$GARDEN_REPLY_TO"
      [ -n "${GARDEN_BLOCKED_ON:-}" ] && printf 'blocked_on: %s\n' "$GARDEN_BLOCKED_ON"
      printf 'sent_at: %s\n'              "$(date -u +%FT%TZ)"
      printf 'dead_lettered_at: %s\n---\n' "$(date -u +%FT%TZ)"
      printf '%s\n' "$BODY"
    } > "$DIR/inbox/dead/$msgid.md"
    git -C "$DIR" add "inbox/dead/$msgid.md"
    if commit_and_push "$DIR" "deadmail($doer) ← $msgid from $GARDEN"; then
      log "recipient inbox '$doer' gone; dead-lettered $msgid for garden-deadmail to promote"
      exit 0
    fi
    log "dead-letter for '$doer' lost a push race (attempt $attempt); retrying"
    backoff "$attempt"
    continue
  fi
  # Coalescing live delivery (GARDEN_MSG_COALESCE=1): amend the open unread entry
  # for this (sender, episode) key rather than idempotent-skip or accumulate.
  if [ "$COALESCE" = 1 ]; then
    if [ -e "$DIR/inbox/$doer/unread/$msgid.md" ]; then
      # An open (unread) entry exists. A within-window re-send just folds its
      # occurrence (already counted) and does not re-push — the entry already
      # carries the condition; the count catches up on the next past-window amend.
      if [ "$co_suppress" = 1 ]; then
        log "coalesced $msgid into open inbox/$doer entry (throttled; occurrence folded)"; exit 0
      fi
      prev="$(sed -n 's/^notice_count: *//p' "$DIR/inbox/$doer/unread/$msgid.md" | head -1)"
      [ -n "${prev:-}" ] && [ "$prev" -eq "$prev" ] 2>/dev/null || prev=1
      pfirst="$(sed -n 's/^first_seen: *//p' "$DIR/inbox/$doer/unread/$msgid.md" | head -1)"
      [ -n "${pfirst:-}" ] || pfirst="$co_first"
      total=$(( prev + co_count ))
      compose_msg "$total" "$pfirst" > "$DIR/inbox/$doer/unread/$msgid.md"
      git -C "$DIR" add "inbox/$doer/unread/$msgid.md"
      if commit_and_push "$DIR" "inbox($doer) amend $msgid → #$total by $GARDEN"; then
        printf '0\n' > "$co_count_f" 2>/dev/null || true
        printf '%s\n' "$co_now" > "$co_last_f" 2>/dev/null || true
        log "amended inbox/$doer entry $msgid (occurrence #$total)"; exit 0
      fi
      log "coalesce amend to '$doer' lost a push race (attempt $attempt); retrying"
      backoff "$attempt"; continue
    fi
    # No open entry: either never posted, or the recipient already drained it to
    # read/. Start a FRESH episode entry (new first_seen) — a re-occurrence after
    # the recipient handled the prior one deserves a new entry, not a silent fold
    # into an archived one (the same archive rule as watchdog-notice/doom-notice).
    if [ -e "$DIR/inbox/$doer/read/$msgid.md" ]; then
      date -u +%FT%TZ > "$co_first_f" 2>/dev/null || true
      co_first="$(cat "$co_first_f" 2>/dev/null || true)"
    fi
    mkdir -p "$DIR/inbox/$doer/unread"
    compose_msg "$co_count" "$co_first" > "$DIR/inbox/$doer/unread/$msgid.md"
    git -C "$DIR" add "inbox/$doer/unread/$msgid.md"
    if commit_and_push "$DIR" "inbox($doer) ← $msgid from $GARDEN (coalescing)"; then
      printf '0\n' > "$co_count_f" 2>/dev/null || true
      printf '%s\n' "$co_now" > "$co_last_f" 2>/dev/null || true
      log "delivered coalescing entry to inbox/$doer ($msgid, count $co_count)"; exit 0
    fi
    log "coalesce post to '$doer' lost a push race (attempt $attempt); retrying"
    backoff "$attempt"; continue
  fi
  # Idempotent live delivery: with a deterministic GARDEN_MSG_ID, a re-poll of the
  # same logical message while the doer is still alive must not double-deliver. If
  # the message is already in the doer's inbox (still unread, or already moved to
  # read/ by the doer's drain) the send is a no-op success.
  if [ -e "$DIR/inbox/$doer/unread/$msgid.md" ] || [ -e "$DIR/inbox/$doer/read/$msgid.md" ]; then
    log "message $msgid already in inbox/$doer (idempotent skip)"; exit 0
  fi
  mkdir -p "$DIR/inbox/$doer/unread"
  {
    printf 'from_host: %s\n' "$GARDEN"
    printf 'from: %s\n'      "${GARDEN_SENDER:-$GARDEN_TAG}"
    [ -n "${GARDEN_REPLY_TO:-}" ] && printf 'reply_to: %s\n' "$GARDEN_REPLY_TO"
    [ -n "${GARDEN_BLOCKED_ON:-}" ] && printf 'blocked_on: %s\n' "$GARDEN_BLOCKED_ON"
    printf 'sent_at: %s\n---\n' "$(date -u +%FT%TZ)"
    printf '%s\n' "$BODY"
  } > "$DIR/inbox/$doer/unread/$msgid.md"
  git -C "$DIR" add "inbox/$doer/unread/$msgid.md"
  if commit_and_push "$DIR" "inbox($doer) ← $msgid from $GARDEN"; then
    log "delivered to inbox/$doer ($msgid)"; exit 0
  fi
  log "inbox-send to '$doer' lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not deliver to inbox/$doer after retries"
