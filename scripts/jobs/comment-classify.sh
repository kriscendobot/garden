#!/bin/bash
# comment-classify.sh — shared deterministic should-ack predicate.
#
# Source this file after common.sh, then call:
#   comment_should_ack <repo> <slug> <author> <surface> <number> <body-file>
#
# Callers may define comment_classify_{armed,trusted,open} callbacks. Each gets
# the same six arguments and returns 0 when its gate passes. Watchers have already
# applied those gates at their ack chokepoint and set
# COMMENT_CLASSIFY_PREQUALIFIED=1. The latency checker supplies callbacks to replay
# this predicate over a lookback window without executing work.

comment_classify_imperative_verb_present() {
  local verb="$1" body="$2"
  printf '%s' "$body" \
    | grep -Eq "(^|[.!?:;)\"] *|(^|[^a-z])(please|kindly|first|then|next|now|also|finally|and|but|so)[,:]? +)$verb([^a-z]|$)"
}

comment_classify_reads_as_directive() {
  local body verb
  body="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  printf '%s' "$body" | grep -Eq '(^|[^a-z])please([^a-z]|$)' && return 0
  printf '%s' "$body" | grep -Eq '(^|[^a-z])(apply|address|finish|complete|handle|resolve|implement|revisit|incorporate|land this|go ahead|take a look|take care of|look into|follow up|sort out|clean this up|can you|could you|would you mind)([^a-z]|$)' && return 0
  for verb in rebase retcon refresh shepherd conduct merge gauntlet americanize deslop \
    refactor rebuild build post continue implement reconstruct rewrite revise \
    address resolve incorporate revisit split extract rename remove revert finish \
    complete handle apply; do
    comment_classify_imperative_verb_present "$verb" "$body" && return 0
  done
  return 1
}

comment_should_ack() {
  local repo="${1:-}" slug="${2:-}" author="${3:-}" surface="${4:-}"
  local number="${5:-}" body_file="${6:-}" body bot
  [ -n "$repo" ] && [ -n "$slug" ] && [ -n "$author" ] || return 1
  bot="${GARDEN_BOT_LOGIN:-kriscendobot}"

  # GitHub review bodies have no reaction endpoint. Inline review comments are
  # reactable and remain covered; classifying an unreactable object would create
  # a permanent false page.
  [ "$surface" != pr-review-body ] || return 1

  [ "$(printf '%s' "$author" | tr '[:upper:]' '[:lower:]')" \
    != "$(printf '%s' "$bot" | tr '[:upper:]' '[:lower:]')" ] || return 1
  case "$author" in *'[bot]'|*'-bot'|*'_bot') return 1 ;; esac

  # The watcher calls at its existing ack chokepoint, after its armed-repo,
  # sender, address/directive, live-thread, and dispatch-success gates have all
  # passed. Preserve that established verdict; the checker takes the full path
  # below when replaying historical rows.
  [ "${COMMENT_CLASSIFY_PREQUALIFIED:-0}" = 1 ] && return 0

  [ -f "$body_file" ] || return 1
  body="$(cat "$body_file")"

  if declare -F comment_classify_armed >/dev/null; then
    comment_classify_armed "$repo" "$slug" "$author" "$surface" "$number" "$body_file" || return 1
  fi
  if declare -F comment_classify_trusted >/dev/null; then
    comment_classify_trusted "$repo" "$slug" "$author" "$surface" "$number" "$body_file" || return 1
  fi
  if declare -F comment_classify_open >/dev/null; then
    comment_classify_open "$repo" "$slug" "$author" "$surface" "$number" "$body_file" || return 1
  fi

  case "${COMMENT_CLASSIFY_SOURCE:-comment}" in
    issue-inbox)
      [ "$surface" = issue ] && return 0
      ;;
    mention)
      printf '%s' "$body" | grep -qiF "@$bot" && return 0
      return 1
      ;;
  esac

  [ "$surface" = issue ] && return 0

  # Exact addressing is sufficient even when the text is conversational: the
  # watcher intentionally acknowledges trusted, addressed chatter.
  printf '%s' "$body" | grep -qF "@$bot" && return 0
  comment_classify_reads_as_directive "$body"
}
