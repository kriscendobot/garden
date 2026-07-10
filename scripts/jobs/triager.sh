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
#
# Consecutive-failure circuit breaker: because a failed handler leaves the cursor
# unadvanced, the systemd timer re-invokes the IDENTICAL ${old_sha}→${new_sha}
# transition every tick. That transition is deterministic (same SHAs, same diff),
# so retrying it thousands of times cannot help — it only crash-loops the unit and
# fills the journal (observed live for kriscendobot-minion.town). We keep a durable
# per-change failure count in the journal (cursors/failcount/<slug>, keyed to the
# current new_sha); once it reaches GARDEN_TRIAGE_FAIL_THRESHOLD we stop re-triaging
# that sha (one WARN, one maintainer-inbox report, exit 0 so systemd stops flapping).
# A newly-observed new_sha clears the breaker automatically. Mirrors the cascade
# circuit-breaker in ci-watcher.sh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

slug="${1:?usage: triager.sh <repo-slug>}"
GARDEN_TAG="triager/$slug"
: "${GARDEN_REPOS:=$GARDEN_ROOT/repos}"
: "${GARDEN_TRIAGE_HANDLER:=$HERE/handlers/triager-claude.sh}"
: "${GARDEN_WATCH_REF:=}"   # empty → use the bare clone's HEAD branch
# Consecutive-failure circuit-breaker threshold: after this many failures of the
# handler on the SAME new_sha, stop re-triaging that sha (0 disables the breaker).
: "${GARDEN_TRIAGE_FAIL_THRESHOLD:=5}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

BARE="$GARDEN_REPOS/$slug.git"
[ -d "$BARE" ] || die "no bare clone at $BARE (clone the repo first)"

git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"

# resolve the ref to watch
ref="$GARDEN_WATCH_REF"
if [ -z "$ref" ]; then
  ref="$(git --git-dir="$BARE" symbolic-ref --short HEAD 2>/dev/null || echo master)"
fi
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" 2>/dev/null \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref" 2>/dev/null)" \
  || die "cannot resolve ref '$ref' in $slug"

# The poll cursor lives in the JOURNAL (durable + shared), not host-local state,
# so a restarted or failed run resumes from the last committed position.
CURSOR_KEY="activity/$slug"
old_sha="$("$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_sha:[[:space:]]*//p' | head -1)"

if [ "$old_sha" = "$new_sha" ]; then
  log "no change on $slug:$ref ($new_sha)"
  exit 0
fi

# --- consecutive-failure circuit breaker (see the header) --------------------
# Read the durable per-change failure count, keyed to the current new_sha. Kept in
# a SIBLING cursor (cursors/failcount/<slug>), not the main activity cursor, so a
# failure never perturbs last_sha — the main cursor stays at old_sha to re-triage,
# and a newly-observed new_sha clears the breaker for free (its fail_sha won't match).
FAIL_KEY="failcount/$slug"
fail_state="$("$HERE/cursor-get.sh" "$FAIL_KEY")"
fail_sha="$(printf '%s\n' "$fail_state" | sed -n 's/^fail_sha:[[:space:]]*//p' | head -1)"
fail_count="$(printf '%s\n' "$fail_state" | sed -n 's/^fail_count:[[:space:]]*//p' | head -1)"
case "$fail_count" in ''|*[!0-9]*) fail_count=0 ;; esac

# Breaker already OPEN for this exact change: do NOT run the handler again. This is
# the steady state after the threshold trips — quiet, no re-post, no `claude -p`,
# and (crucially) exit 0 so the systemd unit stops flapping.
if [ "$GARDEN_TRIAGE_FAIL_THRESHOLD" -gt 0 ] \
   && [ "$fail_sha" = "$new_sha" ] && [ "$fail_count" -ge "$GARDEN_TRIAGE_FAIL_THRESHOLD" ]; then
  log "circuit-breaker OPEN for $slug:$ref $new_sha ($fail_count consecutive triage failures ≥ threshold $GARDEN_TRIAGE_FAIL_THRESHOLD); not re-triaging until a new change appears"
  exit 0
fi

log "change on $slug:$ref: ${old_sha:-<none>} → $new_sha; triaging"

