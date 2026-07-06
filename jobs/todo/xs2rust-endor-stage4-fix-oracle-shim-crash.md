---
model: opus
---
# Fixer: oracle shim SIGSEGV on whole-tree dual-runs (stage-4 acceptance blocker, PR #600)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, keep DRAFT). Work in an
isolated checkout via `ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.
Populate the `c/moddable` oracle pin per `rust/engine/README.md` (git init the empty gitlink first;
fetch pin `48ee02d8cfe0dccb51ee2465cf6716b3468684a4` from a sibling
`<garden-root>/scratch/project-wt-*/c/moddable`). `cargo` is at `$HOME/.cargo/bin`.

## The finding (s10 stage-4 acceptance review)

At branch tip `1b449a1f0d`, whole-tree dual-runs that were green at earlier acceptances now
**SIGSEGV the runner process (rc=139)**:

- `cargo run -p endor-262 --bin test262-language -- built-ins/Function` — crashes. Bisected to
  `built-ins/Function/prototype/toString/{built-in-function-object,well-known-intrinsic-object-functions}.js`,
  the two tests that recursively walk the **well-known-intrinsics graph** from `globalThis` and call
  `Function.prototype.toString` on every function they reach.
- `cargo run -p endor-262 --bin test262-language -- built-ins/Array` — crashes; localized to
  `built-ins/Array/prototype/{concat,map,sort}`; per-file culprits in `concat` are
  `Array.prototype.concat_{large,small}-typed-array.js` and
  `Array.prototype.concat_spreadable-sparse-object.js` — a **second, non-walker crash class**
  (typed-array construction / spreadable sparse objects on the oracle side).

**Introducing commit (bisected, verified both sides, BOTH crash classes):** `63e6017999` — the
stage-4b lockdown/harden child's **oracle-shim extension** that installs the
`harden`/`lockdown`/`petrify`/`mutabilities` globals into the bare-boot `fxCreateMachine` machine.
At `c6de4a8468` (its parent) both the walker file and the typed-array concat file run clean
(rc=0, honest named skips); at `63e6017999` both SIGSEGV. That the typed-array class also starts
here suggests the extension perturbs the bare-boot machine globally (allocation/GC pressure or
global-object layout), not just the four new function slots — diagnose before patching. The
ses-conformance child independently found `lockdown()` **SIGSEGVs the bare-boot shim** when
actually called. The crash is on the C oracle side (every endor crate is
`#![forbid(unsafe_code)]`); it kills the whole differential process, so entire sections lose
their dual-run certification.

Baselines this crash currently blocks from re-certification at tip: `built-ins/Function`
whole-tree `covered=40 divergent=0` (stage-4a classes child) and `built-ins/Array` whole-tree
`covered=437 divergent=0, NO process abort` (s8 acceptance).

## The job

1. Reproduce the two whole-tree crashes at tip.
2. **Fix the shim extension so the bare-boot machine with the four installed globals is
   walk-safe and call-safe**: the intrinsic-graph walk (property enumeration + `toString` on the
   installed host functions) must not crash, and a guest **calling** `lockdown()`/`mutabilities()`
   on the bare-boot machine must fail safely (a catchable throw or a clean abort report), never a
   SIGSEGV. Diagnose properly — likely the installed host-function slots are missing linkage the
   toString/enumeration path needs (name atom, home/prototype, or code field) or `lockdown`'s walk
   touches intrinsics the bare boot never populated. Fix the INSTALLATION (or gate what gets
   installed); do not delete the harden differential capability.
3. **Bars (all must hold, record wall-clocks):**
   - `built-ins/Function` whole-tree completes, **no process abort**, `covered>=40 divergent=0`.
   - `built-ins/Array` whole-tree completes, **no process abort**, `covered>=437 divergent=0`.
   - `built-ins/Object` whole-tree stays `covered=176 divergent=0`.
   - The harden corpus bar `stage4_harden_corpus_agrees_on_results_against_oracle` stays green.
   - `cargo test --workspace -- --test-threads=1` green (capture to a file, check `$?` directly —
     piping to `tail` masks the exit code).
   - `#![forbid(unsafe_code)]` intact; any new `unsafe` stays inside `endor-oracle`'s audited shim.
4. Add the two intrinsic-walker files (or a minimal equivalent) to a locked regression bar so a
   future shim widening that re-breaks the walk fails a named cargo test instead of a whole-tree
   acceptance run. Update `rust/engine/README.md`'s stage-4 evidence block with the fix + the
   re-certified whole-tree numbers.
5. Out of scope (already ledgered for the test262-convergence work): making the dual-run runner
   SURVIVE an oracle crash as a named skip class (the RegExp whole-tree fixed-stack overflow is
   the standing example). Keep this job to the shim regression. Do not touch the module-goal seam.

Commit with explicit pathspecs (never the `c/moddable` gitlink), push to `origin/xs2rust-endor`
via rebase-CAS. Keep PR #600 DRAFT. No maintainer contact; no PR comment.

**Budget discipline:** land and push the first green slice inside the first half of your 2400s
handler budget; two stage-4a children died to oversized scope at 2×2400s each. If the full
whole-tree re-certification will not fit, land the shim fix + the locked regression bar first,
push, and report the remainder honestly.

Report your completion (fix, root cause, re-certified numbers, wall-clocks, any scope folds) to
inbox `port-xs-to-rust-memory-safe-engine-s11`.
