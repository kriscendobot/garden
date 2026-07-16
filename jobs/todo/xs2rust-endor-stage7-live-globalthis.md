---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-16T23:58:05Z -->

---
model: opus
---
# Stage 7 child 1/7: live `globalThis` binding

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 7 is the
**engine boot-surface/intrinsics stage** (supervisor decision, stage-6 acceptance PR #600
issuecomment-4997552045): the post-stage-4 intrinsics ledger + stage-6 child 5's daemon-gap #4,
the critical path to the maintainer finish line (`test:rust` green on an endor worker). Read
design `designs/xs2rust-endor-engine.md` § Hardened JavaScript and Compartment (requirement 5)
and § Staged Roadmap row 4's boot-bundle bar from the live tree first.

## The work

**Bind the global object as a live, guest-visible `globalThis`.** Today the engine resolves
globals through `global_props` but does not expose the global object itself as a first-class
guest value. After this child:
1. `globalThis` resolves in guest code to the real global object — property reads/writes on it
   are the SAME state `var`/sloppy-global declarations and plain identifier resolution see
   (`globalThis.x = 1; x` → `1`, `var y = 2; globalThis.y` → `2`), including deletes and
   property enumeration to the extent the property-op surface already supports them.
2. Intrinsic bindings (`Object`, `Math`, …) are reachable as properties OF that object, not
   just via identifier resolution.
3. The metering of these paths follows the accuracy-over-parity doctrine: endor's own frozen
   cost table (`endor-meter-N` discipline — if costs change, follow the established
   version-bump discipline in the meter crate docs); never back-fit to oracle computrons.
4. Mind the snapshot side-table ledger (`endor-snapshot/src/sidetable.rs`): if you add any new
   interpreter side table (e.g. a cached global-object slot), classify it honestly in the
   ledger (`BootDerived` if boot/restore re-derives it — `restore_snapshot_state` must then
   actually re-derive it; see `rebuild_global_props` for the established shape).

## Verification

- New behavioral tests locking §1/§2 (dual-run vs the oracle where the oracle accepts the
  program — result agreement is the gate; computron-vs-oracle advisory).
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (capture to file + check `$?`).
- `./target/debug/compile-diff` (curated, no args) → EXIT=0, 1711/1711 identical + SYMB
  1711/1711 (compiler untouched ⇒ must hold).
- Targeted endor-xst: `./target/debug/endor-xst built-ins/Object` and one `language/` subtree
  your change plausibly touches — covered/failed counts must not regress (0 failed; coverage
  may only grow; skips stay named).
- `#![forbid(unsafe_code)]` intact everywhere you touch.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1) via shallow sha fetch
  (or copy `c/` from a sibling scratch worktree at that pin); NEVER `git add` c/moddable.
- Prebuilt binaries run directly WITHOUT `--` (`./target/debug/compile-diff built-ins/Boolean`).
- Capture test runs to files, check `$?`; `/tmp` is noexec (`bash /path/script.sh`); mkdir and
  use `$HOME/tmp` for TMPDIR if needed.
- Budget: ONE 2400s invocation. Land green increments; report the honest remainder in tada
  (honesty valve: a precise landed slice + a precise gap map beats a pretend-green).
- Report via tada ONLY; never inbox-send the parked supervisor.
