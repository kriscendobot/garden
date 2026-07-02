---
model: fable
---
# Design: port XS to Rust ("endor engine") — feasibility, architecture, staged roadmap

Wear **roles/designer/AGENT.md**. Project: **`endojs/endo-but-for-bots`** (bot-pushable). Output:
`designs/xs2rust-endor-engine.md` on a `xs2rust-endor` branch, opened as a **DRAFT PR against `llm`**
(the roadmap branch). **Fork-scoped only — no upstream `endojs/endo` or `agoric/agoric-sdk` interaction**
(no comments, PRs, issue/PR links, merges).

**Program context (read this before the brief).** This design is stage 1 of the supervised program
`port-xs-to-rust-memory-safe-engine` (a Fable supervisor on the job board). Two deviations from the
designer role's defaults, both set by the program spec and taking precedence:

1. **The implementation will land on the SAME PR as this design.** A later builder job accretes the
   Rust implementation onto the same branch/PR (the design doc and the implementation share one pull
   request). So name the branch `xs2rust-endor` (not `design/`-scoped) and write the design as the
   in-tree spec the implementation will sit beside.
2. **Open questions are answered by the supervisor, not the maintainer.** Write your `## Open questions`
   section as usual — be explicit and exhaustive — but know that a Fable supervisor (not the human
   maintainer) will make each engineering decision and post design revisions until none remain. Frame
   each question so a decision can actually be made (state the options and the trade-off).

In your tada completion report, name the design slug, the branch, and the **PR number** — the supervisor's
next stage reads your report to find the PR.

## The design brief (verbatim from the program)

Port **XS** (Moddable's interpreted JS engine, as consumed by Endo's xs-worker / agoric-sdk `xsnap`) to
**Rust**, as a crate **endor** embeds, to raise confidence in memory safety while preserving what makes XS
uniquely suited to Endo/agoric. The design must carry ALL of these hard requirements:
1. **Preserve metering, debugger, snapshot-persistence.** Metering = deterministic CPU+memory metering
   reproduced EXACTLY vs C-XS (a consensus requirement; a divergence is a consensus fault) or a stated
   determinism-equivalence proof. Debugger = the XS debugger protocol/inspection surface. Snapshot =
   heap save/restore (the xsnap lifecycle); decide the FORMAT question (read existing XS snapshots vs a
   Rust-native format + migration).
2. **Minimize `unsafe`** — an `unsafe` budget + per-use justification, isolated behind audited modules.
3. **Increase memory-safety confidence** — the headline metric, weighed against perf.
4. **No JIT, ever** — interpreter-only (bytecode/threaded) for determinism, metering, security, footprint.
5. **HardenedJS / Compartment first-class** — native `Compartment`, `lockdown`/SES, hardening primitives.
6. **High test262 coverage → parity with C-XS.** A conformance harness, the coverage bar, and how coverage
   is bootstrapped and tracked to parity. **test262 parity is the acceptance bar for the build phase.**
7. **Fuzzability** — cargo-fuzz/libFuzzer, structure-aware parser+interpreter fuzzing, differential fuzzing
   vs C-XS.
8. **Better endor integration** — embed as a Rust crate instead of the C `xsnap` subprocess; reconcile with
   the `daemon-endor-architecture.md`, `daemon-rust-xs-performance.md`, `daemon-endo-rust-sqlite.md`, and
   `daemon-xs-worker-{metering,debugger,snapshot}.md` design cluster.

Investigation to weigh: build approaches (from-scratch vs extend a Rust engine like Boa vs hybrid), the
determinism/metering bar (the crux; validate equivalence via differential testing on test262 + agoric
contract corpora), snapshot compatibility + debugger protocol, and the footprint/perf envelope. Deliverable
is a feasibility verdict + architecture design + a STAGED roadmap (a thin first slice proving the
metering-determinism + Compartment bar and bootstrapping test262 coverage, then iterate). Design doc lands
under `designs/` on `endojs/endo-but-for-bots`.

## Library and project references

Assembled by the supervisor's research pass; treat as the floor, not the ceiling (library-lookup applies).

Project design cluster (in-repo, `designs/` — requirement 8 demands reconciliation with these):
- `designs/daemon-endor-architecture.md` — the unified Rust binary with three worker platforms and
  byte-identical CBOR envelopes; the crate this engine embeds into.
- `designs/daemon-rust-xs-performance.md` — the three-variant benchmark as bottleneck triangulation;
  `fxHasPendingJobs` as check-and-reset latch. Status: active, not complete.
- `designs/daemon-endo-rust-sqlite.md` — the Rust/SQLite persistence substrate.
- `designs/daemon-xs-worker-metering.md`, `designs/daemon-xs-worker-debugger.md` (six-layer XML
  pass-through, dormant-by-default, break-on-uncaught via firstJump walk),
  `designs/daemon-xs-worker-snapshot.md` — the three preserved-surface designs requirement 1 names.
- `designs/endor-run-expanded.md` — CAS-backed module loading; XS-hosted compartment-mapper reuse.

Garden library (journal worktree, `library/`):
- `library/topics/hardened-javascript.md`, `library/topics/compartments.md`, `library/topics/daemon.md`
- `library/sections/endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes.md`
- `library/sections/endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--status-active-not-complete.md`
- `library/sections/endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk.md`
- `library/sections/endo--docs-guide--realms-and-compartments.md` and the sibling `endo--docs-guide--hardenedjs-story.md`

External ground truth to consult (read-only research; no interaction): Moddable XS sources
(`Moddable-OpenSource/moddable`, `xs/` — the bytecode set, `fxRunID` interpreter loop, metering hooks,
snapshot writer/reader `xsSnapshot.c`, `xsdb` debugger protocol), `agoric-sdk/packages/xsnap` (the meter
schema and the consensus-facing `metering` vectors), Boa / Nova / Kiesel as Rust-engine datapoints, and
tc39/test262 harness structure.
