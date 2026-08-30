#!/bin/bash
# ensure-pr.sh — find-or-create THE pull request for a job, idempotently, in
# plain code. A job that is claimed more than once must converge on ONE pull
# request; it must never open a second.
#
# The hazard (endojs/endo-but-for-bots #865 vs #871, 2026-07-28): the
# `endo-sturdyref-agent-surface-build` job was claimed FOUR times. An early
# stranded incarnation opened #865 on an in-repo branch; the incarnation that
# finished opened #871 on the fork head. The two branches diverged (3 ahead /
# 5 behind), #865 failed all four test-matrix legs, attracted auto-shepherd
# minting, and was finally closed BY HAND. Nothing in scripts/ created PRs, so
# "don't open a duplicate" rested entirely on an agent remembering — which is
# exactly the kind of responsibility that should be deterministic.
#
# The identity this script owns is the pairing of a job base with its PR. It
# looks for an existing PR two independent ways before it will create anything:
#
#   1. THE HEAD BRANCH. `gh pr list --head <branch>` — an open BOT-AUTHORED PR
#      already pointing at this head is this job's PR. The authorship filter is
#      load-bearing: `--head` matches the ref NAME across every fork, so a
#      stranger's identically-named branch would otherwise be adopted and pushed
#      to. Such a match is logged and ignored, never silently dropped.
#   2. THE JOB MARKER. Any open bot-authored PR whose body carries
#      `<!-- garden-job: <base> -->` — the durable, cross-incarnation identity.
#      It survives a requeue, a different head branch (the #865/#871 shape), and
#      a worker that lost every scrap of local state. The marker is an HTML
#      comment, so it is invisible in the rendered body and leaks no methodology
#      (skills/pr-formation § No methodology leak).
#
# The three outcomes, and the rule that makes this safe:
#   * exactly one candidate -> print its number, create NOTHING, exit 0.
#   * no candidate          -> create the PR (marker embedded) and print it.
#   * more than one         -> print them ALL and exit 3. A human or a gardener
#                              resolves the duplicate; the script NEVER guesses,
#                              and above all never adds a third.
# A discovery query that fails, or the targeted head query comes back at its
# page limit (so it may have been truncated), is INCONCLUSIVE. Exit 4 without
# creating. The marker query paginates through every open PR instead of treating
# a busy repository's first page as the whole answer.
#
# The resulting number is recorded into the job's journal `work/<base>` record
# (`pr_number:` / `pr_repo:` / `pr_url:`) so a later call within the same claim
# resolves it with NO GitHub query at all. Note the boundary honestly: the
# reaper DELETES `work/<base>` when it requeues a stale claim, so across
# incarnations the durable converger is the marker query above, not the record.
#
# Usage:
#   ensure-pr.sh <job-base> <repo> <head-branch> <base-branch> \
#                [--title T] [--body-file F | --body TEXT] \
#                [--no-draft] [--find-only] [--author LOGIN] [--limit N]
#
#   <repo>         owner/name (what `gh --repo` wants); a full GitHub URL is
#                  also accepted and normalized.
#   <head-branch>  the PR head. `owner:branch` is accepted (cross-fork); the
#                  owner prefix is stripped for the head-filter query and kept
#                  for the create.
#   --find-only    look, never create. Exit 2 when nothing is found.
#   --limit N      cap the targeted head-branch query. Marker discovery always
#                  paginates through the complete open-PR set.
#   --no-draft     open ready-for-review. Reserved for the boatman's UPSTREAM
#                  ferry PR: every fork-side PR the garden opens MUST be draft
#                  (skills/pr-creation-flow § Draft discipline) because the
#                  draft flag is what triggers the gauntlet. Warns when used.
#
# Ordering: push the head branch FIRST (scripts/jobs/gardening/safe-push-pr-head.sh)
# — `gh pr create` needs the ref to exist on the remote.
#
# Exit codes ARE the contract:
#   0  exactly one PR (found or created); its number is on stdout
#   2  --find-only and no PR exists (nothing on stdout)
#   3  AMBIGUOUS: several candidate PRs; all numbers on stdout; nothing created
#   4  INCONCLUSIVE: a discovery query failed or may have been truncated;
#      nothing created — retry later rather than risk a duplicate
#   1  usage / operational error
#
# Test seams: GARDEN_GH (the gh binary, as in ci-wait-merge.sh),
# GARDEN_ENSURE_PR_NO_JOURNAL=1 (skip the work/<base> record entirely).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ensure-pr"

