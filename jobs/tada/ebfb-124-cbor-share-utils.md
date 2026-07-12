Job complete. Completion report:

---

**Job `ebfb-124-cbor-share-utils` (designer): design for sharing CBOR utilities between slot-machine and ocapn — DONE.**

**What I did.** Surveyed the CBOR usage the maintainer flagged in the PR #124 review and found the duplication is actually three-way in JavaScript, plus a Rust twin: `packages/slots/src/cbor.js` (PR #124, ~245 lines: uint/byte-string/array/null with minimal-length heads, byte-identical with `rust/endo/slots/src/wire/codec.rs`), the module-level primitive helpers inside `packages/ocapn/src/cbor/{encode,decode}.js` (~1300 lines, same head grammar underneath OCapN policy), and a third inline copy in `packages/daemon/src/envelope.js`. The common subset both named consumers rely on is canonical minimal-length head encoding (RFC 8949 section 4.2.1), definite-length byte strings and arrays, null/simple values, uint heads, and strict EOF/truncation discipline.

**The design** (`designs/cbor-codec.md`, slug `cbor-codec`) proposes `@endo/cbor` at `packages/cbor/`: a hardened, functional, single-item primitive codec covering the shared subset plus the ocapn-only grammar (text strings, maps, tag-2/3 bignums, float64 with canonical NaN). Writers are always canonical; readers are tolerant by default with an opt-in `strict` mode for signature-verification paths. OCapN's `CborWriter`/`CborReader` classes and policy stay in `packages/ocapn` as a consuming adapter; the slot verbs stay in `packages/slots`, whose `src/cbor.js` API was deliberately mirrored so its migration is import-path-only. Migration is phased: (1) create the package with a golden-vector fixture mirrored into the Rust crate's tests, (2) migrate ocapn's primitives, (3) migrate slots after #124 lands with the Rust parity CI lane as the byte-identity acceptance gate, (4) optionally migrate the daemon envelope codec. Four open questions are surfaced for the maintainer: the `@endo/cbor`-vs-`@endo/cbors` naming adjacency, strict reads for ocapn signature verification, `String.prototype.isWellFormed` availability on XS, and landing-base sequencing relative to #124.

**What changed.**
- Draft PR **endojs/endo-but-for-bots#710** (`design/cbor-codec` -> `llm`), carrying `designs/cbor-codec.md` and the required `designs/README.md` sync (summary table row, M4 Networking bucket and count 6->7, per-design estimate S/2-3 days, header and recently-added list). Commit `907af3b7a`.
- Cross-link comment posted on PR #124 pointing at the design (standing authorization on this repo): https://github.com/endojs/endo-but-for-bots/pull/124#issuecomment-4951709305

**Verification status.** The design file and README edits are committed and pushed (PR #710 renders them); house-style checks (no em-dashes, no Latin shorthand, no hard code points) ran clean; no mermaid fences were added so no diagram validation was needed. The design itself is a proposal, not runnable code: not verified by execution, by nature of the deliverable.

**Follow-ups.** The refactor is a follow-on build once the maintainer agrees on the shared surface: phase 1+2 (`packages/cbor` + ocapn migration) can be one build job independent of #124; phase 3 (slots migration) is gated on #124 landing. The `@endo/bytes` byte-cursor extraction named in the design is a tracking issue to be filed if the maintainer wants it.

Self-improvement: nothing this time.
