---
model: opus
---
# Build roadmap stage 1 of the xs2rust-endor engine port (thin slice) on PR #600

Role: **builder**. Repo: `endojs/endo-but-for-bots`. Branch: `xs2rust-endor` (base `llm`).
PR: https://github.com/endojs/endo-but-for-bots/pull/600 — the APPROVED design
`designs/xs2rust-endor-engine.md` lives on this same branch; the implementation accretes onto the
SAME branch and PR. **Keep the PR draft**; do not un-draft, do not tag the maintainer. This job is
stage 3 (BUILD, first increment) of the supervised program `port-xs-to-rust-memory-safe-engine`;
open questions in the design are already resolved (§ Resolved Questions) and are binding — reopening
one requires a message to the supervisor, not a unilateral code change.

## Task

Implement **roadmap stage 1 (thin slice)** exactly as specified in
`designs/xs2rust-endor-engine.md` § Staged Roadmap, § Architecture, and § Resolved Questions:

1. A new Cargo workspace at `rust/engine/` with crates `endor-vm`, `endor-oracle`, `endor-262`,
   `endor-fuzz` (resolved question 7/9). `#![forbid(unsafe_code)]` on every crate except
   `endor-oracle` (requirement 2).
2. `endor-vm`: the index-arena value/heap model (`SlotIndex(u32)` slot arena with 32-byte records,
   resolved question 5; `ChunkOffset(u32)` chunk arena; CESU-8 strings, resolved question 4), the
   Vec-backed slot stack with XS frame geometry, and a `match`-dispatch interpreter over the
   arithmetic/logic/branch/call/stack subset of the `XS_CODE_*` ISA (opcode enum with XS's sizes and
   names from `xsCommon.h`/`gxCodeSizes`/`gxCodeNames`).
3. The meter: `u64` in 16.16 fixed point, increments at exactly XS's points with exactly XS's
   weights (1<<16 per bytecode dispatch, 1<<14 per builtin step), checks ONLY at loop-closing points
   (backward branch, call, return, catch), host callback sees `meterIndex >> 16` (design § Metering).
4. `endor-oracle`: dev/CI-only harness that uses the in-tree `c/moddable` pin (resolved question 1)
   through the existing `rust/endo/xsnap` crate as a path dependency, to (a) compile JS source to XS
   bytecode and (b) execute it on C-XS, returning (result, computron) pairs for comparison.
5. A primordial `Compartment.evaluate` seam: fresh per-compartment globals over a shared-intrinsics
   seam, no modules yet (design § Hardened JavaScript; this proves the requirement-5 seam early).
6. `endor-262`: the dual-run harness skeleton with a stage-1 curated corpus checked into
   `endor-262/corpora/` (arithmetic, logic, control flow, calls), recording four-valued agreement
   plus computron agreement.
7. `endor-fuzz`: cargo-fuzz targets 1 (differential source fuzzing, structure-aware) and
   2 (bytecode decoder) per design § Fuzzability, buildable even if only run locally/nightly.

**Acceptance bar (from the design, verbatim): bit-exact (result, computron) agreement with the
oracle on the stage corpus; `forbid(unsafe_code)` holds outside `endor-oracle`.** Run the harness
and paste real output in the PR/report; do not claim the bar without evidence. If the bar cannot be
reached, that is a kill-criterion signal: report the divergences precisely (which opcode/builtin,
expected vs actual computrons) rather than papering over them.

Practicalities: read `designs/xs2rust-endor-engine.md` first, then the XS sources under the
`c/moddable` submodule (`xs/sources/xsRun.c`, `xsCommon.h`, `xsMemory.c`) as ground truth. Follow
repo commit conventions and style rules (no em-dashes, no Latin shorthand). Multiple commits are
fine; keep each independently green. Update the PR description with a stage-1 status section when
done. Report back: what landed, harness output demonstrating the acceptance bar (or the precise
divergence list), and any design frictions the supervisor should rule on.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolinbot2
  gardener: 3
  claimed_at: 2026-07-02T19:38:31Z
