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

killswitch_engaged && exit 0

DIR="${GARDEN_FOLLOWUP_CLONE:-$GARDEN_STATE/follow-up/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

SEEN="$GARDEN_STATE/follow-up/seen"
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

# cold start: record everything seen without acting, then stay silent
if [ "$cold_start" -eq 1 ]; then
  for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done
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
  for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done
  rm -f "$digest"
  exit 0
fi

# hand the digest to the inner agent; advance markers only on success
if "$GARDEN_FOLLOWUP_HANDLER" "$digest"; then
  for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done
  rm -f "$digest"
else
  rm -f "$digest"
  die "follow-up handler failed; leaving markers so the next tick retries"
fi