title=""; body_file=""; body_text=""; draft=1; find_only=0
author="${GARDEN_BOT_LOGIN:-kriscendobot}"
limit="${GARDEN_ENSURE_PR_LIST_LIMIT:-200}"
positional=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --title)     title="${2:?--title needs a value}"; shift 2 ;;
    --title=*)   title="${1#--title=}"; shift ;;
    --body-file) body_file="${2:?--body-file needs a value}"; shift 2 ;;
    --body-file=*) body_file="${1#--body-file=}"; shift ;;
    --body)      body_text="${2:?--body needs a value}"; shift 2 ;;
    --body=*)    body_text="${1#--body=}"; shift ;;
    --author)    author="${2:?--author needs a value}"; shift 2 ;;
    --author=*)  author="${1#--author=}"; shift ;;
    --limit)     limit="${2:?--limit needs a value}"; shift 2 ;;
    --limit=*)   limit="${1#--limit=}"; shift ;;
    --draft)     draft=1; shift ;;
    --no-draft)  draft=0; shift ;;
    --find-only) find_only=1; shift ;;
    --)          shift; while [ "$#" -gt 0 ]; do positional+=("$1"); shift; done ;;
    -*)          die "unknown option $1" ;;
    *)           positional+=("$1"); shift ;;
  esac
done
set -- "${positional[@]+"${positional[@]}"}"

base="${1:?usage: ensure-pr.sh <job-base> <repo> <head-branch> <base-branch> [--title T --body-file F]}"
repo="${2:?repo (owner/name)}"
head="${3:?head branch}"
base_branch="${4:?base branch}"
is_job_basename "$base" || die "illegal job base '$base'"
[[ "$limit" =~ ^[1-9][0-9]*$ ]] || die "--limit must be a positive integer, got '$limit'"

# Normalize a full GitHub URL down to owner/name; reject anything else, because a
# malformed repo makes `gh pr list` return nothing, which would read as "no PR
# exists" and create a duplicate.
repo="${repo#https://github.com/}"; repo="${repo#git@github.com:}"; repo="${repo%.git}"
repo="${repo%/}"
[[ "$repo" =~ ^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$ ]] || die "repo must be owner/name, got '$repo'"

# `gh pr list --head` filters on the head REF name, so a cross-fork `owner:branch`
# must be stripped for the query while the create keeps the qualified form.
head_ref="${head##*:}"

marker="<!-- garden-job: $base -->"

GH="gh"
if [ -n "${GARDEN_GH:-}" ]; then
  if [ -x "$GARDEN_GH" ] || command -v "$GARDEN_GH" >/dev/null 2>&1; then
    GH="$GARDEN_GH"
  else
    log "WARN: GARDEN_GH=$GARDEN_GH does not resolve; falling back to the PATH gh (the fleet wrapper)"
  fi
fi
require_tools jq
require_tools "$GH"

[ "$draft" -eq 1 ] || log "WARN: --no-draft: opening ready-for-review. Only the boatman's upstream ferry PR may do this; a fork-side PR opened non-draft skips the whole gauntlet."

# --- the journal work/<base> record ------------------------------------------
# The fast path within one claim, and the record a human reads to see which PR a
# running job owns. Never fatal: the PR's identity lives on GitHub, so a journal
# that is unreachable degrades to one extra `gh pr list`, never to a failed job.

journal_enabled() { [ "${GARDEN_ENSURE_PR_NO_JOURNAL:-0}" != "1" ]; }

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

# Both journal helpers run their body in a SUBSHELL. common.sh's clone helpers
# `die` (exit 1) on a broken clone and `exit $GARDEN_OFFLINE_RC` on an outage —
# correct for a service whose whole tick is journal work, fatal here, where the
# PR is the deliverable and the record is bookkeeping. The subshell absorbs the
# exit (and releases any clone lock the sync took) so an unreachable journal
# costs one extra `gh pr list`, never the job.

