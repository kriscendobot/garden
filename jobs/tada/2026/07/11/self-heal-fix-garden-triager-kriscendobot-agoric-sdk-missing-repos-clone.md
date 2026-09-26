Completion report:

## Self-heal: garden-triager own-fork "no bare clone" FATAL

**Outcome:** Diagnosed to root cause; confirmed the durable fix is already landed and tested on `main2`; escalated the one remaining step (a drained deploy) to the liaison/maintainer. No code change was needed from this job, and no risky stopgap was applied.

### What I found
The job's premise (provisioner not tracked; `GARDEN_REPOS=repos` mismatch; FATAL on missing clone) had **already been repaired on `main2` by peer gardeners** before this job ran:
- `scripts/jobs/fork-watch-provisioner.sh` + its test are tracked on `main2`; I ran the test → **16/16 pass**.
- The provisioner is wired into the tick path at `repo-watcher.sh:47-49` (runs at the top of every reconcile), materializing into the same `worktrees/` shelf the triager reads.
- `triager.sh`, `comment-watcher.sh`, and `fork-watch-provisioner.sh` now all default `GARDEN_REPOS` to `worktrees/` (was `repos/`), and a missing clone is a **clean skip**, not a FATAL.

**Why the FATAL still storms:** the deployed root (`/home/kris/garden2`) is ~56 commits **behind** `origin/main2`. It still runs the old `triager.sh` (`GARDEN_REPOS=$GARDEN_ROOT/repos`), so `garden-triager@{agoric-sdk,cosgov,endo,finbot}` FATAL every tick looking for `repos/<slug>.git`, which never existed. `upgrade-ready` is set; the deploy is simply pending (it's liaison-Monitor-triggered, not a systemd unit, and DEFERs while gardeners are mid-job).

**Simplifying fact:** all 8 armed own-fork bare clones now exist under `worktrees/<slug>.git` (the 3 formerly-missing — cosgov, ocapn, agoric-3-proposals — were cloned by a peer during diagnosis, verified as valid bare clones). So once `main2` deploys, every triager finds its clone under `worktrees/` and ticks cleanly; the provisioner's MATERIALIZE is a no-op. **No stopgap materialization is needed.**

### What changed
- Nothing to commit — the fix is entirely upstream on `main2`; my worktree was clean.
- Sent a full diagnosis + action request to the maintainer/liaison inbox (`20260711T013139Z-f3a920`).

### Why I did not apply the `repos/` stopgap
Under the currently-deployed old code, materializing `repos/<slug>.git` would flip each own-fork (including the massive `agoric-sdk`) into an **unbounded full-history first-observation `claude -p` triage** (empty cursor → `git log` with no range) — a larger, less predictable action than the throttled, circuit-broken FATAL. The deploy is the clean resolution.

### Follow-up (owner: liaison/maintainer — outside a gardener's execution surface)
Run `scripts/jobs/deploy-garden.sh` when the fleet is quiet. A gardener cannot run it (it drains the fleet including itself, and it's triggered only by the deploy-on-upgrade Monitor). After it lands, `garden-triager@kriscendobot-agoric-sdk` and its 7 siblings reach `no change`/`triaged …` instead of the `no bare clone` FATAL.
