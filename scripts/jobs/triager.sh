#!/bin/bash
# triager.sh — per-repo producer. Watch one repo for changes and post jobs.
#
# Usage: triager.sh <repo-slug>          e.g. kriscendobot-endo
#
# One timer-driven instance per watched repo. It fetches the repo's bare clone
# under $GARDEN_REPOS/<slug>.git, diffs the watched refs against a last-seen
# marker kept OUTSIDE any reset-prone worktree, and for each new change hands
# off to the triage handler — which wears the "triager" role (via `claude -p`)
# to decide what jobs to create, posting them with post-job.sh for gardeners.
#
# The triage decision is pluggable so tests can substitute a deterministic stub:
#   $GARDEN_TRIAGE_HANDLER <slug> <old-sha> <new-sha> <bare-dir>
# The handler is responsible for calling post-job.sh for each job it emits.
# The seen-marker is advanced only after the handler succeeds, so a crash
# re-triages rather than silently dropping a change.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

slug="${1:?usage: triager.sh <repo-slug>}"
GARDEN_TAG="triager/$slug"
: "${GARDEN_REPOS:=$GARDEN_ROOT/repos}"
: "${GARDEN_TRIAGE_HANDLER:=$HERE/handlers/triager-claude.sh}"
: "${GARDEN_WATCH_REF:=}"   # empty → use the bare clone's HEAD branch

killswitch_engaged && { log "killswitch engaged; skipping"; exit 0; }

BARE="$GARDEN_REPOS/$slug.git"
[ -d "$BARE" ] || die "no bare clone at $BARE (clone the repo first)"

git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"

# resolve the ref to watch
ref="$GARDEN_WATCH_REF"
if [ -z "$ref" ]; then
  ref="$(git --git-dir="$BARE" symbolic-ref --short HEAD 2>/dev/null || echo master)"
fi
new_sha="$(git --git-dir="$BARE" rev-parse "refs/remotes/origin/$ref" 2>/dev/null \
            || git --git-dir="$BARE" rev-parse "$ref" 2>/dev/null)" \
  || die "cannot resolve ref '$ref' in $slug"

# The poll cursor lives in the JOURNAL (durable + shared), not host-local state,
# so a restarted or failed run resumes from the last committed position.
CURSOR_KEY="activity/$slug"
old_sha="$("$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_sha:[[:space:]]*//p' | head -1)"

if [ "$old_sha" = "$new_sha" ]; then
  log "no change on $slug:$ref ($new_sha)"
  exit 0
fi
log "change on $slug:$ref: ${old_sha:-<none>} → $new_sha; triaging"

if "$GARDEN_TRIAGE_HANDLER" "$slug" "${old_sha:-}" "$new_sha" "$BARE"; then
  # advance the cursor ONLY after triage succeeded, so a crash re-triages
  printf 'last_sha: %s\nref: %s\nlast_polled_at: %s\n' "$new_sha" "$ref" "$(date -u +%FT%TZ)" \
    | "$HERE/cursor-set.sh" "$CURSOR_KEY"
  log "triaged $slug:$ref up to $new_sha"
else
  die "triage handler failed for $slug; leaving cursor at ${old_sha:-<none>} to retry"
fi
