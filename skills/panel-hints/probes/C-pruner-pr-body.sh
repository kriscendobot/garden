#!/bin/bash
# C-pruner-pr-body — fires the pruner when a garden-authored PR body (or a
# review-thread reply) carries more prose than the reviewer needs. Sensing half of
# the concision side of the `pr-description-reviewer-attention` review-miss cluster
# (kriscendobot/agoric-sdk#16: a body with per-package bullets and an inline test
# tally; a 235-word answer to "which test proves it?" that a permalink answered).
# The probe is a candidate signal; the pruner decides what to cut
# (roles/jurors/pruner/AGENT.md § PR body and thread replies).
#
# Signals (any one fires):
#   size     over GARDEN_PR_BODY_MAX_WORDS (300) words for a body, or
#            GARDEN_PR_REPLY_MAX_WORDS (80) for a reply; fenced code and HTML
#            comments are not counted
#   check    a Markdown checklist item (`- [ ]` / `- [x]`)
#   files    two or more bullets that lead with a code span (`**`pkg`** — ...`),
#            or three or more distinct path-like code spans: a per-file tour
#   verify   an inline test tally (`25 tests pass`, `8 passed`); link the run
#   bullets  a reply with three or more bullets
#
# Usage: C-pruner-pr-body.sh [--body-file F | --stdin] [--kind body|reply]
#        PR_BODY_FILE=F C-pruner-pr-body.sh   (how panel.sh hands it the live body)
# With no body (a plain panel-hints diff run), it abstains: `skip pruner`.
set -uo pipefail

kind=body; src="${PR_BODY_FILE:-}"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --body-file) src="$2"; shift 2 ;;
    --stdin) src=-; shift ;;
    --kind) kind="$2"; shift 2 ;;
    *) echo "C-pruner-pr-body: unknown option: $1" >&2; exit 64 ;;
  esac
done

if [ "$src" = - ]; then
  body="$(cat)"
elif [ -n "$src" ] && [ -r "$src" ]; then
  body="$(cat "$src")"
else
  echo "skip pruner"; exit 0
fi

# Prose only: drop fenced code and HTML comments (the job marker, template prompts).
prose="$(printf '%s\n' "$body" | awk '
  /^[[:space:]]*(```|~~~)/ { fence = !fence; next }
  fence { next }
  { print }' | perl -0pe 's/<!--.*?-->//gs')"

words=$(printf '%s\n' "$prose" | wc -w)
if [ "$kind" = reply ]; then max=${GARDEN_PR_REPLY_MAX_WORDS:-80}; else max=${GARDEN_PR_BODY_MAX_WORDS:-300}; fi

signals=()
[ "$words" -gt "$max" ] && signals+=("size: $words words (> $max for a $kind)")
printf '%s\n' "$prose" | grep -qE '^[[:space:]]*[-*+][[:space:]]+\[[ xX]\]' \
  && signals+=("check: a checklist item")
lead=$(printf '%s\n' "$prose" | grep -cE '^[[:space:]]*[-*+][[:space:]]+(\*\*|__)?`[^`]+`' || true)
paths=$(printf '%s\n' "$prose" | grep -oE '`[A-Za-z0-9_.@-]+/[A-Za-z0-9_./@-]+\.[A-Za-z0-9]+`' | sort -u | wc -l)
if [ "$lead" -ge 2 ]; then
  signals+=("files: $lead bullets lead with a code span")
elif [ "$paths" -ge 3 ]; then
  signals+=("files: $paths distinct file paths")
fi
tally=$(printf '%s\n' "$prose" | grep -oiE '\b[0-9]+ (tests? )?(passed|passing|pass)\b' | head -1)
[ -n "$tally" ] && signals+=("verify: inline test tally \"$tally\"")
if [ "$kind" = reply ]; then
  nb=$(printf '%s\n' "$prose" | grep -cE '^[[:space:]]*[-*+][[:space:]]' || true)
  [ "$nb" -ge 3 ] && signals+=("bullets: $nb bullets in a reply")
fi

if [ "${#signals[@]}" -gt 0 ]; then
  reason="$(printf '%s; ' "${signals[@]}")"
  echo "fire pruner pr-$kind: ${reason%; } — cut to what the reviewer needs (skills/pr-formation, skills/gricean-maxims)"
else
  echo "skip pruner"
fi
