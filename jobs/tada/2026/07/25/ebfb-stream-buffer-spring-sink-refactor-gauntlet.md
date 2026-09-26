The gauntlet is complete. Final state confirmed: PR un-drafted, CI green, inbox empty.

---

## Completion report — gauntlet for endojs/endo-but-for-bots#858 (`feat(stream): add unbounded buffer`)

**Outcome:** Ran the full gardening state machine on the draft build PR and drove it to **un-drafted / ready-for-review** with CI fully green.

**Stages run**
- **Cleaner/verify:** Local verification on the touched packages — `@endo/stream` tests across all 3 ses-ava configs, `tsc`, `eslint`, and `@endo/stream-types-test` `tsc` — all clean. Coverage-auditor confirmed 100% on the new source lines.
- **Panel (code panel, 14 seats weighted to the diff):** assessor, saboteur, breaker, prover, purist, engine-realist, typist, packager, spec-keeper, surfacer, changeset-auditor, coverage-auditor, decomplector, corner-prober.
- **Disposition:** **must-fix** → fixer loop → **pass** on re-review → appellate (advisory item addressed) → un-draft.

**Must-fix found and fixed (empirically confirmed by me and two independent seats):**
- `spring.throw()` enqueued a bare `Promise.reject(error)`; because the buffer's premise is a producer that runs ahead of the sink, the rejection floated with no handler until the sink pulled → a process-fatal `unhandledRejection` (reproduced under plain Node and SES/ava). The single throw test masked it by awaiting `sink.next()` in the same turn.
- **Fix** (`70d6e79`): routed all three spring methods through an `enqueue()` helper that attaches an inert `.catch(() => {})` so the queued promise is marked handled, while `makeQueue.get` still chains its own reaction so the sink observes the error. Added a **load-bearing** regression test (`process.on('unhandledRejection')` + real timer window); verified it reddens on the bug and passes on the fix.
- **Test-pinning** (`7d23bf0`): added a direct assertion for the `next(Promise.reject(...))` path, which the same helper covers; also verified load-bearing.
- Also applied the changeset sentence-per-line standing-rule fix.

**What changed on the PR head (`8cba46a9c` → `7d23bf082`):** `packages/stream/unbounded-buffer.js` (enqueue helper), `packages/stream/test/buffer.test.js` (2 new regression assertions, suite now 5 tests × 3 configs), `.changeset/stream-unbounded-buffer.md` (style).

**Follow-ups surfaced to the maintainer (via liaison; all non-blocking):**
- The identical latent pattern exists byte-for-byte in `makeStream.throw` (`index.js`) — deliberately **not** touched (out of scope; streams are pumped so the window doesn't arise). Flagged in case they want to propagate the guard.
- Design-taste items left for the maintainer's call: decomplector's speculative two-subpath split and the undocumented `./buffer/unbounded` export; by-design fire-and-forget behaviors (post-terminal `sink.next()` hangs; no terminal-op guard); JSDoc `@template T` vs `.d.ts` `TValue` naming nit.

**Verification evidence:** all 21 CI checks SUCCESS on `7d23bf082`, `mergeStateStatus: CLEAN`; local `ses-ava` 5/5 across lockdown/unsafe/endo configs, `tsc` clean, `eslint` clean (only a pre-existing `index.js:116` warning, untouched by this PR).
