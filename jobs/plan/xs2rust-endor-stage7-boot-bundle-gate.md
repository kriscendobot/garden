---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage7
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-16T23:55:46Z
---

---
model: opus
---
# Stage 7 child 6/7: the boot-bundle gate — daemon boot JS on endor vs the oracle

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 7 is the
engine boot-surface/intrinsics stage (supervisor decision, stage-6 acceptance PR #600
issuecomment-4997552045). Children 1–5 precede you serially (live `globalThis`, intrinsics
residuals, promise combinators, guest harden/lockdown, guest Compartment) — sync to the real
remote tip and READ what they actually shipped. You are the stage's ACCEPTANCE-GATE child.

## The work

The design's stage-4 bar, now reachable: **the endor daemon boot bundles run identically on
both engines** (design § Staged Roadmap row 4: `polyfills.js` → `ses_boot.js` lockdown →
HandledPromise shim; `designs/daemon-endor-architecture.md` § Unified runner names the
sequence). Stage-6 child 5's gap map located this (gap #4) on the critical path to the
maintainer finish line.
1. **Locate the actual boot-bundle sources on the live tree** (the daemon architecture design
   and `rust/endo` docs name them; note the worker/SES boot *generators* are known-absent —
   gap #3, being probed by child 7 in parallel with your serial slot — so gate on whatever
   bundle artifacts/sources ARE reachable: the SES shim, polyfills, HandledPromise shim from
   `packages/`).
2. **Build a dual-run boot gate**: execute each reachable boot script (or a faithful staged
   subset, staged in the boot order) on endor and on the C-XS oracle; result agreement is the
   bar (computrons advisory). Land it as a workspace test (`rust/engine`, e.g. in `endor-262`
   or a dedicated integration test) so it runs under `cargo test --workspace` and CANNOT
   silently rot.
3. Where a boot script still cannot run on endor, the gate records a NAMED, per-script,
   per-missing-surface skip — the honest ledger the next stage decomposes from. Your tada
   report carries that ledger (it is the stage-7 acceptance input).
4. Do not weaken any existing gate to get green.

## Verification

- The boot gate lands green (real agreement or named skips; zero unexplained divergence).
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (file + `$?`).
- `./target/debug/compile-diff` (curated) → EXIT=0, 1711/1711 + SYMB 1711/1711.
- endor-xst `--features-include ses-xs-parity` sweep: 0 failed; report the ses-mode
  covered/skip delta for the whole stage (children 4–5 flipped skips — measure the net).
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
