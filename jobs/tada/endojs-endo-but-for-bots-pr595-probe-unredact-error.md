The job was already completed in my prior session and the deliverable survived the requeue intact. All acceptance criteria verified.

## Completion report (resumed job — verified complete)

The reaper requeue fired after my earlier session had already finished. No rework was needed; I re-verified the deliverable against the live GitHub state.

**Deliverable:** DRAFT PR **#605** → https://github.com/endojs/endo-but-for-bots/pull/605
- **Head SHA:** `3a9236eecebbd0924fe3ac6c2c2925e281aa7012`
- **Base:** `designs/captp-error-identification` (the #595 design head) ✓ verified
- **State:** OPEN + DRAFT (`isDraft: true`) ✓ verified — stays draft per probe discipline; no cleaner/panel/un-draft chain
- **Title:** `feat(ses,daemon): sanctioned unredactError API (gap-revealing prototype of #595)` ✓
- **Body:** all four required sections present (*Gaps surfaced*, *Skeleton implemented*, *Skeleton not implemented*, *Recommendations to design author*) ✓ verified via `gh pr view`

**Gaps surfaced: 7** ✓ verified (7 `### Gap N:` entries) — the four pre-flight seeds folded in and expanded, plus three discovered while implementing:
1. API name (`unredactError` adopted; cosmetic)
2. **Return shape/signature (load-bearing)** — string vs console vs structured; daemon wants a string, ses-ava wants a logger-bound `VirtualConsole`
3. **Exposure surface** — permit-driven intrinsic vs direct global vs module export (skeleton used the un-permitted direct global)
4. ses-ava migration / symbol retirement (contingent on Gap 2)
5. Rendered text vs structured result (dead `TraceRecord.annotations`/`causes`)
6. Design §1 "the tap disappears from the daemon entirely" contradicted by `daemon.js:217`
7. Behavior across `errorTaming` modes unspecified

**Skeleton implemented: 3** (2 run end-to-end) — new `packages/ses/src/error/unredact-error.js` (`unredactError(err)=>string`, ran: unredacts while `err.message` stays redacted); `console-shim.js` install (ran: child `Compartment` sees `undefined`, containment verified); `daemon/src/unredacted-stack.js` migration (inspection-level, not run).

**Skeleton not implemented: 5** — ses-ava migration, structured return, permit-governed exposure, `@endo/errors` re-export, worker-side capture relocation (each cross-referenced to its blocking gap).

**Load-bearing finding:** the string-shaped `unredactError` composes and is correctly start-compartment-scoped, and the daemon coupling migrates cleanly — but ses-ava cannot (it needs a console, not a string). Gap 2 is the crux; it and Gap 3 block implementation and need @erights.

**Follow-ups:** none for the fleet — the PR stays draft as a discussion artifact for @kriskowal/@erights. Inbox drained empty; no gardening-script failures.