_recorded_pr_inner() {
  local rec_repo rec_num
  ensure_clone "$DIR" >/dev/null 2>&1 || return 1
  sync_clone "$DIR"   >/dev/null 2>&1 || return 1
  [ -f "$DIR/work/$base" ] || return 1
  rec_num="$(sed -n 's/^pr_number:[[:space:]]*//p' "$DIR/work/$base" | head -1)"
  rec_repo="$(sed -n 's/^pr_repo:[[:space:]]*//p'  "$DIR/work/$base" | head -1)"
  [[ "$rec_num" =~ ^[0-9]+$ ]] || return 1
  # A record naming a different repo is ignored rather than trusted.
  [ "$rec_repo" = "$repo" ] || return 1
  printf '%s\n' "$rec_num"
}

# recorded_pr — print the PR number already recorded for THIS base and repo.
recorded_pr() {
  local num
  journal_enabled || return 1
  num="$( _recorded_pr_inner 2>/dev/null )" || return 1
  [ -n "$num" ] || return 1
  printf '%s\n' "$num"
}

_record_pr_inner() {
  local num="$1" url="$2" attempt rc
  ensure_clone "$DIR" >/dev/null 2>&1 || { log "WARN: no journal clone; not recording $repo#$num on work/$base"; return 0; }
  for attempt in $(seq 1 20); do
    sync_clone "$DIR" >/dev/null 2>&1 || { log "WARN: journal sync failed; not recording $repo#$num on work/$base"; return 0; }
    # ensure-pr.sh is also runnable by hand and by tests; inventing a board record
    # for a job nobody claimed would leave the reaper a phantom to clean up.
    if [ ! -f "$DIR/work/$base" ]; then
      clone_unlock "$DIR" || true
      log "no work/$base record on the board (job not claimed here?); $repo#$num not recorded"
      return 0
    fi
    grep -v '^pr_\(number\|repo\|url\|head\):' "$DIR/work/$base" > "$DIR/work/$base.tmp" || true
    {
      printf 'pr_number: %s\n' "$num"
      printf 'pr_repo: %s\n'   "$repo"
      printf 'pr_url: %s\n'    "$url"
      printf 'pr_head: %s\n'   "$head"
    } >> "$DIR/work/$base.tmp"
    mv "$DIR/work/$base.tmp" "$DIR/work/$base"
    git -C "$DIR" add "work/$base"
    rc=0; commit_and_push "$DIR" "pr($base) $repo#$num" || rc=$?
    [ "$rc" -eq 0 ] && { log "recorded $repo#$num on work/$base"; return 0; }
    [ "$rc" -eq 2 ] && { log "work/$base already records $repo#$num"; return 0; }
    backoff "$attempt"
  done
  log "WARN: could not record $repo#$num on work/$base after retries (the PR itself is fine)"
  return 0
}

# record_pr <number> <url> — stamp the number onto work/<base> under the usual
# push CAS. Advisory: never fails the caller.
record_pr() {
  journal_enabled || return 0
  ( _record_pr_inner "$@" ) || true
  return 0
}

# --- discovery ---------------------------------------------------------------

# gh_read <gh-args...>: one read-only `gh` call, with the SAME bounded transient
# absorber the rest of the fleet uses (common.sh's signature set + full-jitter
# backoff), so a TLS blip does not read as "no PR exists". Prints the response;
# returns non-zero when the read genuinely failed, and the caller then reports
# INCONCLUSIVE rather than guessing.
gh_read() {
  local attempt=1 out rc errf stderr
  errf="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/ensure-pr-list.$$")"
  while :; do
    if out="$("$GH" "$@" 2>"$errf")"; then rc=0; else rc=$?; fi
    if [ "$rc" -eq 0 ]; then rm -f "$errf"; printf '%s' "$out"; return 0; fi
    stderr="$(cat "$errf" 2>/dev/null || true)"
    if ! _gh_api_stderr_is_transient "$stderr"; then
      log "WARN: gh read failed (definitive, rc=$rc); not retrying: ${stderr:-<no stderr>}"
      rm -f "$errf"; return "$rc"
    fi
    if [ "$attempt" -ge "${GARDEN_GH_API_ATTEMPTS:-4}" ]; then
      log "WARN: gh read failed after $attempt transient attempt(s) (rc=$rc): ${stderr:-<no stderr>}"
      rm -f "$errf"; return "$rc"
    fi
    log "gh read transient blip (rc=$rc); retry $((attempt+1)) after backoff"
    backoff "$attempt"
    attempt=$((attempt+1))
  done
}

