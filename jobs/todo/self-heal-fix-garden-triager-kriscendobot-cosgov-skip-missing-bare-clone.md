In `scripts/jobs/triager.sh` line 32, the missing-bare-clone check `[ -d "$BARE" ] || die "no bare clone at $BARE (clone the repo first)"` fails the whole service (exit 1) on any host that lacks a per-host bare clone for a repo that is armed in the shared `journal/repos/` watch set. Because the watch set is shared journal state across the multibot fleet but bare clones are per-host, every armed triager on a host with an empty `repos/` (like this one — `repos/` is empty, 8 forks armed) fails every timer tick and churns self-heal (observed: `garden-triager@kriscendobot-cosgov` FATAL "no bare clone at /home/kris/garden2/repos/kriscendobot-cosgov.git").

Change line 32 to a **graceful skip** instead of a fatal error, mirroring the already-established precedent in the sibling producer `scripts/jobs/comment-watcher.sh:312`, which logs `note: no bare clone at $BARE ...` and continues rather than dying. Replace:

  [ -d "$BARE" ] || die "no bare clone at $BARE (clone the repo first)"

with a log + clean `exit 0`, e.g.:

  [ -d "$BARE" ] || { log "no bare clone at $BARE on this host; skipping (another fleet host holds the clone, or clone on demand)"; exit 0; }

This makes a host that hasn't cloned a shared-watch-set fork a quiet no-op — the correct behavior for the leader/follower fleet where the watch set is shared but clones are per-host — while hosts that DO hold the clone keep triaging normally. Verify the exit-0 path with a triager run against a slug whose `$GARDEN_REPOS/<slug>.git` is absent (should log-and-exit-0, not fail). Keep the fetch-failure `die` on line 34 unchanged (that is a real error when a clone exists).
