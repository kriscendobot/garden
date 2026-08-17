#!/bin/bash
# issue-source-gh.sh — default issue source for issue-inbox-watcher.sh.
#
# Invoked as: issue-source-gh.sh <owner/name> <since-iso>
#
# Emits one TSV line per NEW ISSUE and per NEW ISSUE-COMMENT the repo produced at
# or after <since-iso>, ascending by created_at. The watcher gates and dispatches;
# this handler only fetches. Pull requests are EXCLUDED — GitHub's issues API
# folds PRs into the issue stream (a PR carries a `.pull_request` member), and
# this inbox is for issues, not PRs (the comment-watcher already covers PRs).
#
# TSV columns (tab-separated, body single-lined):
#   kind  created  id  number  author  submitter  state  closed_by  closed_at  url  body
# kind ∈ issue | issue-comment
#   issue        — a newly-opened issue (author == submitter == .user.login)
#   issue-comment— a comment on an issue (author == commenter; submitter == opener)
# state ∈ open | closed ; closed_by = login that closed the issue ('-' if open).
# closed_at      = the issue's close timestamp ('-' if open). The watcher compares a
#                  comment's created against closed_at to tell a post-close
#                  re-engagement comment (process) from the terminal close (drop).
#
# For comments we JOIN the parent issue (one lookup per distinct commented issue,
# cached) to learn the submitter/state/closed_by/closed_at the watcher's
# closing-etiquette rule needs — and to DROP comments whose parent is a PR.
#
# Monitoring safety: the bodies returned here reach a job/message downstream, but
# the watcher's MAINTAINER-TRUST GATE drops any non-maintainer author BEFORE the
# body is used. This handler does no trust filtering itself; it only fetches.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="issue-source"

repo="${1:?owner/name}"; since="${2:-}"

# Hard dependencies. This handler pipes `gh api | jq` to EXTERNAL jq; a missing jq
# would otherwise yield silent empty output ("no new issues") — the 2026-06-24
# outage signature. require_tools fails LOUDLY (and alerts the maintainer) instead
# of letting a missing binary masquerade as "no activity". Must run BEFORE the jq
# pipelines below.
require_tools gh jq

# Bound the query window: never look back more than 24h, and on a cold start
# (empty cursor) seed a modest 1h retroactive window so a just-filed issue is
# caught without an unbounded backfill on a long-idle watcher.
floor="$(date -u -d '-24 hours' +%FT%TZ 2>/dev/null || echo "$since")"
cold="$(date -u -d '-1 hour'   +%FT%TZ 2>/dev/null || echo "")"
if [ -z "$since" ]; then since="$cold"; fi
if [ -n "$floor" ] && [ "$since" \< "$floor" ]; then since="$floor"; fi

oneline='(.body // "") | gsub("[\t\r\n]+"; " ")'

# Every `gh api` here is `gh_api_retry` (common.sh): a TRANSIENT blip (5xx / 429 /
# DNS-TLS-reset) is ridden out under full-jitter backoff before the call gives up,
# so a single GitHub flake no longer blanks an endpoint; a DEFINITIVE 404 is not
# retried and falls through to the same degrade path.
#
# Stderr policy: the HARD-FAIL enumerations retain gh_api_retry's final WARN in a
# temp file, then enum_die includes it in the fatal message. The parent-issue join
# lets the WARN reach stderr directly before its own fatal path. On a clean tick
# gh_api_retry is silent, so this adds no idle-window or empty-result noise. Do NOT
# suppress gh_api_retry's stderr: that caused the 2026-06-24 silent-empty outage.
# jq carries NO redirect: a jq parse error is a real fault that must surface.
#
# Failure policy: an endpoint that FAILS (past gh_api_retry's transient budget)
# fails the WHOLE tick with a nonzero exit, never degrades to empty output. The
# watcher keeps ONE high-water cursor over the merged stream: if one endpoint
# blanked while another emitted later rows, the cursor would advance past the
# blanked endpoint's events and they would never be re-fetched — a maintainer
# directive silently lost (the issue inbox is the maintainer's command channel,
# so correctness beats availability here). The watcher treats a nonzero source
# as a skipped tick with the cursor held; the next tick re-polls the same window.

issues_errf="$(mktemp)"
comments_errf="$(mktemp)"
trap 'rm -f "$issues_errf" "$comments_errf"' EXIT

