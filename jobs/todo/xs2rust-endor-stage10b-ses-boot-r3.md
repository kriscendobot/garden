---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T17:04:03Z -->

---
model: opus
---
# Stage-10b child 2/5 — SES worker-bundle boot, gap round 3 (composed boot: bundle + host prelude)

**Provenance:** continuation of stage-10 children 4–5 (`xs2rust-endor-stage10-ses-boot-gaps-r1`/`-r2`
tada reports — READ BOTH FIRST). Round 2's exact end state: the raw `ses_boot.js` bundle
(70 009 bytes, gitignored, regenerate via `packages/daemon/scripts/bundle-*.mjs` or per the
r1/r2 method) now halts at **`Throw("call: not a function")`**, which is PAST the C-XS
oracle's own raw-bundle ceiling (the oracle aborts earlier at `ReferenceError: get assert:
undefined variable` — the standalone bundle references host-provided globals).

## The work

1. **Compose the boot environment:** drive the bundle WITH its host prelude/environment (the
   daemon's polyfills + host powers — the §1 `composed_boot_bundle` boot-gate tests are
   fragments of it; assemble the real prelude the xsnap worker supplies) so the C-XS oracle
   itself boots far enough to supply ground truth again.
2. **Attribute the `call: not a function` throw** under the composed environment: name the
   exact callee and the missing surface behind it.
3. **Close gaps in bundle-halt order,** one push per gap (the r1/r2 method): transliterate
   from C-XS, dual-run where the oracle reaches, boot-gate result-agreement tests where it
   does not, corpus cases, full engine bar per push.
4. **Target:** monotone progress toward the bundle completing `lockdown()` and the worker
   bootstrap surface. Completion this round is NOT expected — report the exact halt
   signature you end at as the resume point for round 4.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written; never assume a sha, record the one you measured at (tip when this body was cut: `d197a95e34`).

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers. The `endo` crate build needs the generated JS bundles (`ses_boot.js` etc., produced by `packages/daemon/scripts/bundle-*.mjs` after a full monorepo `yarn install`); gitignored placeholder bundles suffice for lib tests that do not drive them (child-3 precedent) — never commit any bundle.

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder with an EXACT resume point is a GOOD outcome, not a failure. The prior stage-10 child 6 died precisely by NOT doing this: it pushed nothing for a whole handler and its work was lost.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 48 lines / 695 passed at stage-10b cut); curated compile-diff all-identical + SYMB (report the count — **1909** at stage-10b cut, may have grown); boot gate green (report the count — **22** at stage-10b cut — and any skip→green conversions); **zero NEW Rust warnings** (the ~346 moddable C-build warnings from the endor-oracle FFI seam are pre-existing); `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — **8** at stage-10b cut; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending), `DebuggerState` (SnapshotExcluded), and `HostReplyChannel` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). Worker-only changes carry the ROOT-workspace bar instead (`cargo test -p endo --lib` — 82 passed at cut). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths. The metered single-shot path (`Compartment::evaluate_with_symbols` / `Interp::run`) must stay byte-identical — persistent-realm/host-channel machinery must remain inert on oracle and corpus runs.
