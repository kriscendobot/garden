#!/bin/bash
# pr-job-marker.sh — stamp the durable garden-job marker onto every `gh pr create`.
#
# WHAT THIS IS
# A job that is claimed more than once (a reaper requeue) must converge on ONE pull
# request; it must never open a second. The deterministic converger already exists:
# scripts/jobs/gardening/ensure-pr.sh embeds `<!-- garden-job: <base> -->` in every
# body it writes and, before creating anything, queries open bot-authored PRs for
# that marker — so a later claimant on ANY host, with a different head branch and no
# local state, adopts the prior PR instead of opening a duplicate (the #865/#871 and
# #999/#1000 shape). That converger has ONE precondition: the prior PR must actually
# CARRY the marker. A worker that opens its PR with a bare `gh pr create` (still a
# documented path for follow-ups and stacked PRs, and how the node-24x-ci job opened
# #999) writes NO marker, so nothing downstream can rediscover it, and a cross-host
# requeue re-creates from scratch. See designs/requeue-rediscover-prior-work.md.
#
# THE FIX
# This library rewrites a `gh pr create` argv so the created PR body carries
# `<!-- garden-job: $GARDEN_JOB_BASE -->` (byte-identical to ensure-pr.sh's marker,
# so ensure-pr's discover() finds it). It is sourced by the fleet's gh wrapper
# (scripts/jobs/bin/gh) — the single PATH chokepoint every fleet gh call passes
# through — so the marker is stamped by code that cannot forget, exactly the reason
# the comment-provenance footer lives there too (roles/mentor/AGENT.md: move a
# responsibility off an agent and into code). $GARDEN_JOB_BASE is exported by the
# worker handler (handlers/monk-claude.sh), so the chokepoint always knows the base.
#
# ADD ONLY, NEVER BLOCK
# This injects an invisible HTML comment; it never blocks a create, never changes a
# rendered byte, and never touches a non-`pr create` call. It cannot regress any
# flow (follow-up, stacked, ferry) — it only makes the PR rediscoverable. Preventing
# the duplicate outright (discover-and-adopt at create time) is the deeper follow-up
# weighed in the design; this contained step is its enabling precondition — you
# cannot rediscover a PR that was never marked.
#
# FAIL OPEN, NEVER CLOSED
# Any doubt — not a `pr create`, no/invalid $GARDEN_JOB_BASE, no body flag (an
# editor or --fill create), an unreadable --body-file, a marker already present —
# passes the call through UNCHANGED. A create that fails because marking was
# unavailable would be worse than a PR missing its marker.
#
# IDEMPOTENT
# A body that already carries any `<!-- garden-job:` marker (ours, or another base's
# on a deliberate adopt) is never given a second one.
#
# Pure/side-effect-free to source: it only defines functions. Deliberately
# standalone (does NOT source common.sh) so the hot gh path stays cheap.

# _prjm_valid_base <base> — the SAME rule as common.sh is_job_basename, inlined so
# this file stays standalone. Rejecting `:` and `#` also keeps the value from
# breaking out of the `<!-- … -->` comment it is spliced into.
_prjm_valid_base() {
  case "${1-}" in ''|*/*|*'#'*|*:*) return 1;; *) return 0;; esac
}

# shellcheck disable=SC2034  # PRJM_NEWARGV is consumed by the gh wrapper.
PRJM_NEWARGV=()
PRJM_TMPFILES=()

# _prjm_mktemp — a temp file the real gh can read; TMPDIR is fine (body text only).
_prjm_mktemp() {
  local f
  f="$(mktemp "${TMPDIR:-/tmp}/garden-prjm.XXXXXX" 2>/dev/null)" || return 1
  PRJM_TMPFILES+=("$f")
  printf '%s' "$f"
}

pr_job_marker_cleanup() {
  local f
  for f in "${PRJM_TMPFILES[@]:-}"; do [ -n "$f" ] && rm -f "$f" 2>/dev/null || true; done
  PRJM_TMPFILES=()
}

# pr_job_marker_rewrite_argv <argv...> — inject the marker into a `gh pr create`.
# Contract for the wrapper:
#   rc 0 → PRJM_NEWARGV is the argv to exec instead of "$@"; pr_job_marker_cleanup
#          removes any temp file AFTER the real gh returns.
#   rc 1 → passthrough: exec the ORIGINAL "$@" unchanged.
# Every body form (-b/--body inline, -F/--body-file file, `-F -` stdin) is
# normalized into a single temp --body-file carrying body+marker, so the original
# body flags are stripped and a --body-file on disk is never mutated.
pr_job_marker_rewrite_argv() {
  PRJM_NEWARGV=()
  local cmd="${1:-}" sub="${2:-}"
  [ "$cmd" = pr ] && [ "$sub" = create ] || return 1
  local base="${GARDEN_JOB_BASE:-}"
  _prjm_valid_base "$base" || return 1
  local marker="<!-- garden-job: $base -->"

  local -a args=("$@")
  local n="${#args[@]}" i
  local body="" have_body=0 from_stdin=0
  local -a keep=()

  i=0
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
      # The one free-text value-bearing flag: consume its value into keep so a
      # title of literally "-b"/"--body-file" is never misread as a body flag.
      -t|--title)
        keep+=("$a"); i=$((i+1)); [ "$i" -lt "$n" ] && keep+=("${args[$i]}") ;;
      -b|--body)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1
        body="${args[$i]}"; have_body=1 ;;
      --body=*) body="${a#--body=}"; have_body=1 ;;
      -b=*)     body="${a#-b=}";     have_body=1 ;;
      -F|--body-file)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1
        local f="${args[$i]}"
        if [ "$f" = "-" ]; then body="$(cat)"; from_stdin=1; else body="$(cat "$f" 2>/dev/null)" || return 1; fi
        have_body=1 ;;
      --body-file=*|-F=*)
        local f="${a#*=}"
        if [ "$f" = "-" ]; then body="$(cat)"; from_stdin=1; else body="$(cat "$f" 2>/dev/null)" || return 1; fi
        have_body=1 ;;
      *) keep+=("$a") ;;
    esac
    i=$((i+1))
  done

  [ "$have_body" -eq 1 ] || return 1   # editor / --fill: nothing to inject

  # Idempotent: any existing garden-job marker (ours, or another base's on a
  # deliberate adopt) means the body already carries its identity — leave it. But a
  # stdin body was consumed and MUST still be forwarded, so on that path we rewrite
  # to a temp file without adding a second marker.
  case "$body" in
    *"<!-- garden-job:"*)
      [ "$from_stdin" -eq 1 ] || return 1
      local tmp; tmp="$(_prjm_mktemp)" || return 1
      printf '%s' "$body" > "$tmp" || return 1
      PRJM_NEWARGV=("${keep[@]}" --body-file "$tmp")
      return 0 ;;
  esac

  local newbody; printf -v newbody '%s\n\n%s' "$body" "$marker"
  local tmp; tmp="$(_prjm_mktemp)" || return 1
  printf '%s' "$newbody" > "$tmp" || return 1
  PRJM_NEWARGV=("${keep[@]}" --body-file "$tmp")
  return 0
}
