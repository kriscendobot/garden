Implemented and pushed Phase 2a capture support on `llm-confined-application-makers-p2`.

- Head: `68e9dac0b9814e24d77d2d865402af81c601657e`
- Added `packages/daemon/src/capture-node-modules.js`
- Added `packages/daemon/test/capture-node-modules.test.js`
- Supports `node-modules-with-map` using the supplied compartment map, root-confinement validation, and original-source capture.
- Supports `node-modules-scan` using `mapNodeModules`, including conditional root `"."` export resolution and explicit entries.
- Did not add mount canonicalization or change `EndoHost.makeFromTree`.

Checks run:

- Focused AVA tests: 2 passed.
- Regression probes: each test failed under a deliberate implementation break, then passed after restoration.
- Daemon lint: passed with 374 pre-existing warnings.
- Daemon TypeScript check: passed.
- Root TypeScript check: passed.
- Formatting and `git diff --check`: passed.
- Garden pre-push probes: all 9 passed; comment-concision advisory reviewed and retained because it documents layout invariants.
- Full daemon suite could not complete in this long worktree path: the first attempt used Node 22 against Node-24 native dependencies; under Node 24, daemon-backed tests failed with Unix-socket `listen EINVAL` path-length errors. The focused capture tests do not use that socket path and passed under both runs.

Follow-up: the next Phase 2 child can integrate this capture helper with mount canonicalization and `makeFromTree`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-scan-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1147s

<!-- garden-usage-end -->
