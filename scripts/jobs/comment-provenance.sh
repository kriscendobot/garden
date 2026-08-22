#!/bin/bash
# comment-provenance.sh — the fleet's GitHub-comment provenance suffix.
#
# WHAT THIS IS
# The maintainer directive (kriskowal, 2026-07-28): every PR/issue comment the
# fleet posts to GitHub carries a small-text footer naming the MODEL, the HARNESS,
# and the DEPLOYED garden `main2` hash (hyperlinked) that produced it. This library
# renders that one-line footer and rewrites a `gh` argv to inject it. It is sourced
# by the fleet's gh wrapper (scripts/jobs/bin/gh) — the single PATH chokepoint every
# fleet gh call passes through — so the norm is ENFORCED by a script, not remembered
# by an agent (roles/mentor/AGENT.md: move a responsibility off an agent into code).
#
# WHY THE WRAPPER, NOT A SKILL
# scripts/jobs/bin/gh sits at the FRONT of the fleet PATH (common.sh), so EVERY gh
# call any role/subagent/direct-posting script makes is interceptable in one place.
# A skill telling agents to append a line is unreliable (forgotten, doubled, drifts);
# the wrapper cannot forget and is idempotent by construction.
#
# THE THREE FACTS
#   model   — GARDEN_JOB_MODEL, the model actually resolved for THIS job
#             (exported by the handler from resolve_model_tier/role_default_model),
#             not the role's nominal default. Empty ⇒ field omitted.
#   harness — the worker kind's harness CLI (GARDEN_WORKER_KIND: gardener→claude,
#             cleric/hermit/fireworker/openrouter→codex, mystic→kimi). Empty ⇒ field omitted.
#   garden  — the DEPLOYED sha from .garden-state/deploy/deployed-sha (the code that
#             actually produced the behavior — NOT origin/main2 tip, which the
#             deployed root routinely lags), hyperlinked to the commit on the repo
#             derived from the git remote (survives the pending kriskowal→kriscendobot
#             transfer: whatever the remote says is what we link, and GitHub redirects
#             the old owner anyway). Short sha as the link text.
#
# FAIL OPEN, NEVER CLOSED
# If model/harness/sha cannot be resolved, the footer degrades to the fields that
# DID resolve (or vanishes entirely) — the comment still posts. A comment that fails
# to post because provenance was unavailable is worse than a comment missing its
# footer. Any parse ambiguity ⇒ the wrapper passes the call through UNCHANGED.
#
# IDEMPOTENT
# The footer carries a hidden marker (PROV_MARKER); a body that already ends with it
# (or with a hand-written equivalent) is never doubled.
#
# This file is pure/side-effect-free to source: it only defines functions. It is
# deliberately self-contained (does NOT source common.sh) so the hot gh path stays
# cheap and cannot be broken by common.sh's heavier setup.

# The hidden idempotency marker embedded in the rendered footer. Grepping for it is
# the primary "already has a footer" test; a looser shape match backs it up so a
# hand-written footer is also not doubled.
: "${PROV_MARKER:=garden-provenance}"

# _prov_root — the DEPLOYED garden root. The wrapper on PATH lives at
# <root>/scripts/jobs/bin/gh, so this file lives at <root>/scripts/jobs/…; walk up
# from here. An explicit GARDEN_ROOT env wins (tests, overrides).
_prov_root() {
  if [ -n "${GARDEN_ROOT:-}" ]; then printf '%s\n' "$GARDEN_ROOT"; return 0; fi
  ( cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd )
}

# _prov_esc <s> — minimal HTML escape for text placed inside <code>…</code>/href.
_prov_esc() {
  local s="${1-}"
  s="${s//&/&amp;}"; s="${s//</&lt;}"; s="${s//>/&gt;}"; s="${s//\"/&quot;}"
  printf '%s' "$s"
}

