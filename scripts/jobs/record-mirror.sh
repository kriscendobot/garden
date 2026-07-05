#!/bin/bash
# record-mirror.sh — record the upstream-PR ↔ our-mirror-PR mapping on the journal.
#
# Usage: record-mirror.sh <upstream-ref> <mirror-ref> [<how-note>]
#   <upstream-ref>  the UPSTREAM governance PR, as  <owner>/<repo>#<N>
#                   (e.g. endojs/endo#3294)
#   <mirror-ref>    OUR mirror / garden-side PR, as <owner>/<repo>#<M>
#                   (e.g. endojs/endo-but-for-bots#387)
#   <how-note>      optional free text recording how the mirror was created
#                   (e.g. "ferry (pr-handoff Shape 1)").
#
# This is the producer the mirror-creation point calls at the one moment BOTH the
# upstream PR and our mirror PR are known — the boatman's ferry cross-link step
# (roles/boatman/AGENT.md, skills/pr-handoff step 8) and the cross-fork-block →
# endo-but-for-bots mirror path. The mapping it writes is the ONLY data the
# garden-mirror-closer service consults; without it the service can do nothing,
# which is why recording it is reinforced at creation time, not left to a sweep.
#
# Schema — one file per upstream PR, line-based `key: value` (same flavour as the
# journal cursors and maintainer messages):
#
#     journal2:pr-mirrors/<up-owner>-<up-repo>-<N>.md
#     ----------------------------------------------------------------
#     upstream: <owner>/<repo>#<N>          # the upstream governance PR
#     mirror: <owner>/<repo>#<M>            # our mirror / garden-side PR
#     created_at: <iso-8601>                # when the mapping was recorded
#     created_by: <host>                    # the host that recorded it
#     how: <free text>                      # how the mirror was created
#     # appended by mirror-closer.sh once the upstream closes and the mirror is
#     # closed to follow (its durable per-mapping cursor — see that script):
#     # closed_at: <iso>
#     # upstream_outcome: merged | closed
#
# Idempotent: re-recording the same upstream→mirror pair is a no-op success (a
# re-ferry of the same PR pair must not churn the mapping or clobber a closed_at
# the closer may already have written).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="record-mirror"

up_ref="${1:?usage: record-mirror.sh <upstream owner/repo#N> <mirror owner/repo#M> [how]}"
mir_ref="${2:?usage: record-mirror.sh <upstream owner/repo#N> <mirror owner/repo#M> [how]}"
how="${3:-mirror created}"

# Validate both refs are <owner>/<repo>#<number>. A malformed ref must fail LOUD,
# never write a garbage mapping the closer would later read.
ref_re='^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+#[0-9]+$'
[[ "$up_ref"  =~ $ref_re ]] || die "upstream ref '$up_ref' is not <owner>/<repo>#<N>"
[[ "$mir_ref" =~ $ref_re ]] || die "mirror ref '$mir_ref' is not <owner>/<repo>#<M>"

up_repo="${up_ref%%#*}"; up_num="${up_ref##*#}"
up_owner="${up_repo%%/*}"; up_name="${up_repo#*/}"
key="pr-mirrors/${up_owner}-${up_name}-${up_num}.md"

DIR="${GARDEN_MIRROR_CLONE:-$GARDEN_STATE/mirror-closer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  if [ -e "$DIR/$key" ]; then
    # Already recorded. If the mirror matches, it is a true no-op (re-ferry of the
    # same pair). If it names a DIFFERENT mirror, that is a real conflict the
    # human must see — never silently overwrite.
    existing_mirror="$(sed -n 's/^mirror:[[:space:]]*//p' "$DIR/$key" | head -1)"
    if [ "$existing_mirror" = "$mir_ref" ]; then
      log "mapping $key already records $up_ref → $mir_ref; nothing to do"
      clone_unlock "$DIR"; exit 0
    fi
    clone_unlock "$DIR"
    die "mapping $key already exists for a DIFFERENT mirror ($existing_mirror, not $mir_ref) — refusing to overwrite; resolve by hand"
  fi
  mkdir -p "$(dirname "$DIR/$key")"
  {
    printf 'upstream: %s\n' "$up_ref"
    printf 'mirror: %s\n'   "$mir_ref"
    printf 'created_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'created_by: %s\n' "$GARDEN"
    printf 'how: %s\n' "$how"
  } > "$DIR/$key"
  git -C "$DIR" add "$key"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  rc=0; commit_and_push "$DIR" "pr-mirror($up_ref → $mir_ref) recorded on $GARDEN" || rc=$?
  if [ "$rc" -eq 0 ]; then
    log "recorded mapping $key ($up_ref → $mir_ref)"
    exit 0
  fi
  [ "$rc" -eq 2 ] && exit 0   # nothing to commit (a peer wrote the same)
  log "record of '$key' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not record mapping '$key' after retries"
