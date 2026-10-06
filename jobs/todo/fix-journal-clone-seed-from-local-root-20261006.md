---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Fresh journal2 clones from GitHub now time out across the fleet.** Fix how the garden creates its journal clones (kriscendobot/garden, main2).

**Evidence.** At 01:22Z on 2026-10-06, endolin-garden2-5bcdff64 was promoted to leader. From then until about 02:40Z, every leader-only service whose `$GARDEN_STATE/<name>/journal` clone was missing or two weeks stale reported itself "offline" (rc=75):
- Fresh clones of `git@github.com:kriskowal/garden.git` (journal2) timed out after 300s, with `fetch-pack: unexpected disconnect while reading sideband packet`. This hit rolling-deploy, orch, deadmail, design-pr-gauntlet-audit, follow-up, mirror-closer, comment-latency-watch, worker-derotate, mentor, budget-refresh, and the per-job `inbox/<job>/journal` clones.
- Catch-up fetches on clones stale since 09-23 timed out at 45s (foreman, deadline-nudge, requirements-watch, reaper, scheduler).
- Each aborted fetch left a `tmp_pack_*` behind; the foreman clone had 570 MiB of them.

The liaison worked around it by hand. It seeded each clone from the host's own root repo (`git fetch --depth=50 file://$GARDEN_ROOT/.git +refs/remotes/origin/journal2:refs/remotes/origin/journal2`; for an existing shallow clone, add `--update-shallow`). After seeding, the network fetch took 6–8s.

**Fix.**
1. Make the shared clone helper in `scripts/jobs/common.sh` (around line 3152) seed new journal2 clones from the local `$GARDEN_ROOT/.git`, shallowly. Use the network only for the incremental top-up.
2. When a capped fetch on a stale clone fails, re-seed it the same way rather than reporting offline forever.
3. Delete stray `tmp_pack_*` files on each attempt.
4. Note that the per-host clone URL is still the old `kriskowal/garden` redirect.

Add regression tests. Land on main2.
