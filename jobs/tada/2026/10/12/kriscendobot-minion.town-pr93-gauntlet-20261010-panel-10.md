PR #93 (kriscendobot/minion.town) failed panel round 10 with a **must-fix** verdict. I posted the result to the PR as a review.

**What ran**
- I made a separate checkout of the PR head, `feat/clip-content-store-gc` at `c49849aa`.
- The panel ran one round against base `main-c9a073c` and printed `code-panel single-round — must-fix` as its result. Its exit code wasn't saved because I ran it in the background, but it finished cleanly. All 34 seats returned a verdict, and the decider left no errors.
- 4 seats approved, 29 commented only, and 1 requested changes.

**Why it's must-fix:** only the saboteur seat requested changes, with three should-fix findings:
1. **One missing site directory can stop every GC run.** The real daemon source most likely throws when a directory is gone instead of returning `undefined`. If so, `--drop-unresolved` can never remove a dead record either. The tests only use a fake source that returns `undefined`.
2. **A restore after a failed quarantine can bring back a stale blob.** It can overwrite a freshly re-written blob with the old copy and its old timestamp, which undoes the grace-period protection.
3. **One stray file in `vhosts/` stops GC for every tenant.** Any `*.json` there whose name isn't a valid record id makes the listing throw.

**Other repeated should-fix points from comment-only seats:**
- The process-id liveness check on quarantine files breaks if the id is reused or the run is in another container. Both the assessor and decomplector raised it; the decomplector suggests a lock instead.
- When the sweep refuses, it tells the operator to run `--excise-unreadable`, but that command rejects records that resolve to nothing.
- `BlobInventoryEntry.blobId` is optional, but code relies on it always being set for blobs.
- Commits outside the GC feature are in the PR, and the history includes commits that undo each other.
- `DEPLOYMENT.md` is unclear about whether `daemon-reload` is needed.

**Checks that fired**
- The new-mechanism check seated the decomplector, which judged the GC justified: the maintainer approved it in PR #89.
- The repeat check flagged `content-gc.ts` as the target of must-fix findings in both of the last two rounds (heads `e0cc943a`, `9adb2e40`).

**About the posted review**
- GitHub won't let the bot request changes on its own PR, so it went up as a comment review headed "Panel round 10 — must-fix", the same way rounds 8 and 9 were posted.
- I shortened it to stay under GitHub's size limit. The 9 comment-only seats left out are named at the end of the review: migrator, engine-realist, wire-watcher, prover, integrator, purist, fast-checker, corner-prober and spec-keeper.

I made no fixes and no garden commits, and the PR is still a draft. The next step is the fix stage, which the gauntlet driver will post.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-panel-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (835015 cached reads)
- Output: 5566 tokens
- Cost: $0.8049870000000001
- Wall-clock: 268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