if "$GARDEN_TRIAGE_HANDLER" "$slug" "${old_sha:-}" "$new_sha" "$BARE"; then
  # Triage succeeded: clear any recorded failure state, then advance the cursor
  # ONLY after triage succeeded, so a crash re-triages.
  if [ -n "$fail_sha" ] || [ "$fail_count" -ne 0 ]; then
    printf 'fail_sha: \nfail_count: 0\ncleared_at: %s\n' "$(date -u +%FT%TZ)" \
      | "$HERE/cursor-set.sh" "$FAIL_KEY" \
      || log "WARN: could not clear failcount for $slug (non-fatal)"
  fi
  printf 'last_sha: %s\nref: %s\nlast_polled_at: %s\n' "$new_sha" "$ref" "$(date -u +%FT%TZ)" \
    | "$HERE/cursor-set.sh" "$CURSOR_KEY"
  log "triaged $slug:$ref up to $new_sha"
  exit 0
fi

# --- handler failed ----------------------------------------------------------
# Increment the durable failure count for this change (reset to 1 on a new sha),
# BEFORE deciding whether to retry or trip the breaker, so the next tick sees it.
if [ "$fail_sha" = "$new_sha" ]; then
  fail_count=$((fail_count + 1))
else
  fail_count=1
fi
printf 'fail_sha: %s\nfail_count: %s\nlast_failed_at: %s\n' "$new_sha" "$fail_count" "$(date -u +%FT%TZ)" \
  | "$HERE/cursor-set.sh" "$FAIL_KEY" \
  || log "WARN: could not persist failcount for $slug (breaker may re-count next tick)"

# Below threshold (or breaker disabled): retry loud, exactly as before — die with a
# nonzero exit so the tick fails and the timer re-invokes.
if [ "$GARDEN_TRIAGE_FAIL_THRESHOLD" -le 0 ] || [ "$fail_count" -lt "$GARDEN_TRIAGE_FAIL_THRESHOLD" ]; then
  die "triage handler failed for $slug ($fail_count/$GARDEN_TRIAGE_FAIL_THRESHOLD consecutive on $new_sha); leaving cursor at ${old_sha:-<none>} to retry"
fi

# At/above threshold: trip the breaker. This failure is the moment it crosses the
# threshold; every subsequent tick takes the "breaker already OPEN" fast path above
# and never reaches here, so the WARN and the maintainer report each fire exactly once.
log "WARN: triage handler failed $fail_count times on $slug:$ref $new_sha (≥ threshold $GARDEN_TRIAGE_FAIL_THRESHOLD); OPENING circuit-breaker — will not re-triage this sha until a new change appears"

# Surface the stuck change to the maintainer ONCE. The report lands in the standing
# inbox/maintainer, which the liaison's maintainer-watch Monitor and the bulletin
# both surface. Sent as a deterministic script (no reply_to): the triager is not a
# living doer. A post failure is non-fatal (we still exit 0 to stop the flap).
mb="$(mktemp)"
{
  printf 'kind: error\n\n'
  printf '# triage circuit-breaker OPENED for `%s`\n\n' "$slug"
  printf 'The triage handler (`%s`) FAILED %s consecutive times on the SAME change\n' "$GARDEN_TRIAGE_HANDLER" "$fail_count"
  printf 'and hit the threshold (`GARDEN_TRIAGE_FAIL_THRESHOLD=%s`).\n\n' "$GARDEN_TRIAGE_FAIL_THRESHOLD"
  printf -- '- Repo slug: `%s`  (watched ref `%s`)\n' "$slug" "$ref"
  printf -- '- Failing range: `%s` → `%s`\n\n' "${old_sha:-<none>}" "$new_sha"
  printf 'Because the transition is deterministic (same old→new SHAs, same diff), retrying\n'
  printf 'cannot help — it only crash-loops the `garden-triager@%s` unit and fills the\n' "$slug"
  printf 'journal. The breaker is now OPEN: this sha will NOT be re-triaged until a NEW\n'
  printf 'change appears on `%s:%s`, which clears the breaker automatically.\n\n' "$slug" "$ref"
  printf 'Investigate the handler failure (reproduce by hand:\n'
  printf '`%s %s %s %s <bare>`), or, if this repo should not be watched\n' "$GARDEN_TRIAGE_HANDLER" "$slug" "${old_sha:-<none>}" "$new_sha"
  printf 'at all, remove it from the watch set. Note: under CLAUDE.md § Monitoring safety\n'
  printf 'constraint only `endojs/endo-but-for-bots` is currently authorized for watching —\n'
  printf 'worth confirming `%s` belongs in the set.\n' "$slug"
} > "$mb"
if GARDEN_SENDER="triager:$slug" "$HERE/inbox-send.sh" maintainer "$mb"; then
  log "posted triage circuit-breaker maintainer-inbox report for $slug ($new_sha)"
else
  log "WARN: could not post triage circuit-breaker maintainer report for $slug (breaker stays open)"
fi
rm -f "$mb"

exit 0
