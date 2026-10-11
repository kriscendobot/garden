I applied the panel-2 must-fix items on PR #181, kriscendobot/minion.town, and CI is green (`ci-wait-merge` rc 0, 3 of 3 checks passed).

**Must-fix items:**
- **archivist:** the usage text of `git-remote-partition.sh unpublish` split the design reference `designs/git-remote-served-clip.md § 6` across two lines. It is now on one line.
- **integrator:** the PR body claimed Phase `deliverable` while also saying the headless-browser coherence run that design § 10 requires is missing. I relabeled the Phase as `orchestrated-slice` and added a `Successor:` line. That line names a new parked job, `minion-town-git-remote-served-clip-browser-coherence` (deferred, arc `minion-town-git-remote`, role builder), which owns the browser run. The PR stays draft.
- **pruner:** I edited the PR body:
  - removed the "What changed" section;
  - dropped the review-inversion sentence from "Choices";
  - shortened the tree-construction bullet in "Gaps".

  The body went from about 464 words to 310.

**Saboteur should-fix items, also done:**
- **Revocation timing:** the help for `unpublish` and `purge-root`, and the served-clip section of `DEPLOYMENT.md`, now give the full delay. A purged or unpublished clip can be served for up to the marker sweep period plus the gateway's partition cache TTL, about 35 s at the defaults. Copies under `/.content/` that browsers or intermediate caches already hold cannot be recalled.
- **Destroy race:** `writeServedState` now checks the partition again after writing and removes the file if a `destroy` happened during the write. `addPendingMarker` now refuses an unknown partition, so it can't leave a ghost pending entry. A new test in `capability.test.ts` covers both.
- **In-flight marker leak:** no change needed. `runHttpBackend` already calls `onComplete` exactly once on the spawn-error path.

**Commit and checks:** the changes are in commit `4922ce7`, pushed to `git-remote-served-clip` with `safe-push-pr-head.sh` (a88c2ed → 4922ce7). Typecheck passes. 141 of 142 git-remote tests pass locally. The one failure is `capability.test.ts` "propagates a git failure", which the PR body already notes fails locally on the unmodified head and passes in CI.

**Follow-up:** the browser coherence observation is owned by the parked job `minion-town-git-remote-served-clip-browser-coherence`. The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1554370 cached reads)
- Output: 8604 tokens
- Cost: $1.0317860000000003
- Wall-clock: 1640s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
