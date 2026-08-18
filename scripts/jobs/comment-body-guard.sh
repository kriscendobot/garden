#!/bin/bash
# comment-body-guard.sh — refuse a GitHub comment whose inline-code was eaten by
# shell backtick command substitution.
#
# THE INCIDENT (endojs/endo-but-for-bots #475, erights review 4965245381)
# On 2026-06-22/06-23 the fleet posted two review-thread replies in which every
# `inlineCode` span had VANISHED, each collapsing to a bare gap:
#
#   "…no longer provides  / . A new  package now owns … with , , and , …"
#
# The cause is unambiguous: the reply body was interpolated into a double-quoted
# (or unquoted) shell word and handed to `gh` from a Bash command line, so bash
# performed COMMAND SUBSTITUTION on every `` `identifier` `` — it ran `identifier`
# as a command (not found → empty stdout) and substituted the empty result,
# deleting the span AND its backticks and leaving a single-space hole. A
# markdown-heavy technical comment (package/function names in backticks) is the
# worst case: it loses exactly the words that carry the meaning.
#
# THE DISCIPLINE FIX (already in place since 2026-06-24)
# skills/pr-review-thread-replies/SKILL.md now mandates writing the body to a FILE
# (with the Write tool, never echoed through a shell) and posting via --body-file /
# `--field body=@file`. That held: across 3822 fleet comments since, only the two
# original comments exhibit the signature. This guard is the DEFENSE-IN-DEPTH
# backstop so the discipline is enforced by code, not remembered by an agent
# (roles/mentor/AGENT.md: move a responsibility off an agent into code).
#
# WHAT THIS DOES
# Sourced by the fleet gh wrapper (scripts/jobs/bin/gh) — the one PATH chokepoint
# every fleet gh call crosses — it inspects the OUTGOING comment body (after bash
# has already parsed the command line, so a stripped body arrives here corrupted)
# and REFUSES to post one that unmistakably matches the backtick-strip signature.
# The refusal is loud and names the remedy, so the calling role reposts correctly
# (from a file) instead of landing garbage a maintainer must later triage.
#
# FAIL-CLOSED ONLY ON A POSITIVE HIGH-PRECISION MATCH; FAIL-OPEN ON ANY DOUBT
# Unlike the provenance footer (comment-provenance.sh: fail OPEN, a footer is
# optional), a DETECTED-corrupt body is worse than a blocked post — the agent sees
# the block and reposts, whereas posted garbage misleads the maintainer and needs
# manual cleanup (this very job). So the guard blocks — but ONLY when it has
# POSITIVELY extracted a body that POSITIVELY matches the signature. Any parse
# doubt (unknown argv shape, non-comment endpoint, unreadable file) → passthrough
# (rc 1), never a block. The detector is tuned to ZERO false positives across the
# fleet's entire 3822-comment history and both known-bad bodies (see
# test/comment-body-guard-test.sh). An escape hatch — GARDEN_ALLOW_BACKTICK_STRIP=1
# — bypasses the block for the vanishingly rare legitimate body.
#
# Pure/side-effect-free to source: defines functions only. Self-contained (does not
# source common.sh) so the hot gh path stays cheap.

# comment_body_looks_backtick_stripped <body> — rc 0 (TRUE, corrupt) when the body
# bears the unmistakable signature of shell-eaten inline-code spans; rc 1 otherwise.
#
# Signature (high precision, tuned to 0 false positives on 3822 real fleet
# comments): a body with NO backtick at all (a genuine technical comment keeps its
# backticks; a fully-eaten one has none) that ALSO shows a collapse artifact —
#   * an empty enumeration slot ", , " (a stripped `X` between two commas), OR
#   * >= 2 independent collapse marks: "(," / ",)" (a stripped span at a paren
#     boundary) or a mid-line "  /  " gap (a stripped `A` / `B` pair).
# The zero-backtick precondition is what makes this safe to fail closed on: any
# comment that still carries backticks is, by construction, not a fully-eaten one.
comment_body_looks_backtick_stripped() {
  local b="${1-}"
  case "$b" in *'`'*) return 1 ;; esac   # any surviving backtick ⇒ not fully eaten
  # empty enumeration slot: a comma, blank(s), then a comma.
  [[ "$b" =~ ,[[:blank:]]+, ]] && return 0
  local hits=0
  [[ "$b" =~ \([[:blank:]]*, ]] && hits=$((hits+1))   # "(,"  open-paren then comma
  [[ "$b" =~ ,[[:blank:]]*\) ]] && hits=$((hits+1))   # ",)"  comma then close-paren
  [[ "$b" =~ [^[:space:]][[:blank:]][[:blank:]]+/[[:blank:]]*[^[:space:]] ]] && hits=$((hits+1))  # "  /  " gap
  [ "$hits" -ge 2 ] && return 0
  return 1
}

