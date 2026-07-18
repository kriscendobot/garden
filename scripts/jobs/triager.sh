#!/bin/bash
# triager.sh — per-repo producer. Watch one repo for changes and post jobs.
#
# Usage: triager.sh <repo-slug>          e.g. kriscendobot-endo
#
# One timer-driven instance per watched repo. It fetches the repo's bare clone
# under $GARDEN_REPOS/<slug>.git (the garden's standing bare clones, kept in
# $GARDEN_ROOT/worktrees/<slug>.git per CLAUDE.md § Layout), diffs the watched
# refs against a last-seen
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
: "${GARDEN_TRIAGE_HANDLER:=$HERE/handlers/triager-claude.sh}"
: "${GARDEN_WATCH_REF:=}"   # empty → use the bare clone's HEAD branch
# Consecutive-failure circuit-breaker threshold: after this many failures of the
# handler on the SAME new_sha, stop re-triaging that sha (0 disables the breaker).
: "${GARDEN_TRIAGE_FAIL_THRESHOLD:=5}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

BARE="$(bare_clone_dir "$slug")"   # $GARDEN_ROOT/worktrees/<slug>.git (GARDEN_REPOS override honored)
# The watch set is journal-shared across hosts, but bare clones are host-local, so a
# host that arms this timer need not already hold the clone. The triager needs a local
# clone to diff refs against its cursor (unlike comment-watcher.sh, which polls via
# gh), so a missing clone must never be a hard die — that drove an every-tick systemd
# failure/restart on any clone-less host.
#
# DEFAULT (self-provision OFF): a clone-less host is a benign no-op — the host that
# holds the clone triages this repo. This is the just-landed skip-model (case I in the
# test guards the default resolving under worktrees/), so a missing clone stays a clean
# skip unless a host explicitly opts in.
#
# OPT-IN (GARDEN_TRIAGE_SELF_PROVISION=1): some watched repos have no clone on ANY host
# (ocapn, agoric-3-proposals, cosgov), so a plain skip leaves them un-triaged forever.
# When a host opts in, SELF-PROVISION the standing bare clone here, reusing the same
# derive-URL + bounded-atomic-clone logic clone-keeper.sh uses to re-create a vanished
# tracked clone (worktrees/<owner>-<name>.git → $GARDEN_CLONE_URL_BASE/<owner>/<name>.git),
# then fall through to the normal fetch. If the upstream is unreachable, skip cleanly
# (exit 0) so the next tick retries — no crash loop; a persistently unreachable or an
# underivable source escalates to the maintainer inbox rather than dying forever.
#
# The guard is `! is_own_git_repo "$BARE"` (not `[ ! -d "$BARE" ]`), mirroring
# keep_clone: it also catches a present-but-CORRUPT dir (a path that exists but is not
# its OWN bare git repo — a half-populated clone, a leftover dir, a plain file). Such a
# dir may hold un-pushed local state, so we SURFACE it and NEVER clobber it with a
# re-clone (exactly as keep_clone does) and skip cleanly rather than falling through to
# a `git fetch` that would hard-die every tick and crash-loop the unit.
if ! is_own_git_repo "$BARE"; then
  if [ -e "$BARE" ]; then
    # Present-but-corrupt: surface for manual reconciliation, do NOT re-clone (it may
    # hold un-pushed local state), do NOT die (a fetch on a non-repo dir crash-loops
    # the unit). Skip this tick; a human restores or removes it. Matches keep_clone.
    cmsg="triager: bare clone path $BARE for $slug exists but is not a git repo; needs manual reconciliation (not clobbering). $slug is not being triaged until it is restored."
    log "STALE: $cmsg"
    alert_maintainer "triager-clone-corrupt-${slug//[^A-Za-z0-9._-]/_}" "$cmsg"
    exit 0
  fi
  if [ "${GARDEN_TRIAGE_SELF_PROVISION:-0}" != 1 ]; then
    log "no bare clone at $BARE on this host; skipping triage (a host that holds the clone triages this repo)"
    exit 0
  fi
  if src="$(derive_clone_url "$BARE")"; then
    if bounded_clone "$src" "$BARE"; then
      # A fresh bare clone carries no fetch refspec; set it exactly as
      # ensure-project-worktree.sh / WORKTREES.md prescribe so the fetch below (and
      # any worktree later cut from this clone) tracks origin/* rather than freezing.
      git -C "$BARE" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' || true
      log "provisioned missing bare clone $slug at $BARE from $src"
    else
      # The source is known but the clone did not complete — usually transient
      # (offline, DNS, a half-open connection reaped by the timeout), so we do NOT
      # wedge: skip and retry next tick. A PERSISTENTLY unreachable source (deleted
      # fork, wrong owner/name, firewalled) would otherwise re-warn every tick into a
      # log nobody reads, so it ALSO escalates — alert_maintainer is throttled per
      # dedup key and never fails its caller, so a blip alerts at most once per window.
      pmsg="triager: bare clone for $slug is MISSING at $BARE and the self-provision clone from '$src' failed (unreachable/offline?). Retried next tick; if this persists the source is bad (deleted fork, wrong owner/name, or firewalled) and $slug cannot be triaged until it is restored."
      log "WARN: $pmsg (skipping this tick)"
      alert_maintainer "triager-provision-failed-${slug//[^A-Za-z0-9._-]/_}" "$pmsg"
      exit 0
    fi
  else
    # The slug does not fit <owner>-<name>, so no upstream URL can be derived and the
    # clone can never self-heal on any tick. Escalate (once, throttled) so a human
    # restores the clone or fixes the watch entry, rather than skipping silently forever.
    nmsg="triager: bare clone for $slug is MISSING at $BARE and no upstream URL could be derived from the slug (expected <owner>-<name>). It cannot be auto-provisioned — add the clone by hand or fix the watch entry; $slug is not being triaged until then."
    log "STALE: $nmsg"
    alert_maintainer "triager-provision-nourl-${slug//[^A-Za-z0-9._-]/_}" "$nmsg"
    exit 0
  fi
