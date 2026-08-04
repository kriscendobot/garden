#!/bin/bash
# annotate-plan.sh — producer primitive: ANNOTATE a job already parked in the
# board's plan/ category (append a note, and/or adjust its selection metadata).
#
# post-plan.sh is IDEMPOTENT-ONLY: a second post of the same basename is a no-op
# success, by design (a re-run producer must never fork a parked item). That
# leaves no sanctioned way to say "this parked job just learned something new" —
# a follow-up review comment, a narrowed scope, a priority bump — so producers
# hand-rolled their own sync -> edit -> commit -> push CAS loop against the shared
# producer clone. This is that loop, once, correctly.
#
# Usage:
#   annotate-plan.sh [--note TEXT] [--key KEY] [--priority LEVEL] [--roadmap ITEM]
#                    [--role ROLE] [--by ROLE] [--if-parked] <basename> [body-file]
#
#   --note TEXT       the annotation text, inline. Mutually exclusive with
#                     [body-file]; with neither, the note is read from stdin
#                     (empty stdin is fine when a metadata flag is given).
#   --key KEY         the annotation's dedup identity. Re-annotating with a key
#                     already present in the file is a NO-OP SUCCESS, so a
#                     re-run/requeued producer never double-appends. Default: a
#                     content hash of the note + metadata changes, which makes an
#                     identical re-annotation idempotent for free. Pass an
#                     explicit key when you deliberately want the SAME text
#                     appended again under a new identity, or when you want a
#                     stable identity (a comment id) across reworded text.
#   --priority LEVEL  update the `priority:` field (urgent|high|normal|low).
#   --roadmap ITEM    update the `roadmap:` field.
#   --role ROLE       update the `role:` field (the role a gardener wears).
#   --by ROLE         provenance stamped on the annotation (default:
#                     $GARDEN_SENDER or "producer").
#   --if-parked       if <basename> has already LEFT plan/ (promoted, claimed, or
#                     completed), exit 0 quietly instead of failing. For a
#                     producer that races the foreman and would rather skip the
#                     annotation than fail its job.
#   <basename>        the parked job's spine (extensionless).
#   [body-file]       a file holding the annotation text.
#
# The note is producer-supplied text appended VERBATIM to a body that is PARKED,
# so it is first stripped of the reaper/gardener cycle markers (common.sh § the
# cycle-marker family). post-plan.sh strips those on the way INTO plan/ and
# promote-plan.sh on the way OUT, so that a stale `<!-- garden-deadline-overrun:
# N -->` can never re-doom a job on its first evaluation after promotion — but
# an annotation is a THIRD way into a parked body, and a producer piping a live
# job body as a note ("here is what the last cycle reported") re-introduces the
# whole family behind both of those strips. promote-plan.sh's strip would still
# clear it at the exit, but a parked body carrying counters the job never earned
# is wrong before then and in its own right: it is what every reader of plan/
# sees, it makes the promoter's `cleared=` provenance report a reset that never
# happened, and any OTHER path that copies a parked body back into a live cycle
# carries the counter to a reaper that trusts it. So all three writers into plan/
# sanitize, using the same helpers — a marker-format change, or a sixth marker,
# lands in one place and cannot half-apply.
#
# Deliberately NOT settable here: `gate:`, `blocked_on:`, `orchestrated_by:`.
# Those carry the board's promotion invariants (who may promote this job, and
# when), and re-gating a parked job is a different act with its own primitives —
# promote-plan.sh to release a gate, block-job.sh to establish a blocked edge,
# post-orchestration.sh to own a child. An annotation only ever adds information
# and re-tunes the deferred-selection keys.
#
# Exit codes: 0 annotated (or a deduped/skipped no-op), 1 usage/illegal input,
# 3 the job is not parked in plan/ (without --if-parked).
#
# The write is one sync -> read -> rewrite -> commit -> push CAS attempt, retried
# with backoff on a lost race exactly like post-plan.sh/promote-plan.sh: it
# touches only its own basename, so a rejected push re-syncs against the new tip
# (re-running the dedup check, so a peer's identical annotation still wins once)
# and re-applies.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="annotate-plan"

# die with a caller-chosen exit code, so "not parked" (3) is distinguishable from
# "bad usage" (1) by a script that branches on it.
die_rc() { local rc="$1"; shift; log "FATAL: $*"; exit "$rc"; }

usage() {
  cat <<'EOF'
annotate-plan.sh — annotate a job already parked in plan/ (append a note and/or
retune its selection metadata).

Usage:
  annotate-plan.sh [--note TEXT] [--key KEY] [--priority LEVEL] [--roadmap ITEM]
                   [--role ROLE] [--by ROLE] [--if-parked] <basename> [body-file]

  --note TEXT       annotation text inline (else [body-file], else stdin).
  --key KEY         dedup identity; a key already present is a no-op success.
                    Default: a content hash of the note + metadata changes.
  --priority LEVEL  update priority: urgent|high|normal|low.
  --roadmap ITEM    update roadmap:.
  --role ROLE       update role:.
  --by ROLE         provenance (default: $GARDEN_SENDER or "producer").
  --if-parked       exit 0 quietly if <basename> already left plan/.
  <basename>        the parked job's spine; must not start with '-'.
  [body-file]       a file holding the annotation text.

Gate fields (gate:/blocked_on:/orchestrated_by:) are NOT settable here; use
promote-plan.sh / block-job.sh / post-orchestration.sh.
EOF
}

