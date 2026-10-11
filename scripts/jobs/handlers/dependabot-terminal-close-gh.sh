#!/bin/bash
# Execute one watcher-proven terminal Dependabot close without an LLM.
# rc 0: closed (or already closed) and recorded; rc 1: proof changed, use botanist;
# rc 75: the terminal proof still holds but the close/record surface was unavailable.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
export GARDEN_TAG=dependabot-terminal-close GARDEN_NO_LLM=1

job="${1:?job file required}"; report="${2:?report file required}"
field() { plan_field "$job" "$1"; }
repo="$(field dependabot-close-repo)"; pr="$(field dependabot-close-pr)"
pkg="$(field dependabot-close-package)"; old="$(field dependabot-close-old)"
new="$(field dependabot-close-new)"; kind="$(field dependabot-close-kind)"
project="$(field dependabot-close-project)"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_DEPENDABOT_LOGIN:=dependabot[bot]}"
: "${GARDEN_DEP_CLOSE_COMPAT:=$HERE/dep-compat-gh.sh}"
: "${GARDEN_DEP_CLOSE_COMPARE:=$HERE/dep-compare-gh.sh}"
: "${GARDEN_DEP_CLOSE_JOURNAL:=$HERE/../journal-entry.sh}"
gh_bin="${GARDEN_GH:-gh}"

