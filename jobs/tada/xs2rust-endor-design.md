Job complete. Completion report:

**Design slug:** `xs2rust-endor-engine` · **Branch:** `xs2rust-endor` · **PR:** endojs/endo-but-for-bots **#600** (DRAFT, base `llm`) — https://github.com/endojs/endo-but-for-bots/pull/600

**What I did.** Wore the designer role and produced `designs/xs2rust-endor-engine.md` (commit 595723643): feasibility verdict, architecture, and a 9-stage roadmap for porting XS to Rust as the engine the `endor` daemon embeds. Grounded in two research passes against primary sources: (1) XS/xsnap internals (fxRunID dispatch over the 245-opcode `XS_CODE_*` ISA; meter increments at 1<<16 per bytecode / 1<<14 per builtin step with checks only at loop-closing points; the FourCC snapshot atom grammar with index/offset projection; the xsbug XML protocol; ~75 KLOC core; Agoric's divergent XS 13.3 integer meter and current `xs-meter-37`), and (2) the Rust engine landscape (Boa 95.4% test262 but no metering/snapshot/SES; Nova 77.2%; Kiesel is Zig on Boehm GC; Brimstone single-author), which grounds the build-approach verdict: **oracle-locked transliteration of XS** (same ISA, meter points, snapshot grammar, debugger protocol; index-arena heap; `forbid(unsafe_code)` engine crates; C-XS as a permanent differential (result, computron) oracle in CI). All eight program requirements are carried; the thin first slice proves or kills the metering-determinism crux and the Compartment seam while bootstrapping the dual-run test262 harness; kill criteria are named. Reconciliation table covers the whole `daemon-endor-*` / `endor-run-expanded` cluster via the existing `Machine` API seam.

**Program deviations honored:** branch named `xs2rust-endor` (not `design/`-scoped) since the builder stage accretes the implementation onto this same PR; the 10 open questions are framed as decidable options-with-trade-offs for the Fable supervisor, each with a recommendation.

**Also changed:** `designs/README.md` per repo conventions — summary-table row, M11 milestone table row and goal text, XXL estimate row (20-30 weeks), M11 items 2→3 with effort/timeline/totals widened, recently-added entry, last-updated line.

**Verification status:** design-only diff; style rules checked by grep (no em-dashes, no Latin shorthand: clean); branch push and PR creation verified by command output above. No runtime surface to exercise.

**Follow-ups:** the supervisor's next stage should read PR #600, resolve the open questions (notably oracle pin, meter-version stance, and crate naming), then post the stage-1 builder job targeting the same branch.

Self-improvement: nothing this time.