# _prov_harness <worker-kind> — the harness CLI name for a worker kind. Kept in
# sync with worker_kind_field (common.sh) but inlined so this file stays standalone.
# An unknown/blank kind yields empty (field omitted, fail-open).
_prov_harness() {
  case "${1-}" in
    gardener)               printf 'claude' ;;
    cleric|hermit|fireworker|openrouter) printf 'codex' ;;
    mystic)                 printf 'kimi' ;;
    '')                     : ;;
    *)                      printf '%s' "$1" ;;  # forward an unrecognized kind verbatim
  esac
}

# _prov_deployed_sha <root> — the recorded deployed sha (the deploy marker). No git
# fallback here: the hot comment path must not shell out to git in the shared root,
# and an unrecorded sha simply degrades the garden field (fail-open). Env overrides
# mirror common.sh for testability.
_prov_deployed_sha() {
  local root="${1-}" marker
  marker="${GARDEN_DEPLOYED_SHA_MARKER:-${GARDEN_DEPLOY_STATE:-${GARDEN_STATE:-$root/.garden-state}/deploy}/deployed-sha}"
  local s; s="$(cat "$marker" 2>/dev/null || true)"
  s="${s//[$'\t\r\n ']/}"
  printf '%s' "$s"
}

# _prov_repo_url <root> — the https base URL of the garden repo, DERIVED from the
# git remote so it tracks the pending owner transfer. `git config --get` is a
# read-only config read (no fetch/checkout/state change), the same safe read
# bot_name()/bot_email() already perform against the shared root. Empty ⇒ the
# garden field degrades to an un-linked short sha.
_prov_repo_url() {
  local root="${1-}" u
  u="$(git -C "$root" config --get remote.origin.url 2>/dev/null || true)"
  [ -n "$u" ] || return 0
  u="${u%.git}"
  case "$u" in
    git@github.com:*)        u="https://github.com/${u#git@github.com:}" ;;
    ssh://git@github.com/*)  u="https://github.com/${u#ssh://git@github.com/}" ;;
    https://github.com/*)    : ;;
    http://github.com/*)     u="https://github.com/${u#http://github.com/}" ;;
    *)                       return 0 ;;  # unrecognized host ⇒ no link (fail-open)
  esac
  printf '%s' "$u"
}

# provenance_line — render the footer line, or nothing if no fact resolved. Pure;
# reads GARDEN_JOB_MODEL / GARDEN_WORKER_KIND from the environment.
provenance_line() {
  local model harness root sha url short line parts
  model="${GARDEN_JOB_MODEL:-}"
  harness="$(_prov_harness "${GARDEN_WORKER_KIND:-}")"
  root="$(_prov_root)"
  sha="$(_prov_deployed_sha "$root")"
  url="$(_prov_repo_url "$root")"

  parts=""
  if [ -n "$model" ]; then
    parts="model <code>$(_prov_esc "$model")</code>"
  fi
  if [ -n "$harness" ]; then
    [ -n "$parts" ] && parts="$parts · "
    parts="${parts}harness <code>$(_prov_esc "$harness")</code>"
  fi
  if [ -n "$sha" ]; then
    short="${sha:0:8}"
    [ -n "$parts" ] && parts="$parts · "
    if [ -n "$url" ]; then
      parts="${parts}garden <a href=\"$(_prov_esc "$url")/commit/$(_prov_esc "$sha")\"><code>$(_prov_esc "$short")</code></a>"
    else
      parts="${parts}garden <code>$(_prov_esc "$short")</code>"
    fi
  fi
  [ -n "$parts" ] || return 0
  printf '<sub><!--%s-->%s</sub>' "$PROV_MARKER" "$parts"
}

# provenance_body_has_line <body> — true (rc 0) when the body already carries a
# provenance footer: our hidden marker, or a hand-written equivalent (a <sub> line
# naming model … garden … commit/). Prevents a doubled footer.
provenance_body_has_line() {
  local body="${1-}"
  case "$body" in
    *"$PROV_MARKER"*) return 0 ;;
  esac
  # Loose shape match for a hand-authored footer (agent copied the template).
  printf '%s' "$body" | grep -Eiq '<sub>[^<]*model .*garden.*commit/' && return 0
  return 1
}

