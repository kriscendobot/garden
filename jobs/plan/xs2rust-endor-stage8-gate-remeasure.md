---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage8c
priority: normal
posted_by: supervisor-s25
posted_at: 2026-07-17T22:41:26Z
---


---
model: opus
---
# Stage-8c child 3/3 (was stage-8 child 6/6) — boot-gate re-measure + whole-stage verify

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Final build child of serial orchestration
`xs2rust-endor-build-stage8c`; tada-only reporting. One 2400s invocation. Rust workspace is
`rust/engine`.

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip; seed `rust/engine/target/` and `c/moddable` by
`cp -al` from a sibling at the same commit (empty-dir nesting gotcha); confirm tip sha + clean
status.

**Task — measure the whole stage at the tip (binding rule: a whole-tree claim requires the
whole-tree measurement at the claimed tip).** Children 1–5 landed the daemon groundwork
(bundle fix, generators, C-XS baseline) and the engine boot-surface work (class construction,
remainder items). You verify and re-measure; you land NOTHING except (a) fixes to your own
findings if they are one-line-trivial, or (b) corpus/test additions — anything substantive goes
in your report as a named finding for the supervisor's fixer round.

1. **Boot-bundle gate re-measure:** run the stage-7 boot-bundle acceptance gate (the 14-case
   dual-run suite child 6 of stage 7 landed — find it in `rust/engine/endor-262`, the
   boot-bundle gate test/binary; read `journal/jobs/tada/xs2rust-endor-stage7-boot-bundle-gate.md`
   if present for its invocation) and report the named-skip → covered conversions vs the
   stage-7 ledger (class construction, destructuring, method shorthand, String.raw, partial
   descriptors, `at`, HandledPromise). The gate must be ≥ as green as stage 7 left it (14/14,
   no regressions); conversions are the stage's yield metric.
2. **Workspace:** `cargo test --workspace -- --test-threads=1` → EXIT=0, every `test result:`
   line 0 failed (capture to file, check `$?`).
3. **Curated compile-diff:** `./target/debug/compile-diff` (no `--` separator) → all identical +
   SYMB, EXIT=0; report the grown corpus count (was 1711/1711 at stage-7 acceptance).
4. **Spot checks:** `endor-xst` Object/Promise/Compartment + `statements/class` + the child-5
   subtrees → 0 failed; `-l built-ins/Boolean`; ses-parity sweep (`-l --feature-filter
   ses-xs-parity --features-include ses-xs-parity built-ins`). Report covered counts.
5. **Full 121-run enumeration (mandatory — the stage touches boot-path engine code):** the
   script pattern is `/home/kris/garden/tmp/s23-enum.sh` — copy it, edit its `WT=` to YOUR
   worktree and `OUT=` to a fresh dir, run it, require 121 runs 0 nonzero 0 divergent
   0 accept-disagree; report the summary line. (Stage-7 anchor: total=20603 identical=16981
   divergent=0 oracle-rejected=3622; identical may GROW with new corpus coverage, divergent and
   accept-disagree must stay 0.)
6. `#![forbid(unsafe_code)]` intact at every engine crate root; warning inventory (only the
   pre-existing cosmetic ones allowed).

**Deliverable:** the measured whole-stage report — every bar with its number and exit code, the
gate conversion table, and a findings list (possibly empty) for the supervisor. Do NOT declare
acceptance; that is the supervisor's call.

**Practical:** `$HOME` = `/home/kris/garden`; `cargo` at `$HOME/.cargo/bin`; logs under
`$HOME/tmp`; exit-code discipline throughout.

**Lineage note (supervisor s25, 2026-07-17):** this child is carried verbatim from the stage-8/stage-8b originals; both prior orchestrations halted at the cxs-baseline sibling during transient fleet outage windows (~11:30-12:40Z and ~17:04-18:23Z, poison=infra not spec). The C-XS `test:rust` baseline was completed by the supervisor itself at tip `9bef7de22e` (report: `journal/jobs/tada/xs2rust-endor-stage8-cxs-baseline-r2.md`), so this orchestration (stage8c) carries only the three remaining children. The press may have rebased since — sync to the REAL remote tip and find rebased equivalents by subject if needed.
