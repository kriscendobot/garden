#!/bin/bash
# forward-gauntlet-followups.sh — deterministically surface a completed
# gauntlet clean/fix stage's extra follow-ups to the maintainer before the
# completion gate runs.
#
# Usage: forward-gauntlet-followups.sh <child-base> <job-file> <report>
#
# Clean/fix stage workers stop after one stage; the deterministic gauntlet
# driver owns the next-panel transition. Any OTHER actionable `## Follow-ups`
# text can require a maintainer decision, however, and is not necessarily a
# board-postable successor. Forward that text with reply_to=<child-base>. The
# stable message key makes a requeued completion one coalesced episode.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="forward-gauntlet-followups"

base="${1:?child base}"
jobfile="${2:?job file}"
report="${3:?completion report}"
[ -f "$jobfile" ] && [ -f "$report" ] || exit 0

gauntlet="$(plan_field "$jobfile" gauntlet)"
stage="$(plan_field "$jobfile" gauntlet_stage)"
[ -n "$gauntlet" ] || exit 0
case "$stage" in clean|fix) ;; *) exit 0 ;; esac

# Only a successfully completed stage is eligible. still-pending and failed
# reports remain wholly owned by the driver retry/halt path.
marker_count="$(grep -Ec "^[[:space:]]*<!--[[:space:]]*gauntlet-stage-result:[[:space:]]*$stage=done[[:space:]]*-->[[:space:]]*$" "$report" || true)"
[ "$marker_count" -eq 1 ] || exit 0

section="$(report_followups_section "$report" 2>/dev/null || true)"
followups_actionable "$section" || exit 0

# The next-panel note is informational and already durable in the gauntlet
# record. A section consisting only of that note needs no maintainer message.
gauntlet_driver_owns_followups "$report" "$section" && exit 0

# The section extractor intentionally runs to the next h2 (or EOF), so the
# terminal stage marker can be part of its raw result. It is protocol metadata,
# not a maintainer follow-up; keep it out of the forwarded body.
forwarded_section="$(printf '%s\n' "$section" | sed -E '/^[[:space:]]*<!--[[:space:]]*gauntlet-stage-result:/d')"

body="$(mktemp "${TMPDIR:-/tmp}/gauntlet-followups.XXXXXX")"
trap 'rm -f "$body"' EXIT
{
  printf 'Gauntlet stage "%s" ("%s", stage "%s") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.\n\n' "$base" "$gauntlet" "$stage"
  printf '## Follow-ups\n%s\n' "$forwarded_section"
} > "$body"

# inbox-send performs bounded push retries. If those are exhausted, propagate
# the failure: gardener.sh leaves the child in doin, and the requeued completion
# retries this same stable coalescing episode instead of recurring at gate rc=1.
GARDEN_MSG_COALESCE=1 \
GARDEN_MSG_ID="gauntlet-followups-$base" \
GARDEN_SENDER="gardener:$base" \
  "${GARDEN_GAUNTLET_FOLLOWUP_MESSAGE_USER:-$HERE/message-user.sh}" "$base" "$body"
