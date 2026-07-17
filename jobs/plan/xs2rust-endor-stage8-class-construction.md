---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage8
priority: normal
posted_by: producer
posted_at: 2026-07-17T10:51:27Z
---

---
model: opus
---
# Stage-8 child 4/6 — engine: class-instance construction (the big rock)

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Build child of serial orchestration
`xs2rust-endor-build-stage8`; tada-only reporting. One 2400s invocation. The Rust workspace is
`rust/engine` (NOT the repo root).

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip; push via CAS, verify by exit code. Seed
`rust/engine/target/` by hardlink-copy from a sibling scratch worktree at the same commit
(`cp -al`), and `c/moddable` likewise (if it exists empty, `rmdir` first to avoid nesting);
confirm tip sha + clean `git status` before trusting a seeded cache.

**Task.** Implement **class-instance construction** in endor-vm — the named-skip chain the
stage-7 boot-bundle gate and child 2's gap note identified: the
`TO_INSTANCE`/`INSTANTIATE`/`CONSTRUCTOR_FUNCTION`/`EXTEND`/`CLASS`/`SUPER` opcode chain
(XS names; find the exact opcode set via the gate's named skips — run
`./target/debug/endor-xst` on a class-using subtree and read the `unsupported-opcode:` skip
names, e.g. `to_instance`). Follow the established endor-vm porting pattern: byte-identical
compiled bytecode vs the C-XS pin (compile-diff), result agreement on dual-run, metering by
endor's own frozen cost table (`endor-meter-1` — accuracy-over-parity doctrine: NEVER back-fit
meters to oracle computrons; computron-vs-oracle telemetry is advisory). Class syntax should
move from named-skip to covered on real test262 cases: `class {}` declarations/expressions,
`new` of a class, instance fields via constructor assignment, `extends`+`super` if honestly
reachable in the invocation — report precisely which of these landed and which remain named
skips.

**Bars (all from `rust/engine`, captured to files, `$?` checked):**
1. `cargo test --workspace -- --test-threads=1` → EXIT=0, every `test result:` line 0 failed.
2. `./target/debug/compile-diff` (curated; no `--` separator on the prebuilt binary) →
   1711/1711 + SYMB 1711/1711, EXIT=0 — the corpus must not regress; ADD class-construction
   cases to the corpus per the established pattern so the count GROWS.
3. `./target/debug/endor-xst statements/class` (and `built-ins/Function` spot) → 0 failed;
   report covered-count delta vs the pre-change run (measure BEFORE and AFTER).
4. Dual-run regressions for the newly covered constructs in the endor-262 suite.
5. `#![forbid(unsafe_code)]` intact; no new warnings.
6. Any NEW `Interp` field or side table: classify honestly in the snapshot side-table ledger
   (`endor-snapshot/src/sidetable.rs`) THE DAY IT LANDS (s22 caught an unledgered table —
   do not repeat it), and add it to `lockdown_roots()` if it holds heap slots.

**Practical:** `$HOME` = `/home/kris/garden`; `cargo` at `$HOME/.cargo/bin`; logs under
`$HOME/tmp`; a `cargo test` piped to `tail` masks the exit code. Commit+push before long runs.
Honest-partial discipline: this is the big rock — a clean partial (e.g. plain classes covered,
`extends`/`super` remaining as named skips) is a valid completion if reported precisely.
