---
role: builder
tier: mentat
dispatch: manual
---
**Role: builder.** Build host-local read/write locks for the garden's upstream branches (`origin/journal2`, `origin/main2`) in `kriscendobot/garden`, landing direct to `main2` per the garden's no-self-PR convention.

Maintainer ask (kriskowal, liaison session 2026-09-29): "We should probably entertain host-local read and write locks for the upstream garden branches, such that we can coalesce fetches and compare-and-swap operations and refrain from concurrent git operations on a particular repository, and also to accept a recent fetch as sufficiently fresh."

Goals:
1. **Per-repository serialization.** A host-local lock keyed by repository (git dir). Many scripts touch the same repo at once: the shared root `$GARDEN_ROOT/.git` + `journal/` worktree, and the per-id `$GARDEN_STATE/*/journal` clones. Concurrent git operations on one repo must not run at once. Reads (fetch, rev-parse of a remote ref) take a shared lock. Writes (the CAS push, ref updates, gc/repack) take an exclusive lock.
2. **Coalesced fetches.** When a fetch of `origin/<branch>` is already in flight, or finished within a freshness window, later callers wait for it or reuse it. They must not start their own fetch. Record the last successful fetch time per (repo, remote, branch) host-locally.
3. **Freshness acceptance.** Add a caller-selectable max-age (a sensible default plus a per-call override) so a recent fetch counts as fresh enough. Callers that must see the true tip, like the claim CAS and is-main-host leader checks, can demand a fresh fetch. Stale reads must never be passed off as fresh; see memory "garden-state-clone-bloat-wedge", where a capped fetch silently served stale refs.
4. **Coalesced CAS.** Push-as-CAS (claim-job, post-job, set-* config writers, the journal CAS helpers in `scripts/jobs/common.sh`) runs fetch→rebase→push under the exclusive lock, so same-host racers queue instead of spending retries against each other. Cross-host racing stays on the push CAS, unchanged.

Constraints: flock-based, with no new daemon. Lock files go under `$GARDEN_STATE` (host-local, never in the journal). Put timeouts on every lock wait so a hung git can't wedge the fleet. Detect stale holders and log them. Keep the fail-open/fail-closed semantics that exist today (read the callers). Before editing, survey every git fetch/push call site in `scripts/jobs/` and route them through one helper in `common.sh`. Don't re-implement the helper per script. Watch out for the garden-root-repo-guard, deploy-garden.sh and gc/maintain paths, which also touch the root repo.

Deliverables: the helper in `common.sh`, migrated call sites, a guard/test script exercising contention (parallel fetchers coalesce to one fetch; parallel CAS writers serialize; the freshness window is honored; a demand-fresh caller refetches; lock timeouts behave), and a short design note in `designs/`. Report the measured fetch reduction on a live host if you can.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T00:03:05Z