note_opt=""
have_note_opt=0
key=""
priority=""
roadmap=""
role=""
by="${GARDEN_SENDER:-producer}"
if_parked=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)   usage; exit 0;;
    --note)      note_opt="${2?--note needs a value}"; have_note_opt=1; shift 2;;
    --key)       key="${2:?--key needs a value}"; shift 2;;
    --priority)  priority="${2:?--priority needs a value}"; shift 2;;
    --roadmap)   roadmap="${2:?--roadmap needs a value}"; shift 2;;
    --role)      role="${2:?--role needs a value}"; shift 2;;
    --by)        by="${2:?--by needs a value}"; shift 2;;
    --if-parked) if_parked=1; shift;;
    --)          shift; break;;
    -*)          die "unknown option: '$1' (run --help for usage)";;
    *)           break;;
  esac
done

base="${1:?usage: annotate-plan.sh [--note TEXT] [--key K] [--priority L] [--roadmap I] [--role R] [--by R] [--if-parked] <basename> [body-file]}"
body_src="${2:-}"

case "$base" in
  -*)        die "illegal basename: '$base' (names must not start with '-')";;
  */*|.*|'') die "illegal basename: '$base'";;
esac
base="${base%.md}"

# The key is a marker-comment token and a grep needle; keep it boring so it can
# never break the marker it lives in.
case "$key" in
  *[!A-Za-z0-9._:@#/-]*) die "illegal --key '$key' (use [A-Za-z0-9._:@#/-] only)";;
esac
if [ -n "$priority" ]; then
  case "$priority" in
    urgent|high|normal|low) :;;
    *) die "illegal --priority '$priority' (urgent|high|normal|low)";;
  esac
fi

# Body source guard, mirroring post-plan.sh: a non-empty body arg that is not a
# readable file is almost always an inline body STRING passed where a body-FILE
# path is expected, and falling through to `cat` on a non-tty stdin would block
# forever holding the shared producer lock (garden-harden-producer-body-read-hang).
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, use --note TEXT for an inline note, or feed the note on stdin)"
fi
if [ "$have_note_opt" = 1 ] && [ -n "$body_src" ]; then
  die "--note and a body-file are mutually exclusive (give the annotation once)"
fi

# The note: --note, else the body file, else stdin (only when stdin is not a
# tty — an interactive caller with no note is annotating metadata only).
if   [ "$have_note_opt" = 1 ]; then note="$note_opt"
elif [ -n "$body_src" ];       then note="$(cat "$body_src")"
elif [ ! -t 0 ];               then note="$(cat)"
else note=""
fi

# Strip the cycle markers from the note before anything else sees it (see the
# header). The summary helper reads a FILE — it reuses the same reap_count/
# deadline_overrun_count/has_*_hint accessors the reaper, post-plan.sh and
# promote-plan.sh use — so the note lands in a throwaway temp file first. Both it
# and the strip come from common.sh, never re-spelled here. Done BEFORE the
# default dedup key is computed, so the key content-addresses what actually lands
# and two notes differing only in stale markers collapse to one annotation.
note_cleared=none
if [ -n "$note" ]; then
  NOTE_TMP="$(mktemp "${TMPDIR:-/tmp}/garden-annotate-note.XXXXXX")"
  trap 'rm -f "$NOTE_TMP"' EXIT
  printf '%s\n' "$note" > "$NOTE_TMP"
  note_cleared="$(cycle_marker_summary "$NOTE_TMP")"
  if [ "$note_cleared" != "none" ]; then
    note="$(strip_cycle_markers < "$NOTE_TMP")"
    log "cleared stale cycle markers from the annotation note for '$base': $note_cleared"
  fi
  rm -f "$NOTE_TMP"; trap - EXIT
fi

# The metadata updates, as a newline-separated key=value list preserving the
# frontmatter's own field order.
fields=""
if [ -n "$priority" ]; then fields+="priority=$priority"$'\n'; fi
if [ -n "$roadmap" ];  then fields+="roadmap=$roadmap"$'\n';   fi
if [ -n "$role" ];     then fields+="role=$role"$'\n';         fi

if [ -z "$note" ] && [ -z "$fields" ]; then
  if [ "$note_cleared" != "none" ]; then
    die "the annotation note was entirely cycle markers ($note_cleared), which are stripped so they cannot re-doom the parked job; nothing left to annotate"
  fi
  die "nothing to annotate: give a note (--note TEXT, a body-file, or stdin) and/or a --priority/--roadmap/--role change"
fi

# A one-line summary of the metadata change, for the marker and the commit message.
fields_summary="$(printf '%s' "$fields" | tr '\n' ' ' | sed 's/ *$//')"

# The provenance token for a sanitized note — empty (so an ordinary annotation's
# marker is byte-for-byte what it always was) unless the strip cleared something.
cleared_token=""
if [ "$note_cleared" != none ]; then cleared_token=" cleared=$note_cleared"; fi

# Default dedup identity: the content address of what this annotation SAYS. Two
# identical annotations therefore collapse (the idempotency a re-run producer
# needs) while a genuinely new note appends.
if [ -z "$key" ]; then
  key="$(printf '%s\n--\n%s\n' "$note" "$fields" | (sha1sum 2>/dev/null || shasum) | cut -c1-12)"
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

# Apply the field updates to the file's LEADING frontmatter block: an existing
# key is replaced in place (order preserved), a missing one is appended just
# before the closing '---'. Every other line — including keys this script does
# not know about (model:, handler-timeout:, requires:) — passes through
# untouched, so an annotation can never silently drop a job's execution keys the
# way a blind frontmatter rewrite would.
apply_fields() {  # apply_fields <src-file>  -> stdout
  awk -v kv="$fields" '
    BEGIN {
      n = split(kv, pairs, "\n")
      for (i = 1; i <= n; i++) {
        if (pairs[i] == "") continue
        p = index(pairs[i], "=")
        k = substr(pairs[i], 1, p - 1)
        val[k] = substr(pairs[i], p + 1)
        order[++m] = k
      }
    }
    NR == 1 && $0 == "---" { infm = 1; print; next }
    infm && $0 == "---" {
      for (i = 1; i <= m; i++) { k = order[i]; if (!(k in seen)) printf "%s: %s\n", k, val[k] }
      infm = 0; print; next
    }
    infm {
      p = index($0, ":")
      if (p > 0) {
        k = substr($0, 1, p - 1)
        if (k in val) { printf "%s: %s\n", k, val[k]; seen[k] = 1; next }
      }
      print; next
    }
    { print }
  ' "$1"
}

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"

  src="$DIR/$JOBS_PLAN/$base.md"
  if [ ! -e "$src" ]; then
    where=""
    for cat_dir in "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA"; do
      if [ -e "$DIR/$cat_dir/$base.md" ]; then where="$cat_dir"; break; fi
    done
    clone_unlock "$DIR"
    if [ -n "$where" ]; then
      if [ "$if_parked" = 1 ]; then
        log "job '$base' has left plan/ (now in $where); skipping annotation (--if-parked)"
        exit 0
      fi
      die_rc 3 "job '$base' is no longer parked (it is in $where); annotate applies only to plan/ jobs — re-post the information as a follow-up job, or re-run with --if-parked to skip"
    fi
    if [ "$if_parked" = 1 ]; then
      log "no job '$base' anywhere on the board; skipping annotation (--if-parked)"
      exit 0
    fi
    die_rc 3 "no plan job '$base' to annotate (not in plan/, todo/, doin/, or tada/)"
  fi

  # Dedup: this exact annotation identity already landed (a re-run, a requeue, or
  # a peer that won the race). Re-checked on every attempt, against the tip.
  if grep -qF "garden-annotation: key=$key " "$src"; then
    clone_unlock "$DIR"
    log "plan job '$base' already carries annotation key=$key; nothing to do"
    exit 0
  fi

  # Compose beside the file, then rename into place, so a crash mid-write can
  # never leave a half-written plan job staged for the commit below.
  tmp="$(mktemp "${TMPDIR:-/tmp}/annotate-plan.XXXXXX")"
  {
    # A legacy plan file with no frontmatter still gets its metadata updates:
    # synthesize the block rather than dropping the change on the floor.
    if [ -n "$fields" ] && [ "$(head -1 "$src")" != "---" ]; then
      printf -- '---\n'
      printf '%s\n' "$fields" | sed '/^$/d; s/=/: /'
      printf -- '---\n\n'
      cat "$src"
    else
      apply_fields "$src"
    fi
    # `cleared=` is appended only when the note actually carried cycle markers, so
    # an ordinary annotation's marker is byte-for-byte what it always was.
    printf '\n<!-- garden-annotation: key=%s by=%s at=%s%s%s -->\n' \
      "$key" "$by" "$(date -u +%FT%TZ)" \
      "${fields_summary:+ fields=$fields_summary}" "$cleared_token"
    if [ -n "$note" ]; then printf '\n%s\n' "$note"; fi
  } > "$tmp"
  chmod 644 "$tmp"          # mktemp is 0600; board files are world-readable
  mv "$tmp" "$src"
  git -C "$DIR" add "$JOBS_PLAN/$base.md"

  if commit_and_push "$DIR" "annotate($base) plan${fields_summary:+ [$fields_summary]} by $GARDEN"; then
    log "annotated plan job '$base' (key=$key${fields_summary:+ $fields_summary})"
    exit 0
  fi
  log "annotate of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not annotate '$base' after retries"
