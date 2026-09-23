CI is now GREEN (0 failed, 27 total). The browser-tests failure was confirmed a transient 30-minute infra timeout — re-running the job passed it, no diff change needed.

## Completion report

Applied the round-4 panel's must-fix and should-fix items to PR #1040 (`endojs/endo-but-for-bots`, head `kriskowal-hardened262`) in one review-feedback follow-up commit, pushed, and drove CI to green.

**must-fix:**
- **breaker (async false-pass):** Both agents (`scripts/agents/node.js`, `xs.js`) derived `ok` solely from child exit `0`, but `$DONE(error)` only `print()`s a `Test262:AsyncTestFailure` marker and never sets a nonzero exit, so in-protocol async failures laundered into false passes. Routed both agents through a new shared `scenarioOk(test, code, stdout)` in `scripts/agents/scenario.js` (plus `scenarioIsAsync`): stdout is now always piped and captured (forwarded to our stdout only when not quiet), and a clean exit fails if it printed the failure marker, or — for a declared-async case — never printed `Test262:AsyncTestComplete`. Verified against the breaker's live repro (`needsImportMeta`): now correctly reports `# not ok` where it previously reported `# ok`.
- **packager (LICENSE):** Filled the Apache placeholder at `packages/hardened262/LICENSE:189` → `Copyright 2026 Endo Contributors`.
- **assessor (raw+module):** Extended the raw strict-pragma-skip guard in `scripts/test.js` to also skip `mode === 'Module'` (an ES module body is inherently strict), preventing silent strict semantics on a sloppy-only raw case.

**should-fix (folded in):**
- **changeset-auditor:** Rewrote `.changeset/add-endo-hardened262.md` sentence-per-line.
- **spec-keeper:** `test/harden/proto-of-property.js` (was byte-identical to `transitive-proto.js`) now pins the property→proto edge its name promises; `test/harden/exists.js` (was a dup of `property.js`) is now a distinct harden-exists smoke test; corrected `stamp.js`'s PrivateFieldAdd citation §7.3.28 → §7.3.27.
- Extended `scripts/scenarios.test.js` golden tests to pin `scenarioOk`'s async logic and the raw+module skip (17 tests, all pass).

**Verification:** `node --test`, eslint, tsc, and prettier all clean locally. (First push went RED on a prettier formatting nit in the new test — a local/CI parity gap since the package `lint` script omits the root prettier step; fixed with `prettier --write` and amended.) CI terminal: **GREEN**, 27/27.

**Not done (noted follow-up):** the packager should-fix asking that the base commit's `yarn.lock` churn live in a separate `chore: Update yarn.lock` commit is a history-split of an already-published commit, which a follow-up-commit fix stage cannot do without a full-branch rewrite; left for a `retcon` if desired. My changes touched no `yarn.lock`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1040-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 109 tokens (4725763 cached reads)
- Output: 35011 tokens
- Cost: $4.190884499999998
- Wall-clock: 2990s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
