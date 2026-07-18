---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T16:43:06Z -->

---
model: opus
---
# Stage-10b child 1/5 — cross-turn function invocation (the persistent realm's callable gap)

**Provenance:** stage-10 child 3 (`xs2rust-endor-stage10-persistent-realm`, tada report —
READ IT FIRST) landed `PersistentRealm` with a precisely-named remainder: **a function
installed by turn 1 (`globalThis.handleCommand = f`) survives as DATA but is NOT callable in
turn 2** — the interpreter dispatches a function body by its byte offset into the *currently
running* program's code buffer, so calling a prior turn's function would dispatch into this
turn's bytes. This is a hard prerequisite for the live worker-evaluate round trip (the daemon
boot turn installs handlers; later delivers invoke them), and the reason the original
live-captp-eval child could not reach its DoD.

## The work

1. **Make prior-turn functions callable.** The named approach (child 3's module doc,
   remainder note 1): an append-only / per-program-retained code buffer — the realm retains
   each turn's program (code bytes + constants + symbol bindings) alive for the realm's
   lifetime, and a function value carries enough identity (owning-program + offset, or a
   rebased offset into an append-only buffer) that `RUN` dispatch resolves against the
   OWNING program's bytes. Choose the design that least disturbs the single-shot metered
   path; document the choice in the module doc.
2. **DoD (binding):** extend the endor-vm persistent-realm tests and the `endo` crate
   multi-turn worker test so that turn 1 installs `globalThis.handleCommand` as a FUNCTION
   and turn 2 INVOKES it (argument round trip + return value + a throw surfaced as a
   catchable error), all green. Closures over turn-1 top-level state: cover what works,
   name honestly what does not.
3. **Byte-identity guard:** the single-shot metered path must be untouched — run the full
   engine bar (compile-diff + SYMB all-identical) to prove it.
4. Any new/changed VM state that outlives a turn must be examined against the side-table
   ledger the day it lands (retained programs are realm state: state its GC-roots and
   snapshot posture explicitly, the `HostReplyChannel` precedent).

This is an ENGINE capability slice sized for monotone progress: if the full design does not
fit the handler, land the smallest verified increment (e.g. retained-program table + dispatch
resolution, with invocation limited to no-capture functions) and report the exact remainder.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written; never assume a sha, record the one you measured at (tip when this body was cut: `d197a95e34`).

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers. The `endo` crate build needs the generated JS bundles (`ses_boot.js` etc., produced by `packages/daemon/scripts/bundle-*.mjs` after a full monorepo `yarn install`); gitignored placeholder bundles suffice for lib tests that do not drive them (child-3 precedent) — never commit any bundle.

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder with an EXACT resume point is a GOOD outcome, not a failure. The prior stage-10 child 6 died precisely by NOT doing this: it pushed nothing for a whole handler and its work was lost.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 48 lines / 695 passed at stage-10b cut); curated compile-diff all-identical + SYMB (report the count — **1909** at stage-10b cut, may have grown); boot gate green (report the count — **22** at stage-10b cut — and any skip→green conversions); **zero NEW Rust warnings** (the ~346 moddable C-build warnings from the endor-oracle FFI seam are pre-existing); `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — **8** at stage-10b cut; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending), `DebuggerState` (SnapshotExcluded), and `HostReplyChannel` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). Worker-only changes carry the ROOT-workspace bar instead (`cargo test -p endo --lib` — 82 passed at cut). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths. The metered single-shot path (`Compartment::evaluate_with_symbols` / `Interp::run`) must stay byte-identical — persistent-realm/host-channel machinery must remain inert on oracle and corpus runs.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-18T16:43:10Z
