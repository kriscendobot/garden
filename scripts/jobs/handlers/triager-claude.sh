#!/bin/bash
# triager-claude.sh — default triage handler: decide jobs via `claude -p`.
#
# Invoked by triager.sh as: triager-claude.sh <slug> <old-sha> <new-sha> <bare>
# Wears the triager role, inspects what changed on the repo between old..new,
# and emits zero or more jobs for gardeners. The triager role brief lives at
# roles/triager/AGENT.md.
#
# Contract with claude: emit each job as a block
#     JOB <basename>
#     <body lines...>
#     ENDJOB
# This handler posts each block via post-job.sh. The basename must be
# deterministic from the change (e.g. <slug>-pr<N>-<shorthash>) so re-triage is
# idempotent. The test harness overrides GARDEN_TRIAGE_HANDLER with a stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="triage-claude"

slug="${1:?slug}"; old="${2:-}"; new="${3:?new}"; bare="${4:?bare}"
role_brief="$GARDEN_ROOT/roles/triager/AGENT.md"

range="${old:+$old..}$new"
changes="$(git --git-dir="$bare" log --no-merges --stat "${old:+$old..$new}" 2>/dev/null | head -400)"

prompt="$(cat <<EOF
You are a garden triager (role brief: $role_brief) for repository '$slug'.
The repository advanced over range '$range'. The change summary follows. Decide
what work, if any, gardeners should pick up. Emit zero or more job blocks in
EXACTLY this format and nothing else:

JOB <short-filesystem-safe-basename, deterministic from the change>
<one or more body lines describing the job for a gardener>
ENDJOB

----- CHANGES -----
$changes
----- END CHANGES -----
EOF
)"

command -v claude >/dev/null 2>&1 || die "claude not on PATH; cannot triage $slug"
# --dangerously-skip-permissions: autonomous headless context, no human
# approver; the default permission gate would deny every tool call (the triager
# needs gh especially). Bypass is the intended fleet posture (operator
# pre-consents via skipDangerousModePermissionPrompt in ~/.claude). Non-root.
# Capture claude's exit status and stderr so a failure is diagnosable rather
# than an opaque abort inside the command substitution under `set -e`. This lets
# a self-heal responder distinguish a transient API/DNS/quota blip (leave the
# cursor to retry) from a deterministic error (post a fix). The success path and
# the non-advancing-cursor retry semantics are unchanged.
errfile="$(mktemp "${TMPDIR:-/tmp}/triage-claude.XXXXXX.err")"
trap 'rm -f "$errfile"' EXIT
# NB: capture rc in the `else` branch, not via `if ! ...; then rc=$?` — after a
# `!`-negated pipeline `$?` is the logical negation (0), losing claude's real
# exit code.
if out="$(claude -p --dangerously-skip-permissions "$prompt" 2>"$errfile")"; then
  :
else
  rc=$?
  die "claude -p exited $rc while triaging $slug: $(tail -c 500 "$errfile")"
fi

# parse JOB..ENDJOB blocks and post each
posted=0; base=""; body=""
while IFS= read -r line; do
  if [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then
    base="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "ENDJOB" ] && [ -n "$base" ]; then
    printf '%s' "$body" | "$HERE/../post-job.sh" "$base"
    posted=$((posted+1)); base=""; body=""
  elif [ -n "$base" ]; then
    body+="$line"$'\n'
  fi
done <<< "$out"
log "posted $posted job(s) from $slug triage"
