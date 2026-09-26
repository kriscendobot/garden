Inbox empty. The job is complete.

## Completion report

**Job:** `ironhorse-computron-benchmark-baseline-design` (role: designer) — expand the maintainer directive on endojs/endo-but-for-bots PR #1282 into a plan for benchmark-established computron baselines, and land it on a review surface.

**What I did**
- Read the source directive (PR #1282 review comment, kriskowal 2026-09-15) and treated it as data. Studied PR #1282's full touch-list, the existing metering infrastructure (`golden_computrons.rs`/`computrons.tsv`, `scaling_bench.rs`, `benches/run.py`+`baseline.json`, the `ironhorse-meter` crate, the nightly `benchmarks` CI job), and the accuracy-over-parity doctrine in `designs/ironhorse-engine.md` § Metering.
- Wrote `designs/ironhorse-computron-benchmark-baseline.md`, covering all five deliverable points:
  1. **Benchmarking approach** — a per-load cost model `C_model(n) = coef·f(n) + b`, `f(n)` from a closed growth-class set, fit from *deterministic* computron counts across a size ladder.
  2. **Ranges/bounds** — three gates: exact pins (PR CI), a deterministic growth-envelope (PR CI), and a nightly wall-clock faithfulness gate. Key insight: because computrons are deterministic (`computrons == meter_raw >> 16`), the range constraint gates cheaply on PR CI, and the noisy benchmark is reserved for confirming the meter stays a faithful CPU-time proxy.
  3. **Polynomial built-ins** — `f(n)` scaling, tied to the engine's existing `*_PER_ELEMENT`/`chunk_cost`/`string_chunk_cost` pricing and the `ironhorse-meter-opcode-cost-instrumentation` complexity model; seed roster covers named-property insertion (known quadratic), string/regexp/collection ops, and the async-gen loads #1282 relaxed.
  4. **Fate of PR #1282** — explicit recommendation to **revise in place** (its demolition is doctrine-correct), with a coverage-gap-free sequencing and a builder audit step; rejected supersede and partial-keep with justification.
  5. **Execution steps** for the sibling `ironhorse-computron-benchmark-baseline-build` job.
  - Includes an `## Open questions` section (tolerance bands, gate-2 lane placement, seed roster, recalibration policy, #1282 sequencing, two-input grids) and the captured prompt.
- Validated the design's mermaid diagram parses (`OK flowchart-v2`), and re-validated both README diagrams after editing (`OK flowchart-v2`, `OK gantt`).
- Synced `designs/README.md`: summary-table row, dependency-graph node (`ihengine --> ihbaseline`), M11 milestone one-liner, and a totals-block note.

**What changed / evidence**
- Design slug: `ironhorse-computron-benchmark-baseline`; branch `design/ironhorse-computron-benchmark-baseline`; commit `5a823f411`.
- **Draft PR endojs/endo-but-for-bots#1283** against `llm`, verified `isDraft: true`, `state: OPEN`, diff = exactly the two design files. Left draft per designer norms; the completion machinery auto-stages the design-panel gauntlet.

**Follow-ups**
- Sibling build job `ironhorse-computron-benchmark-baseline-build` (named in the job spec) executes the plan; not yet on the board — the liaison/foreman posts it.
- The build's step 1 (audit of loads #1282 left unconstrained) and the maintainer's answers to the open questions gate implementation specifics.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-computron-benchmark-baseline-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4360363 cached reads)
- Output: 41254 tokens
- Cost: $5.1046665
- Wall-clock: 695s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
