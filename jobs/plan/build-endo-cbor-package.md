---
gate: go-ahead
priority: normal
roadmap: M4 Networking / @endo/cbor
role: builder
posted_by: gardener
posted_at: 2026-07-15T05:43:49Z
---

# Build: create `@endo/cbor` (phase 1) per the landed design in PR #710

**Design source (note the PRs):** the merged design PR
[endojs/endo-but-for-bots#710](https://github.com/endojs/endo-but-for-bots/pull/710)
— *"design: shared canonical CBOR primitives (@endo/cbor) for slot-machine and
ocapn"* — landed `designs/cbor-codec.md` on the `llm` roadmap branch. A follow-up
review on #710 answered the design's four open questions; those answers are folded
into the design by **PR [#738](https://github.com/endojs/endo-but-for-bots/pull/738)**
(*"resolve @endo/cbor open questions; rename @endo/cbors → @endo/cbor-frame"*).
**Read the design doc at the tip that includes #738 and implement against it; do not
re-derive it.** If #738 has not yet merged when this job runs, honor the resolved
answers restated in the "Open questions — RESOLVED" section below. This build is the
maintainer-requested follow-up (@kriskowal on #710, "incorporate these answers … and
then build the design").

**Repo:** `endojs/endo-but-for-bots`, **base `llm`** (maintainer directive on #710 —
"put it on `llm` and hope to port to origin/master when stable"; do not base-infer to
`master`). Draft PR; the build **auto-runs the gauntlet**.

## Scope — PHASE 1 ONLY

Implement **only phase 1** of the design's phased migration: **create the
`@endo/cbor` package** (`packages/cbor/`). Do **not** migrate the ocapn primitives
(phase 2) or the slots codec (phase 3, gated on #124 landing) or the daemon
envelope / `@endo/cbor-frame` head-import refactor (phase 4) in this build — those are
later, separately-gated steps. Migrating a consumer here would break the "don't ship a
private copy" sequencing.

The design also adds a **phase 0**: a shared well-formed-string ponyfill the codec
depends on (factor the check out of `@endo/ocapn`/`@endo/pass-style` into
`@endo/is-well-formed-string` or an `@endo/utf8` module — see the resolved OQ3 below).
Land or reuse that dependency rather than adding `@endo/pass-style` to `@endo/cbor`.
If it is not yet available, surface the gap rather than reaching for the native
`String.prototype.isWellFormed` (which XS may lack) or duplicating the check.

Build a hardened, functional, single-item primitive CBOR codec covering:
- the **shared subset**: canonical minimal-length heads (RFC 8949 §4.2.1),
  definite-length byte strings and arrays, null/simple values, uint heads, strict
  EOF/truncation discipline;
- the **ocapn-only grammar** the design folds in: text strings, maps, tag-2/3
  bignums, float64 with canonical NaN.

Per the resolved design: **writers are always canonical; readers are STRICT by
default** (reject non-minimal heads and non-minimal bignum payloads), with an opt-in
`{ lenient: true }` escape hatch retained only for a concrete tolerant-peer need.
Non-canonical NaN is rejected in every mode. Keep OCapN policy (record labels,
selectors, structure stack, `OcapnReader`/`OcapnWriter`) OUT of this package — it
stays in `packages/ocapn` as a consuming adapter in a later phase. Slot verbs stay in
`packages/slots`. The framing sibling is `@endo/cbor-frame` (the `@endo/cbors` name is
retired); do not reference the retired name.

Include the design's phase-1 acceptance artifact: a **shared golden-vector fixture**
for the codec, structured so it can be **mirrored into the Rust crate's tests**
(`rust/endo/slots/src/wire/codec.rs` is the byte-identical twin) — set up the fixture
now even though the Rust parity CI becomes the acceptance gate for the later slots
migration.

## Open questions — RESOLVED (maintainer review on #710, folded in by #738)
The design's four open questions are now settled; build to these, do not re-litigate:
1. **Naming** — `@endo/cbor` (codec) and `@endo/cbor-frame` (framing) are separate
   packages; the retired `@endo/cbors` name must not appear.
2. **Strict readers** — strict by default; `{ lenient: true }` is the only opt-out.
3. **`isWellFormed`** — do not rely on the native method; depend on the shared
   ponyfill (phase 0: `@endo/is-well-formed-string` or an `@endo/utf8` module),
   factored out of `@endo/ocapn`/`@endo/pass-style`, not duplicated.
4. **Base** — land phase 1 on `llm`; port to `origin/master` when stable.

Still **surface** in the PR body / `tada` report any point where implementation
forced a choice the design did not anticipate (e.g. the exact home chosen for the
well-formed-string ponyfill, or any interop concern with a peer that emits
non-canonical heads).

## Norms
- Load-bearing tests ([regression-evidence](../../skills/regression-evidence/SKILL.md))
  for the codec: round-trip vectors, canonical-minimal-head enforcement on write,
  strict-by-default read rejection (non-minimal heads/bignums) with the `lenient`
  opt-out accepting them, and truncation/EOF rejection.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).
- Fully-qualify issue/PR references; ASCII prose (house style).

## Done
A draft `feat` PR on base `llm` creating `@endo/cbor` (`packages/cbor/`) — the
hardened functional single-item primitive codec over the shared subset plus the
ocapn-only grammar, canonical writers, **strict-by-default readers** (with the
`lenient` opt-out), depending on the shared well-formed-string ponyfill (not
`@endo/pass-style`), and the shared golden-vector fixture prepared for Rust mirroring
— implemented per `designs/cbor-codec.md` as amended by #738, with load-bearing tests,
auto-gauntleted. The `tada` report links the PR, cites #710/#738 as the design
source, and notes any decisions forced during the build and anything held for the
later consumer-migration phases.
