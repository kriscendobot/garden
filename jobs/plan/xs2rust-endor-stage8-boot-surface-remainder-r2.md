---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage8d
priority: normal
posted_by: producer
posted_at: 2026-07-18T03:37:52Z
---

---
model: opus
---
# Stage-8d child 1/2 — engine: boot-surface remainder r2 (method shorthand, String.raw, `at`, HandledPromise-investigate)

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Build child of serial orchestration
`xs2rust-endor-build-stage8d`; tada-only reporting. One 2400s invocation. Rust workspace is
`rust/engine` (NOT the repo root).

**SIZING DISCIPLINE (read first — your predecessor died for lack of it).** The previous cut of
this child (`xs2rust-endor-stage8-boot-surface-remainder`, stage8c child 2/3) overran its 2400s
handler wall-clock and was reaper-poisoned having pushed **NOTHING** — a full invocation of work
lost. You will not repeat that: **commit and push EACH item the moment it lands green** (small
commits, CAS push, verify by exit code). At ~T+30min, STOP implementing, push whatever is green,
and write the honest-partial report. An unpushed working tree at reap time is a total loss; a
pushed partial is progress. Do not start an item you cannot finish AND verify in the time left.

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip (the branch was rebased onto fresh `llm` at 02:09Z
2026-07-18; tip was `2ef06cfdde` then and may have moved); seed `rust/engine/target/` and
`c/moddable` by `cp -al` from a sibling scratch worktree at the same commit (empty-dir nesting
gotcha: `rmdir` an empty `c/moddable` before copying); confirm tip sha + clean `git status`.

**Already done — do NOT redo:** object destructuring (covered via `to_instance`, stage8c
class-construction child); partial descriptors on `defineProperty` (landed by the 02:05Z press,
commits `eaf45be7e0`/`2ef06cfdde`; gate ledger advanced to `{at: 2}`; `polyfills.js` boot bundle
now whole-file green; corpus at 1730).

**Task — the remaining stage-7 boot-bundle-gate named skips, in effort order:**
1. **Method shorthand** in object literals (`{ add(x) {…} }` — the gate's `add` skip).
2. **`String.raw`**.
3. **The gate's `at` skips** (ledger `{at: 2}` — find the exact named-skip sites in the
   boot-bundle gap ledger; likely `Array.prototype.at`/`String.prototype.at` on large/edge
   indices or a host_aliases `at` use; clear what the bundles actually exercise).
4. **`HandledPromise`** — investigate ONLY: determine what engine primitive the eventual-send
   shim's named skip actually wants. If it reduces to something small, land it; if big, report
   the precise gap and leave the named skip — do NOT burn the invocation on it.

Same porting pattern as always: byte-identical compiled bytecode (compile-diff, ADD corpus
cases so 1730 grows), result agreement on dual-run, metering by endor's own frozen cost table
(accuracy-over-parity: never back-fit to oracle computrons).

**Bars (from `rust/engine`, captured to a file, `$?` checked):** workspace EXIT=0 all
`test result:` lines 0 failed (34 lines as of `2ef06cfdde`; if you see
`compile_diff::tests::module_corpora_byte_identity_no_divergence` fail, report it verbatim as a
finding — the supervisor is tracking a suspected environment-dependent flake there — and do not
chase it); curated compile-diff green with grown corpus + SYMB; `endor-xst` on touched subtrees
(`language/expressions/object`, `built-ins/String/raw`, `built-ins/Array/prototype/at`) → 0
failed, covered deltas measured before/after; dual-run regressions for each newly covered
construct; `forbid(unsafe_code)` intact; no new warnings; any new `Interp` field/side table
ledgered honestly the day it lands + swept by `lockdown_roots()` if it holds heap slots.

**Practical:** `$HOME` = `/home/kris/garden`; `cargo` at `$HOME/.cargo/bin`; logs under
`$HOME/tmp`; exit-code discipline (never pipe `cargo test` to `tail`); honest-partial
discipline — report exactly which items landed and which remain named skips.
