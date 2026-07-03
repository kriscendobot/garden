# scholar: ingest danfinlay/quickjs @ native-ses for XS-evolution implementation strategies

**Read-only ingestion into the context library** (`journal/library/`). No PR/issue interaction anywhere; this is research distillation, not fork work.

## Source

<https://github.com/danfinlay/quickjs/tree/native-ses> — danfinlay's QuickJS fork on branch `native-ses` (QuickJS with **native SES** support). Clone/read the branch; study how it implements SES/HardenedJS primitives natively in a small C interpreter.

## Lens (kriskowal, 2026-07-03)

Ingest it **with an eye for useful implementation strategies that might translate to evolution on XS**, explicitly **weighing performance considerations against the aversion to JIT or other memory-unsafety concerns that might undermine the security of a simpler machine.** Concretely, distill:

- **How native SES is realized** here (Compartment / `lockdown` / hardening / intrinsics isolation) at the engine level, and which of those strategies could inform XS's own native Compartment/SES surface.
- **Implementation techniques that could translate to XS** (interpreter structure, intrinsics handling, membrane/immutability mechanics, evaluator/parser choices), called out as candidate ideas for XS evolution.
- **The performance-vs-safety tradeoff for each idea**: where a technique buys speed by leaning on JIT or memory-unsafe constructs, flag it as **out of bounds** for the garden's direction (no JIT, minimal `unsafe`, determinism/metering, a small auditable machine); where it buys safety/simplicity at a perf cost, weigh it. Safety of the simpler machine is the priority; performance is weighed against it, not above it.

## Connect to existing work

Cross-link to the active **XS→Rust (Endor)** design cluster: `designs/xs2rust-endor-engine.md` (PR #600 on `endojs/endo-but-for-bots`) and the `daemon-xs-worker-{metering,debugger,snapshot}.md` / `daemon-rust-xs-performance.md` cluster. Where a QuickJS-native-ses strategy bears on a resolved question or open item in that design, note it so the XS→Rust program can pick it up.

## Deliverable

A context-library entry (per `skills/context-library` / `skills/journalism` / `library-lookup`) distilling the above — the transferable strategies, each with its perf-vs-JIT/memory-safety verdict — indexed so the XS→Rust designers/builders can find it, and cross-linked to the Endor design cluster. Journal a `result` entry pointing at the library page.

---
claim:
  host: endolinbot2
  gardener: 3
  claimed_at: 2026-07-03T05:56:33Z
