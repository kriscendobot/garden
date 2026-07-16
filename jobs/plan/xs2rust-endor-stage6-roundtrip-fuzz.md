---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage6
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-16T21:29:56Z
---

---
model: opus
---
# Stage 6 child 4/6: snapshot round-trip-invariance + malformed-atom fuzz targets

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 6
(Snapshots). Children 1–3 have landed (`endor-snapshot` atoms + `Machine` surface). This is the
design's fuzz item 3: "Snapshot round-trip and decoder fuzzing: write/read" — read design §
Fuzzability from the live tree, and the existing `endor-fuzz` crate for the house style of
targets and fixtures (the fuzz-trophies regression tree `endor-262/cases/regressions/` shows how
trophies get locked).

## The work

1. **Round-trip-invariance fuzz target**: structure-aware generation of machine states (drive the
   engine with generated programs to populate heaps — closures, generators, promises, hardened
   graphs, regexps, bound functions, async state — then snapshot): assert write→read→write
   byte-equality and behavioral continuation. Deterministic inputs (seed-derived), no wall-clock.
2. **Malformed-atom fuzz target** (the decoder): arbitrary/mutated bytes into the snapshot
   reader must NEVER panic, hang, or allocate unboundedly — every malformed input yields a
   structured error. `forbid(unsafe_code)` means no memory-safety hazard, but a panic in a
   `read` path is still a defect (the daemon's restore path must fail closed, not crash).
3. **Locked regression fixtures**: any crash/invariance trophy becomes a committed fixture test
   (the trophies tree pattern), so the finding survives independent of fuzzing infrastructure.
4. **cargo-fuzz reality check**: cargo-fuzz may not be installed on the host (stage-5 residuals
   ledger: "a long cargo-fuzz campaign needs cargo-fuzz installed"). Attempt
   `cargo install cargo-fuzz` (or confirm present); if a real libFuzzer campaign is not
   reachable within budget, land the fuzz TARGETS (buildable, committed) plus a bounded
   in-`cargo-test` property loop (a few thousand deterministic seeded iterations) as the
   committed gate, and state honestly in your tada report which of the two ran and for how many
   iterations. Do not fake a campaign.

## Verification

- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (file + `$?`).
- The bounded property loop (or fuzz smoke) runs green in-tree; targets build.
- Any trophies: locked fixtures committed + named in the tada report.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1) via shallow sha fetch;
  NEVER `git add` c/moddable. Miri (if used) needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec.
- Capture test runs to files, check `$?`.
- Budget: ONE 2400s invocation. Land green increments; report the honest remainder in tada.
- Report via tada ONLY; never inbox-send the parked supervisor.
