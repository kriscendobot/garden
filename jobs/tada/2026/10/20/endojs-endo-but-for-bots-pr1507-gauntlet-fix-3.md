Fix round 3 for endojs/endo-but-for-bots#1507 is pushed and CI is green: all 35 checks passed, none failed.

**What I fixed:** the pre-pass failed the `no-inline-import-jsdoc` probe in three files: `packages/ocapn-noise/src/transports/{mock,tcp,ws-node}.js`.
- In each file, the inline `import('../types.js')` and `import('@endo/stream')` type references are now top-of-file `@import` tags.
- The shared `OcapnNoiseTransport` type is imported under the alias `GenericTransport`. That lets each file keep its local `OcapnNoiseTransport` typedef name (Mock, Tcp and WebSocket listen options) unchanged.
- The rest of each file now uses the bare imported names.
- I fixed every inline import in those files, not just the line each finding pointed at, so no file mixes the two styles.

**Advisory finding (non-blocking):** the pre-pass also flagged the comment on `listen` in `packages/ocapn-noise/src/types.d.ts:144` for length. I left it as is. It describes behavior the signature can't show: hints are published only after a successful bind, a failed bind leaves the transport registered, the conditions under which the call rejects, and that closing the listener keeps the dial adapter.

**Checks before pushing:**
- `tsc` for the package passes. I confirmed the check covers these files by breaking a type name, which it reported, and then reverting it.
- `eslint src` shows no errors. There are three warnings, none from this change: two unused `eslint-disable` directives in `bindings.js` and `network.js`, and a nested-`await` warning at `ws-node.js:214`, which is outside the lines I edited.
- Prettier passes on the changed files.
- The package's test suite passes, 84 of 84 under ses-ava.

**Push and CI:** commit `dc9c32b546` ("style(ocapn-noise): hoist transport JSDoc imports into @import tags") went to `feat/ocapn-noise-explicit-listeners` through `safe-push-pr-head.sh`, moving it from f75bcbcd80 to dc9c32b546. The first CI wait was stopped by the tool's 10-minute background limit, so I ran `ci-wait-merge.sh --no-merge` again in shorter foreground runs. The last run returned rc 0.

**Follow-ups:** none from this stage. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1507-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1610772 cached reads)
- Output: 8715 tokens
- Cost: $1.0486944000000002
- Wall-clock: 2022s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
