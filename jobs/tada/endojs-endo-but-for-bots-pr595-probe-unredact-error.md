The probe is complete. Draft PR #605 is open on the correct base, verified draft, with the four-section gap report.

---

## Completion report

**Probe (gap-revealing build) of the sanctioned SES `unredactError` API — endojs/endo-but-for-bots #595**

**Deliverable:** DRAFT PR **#605** → https://github.com/endojs/endo-but-for-bots/pull/605
- **Head SHA:** `3a9236eecebbd0924fe3ac6c2c2925e281aa7012`
- **Base:** `designs/captp-error-identification` (the #595 design head) — as mandated
- **State:** DRAFT (verified `isDraft: true`); no cleaner/panel/un-draft chain run, per probe discipline
- **Title:** `feat(ses,daemon): sanctioned unredactError API (gap-revealing prototype of #595)`

**Gaps surfaced: 7** (the four pre-flight seeds folded in and expanded, plus three discovered while implementing)
1. API name — `unredactError` vs the design's `getErrorDiagnostic` (adopted the review's name; cosmetic)
2. **Return shape/signature (load-bearing)** — string vs console vs structured; the daemon wants a string, ses-ava wants a logger-bound `VirtualConsole`. The crux of the whole design.
3. **Exposure surface** — permit-driven `%InitialUnredactError%` intrinsic vs direct named global vs module export; the skeleton used the un-permitted direct-global path (provably start-compartment-only but un-hardened).
4. ses-ava migration / symbol retirement (Open Question 2) — contingent on Gap 2 resolving to a console shape.
5. Rendered text vs structured result — `TraceRecord.annotations`/`causes` are hardcoded `[]`; a string-only API cements that.
6. Design §1 claims "the tap disappears from the daemon entirely," but `daemon.js:217` is a legitimate daemon-internal capture site that contradicts it.
7. Behavior across `errorTaming` modes is unspecified (fidelity varies safe/unsafe/unsafe-debug).

**Skeleton implemented: 3 items** (2 empirically run)
- `packages/ses/src/error/unredact-error.js` (new): `defineUnredactError → unredactError(err)=>string`. **Ran** — rendered unredacted message args + stack + note while `err.message` stayed redacted.
- `packages/ses/src/console-shim.js`: installs `globalThis.unredactError` start-compartment-only. **Ran** — child `Compartment` sees `undefined` (containment verified, mirroring `getStackString`), demonstrating design constraint #2's enforcement mechanism.
- `packages/daemon/src/unredacted-stack.js`: prefers the sanctioned API, fully fallback-guarded. Inspection-level (not run — no full daemon build).

**Skeleton not implemented: 5 items** — ses-ava migration (Gap 2/4), structured return (Gap 5), permit-governed exposure (Gap 3), `@endo/errors` re-export (Gap 3), worker-side capture relocation (Gap 6). Each cross-references the blocking gap.

**Verification honesty:** the SES skeleton was run end-to-end (imported `packages/ses/index.js` under Node 22 with workspace deps symlinked; not a full monorepo build). The daemon and ses-ava changes are inspection-level, stated as such in the report and PR body.

**Load-bearing finding for the design author:** the string-shaped `unredactError` composes and is correctly start-compartment-scoped, and the daemon coupling migrates cleanly onto it — but ses-ava does not, because it consumes a console, not a string. Gap 2 (return shape) is the crux; it and Gap 3 (exposure surface) block implementation and need @erights. Gaps 1, 6, 7 are design clarifications the author can settle alone.

**Follow-ups:** none for the fleet — the PR stays draft as a discussion artifact for @kriskowal/@erights. No gardening-script failures encountered.
