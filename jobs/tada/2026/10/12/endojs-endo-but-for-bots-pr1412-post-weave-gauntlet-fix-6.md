I applied the round-6 panel's must-fix items to PR #1412, and CI is green on the new head (`ci-wait-merge` rc 0, 33/33 checks, 0 failed).

**Changes**, in one follow-up commit `85acc161d1` on `build/endo-claude-backends-1357`, pushed with `safe-push-pr-head.sh` (fast-forward from `f3591289bd`):
- **Changeset (releaser):** I rewrote `.changeset/endo-claude-inference-backends.md` as a release note for users. It names both backend subpaths and the `maxBudgetUsd` ceiling. It says a backend reports `unavailable` and runs nothing unless the installed `claude` binary matches the pinned version, so users should install that version. It says auth failures show up as a generic failure, not yet as `needs-auth`. I dropped the `@endo/claude/*.js` sentence and the list of runtime dependencies.
- **Releaser's question about `@endo/inference`:** it is publishable. On the base it is not private, it is at 0.1.0, and it has its own `add-endo-inference.md` changeset, so it releases together with this package.
- **README (pruner):** I removed the sentence about the design reshaping the provider and the `src/turn-guard.js` reference from the "Inference backends" section.
- **PR body (pruner):** I removed the "Documentation Considerations" section. I also removed "Testing Considerations", which repeated the canary deferral, and moved its "no live credential, network, or `claude` binary needed" point into the Description.
- **Should-fix (archivist):** I added JSDoc for `SdkOptionsSpec.maxBudgetUsd` in `backends.types.d.ts`.

**CI:** the first run failed one job, `test (22.x, macos-15)`, in `@endo/patterns`: the randomized `M.choose well-formedness` test got a payload whose error message didn't match the expected pattern. This PR doesn't touch `@endo/patterns`, and the same test passed on the other three Node/OS legs, so I treated it as a flake and reran only that job. The rerun passed.

**Not addressed** (should-fix items, left for the panel): the SDK backend still doesn't close its MCP server on the normal path (assessor), the `Admission` typedef should move to `backends.types.d.ts` (typist), and the subpath exports still point at `src/` files (packager).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2346678 cached reads)
- Output: 8839 tokens
- Cost: $1.1941076000000004
- Wall-clock: 4279s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
