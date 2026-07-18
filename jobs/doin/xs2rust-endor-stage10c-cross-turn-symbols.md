---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T18:43:03Z -->

---
model: opus
---
# Stage-10c child 1/5 — cross-turn SYMBOL resolution (prior-turn handler bodies resolve intrinsics + globals)

**Provenance:** the exact named remainder of stage-10b child 1 (`xs2rust-endor-stage10b-cross-turn-functions`,
read its tada report first — `journal/jobs/tada/xs2rust-endor-stage10b-cross-turn-functions.md`). Cross-turn
function INVOCATION is landed (append-only `Interp::retained_code`, dispatch by original `body_start` into the
retained region, ledgered `SideTable::RetainedProgramCode` SnapshotExcluded). What is NOT closed: a prior-turn
function body that resolves a **symbol id** reads it against THIS turn's symbol tables, because the compiler
numbers symbols program-locally (the same name gets a different id each turn) and `carry_globals_into` rebuilds
the tables per turn. Two characterized failure modes, both pinned by the guard test
`persistent_realm_prior_turn_symbol_ref_is_the_named_remainder`:
- an **intrinsic reference** (`new Error(...)`) fails LOUDLY (undefined-variable throw);
- a **named-global read** (`globalThis.base`) is SILENTLY WRONG (misses under the new ids → `undefined`/`NaN`).

## The work

The resume point stage-10b child 1 named: **per-turn symbol-context switching on cross-program frame
entry/exit** — retain each turn's `symbol_names`/`symbol_ids`/`symbol_key_ids` + cached ids in a
`RetainedProgram` record keyed off the callee's owning region of `retained_code`, swap on
`enter_call`/`leave_call` (and any other cross-region entry: bound calls, `.call`/`.apply`, accessor dispatch,
throw-unwind back across regions), **plus** make the shared global object carry bindings under every turn's
numbering (or re-key on entry) so intrinsic/global reads from a prior-turn body resolve correctly. Judge the
design on the tree as it stands — an equivalent mechanism (e.g. a per-region symbol-id remap table applied at
resolution time) is acceptable if it meets the same DoD with less machinery; state your choice and why.

**DoD (binding):**
1. The named-remainder guard test FLIPS: a turn-1 function body referencing an intrinsic (`new Error(...)`)
   invoked in turn 2 completes correctly, and a turn-1 body reading a named global (`globalThis.base`, both
   read and write) resolves the SAME binding in turn 2 — no silent `undefined`.
2. A **real-handler shape** test: turn 1 installs `globalThis.handleCommand = (cmd) => ...` whose body uses
   `JSON.stringify`, `new Error`, and a realm global set in an earlier turn; turn 2+ invokes it and gets the
   right answer; a throwing path surfaces as a catchable error in the calling turn.
3. `endo` crate multi-turn worker test extended to the same shape (ROOT-workspace bar).
4. Cross-turn state remains ledgered: if the retained per-turn symbol tables become NEW VM state, ledger the
   side table the day it lands (SnapshotExcluded, matching `RetainedProgramCode`), with the by-contract test.
5. **Byte-identity guard:** the single-shot metered path must be untouched — compile-diff 1909/1909 + SYMB,
   full engine bar per the discipline block.

Push the increment as soon as the engine bar is green — this child is the capability the live round trip
(child 4) depends on; a verified partial (e.g. intrinsics resolve, global-write re-keying remains) with an
exact resume point is an acceptable tada.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written; never assume a sha, record the one you measured at (tip when this body was cut: `43de4567f6`).

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers. The `endo` crate build needs the generated JS bundles (`ses_boot.js` etc., produced by `packages/daemon/scripts/bundle-*.mjs` after a full monorepo `yarn install`); gitignored placeholder bundles suffice for lib tests that do not drive them — never commit any bundle.

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder with an EXACT resume point is a GOOD outcome, not a failure. TWO predecessors (stage-10 child 6, stage-10b child 4) died precisely by NOT doing this: each pushed nothing for a whole handler and its work was lost. If you are 1800s in with nothing pushed, STOP building and push/checkpoint what you have.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 48 lines / **703** passed at stage-10c cut); curated compile-diff all-identical + SYMB (report the count — **1909** at stage-10c cut, may have grown); boot gate green (report the count — **24** at stage-10c cut — and any skip→green conversions); **zero NEW Rust warnings** (the ~346 moddable C-build warnings from the endor-oracle FFI seam are pre-existing); `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — **8** at stage-10c cut; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending), `DebuggerState` (SnapshotExcluded), `HostReplyChannel` (SnapshotExcluded), and `RetainedProgramCode` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). Worker-only changes carry the ROOT-workspace bar instead (`cargo test -p endo --lib` — **83** passed at cut). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths. The metered single-shot path (`Compartment::evaluate_with_symbols` / `Interp::run`) must stay byte-identical — persistent-realm/host-channel/retained-code machinery must remain inert on oracle and corpus runs.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-18T18:43:06Z
