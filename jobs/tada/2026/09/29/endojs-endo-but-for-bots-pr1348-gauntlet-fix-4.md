**Fix round 4 on endojs/endo-but-for-bots#1348: CI is green, but must-fix items 1 and 2 are still open. Both need a maintainer decision, so the next panel round will flag them again.**

The PR head is now `c193f194cd` and is still a draft. All 33 checks passed (16 succeeded, 17 skipped). The first CI run failed the lint type check on my new test (partial stand-in capabilities didn't satisfy the types), and `c193f194cd` fixed that.

**Must-fix items from the panel-4 verdict:**
1. **#731 parking:** not settled. I sent the maintainer the question: should endojs/endo-but-for-bots#731's parking of the JSON agent-tools wrappers be lifted for this slice, or should the PR stay draft?
2. **"Deliverable" disposition:** not settled. I sent the question in the same message: should the PR become a slice or probe that stays draft, given the deferred Phase 2 (2c) and Phase 4, or should the Phase 4 consumer come into scope?
3. **Summary comment:** done. I posted https://github.com/endojs/endo-but-for-bots/pull/1348#issuecomment-5883340692. It covers the round-3 commits `be32f1dde2` and `b8a9e727d9`, this round's commits, the items I declined, and the two open questions.

**Should-fix items applied**, pushed with `safe-push-pr-head.sh`:
- `f3b9393c5b`: the `endow` hook's view of the options is now only shallowly frozen, so the caller's `messages`, `credentials`, `streamFn` and `convertToLlm` are no longer deep-frozen. The errors now go through `makeError(X…, TypeError)` from `@endo/errors`. A new test checks that caller-owned options stay unfrozen.
- `ca9c915a3b` and `c193f194cd`: a new test checks that `inspectShell` and `inspectGitRemote` each reach their own capability.
- `09fb9e313b`: the README now states the rename condition correctly and says that `workspaceGrants.readOnly` only removes the file write tool. It also fixes the over-long line.

**Should-fix items declined:**
- **Collision-path test:** the public makers can no longer produce a name collision, so testing the guard would mean exporting a private helper.
- **Renaming `workspaceGrants`:** this depends on the maintainer's decision.
- **Regrouping the commits:** this needs a history rewrite, which is retcon work once the scope is settled.

**Follow-up:** the maintainer needs to answer items 1 and 2 before a later panel round can clear this PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1808838 cached reads)
- Output: 12383 tokens
- Cost: $1.1883556
- Wall-clock: 1778s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