case "$repo" in endojs/endo-but-for-bots|"$GARDEN_BOT_LOGIN"/*) ;; *) exit 1;; esac
case "$pr" in ''|*[!0-9]*) exit 1;; esac
case "$kind" in superseded|peer|node) ;; *) exit 1;; esac

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
doc="$(gh_api_retry "repos/$repo/pulls/$pr" 2>/dev/null)" || exit 1
state="$(printf '%s' "$doc" | jq -r '.state // empty')"

# A retry after close must still finish its durable ledger/report. Only the open
# path revalidates and mutates; a terminal state is accepted solely for this
# already-claimed, watcher-authored directive.
if [ "$state" = open ]; then
  author="$(printf '%s' "$doc" | jq -r '.user.login // empty')"
  title="$(printf '%s' "$doc" | jq -r '.title // empty')"
  [ "$(printf '%s' "$author" | tr '[:upper:]' '[:lower:]')" = "$(printf '%s' "$GARDEN_DEPENDABOT_LOGIN" | tr '[:upper:]' '[:lower:]')" ] || exit 1
  [[ "$title" =~ ^[A-Za-z]+(\([A-Za-z0-9_./-]*\))?!?:[[:space:]]+(.*)$ ]] && title="${BASH_REMATCH[2]}"
  [[ "$title" =~ ^[Bb]ump[[:space:]]+([^[:space:]]+)[[:space:]]+from[[:space:]]+([^[:space:]]+)[[:space:]]+to[[:space:]]+([^[:space:]]+)([[:space:]].*)?$ ]] || exit 1
  [ "${BASH_REMATCH[1]}" = "$pkg" ] && [ "${BASH_REMATCH[2]}" = "$old" ] && [ "${BASH_REMATCH[3]}" = "$new" ] || exit 1

  if [ "$kind" = superseded ]; then
    peer="$(field dependabot-close-peer)"; peer_new="$(field dependabot-close-peer-new)"
    case "$peer" in ''|*[!0-9]*) exit 1;; esac
    peer_doc="$(gh_api_retry "repos/$repo/pulls/$peer" 2>/dev/null)" || exit 1
    [ "$(printf '%s' "$peer_doc" | jq -r '.state // empty')" = open ] || exit 1
    peer_author="$(printf '%s' "$peer_doc" | jq -r '.user.login // empty')"
    [ "$(printf '%s' "$peer_author" | tr '[:upper:]' '[:lower:]')" = "$(printf '%s' "$GARDEN_DEPENDABOT_LOGIN" | tr '[:upper:]' '[:lower:]')" ] || exit 1
    peer_title="$(printf '%s' "$peer_doc" | jq -r '.title // empty')"
    [[ "$peer_title" =~ ^[A-Za-z]+(\([A-Za-z0-9_./-]*\))?!?:[[:space:]]+(.*)$ ]] && peer_title="${BASH_REMATCH[2]}"
    [[ "$peer_title" =~ ^[Bb]ump[[:space:]]+([^[:space:]]+)[[:space:]]+from[[:space:]]+([^[:space:]]+)[[:space:]]+to[[:space:]]+([^[:space:]]+)([[:space:]].*)?$ ]] || exit 1
    [ "${BASH_REMATCH[1]}" = "$pkg" ] && [ "${BASH_REMATCH[3]}" = "$peer_new" ] || exit 1
    if [ "$new" != "$peer_new" ]; then
      comparison="$("$GARDEN_DEP_CLOSE_COMPARE" "$pkg" "$new" "$peer_new" 2>/dev/null)" || exit 1
      IFS=$'\t' read -r _status _ahead behind _upstream _oldref _newref <<< "$(printf '%s' "$comparison" | head -1)"
      [ "$behind" = 0 ] || exit 1
    fi
  else
    a="$(field dependabot-close-proof-a)"
    declared="$(field dependabot-close-proof-project)"
    required="$(field dependabot-close-proof-required)"
    path="$(field dependabot-close-proof-path)"
    proof="$("$GARDEN_DEP_CLOSE_COMPAT" "$repo" "$pr" "$pkg" "$new" 2>/dev/null)" || exit 1
    [ "$proof" = "incompatible"$'\t'"$kind"$'\t'"$a"$'\t'"$declared"$'\t'"$required"$'\t'"$path" ] || exit 1
  fi
elif [ "$state" != closed ]; then
  exit 1
fi

marker="<!-- garden-dependabot-terminal-close:$repo#$pr:$kind:$pkg@$new -->"
if [ "$kind" = superseded ]; then
  peer="$(field dependabot-close-peer)"
  printf 'REJECT (superseded). This Dependabot PR is superseded by #%s, which moves `%s` to the same or a containing target. This is not a finding against the upgrade; reopen if the successor does not land.\n\n%s\n' "$peer" "$pkg" "$marker" > "$tmp/comment"
elif [ "$kind" = peer ]; then
  printf 'REJECT (incompatible). `%s` declares `%s` at `%s`, while `%s` %s requires `%s`; the peer ranges have an empty intersection. Reopen if either declaration changes.\n\n%s\n' "$(field dependabot-close-proof-path)" "$(field dependabot-close-proof-a)" "$(field dependabot-close-proof-project)" "$pkg" "$new" "$(field dependabot-close-proof-required)" "$marker" > "$tmp/comment"
else
  printf 'REJECT (incompatible). `%s` declares Node `%s` (supported floor `%s`), while `%s` %s requires Node `%s`; the dependency excludes the project-supported floor. Reopen if either declaration changes.\n\n%s\n' "$(field dependabot-close-proof-path)" "$(field dependabot-close-proof-project)" "$(field dependabot-close-proof-a)" "$pkg" "$new" "$(field dependabot-close-proof-required)" "$marker" > "$tmp/comment"
fi

comment_status=skipped-already-closed; comment_error=""
if [ "$state" = open ]; then
  comment_status=posted
  comments="$(gh_api_retry --paginate "repos/$repo/issues/$pr/comments?per_page=100" 2>"$tmp/comment-read.err")" || comments=""
  if [ -n "$comments" ] && printf '%s' "$comments" | jq -se --arg m "$marker" 'any(.[][]; (.body // "") | contains($m))' >/dev/null; then
    comment_status=already-present
  elif ! "$gh_bin" pr comment "$pr" -R "$repo" --body-file "$tmp/comment" > /dev/null 2>"$tmp/comment-write.err"; then
    comment_status=failed
    comment_error="$(tr '\n' ' ' < "$tmp/comment-write.err" | head -c 500)"
  fi

  # Commentary is best-effort. A 403 here must never suppress the authorized
  # terminal mutation (the PR #1439 failure this executor closes).
  if ! "$gh_bin" pr close "$pr" -R "$repo" > /dev/null 2>"$tmp/close.err"; then
    close_error="$(tr '\n' ' ' < "$tmp/close.err" | head -c 500)"
    printf 'dependabot-terminal-close: failed\ncomment-status: %s\nclose-status: failed\ncomment-error: %s\nclose-error: %s\n' "$comment_status" "$comment_error" "$close_error" > "$report"
    exit "${GARDEN_TRANSIENT_RC:-75}"
  fi
fi

{
  printf 'project: %s\nrepo: %s\npr: %s\ndependabotany-terminal-pr: %s\n' "$project" "$repo" "$pr" "$pr"
  printf 'comment-status: %s\nclose-status: closed\n\n' "$comment_status"
  printf '# Dependabotany deterministic result: %s#%s - REJECT %s\n\n' "$repo" "$pr" "$kind"
  printf 'The watcher proof was revalidated and the terminal close was attempted independently of the verdict comment. Comment status: %s.\n' "$comment_status"
  [ -z "$comment_error" ] || printf 'Comment failure (non-blocking): %s\n' "$comment_error"
} > "$tmp/result"
GARDEN_ROLE=dependabot-terminal-close "$GARDEN_DEP_CLOSE_JOURNAL" result "$tmp/result" >/dev/null \
  || exit "${GARDEN_TRANSIENT_RC:-75}"

{
  printf 'dependabot-terminal-close: complete\n'
  printf 'repo: %s\npr: %s\nverdict: REJECT-%s\n' "$repo" "$pr" "$kind"
  printf 'comment-status: %s\nclose-status: closed\n' "$comment_status"
  [ -z "$comment_error" ] || printf 'comment-error: %s\n' "$comment_error"
  printf '\nClosed %s#%s after deterministic live-proof revalidation.\n' "$repo" "$pr"
} > "$report"
