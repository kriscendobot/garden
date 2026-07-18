---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage8d
priority: normal
posted_by: producer
posted_at: 2026-07-18T03:37:57Z
---

---
model: opus
---
# Stage-8d child 2/2 — boot-gate re-measure + whole-stage verify (r2)

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Final build child of serial orchestration
`xs2rust-endor-build-stage8d`; tada-only reporting. One 2400s invocation. Rust workspace is
`rust/engine`.

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip; seed `rust/engine/target/` and `c/moddable` by
`cp -al` from a sibling at the same commit (empty-dir nesting gotcha); confirm tip sha + clean
status. The branch was rebased onto fresh `llm` at 02:09Z 2026-07-18 — old shas resolve to
rebased equivalents by commit subject.

**Task — measure the whole stage at the tip (binding rule: a whole-tree claim requires the
whole-tree measurement at the claimed tip).** The stage-8 build landed across: daemon-bundle
imports + boot generators (original stage-8 children 1–2), class construction (stage8c child 1,
corpus 1711→1722, `statements/class` 0→398), partial descriptors (the 02:05Z press, corpus
→1730, `polyfills.js` whole-file green), and the stage8d remainder child serially before you
(method shorthand, String.raw, `at`, HandledPromise findings — read its tada report if on the
board, else its commits). You verify and re-measure; you land NOTHING except (a) fixes to your
own findings if they are one-line-trivial, or (b) corpus/test additions — anything substantive
goes in your report as a named finding for the supervisor's fixer round.

1. **Boot-bundle gate re-measure:** run the stage-7 boot-bundle acceptance gate (the 14-case
   dual-run suite in `rust/engine/endor-262`; read
   `journal/jobs/tada/xs2rust-endor-stage7-boot-bundle-gate.md` for its invocation) and report
   the full named-skip → covered **conversion table** vs the stage-7 ledger (class
   construction, destructuring, method shorthand, String.raw, partial descriptors, `at`,
   HandledPromise). The gate must be ≥ as green as stage 7 left it (14/14, no regressions;
   `polyfills.js` whole-file green as of the press must STAY green); conversions are the
   stage's yield metric. Report the residual named-skip ledger verbatim — it feeds stage-9
   scoping.
2. **Workspace:** `cargo test --workspace -- --test-threads=1` → EXIT=0, every `test result:`
   line 0 failed (capture to file, check `$?`; 34+ lines expected). **Specifically report the
   pass/fail of `compile_diff::tests::module_corpora_byte_identity_no_divergence`:** the
   stage8c class-construction child measured it FAILING (top-level-await module corpus, 1 byte
   long) in its seeded worktree and proved it failing at base `9bef7de22e` there too, yet the
   02:05Z press measured the whole workspace EXIT=0 (518 passed, 0 failed) at `2ef06cfdde`.
   The supervisor suspects an environment-dependent artifact (seeded `target/` or oracle
   state). Run it from YOUR fresh checkout and report the verdict verbatim; if it fails,
   capture which corpus case and the byte position — a named finding, do not fix.
3. **Curated compile-diff:** `./target/debug/compile-diff` (no `--` separator) → all identical +
   SYMB, EXIT=0; report the corpus count (1730 as of `2ef06cfdde`; stage-7 anchor was 1711).
4. **Spot checks:** `endor-xst` Object/Promise/Compartment + `statements/class` + the remainder
   subtrees (`language/expressions/object`, `built-ins/String/raw`,
   `built-ins/Array/prototype/at`, `built-ins/Object/defineProperty`) → 0 failed; `-l
   built-ins/Boolean`; ses-parity sweep (`-l --feature-filter ses-xs-parity
   --features-include ses-xs-parity built-ins`). Report covered counts.
5. **Full 121-run enumeration (mandatory — the stage touches boot-path engine code):** the
   script pattern is `/home/kris/garden/tmp/s23-enum.sh` — copy it, edit its `WT=` to YOUR
   worktree and `OUT=` to a fresh dir, run it, require 121 runs 0 nonzero 0 divergent
   0 accept-disagree; report the summary line. (Stage-7 anchor: total=20603 identical=16981
   divergent=0 oracle-rejected=3622; identical may GROW with new corpus coverage, divergent and
   accept-disagree must stay 0.)
6. `#![forbid(unsafe_code)]` intact at every engine crate root; warning inventory (only the
   pre-existing cosmetic ones allowed).

**Deliverable:** the measured whole-stage report — every bar with its number and exit code, the
gate conversion table + residual-skip ledger, the module_corpora verdict, and a findings list
(possibly empty) for the supervisor. Do NOT declare acceptance; that is the supervisor's call.

**Practical:** `$HOME` = `/home/kris/garden`; `cargo` at `$HOME/.cargo/bin`; logs under
`$HOME/tmp`; exit-code discipline throughout; commit+push any corpus/test additions before your
window closes (an unpushed tree at reap time is a total loss).
