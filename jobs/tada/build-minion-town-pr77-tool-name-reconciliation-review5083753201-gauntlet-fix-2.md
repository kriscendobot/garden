CI is green (rc 0). The fix stage is complete.

## Completion report

Applied the panel round-2 must-fix items to PR #79 (`kriscendobot/minion.town`, head branch `feat/tool-name-reconciliation`), pushed as follow-up commit `24ef869`, and CI came back **GREEN**.

**Must-fix (gating):**
1. **Independent name pin** — `test/endo-mcp-tool-names.test.ts`: added a **literal** expected-name snapshot for `REGISTERED_MCP_TOOL_NAMES` (not derived from the manifest). Verified the reviewer's mutation (`readText` → `readTxt`) now **fails** this test, where it previously left every manifest-derived coherence check green. The mounted-surface coherence test in `endo-clip-tools.test.ts:125` intentionally stays manifest-derived.
2. **Dangling source reference** — `src/endo/mcp-tool-names.ts`: replaced the bogus `designs/design-tool-name-reconcile` citation (a leaked garden job base name) and the bare `README.md#naming-convention` anchor with a relative `../../README.md` reference plus the PR #77 URL where the reconciliation landed.

**Should-fix / comment-only (addressed to improve the tally):**
- Softened the precedence docblock to record baseline-vs-optional **rank** (not mount order) and named `baseline`/`baselineReserved` as the baseline-rank groups — resolving the self-contradiction with `baselineReserved`.
- Decided `claudeForm.submit`'s rank explicitly: **baseline** (backing method on the composed `GuestFacet`), only its tool optionally mounted.
- README: named the actual design-time mechanism (the test suite importing the manifest fails CI) rather than describing the boot-crash throw as design-time.
- Added an NFC/NFD (`é`) pair to the exact-identity test so its body matches its title.

**Verification:** `npm run typecheck` clean; full suite `309 passed | 5 skipped`; CI GREEN at head `24ef869`.

Per stage instructions I did **not** re-run the panel — the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2237095 cached reads)
- Output: 18555 tokens
- Cost: $2.2175404999999997
- Wall-clock: 332s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
