#!/bin/bash
# mentor.sh — the self-improvement service: watch the log AND journalctl for
# failures, debug them, and find ways to make the automation more reliable (or
# to move a responsibility off an agent into a script).
#
# Usage: mentor.sh
#
# Part of the garden's self-healing posture: every automation is supervised and
# shells out to `claude -p` inner agents, and automation is SILENT UNTIL AN
# ERROR. This service feeds two failure surfaces to an inner agent (the mentor
# role): (1) new journal progress/error entries, and (2) recent warnings/errors
# from `journalctl --user` across ALL garden-* services. The inner agent debugs
# and proposes improvements, posting them as jobs for gardeners. The script is
# thin and quiet; only its own failures surface.
#
# Pluggable for tests: GARDEN_MENTOR_HANDLER <digest-file>.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="mentor"
: "${GARDEN_MENTOR_HANDLER:=$HERE/handlers/mentor-claude.sh}"

killswitch_engaged && exit 0

DIR="${GARDEN_MENTOR_CLONE:-$GARDEN_STATE/mentor/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

SEEN="$GARDEN_STATE/mentor/seen"
JSINCE="$GARDEN_STATE/mentor/journalctl-since"
mkdir -p "$(dirname "$SEEN")"; touch "$SEEN"

# 1. new journal entries since last run
new=()
while IFS= read -r f; do
  rel="${f#"$DIR"/}"
  grep -qxF "$rel" "$SEEN" && continue
  new+=("$f")
done < <(find "$DIR/entries" -type f -name '*.md' 2>/dev/null | sort)

# 2. recent service failures from journalctl across all garden-* units
#    (production path; tolerant when systemd/journalctl is absent)
since="$(cat "$JSINCE" 2>/dev/null || echo '-1h')"
jlog=""
if command -v journalctl >/dev/null 2>&1; then
  systemd_user_env
  jlog="$(journalctl --user -u 'garden-*' -p warning --since "$since" --no-pager 2>/dev/null || true)"
fi

# 3. nothing to look at → stay silent
if [ "${#new[@]}" -eq 0 ] && [ -z "$jlog" ]; then exit 0; fi

# 4. build the combined digest
digest="$(mktemp "${TMPDIR:-/tmp}/garden-improve.XXXXXX")"
for f in "${new[@]}"; do
  printf '===== entry %s =====\n' "${f#"$DIR"/}" >> "$digest"; cat "$f" >> "$digest"; printf '\n' >> "$digest"
done
if [ -n "$jlog" ]; then
  printf '===== journalctl garden-* (since %s) =====\n%s\n' "$since" "$jlog" >> "$digest"
fi

# 5. hand it to the inner agent; advance markers only on success
if "$GARDEN_MENTOR_HANDLER" "$digest"; then
  for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done
  date -u +%FT%TZ > "$JSINCE"
  rm -f "$digest"
else
  rm -f "$digest"
  die "improve handler failed; leaving markers so the next tick retries"
fi
