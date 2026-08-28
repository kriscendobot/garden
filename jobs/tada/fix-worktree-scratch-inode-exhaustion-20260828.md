Everything is clear now. Final state understood:

- **Fleet is NOT drained** — no drain marker exists. The emergency response used the **foreman brake** (`config/foreman-brake` on journal2, currently BRAKED), which stops only the autonomous pump while letting existing gardeners claim/finish. This host is the leader. I did not touch the drain or the brake.
- **Remaining legacy worktrees** are exactly the ones I deliberately kept: the 5 open-PR orphans, `endojs-endo/llm`, and two tiny finbot panel dirs.

The work is complete. Writing my report.

---

## Completion report — `fix-worktree-scratch-inode-exhaustion-20260828`

**Situation on arrival.** By the time I sampled (14:12), inode headroom had already recovered substantially from the razor-thin ~75K at claim time — `df -i /` showed ~26.6M free (11%), and the byte-space was never the issue (1TB free). The emergency relief noted in the job had held. So this was a careful root-cause sweep, not a live firefight.

**Root cause confirmed (in code, not just by sampling).** Per-job worktrees are created keyed by job base but **never torn down on completion**: `complete-job.sh` has no worktree-removal step, `ensure-project-worktree.sh` is deliberately deterministic-recreate (so a reaper requeue resumes in place), and the reaper only touches doom counters. Each project worktree carries a full ~130K-file `node_modules`, so they accumulate without bound.

**What I deleted (verified safe, biggest-first).** All were confirmed *orphaned* — their `.git` files point at pre-move gitdirs (`/home/kris/worktrees/…`, `/home/kris/repos/…`) that no longer exist, and none appear in any bare repo's live `git worktree list` (the current scheme registers only `scratch/project-wt-*`). I cross-checked every candidate against live GitHub PR state and the `doin/` board:

- **endo-but-for-bots legacy worktrees for MERGED/CLOSED PRs**: `gardener-fixer-442`, `pr442-rebase`, `pr442-retcon-feedback`, `cas-plan-pr442` (PR 442 merged); `pr513-gauntlet` (merged); `port-pr57` (closed); `pr405-retcon`, `pr528-gauntlet`, `pr507-fixer` (merged); `fix-cjs-bundle-deferred-c58` (PR 58 merged).
- **Retired v1 monitor worktrees** (the `monitor` role is retired → triager+watchman): `watch-endo-but-for-bots--monitor--*`, `watch-endo--monitor--*`, `watch-agoric-sdk--monitor--*`, `watch-cosgov--monitor--*`.
- **`scratch/endo-pin-pr53`** — a standalone clone (own `.git`) for CLOSED PR 53, last touched before the incident, in no `doin/` job. Its only working-tree "change" was a mode-bit flip (100644→100755) with zero content and no unpushed commits — verified before removal.

**Reclaimed: ~896,000 inodes** (sum of measured file counts of the deleted trees; the raw `df -i` deltas of +583,871 then +135,563 understate it because gardeners were concurrently creating files during the sweep).

**What I deliberately did NOT delete:**
- **5 open-PR legacy worktrees** — `shepherd-461` (PR 461 OPEN), `pr472-shepherd` (472), `pr438-fixer` (438), `pr96-finish` (96), `shepherd-514` (514). The job forbids deleting open-PR worktrees. **Note for the maintainer:** these are *also* fully orphaned (dead gitdirs, pre-move path) and provably not active workspaces (all live work is in `scratch/project-wt-*`), yet they hold **~452K inodes**. The no-open-PR rule's rationale ("might still be reviewed/rebased there") is physically impossible for a broken-git orphan. If you authorize it, deleting these five would roughly *double* the reclaim. I left them per your explicit instruction.
- **`endojs-endo/llm`** (~44K files) — orphaned but semantically significant; flagged rather than removed.
- **`scratch/gardener-wt-*`** (57 dirs, ~100K files, mostly ~1.2K each — the garden repo has no node_modules) — these are *registered garden-root worktrees*; removing them cleanly needs `git worktree remove/prune` on `$GARDEN_ROOT/.git`, which the worker spine forbids me from touching. One anomaly worth a look: `gardener-wt-…-pr881-gauntlet` has 35,964 files (a stray node_modules/build in a garden worktree that shouldn't have one).
- **`scratch/tmpexec`** (87K files) — **live** (parent mtime updating in real time as agent-tools mounts are created); left untouched.

**Standing practice (ask #4) — yes, this must be systematized.** I posted a **high-priority follow-up plan job** `implement-worktree-teardown-on-job-completion` specifying both halves of the durable fix: (1) terminal-state teardown in `complete-job.sh`/reaper via `git worktree remove` (guarded so requeue-eligible jobs are never removed); (2) a leader-only scheduled safety-net sweep (like `groom-parked-job-queue`) that removes orphaned + merged/closed-PR worktrees after live GitHub verification, running even under drain; plus a `df -i` headroom alert so this is caught *before* 0 free, not after.

**Drain status (ask #5) — I did NOT lift anything.** Correction to the job's premise: the fleet is **not currently drained** — there is no drain marker, and `drain-fleet.sh status` reports "not draining." The active throttle is the **foreman brake** (`config/foreman-brake`, currently BRAKED), which stops only the autonomous pump while gardeners keep claiming; active `doin/` jobs and gardeners 1–4 are running. I left the brake untouched. **Readiness:** inode pressure is resolved (~26.98M free, 89% used); nothing blocks lifting the brake from an inode standpoint. The decision to clear the brake is yours/the liaison's.

**Recommended next decisions for the maintainer:** (a) authorize deleting the 5 open-PR orphans (+~452K inodes) and `endojs-endo/llm`; (b) promote the `implement-worktree-teardown-on-job-completion` follow-up; (c) clear the foreman brake when ready.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-worktree-scratch-inode-exhaustion-20260828.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 51 tokens (1969910 cached reads)
- Output: 38575 tokens
- Cost: $2.7918370000000006
- Wall-clock: 599s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