list_prs() { gh_read pr list "$@"; }

# list_open_prs_paginated: return every open PR as one JSON array. GitHub's
# pulls endpoint is ordered newest-first and paginated at 100 items; --paginate
# follows every Link header and --slurp preserves the page boundaries so jq can
# flatten them deterministically. This deliberately has no caller-set cap: the
# durable marker may be on an old PR in a repository with hundreds of open bot
# PRs.
list_open_prs_paginated() {
  gh_read api --paginate --slurp "repos/$repo/pulls?state=open&per_page=100" \
    | jq '[.[][] | {number, body, url: .html_url, author: {login: .user.login}}]'
}

# discover — print each candidate PR number, one per line, sorted and unique.
# Returns 0 on a conclusive answer (including "none"), 4 when either query
# failed or the targeted head query came back AT the page limit, where a
# truncated page could be hiding the very PR we are looking for.
discover() {
  local by_head by_marker n foreign
  by_head="$(list_prs --repo "$repo" --state open --head "$head_ref" \
                      --limit "$limit" --json number,headRefName,author,url 2>/dev/null)" \
    || { log "WARN: head-branch query for $repo:$head_ref failed"; return 4; }
  n="$(printf '%s' "$by_head" | jq 'length' 2>/dev/null)" || { log "WARN: unparseable head-branch query result"; return 4; }
  [ "$n" -lt "$limit" ] || { log "WARN: head-branch query returned $n results at the page limit ($limit) — possibly truncated"; return 4; }

  # `--head` matches on the head REF NAME across every fork, so a stranger's PR
  # from a branch that happens to share our name would match. Adopting it would
  # be far worse than opening our own PR — we would push commits onto someone
  # else's branch — so keep only $author's. A drop is LOGGED, never silent.
  foreign="$(printf '%s' "$by_head" | jq -r --arg a "$author" \
             '[.[] | select((.author.login // "") != $a) | .number] | join(", ")')"
  [ -z "$foreign" ] || log "WARN: ignoring open PR(s) $foreign on head '$head_ref' authored by someone other than $author"
  by_head="$(printf '%s' "$by_head" | jq --arg a "$author" '[.[] | select((.author.login // "") == $a)]')"

  by_marker="$(list_open_prs_paginated 2>/dev/null)" \
    || { log "WARN: paginated marker query for open PRs on $repo failed"; return 4; }
  printf '%s' "$by_marker" | jq -e 'type == "array"' >/dev/null 2>&1 \
    || { log "WARN: unparseable paginated marker query result"; return 4; }

  {
    printf '%s' "$by_head"   | jq -r '.[].number'
    printf '%s' "$by_marker" | jq -r --arg m "$marker" --arg a "$author" \
      '.[] | select((.author.login // "") == $a) | select((.body // "") | contains($m)) | .number'
  } | sort -n | uniq
}

# url_for <number> — the PR's URL, derived without another query.
url_for() { printf 'https://github.com/%s/pull/%s\n' "$repo" "$1"; }

