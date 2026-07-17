---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage8
priority: normal
posted_by: producer
posted_at: 2026-07-17T10:51:32Z
---

---
model: opus
---
# Stage-8 child 5/6 — engine: boot-surface remainder (destructuring, method shorthand, String.raw, partial descriptors, `at` at scale, HandledPromise)

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Build child of serial orchestration
`xs2rust-endor-build-stage8`; tada-only reporting. One 2400s invocation. Rust workspace is
`rust/engine` (NOT the repo root).

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip; push via CAS, verify by exit code. Seed
`rust/engine/target/` and `c/moddable` by `cp -al` from a sibling scratch worktree at the same
commit (empty-dir nesting gotcha: `rmdir` an empty `c/moddable` before copying); confirm tip sha
+ clean `git status`.

**Task.** Clear the SMALLER named-skip items from the stage-7 boot-bundle gate ledger (child 4,
serially before you, took class construction). In rough effort order:
1. **Object destructuring** (`var {a} = obj`, parameter destructuring as reachable).
2. **Method shorthand** in object literals (`{ add(x) {…} }` — the gate's `add` skip).
3. **`String.raw`**.
4. **Partial descriptors on `defineProperty`** (a descriptor carrying only some attributes must
   merge per spec, not default-fill).
5. **Indexed-slot `at` at scale** (the gate's `at`-related skip — `Array.prototype.at`/
   `String.prototype.at` on large/edge indices; find the exact named skip and clear it).
6. **`HandledPromise`** — investigate FIRST: this is the eventual-send shim's surface; determine
   what engine primitive the named skip actually wants (it may reduce to something small like
   `Promise.prototype` extensibility or a missing intrinsic hook, or it may be big). If big,
   report the precise gap and leave it as a named skip — do NOT burn the invocation on it.

Same porting pattern as always: byte-identical compiled bytecode (compile-diff, ADD corpus
cases so 1711 grows), result agreement on dual-run, metering by endor's own frozen cost table
(accuracy-over-parity: never back-fit to oracle computrons).

**Bars (from `rust/engine`, captured, `$?` checked):** workspace EXIT=0 all `test result:` lines
0 failed; curated compile-diff green with grown corpus; `endor-xst` on the touched subtrees
(`language/expressions/object`, `built-ins/String/raw`, `built-ins/Object/defineProperty`,
`built-ins/Array/prototype/at`) → 0 failed, report covered deltas measured before/after;
dual-run regressions for each newly covered construct; `forbid(unsafe_code)` intact; no new
warnings; any new `Interp` field/side table ledgered honestly the day it lands + swept by
`lockdown_roots()` if it holds heap slots.

**Practical:** `$HOME` = `/home/kris/garden`; `cargo` at `$HOME/.cargo/bin`; logs under
`$HOME/tmp`; exit-code discipline (never pipe `cargo test` to `tail`); commit+push before long
runs; honest-partial discipline — report exactly which items landed and which remain named
skips.
