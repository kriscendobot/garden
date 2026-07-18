---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T12:16:03Z -->

---
model: opus
---
# Stage-9c child 9/9 — the `test:rust` finish-line measurement on the Rust engine (re-cut, checkpointed)

**Provenance (read before sizing your run):** the first cut of this child
(`xs2rust-endor-stage9-test-rust-finish-line`) was reaper-poisoned at the 2400s wall-clock
with zero pushes on 2026-07-18 — it ran BEFORE the worker surface existed, so every
worker-spawning test hung to its ava timeout against a worker that boots but cannot serve
CapTP. You run AFTER the worker-surface child (8/9); your job is the honest measurement, with
checkpointing so no wall-clock poison can erase your progress again.

**This job is MEASUREMENT-ONLY: no engine fixes, no test edits, no corpus edits.** (A trivial
harness-only unblocking change — e.g. an env knob the seam already defines — is allowed only
if provably not an engine-behavior change; push it separately and flag it.)

## Procedure

1. **Smoke gate first (bounded, ~5 min):** run ONE worker-spawning daemon test on the Rust
   engine (`ENDO_ENGINE=rust`, serial, REAL short path — the `~/tmp/s8cxs` recipe, `sun_path`
   cap 90 chars, ava as `node ../../node_modules/ava/entrypoints/cli.js`). If the CapTP
   handshake STILL cannot complete (child 8 reported an honest remainder), do NOT run the
   full suite: report the deterministic finding, a small representative subset table
   (~6–10 files spanning the daemon surface), and the top blockers, and stop — that is a
   complete, honest measurement of where the finish line stands.
2. **Full serial run, in CHUNKS with checkpoints:** enumerate the `test:rust` test files,
   run them in chunks (per-directory or ~8–10 files), serially, on the Rust engine. After
   EACH chunk: append the per-test results to `$HOME/tmp/s9fl-results/` AND commit a
   checkpoint journal entry (your journal worktree is `$HOME/journal`; write
   `entries/<date>/…-s9fl-checkpoint-<n>.md` with the cumulative per-test table and the
   chunk cursor; push with the ff-only pull + push CAS). A re-cut of you resumes from the
   last checkpoint instead of restarting.
3. **Clock discipline:** at ~2000s elapsed, stop launching new chunks; write the final
   checkpoint and report the partial table + the precise resume point in your tada.
4. **Build hygiene:** fresh rebuild of the daemon bin and engine crates at the recorded tip
   before measuring (`cargo clean -p endor-compile -p endor-vm -p endor-oracle` in
   `rust/engine`); record the tip sha; the whole measurement is AT that tip.

## The comparison anchor — serial C-XS baseline

**804 passed / 26 failed / 65 skipped** (endolin-garden log
`/home/kris/garden/tmp/s26-cxs-baseline-serial.log`, corroborated on endolin-garden2;
+110 pending only from `test/endo.test.js`, the detached-daemon harness, un-runnable in the
sandbox — expect the same on the Rust run). Expected C-XS failure classes (the
expected-divergence ledger; Rust matching these failures is PARITY, not regression):
git-backend 8 (`Could not parse git version from ""`); error-trace worker-assertions 5;
content-store-gc 9; endo.test.js 3 (sandbox); shell /tmp-noexec 1. Concurrent runs are NOT an
anchor (mass `endo.sock not ready` artifacts); run serially.

## Report (tada)

- The three-number Rust-engine summary (passed/failed/skipped) + exit codes, log paths, and
  the checkpoint-entry paths.
- Per-class divergence table: failing on Rust but not in the C-XS anchor (grouped by
  first-line error class, one verbatim first failure per NEW class), and failing on C-XS but
  passing on Rust.
- Which of the 5 expected classes reproduced identically; any mass-identical class excluded
  as an environment artifact (name the exclusion evidence).
- The honest bottom line: is the maintainer's finish line (all `test:rust` daemon tests
  passing on the Rust engine, modulo the expected-divergence ledger) MET, NEAR, or FAR — with
  the top blockers named and counted.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
