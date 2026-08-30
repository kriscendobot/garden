#!/bin/bash
# ensure-pr-gh-stub.sh — a hermetic stand-in for `gh` for ensure-pr-test.sh.
#
# Models exactly the two gh surfaces ensure-pr.sh depends on, against a JSON
# fixture instead of GitHub (including gh's nested `author: {login}` shape):
#   * `gh pr list --repo R --state open [--head B] [--author A] --limit N --json ...`
#     -> the matching subset of $FAKE_PR_DB as a JSON array.
#   * `gh pr create --repo R --base B --head H --title T --body-file F [--draft]`
#     -> appends a PR to $FAKE_PR_DB and prints its URL, exactly as gh does.
#
# Every invocation's argv is appended to $FAKE_GH_LOG, so a test can assert both
# "created nothing" and "queried nothing" (the journal fast path).
# FAKE_GH_FAIL=list-definitive makes the list query fail with a non-transient
# error, the inconclusive-discovery case.
set -uo pipefail
: "${FAKE_PR_DB:?ensure-pr-gh-stub: set FAKE_PR_DB to a JSON array file}"
: "${FAKE_GH_LOG:?ensure-pr-gh-stub: set FAKE_GH_LOG to a log file}"
printf '%s\n' "$*" >> "$FAKE_GH_LOG"

if [ "${1:-}" = pr ] && [ "${2:-}" = list ]; then
  if [ "${FAKE_GH_FAIL:-}" = list-definitive ]; then
    echo "gh: HTTP 404: Not Found (https://api.github.com/repos/x/y/pulls)" >&2
    exit 1
  fi
  shift 2
  head=""; author=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --head)   head="${2:-}";   shift 2 ;;
      --author) author="${2:-}"; shift 2 ;;
      *) shift ;;
    esac
  done
  jq --arg head "$head" --arg author "$author" \
     '[ .[] | select($head   == "" or .headRefName  == $head)
             | select($author == "" or .author.login == $author) ]' "$FAKE_PR_DB"
  exit 0
fi

if [ "${1:-}" = api ]; then
  if [ "${FAKE_GH_FAIL:-}" = list-definitive ]; then
    echo "gh: HTTP 404: Not Found (https://api.github.com/repos/x/y/pulls)" >&2
    exit 1
  fi
  # `gh api --paginate --slurp` returns an outer array containing one array per
  # page. The fixture chunks at GitHub's requested 100-item page size.
  jq '[.[] | {number, body, html_url: ("https://github.com/example/repo/pull/" + (.number | tostring)), user: .author}] | [range(0; length; 100) as $i | .[$i:$i+100]]' "$FAKE_PR_DB"
  exit 0
fi

if [ "${1:-}" = pr ] && [ "${2:-}" = create ]; then
  shift 2
  repo=""; head=""; body_file=""; draft=false
  while [ $# -gt 0 ]; do
    case "$1" in
      --repo)      repo="${2:-}";      shift 2 ;;
      --head)      head="${2:-}";      shift 2 ;;
      --body-file) body_file="${2:-}"; shift 2 ;;
      --draft)     draft=true;         shift ;;
      *) shift ;;
    esac
  done
  number="$(jq '[.[].number] + [0] | max + 1' "$FAKE_PR_DB")"
  jq --argjson n "$number" --arg h "${head##*:}" --arg a "${FAKE_GH_LOGIN:-kriscendobot}" \
     --arg b "$(cat "$body_file" 2>/dev/null)" --argjson d "$draft" \
     '. + [{number: $n, headRefName: $h, author: {login: $a}, body: $b, isDraft: $d}]' \
     "$FAKE_PR_DB" > "$FAKE_PR_DB.new"
  mv "$FAKE_PR_DB.new" "$FAKE_PR_DB"
  printf 'https://github.com/%s/pull/%s\n' "$repo" "$number"
  exit 0
fi

echo "ensure-pr-gh-stub: unmodelled invocation: $*" >&2
exit 64
