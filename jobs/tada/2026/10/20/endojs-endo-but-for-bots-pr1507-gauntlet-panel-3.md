PR #1507 (endojs/endo-but-for-bots), gauntlet panel round 3: the read-only style pre-pass failed, so no jurors were dispatched and no review was posted.

- **Pinned pair:** base `92b91a7e93c936b30567924c480641da19f44f78`, head `f75bcbcd806036f5954426b4345669d478a437a1` on `endojs/feat/ocapn-noise-explicit-listeners`.
- **Checkout:** the head was checked out detached in an isolated per-job worktree (`/home/kris/garden/scratch/project-wt-endojs--5b321751a5c1-a6d32bcf`), and `git rev-parse HEAD` matched the head ID.
- **Pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only --base-ref <base>` exited 1. The `no-inline-import-jsdoc` probe flagged inline `import('../types.js')` typedefs in three transport files (`mock.js`, `tcp.js` and `ws-node.js`, each at line 6). There is also a non-blocking warning about a 7-line prose comment at `types.d.ts:144`.
- **Not done:** `panel.sh` was not run. Nothing in the project or the garden repo was changed.
- **Follow-up:** the driver routes the block below to fix-3. The fix is to add a top-of-file `@import` tag in each of the three files and use a bare type reference.

<!-- gauntlet-style-prepass-output-begin -->
probe no-inline-import-jsdoc    fail (exit 1)
  fail: packages/ocapn-noise/src/transports/mock.js:6 @typedef uses inline import('../types.js'); add a top-of-file @import tag and use a bare type reference
  fail: packages/ocapn-noise/src/transports/tcp.js:6 @typedef uses inline import('../types.js'); add a top-of-file @import tag and use a bare type reference
  fail: packages/ocapn-noise/src/transports/ws-node.js:6 @typedef uses inline import('../types.js'); add a top-of-file @import tag and use a bare type reference
advisory comment concision      warn (non-blocking)
  fire pruner packages/ocapn-noise/src/types.d.ts:144 (+7-line prose comment) — decide whether it adds a non-obvious invariant or rationale; require deletion if it only narrates adjacent code
result: 1 failing stage(s); address and re-run.
<!-- gauntlet-style-prepass-output-end -->

<!-- gauntlet-stage-result: panel=prepass-failed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1507-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (232316 cached reads)
- Output: 1698 tokens
- Cost: $0.4323112
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
