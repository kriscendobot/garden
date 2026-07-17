---
model: opus
---
# Fix the stage-7 review findings on PR #600 (xs2rust-endor): compartment isolation divergence + two snapshot-ledger honesty gaps

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (keep DRAFT). Sync to the REAL
remote tip first (it advances between sessions; verify pushes by git exit code). The Rust workspace is
`rust/engine`, NOT the repo root. Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1)
— copy `c/moddable` from a sibling scratch worktree at the pin; NEVER `git add c/moddable`. `cargo` at
`$HOME/.cargo/bin`. Capture test output to files and check `$?` — a pipe to `tail` masks the exit code.
Findings comment: https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4999467228

## F3 (GATING result-agreement divergence — the main fix): parent-realm globals leak into child Compartments

In `endor-vm/src/interp.rs` (`Native::Compartment` construction) the child global is allocated as
`Slot::instance(self.global_obj)` — its prototype is the LIVE parent global object, so every parent
mutable global (created before or after compartment construction) is readable inside the child:

    var p = 42; var c = new Compartment(); typeof c.globalThis.p   → oracle "undefined", endor "number"
    var c = new Compartment(); var q = 7; typeof c.globalThis.q    → oracle "undefined", endor "number"

Under the accuracy-over-parity doctrine a wrong answer gates (named skips do not). It is also a real
confinement hole. Fix so a child compartment sees the SHARED INTRINSICS and its endowments but NOT
parent runtime globals. Constraints:
- `new Compartment().globalThis.Object === Object` and `typeof (new Compartment().globalThis.Math)`
  are dual-run-locked (endor-262 `guest_compartment_surface_dual_runs_against_the_pin`) and must stay
  green — intrinsic identity is shared across compartments, as in the pin.
- A natural shape: an intrinsics-only prototype/holder object built at boot (`create_intrinsics` /
  `link_intrinsics`) that the child global chains to — NOT the live `global_obj`, which accumulates
  runtime globals via `create_global_property`. Mind the `GET_PROPERTY` `globalThis`-by-id special case
  and `lockdown_roots()` (the holder must be swept by lockdown too, or shown frozen-equivalent).
- Add dual-run regression tests locking BOTH leak directions (parent global defined before AND after
  construction → `typeof c.globalThis.<name>` is "undefined" on both engines), alongside the existing
  child→parent and sibling isolation cases.
- This touches boot-path engine code: expect the s23 supervisor review to re-run the full 121-run
  enumeration; you must re-run the standard bars yourself (below).

## F1 (ledger honesty): the `compartments` side table is unledgered

`Interp::compartments` (compartment instance → child global HashMap) is cross-crank machine state at a
quiescent suspend point, but has no `SideTable` row in `endor-snapshot/src/sidetable.rs` and no
excluded-transients entry. Add `SideTable::Compartments` classified HONESTLY (almost certainly
`Pending`, like `CtorPrototype`/`SymbolKeyIds`: a HashMap-only link, not arena-recoverable; document
the deciding evidence in the row comment). Bump `VARIANT_COUNT` (30→31), extend `ALL`, keep the ledger
tests green. If your F3 fix adds any OTHER new `Interp` field carrying cross-crank state, classify it
in the same commit (the s20 rule: every new side table is ledgered honestly the day it lands).

## F2 (ledger honesty): `locked_down`'s false round-trip claim

The `locked_down: bool` field doc claims it "round-trips as a plain interpreter scalar across the
snapshot (no ledger row)" — false: nothing serializes it, `restore_snapshot_state` never rebuilds it,
so a machine that locked down in crank 1 resumes with the latch cleared (a second `lockdown()` then
runs instead of throwing `TypeError: lockdown already called`). EITHER wire it through the snapshot
image (serialize + restore; add a cross-crank regression test in the
`runtime_global_survives_suspend_resume` pattern: lockdown → snapshot → restore → second lockdown
still throws AND primordials still frozen) OR classify it honestly as a `Pending` ledger row and
correct the comment. Prefer the real fix if the image format change is small; honesty is the bar,
snapshot-format discipline applies (fail-closed version gate if the image layout changes).

## Verification bars (all captured to files, `$?` checked, from `rust/engine`)

1. `cargo test --workspace -- --test-threads=1` → EXIT=0, every `test result:` line 0 failed.
2. `./target/debug/compile-diff` (curated, no `--` separator) → 1711/1711 identical + SYMB 1711/1711, EXIT=0.
3. `./target/debug/endor-xst built-ins/Compartment built-ins/Object built-ins/Promise` → 0 failed, no
   coverage regression (Object 182, Promise 109 at the s22 review tip; Compartment corpus 0 covered is
   expected — all named skips).
4. `./target/debug/endor-xst -l built-ins/Boolean` → 16 covered / 0 failed (the lockdown axis stays real);
   `./target/debug/endor-xst -l --feature-filter ses-xs-parity --features-include ses-xs-parity built-ins`
   → 0 failed.
5. `#![forbid(unsafe_code)]` intact at every engine crate root; no new warnings.

Commit with explicit pathspecs (never `c/moddable`), push with a rebase-CAS loop
(`git push origin HEAD:xs2rust-endor`), keep the PR DRAFT, and report via your tada completion report
ONLY (your supervisor s23 is parked and reads the board — never inbox-send a parked supervisor).
