All five corrected jobs are on the board (already claimed into `doin/` by the freshly-restarted fleet), inbox is empty, and the result entry is written. The job is complete.

# Completion report

**Investigated and re-posted all 5 poisoned garden-infra jobs; no job re-posted unchanged; one live incident routed to the maintainer.**

## Root cause of the poisoning (shared by all 5)
Not bad job bodies and not the infra they target. A **sustained Claude quota/usage outage** (2026-07-01T00:26–00:50Z, recurring ~2026-07-02T01:20–01:45Z) made every gardener `claude -p` handler exit rc=1 with a transient "claude quota/usage cut" signature. The **reaper counts requeue cycles regardless of transient-vs-deterministic classification** (`GARDEN_REAP_POISON_THRESHOLD=5`), so 5 requeue cycles *inside one outage* poisoned each job. Dozens of unrelated peers (pr96-shepherd, pr394-fixer, pr216-weave, pr587/588/591-shepherd, …) failed identically in the same window — proof it was environmental. The fleet went quiet ~01:34Z until the ~09:54Z restart; the outage has passed, so re-posts are safe. All four `improve-*` target defects were **re-verified still present** against origin/main2, so none is moot.

## Per-job actions
1. **improve-gardener-transient-failure-backoff-and-fleet-brake** — verified: transient block (gardener.sh ~L477) loops to claim with zero `idle_backoff`, no fleet brake. This is the sanctioned fix for the very thrash that poisoned all five. **Re-posted corrected.**
2. **improve-garden-identity-drift-detector** — body correct, and the drift is **still live**: `/home/kris/.garden`=`endolinbot2` vs `hostname -s`/`leader`=`endolinbot` → `is-main-host` returns FOLLOWER and every leader-only singleton is skipped. Existing gardener.sh:98 WARN + scaler reconcile miss it (a `.garden`-file override resolves consistently across workers). **Re-posted sharpened** + **messaged the maintainer** (msg `20260702T100530Z-a43c17`) since the operational fix is on the deployed root, outside a gardener's autonomous scope.
3. **improve-issue-inbox-child-git-reaping** — verified: `garden-issue-inbox.service` has no `KillMode=mixed`/`TimeoutStopSec`. **Re-posted corrected.**
4. **improve-repo-watcher-arm-retry** — verified: repo-watcher.sh ~L141 bare WARN discards rc/stderr, no in-tick retry. **Re-posted corrected.**
5. **build-daemon-rename-to-manager** (project build job; poison report already in `read/`, nothing to archive) — **re-posted corrected** with postmortem header.

Every re-post carries a poison-postmortem header so a future handler won't blindly re-poison during the next quota storm.

## Deliverables
- Journal `result`: `entries/2026/07/02/100639Z-result-gardener-4df0ff.md`
- All 5 corrected jobs on the board (now in `doin/`, claimed by the fleet)
- Maintainer notified of the live `.garden` drift incident

## Follow-ups (for the maintainer)
- **Operational:** correct `/home/kris/.garden` (or re-point the leader marker) and restart the fleet so `is-main-host` flips back to leader — leader-only singletons are currently down on endolinbot.
- **Infra hardening (flagged, not filed):** the reaper poisons after 5 cycles even when all 5 are sustained-environmental transients; pausing the poison counter under the fleet brake (job #1) or classifying sustained-outage transients would prevent this whole mass-poisoning class.

No garden source was landed on main2 (no in-worktree code change was warranted; the one actionable live defect is operational).
