---
gate: go-ahead
priority: normal
roadmap: M4 Networking / @endo/cbor
role: builder
posted_by: gardener
posted_at: 2026-07-15T05:43:49Z
---

# Build: create `@endo/cbor` (phase 1) per the landed design in PR #710

**Design source (note the PR):** the merged design PR
[endojs/endo-but-for-bots#710](https://github.com/endojs/endo-but-for-bots/pull/710)
— *"design: shared canonical CBOR primitives (@endo/cbor) for slot-machine and
ocapn"* — landed `designs/cbor-codec.md` on the `llm` roadmap branch. **Read that
design doc first and implement against it; do not re-derive it.** This build is the
maintainer-requested follow-up (@kriskowal on #710, "note the PR for the build").

**Repo:** `endojs/endo-but-for-bots`, base per the builder base-inference rule (the
design lives on `llm`; implement on the project's implementation base — read the
design, then infer the base from where the touched packages exist, per
`roles/builder/AGENT.md`). Draft PR; the build **auto-runs the gauntlet**.

## Scope — PHASE 1 ONLY

Implement **only phase 1** of the design's phased migration: **create the
`@endo/cbor` package** (`packages/cbor/`). Do **not** migrate the ocapn primitives
(phase 2) or the slots codec (phase 3, gated on #124 landing) or the daemon
envelope (phase 4) in this build — those are later, separately-gated steps. Migrating
a consumer here would break the "don't ship a private copy" sequencing the design's
open question 4 is about.

Build a hardened, functional, single-item primitive CBOR codec covering:
- the **shared subset**: canonical minimal-length heads (RFC 8949 §4.2.1),
  definite-length byte strings and arrays, null/simple values, uint heads, strict
  EOF/truncation discipline;
- the **ocapn-only grammar** the design folds in: text strings, maps, tag-2/3
  bignums, float64 with canonical NaN.

Per the design: **writers are always canonical; readers are tolerant by default with
an opt-in `strict` mode.** Keep OCapN policy (record labels, selectors, structure
stack, `OcapnReader`/`OcapnWriter`) OUT of this package — it stays in
`packages/ocapn` as a consuming adapter in a later phase. Slot verbs stay in
`packages/slots`.

Include the design's phase-1 acceptance artifact: a **shared golden-vector fixture**
for the codec, structured so it can be **mirrored into the Rust crate's tests**
(`rust/endo/slots/src/wire/codec.rs` is the byte-identical twin) — set up the fixture
now even though the Rust parity CI becomes the acceptance gate for the later slots
migration.

## Open questions — follow the design's stated defaults, surface decisions
The design carries open review questions; do not silently pick against them. Follow
the design's stated defaults (tolerant readers, canonical writers, `@endo/cbor`
naming beside the framing sibling `@endo/cbors`), and **surface** in the PR body /
`tada` report any point where implementation forced a choice — especially:
`isWellFormed` availability on XS (a local fallback vs. a `@endo/pass-style`
dependency) and whether ocapn signature-verification paths will eventually want
`strict` reads.

## Norms
- Load-bearing tests ([regression-evidence](../../skills/regression-evidence/SKILL.md))
  for the codec: round-trip vectors, canonical-minimal-head enforcement on write,
  tolerant-vs-strict read behavior, and truncation/EOF rejection.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).
- Fully-qualify issue/PR references; ASCII prose (house style).

## Done
A draft `feat` PR creating `@endo/cbor` (`packages/cbor/`) — the hardened functional
single-item primitive codec over the shared subset plus the ocapn-only grammar,
canonical writers, tolerant/`strict` readers, and the shared golden-vector fixture
prepared for Rust mirroring — implemented per the landed `designs/cbor-codec.md`,
with load-bearing tests, auto-gauntleted. The `tada` report links the PR, cites #710
as the design source, and notes any open-question decisions forced during the build
and anything held for the later consumer-migration phases.