fi

# Steady-state clone refresh. git has no IO timeout of its own, so a half-open
# SSH fetch can hang until systemd kills it and marks the unit Failed. Keep its
# diagnostic in a file: the transient matcher deliberately distinguishes a
# connectivity blip from a malformed local clone or remote configuration.
ERRF="$(mktemp)"
trap 'rm -f "$ERRF"' EXIT
fetch_rc=0
if timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT" \
     git --git-dir="$BARE" fetch -q --all --prune 2>"$ERRF"; then
  :
else
  fetch_rc=$?
fi
if [ "$fetch_rc" -ne 0 ]; then
  # timeout returns 124 when it sends SIGTERM and 137 when its kill-after
  # escalation is needed. 143 additionally covers a terminated fetch reported
  # by a wrapper. All are transient stalls, just like a recognized network error.
  if [ "$fetch_rc" -eq 124 ] || [ "$fetch_rc" -eq 137 ] || [ "$fetch_rc" -eq 143 ] \
      || is_transient_net_error "$ERRF"; then
    log "WARN: transient fetch failure for $slug; skipping this tick (retry next tick)"
    exit 0
  fi
  die "fetch failed for $slug"
fi

# resolve the ref to watch. --verify -q keeps a missing primary ref from echoing its
# unresolved name to stdout (which the `||` fallback would then glue onto the real SHA —
# the two-line new_sha that produced the "ambiguous argument" fatal on bare clones whose
# refs are not under refs/remotes/origin/, e.g. kriscendobot-agoric-sdk). The ^{commit}
# peel also normalizes an annotated-tag ref to its commit before the downstream diff.
ref="$GARDEN_WATCH_REF"
if [ -z "$ref" ]; then
  ref="$(git --git-dir="$BARE" symbolic-ref --short HEAD 2>/dev/null || echo master)"
fi
if ! new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref^{commit}")"; then
  # An EMPTY / unborn-HEAD bare clone (zero refs) has nothing to resolve: the fetch at
  # line ~117 succeeds with nothing to fetch, and this is the own-fork auto-provisioning
  # path (fork-watch-provisioner) racing a fork that was created upstream but not yet
  # populated. Treat it like the missing-clone branches above — "no content to triage
  # yet", skip this tick with exit 0 — rather than die-ing (exit 1 fails the systemd unit
  # and triggers self-heal churn every tick until the fork gets its first commit). It
  # self-heals the moment a commit lands and a ref appears.
  if [ -z "$(git --git-dir="$BARE" for-each-ref --count=1 2>/dev/null)" ]; then
    log "$slug is empty (unborn HEAD, no commits yet) — skipping this tick"
    exit 0
  fi
  # A clone that HAS refs but still cannot resolve the watched ref is a genuine
  # misconfiguration (wrong GARDEN_WATCH_REF, deleted branch — the agoric-sdk scenario
  # the fallback above targets); keep the loud escalation so it is not masked.
  die "cannot resolve ref '$ref' in $slug"
fi
# Fail loudly on a poisoned new_sha rather than handing a bad revision downstream.
# `--verify -q` (above) already keeps a failed rev-parse from echoing its unresolved
# argument to stdout, so this should always hold; the assert is a cheap tripwire that
# catches any future regression (e.g. a dropped -q gluing 'refs/…\n<sha>' together)
# at the source instead of as an "ambiguous argument" fatal deep in the handler.
[[ "$new_sha" =~ ^[0-9a-f]{40}$ ]] \
  || die "resolved a malformed new_sha for '$ref' in $slug (want a single 40-hex SHA, got: $(printf '%q' "$new_sha"))"

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
if GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="triager:$slug" "$HERE/inbox-send.sh" maintainer "$mb"; then
  log "posted triage circuit-breaker maintainer-inbox report for $slug ($new_sha)"
else
  log "WARN: could not post triage circuit-breaker maintainer report for $slug (breaker stays open)"
fi
rm -f "$mb"

exit 0
