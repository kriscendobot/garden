#!/bin/bash
# post-job.sh — post a job to the journal's job board.
#
# Usage:
#   post-job.sh <verb> <slug> [options]
# Options:
#   --repo <owner/name>
#   --pr <int>
#   --issue <int>
#   --design <path>
#   --project <slug>
#   --eligible <role>[,<role>...]      default: steward
#   --priority urgent|normal           default: normal
#   --deadline <ISO>                   default: null
#   --identity-switch                  set authorizations.identity_switch = true
#   --comment-repo <owner/name>        repeatable; populates authorizations.comment_repos
#   --posted-by-role <role>            default: $GARDEN_ROLE or the inferred role
#   --refs <path>                      repeatable; populates refs[]
#
# The job body is read from stdin.
#
# Output: the relative path of the posted file under the journal worktree
# (e.g. `jobs/open/20260518T231500Z--a1b2c3--gamut-289.md`).

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <verb> <slug> [--repo owner/name] [--pr N] [--issue N] [--design path] [--project slug] [--eligible role[,role...]] [--priority urgent|normal] [--deadline ISO] [--identity-switch] [--comment-repo owner/name]... [--posted-by-role role] [--refs path]..." >&2
  exit 64
fi

VERB=$1
SLUG=$2
shift 2

REPO=null
PR=null
ISSUE=null
DESIGN=null
PROJECT=null
ELIGIBLE=steward
PRIORITY=normal
DEADLINE=null
IDENTITY_SWITCH=false
COMMENT_REPOS=()
ROLE=${GARDEN_ROLE:-}
REFS=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --repo) REPO=$2; shift 2;;
    --pr) PR=$2; shift 2;;
    --issue) ISSUE=$2; shift 2;;
    --design) DESIGN=$2; shift 2;;
    --project) PROJECT=$2; shift 2;;
    --eligible) ELIGIBLE=$2; shift 2;;
    --priority) PRIORITY=$2; shift 2;;
    --deadline) DEADLINE=$2; shift 2;;
    --identity-switch) IDENTITY_SWITCH=true; shift;;
    --comment-repo) COMMENT_REPOS+=("$2"); shift 2;;
    --posted-by-role) ROLE=$2; shift 2;;
    --refs) REFS+=("$2"); shift 2;;
    *) echo "post-job: unknown option: $1" >&2; exit 64;;
  esac
done

if [ -z "$ROLE" ]; then
  echo "post-job: --posted-by-role not given and GARDEN_ROLE unset; cannot record producer identity" >&2
  exit 1
fi

# Resolve the garden root from this script's location.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GARDEN_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
JRN="$GARDEN_ROOT/journal"

test -d "$JRN/jobs/open" || { echo "post-job: $JRN/jobs/open missing; run from a garden checkout" >&2; exit 1; }

SHORT=$(openssl rand -hex 3)
UTC=$(date -u +%Y%m%dT%H%M%SZ)
ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ)
NAME="${UTC}--${SHORT}--${SLUG}.md"
DEST_REL="jobs/open/$NAME"
DEST="$JRN/$DEST_REL"

# Read the body from stdin into a temp file so we can write the assembled
# entry atomically.
BODY=$(mktemp)
trap 'rm -f "$BODY"' EXIT
cat > "$BODY"

# Resync the journal worktree before writing. Safe to hard-reset because
# we have not committed anything locally yet.
git -C "$JRN" fetch --quiet origin journal 2>/dev/null || true
git -C "$JRN" reset --hard origin/journal >/dev/null 2>&1 || true

{
  printf -- '---\n'
  printf 'job: %s\n' "$SHORT"
  printf 'posted_by_role: %s\n' "$ROLE"
  printf 'posted_by_host: %s\n' "$(hostname -s)"
  printf 'posted_at: %s\n' "$ISO"
  printf 'verb: %s\n' "$VERB"
  printf 'project: %s\n' "$PROJECT"
  printf 'target:\n'
  printf '  repo: %s\n' "$REPO"
  printf '  pr: %s\n' "$PR"
  printf '  issue: %s\n' "$ISSUE"
  printf '  design: %s\n' "$DESIGN"
  printf 'authorizations:\n'
  printf '  identity_switch: %s\n' "$IDENTITY_SWITCH"
  if [ "${#COMMENT_REPOS[@]}" -eq 0 ]; then
    printf '  comment_repos: []\n'
  else
    printf '  comment_repos:\n'
    for r in "${COMMENT_REPOS[@]}"; do printf '    - %s\n' "$r"; done
  fi
  printf 'priority: %s\n' "$PRIORITY"
  printf 'deadline: %s\n' "$DEADLINE"
  printf 'eligible_roles:\n'
  IFS=',' read -ra ROLES <<< "$ELIGIBLE"
  for r in "${ROLES[@]}"; do printf '  - %s\n' "$r"; done
  if [ "${#REFS[@]}" -eq 0 ]; then
    printf 'refs: []\n'
  else
    printf 'refs:\n'
    for r in "${REFS[@]}"; do printf '  - %s\n' "$r"; done
  fi
  printf 'preconditions: []\n'
  printf -- '---\n\n'
  cat "$BODY"
} > "$DEST.tmp"
mv "$DEST.tmp" "$DEST"

git -C "$JRN" add "$DEST_REL"
git -C "$JRN" commit -m "jobs: post $SHORT $VERB $SLUG" >/dev/null

for i in 1 2 3 4 5; do
  if git -C "$JRN" push --quiet origin HEAD:journal 2>/dev/null; then
    break
  fi
  git -C "$JRN" fetch --quiet origin journal
  git -C "$JRN" rebase origin/journal >/dev/null 2>&1 || { git -C "$JRN" rebase --abort >/dev/null 2>&1 || true; sleep $((i*i)); }
done

echo "$DEST_REL"