# provenance_append <body> — echo the body with the footer appended (a blank line
# between). Idempotent: a body already carrying a footer is returned unchanged. If
# no fact resolves, the body is returned unchanged (fail-open).
provenance_append() {
  local body="${1-}" line
  if provenance_body_has_line "$body"; then
    printf '%s' "$body"; return 0
  fi
  line="$(provenance_line)"
  if [ -z "$line" ]; then
    printf '%s' "$body"; return 0
  fi
  printf '%s\n\n%s' "$body" "$line"
}

# ===========================================================================
# argv rewriting — the wrapper's hard part: injecting the footer into whichever
# of gh's many body-bearing invocation forms is in use, WITHOUT corrupting the
# body (JSON stays valid; a --body-file on disk is never mutated — a fresh temp
# holds the modified body).
#
# Contract for the wrapper:
#   provenance_rewrite_argv "$@"
#     rc 0 → PROV_NEWARGV is the argv to exec instead of "$@"; PROV_TMPFILES lists
#            temp files to clean AFTER the real gh returns.
#     rc 1 → passthrough: exec the ORIGINAL "$@" unchanged (not a comment-create,
#            body already carries a footer, no fact resolved, or any parse doubt).
# Fail-open is the invariant: every uncertain branch returns 1.
# ===========================================================================

PROV_NEWARGV=()
PROV_TMPFILES=()

# _prov_mktemp — a temp file on an exec-safe path. Body/JSON temp files only need
# to be readable by the real gh; TMPDIR is fine.
_prov_mktemp() {
  local f
  f="$(mktemp "${TMPDIR:-/tmp}/garden-prov.XXXXXX" 2>/dev/null)" || return 1
  PROV_TMPFILES+=("$f")
  printf '%s' "$f"
}

provenance_cleanup() {
  local f
  for f in "${PROV_TMPFILES[@]:-}"; do [ -n "$f" ] && rm -f "$f" 2>/dev/null || true; done
  PROV_TMPFILES=()
}

# _prov_rewrite_body_flag <argv...> — handle `gh pr comment` / `gh issue comment`
# / `gh pr review`: the body arrives via -b/--body (inline) or -F/--body-file
# (file, or `-` = stdin). Normalize ALL three into a single temp --body-file that
# carries body+footer, stripping the original body flags. rc 0 if rewritten.
_prov_rewrite_body_flag() {
  local -a args=("$@")
  local i n="${#args[@]}"
  local body="" have_body=0 from_stdin=0
  local -a keep=()

  i=0
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
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

  [ "$have_body" -eq 1 ] || return 1   # editor/--edit-last/-w: nothing to inject

  # Idempotent: an already-footed body sourced from a FILE/inline can pass through
  # untouched. But if we consumed STDIN we must forward it (stdin is gone), so we
  # still rewrite — just without appending a second footer.
  if provenance_body_has_line "$body"; then
    [ "$from_stdin" -eq 1 ] || return 1
  fi

  local newbody; newbody="$(provenance_append "$body")"
  # Footer empty (no fact resolved) and body unchanged: leave the call UNTOUCHED
  # (fail-open). A stdin body must still be forwarded — we already consumed it.
  if [ "$newbody" = "$body" ] && [ "$from_stdin" -eq 0 ]; then return 1; fi
  local tmp; tmp="$(_prov_mktemp)" || return 1
  printf '%s' "$newbody" > "$tmp" || return 1

  PROV_NEWARGV=("${keep[@]}" --body-file "$tmp")
  return 0
}

# _prov_api_endpoint_is_comment <endpoint> — true when the REST path creates a
# comment (issue/PR conversation comment, inline review comment, threaded reply,
# or a review whose summary body we footer). Excludes /reactions, PR/issue
# description PATCH, labels, merges — anything without a comment body.
_prov_api_endpoint_is_comment() {
  case "${1-}" in
    */issues/[0-9]*/comments)      return 0 ;;   # issue / PR conversation comment
    */pulls/[0-9]*/comments)       return 0 ;;   # inline review comment
    */comments/[0-9]*/replies)     return 0 ;;   # threaded reply
    */pulls/[0-9]*/reviews)        return 0 ;;   # review (summary body)
  esac
  return 1
}

