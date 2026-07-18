---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage10
priority: normal
posted_by: producer
posted_at: 2026-07-18T13:02:28Z
---

---
model: opus
---
# Stage-10 child 7/7 — finish-line re-measurement (measurement-only)

**Provenance:** re-run of stage-9c child 9's bounded serial sweep, after children 1–6 closed
the worker-evaluate blocker. **Measurement-only: no engine/test/corpus edits, nothing pushed to
the branch.** Read child 9's tada + checkpoints
(`journal/entries/2026/07/18/*s9fl-checkpoint-*.md`) and the stage-9 acceptance
(PR #600 issuecomment-5011343934) for the method and the prior table.

## The work

1. **Smoke gate first (cheap):** short-path daemon checkout, fresh release `endor` at the real
   tip; run `error-trace.test.js` on Rust (`ENDO_WORKER_BIN='<abs>/endor worker -e rust'`,
   serial, 60s timeout). If it still hangs, STOP the full sweep — checkpoint that fact to a
   journal entry (`entries/…-s10fl-checkpoint-*.md`) and tada with the halt signature; the
   supervisor re-cuts. Do not burn the window on a timeout-dominated sweep.
2. **Full bounded serial sweep, both engines:** the 52 runnable daemon files
   (`--concurrency=1 --timeout=25s`, `endo.test.js` excluded), Rust then C-XS, same harness —
   child 9's exact method. **Checkpoint the partial table to journal entries every ~15 files**
   (push to `journal2`) so a poison loses nothing.
3. **Report:** the three-number table for both engines, the per-file divergence list, and the
   expected-divergence-ledger reconciliation (content-store-gc 9, error-trace class, git 5 in
   this env, endo.test.js excluded, shell/tmp N/A). The stage-9 anchor to beat: Rust 531/14/20/6
   with 1 hang vs C-XS 530/19/20/0. **The finish line is MET when zero tests fail (or hang) on
   Rust that pass on C-XS, and every Rust failure is in the expected-divergence ledger's
   classes** — state explicitly in your tada whether that holds, file by file for any residue.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers (stage-9c child 9's measured correction).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 47 lines / 673 passed at stage-9 close); curated compile-diff all-identical + SYMB (report the count — **1878** at stage-9 close, may have grown); boot gate green (report the count — 17 at stage-9 close — and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 at stage-9 close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending) and `DebuggerState` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
