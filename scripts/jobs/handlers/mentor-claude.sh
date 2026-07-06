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
<repo-relative path of the SINGLE implicated script, alone on this first line>
<what to change and why>
ENDJOB

The FIRST body line MUST be the one repo-relative script path the job addresses
(e.g. \`scripts/jobs/foo.sh\`) and nothing else — it is parsed into a STABLE
directive identity so re-detections of the SAME failure across ticks collapse
onto one open job instead of piling up under fresh slugs. If a job truly touches
several scripts, name the single most-implicated one first; put the rest in prose
below. Emit nothing if there is no clear opportunity.
EOF
)"

# The inner agent is `claude` by default; tests inject a deterministic stub via
# GARDEN_MENTOR_CLAUDE so the parse/post path and the transient-propagation path
# below can be driven without a live model (mirrors GARDEN_FOLLOWUP_CLAUDE in
# follow-up-claude.sh — and a non-`claude`-named stub is required because the
# fleet sandbox pins the literal `claude` binary, so a PATH shim named `claude`
# cannot execute).
: "${GARDEN_MENTOR_CLAUDE:=claude}"
command -v "$GARDEN_MENTOR_CLAUDE" >/dev/null 2>&1 \
  || die "$GARDEN_MENTOR_CLAUDE not on PATH; cannot run mentor"
# --dangerously-skip-permissions: autonomous headless context, no human
# approver; the default permission gate would deny every tool call. Bypass is
# the intended fleet posture (operator pre-consents via
# skipDangerousModePermissionPrompt in ~/.claude). Requires running as non-root.
# Run `claude` under `set +e` so a NON-ZERO exit — the common transient case (a
# quota/usage cut, an Anthropic overload/5xx, an api/network blip) — is captured
# rather than tripping `set -e`, which would abort this handler at rc=1 with
# claude's output trapped in a discarded `$out` and NOTHING re-emitted. mentor.sh
# captures our combined stdout+stderr and classifies it: with empty output + rc=1
# it matches neither is_transient_empty_failure (wants a signal/offline rc) nor
# is_transient_claude_signature/_fetch_stderr_is_offline (both need signature
# TEXT), so it falls through to `die` and misreads a transient inner-agent outage
# as a real handler defect — the 30-min FATAL loop observed 2026-07-06. Mirror
# gardener-claude.sh:279-282: on non-zero rc, re-emit the captured output to our
# stderr (so mentor.sh's classifiers can see the transient signature and/or a
# propagated signal/offline rc) AND propagate rc via `exit`. The rc=0 path parses
# `$out` for JOB blocks exactly as before.
set +e
out="$("$GARDEN_MENTOR_CLAUDE" -p --dangerously-skip-permissions "$prompt" 2>&1)"
rc=$?
set -e
if [ "$rc" -ne 0 ]; then
  printf '%s\n' "$out" >&2
  exit "$rc"
fi

# already_fixed_pending_deploy: deterministic pre-filter (no LLM). A mentor
# "improve <script>" job is churn if the fix is ALREADY committed to
# origin/main2 and merely awaiting a deliberate deploy of the root checkout —
# the stale deployed root keeps re-emitting the same WARN, so the mentor keeps
# re-filing. We detect that with the same freshness signal garden-upgrade-monitor
# uses: fetch origin/main2, then for each script path the job body names, ask
# whether the DEPLOYED root already differs from origin/main2 for that path. If
# any implicated path differs, the fix is upstream (pending deploy) — skip.
# Returns 0 (skip) when at least one named path already differs; 1 otherwise.
_m2_fetched=""
already_fixed_pending_deploy() {
  local body="$1" path
  # Collect file tokens the body names (scripts/... .sh and similar file paths).
  local -a paths=()
  while IFS= read -r path; do
    [ -n "$path" ] && paths+=("$path")
  done < <(printf '%s' "$body" \
    | grep -oE '[A-Za-z0-9._/-]+\.(sh|md|py|js|ts|service|timer)' \
    | sort -u)
  [ "${#paths[@]}" -gt 0 ] || return 1
  if [ -z "$_m2_fetched" ]; then
    git -C "$GARDEN_ROOT" fetch -q origin main2 2>/dev/null || return 1
    _m2_fetched=1
  fi
  for path in "${paths[@]}"; do
    # Only paths that actually exist in the tree are meaningful to diff.
    git -C "$GARDEN_ROOT" cat-file -e "origin/main2:$path" 2>/dev/null || continue
    if ! git -C "$GARDEN_ROOT" diff --quiet origin/main2 -- "$path" 2>/dev/null; then
      log "improve job for $path already fixed in origin/main2 (pending deploy); not reposting"
      return 0
    fi
  done
  return 1
}

# Post one parsed JOB block. Its FIRST body line names the single implicated
# script path (required by roles/mentor/AGENT.md); we parse it into a STABLE
# directive identity `mentor:<path>` and pass it to post-job.sh. post-job.sh
# dedups on --identity via jobs/index/<hash>, so the SAME recurring failure —
# which re-detects under a fresh LLM-chosen slug every tick — collapses onto ONE
# open job regardless of that slug. Without this, 129 near-duplicate improve-*
# jobs piled up in jobs/tada/. The full normalized path (not just the basename)
# is the identity so two distinct scripts sharing a basename (e.g. common.sh)
# never fold onto one job. A first line that is not a lone path (older/malformed
# emission) falls back to no identity, preserving prior behavior.
post_mentor_job() {
  local base="$1" body="$2" first path
  first="$(printf '%s\n' "$body" | grep -m1 -v '^[[:space:]]*$' || true)"
  # Strip surrounding whitespace and any leading list/quote/backtick markers.
  path="$(printf '%s' "$first" | sed -E 's/^[[:space:]]*[-*>`[:space:]]*//; s/[[:space:]`]*$//')"
  if [[ "$path" =~ ^[A-Za-z0-9_./-]+$ ]] && { [[ "$path" == *.sh ]] || [[ "$path" == */* ]]; }; then
    path="${path#./}"
    printf '%s' "$body" | "$HERE/../post-job.sh" --identity "mentor:$path" "$base"
  else
    log "JOB '$base' first line is not a lone script path; posting without a directive identity"
    printf '%s' "$body" | "$HERE/../post-job.sh" "$base"
  fi
}

base=""; body=""
while IFS= read -r line; do
  if [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then base="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "ENDJOB" ] && [ -n "$base" ]; then
    if ! already_fixed_pending_deploy "$body"; then
      post_mentor_job "$base" "$body"
    fi
    base=""; body=""
  elif [ -n "$base" ]; then body+="$line"$'\n'; fi
done <<< "$out"
