---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage7
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-16T23:55:30Z
---

---
model: opus
---
# Stage 7 child 3/7: `Promise.prototype.finally` + combinators on the native-reaction path

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 7 is the
engine boot-surface/intrinsics stage (supervisor decision, stage-6 acceptance PR #600
issuecomment-4997552045). Children 1–2 precede you serially — sync to the real remote tip and
READ what they actually shipped.

## The work

The review ledger's promise residuals, riding the landed 5-slot native-reaction path (read its
implementation in `endor-vm` first — the ledger notes this is the intended substrate):
1. **`Promise.prototype.finally`.**
2. **The combinators**: `Promise.all`, `Promise.allSettled`, `Promise.any`, `Promise.race` —
   whichever of these are missing or partial on the live tree (read before building; do not
   re-implement what exists).
3. Job-queue/pump-loop latch semantics preserved (design § roadmap row 3) — the combinators
   must schedule reactions with the same crank discipline the existing promise tests lock.
4. Metering per the accuracy-over-parity doctrine: endor's own frozen cost table + version-bump
   discipline; result agreement with the oracle is the gate, computrons advisory.

## Verification

- Dual-run result-agreement tests per landed item; deterministic-per-release meter (identical
  computrons across repeated runs).
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (file + `$?`).
- `./target/debug/compile-diff` (curated) → EXIT=0, 1711/1711 + SYMB 1711/1711.
- Targeted endor-xst `built-ins/Promise`: 0 failed, coverage may only grow, skips named.
- `#![forbid(unsafe_code)]` intact.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1); NEVER `git add`
  c/moddable. Prebuilt binaries run directly WITHOUT `--`.
- Capture test runs to files, check `$?`; `/tmp` is noexec; use `$HOME/tmp` for TMPDIR.
- Budget: ONE 2400s invocation. Land green increments; honest remainder in tada.
- Report via tada ONLY; never inbox-send the parked supervisor.
