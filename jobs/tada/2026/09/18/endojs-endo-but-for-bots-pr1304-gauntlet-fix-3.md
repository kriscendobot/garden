**Fix round 3 complete.** Applied the panel-3 must-fix items to endojs/endo-but-for-bots PR #1304 and drove CI to green.

What I found and did:
- A prior claimant of this job had already pushed a thorough round-3 fix commit (`dade2d134`) that addressed every panel-3 must-fix/should-fix item: the engine-realist collection-phase revocation hole (added a context-cancellation liveness gate to `makeReadOnlyDirectoryView` and both `manager.js` mailbox/message-hub views, mirroring `mount.js`'s `assertLive`); corner-prober/wire-watcher's untested guest call sites (new `endo.test.js` coverage for `mailHub`/`messageHub` `readOnly()` plus a negative test pinning that `EndoHost`/`EndoGuest` lack `readOnly` today); the shared `@endo/helpdown` `makeHelp` prototype-walk fix (own-property lookup, routing the view's help through `help.md`); guard alignment (`M.callWhen().returns(M.remotable('ReadableNameHub'))`); the `namehub-interface-unification.md` design amendment; and the #1125 eval-formula-vs-local-exo reconciliation note in the PR body (flagged as a maintainer decision surface).
- I caught and fixed a defect that commit left behind: stray `</content>`/`</invoke>` tool-artifact tags at the tail of both changeset files. Pushed the cleanup as `ca1157647` via `safe-push-pr-head.sh`.

Verification (local): help-text-data regenerates with no drift, `@endo/daemon` lint:types + eslint clean, `@endo/helpdown` lint:types + tests pass, read-only-view unit tests pass (6/6).

CI result: **GREEN** — `rollup-terminal … total=32 failed=0` against head `ca1157647`.

Follow-up (informational, not blocking): the PR body explicitly leaves a maintainer decision open — this slice ships the transient, non-storable local exo rather than kriskowal's suggested eval-formula (storable/pet-nameable) form; if the storable property is required now, the PR should return to draft behind that direction. That's for the maintainer/panel-4, not this fix stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s)
- Input: 280 tokens (15556175 cached reads)
- Output: 73628 tokens
- Cost: $13.938449499999999
- Wall-clock: 2641s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
