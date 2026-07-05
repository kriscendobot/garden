The fix landed on `origin/main2` as `1e9f4a957`. Notably, the immediately preceding commit `c5b61affc` is a complementary handler-side fix (kill a live predecessor before re-entering the worktree) — the two guards close the corruption from both ends and my rebase was clean (no file overlap).

Here's my completion report.

---

**Job: fix the reaper data-corruption bug (two live writers in one worktree)**

**Root cause.** The reaper treated any claim past `GARDEN_CLAIM_TTL` as dead, trusting the gardener's invariant `GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL`. But the reaper and gardener read `GARDEN_CLAIM_TTL` in separate processes and nothing enforces that ordering — set it below the handler wall (the reported ~18-min requeue vs ~40-min wall) and the reaper requeues a claim whose handler is still running. A fresh gardener re-claims the same base, re-enters the same persisted per-job worktree, and two handlers write one tree.

**What I changed** (`scripts/jobs/reaper.sh`):
1. **`reap_age_threshold()`** re-derives the invariant *at reap time*: a claim is never considered stale before the maximum lifetime its handler could hold — the effective handler budget (the job's `handler-timeout:` header, else `GARDEN_HANDLER_TIMEOUT`, clamped the way the gardener clamps it) + `GARDEN_HANDLER_KILL_AFTER` + a `GARDEN_REAP_SAFETY_SLACK` (30s). So a misconfigured-low `GARDEN_CLAIM_TTL` can no longer requeue a live handler, and the bad config is logged. This is host-agnostic, so it also covers follower claims the reaper can't inspect.
2. **Live-handler guard** (defense-in-depth for a wedged `timeout` supervisor): before requeuing, probe *this host* for a live handler subtree working the base (any process whose argv carries the doin job-file path, excluding the reaper's own subtree). If alive, SIGTERM → grace → SIGKILL the subtree (mirroring the existing stuck-fetch janitor) and **defer** the requeue one tick — kill-and-wait, so the requeue lands against a settled single-owner tree.
3. Added three knobs (`GARDEN_HANDLER_TIMEOUT`, `GARDEN_HANDLER_KILL_AFTER`, `GARDEN_REAP_SAFETY_SLACK`) with defaults matching `gardener.sh`. The reap-now hint path (handler already confirmed dead) still bypasses the age floor; the live-handler guard runs uniformly and finds nothing there.

**Test** (`scripts/jobs/test/reaper-live-handler-guard-test.sh`, new, hermetic): FLOOR (a bad-low TTL cannot reap below the handler's max lifetime), HEADER (a longer `handler-timeout` raises the floor above TTL), LIVE-GUARD (a live handler past the floor is killed and its claim deferred, not requeued). 3/3 pass. Existing `reaper-poison-park-test.sh` still 5/5. `bash -n` and `shellcheck -x` clean on my additions.

**Landed:** commit `1e9f4a957` on `origin/main2` (pushed via rebase CAS).

**Follow-ups / notes:** A peer landed a complementary handler-side fix (`c5b61affc`, "kill a live predecessor in the worktree before re-claiming") in the same window — it guards the re-claim end while mine guards the requeue end; together they close the hole from both sides, and the rebase was clean (no file overlap). The reaper's live-handler probe is inherently host-local (leader-only reaper); the age-floor is the cross-host guard, which is the correct division since a re-claim only corrupts when it lands on the original handler's host and shares its persisted worktree.
