Everything is verified and in place. Here is my completion report.

---

## Completion report — review directive on endojs/endo-but-for-bots PR #710

**Preflight:** ran `pr-feedback-preflight.sh` → **PROCEED** (no peer had resolved it).

**Enumerated the review** (id `4701270186`, by @kriskowal, on the now-merged #710). Review body: *"dispatch a builder to incorporate these answers to open questions in the design and then build the design."* Plus four inline comments on `designs/cbor-codec.md`, each answering one Open Question. All five asks resolved — I incorporated the answers directly (a bounded, fully-specified edit) rather than deferring them into the build, then routed the build:

**1. Incorporated the answers — PR [#738](https://github.com/endojs/endo-but-for-bots/pull/738) against `llm`** (design-docs only, now `MERGEABLE`):
- **OQ1 (naming):** swept every `@endo/cbors` mention → `@endo/cbor-frame`; renamed `designs/cbors.md` → `designs/cbor-frame.md` and rewrote it for the package that actually shipped in #288 (`makeCborFrameReader`/`makeCborFrameWriter`, `packages/cbor-frame/`, status Implemented, naming rationale flipped from the retired plural to the `-frame` suffix); recorded that `@endo/cbor-frame` stays deliberately minimal and may import head primitives from `@endo/cbor` (phase 4).
- **OQ2 ("be strict"):** readers are now strict by default (reject non-minimal heads/bignum payloads), with a `{ lenient: true }` opt-out retained only for a concrete tolerant-peer need.
- **OQ3 (`isWellFormed`):** do not rely on the native method; depend on a shared ponyfill factored out of `@endo/ocapn`/`@endo/pass-style` into `@endo/is-well-formed-string` or an `@endo/utf8` module (added as phase 0), not duplicated.
- **OQ4 (base):** phase 1 lands on `llm`, ported to `origin/master` when stable.
- Also swept `README.md`, `gateway-package.md`, `syrups.md` (fixed the broken `cbors.md` links). Rebased onto current `llm` and resolved one README conflict (kept the incoming `endo-reminder` M3 row + my `cbor-frame` M4 row).

**2. Routed the build:** corrected the already-parked plan job `build-endo-cbor-package` (it predated this review and carried stale defaults — tolerant readers, `@endo/cbors`). Pushed to `journal2` so it now builds strict-by-default, `@endo/cbor-frame` naming, the shared ponyfill dependency, base `llm`, against the design as amended by #738.

**3. Closed the loop on GitHub:** posted four inline replies (one per Open Question, citing #738) + a top-level comment on #710 addressing the review-body directive.

**Follow-up filed (parked):** `endojs-endo-but-for-bots-syrups-naming-reconcile` — the syrups design docs (`ocapn-tcp-syrups-framing.md`, `syrups.md`) still recommend the retired `@endo/syrups` plural while the package shipped as `@endo/syrup-frame`; that plural-naming analysis is the syrups design's own reconciliation, deliberately not rewritten inside this CBOR review. This is the only remaining `@endo/cbors` residue, and it's confined to that stale argument.

Inbox drained (empty). No `main2` changes — this job touched the project repo and journal only.
