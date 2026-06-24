#!/bin/bash
# mentor-claude.sh — default self-improvement handler: find opportunities via
# `claude -p` wearing the mentor role, and post them as jobs for gardeners.
#
# Invoked by mentor.sh as: mentor-claude.sh <digest-sha> <clone-dir>
# The digest (unseen journal entries + the journalctl -p warning tail) has been
# captured as a content-addressed git blob in <clone-dir>; we pass the inner
# agent only the SHA so the whole tail never enters its context — it inspects
# the slices it needs with `git cat-file -p <sha> | grep/sed`. The inner agent
# looks for: recurring failures worth hardening a script against, and
# responsibilities currently done by an agent that a script could do more
# reliably. It emits job blocks (JOB <base> … ENDJOB); this handler posts each.
#
# Test harness overrides GARDEN_MENTOR_HANDLER with a deterministic stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="mentor-claude"

sha="${1:?usage: mentor-claude.sh <digest-sha> <clone-dir>}"
dir="${2:-${GARDEN_MENTOR_CLONE:-$GARDEN_STATE/mentor/journal}}"
role_brief="$GARDEN_ROOT/roles/mentor/AGENT.md"

prompt="$(cat <<EOF
You are the garden mentor (role brief: $role_brief). Recent failure surfaces —
new journal progress/error entries plus the \`journalctl -p warning\` tail across
all garden-* units — have been captured as a single content-addressed blob in
the mentor's journal clone. The body is NOT inlined here on purpose: read only
the slices you need.

$(inspect_note "$sha" "$dir")

The blob's sections are delimited by lines beginning '===== entry <path> ====='
(one per new journal entry) and '===== journalctl garden-* (since ...) ====='
(the warnings tail). Narrow with a pipe rather than reading the whole blob, e.g.:
  git -C $dir cat-file -p $sha | grep -n -i -E 'error|fail|fatal|trace'
  git -C $dir cat-file -p $sha | sed -n '/===== journalctl/,\$p'
  git -C $dir cat-file -p $sha | grep -A20 '===== entry '

Identify concrete opportunities to (a) harden a scripted automation against a
recurring failure, or (b) move a responsibility off an agent into a script where
it can run more reliably. For each, emit a job block EXACTLY:

JOB improve-<short-deterministic-slug>
<what to change and why, with the script/file involved>
ENDJOB

Emit nothing if there is no clear opportunity.
EOF
)"

command -v claude >/dev/null 2>&1 || die "claude not on PATH; cannot run mentor"
# --dangerously-skip-permissions: autonomous headless context, no human
# approver; the default permission gate would deny every tool call. Bypass is
# the intended fleet posture (operator pre-consents via
# skipDangerousModePermissionPrompt in ~/.claude). Requires running as non-root.
out="$(claude -p --dangerously-skip-permissions "$prompt")"

base=""; body=""
while IFS= read -r line; do
  if [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then base="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "ENDJOB" ] && [ -n "$base" ]; then
    printf '%s' "$body" | "$HERE/../post-job.sh" "$base"; base=""; body=""
  elif [ -n "$base" ]; then body+="$line"$'\n'; fi
done <<< "$out"
