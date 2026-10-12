Fix round 2 for endojs/endo-but-for-bots#1412 is pushed and CI is green: `ci-wait-merge.sh --no-merge` returned rc 0, with 33 of 33 checks passing and none failing.

**What I fixed.** The latest panel review is 5486377772, against head `2467b3a2de`. Three seats requested changes:
- **archivist (must-fix):** The README says it lists every subpath export, but `confinedAllowList` from `confinement-options.js` was missing from the list. It is now listed as an export with a one-line description.
- **curator #2:** `index.js` now has a comment saying the `@endo/inference` backends are reached only through subpath exports, and why. It points to the README section that lists them.
- **pruner:** I removed the PR body's Scaling, Documentation and Upgrade Considerations sections, which repeated the README, the design and the changeset. The body went from about 450 to about 340 words. Description, Security, Testing and Compatibility remain.

The README and `index.js` changes are one commit, `15a24d78b5` ("docs(claude): list confinedAllowList and note the subpath-only backends"). It went to `build/endo-claude-backends-1357` through `safe-push-pr-head.sh` as a fast-forward from `2467b3a2de`. The PR body was edited with `gh pr edit`.

**What I left alone.** All of these are should-fix or comment-only:
- **curator #1** asks for a `types` condition on each subpath export. I didn't change this because the README already explains that each subpath's types are its JSDoc, emitted as declarations next to the module when the package is packed.
- **curator #3** says the `src/*` modules export more than the intended public surface, so helpers like `turnOutcome` and `usageFromResult` become public through the subpaths. I didn't change it; fixing it means trimming or filtering those modules' exports.
- **curator #4** notes that `argv.js` validation errors lost their `buildArgv:` prefix. I didn't change it.

If the maintainer wants curator #1 or #3, they need a later round.

**Follow-ups.** None from this stage. I did not re-run the panel; the driver posts panel-3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1028823 cached reads)
- Output: 5852 tokens
- Cost: $0.8093805999999999
- Wall-clock: 2348s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
