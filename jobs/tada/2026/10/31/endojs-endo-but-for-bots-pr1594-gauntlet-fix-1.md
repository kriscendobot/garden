Fix round 1 for endojs/endo-but-for-bots#1594 is pushed and CI is green.

**What I changed:** one follow-up commit, `7bbf536c2f`, on the PR head `daemon-rename-to-manager`. It fixes both failing checks from the deterministic style prepass.

1. **no-inline-import-jsdoc:** in `packages/daemon/test/endo.test.js`, `ManagerDatabase` is now imported in the existing top-of-file `@import` block. Line 94 now uses the bare `@returns {ManagerDatabase}`.
2. **prefer-endo-primitives:** I added a `prefer-endo-primitives-exempt` marker comment, with a reason, near the top of all 11 flagged test files. The bare `Far` stubs in those files were already there; the rename only changed the names around them (for example `workerDaemonFacet` became `workerManagerFacet`) or rewrapped the lines. I used the exemption rather than converting them to `makeExo`, because adding interface guards to 11 test files would pull non-rename changes into a rename-only PR. If the panel wants them converted, that's a separate follow-up.

**Checks:** after the commit, both probes pass against `origin/llm-9a14ddf`. ESLint on the touched files reports warnings only, no errors. I pushed with `safe-push-pr-head.sh --mode advance` (c13ac3d27a → 7bbf536c2f). `ci-wait-merge.sh --no-merge` returned rc 0: all 36 checks reached a final state with 0 failures.

**Follow-ups:** none from this stage. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1095460 cached reads)
- Output: 4991 tokens
- Cost: $0.7853120000000001
- Wall-clock: 2448s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
