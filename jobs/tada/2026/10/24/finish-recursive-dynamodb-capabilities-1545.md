Everything verifies. Both integration tests are properly `test.skip`-guarded (so CI stays green), the package correctly has no static `@aws-sdk/client-dynamodb` dependency, and `fast-check` backs the property tests. The working tree is clean and at the pushed head — the prior attempt completed the reconciliation and was reaped during the long CI wait.

## Completion report

**Job:** finish `@endo/exo-dynamodb` on PR #1545 (endojs/endo-but-for-bots, branch `gardener/fu-design-recursive-dynamodb-capabilities-1`, base `llm-d5ac419`), reconciled to minion.town design PR #221 @ `d65ac219`.

**Re-derived state (clean restart):** The prior attempt had already pushed the reconciliation. PR head is `e728a830` ("reconcile capabilities with the final design", committed 04:54Z today), which sits atop the initial `95ff807` + the sort-range fix `18d1a263`. My fresh worktree is clean and exactly at that pushed head — there were no uncommitted changes to recover and nothing new to push.

**Verification performed:**
- **Design conformance** — the committed `DynamoControl`/`DynamoCapability` surface and the 39 package tests map onto the design's §2 interface and §9 "least-authority evidence" checklist in full: both `derive` methods resolve `Result<{capability, grantId}>`; control has async `withdraw`/`lineage` (plus `retire`); malformed/widening/revoked resolve (never reject); `keySpace` + per-index `KeyRange` maps + nested `shape` with a conjunctive `Condition` guard + `itemBytes`/`requestsPerSecond`; numeric exact/interval + sort-condition intersection; index rows outside the base key space dropped with no count; GSI consistent-read refusal; per-write/transaction idempotency keys; named-grant tombstone/restart; and property, deny-before-send, index-leakage, revocation, restart, audit, confinement coverage. The coupon-parity / migration tests (§9 final bullet, design follow-ups 2–3) are correctly **out of scope** — they belong to the separate minion.town adapter PR.
- **CI classification (run on exact head `e728a830`, run 40064188261)** — `@endo/exo-dynamodb` is green: lint, build, all tests pass, c8 coverage 100% stmts/branches/funcs/lines (97.5% on `src`). Every red is pre-existing and base-reproducing, not from this package:
  - `build` → `scripts/graph.sh: tred: command not found` (graphviz/mutual-dependency infra).
  - `test` / `cover` / `sandbox-drivers` → `@endo/sandbox` bwrap tests only (`ulimit -u` illegal option, bwrap parent-death process-group) — the known sandbox-driver failures.
- **Integration tests that cannot run in the fleet/CI** (reported as asked): `test/integration/dynamodb-local.test.js` is `test.skip` unless `EXO_DYNAMODB_LOCAL_ENDPOINT` is set (no Java/Docker on build hosts; CI logged `[skip] … dynamodb-local`; the prior attempt ran it green against a `moto_server` emulator with `EXO_DYNAMODB_LOCAL_NO_TOKENS=1`). `test/integration/isolated-iam.test.js` is `test.skip` unless a real AWS table + a narrower-than-catalog IAM role are configured and dynamically imports `@aws-sdk/client-dynamodb` (not a package dep). Both stay green-by-skip in CI.
- **PR hygiene** — the original garden job marker `<!-- garden-job: fu-design-recursive-dynamodb-capabilities-1 -->` is preserved; the draft PR body already documents the full contract, CI note, and integration-test status. No duplicate PR created (the existing one is adopted as instructed).

**Changed:** nothing new this attempt — the deliverable was already committed and pushed; this run re-derived and confirmed it against the final design and classified CI.

**Follow-ups:** none for this PR. The minion.town adapter migration + `queue` GSI backfill + coupon parity tests are design follow-ups 2–3 and belong to a separate minion.town PR. The PR remains a draft pending the gauntlet/review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/finish-recursive-dynamodb-capabilities-1545.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 268 tokens (28084632 cached reads)
- Output: 168376 tokens
- Cost: $13.031578700000003
- Wall-clock: 5338s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
