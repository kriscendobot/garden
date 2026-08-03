#!/bin/bash
# review-rounds.sh — count HUMAN review rounds per merged bot pull request, the scarce
# input the garden's $400/mo subscription CANNOT buy. Plain code, gh + jq + awk, NO LLM.
# Design: designs/issue-cost-and-triple-evaluation.md § the human-review heuristic.
#
# WHY THIS EXISTS. cost-by-pr.sh prices the MACHINE half of an issue (capped proxy
# wallclock x rate card). But at ~$0.125/job true cost on a flat subscription the
# machine spend is close to noise against maintainer attention: a merged PR costs the
# garden a few cents to a few dollars of machine time and 1-3 ROUNDS of human review.
# This script measures that second, dominant term directly from the review threads, so
# a "cost of an issue" is machine + (human review rounds x minutes/round x $/minute).
#
# WHAT A "ROUND" IS. One review SUBMISSION (a GitHub pull-request review) authored by a
# human, not a bot. That is the unit of maintainer attention a PR consumed: each is a
# pass over the diff that ended in approve / request-changes / comment. Bot reviews
# (the panel's own summary posts, other fleet bots) are EXCLUDED — they are machine
# review, already on the machine side of the ledger. A reviewer is treated as human
# unless its login ends in `bot`/`[bot]` or is on --bot-logins; pass --humans to make
# the human set explicit instead (recommended when you know the maintainers).
#
# WHAT THIS IS NOT. Minutes-per-round and $/minute are NOT measured here or anywhere in
# the journal — they are maintainer-supplied parameters. This script measures the
# ROUND COUNT (which a worse (model,harness,memory) triple inflates) and leaves the
# per-round pricing to the caller, because a fabricated minutes figure would be the
# least defensible number in the whole budget. See the design doc's confidence table.
#
# Usage: review-rounds.sh -R <owner/repo> [--author <login>] [--humans a,b,c]
#                         [--bot-logins x,y] [--limit N] [--min-per-round M]
#                         [--dollars-per-hour D] [--json]
#   --author        PR author to restrict to (default: the bot login, $GARDEN_BOT_LOGIN).
#                   Pass '*' for all authors.
#   --humans        explicit comma-separated human reviewer logins; overrides the
#                   "not a bot" heuristic (most defensible — you name the maintainers).
#   --bot-logins    extra reviewer logins to treat as bots (comma-separated).
#   --min-per-round illustrative minutes of maintainer time per round (default 0 = off:
#                   report rounds only, price nothing).
#   --dollars-per-hour  fully-loaded maintainer cost/hour for the illustrative $ column.
#   --json          machine output.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

repo='' author='' humans='' extrabots='' limit=1000 minpr=0 dph=0 json=0
while [ $# -gt 0 ]; do
  case "$1" in
    -R|--repo)          repo="${2:?}"; shift 2 ;;
    --author)           author="${2:?}"; shift 2 ;;
    --humans)           humans="${2:?}"; shift 2 ;;
    --bot-logins)       extrabots="${2:?}"; shift 2 ;;
    --limit)            limit="${2:?}"; shift 2 ;;
    --min-per-round)    minpr="${2:?}"; shift 2 ;;
    --dollars-per-hour) dph="${2:?}"; shift 2 ;;
    --json)             json=1; shift ;;
    -h|--help)          sed -n '2,40p' "$0"; exit 0 ;;
    *) die "unknown arg: $1" ;;
  esac
done
[ -n "$repo" ] || die "review-rounds.sh needs -R <owner/repo>"
command -v gh >/dev/null 2>&1 || die "gh not on PATH"
[ -n "$author" ] || author="${GARDEN_BOT_LOGIN:-kriscendobot}"

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# One bulk read: every merged PR with its reviews. reviews[] carries author.login and
# state; that is all a round count needs.
gh pr list -R "$repo" --state merged --limit "$limit" \
  --json number,author,mergedAt,reviews > "$TMP/prs.json" 2>/dev/null \
  || die "gh pr list failed for $repo"

