**Panel round 1 for endojs/endo-but-for-bots PR #348: must-fix**

This was finished last session. I've only checked that the review is still on the PR. Last time the completion line wasn't the final line of the report, so the job came back unrecorded; this report fixes that.

**What was done**
- Made an isolated checkout of the PR head, `endojs/endo-but-for-bots@mirror/2902-dedup-bundle-lite` at `496b4ffa42`.
- Ran `panel.sh` in single-round mode against base `6ee3fda` (`master-6ee3fda`). It exited 0, all 33 seats reported, and the verdict was **must-fix**. My first launch was killed along with its background shell, so I cleaned up the orphaned seats and reran it detached; only the clean rerun's verdict counts.
- Posted the aggregate as review 5479341178 on PR #348 (verified, 14:34:11Z).
  - It is a **COMMENTED** review, not request-changes. GitHub won't let the bot request changes on a PR it opened itself. The review header says the verdict is must-fix and should be treated as request-changes. If the next-stage-owed check looks only at the review state, it may not count this as must-fix.
  - To fit GitHub's 65,536-character limit, I merged 33 identical model-info footer lines into one. All seat findings are posted in full.

**What the panel found**
- **Must-fix:**
  - The PR body doesn't follow the upstream template. A script check caught this before the seats ran, and it alone forces the must-fix verdict.
  - The pruner seat wants the test-count tallies and the mirror-sequencing section removed from the body.
  - The archivist seat wants confirmation that the JSDoc for `makeFunctorFromMap` and `makeScriptFromMap` still exists in `bundle-lite.js`.
- **Should-fix:**
  - An unrelated `ci:` commit, which only edits a version comment, is bundled in without explanation.
  - There is no changeset, and no stated reason why none is needed.
  - No regression test covers the restored `syncModuleTransforms` option.
  - `bundle.js` still has duplicate typedefs that nothing uses.
  - The generated bundle code changes from a `for…of` loop to an indexed loop, which could break saved bundle snapshots or hashes.
- **The code itself:** most seats approved the deduplication as behavior-preserving, and the public API is unchanged.

**Follow-ups:** the gauntlet's fix-loop stage owns the remaining work. If the gauntlet needs a real request-changes review on PRs the bot opened, the garden scripts would need a change.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (1871186 cached reads)
- Output: 9007 tokens
- Cost: $2.1099344
- Wall-clock: 201s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
