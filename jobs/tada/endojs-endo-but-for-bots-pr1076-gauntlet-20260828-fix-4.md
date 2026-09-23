CI is GREEN (all 24 checks passed, rc 0). The fix is complete.

## Completion report

**Job:** FIX round 4 of the staged gauntlet for endojs/endo-but-for-bots PR #1076 (`test(hardened262): pin %ThrowTypeError% intrinsic metadata`).

**Panel round-4 must-fix items applied** (single fix pass, to `packages/hardened262/test/intrinsics/ThrowTypeError/intrinsic-metadata.js`):

1. **breaker + corner-prober (non-constructibility):** Added `assert.throws(TypeError, function () { return new ThrowTypeError(); })` to pin non-constructibility *operationally* rather than merely inferring it from the absent own `prototype` property.
2. **corner-prober (cross-kind identity):** Added a second identity route through a *different function kind* — a `class` method's strict `arguments` object — asserting its `callee` getter `=== ThrowTypeError`, catching a host that keyed the poison pill on syntactic function kind rather than minting one realm-wide accessor. Tagged `class` in `features`.
3. **corner-prober (skip rationale):** Added a one-line rationale comment explaining the `strict`/`compartment*`/`lockdownStrict` baseline skips are **harness-wide** (`agentRunsScenario` in `scripts/test.js` drives only the `module`/`lockdownModule` scenarios today), not specific to this case, and that `onlyStrict` is satisfied because a module body is inherently strict.

The coverage-auditor item was surfaced-not-blocking (no c8 report), no action required.

**Verification:** Ran the test locally under all three agents (`xs`, `sesXs`, `sesNode`) — all `module`/`lockdownModule` scenarios `# ok`. Baseline comparison shows no drift for this file (classification unchanged, no baseline edit needed).

**Push:** Follow-up commit `4ddefe1ab` advanced `origin/test/hardened262-throwtypeerror-intrinsic-metadata` (b223e4e16 → 4ddefe1ab) via `safe-push-pr-head.sh`.

**CI:** Watched to terminal — all 24 checks green (test262 22.x/24.18.0, test-xs, lint, etc.), rc 0.

Stopped here per stage instructions — did not re-run the panel; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1076-gauntlet-20260828-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2284626 cached reads)
- Output: 14909 tokens
- Cost: $2.1651600000000006
- Wall-clock: 1031s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
