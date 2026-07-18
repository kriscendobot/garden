---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T14:16:03Z -->

---
model: opus
---
# Stage-10 child 3/7 — persistent guest realm + host-reply channel in the worker surface

**Provenance:** stage-9c child 8 (worker surface, commit `e07903ebee`) landed the netstring/CBOR
envelope service but named this blocker precisely: **endor-vm evaluates a program to a
completion value on a fresh interpreter per call; there is no way to hold one realm live across
`deliver`s and no JS→Rust host-reply channel** (`hostSendRawFrame`/`getPendingEnvelope`
analog). Hence a `deliver` is a stateless evaluation, not a turn of a CapTP session. Stage-9c
child 9 measured this as the direct cause of the sole `test:rust` divergence (error-trace hangs).

## The work

1. **Persistent machine:** rework `rust/endo/src/rust_worker.rs` (`serve_rust_worker`) to hold
   ONE `endor_vm` machine alive across the receive loop — boot once (compartment + bootstrap),
   then evaluate each `deliver`'s guest program **in the same realm**, so a global installed by
   one turn (e.g. `handleCommand`) is visible to the next. Expose whatever minimal public
   surface endor-vm needs for evaluate-again-in-same-realm (an `evaluate_more`/incremental
   program entry) — engine-side changes carry the full engine verification bar; keep the
   metered path untouched for single-shot programs (dual-run bit-exactness must hold — the
   corpus and oracle run single programs; do not perturb their metering).
2. **Host-reply channel:** give the guest a host function (bound global or intrinsic seam,
   e.g. `hostSendRawFrame(bytes)`-shaped) whose calls enqueue outbound envelopes the Rust loop
   drains and writes to the transport after each turn — the C-XS xsnap precedent. This is a
   HOST surface (not oracle-observable): verify with endor-side unit tests, not dual-run; keep
   it OFF for oracle/corpus runs so byte-identity is unperturbed.
3. **Prove the loop:** extend the `rust_worker` tests — a multi-turn session where turn 1
   installs state/`handleCommand`, turn 2 reads it back and replies via the host channel; the
   in-memory transport asserts the framed reply envelopes.

If endor-vm's public surface needs a new side table or machine field for the persistent-realm
entry, ledger it the day it lands. ROOT-workspace (`endo` crate) tests: report `cargo test -p
endo` counts (80 at stage-9 close).

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root (the daemon/worker code builds the ROOT workspace's `endor` bin). Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`; no-arg = the curated corpora + SYMB run); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`). Daemon `test:rust` runs select the Rust engine via `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` — `ENDO_ENGINE=rust` does NOT route child-process workers (stage-9c child 9's measured correction).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed — 47 lines / 673 passed at stage-9 close); curated compile-diff all-identical + SYMB (report the count — **1878** at stage-9 close, may have grown); boot gate green (report the count — 17 at stage-9 close — and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 at stage-9 close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract — the pattern of `proxies` (Pending) and `DebuggerState` (SnapshotExcluded) in `endor-snapshot/src/sidetable.rs`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 14
  worker_kind: gardener
  claimed_at: 2026-07-18T14:16:07Z
