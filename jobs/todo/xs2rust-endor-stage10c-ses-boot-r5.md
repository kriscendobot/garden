---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T19:04:05Z -->

---
model: opus
---
# Stage-10c child 2/5 — SES worker-bundle boot, gap round 5 (error own-property descriptors, then onward)

**Provenance:** continuation of the composed-boot chain — stage-10 children 4–5 (`ses-boot-gaps-r1/r2`) and
stage-10b children 2–3 (`ses-boot-r3/r4`). **READ THEIR TADA REPORTS FIRST**
(`journal/jobs/tada/xs2rust-endor-stage10b-ses-boot-r3.md`, `-r4.md`): r3 landed the composed assert-prelude
method + native-method `%Function.prototype%` chaining; r4 landed bind/call/apply on native & method receivers
(the full `uncurryThis = bind.bind(call)` chain composes end to end; boot gate 24).

**Exact resume point (r4's precisely-attributed frontier):** the raw SES-boot bundle now halts at
**`Unsupported("getOwnPropertyDescriptor:exotic-object")`** — receiver is an **error object**, key is
**`"stack"`**: SES error-taming inspecting `Object.getOwnPropertyDescriptor(errorObj, 'stack')`. Error
receivers are currently classified fully exotic for `getOwnPropertyDescriptor`.

## The work

1. Teach `ObjectGetOwnPropertyDescriptor` (and `Reflect.getOwnPropertyDescriptor`, same guard) to read an
   error instance's `stack` (and other own) property descriptors, validated by an oracle-reaching
   `Object.getOwnPropertyDescriptor(new Error(), 'stack')` dual-run (result agreement; XS's `stack` shape as
   the oracle reports it is ground truth). Extend to the array/wrapper receivers r4 flagged if the bundle's
   halt order reaches them.
2. **Re-drive the bundle after each closed gap** (the r1–r4 method): close the next halt, promote an
   isolated oracle-reaching boot-gate form per gap, **push per gap** (each gap = one coherent pushable item:
   fix + boot-gate test + engine bar green).
3. Known deferred gaps from r4 you may hit next (each self-named): bound-of-bound calls
   (`bind:bound-target-call`), primitive `thisArg` boxing (`call:primitive-this-boxing`).
4. **Report the exact final frontier** in your tada: the halt signature, the attributed SES source line, and
   the isolated dual-run form that reproduces it. Completion of the whole boot is NOT expected this round —
   an honest frontier with an exact resume point is success. Count and report the boot-gate total.

The oracle ceiling note (r3): the composed single-eval prelude+bundle concatenation is malformed
(`SyntaxError: invalid directive` — the XS parser's `mxNotSimpleParametersFlag` leak); the daemon evaluates
polyfills and boot as SEPARATE evals in one realm. Isolated oracle-reaching snippets per gap (the boot-gate
method) remain the ground-truth vehicle; a multi-script oracle harness is NOT required this round.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written; never assume a sha, record the one you measured at (tip when this body was cut: `43de4567f6`).

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers. The `endo` crate build needs the generated JS bundles (`ses_boot.js` etc., produced by `packages/daemon/scripts/bundle-*.mjs` after a full monorepo `yarn install`); gitignored placeholder bundles suffice for lib tests that do not drive them — never commit any bundle.

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder with an EXACT resume point is a GOOD outcome, not a failure. TWO predecessors (stage-10 child 6, stage-10b child 4) died precisely by NOT doing this: each pushed nothing for a whole handler and its work was lost. If you are 1800s in with nothing pushed, STOP building and push/checkpoint what you have.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 48 lines / **703** passed at stage-10c cut); curated compile-diff all-identical + SYMB (report the count — **1909** at stage-10c cut, may have grown); boot gate green (report the count — **24** at stage-10c cut — and any skip→green conversions); **zero NEW Rust warnings** (the ~346 moddable C-build warnings from the endor-oracle FFI seam are pre-existing); `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — **8** at stage-10c cut; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending), `DebuggerState` (SnapshotExcluded), `HostReplyChannel` (SnapshotExcluded), and `RetainedProgramCode` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). Worker-only changes carry the ROOT-workspace bar instead (`cargo test -p endo --lib` — **83** passed at cut). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths. The metered single-shot path (`Compartment::evaluate_with_symbols` / `Interp::run`) must stay byte-identical — persistent-realm/host-channel/retained-code machinery must remain inert on oracle and corpus runs.
