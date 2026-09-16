Done. Both harness copies extended, validated on all three agents with the pinned Moddable 9.0.0 `xst`, and a draft PR opened.

## Completion report

**Job:** Extend hardened test262 coverage to every immutable-arraybuffer method (follow-up to the kriskowal review on merged PR #475).

**Decision made:** The hardened262 / test262 layer's purpose is cross-delivery **parity** (SES-shim-on-Node vs. native-XS vs. SES-on-XS) — the one thing the package's Node-only ava suites cannot prove. So a method belongs in the shared `immutableArrayBufferViewMatrix` harness iff it has an observable immutable-semantics contract that must hold identically across all delivery mechanisms. Every method the audit flagged qualifies, so all were mirrored — as **one representative assertion per behavioral class**, leaving per-flavor exhaustiveness (11 TypedArray flavors, every DataView width) in the ava suites.

**What changed** (both harness copies, kept in sync — `packages/hardened262/harness/` and `packages/test262-runner/test262/harness/`):
- Immutable-buffer read accessors: `byteLength`, `maxByteLength`, `resizable`, `detached`
- Mutating ArrayBuffer methods reject an immutable receiver: `resize`, `transfer`, `transferToFixedLength`
- Immutable `.slice()` → genuine mutable copy, bytes preserved
- `transferToImmutable` → immutable result (tag via existing flag), source detached, bytes preserved
- TypedArray mutators reject immutable-backed view: `copyWithin`, `fill`, `reverse`, `sort`
- `subarray` stays immutable-backed, reads through, rejects writes
- Non-Uint8 DataView accessors: `getInt16` reads through; `setInt16`/`setFloat32` throw

**Key finding:** genuine (XS) and emulated (Node+SES) hosts diverge only along axes the harness *already* parameterizes (`immutableBufferTag`, `immutableArrayViewIsEmulated`). Every new assertion holds identically otherwise, so **no new capability flags** and **no baseline churn** (additions land inside an already-passing file; baseline is per-file pass/fail).

**Validation:** all three agents green under the CI-pinned **Moddable 9.0.0** `xst` (the on-PATH `xst` lacks native immutable ArrayBuffer; I fetched the 9.0.0 release build to validate). The `@endo/hardened262` `xs` baseline gate confirms `view-behavior-matrix.js` unchanged.

**Delivered:** draft PR **endojs/endo-but-for-bots#1288** (base `llm`), stopping at draft per the manual-gauntlet regime — promote with **run the gauntlet #1288**.

**Follow-ups / notes:**
- The two harness copies had already diverged (the test262-runner copy carries capability-flag guards the hardened262 copy lacks); I preserved that structure and added identical assertion blocks to both. Unifying the two copies remains the deferred design question noted in the existing `hardened262-mirror` memory.
- The test262-runner matrix scripts are **not** wired into CI (only the hardened262 baseline gate is); the runner copy is a manually-run companion. Worth wiring if the maintainer wants the emulated Node+SES path gated.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-immutable-arraybuffer-hardened262-coverage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (7715891 cached reads)
- Output: 66196 tokens
- Cost: $7.1608975
- Wall-clock: 1001s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