enum_die() { # enum_die <description> <rc> <stderr-file>
  local description="$1" rc="$2" errf="$3" detail
  detail="$(tail -n 5 "$errf" 2>/dev/null || true)"
  if [ -n "$detail" ]; then
    die "$description for $repo failed (rc=$rc); failing the tick so the cursor holds; gh stderr (last 5 lines):
$detail"
  fi
  die "$description for $repo failed (rc=$rc); failing the tick so the cursor holds"
}

# 1) NEW ISSUES (exclude PRs). The issues API `since=` filters by UPDATED_AT, so we
#    additionally select created_at >= since to keep this to genuinely-new issues.
gh_api_retry --paginate "repos/$repo/issues?state=all&since=$since&sort=created&direction=asc&per_page=100" \
  2>"$issues_errf" \
  | jq -r --arg s "$since" "
      .[] | select(has(\"pull_request\") | not) | select(.created_at >= \$s)
      | [ \"issue\", .created_at, (.id|tostring), (.number|tostring),
          .user.login, .user.login, .state, (.closed_by.login // \"-\"),
          (.closed_at // \"-\"), .html_url, ($oneline) ] | @tsv" \
  || enum_die "issues enumeration" "$?" "$issues_errf"

# 2) NEW ISSUE COMMENTS — join the parent issue for submitter/state/closed_by and
#    to drop PR comments. The issues/comments feed is repo-wide and `since=` here
#    filters by UPDATED_AT, so select created_at >= since too.
#    LATENT ISSUES-DISABLED 404 (same shape as comment-source-gh.sh's section 1): this
#    repo-level `issues/comments` list returns a PERMANENT HTTP 404 on any repo whose
#    Issues feature is OFF (the default for a fork), which enum_die below would turn
#    into a per-tick FATAL. It does NOT fire today because the issue-inbox only ever
#    watches config/garden-repo (kriscendobot/garden, has_issues=true). If the inbox is
#    ever pointed at a fork, gate this on has_issues from repos/<repo> (the disabled
#    state has no issues to enumerate, so there is nothing to recover here — unlike the
#    comment-watcher's pr-comment surface) rather than failing the tick; reuse
#    comment-source-gh.sh's repo_has_issues/repo_issues_disabled shape.
declare -A _ISSUE_META=()   # number -> "submitter\tstate\tclosed_by\tclosed_at\tis_pr"
issue_meta() {  # issue_meta <number> -> echoes submitter \t state \t closed_by \t closed_at \t is_pr
  local n="$1" raw
  if [ -n "${_ISSUE_META[$n]+x}" ]; then printf '%s' "${_ISSUE_META[$n]}"; return; fi
  # closed_by AND closed_at use a '-' sentinel when empty so the TAB-IFS `read` below
  # does not collapse an empty middle field and mis-assign is_pr (see watcher's note).
  raw="$(gh_api_retry "repos/$repo/issues/$n" \
         | jq -r '[ .user.login, .state, (.closed_by.login // "-"), (.closed_at // "-"),
                    (if has("pull_request") then "pr" else "issue" end) ] | @tsv' \
         | head -1 || true)"
  _ISSUE_META[$n]="$raw"; printf '%s' "$raw"
}

gh_api_retry --paginate "repos/$repo/issues/comments?since=$since&sort=created&direction=asc&per_page=100" \
  2>"$comments_errf" \
  | jq -r --arg s "$since" "
      .[] | select(.created_at >= \$s)
      | [ .created_at, (.id|tostring),
          ((.issue_url // \"\") | capture(\"/(?<n>[0-9]+)\$\").n // \"\"),
          .user.login, .html_url, ($oneline) ] | @tsv" \
  | while IFS=$'\t' read -r created cid number author url body; do
      [ -n "$number" ] || continue
      meta="$(issue_meta "$number")"
      IFS=$'\t' read -r submitter state closed_by closed_at is_pr <<<"$meta"
      [ "$is_pr" = pr ] && continue                 # a PR comment — not our inbox
      if [ -z "$submitter" ]; then
        # The parent-issue join failed (gh error past the retry budget). Do NOT
        # skip just this row: the watcher's cursor would advance over it via the
        # later rows and the comment would be unrecoverable. Fail the tick.
        log "FATAL: parent issue #$number lookup failed for comment id=$cid; failing the tick so the cursor holds"
        exit 3
      fi
      printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "issue-comment" "$created" "$cid" "$number" "$author" "$submitter" \
        "$state" "$closed_by" "$closed_at" "$url" "$body"
    done \
  || enum_die "issue-comments enumeration/join" "$?" "$comments_errf"
