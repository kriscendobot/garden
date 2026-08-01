#!/bin/bash
# mentor-claude.sh — default self-improvement handler: find opportunities via
# the configured inference provider wearing the mentor role, and post the resulting
# jobs for gardeners.  Despite its historical filename, this is not Claude-only.
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
# shellcheck source=codex-provider-common.sh
source "$HERE/codex-provider-common.sh"
GARDEN_TAG="mentor-claude"

sha="${1:?usage: mentor-claude.sh <digest-sha> <clone-dir>}"
dir="${2:-${GARDEN_MENTOR_CLONE:-$GARDEN_STATE/mentor/journal}}"
role_brief="$GARDEN_ROOT/roles/mentor/AGENT.md"
: "${GARDEN_MENTOR_PROVIDER_ORDER:=openai,local,anthropic}"

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

# The Foreman's provider contract is reused here: unavailable credentials, quota,
# and transient provider failures advance through the configured order; a provider
# that returns semantic output owns the decision.  We deliberately do not solicit a
# second model after malformed output, because it could create conflicting jobs.
provider_order() {
  local raw="$GARDEN_MENTOR_PROVIDER_ORDER" item seen="," out=""
  local -a parts=()
  IFS=',' read -r -a parts <<< "$raw"
  [ "${#parts[@]}" -gt 0 ] || die "GARDEN_MENTOR_PROVIDER_ORDER is empty"
  for item in "${parts[@]}"; do
    item="$(printf '%s' "$item" | tr -d '[:space:]')"
    case "$item" in openai|local|anthropic) ;; *) die "invalid GARDEN_MENTOR_PROVIDER_ORDER provider '$item' (allowed: openai, local, anthropic; Moonshot is explicit-job-only)" ;; esac
    case "$seen" in *",$item,"*) die "duplicate provider '$item' in GARDEN_MENTOR_PROVIDER_ORDER" ;; esac
    seen+="$item,"; out+="${out:+ }$item"
  done
  [ -n "$out" ] || die "GARDEN_MENTOR_PROVIDER_ORDER contains no providers"
  printf '%s\n' "$out"
}

# The mentor may propose several independent improvements, but its entire output
# must be a sequence of complete JOB blocks and every block must name one stable
# script path first.  Canonicalizing before posting makes malformed/trailing prose
# fail closed rather than being silently ignored by a permissive line scanner.
validate_mentor_response() {
  local f="${1:?response file}" line base="" body="" first
  while IFS= read -r line || [ -n "$line" ]; do
    if [ -z "$base" ]; then
      [[ "$line" =~ ^JOB[[:space:]]+([a-z0-9][a-z0-9-]*)$ ]] || return 20
      base="${BASH_REMATCH[1]}"; body=""
    elif [ "$line" = ENDJOB ]; then
      [ -n "$body" ] || return 20
      first="$(printf '%s\n' "$body" | grep -m1 -v '^[[:space:]]*$' || true)"
      [[ "$first" =~ ^[A-Za-z0-9_./-]+\.(sh|py|js|ts)$ ]] || return 20
      printf 'JOB %s\n%sENDJOB\n' "$base" "$body"
      base=""; body=""
    else
      [[ "$line" =~ ^JOB[[:space:]] ]] && return 20
      body+="$line"$'\n'
    fi
  done < "$f"
  [ -z "$base" ] || return 20
}

mentor_codex_attempt() { # <openai|local> <prompt>
  local provider="$1" prompt="$2" kind model effort output json_capture rc
  case "$provider" in openai) kind=cleric ;; local) kind=hermit ;; *) return 20 ;; esac
  model="$(model_routing_default "$provider" 2>/dev/null || true)"
  [ -n "$model" ] || case "$provider" in local) model=qwen3.6 ;; *) model=gpt-5.6-terra ;; esac
  codex_provider_preflight "$provider" "$kind" mentor "mentor-$provider" 0 "$model" || return 10
  effort="$(codex_effort_for_model "$model" "$(role_default_effort "$kind" mentor)")"
  output="$(mktemp "${TMPDIR:-/tmp}/garden-mentor-$provider-message.XXXXXX")"
  json_capture="$(mktemp "${TMPDIR:-/tmp}/garden-mentor-$provider-json.XXXXXX")"
  codex_provider_extra_args "$provider"
  set +e
  codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
    -m "$model" -c "model_reasoning_effort=$effort" \
    --output-last-message "$output" --json "${CODEX_PROVIDER_EXTRA_ARGS[@]}" "$prompt" >"$json_capture" 2>&1
  rc=$?
  set -e
  if [ "$rc" -ne 0 ]; then
    log "mentor $provider provider unavailable or quota-limited (rc=$rc): $(tail -c 300 "$json_capture" 2>/dev/null || true)"
    rm -f "$output" "$json_capture"; return 10
  fi
  cat "$output"; rm -f "$output" "$json_capture"
}

mentor_anthropic_attempt() { # <prompt>
  local prompt="$1" cli output rc
  [ "$(meter_quota_status)" != backoff ] || { log "mentor anthropic provider skipped: configured Claude quota is at its high-water mark"; return 10; }
  if [ -n "${GARDEN_MENTOR_CLAUDE:-}" ]; then
    cli="$GARDEN_MENTOR_CLAUDE"
    { [ -x "$cli" ] || command -v "$cli" >/dev/null 2>&1; } \
      || { log "mentor anthropic provider unavailable: $cli not executable or on PATH"; return 10; }
  else
    cli="$(claude_bin_now)" || { log "mentor anthropic provider unavailable: claude not found"; return 10; }
  fi
  set +e
  output="$("$cli" -p --dangerously-skip-permissions "$prompt" 2>&1)"; rc=$?
  set -e
  if [ "$rc" -ne 0 ]; then
    printf '%s\n' "$output" >&2
    return 10
  fi
  printf '%s\n' "$output"
}

raw="$(mktemp "${TMPDIR:-/tmp}/garden-mentor-provider-raw.XXXXXX")"
canonical="$(mktemp "${TMPDIR:-/tmp}/garden-mentor-provider-canonical.XXXXXX")"
trap 'rm -f "$raw" "$canonical"' EXIT
for provider in $(provider_order); do
  : > "$raw"; rc=0
  case "$provider" in
    openai|local) mentor_codex_attempt "$provider" "$prompt" > "$raw" || rc=$? ;;
    anthropic) mentor_anthropic_attempt "$prompt" > "$raw" || rc=$? ;;
  esac
  if [ "$rc" -eq 10 ]; then log "mentor provider '$provider' unavailable; trying the next configured provider"; continue; fi
  [ "$rc" -eq 0 ] || die "mentor provider '$provider' failed unexpectedly (rc=$rc)"
  if validate_mentor_response "$raw" > "$canonical"; then out="$(cat "$canonical")"; break; fi
  die "mentor provider '$provider' returned malformed semantic output; refusing fallback to avoid conflicting improvement jobs"
done
[ -n "${out+x}" ] || die "no configured mentor inference provider was available"

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