# _prov_rewrite_api <argv...> — handle `gh api` comment-creating POSTs. The body
# is carried as a field flag (-f/--raw-field/-F/--field body=…) or inside an
# --input JSON file (or `--input -` stdin). Only rewrite when the endpoint is a
# comment endpoint AND a POST (explicit -X POST, or fields defaulting to POST);
# everything else (reads, reactions, PATCH descriptions) passes through. rc 0 if
# rewritten.
_prov_rewrite_api() {
  local -a args=("$@")
  local n="${#args[@]}" i
  local method="" endpoint="" input_idx=-1 input_val=""
  local body_idx=-1 body_prefix="" body_val="" body_from=""   # from: raw|field
  local seen_field=0

  i=0
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
      api) : ;;  # the subcommand itself
      -X|--method)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; method="${args[$i]}" ;;
      -X=*)       method="${a#-X=}" ;;
      --method=*) method="${a#--method=}" ;;
      -f|--raw-field)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; seen_field=1
        case "${args[$i]}" in body=*) body_idx=$i; body_prefix="body="; body_val="${args[$i]#body=}"; body_from=raw ;; esac ;;
      -f=*|--raw-field=*)
        seen_field=1; local v="${a#*=}"
        case "$v" in body=*) body_idx=$i; body_prefix="${a%%body=*}body="; body_val="${v#body=}"; body_from=raw ;; esac ;;
      -F|--field)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; seen_field=1
        case "${args[$i]}" in body=*) body_idx=$i; body_prefix="body="; body_val="${args[$i]#body=}"; body_from=field ;; esac ;;
      -F=*|--field=*)
        seen_field=1; local v="${a#*=}"
        case "$v" in body=*) body_idx=$i; body_prefix="${a%%body=*}body="; body_val="${v#body=}"; body_from=field ;; esac ;;
      --input)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1; input_idx=$i; input_val="${args[$i]}" ;;
      --input=*) input_idx=$i; input_val="${a#--input=}" ;;
      -H|--header|-q|--jq|-t|--template|--hostname|--cache)
        i=$((i+1)) ;;  # value-bearing flags: skip the value so it is not read as the endpoint
      -*) : ;;         # boolean/unknown flag
      *)  [ -z "$endpoint" ] && endpoint="$a" ;;
    esac
    i=$((i+1))
  done

  _prov_api_endpoint_is_comment "$endpoint" || return 1

  # Must be a create POST. Explicit non-POST method (GET/PATCH/DELETE/…) ⇒ not a
  # comment create ⇒ passthrough. No method + a field flag ⇒ gh POSTs ⇒ create.
  if [ -n "$method" ]; then
    case "$method" in [Pp][Oo][Ss][Tt]) : ;; *) return 1 ;; esac
  else
    [ "$seen_field" -eq 1 ] || [ "$input_idx" -ge 0 ] || return 1
  fi

  PROV_NEWARGV=("${args[@]}")

  # --- body via --input JSON --------------------------------------------------
  # A `--input -` STDIN read cannot be un-consumed: once we cat it, passing the
  # original argv through would hand gh an empty stdin. So for the stdin form we
  # ALWAYS forward via a temp file (footered if a .body is present, verbatim
  # otherwise). A `--input <file>` is re-readable, so it may cleanly passthrough.
  if [ "$input_idx" -ge 0 ]; then
    local from_stdin=0; [ "$input_val" = "-" ] && from_stdin=1
    if [ "$from_stdin" -eq 0 ]; then
      command -v jq >/dev/null 2>&1 || return 1  # file input, cannot edit ⇒ passthrough
    fi
    local json
    if [ "$from_stdin" -eq 1 ]; then json="$(cat)"; else json="$(cat "$input_val" 2>/dev/null)" || return 1; fi
    # _prov_forward_json: re-emit $json (possibly edited) to a temp and repoint.
    _prov_forward_json() {
      local j="$1" tmp
      tmp="$(_prov_mktemp)" || return 1
      printf '%s' "$j" > "$tmp" || return 1
      PROV_NEWARGV[$input_idx]="$tmp"
    }
    # jq absent on the stdin path: we already consumed stdin, so forward verbatim
    # (cannot inject, but must not drop the body).
    if ! command -v jq >/dev/null 2>&1; then
      _prov_forward_json "$json" && return 0 || return 1
    fi
    local cur; cur="$(printf '%s' "$json" | jq -er '.body // empty' 2>/dev/null || true)"
    if [ -z "$cur" ] || provenance_body_has_line "$cur"; then
      # No body to footer, or already footed. On stdin we must still forward.
      if [ "$from_stdin" -eq 1 ]; then _prov_forward_json "$json" && return 0 || return 1; fi
      return 1
    fi
    local newbody; newbody="$(provenance_append "$cur")"
    local newjson
    newjson="$(printf '%s' "$json" | jq --arg b "$newbody" '.body=$b' 2>/dev/null)" || {
      [ "$from_stdin" -eq 1 ] && { _prov_forward_json "$json" && return 0; }; return 1; }
    _prov_forward_json "$newjson" && return 0 || return 1
  fi

  # --- body via a field flag --------------------------------------------------
  [ "$body_idx" -ge 0 ] || return 1
  # -F/--field body=@file or body=- reads externally; append after resolving so we
  # never mutate the source file — pass the combined value inline via a raw field.
  local resolved="$body_val"
  if [ "$body_from" = field ]; then
    case "$body_val" in
      @-) resolved="$(cat)" ;;
      @*) resolved="$(cat "${body_val#@}" 2>/dev/null)" || return 1 ;;
      -)  resolved="$(cat)" ;;
    esac
  fi
  if provenance_body_has_line "$resolved"; then
    case "$body_val" in @-|-) : ;; *) return 1 ;; esac  # already footed & not stdin ⇒ passthrough
  fi
  local newbody; newbody="$(provenance_append "$resolved")"
  # Footer empty (no fact resolved) and value unchanged: passthrough untouched,
  # unless the value came from stdin (already consumed → must forward).
  if [ "$newbody" = "$resolved" ]; then
    case "$body_val" in @-|-) : ;; *) return 1 ;; esac
  fi
  # Re-emit as a raw-field (literal) so an @file/- form cannot re-trigger file/stdin
  # reads on the modified value. Keep any -F=/-f= prefix's flag intact by rewriting
  # to the plain `body=` value; the flag token itself (args[body_idx-…]) stays.
  case "${args[$body_idx]}" in
    body=*|*=body=*) PROV_NEWARGV[$body_idx]="${body_prefix}${newbody}" ;;
    *)               PROV_NEWARGV[$body_idx]="body=${newbody}" ;;
  esac
  # A field flag that read @file/- must become a raw literal so gh treats the new
  # value as a string, not a re-read. If the flag was -F/--field, flip it to -f.
  if [ "$body_from" = field ]; then
    local flag_idx=$((body_idx-1))
    if [ "$flag_idx" -ge 0 ]; then
      case "${args[$flag_idx]}" in
        -F|--field) PROV_NEWARGV[$flag_idx]="--raw-field" ;;
      esac
    fi
    # Inline -F=body=… / --field=body=… forms: rewrite the whole token to raw-field.
    case "${args[$body_idx]}" in
      -F=body=*)      PROV_NEWARGV[$body_idx]="--raw-field=body=${newbody}" ;;
      --field=body=*) PROV_NEWARGV[$body_idx]="--raw-field=body=${newbody}" ;;
    esac
  fi
  return 0
}

# provenance_rewrite_argv <argv...> — top dispatcher. See the contract block above.
provenance_rewrite_argv() {
  # shellcheck disable=SC2034  # PROV_NEWARGV is consumed by the gh wrapper.
  PROV_NEWARGV=()
  local cmd="${1:-}" sub="${2:-}"
  case "$cmd" in
    pr)
      case "$sub" in
        comment|review) _prov_rewrite_body_flag "$@" && return 0 ;;
      esac ;;
    issue)
      case "$sub" in
        comment) _prov_rewrite_body_flag "$@" && return 0 ;;
      esac ;;
    api) _prov_rewrite_api "$@" && return 0 ;;
  esac
  return 1
}
