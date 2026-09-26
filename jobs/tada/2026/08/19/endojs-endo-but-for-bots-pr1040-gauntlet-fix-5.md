Round-5 fix stage complete. All work landed, CI green.

## Completion report

Applied the round-5 panel verdict's must-fix items (plus the low-risk should-fix items to converge) to `endojs/endo-but-for-bots` PR #1040, head branch `kriskowal-hardened262`, in package `@endo/hardened262`.

**Must-fix (all 4 closed):**
1. **Zero-coverage visibility invariant** — `scenariosForTests` now filters each source file's scenarios in isolation and emits a synthetic `{ skipped: true, zeroCoverage: true }` record when *every* generated scenario is filtered out. Files whose `no*` flags exclude all wired agents (`noXs`+`noSesXs`+`noSesNode`) no longer vanish from `--list` and the run report; `--list` gets a `zero-coverage` line and the reporters render an explicit skip.
2. **`raw`+`module`** — the same zero-coverage record surfaces the contradiction as a deliberate, visible skip instead of a silent drop.
3. **`prototype/globalThis/defaults.js`** — swapped `noXs` → `noLockdown`, restoring bare `xs`+`module` as executing regression evidence while excluding only `xs`+lockdown.
4. **`import-hook/module-source-evaluate.js`** — chained `.then($DONE, $DONE)` so the `async` case signals completion instead of always reporting fail.

**Should-fix (to reduce another round):** routed the node agent through a new `scenarioIsLockdown` accessor (single source of truth, matching `xs.js`); added a per-scenario child spawn timeout (`awaitScenarioChild`, 60s default, `HARDENED262_TIMEOUT_MS` override, SIGKILL→fail); filled the empty `description:` on `ModuleSource/needsImportMeta/name.js`.

**Tests:** added golden tests in `scenarios.test.js` pinning both zero-coverage records, `raw`+`module`, `scenarioIsLockdown`, and that a normal file emits no zero-coverage record.

**Verification:** local `node --test` (21 pass), `eslint` (0 errors), `tsc` (clean), `prettier --check` (clean). First push went RED on `lint:prettier` (formatting on the two edited scripts); ran prettier `--write`, folded into the commit, re-pushed.

**Pushed:** head `4fe196fff` via `safe-push-pr-head.sh`. **CI: GREEN — 27/27 checks, 0 failed.** Posted the round-5 completion-summary comment (#issuecomment-5343359363).

Follow-ups: none required this stage. Remaining panel advisories (comment-only: non-async stdout laundering edge, temp-file path race, naming drift, JSDoc typedef) were left for a future round per the "apply must-fix once, then stop" contract.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1040-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (6298685 cached reads)
- Output: 43495 tokens
- Cost: $5.419195499999999
- Wall-clock: 2068s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