jq -r \
  --arg author "$author" \
  --arg humans "$humans" \
  --arg extrabots "$extrabots" '
  ($humans   | split(",") | map(select(length>0))) as $H |
  ($extrabots| split(",") | map(select(length>0))) as $XB |
  # is a reviewer login a human?  explicit --humans wins; else "not a bot".
  def is_human($l):
    if ($H|length)>0 then ($H|index($l))!=null
    else ($l|endswith("bot")|not) and ($l|endswith("[bot]")|not) and ($XB|index($l)==null)
    end;
  .[]
  | select($author=="*" or .author.login==$author)
  | { number,
      rounds:  [ .reviews[]? | select(is_human(.author.login)) ] | length,
      total:   [ .reviews[]? ] | length,
      reviewers: ( [ .reviews[]? | select(is_human(.author.login)) | .author.login ] | unique ) }
  | [ .number, .rounds, .total, (.reviewers|length) ] | @tsv
' "$TMP/prs.json" > "$TMP/rounds.tsv"

awk -F'\t' -v repo="$repo" -v minpr="$minpr" -v dph="$dph" -v json="$json" '
{ n++; r[n]=$2; pr[n]=$1; sumr+=$2; sumt+=$3; if($2>0)withr++; if($2==0)zero++;
  if($4>1)multi++ }
END{
  if(n==0){ if(json){print "{\"repo\":\""repo"\",\"merged_prs\":0}"} else {print "no merged PRs for that author on "repo}; exit 0 }
  # sort rounds for median / p90
  for(i=1;i<=n;i++) s[i]=r[i];
  for(i=1;i<=n;i++) for(j=i+1;j<=n;j++) if(s[j]<s[i]){t=s[i];s[i]=s[j];s[j]=t}
  med = (n%2)? s[(n+1)/2] : (s[n/2]+s[n/2+1])/2;
  p90 = s[int(0.9*n)>0?int(0.9*n):1];
  mean = sumr/n;
  dollars_per_round = (minpr>0 && dph>0) ? (minpr/60.0)*dph : 0;
  if(json){
    printf "{\"repo\":\"%s\",\"merged_prs\":%d,\"human_rounds\":{\"mean\":%.3f,\"median\":%.1f,\"p90\":%d,\"max\":%d,\"total\":%d},\"prs_with_human_review\":%d,\"prs_zero_human_review\":%d,\"prs_multi_reviewer\":%d",
      repo,n,mean,med,p90,s[n],sumr,withr,zero,multi;
    if(dollars_per_round>0)
      printf ",\"illustrative\":{\"min_per_round\":%d,\"dollars_per_hour\":%d,\"dollars_per_round\":%.2f,\"mean_human_review_cost_per_pr\":%.2f}",
        minpr,dph,dollars_per_round,mean*dollars_per_round;
    print "}";
  } else {
    printf "Human review rounds per merged PR — %s (author-restricted)\n", repo;
    printf "  merged PRs measured:        %d\n", n;
    printf "  human rounds/PR:            mean %.2f  median %.1f  p90 %d  max %d\n", mean, med, p90, s[n];
    printf "  total human review rounds:  %d\n", sumr;
    printf "  PRs with >=1 human review:  %d (%.0f%%)\n", withr, 100*withr/n;
    printf "  PRs with ZERO human review: %d (%.0f%%)\n", zero, 100*zero/n;
    printf "  PRs reviewed by >1 human:   %d\n", multi;
    if(dollars_per_round>0){
      printf "  ILLUSTRATIVE (parameters, NOT measured): %d min/round x $%d/hr = $%.2f/round\n", minpr, dph, dollars_per_round;
      printf "    -> mean human-review cost/merged PR = $%.2f  (compare machine cost from cost-by-pr.sh)\n", mean*dollars_per_round;
    }
  }
}' "$TMP/rounds.tsv"
