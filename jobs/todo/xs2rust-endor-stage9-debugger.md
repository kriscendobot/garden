---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T07:31:03Z -->

---
model: opus
---
# Stage-9b child 4/5 — the Debugger row (design row 7, requirement 1b)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD). The press may have rebased — find equivalents by subject, verify `git diff -- rust/ c/` byte-identity. Verify pushes by git EXIT CODE.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; engine workspace `rust/engine`; `TMPDIR=$HOME/tmp`; capture output to files, check `$?`. Seed `target/` by `cp -al` from a same-commit sibling; `c/moddable`: `rmdir` empty dir, `cp -al` from sibling, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify clean status. **Never `git add c/moddable`.** Acceptance-grade runs: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` first. **Push-per-item**; size to one 2400s invocation; report the honest remainder rather than overrun. **Doctrine:** accuracy-over-parity; never back-fit oracle/corpus/tests/meter.

## The work

Implement the **Debugger row** — design `designs/xs2rust-endor-engine.md` § Debugger (requirement 1b, near line 546) and roadmap row 7, with `designs/daemon-xs-worker-debugger.md` as the consumer contract (its layers 2–6 — bus verbs, DebugSession, Debugger exo, UI, hot-attach — stay untouched; layer 1's C hooks become the **`DebugTransport` trait**). This row's deferral budget is exhausted: it starts now.

Read the two design documents FIRST — they, not this brief, define the protocol surface. The direction of the row's acceptance (design row 7): the existing Rust debug-protocol tests and CapTP debugger tests pass unmodified against endor; xsbug connects. The xsbug protocol is the XML-message protocol `xsDebug.c` speaks — annotate the Rust implementation against those C sources.

Slices (push each; a coherent prefix landed honestly beats an unsound whole):
1. The `DebugTransport` trait + the protocol framing/parse/serialize core, with unit tests annotated against `xsDebug.c` message shapes.
2. The VM-side inspection hooks (break, step, frames, locals/closures inspection per the design's slot/frame contract) behind the trait, metering-neutral when disarmed.
3. The integration point the daemon design names (transport over the envelope bus seam), plus whichever of the existing debug-protocol tests can be turned on against endor.

If the full row exceeds one invocation, land the protocol/transport core + tests and report the precise remainder in your tada report for re-dispatch.

**Verification bar (report numbers + exit codes):** fresh clean of the three crates, then: workspace EXIT=0 all `test result:` lines 0 failed; curated compile-diff all-identical + SYMB; boot gate still 14-green-equivalent (no regressions); zero new Rust warnings; `forbid(unsafe_code)` intact at all 7 roots (the debugger must not introduce unsafe); metering unchanged on non-debug paths (no computron drift in dual-run tests).
