CI is GREEN (26/26, 0 failed). The clean stage is complete.

## Completion report

**Job:** Gauntlet CLEAN stage for endojs/endo-but-for-bots PR #1015 (the `@endo/claude` confined-inference package).

**What I did:**
- Ran a coverage pass on the touched package `packages/claude` (the sole package with real source changes; `claude-sandbox`'s modifications were test-accompanied already). Baseline was 90.9% stmts / 79.7% branch / 87.2% funcs.
- Added targeted tests for genuine, uncovered failure modes — no contortion tests:
  - **`test/results.test.js`**: the previously-untested taxonomy constructors `rateLimited`, `bridgeDown`, `nonzeroExit`, `parseError`, plus `ok`'s non-string-text guard (these are the deliberate DD8 exhaustive taxonomy, so I *tested* rather than deleted them).
  - **`test/formula-id.test.js`** (new file): `assertGuestFormulaId` injection vectors (quote/CR/LF/length/case/non-string) and the `isGuestFormulaId` predicate — both are public API from `index.js` and had zero direct coverage.
  - **`test/shim.test.js`**: the pure MCP handler's Invalid-Request, ping, and notification (unknown-method + broker-error-swallowed) branches.
  - **`test/mcp-config.test.js`**: transport-validation guards — missing transport, empty command, non-string args, CRLF/invalid URL header-injection, unknown transport kind.
- Result: `results.js`, `mcp-config.js`, `formula-id.js` all reach **100%**; overall **branch 79.7%→86.1%, funcs 87.2%→97.9%**. The only remaining gap is `shim.js`'s `main()` bin wrapper (real sockets/stdio, process-level — not unit-testable without a live UDS; documented as the v1 stopgap bin).
- **No dead code** to remove: the PR is an additive new package, so nothing was orphaned; the untested constructors were live taxonomy, not dead code.

**What changed:** two commits pushed to the PR head `endojs/endo-but-for-bots:endo-claude-package` (test-only, +151 lines across 4 test files; no source, no changeset needed). The second commit was a prettier-format fixup after the first push's `lint` job flagged formatting.

**Verification:** local eslint + tsc + prettier + ava (73 tests) all clean; CI watched to terminal state — **GREEN, 26/26 checks, 0 failed**.

**Follow-ups:** none. PR remains draft (correct — the panel/un-draft stages follow this one in the gauntlet).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1015-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4727650 cached reads)
- Output: 26408 tokens
- Cost: $3.966269
- Wall-clock: 2259s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