# _cbg_is_comment_endpoint <endpoint> — mirror of comment-provenance's endpoint
# test: only REST paths that CREATE a comment carry a body worth guarding.
_cbg_is_comment_endpoint() {
  case "${1-}" in
    */issues/[0-9]*/comments)   return 0 ;;   # issue / PR conversation comment
    */pulls/[0-9]*/comments)    return 0 ;;   # inline review comment
    */comments/[0-9]*/replies)  return 0 ;;   # threaded reply
    */pulls/[0-9]*/reviews)     return 0 ;;   # review (summary body)
  esac
  return 1
}

# _cbg_body_from_flag <argv...> — extract a pr/issue comment|review body from the
# -b/--body (inline) or -F/--body-file (file, or `-`=stdin) forms. Echoes the body;
# rc 0 if a body was found, rc 1 otherwise. NOTE: a `-` stdin body is NOT read here
# (consuming stdin would strand the real gh); stdin bodies simply pass unguarded.
_cbg_body_from_flag() {
  local -a args=("$@"); local i n="${#args[@]}"; local body="" have=0
  i=0
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
      -b|--body)      i=$((i+1)); [ "$i" -lt "$n" ] || return 1; body="${args[$i]}"; have=1 ;;
      --body=*)       body="${a#--body=}"; have=1 ;;
      -b=*)           body="${a#-b=}";     have=1 ;;
      -F|--body-file) i=$((i+1)); [ "$i" -lt "$n" ] || return 1
                      local f="${args[$i]}"; [ "$f" = "-" ] && return 1
                      body="$(cat "$f" 2>/dev/null)" || return 1; have=1 ;;
      --body-file=*|-F=*)
                      local f="${a#*=}"; [ "$f" = "-" ] && return 1
                      body="$(cat "$f" 2>/dev/null)" || return 1; have=1 ;;
    esac
    i=$((i+1))
  done
  [ "$have" -eq 1 ] || return 1
  printf '%s' "$body"; return 0
}

# _cbg_body_from_api <argv...> — extract the body a `gh api` comment POST would
# send, from a -f/-F/--raw-field/--field body=… flag (inline, or @file) only when
# the endpoint is a comment endpoint. Echoes the body; rc 0 if found, rc 1 else.
# `--input` JSON and `@-`/`-` stdin forms are left unguarded (parse-doubt/stdin).
_cbg_body_from_api() {
  local -a args=("$@"); local n="${#args[@]}" i
  local endpoint="" body="" have=0
  i=0
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
      -f|--raw-field|-F|--field)
        i=$((i+1)); [ "$i" -lt "$n" ] || return 1
        case "${args[$i]}" in body=*) body="${args[$i]#body=}"; have=1 ;; esac ;;
      -f=*|--raw-field=*|-F=*|--field=*)
        local v="${a#*=}"; case "$v" in body=*) body="${v#body=}"; have=1 ;; esac ;;
      -H|--header|-q|--jq|-t|--template|--input|--hostname|--cache|-X|--method)
        i=$((i+1)) ;;   # value-bearing: skip the value so it is not read as endpoint
      -*) : ;;
      api) : ;;
      *)  [ -z "$endpoint" ] && endpoint="$a" ;;
    esac
    i=$((i+1))
  done
  _cbg_is_comment_endpoint "$endpoint" || return 1
  [ "$have" -eq 1 ] || return 1
  case "$body" in
    @-|-) return 1 ;;                                     # stdin: leave unguarded
    @*)   body="$(cat "${body#@}" 2>/dev/null)" || return 1 ;;
  esac
  printf '%s' "$body"; return 0
}

# comment_body_guard_argv <argv...> — the wrapper hook. rc 0 = BLOCK (a corrupt
# body was positively detected and not overridden); the wrapper must refuse the
# call. rc 1 = passthrough (not a guardable comment, no body, parse doubt, clean
# body, or override set). On a block it prints a loud, remedy-naming message to
# stderr. Never mutates argv.
comment_body_guard_argv() {
  [ "${GARDEN_ALLOW_BACKTICK_STRIP:-0}" = 1 ] && return 1
  local cmd="${1:-}" sub="${2:-}" body=""
  case "$cmd" in
    pr)    case "$sub" in comment|review) body="$(_cbg_body_from_flag "$@")" || return 1 ;; *) return 1 ;; esac ;;
    issue) case "$sub" in comment)        body="$(_cbg_body_from_flag "$@")" || return 1 ;; *) return 1 ;; esac ;;
    api)   body="$(_cbg_body_from_api "$@")" || return 1 ;;
    *)     return 1 ;;
  esac
  comment_body_looks_backtick_stripped "$body" || return 1
  # shellcheck disable=SC2016  # backticks in the message are literal prose.
  printf 'gh-wrapper: ERROR kind:error REFUSING to post a comment whose inline-code spans were eaten by shell backtick command substitution (every `%s` collapsed to an empty gap — see the ", , " / "(," holes in the body). This is the endojs/endo-but-for-bots #475 corruption. Do NOT put a comment body containing backticks on a shell command line: WRITE it to a file (with the Write tool, not echo/heredoc) and post via --body-file <file> or `--field body=@<file>`. Override with GARDEN_ALLOW_BACKTICK_STRIP=1 only if this body is genuinely correct.\n' \
    'inlineCode' >&2
  return 0
}
