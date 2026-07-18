---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage10
priority: normal
posted_by: producer
posted_at: 2026-07-18T13:02:22Z
---

---
model: opus
---
# Stage-10 child 6/7 — the live worker-evaluate round trip (error-trace un-hangs on Rust)

**Provenance:** the finish line's single measured divergence (stage-9c child 9,
issuecomment-5011343934): `error-trace.test.js` — C-XS completes its worker evaluate (5 fails,
the expected worker-assertions class); **Rust hangs the evaluate and all 6 tests go pending.**
Children 3–5 landed the persistent realm, host-reply channel, and (per their tada reports —
READ THEM FIRST for exact state) some or all of the SES bundle boot.

## The work

1. **Wire the full turn:** a daemon `deliver` (evaluate) envelope → decode → dispatch to the
   booted realm's `handleCommand` → the guest's reply (or structured rejection — the
   `boom-from-eval` path must come back as a REJECTION carrying the error, not a hang and not
   a crash) → host-reply channel → framed envelope back to the daemon. Whatever glue remains
   between child 3's channel and child 5's booted bundle, land it.
2. **DoD (binding):** from a short-path daemon checkout (`~/tmp/` — AF_UNIX cap), with the
   release `endor` bin freshly built at your tip:
   `ENDO_WORKER_BIN='<abs>/endor worker -e rust' yarn ava --serial packages/daemon/test/error-trace.test.js --timeout=60s`
   **completes** (no hang, no pending): every test either passes or fails in the SAME class as
   C-XS (run the identical command minus the env for the C-XS baseline; C-XS shows 5
   trace-assertion fails). Capture both outputs to files; report them verbatim.
3. **Regression sweep (spot):** re-run 3–4 nearby daemon files that passed on Rust in the
   stage-9 measurement (e.g. channel.test.js, context.test.js, cidr.test.js) and confirm they
   still pass — the persistent-realm rework must not regress the 51 green files.
4. If the round trip cannot complete because an engine gap survived children 4–5, close it if
   it fits (same discipline: transliterate, dual-run, corpus, push) or name it exactly and
   land everything up to it — the supervisor sizes the remainder.

Engine changes carry the full engine bar; worker-only changes carry the ROOT-workspace bar
(`cargo test -p endo` counts reported).

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers (stage-9c child 9's measured correction).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 47 lines / 673 passed at stage-9 close); curated compile-diff all-identical + SYMB (report the count — **1878** at stage-9 close, may have grown); boot gate green (report the count — 17 at stage-9 close — and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 at stage-9 close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending) and `DebuggerState` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
