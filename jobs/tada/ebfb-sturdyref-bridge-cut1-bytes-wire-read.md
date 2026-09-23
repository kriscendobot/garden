Inbox empty. The job is complete.

## Completion report

**Job:** Bridge cut 1 — bytes-preserving SturdyRef wire read (design #697, cut 1), repo `endojs/endo-but-for-bots`.

**What I did**
- Read the design (`designs/sturdy-refs-cross-peer-bridge.md` § 1 + cut table row 1 @ `5aee6e0b4e2c`) and the `sturdyref` concept doc; got an isolated project worktree off `build/sturdyrefs-endor-syscall-retention` (re-verified live HEAD `fab626e84a`).
- Fixed `OcapnSturdyRefCodec` read (`packages/ocapn/src/codecs/descriptors.js`) to keep non-ASCII swiss-nums as bytes.

**Key finding (design premise corrected).** The design's cut-1 row says the read "throws at decode" on a non-ASCII secret. It does not: `new TextDecoder('ascii', { fatal: true })` resolves to the WHATWG **windows-1252** decoder, which never throws and *silently corrupts* bytes `> 0x7f` into a lossy string (the write path's `encodeSwissnum` would then reject that string). A naïve try/catch/fall-back-to-bytes (which is what `sturdyRefTracker.lookup` does, and what a literal reading of the cut would replicate) can therefore *never* reach its bytes branch. I instead made the ASCII decision **explicit** — `secretBytes.every(b => b <= 0x7f)` — materializing a string only for strictly-ASCII swiss-nums and keeping the raw `Uint8Array` otherwise. This achieves the cut's stated intent and passes its verbatim test plan.

**Changes (branch `build/sturdyref-bridge-1-bytes-wire-read`, commit `948aec29ac`)**
- `src/codecs/descriptors.js` — bytes-preserving read via explicit ASCII check.
- `src/client/ref-kit.js` — widened `makeSturdyRef` JSDoc type to `string | Uint8Array` (matches the underlying tracker; resolves the surfaced type error).
- `test/codecs/passable.test.js` + snapshots — new round-trip entry (syrup + cbor) for a fixed non-ASCII 24-byte swiss-num, asserting byte-for-byte round-trip **and** a confinement sweep of the materialized SturdyRef's own properties + full prototype chain (secret bytes unreachable).

**Evidence (real execution)**
- Wire snapshot shows the 24 bytes `9f1ca300ff80427eb5d401c8916afe3388a10fcc77e25b90` riding verbatim (syrup `24:…`, cbor `h'…'`); read-back deep-equals the original.
- `yarn test` in `packages/ocapn`: **536 tests passed**; targeted `test/codecs/passable.test.js`: 85 passed incl. both new byte-secret cases (green without `--update-snapshots`, i.e. snapshots match).
- `yarn lint`: **0 errors, exit 0** (176 pre-existing `any` warnings only).

**Confinement property preserved: opaque-and-unforgeable** — the load-bearing test verifies the secret bytes are reachable from neither the materialized SturdyRef's own properties nor its prototype chain.

**PR:** [endojs/endo-but-for-bots#698](https://github.com/endojs/endo-but-for-bots/pull/698) — **DRAFT** (kept draft per the effort's press charter), base `build/sturdyrefs-endor-syscall-retention`, head `build/sturdyref-bridge-1-bytes-wire-read`. No push to any `design/*` or protected build branch.

**Follow-up (out of scope for cut 1):** `sturdyRefTracker.lookup` in `src/client/sturdyrefs.js` carries the identical never-throws defect (its byte-fallback is dead code); recommend a sibling fix. Flagged in the PR body.
