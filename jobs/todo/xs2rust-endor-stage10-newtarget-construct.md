---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T13:40:06Z -->

---
model: opus
---
# Stage-10 child 2/7 — `new.target` retargeting + Promise-subclass construction

**Provenance:** stage-9c child 5 measured that *invoking* a HandledPromise static bottoms into
`Reflect.construct(Promise, [superExecutor], new.target)` — a **Promise-subclass construct with
a retargeted `new.target`** — currently a documented honest skip
(`Reflect.construct:newtarget-retarget`, plus the class-construction skips: `super()`
construction + `new.target` retargeting, 18 corpus cases). This is the single named engine
prerequisite for `new HandledPromise(executor)` and therefore for the SES/CapTP bundle boot
(children 4–6 after you).

## The work

Transliterated from `xsRun.c`/`xsFunction.c` (the `XS_CODE_NEW`/construct machinery,
`fxGetPrototypeFromConstructor` with the running `new.target`):

1. **`Reflect.construct(target, args, newTarget)` with `newTarget !== target`** — the instance
   prototype comes from `newTarget.prototype` (child 1 just made that readable), the body runs
   as `target`. Extend child 3-of-9c's `run_reentrant_construct` geometry.
2. **Subclass construction of intrinsic constructors** — at minimum `Promise` as super
   (`class HP extends Promise`-shaped construction reached via `Reflect.construct(Promise,
   [executor], HP)`): the executor must be driven, the minted instance carrying the subclass
   prototype while living in the `promises` side table. `Array`/`Error` as super only if they
   fall out cleanly; otherwise honest remainders.
3. **`super()` in class constructor bodies + `new.target` in function bodies** — promote the
   18 class-construction honest skips to green where the machinery now supports them; keep the
   soundness gate on what remains (private fields etc. stay skipped).

**Coverage:** curated corpus `cases/language/stage10-newtarget-construct/` (dual-run: retargeted
construct, Promise subclass resolve/reject round-trip through the retargeted instance, `super()`
chains, `new.target` identity in ordinary `new`); bump `CORPUS_PROGRAM_COUNT`; convert boot-gate
skips that now green. The `promises`/`functions` side tables gain no new shape — if you DO add a
table or field, ledger it the day it lands.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers (stage-9c child 9's measured correction).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 47 lines / 673 passed at stage-9 close); curated compile-diff all-identical + SYMB (report the count — **1878** at stage-9 close, may have grown); boot gate green (report the count — 17 at stage-9 close — and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 at stage-9 close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending) and `DebuggerState` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
