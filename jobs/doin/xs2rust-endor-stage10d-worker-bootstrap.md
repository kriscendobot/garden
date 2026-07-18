---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T22:04:12Z -->

---
model: opus
---
# stage10d child 2/4 — wire the real worker boot chain into `rust_worker` (polyfills → ses_boot → worker bootstrap → `handleCommand` dispatch)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep it DRAFT, post NO PR comments), branch `xs2rust-endor`, base `llm`. Tip at cut: `c345aa838` — **sync to the REAL remote tip first** (child 1 will have advanced it; verify pushes by git EXIT CODE). Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.

## Precondition gate (run FIRST, ~300s budget)

Child 1 (`xs2rust-endor-stage10d-real-boot`) targeted: REAL `polyfills.js` + REAL generated `ses_boot.js` evaluate cleanly as two separate evals in one `endor_vm::PersistentRealm`, `lockdown()` completes. Run its gate test (and `cargo test -p endor-vm persistent_realm`) at your tip. **If the real two-eval boot is RED, do NOT attempt the worker wiring: this job DEGRADES to a further real-boot gap round** (continue from child 1's exact named remainder, push-per-gap — an honest capability increment is success).

## Context

`rust/endo/src/rust_worker.rs` currently boots its `PersistentRealm` with only a trivial probe program (`"endor-worker-boot-ok"`); its own module doc names the gap: until the SES worker bundle boots, `deliver` cannot dispatch to a real `handleCommand`. The C-XS path (`rust/endo/xsnap/src/lib.rs` ~1126, ~1537) runs polyfills → SES_BOOT → role-specific bootstrap (`WORKER_BOOTSTRAP` = the generated `worker_bootstrap.js`). The persistent-realm machinery (cross-turn functions + symbols, host-reply channel `host_send_fns`/`host_outbox`) landed in stages 10–10c precisely to make this possible.

## Definition of done

1. `RustWorker::boot` (or its equivalent seam) evaluates, in one persistent realm: REAL `polyfills.js` → REAL generated `ses_boot.js` → the REAL generated worker bootstrap program — the same sequence the C-XS worker runs. `booted` reflects the real chain's success.
2. A delivered command dispatches to the guest's registered `handleCommand` and a reply frame returns through the host-reply channel: extend the ROOT-workspace `cargo test -p endo --lib` worker tests (84 passed at cut) to prove one command→handler→reply round at the unit level on the real chain.
3. Frontier gaps in the worker-bootstrap/bundle surface: close them **push-per-gap**, each grounded by an isolated oracle-reaching dual-run snippet where the gap is an engine semantic (vs a wiring defect). An honest named remainder with the exact halt signature is SUCCESS if the window ends.
4. **Never commit generated bundles** (`ses_boot.js`, `worker_bootstrap.js`, `daemon_bootstrap.js` stay gitignored; placeholders suffice for lib builds that do not drive them).

## Bars that must stay green (verify before EVERY push; capture outputs to files, check `$?`)

- Engine workspace (`rust/engine`): `cargo test --workspace --no-fail-fast` EXIT=0, 48 `test result:` lines all `0 failed` (708 passed at cut).
- `./target/debug/compile-diff`: 1909/1909 identical + SYMB 1909/1909, 0 divergent (metered path byte-identity unperturbed — the host-reply channel and realm machinery stay OFF/inert on the metered single-shot path).
- Boot gate: 28 at cut (test binary's count is canonical); no regressions.
- ROOT-workspace `cargo test -p endo --lib`: ≥84 passed, 0 failed.
- Zero new Rust warnings; `#![forbid(unsafe_code)]` intact at the 7 anchored engine crate roots (oracle exempt); any NEW side table ledgered day-it-lands (`sidetable.rs`, VARIANT_COUNT 35 at cut); `c/moddable` at pin `23b4d6b0a65f…`, clean, never staged.

**Doctrine: accuracy-over-parity.** Result agreement gates; computrons advisory; never back-fit meters.

## Environment notes

`cargo` at `$HOME/.cargo/bin`; `TMPDIR=$HOME/tmp` (mkdir first; `/tmp` noexec). Seed `rust/engine/target/` and the root `target/` by `cp -al` from a same-commit sibling (verify its tip sha); `rmdir` empty `c/moddable` before seeding the pinned checkout.

## Discipline (BINDING)

- **Push-per-item**; **STOP-and-checkpoint** if ~1800s in with nothing pushed (land an honest WIP that keeps all bars green, push, tada with exact resume point).
- Report via tada ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-18T22:04:17Z
