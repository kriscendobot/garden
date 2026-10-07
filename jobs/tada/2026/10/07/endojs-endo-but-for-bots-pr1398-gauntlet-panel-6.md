Panel round 6 on PR #1398 came back **must-fix**. I posted the review: https://github.com/endojs/endo-but-for-bots/pull/1398#pullrequestreview-5442407560

**How it ran**
- I reviewed against the PR's actual base commit, `0e0b333c`. The changed-file list matched GitHub's (8 files).
- The head under review is `87c7516d`.
- `panel.sh` ran in single-round mode and exited 0. It used the code panel, and all 34 seats came back without errors.
- The review is posted as a COMMENT with a `disposition: must-fix` header, because GitHub blocks request-changes on the bot's own PR.

**Votes:** 6 request changes (breaker, changeset-auditor, integrator, packager, prover, releaser), 14 comment-only, 14 approve.

**Round 5's main blocker is resolved.** Round 5 asked whether the collection-tombstone mechanism is needed at all. The new head deletes it, and the decomplector seat agrees with removing it.

**What still needs fixing:**
1. **Tests (prover, must-fix):** The collected-formula test doesn't actually trigger the race the fix targets. Nothing tests the startup case, where a lookup waits until the daemon finishes loading its saved formulas (`formulaGraphSeeded`). Nothing tests a formula saved before a restart and looked up afterward either.
2. **Commit grouping (integrator, must-fix):** The history adds `collection-tombstones.js`, reworks it, then deletes it. It should be regrouped into three commits: a `fix` with its test, a `feat` for the SturdyRef kit, and the separate `yarn.lock` chore.
3. **Changeset (packager, changeset-auditor, releaser):** It should describe only the fix users can see, and the internal-feature paragraph should be dropped or justified. Two more things: confirm that `patch` is the right bump level, and put one sentence per line.
4. **Should-fix:**
   - `persistGitRemoteState` can still put a collected formula back into memory.
   - The `DaemonCoreExternal` type doesn't list `sturdyRefForFormula` or `formulaIdOf`.
   - Someone should confirm the write at `manager.js:637` also updates the in-memory map.

I made no garden or project commits; this stage only reviews. Per the job, I didn't fix anything or un-draft the PR. The next gauntlet stage handles fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (854867 cached reads)
- Output: 5726 tokens
- Cost: $0.7500374
- Wall-clock: 293s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
