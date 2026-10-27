#!/bin/bash
# review-write-deny.sh — the host-local LEARNED EXCLUSION for PR review writes.
# Sourced (pure functions, no side effects at source time) by common.sh, so
# claim-job.sh sees it, and by gardening/panel.sh, which does not load common.sh.
#
# THE PROBLEM: a host whose bot token cannot write pull-request reviews on a repo
# owner's resources (oros-studio on endojs: every `gh pr review` died with
# `GraphQL: Resource not accessible by personal access token
# (addPullRequestReview)`) still raced onto gauntlet panel stages for that owner,
# ran the full ~30-seat juror fan-out, and failed only at the post, burning a
# stage retry each time (endojs/endo-but-for-bots #1543 halted after panel-2,
# panel-5, and two panel-6 attempts; also #1515, #1520, #1283, #1304, #1514, #1517).
#
# THE FIX: the FIRST such 403 records a TTL'd marker keyed by the repo OWNER (a
# fine-grained token's resource grant is per owner). While the marker is live:
#   * claim-job.sh skips every review-posting stage (gauntlet panel/undraft) whose
#     PR belongs to that owner, so a capable host claims it instead; and
#   * panel.sh refuses before the seat fan-out, so a claim that slipped through
#     costs no juror spend.
# The marker lives under $GARDEN_STATE, NEVER the journal: journal2 is public, and
# "host X's token cannot write to org Y" is credential metadata. It fails closed
# for the TTL, then expires, so a token that has since been granted access is
# re-tried without operator cleanup; each fresh 403 re-arms it.
#
# Only GitHub's fine-grained-token refusal ("Resource not accessible by personal
# access token" / "... by integration") arms it. A plain 403 can be a secondary
# rate limit, which says nothing about this token's grant.

: "${GARDEN_REVIEW_WRITE_DENY_TTL:=604800}"   # 7 days

review_write_deny_dir() {
  printf '%s\n' "${GARDEN_REVIEW_WRITE_DENY_DIR:-${GARDEN_STATE:-${GARDEN_ROOT:-$HOME}/.garden-state}/review-write-deny}"
}

review_write_deny_key() { # <owner> — lowercase, filename-safe
  printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-'
}

review_write_forbidden_text() { # <file> — the token-grant 403, not a rate limit
  grep -qE 'Resource not accessible by (personal access token|integration)' "$1" 2>/dev/null
}

review_write_deny_record() { # <owner> <repo> [detail]
  local key dir
  key="$(review_write_deny_key "$1")"; [ -n "$key" ] || return 0
  dir="$(review_write_deny_dir)"
  mkdir -p "$dir" 2>/dev/null || return 0
  printf 'expires=%s\nrepo=%s\ndetail=%s\n' \
    "$(( $(date +%s) + GARDEN_REVIEW_WRITE_DENY_TTL ))" "${2:-}" "${3:-}" \
    > "$dir/$key.tmp.$$" 2>/dev/null && mv -f "$dir/$key.tmp.$$" "$dir/$key" 2>/dev/null
  return 0
}

review_write_denied() { # <owner> — 0 while an unexpired marker exists
  local key file expires
  key="$(review_write_deny_key "$1")"; [ -n "$key" ] || return 1
  file="$(review_write_deny_dir)/$key"
  [ -f "$file" ] || return 1
  expires="$(sed -n 's/^expires=//p' "$file" 2>/dev/null | head -1)"
  [[ "$expires" =~ ^[0-9]+$ ]] || return 1
  [ "$(date +%s)" -lt "$expires" ] && return 0
  rm -f "$file" 2>/dev/null || true
  return 1
}

# The repo owner a job would post a PR review/ready-state change to, or nothing.
# Only the gauntlet stages that write to the PR are covered: panel (posts the
# review) and undraft (`gh pr ready`). clean/fix push commits and viability only
# reads, so they stay claimable on the host.
job_review_write_owner() { # <job-file>
  local stage pr
  stage="$(sed -n 's/^gauntlet_stage:[[:space:]]*//p' "$1" 2>/dev/null | head -1)"
  case "$stage" in panel|undraft) ;; *) return 0 ;; esac
  pr="$(sed -n 's/^pr:[[:space:]]*//p' "$1" 2>/dev/null | head -1)"
  [[ "$pr" =~ github\.com/([A-Za-z0-9_.-]+)/[A-Za-z0-9_.-]+/pull/[0-9]+ ]] || return 0
  printf '%s\n' "${BASH_REMATCH[1]}"
}

job_review_write_denied_owner() { # <job-file> — prints the owner and returns 0 when denied
  local owner
  owner="$(job_review_write_owner "$1")"
  [ -n "$owner" ] && review_write_denied "$owner" || return 1
  printf '%s\n' "$owner"
}
