---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T06:49:29Z -->

---
model: opus
---
# Stage-9b child 2/5 — HandledPromise / eventual-send surface

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD). The press may have rebased — find equivalents by subject, verify `git diff -- rust/ c/` byte-identity. Verify pushes by git EXIT CODE.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; workspace `rust/engine`; `TMPDIR=$HOME/tmp`; capture test output to files, check `$?`. Seed `target/` by `cp -al` from a same-commit sibling; `c/moddable`: `rmdir` empty dir, `cp -al` from sibling, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify clean status. **Never `git add c/moddable`.** Acceptance-grade runs: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` first. **Push-per-item**; size to one 2400s invocation; report the honest remainder rather than overrun. **Doctrine:** accuracy-over-parity; never back-fit oracle/corpus/tests/meter.

## The work

Implement the **HandledPromise surface** the SES boot / eventual-send shim requires, converting the boot-gate skip `skip_ses_boot_handled_promise_shim_absent` toward green. This is the last non-structural entry in the stage-8 residual skip ledger, and it is a **prerequisite for the `test:rust` daemon finish line** (the daemon is built on E() eventual send).

Method — honest scoping first, then slices:
1. **Read the actual consumer** before writing engine code: the eventual-send shim source consumed by the SES boot bundle (find it from the boot-bundle composition used by `endor-262`'s gate tests) and, where XS provides native support, the XS sources. Determine the minimal-but-honest surface the shim needs from the engine (constructor, static methods `applyFunction`/`applyMethod`/`get`, handler traps, presence/unresolved-handler semantics, promise-identity requirements). Annotate what you implement against the shim/spec — do not invent semantics.
2. Implement in coherent slices, **pushing each slice** with its tests (dual-run oracle-agreement where the oracle also runs the shim; endor-side unit tests where the surface is shim-defined rather than oracle-observable).
3. Convert (or split) the boot-gate skip: if the full shim greens, make it a green `boot_step_*`; if only part greens honestly, split the skip into the green part + a NARROWER named skip stating the precise residual — never a vague skip.

If the honest surface is too large for one invocation, land the coherent prefix push-per-item and report the precise remainder in your tada report — the supervisor re-dispatches; do not rush an unsound surface.

**Verification bar (report numbers + exit codes):** fresh clean of the three crates, then: workspace EXIT=0 all `test result:` lines 0 failed; curated compile-diff all-identical + SYMB; boot gate green (your conversion/split included); zero new Rust warnings; `forbid(unsafe_code)` intact at all 7 roots.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 20
  worker_kind: gardener
  claimed_at: 2026-07-18T06:49:33Z