# report_ambiguous <numbers...> — the never-guess exit. Every candidate goes to
# stdout (the caller's list to resolve); the explanation goes to stderr.
report_ambiguous() {
  local n
  for n in "$@"; do printf '%s\n' "$n"; done
  cat >&2 <<EOF
ensure-pr: AMBIGUOUS — job '$base' matches ${#} open PRs on $repo: $*
  Nothing was created. One of these is this job's PR and the rest are duplicates
  (the endo-but-for-bots #865/#871 shape). Close or retarget the strays by hand,
  leave exactly one open, then re-run. This script will never add a third.
EOF
}

# --- 1. the recorded fast path (no GitHub query at all) ----------------------
if pr="$(recorded_pr)"; then
  log "work/$base already records $repo#$pr"
  printf '%s\n' "$pr"
  exit 0
fi

# --- 2. discovery ------------------------------------------------------------
rc=0; found="$(discover)" || rc=$?
if [ "$rc" -eq 4 ]; then
  echo "ensure-pr: INCONCLUSIVE — could not enumerate $repo's open PRs; refusing to create (a duplicate is worse than a retry)" >&2
  exit 4
fi
[ "$rc" -eq 0 ] || die "discovery failed (rc=$rc)"

# shellcheck disable=SC2206  # deliberate word-splitting of the newline-separated list
candidates=(${found:-})
case "${#candidates[@]}" in
  1) pr="${candidates[0]}"
     log "job '$base' already has $repo#$pr open; creating nothing"
     record_pr "$pr" "$(url_for "$pr")"
     printf '%s\n' "$pr"
     exit 0 ;;
  0) : ;;
  *) report_ambiguous "${candidates[@]}"; exit 3 ;;
esac

# --- 3. create ---------------------------------------------------------------
if [ "$find_only" -eq 1 ]; then
  log "no open PR for job '$base' on $repo (--find-only)"
  exit 2
fi
[ -n "$title" ] || die "no PR found and no --title given; cannot create one"
if [ -n "$body_file" ]; then
  [ -f "$body_file" ] || die "--body-file '$body_file' is not a readable file"
  body_text="$(cat "$body_file")"
fi
[ -n "$body_text" ] || die "no PR found and no --body-file/--body given; a PR body is not optional (skills/pr-formation)"

bodyf="$(mktemp "${TMPDIR:-/tmp}/ensure-pr-body.XXXXXX")"
trap 'rm -f "$bodyf"' EXIT
{
  printf '%s\n' "$body_text"
  # The marker is appended only when the caller has not already embedded it, so a
  # body round-tripped through this script does not accumulate copies.
  case "$body_text" in *"$marker"*) : ;; *) printf '\n%s\n' "$marker" ;; esac
} > "$bodyf"

create_args=(--repo "$repo" --base "$base_branch" --head "$head"
             --title "$title" --body-file "$bodyf")
[ "$draft" -eq 1 ] && create_args+=(--draft)

# ONE attempt, deliberately. `gh pr create` is not idempotent: a retry over a
# create whose response was lost is precisely how a duplicate is born. On any
# failure we re-discover instead — if the PR exists after all (ours landed, or a
# racing peer won), we adopt it.
if out="$("$GH" pr create "${create_args[@]}" 2>&1)"; then
  pr="$(printf '%s\n' "$out" | grep -oE '/pull/[0-9]+' | grep -oE '[0-9]+' | tail -1)"
else
  log "WARN: gh pr create failed: $out"
  pr=""
fi

# --- 4. verify exactly one, whatever happened above --------------------------
# This second look is load-bearing twice over: it recovers the number when the
# create's own output was unreadable, and it catches a peer incarnation that
# created its PR inside our create window. Either way the invariant asserted is
# the same one: this job ends with exactly one open PR.
rc=0; found="$(discover)" || rc=$?
if [ "$rc" -eq 0 ]; then
  # shellcheck disable=SC2206
  candidates=(${found:-})
  case "${#candidates[@]}" in
    1) pr="${candidates[0]}" ;;
    0) [ -n "$pr" ] || die "gh pr create reported no PR and none is open for job '$base' on $repo: $out" ;;
    *) report_ambiguous "${candidates[@]}"; exit 3 ;;
  esac
elif [ -z "$pr" ]; then
  echo "ensure-pr: create failed and the re-check was inconclusive; no PR number to report" >&2
  exit 4
fi

[ -n "$pr" ] || die "could not determine the PR number for job '$base' on $repo"
draft_note="ready-for-review"; [ "$draft" -eq 1 ] && draft_note=draft
log "opened $repo#$pr ($draft_note) for job '$base' (head $head, base $base_branch)"
record_pr "$pr" "$(url_for "$pr")"
printf '%s\n' "$pr"
exit 0
