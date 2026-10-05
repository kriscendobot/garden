Round 3 of the panel on endojs/endo-but-for-bots#1391 came back **must-fix**, and the review is posted.

**Run:** I checked out the PR head `740f94e9b2` in an isolated project worktree. I ran `panel.sh` in single-round mode against the base commit `ef4662f04b57`, not the base branch name. It exited 0 with disposition `must-fix`. 33 seats ran and the run record is at `panel-runs/endojs-endo-but-for-bots-1391/1226daaf3d0c.md`.

**Seat results:**
- **Request-changes (4):** packager, purist, integrator, pruner.
- **Comment-only (9):** stylist, archivist, breaker, engine-realist, benchmarker, scribe, gateway, corner-prober, fast-checker.
- **Approve (20):** all other seats.

**What the PR still needs:**
1. **must-fix (packager; integrator agrees):** `.changeset/ses-permit-sturdyref.md` doesn't mention the newest shape-check rule. Since `740f94e9b2`, lockdown also requires the `prototype` to be non-writable and non-configurable.
2. **should-fix (purist):** the shared `SturdyRef` shim looks up `Promise`, `TypeError` and `WeakMap` from the global scope when it runs. Code in the main compartment can replace them afterwards, which changes `enliven` in every compartment. The fix is to capture them when the module loads, plus a regression test.
3. **should-fix (purist):** either explain why `HandledPromise` and `SturdyRef` are treated differently or make them consistent. Separately, either link the generic first-wins table to its validator or handle `SturdyRef` openly as a special case.
4. **should-fix (integrator):** drop the four daemon commits that undo each other (`e703fad05d`, `d6d07ab446`, `14381fc8f5`, `0ebeab85eb`). Fold the fix-up and docs commits into the commits they amend.
5. **summary-fix:**
   - The pruner wants the open-threads section and the empty template sections cut from the PR body.
   - The scribe notes that `740f94e9b2` has no completion-summary comment.

**Review:** https://github.com/endojs/endo-but-for-bots/pull/1391#pullrequestreview-5415514794, on commit `740f94e9b2`.
- It is posted as `COMMENTED`, not request-changes, because GitHub refuses request-changes on the bot's own PR. Round 2 was posted the same way.
- The full aggregate (86KB) is over GitHub's size limit. The review has the must-fix summary plus the full text from every request-changes and comment-only seat; approve seats are listed by name only.

I made no fixes, did not un-draft, and changed nothing on garden `main2`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (799031 cached reads)
- Output: 4967 tokens
- Cost: $0.7563222000000001
- Wall-clock: 506s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
