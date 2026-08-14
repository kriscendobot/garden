#!/bin/bash
# maintainer-archive.sh — archive a maintainer-inbox message (unread → read).
# Usage: maintainer-archive.sh <msgid>
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="maintainer-archive"
id="${1:?usage: maintainer-archive.sh <msgid>}"
DIR="${GARDEN_MAINT_CLONE:-$GARDEN_STATE/maintainer/journal}"

# Choose a non-colliding archive destination under read/ for the unread message
# at $src. A bare `git mv` collides for a RECURRING KEYED notice: watchdog/reaper
# notices use stable, dedup-keyed filenames (one keyed message per open
# condition), so a condition that re-opens after the maintainer archived the prior
# notice re-creates the SAME unread/<key>.md — and `git mv` refuses because
# read/<key>.md already exists, wedging the archive forever. Recurrence is exactly
# the history worth keeping (the dedup design tracks notice_count/first_seen/
# last_seen), so we PRESERVE both: on collision, archive to
# read/<stem>.<disambiguator>.md rather than overwriting the earlier copy.
archive_dest() {
  local src="$1" stem ext base ts sha rel
  base="$id"
  if [ ! -e "$DIR/inbox/maintainer/read/$base" ]; then
    printf 'inbox/maintainer/read/%s\n' "$base"; return
  fi
  # Split a trailing .md (the only extension notices carry) off the stem so the
  # disambiguator lands before it (…-list.<ts>.md, not …-list.md.<ts>).
  case "$base" in
    *.md) stem="${base%.md}"; ext=".md";;
    *)    stem="$base";       ext="";;
  esac
  # Prefer the message's own recurrence timestamp for a meaningful, stable suffix;
  # fall back through the frontmatter times, then a content hash. Sanitize to the
  # ref/filesystem-safe charset doom-notice.sh uses (drops the ISO colons).
  ts="$(sed -n -e 's/^last_seen:[[:space:]]*//p' -e 's/^sent_at:[[:space:]]*//p' -e 's/^first_seen:[[:space:]]*//p' "$src" 2>/dev/null | head -1)"
  ts="$(printf '%s' "$ts" | tr -cd 'A-Za-z0-9._-')"
  rel="inbox/maintainer/read/$stem${ts:+.$ts}$ext"
  # Still a collision (same key archived twice at the same timestamp, or no usable
  # timestamp): append a short content hash so no earlier archived copy is lost.
  if [ -z "$ts" ] || [ -e "$DIR/$rel" ]; then
    sha="$(git -C "$DIR" hash-object "$src" 2>/dev/null | cut -c1-8)"
    [ -n "$sha" ] || sha="$(cksum "$src" | cut -d' ' -f1)"
    rel="inbox/maintainer/read/$stem${ts:+.$ts}.$sha$ext"
  fi
  printf '%s\n' "$rel"
}

ensure_clone "$DIR"
for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  if [ ! -e "$DIR/inbox/maintainer/unread/$id" ]; then log "$id already archived"; exit 0; fi
  mkdir -p "$DIR/inbox/maintainer/read"
  dest="$(archive_dest "$DIR/inbox/maintainer/unread/$id")"
  git -C "$DIR" mv "inbox/maintainer/unread/$id" "$dest"
  if commit_and_push "$DIR" "maintainer archive $id"; then log "archived $id → $dest"; exit 0; fi
  backoff "$attempt"
done
die "could not archive $id after retries"
