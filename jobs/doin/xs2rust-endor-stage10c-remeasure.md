---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T20:13:04Z -->

---
model: opus
---
# Stage-10c child 5/5 — re-measure the bounded-serial 52-file daemon sweep (measurement only)

**Provenance:** re-cut of the swept stage-10b child 5 (`xs2rust-endor-stage10b-remeasure`). Runs AFTER the
stage-10c capability children in this serial orchestration. **Measurement only — you change NO engine or
worker code.** If a measured regression is real, you report it precisely; you do not fix it.

## The work

1. **Smoke gate first (~300s):** short-path daemon checkout (`~/tmp/s9r` on endolin-garden; AF_UNIX cap),
   release `endor` bin freshly built at your tip (record the sha), then ONE known-green file
   (e.g. channel.test.js) under `ENDO_WORKER_BIN='<abs>/endor worker -e rust'`. If the smoke run shows an
   environment-artifact class (AF_UNIX overflow, provisioning-race asserts, stale target/), FIX THE
   ENVIRONMENT (not the code) before proceeding; if it shows a real engine regression, stop and report it as
   the finding.
2. **The bounded-serial 52-file sweep** (the s9fl harness/checkpoint method — see
   `journal/jobs/tada/xs2rust-endor-stage9c-finish-line-measure.md` for the file list and per-file bounded
   invocation): run each file serially with a per-file timeout, checkpoint results to a scratch file as you
   go (s10fl checkpoints) so a deadline loses only the in-flight file. Rust engine first; re-run the C-XS
   baseline (`~/tmp/s8cxs`) only for files whose Rust class CHANGED vs the stage-9 table (the C-XS anchor
   530/19/20/0 stands otherwise).
3. **Report the comparison table** vs the stage-9 anchor (Rust 531/14/20/6 + 1 hang vs C-XS 530/19/20/0):
   per-file class changes only (pass/fail/skip/pending/hang), with the expected-divergence ledger applied
   (git-backend class, worker-assertions class, content-store-gc, /tmp-noexec). Name every delta and whether
   it is explained by a stage-10 capability landing (e.g. error-trace un-hanging) or unexplained (a finding).
4. Your tada is the measurement record: tip sha, both engines' totals, the delta table, checkpoint-file path,
   and any environment artifacts encountered. Push NOTHING to the branch (measurement only); if you are out
   of window mid-sweep, report the completed prefix + the checkpoint file as the honest remainder.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written; never assume a sha, record the one you measured at (tip when this body was cut: `43de4567f6`).

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers. The `endo` crate build needs the generated JS bundles (`ses_boot.js` etc., produced by `packages/daemon/scripts/bundle-*.mjs` after a full monorepo `yarn install`); gitignored placeholder bundles suffice for lib tests that do not drive them — never commit any bundle.

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder with an EXACT resume point is a GOOD outcome, not a failure. TWO predecessors (stage-10 child 6, stage-10b child 4) died precisely by NOT doing this: each pushed nothing for a whole handler and its work was lost. If you are 1800s in with nothing pushed, STOP building and push/checkpoint what you have.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 48 lines / **703** passed at stage-10c cut); curated compile-diff all-identical + SYMB (report the count — **1909** at stage-10c cut, may have grown); boot gate green (report the count — **24** at stage-10c cut — and any skip→green conversions); **zero NEW Rust warnings** (the ~346 moddable C-build warnings from the endor-oracle FFI seam are pre-existing); `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — **8** at stage-10c cut; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending), `DebuggerState` (SnapshotExcluded), `HostReplyChannel` (SnapshotExcluded), and `RetainedProgramCode` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). Worker-only changes carry the ROOT-workspace bar instead (`cargo test -p endo --lib` — **83** passed at cut). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths. The metered single-shot path (`Compartment::evaluate_with_symbols` / `Interp::run`) must stay byte-identical — persistent-realm/host-channel/retained-code machinery must remain inert on oracle and corpus runs.

<!-- garden-reaped: 2 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  worker_kind: gardener
  claimed_at: 2026-07-18T20:43:09Z
