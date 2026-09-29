#!/bin/bash
# screen-delegated-prs.sh — proxy pre-pass 1d: screen and merge kriscendobot/minion.town
# pull requests under the maintainer's screening delegation (no LLM).
#
# Design: designs/minion-town-pr-screening.md; operations:
# context/operations/minion-town-screening.md. Inert (exit 0, quiet) until the
# delegation record config/delegations/minion-town-pr-screening is seeded with
# scripts/jobs/minion-town-screening.sh seed; revoked, paused, or tampered records
# deny it. One tick (scripts/jobs/screening/driver.py):
#   - post-merge validation of attested merges: deploy.yml + the MCP watchdog; a
#     failure pauses the delegation, posts a heal fixer, and notifies the maintainer;
#   - auto-resume of a screener-made pause after a green main deploy + healthy watchdog;
#   - the screen: gates 1–6 on each open PR's exact head, writing an attestation under
#     screenings/ and posting a conductor that runs
#     ci-wait-merge.sh --screened-delegated-merge.
# Reads only GitHub metadata, CI rollups, diff paths, and journal records (the body is
# matched only against the exact heal marker), so it widens no surveillance.
#
# Journal writes land in ONE CAS commit on a dedicated clone; the driver's actions
# (deterministically named posts, gauntlet records, review requests) run only after
# that commit lands, and each is idempotent across ticks.
#
# Test seams: GARDEN_SCREEN_CLONE, GARDEN_SCREEN_HEARTBEAT, GARDEN_GH,
# GARDEN_SCREEN_POST_JOB, GARDEN_SCREEN_POST_GAUNTLET.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="${GARDEN_TAG:-proxy-screen}"

journal="${GARDEN_SCREEN_CLONE:-$GARDEN_STATE/screening/journal}"
: "${GARDEN_SCREEN_HEARTBEAT:=${GARDEN_MINION_MCP_DIR:-$GARDEN_STATE/minion-mcp}/heartbeat.json}"
: "${GARDEN_SCREEN_POST_JOB:=$HERE/post-job.sh}"
: "${GARDEN_SCREEN_POST_GAUNTLET:=$HERE/post-gauntlet.sh}"
export GARDEN_SCREEN_HEARTBEAT
GH="${GARDEN_GH:-gh}"
repository=kriscendobot/minion.town
ensure_clone "$journal"
out="$(mktemp)"; trap 'rm -f "$out"' EXIT

for attempt in $(seq 1 20); do
  sync_clone "$journal"
  if ! python3 "$HERE/screening/driver.py" "$journal" > "$out"; then
    clone_unlock "$journal"
    die "screener tick failed (GitHub read or journal parse); no state written"
  fi
  # One pathspec per add: a not-yet-created path would abort a combined add.
  for path in config/delegations/minion-town-pr-screening screenings/kriscendobot-minion.town; do
    [ -e "$journal/$path" ] && git -C "$journal" add -A -- "$path"
  done
  for notice in "$journal"/inbox/maintainer/unread/minion-town-pr-screening-*.md; do
    [ -f "$notice" ] && git -C "$journal" add -- "${notice#"$journal/"}"
  done
  rc=0
  if git -C "$journal" diff --cached --quiet; then
    clone_unlock "$journal"
  else
    commit_and_push "$journal" "proxy screen: kriscendobot/minion.town" || rc=$?
    [ "$rc" = 0 ] && clone_unlock "$journal"
  fi
  if [ "$rc" = 0 ] || [ "$rc" = 2 ]; then
    jq -r '.notes[]' "$out" | while IFS= read -r line; do log "$line"; done
    jq -c '.actions[]' "$out" | while IFS= read -r action; do
      kind="$(jq -r .kind <<<"$action")"
      case "$kind" in
        post)
          body="$(mktemp)"; jq -r .body <<<"$action" > "$body"
          GARDEN_SENDER=proxy:screen "$GARDEN_SCREEN_POST_JOB" "$(jq -r .base <<<"$action")" "$body" >/dev/null \
            || log "WARN: post $(jq -r .base <<<"$action") failed; retrying next tick"
          rm -f "$body" ;;
        gauntlet)
          GARDEN_SENDER=proxy:screen "$GARDEN_SCREEN_POST_GAUNTLET" --by proxy:screen \
            "$(jq -r .base <<<"$action")" "$(jq -r .url <<<"$action")" >/dev/null \
            || log "WARN: gauntlet $(jq -r .base <<<"$action") failed; retrying next tick" ;;
        request-review)
          # The JSON-body shape; `-f reviewers[]=` returns HTTP 422 (roles/fixer/AGENT.md).
          echo '{"reviewers":["kriskowal"]}' \
            | "$GH" api -X POST "repos/$repository/pulls/$(jq -r .number <<<"$action")/requested_reviewers" \
                --input - >/dev/null 2>&1 \
            || log "WARN: review request for #$(jq -r .number <<<"$action") failed (the inbox notice stands)" ;;
      esac
    done
    exit 0
  fi
  backoff "$attempt"
done
die 'could not commit screening state'
