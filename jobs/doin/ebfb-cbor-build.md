# build: create @endo/cbor (shared canonical CBOR primitives), phase 1

Repo: endojs/endo-but-for-bots
Design: `designs/cbor-codec.md` (on the `llm` roadmap branch; merged design PR
https://github.com/endojs/endo-but-for-bots/pull/710).
Unblocks: https://github.com/endojs/endo-but-for-bots/pull/124 (slot-machine).

Requested by @kriskowal:
https://github.com/endojs/endo-but-for-bots/pull/710#issuecomment-4976902397
("Please dispatch a builder. This will unblock progress on #124.")

## Task

Implement **phase 1 only** of the design: create the new leaf package
`packages/cbor/` (`@endo/cbor`) — a hardened, functional, single-item CBOR
primitive codec covering the shared subset (canonical minimal-length heads,
definite byte strings/text strings/arrays/maps, uint/int heads, tags,
tag-2/3 bignums, float64 with canonical NaN, simple values), with the API
surface, number-domain, canonicality posture (canonical writers; readers
tolerant by default, strict by option), and buffer state described in the
design. Do NOT do phases 2-4 (ocapn/slots/daemon migration) — those are
separate follow-ups; phase 3 (slots) is gated on #124 landing.

Deliverables per the design's Test Plan:
- The package with the exported API in `packages/cbor/index.js`, every export
  hardened, errors via `@endo/errors` carrying reader `name` + byte offset.
- Deps: `@endo/errors`, `@endo/harden` (workspace:^). Use engine-native
  `String.prototype.isWellFormed` for text-string well-formedness (local
  fallback if XS lacks it — Open Question 3).
- A golden `(diagnostic, hex)` vector fixture covering the argument-width
  boundaries, every in-scope major type, canonical NaN, and bignum edge cases,
  plus the ported cases from `packages/slots/test/cbor.test.js` and the
  primitive-level cases from `packages/ocapn/test/cbor/{encode,decode}.test.js`,
  and the strict-mode cases (non-minimal heads, truncation, trailing bytes).

## Base branch

Follow the builder base-inference rule. `@endo/cbor` is a new leaf; its only
deps (`@endo/errors`, `@endo/harden`) exist on `master`, and the design's
phase-1 guidance names `master` (forward-merged to `llm`/`endor` in the
ordinary course). Base on `master` unless package-availability inference says
otherwise. The design read lives on `llm`; the implementation is a separate PR
on a master-line base.

## Notes for the builder

- Read `designs/cbor-codec.md` at its path on `llm` first; treat the design as
  the spec (identifier spellings follow the slots file so the later slots
  migration is import-path-only).
- Open Questions 2 and 4 (ocapn strict-mode; land-order vs #124) are
  maintainer calls at later phases — do not block phase 1 on them.
- Standard gauntlet applies (draft PR -> clean -> panel -> fix-loop ->
  un-draft) under the supervising gardener.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-15T04:39:40Z
