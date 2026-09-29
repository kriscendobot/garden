## Clean stage: endojs/endo-but-for-bots PR #1348

**Result:** Nothing to change, and CI is green at head `8d912500`. The PR is still an open draft.

**Coverage check of the source changes:**
- `packages/agent-tools/src/workspace.js`: the new `nameWorkspaceTools` renaming (`inspect` becomes `inspectShell` / `inspectGitRemote`) is fully covered. `workspace.test.js` tests each renamed group and the combined shell + remote catalog. The groups that keep their names (file/git/gitMount) are covered by the existing composition tests. `git-worked-loop.test.js` also runs the full provisioned catalog end to end.
- `packages/agentry/src/workspace-agent.js` (new): `workspace-agent.test.js` covers it with a test that grants every capability and one that grants only the filesystem. `exports.test.js` checks the export paths.
- **Dead code:** The PR removed the `makeWorkspaceTools` import from the worked-loop test, and nothing else was left orphaned. By the skill's four-part test for dead code, nothing qualifies.

**Worth passing to the panel:** the `throw` for duplicate tool names in `concatDistinctTools` (`workspace.js:94`) no longer has a test. The PR replaced the test that used to trigger it, and with the current tool makers that throw can't happen. It is not dead code: it sits in a function `makeWorkspaceTools` calls, and it deliberately refuses a catalog where a future maker would add a duplicate name. The only way to test it would be to export the helper or rewrite it to accept injected dependencies. I didn't think that was justified in this stage, so I left the guard alone.

**CI:** `ci-wait-merge.sh --no-merge` returned rc=0: 33 checks, 0 failed.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (446605 cached reads)
- Output: 3241 tokens
- Cost: $0.545293
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
