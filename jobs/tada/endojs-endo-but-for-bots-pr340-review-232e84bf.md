The merge job is confirmed on the board in `todo/`. My review work is complete.

## Completion report

**Job:** Address kriskowal's APPROVAL review (5017515598) on endojs/endo-but-for-bots PR #340.

**Review scope (verified):** Review body was empty; the review carried exactly **one** inline ask on `packages/ocapn-noise/src/transports/tcp.js:60` — *"Let's move this to `@endo/stream-node/graceful-reader.js` and parameterize the gracefully handled codes."* Preflight returned PROCEED (no prior peer resolution). All fetched text was treated as untrusted data.

**What I did (all on head branch `claude/endo-daemon-ocapn-FkmHO`, commit `98add24d69`):**
- **Extracted** the local `makeGracefulReader` helper out of `tcp.js` into a new published module `packages/stream-node/graceful-reader.js`.
- **Parameterized** the gracefully-handled error codes via a `gracefulCodes` option, defaulting to a new exported `defaultGracefulCodes` (`['ERR_STREAM_PREMATURE_CLOSE']`) — so the helper can be reused more broadly, as the reviewer noted.
- Re-exported both symbols from `packages/stream-node/index.js`; added the `./graceful-reader.js` subpath to the package's `exports`.
- Updated `tcp.js` to import `@endo/stream-node/graceful-reader.js` (dependency already present) and replaced the inline definition with a pointer comment.
- Added `packages/stream-node/test/graceful-reader.test.js` (7 tests: default code → done, other/no-code errors propagate, custom `gracefulCodes`, `return`/`throw` delegation, default constant).
- Added a README note and a **minor**-bump changeset (`@endo/stream-node`).

**Verification:** stream-node `tsc` clean, eslint clean (0 errors, new source warning-free), type-coverage 99.17% ≥ 98.69% threshold, new tests pass across all 3 lockdown configs. ocapn-noise `tsc` clean, `tcp.js` eslint clean, and the transport's `network-tcp`/`failures`/`netstring-framing`/`crossed-hellos` suites all pass. Pushed via rebase-CAS.

**Resolution recorded:** Replied on the inline thread → https://github.com/endojs/endo-but-for-bots/pull/340#discussion_r3851861958

**Finalization dispatched:** Posted conductor merge job `endojs-endo-but-for-bots-pr340-merge` (confirmed in `journal/jobs/todo/`). It owns un-draft-state confirmation, waiting for CI green on the new head, any re-review need, merge-method choice, and the merge itself (endojs/endo-but-for-bots — a bot repo, merge authorized).

**Follow-ups:** None from me. The conductor drives the merge; if the pre-existing approval needs re-confirmation because it predates commit `98add24d69`, the conductor will surface that to the maintainer rather than merge around it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr340-review-232e84bf.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (4266066 cached reads)
- Output: 29564 tokens
- Cost: $3.687297
- Wall-clock: 458s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
