PR #1349 now passes CI (16/16) on head `8382a1f48a`. It answers the two panel reviewers that requested changes (integrator and pruner), and kriskowal and naugtur are re-requested for review. Locally, the `ses` tests (548 passed, 2 known failures, 2 skipped), `test:xs`, `lint` and the garden probes pass.

**What I changed on `build/hardened-text-codecs-shim`:**
- **`1dc303910f`:** put the curly quotes back in `docs/guide.md` and `packages/ses/docs/guide.md`. The guide diffs now contain only the codec paragraphs (integrator item 2).
- **`667e7e4b60`:** shortened the Browser Tests trigger comment to its reason (pruner).
- **`8382a1f48a`:** restored the `# v3.0.3` version comment on `dorny/paths-filter` in `ci.yml`. I had reverted it as unrelated, but that turned zizmor red: the floating `v3` tag no longer points at the pinned commit. The PR body now explains the edit instead (integrator item 3).
- **`f7df006f12`:** the XS lockdown shim now throws a clear error if `repairIntrinsics` returns without reporting its intrinsics. Before, `undefined` would have been passed on (assessor and typist).
- **`925e735f3d`:** prose fixes.
  - Trimmed two comments that restated the code (pruner).
  - Cited endojs/endo#3369 for the Chromium claims nothing in the repo verifies, and fixed a broken sentence in the browser spec (archivist).
  - Removed a paragraph from the older `tender-lions-tickle.md` changeset that this PR makes false (archivist).
- **PR body:** fixed the template heading levels, the only must-fix; `pr-body-template-check.sh` now passes. The Compatibility section now describes the XS compartment behavior change (integrator item 4).
- **naugtur's thread:** I corrected our earlier reply. It said his "only replace when needed" check was done, but a later commit (`f1770005a9`) made the replacement unconditional again, following the design in endojs/endo-but-for-bots#1431. The thread is now open for his decision.
- **Summary comment** posted on the PR: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6439860915

**Not done in this pass:**
- **`fixup!` commits:** left for the conductor to squash at merge.
- **Decomplector's suggestion:** still open. They asked to return the intrinsics as a value instead of through the `onIntrinsics` callback.
- **Other panel items:** the remaining should-fix items from the prover, migrator, spec-keeper, breaker and engine-realist seats are untouched.
- **hardened262 migration:** still waiting for a base branch that contains `packages/hardened262`.

**Decision needed from the maintainer (message sent to the maintainer inbox):** the pre-push gate's code-point autofixer straightens quotes across the whole of any changed markdown file. That rewrite is what created the guide churn the integrator flagged, and the next fixer who runs the gate will bring it back. The options I offered are:
- (a) fix only added lines;
- (b) land the rewrites as a separate typography commit;
- (c) leave it as is.

A reply will be promoted to a new job.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `b3fecfbfa1d5c722578a000591f263a0e5cedc0d`; this job presented `8382a1f48a93827be8e4f592c93bfb7aeb33eb58`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-fix-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4300519 cached reads)
- Output: 19934 tokens
- Cost: $2.1527918
- Wall-clock: 1340s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
