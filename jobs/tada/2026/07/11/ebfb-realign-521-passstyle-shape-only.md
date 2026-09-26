The press-driver had already completed (its cycle ended); the message was dead-lettered so its intent isn't lost. The job is complete.

## Completion report

**Job:** Realign PR #521 (`endojs/endo-but-for-bots`) to the shape-only sturdyref design — cuts 1–2 of `designs/sturdy-refs-ocapn-enlivenment.md`.

**What I did** — pushed additive commit `d3c68897b` on top of `0ad8d1b02` to `build/sturdyrefs-pass-style-ocapn` (original commit untouched; PR stays **DRAFT**):

- **Cut 1 — `@endo/pass-style` is now shape-only.** `SturdyRefHelper` recognises/validates **structurally** with no mint-gating WeakMap and no maker. A valid SturdyRef is an instance with no own properties whose tag-record prototype carries `[Symbol.for('passStyle')]: 'sturdyref'`, `[Symbol.toStringTag]: 'SturdyRef'`, a get-only non-enumerable `location` accessor returning a deep-frozen parsed `OcapnLocation` copyRecord, and an optional get-only non-enumerable string `type` hint accessor (advisory, excluded from identity). Removed the exported `makeSturdyRef` maker **and** the misspelled `getStudyRefLocator`; rewrote the `SturdyRef` type and the pass-style test suite for the shape.
- **Cut 2 — `@endo/ocapn` constructs.** The sturdyref tracker (CapTP session manager) mints instances satisfying the pass-style shape and holds the off-band `(location, secret[, type])` map keyed by SturdyRef identity, per-instance; enliven/reveal read the session manager's own map. Updated the ocapn suite where it asserted the old hidden-`location` behavior — `location` is now readable by design.

**Confinement statement (required):** the raw SturdyRef is the trusted/wire tier and carries a readable `location` **by design**; the confined-guest surface is the daemon boundary (cuts 3–4, not this PR). This cut's confinement obligation — the swiss number is never readable from a SturdyRef — is tested over own properties **and** the full prototype chain.

**Verification (cited):** fresh worktree, `corepack yarn install` first, then real suites — `@endo/pass-style` **68 tests passed**, `@endo/ocapn` **534 tests passed**, `@endo/marshal` **82 tests passed**, all across the SES lockdown/unsafe/endo configs; `tsc` and `eslint` **0 errors** on both changed packages (only pre-existing `jsdoc/any`-type warnings, consistent with surrounding code).

**Posted** a summary comment on PR #521 linking the design sections and noting the guest-token confinement tier is a later cut.

**Follow-ups (deliberately out of scope, noted on the PR):**
1. `M.sturdyRef()` / `M.kind('sturdyref')` in `@endo/patterns` — blocked on `@endo/marshal` rank-order for sturdyref (marshal deliberately excludes it from the prefix table), so it would balloon scope; deferred per the design's guidance.
2. The per-client enlivenment cache (`sturdyRefToEnlivened`) is retained; the design's § *Enlivenment is on demand* says enlivenment should not cache — an enlivenment-semantics change orthogonal to the shape realignment.
3. Cuts 3–4 (daemon facet threading + guest opaque-token distributed confinement) remain.

**Peer coordination:** notified the `endo-sturdyref-press` driver; it had already completed, so the message was dead-lettered for promotion (intent preserved).
