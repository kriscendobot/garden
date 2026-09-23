CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Stage:** FIX round 1 of gauntlet `endojs-endo-but-for-bots-pr1074-gauntlet-resume-20260828-0935`, PR #1074 (`test(hardened262): cover %TypedArray% and %TypedArrayPrototype% intrinsic metadata`).

**Panel round-1 must-fix items applied** (all three), in commit `f095f5d75` on head branch `test/hardened262-typedarray-intrinsic-metadata`:

1. **Dropped `arraybuffer-transfer` from `features:` front-matter** (`intrinsic-metadata.js:4`). The detachment path feature-detects `transfer()` and falls back to `structuredClone`, so the feature is not unconditionally required; a `features:`-honoring runner would otherwise skip the entire file (including the unrelated superclass/name/iterator/toStringTag-shape assertions) on a host lacking only `transfer()`. (archivist, spec-keeper, integrator, migrator)

2. **Made `detachBuffer` fail loudly** — it now throws a `Test262Error` when a host offers neither `ArrayBuffer.prototype.transfer` nor `structuredClone`, instead of silently returning `false` and letting `assertDetachedToStringTag` no-op. A "passed" baseline entry can no longer conceal a detached-buffer `@@toStringTag` check that never ran. Both currently-supported hosts clear the bar (XS has native `transfer()`; Node's floor has `structuredClone` since 17), so the branch is unreachable today; a future host regression surfaces as a loud failure. Verified both branches empirically (normal run passes; simulated neither-mechanism host throws the expected loud error). (spec-keeper, prover, saboteur, engine-realist, breaker, corner-prober)

3. **Refreshed the stale PR description** — the detached-buffer bullet now describes the portable `detachBuffer` guard (transfer → structuredClone → throw-loudly) and the dual Number/BigInt (`Int8Array` + `BigInt64Array`) constructor coverage that actually landed, rather than the old "exercised via `ArrayBuffer.prototype.transfer`" prose. (integrator)

Also folded in the non-blocking spec-citation should-fix (ECMA-262 §23.2.3.38 getter, §20.1.3.6 `Object.prototype.toString`).

**Push:** `451e1a774 → f095f5d75` on `origin/test/hardened262-typedarray-intrinsic-metadata` via `safe-push-pr-head.sh` (advance mode).

**CI:** all 24 checks SUCCESS on head `f095f5d75`; `ci-wait-merge.sh` returned rc 0 (CI GREEN).

Stopped here per the stage contract — did not re-run the panel (the driver re-posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1074-gauntlet-resume-20260828-0935-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 48 tokens (1990665 cached reads)
- Output: 13207 tokens
- Cost: $2.1258685000000006
- Wall-clock: 821s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
