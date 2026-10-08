## Fix round 1 report: endojs/endo-but-for-bots PR #250

I fixed all three must-fix items from the panel and pushed the fixes to `ci/no-npm-lifecycle-master` as two follow-up commits. CI is green on the new head `a31662b49f`, with all 17 checks passing.

**Must-fix items:**
1. **Comments pointed at a design doc not on `master`.** All eight workflow comments no longer mention `designs/ci-no-npm-lifecycle.md`. Each comment now explains the env block on its own. As saboteur suggested, the comments in `ci.yml` and `ocapn-guile-interop.yml` now say the block guards against config drift, not against a hostile branch. I also shortened the `depcheck.yml` comment to one line, as pruner asked. This is commit `e1db05a984`.
2. **`copilot-setup-steps.yml` had been skipped.** It now has the same top-level `env:` block (`YARN_ENABLE_SCRIPTS: 'false'`, `npm_config_ignore_scripts: 'true'`). That is safe because `ci.yml` already runs the same `install-engines` step under this env. Same commit.
3. **PR body and title.** I rewrote the body section by section from `.github/PULL_REQUEST_TEMPLATE.md`. It has no untitled preamble and no `## Refs` or `## Scope` headings, and the reference to #126 is now a full URL. The Testing section now says correctly that both `update-action-pins*.yml` workflows run `yarn install --immutable`. The body also notes that `npm publish` would skip `prepack` under this env, and that no workflow runs `npm publish` today. The title is now `ci: disable npm lifecycle scripts in workflows`.

**A CI failure that was not caused by this PR:** after the first push, zizmor v1.24.1 failed on `ci.yml:286`. The pin there is `dorny/paths-filter@d1c1ffe… # v3`, but upstream has since moved the `v3` tag to v3.0.4 (`0e4a8c6e`). The pinned commit is v3.0.3, so I kept the pin and changed the comment to `# v3.0.3` in commit `a31662b49f`. The PR body mentions this.

**Not done (should-fix only):** I did not drop the two empty CI-nudge commits or squash the `ocapn-guile-interop` env-merge fix. Both would rewrite history, and this stage only pushes follow-up commits. They could be cleaned up in a retcon before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr250-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1298130 cached reads)
- Output: 8880 tokens
- Cost: $0.9799299999999999
- Wall-clock: 1289s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
