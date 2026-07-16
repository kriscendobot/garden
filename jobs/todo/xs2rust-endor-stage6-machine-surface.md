---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-16T22:04:06Z -->

---
model: opus
---
# Stage 6 child 3/6: `Machine` snapshot surface + meter state across suspend

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 6
(Snapshots, design § roadmap row 6 + § Snapshots requirement 1c — read both from the live tree,
plus `designs/daemon-xs-worker-snapshot.md`). Children 1 (seam flip) and 2 (`endor-snapshot`
atom writer/reader + arena serialization) have landed — build on child 2's crate surface; sync
to the real remote tip and READ what it actually shipped before designing yours.

## The work

1. **The xsnap-shaped snapshot surface on the engine's machine**: `write_snapshot_to_file`,
   `from_snapshot_file`, and `suspend_to_cas` (streaming write/read; the CAS layout and verbs
   per daemon-xs-worker-snapshot.md — the supervisor's suspend/resume and CAS integration
   contract is that this surface matches what the xsnap crate exposes today, so the embedder
   swaps engines without surgery).
2. **Meter state across suspend** (design row 6's explicit item): the metering state —
   accumulated computrons, the frozen cost-table version (`endor-meter-N`), any allocation
   accounting — serializes into the snapshot and a resumed machine CONTINUES its meter exactly:
   run-to-N-computrons, suspend, resume, run-to-end must equal the uninterrupted run in BOTH
   result and final computron count. Lock that as a test (several programs, including one that
   suspends mid-loop with live closures/generators if the suspend points allow).
3. **Round-trip behavioral tests at the machine level**: snapshot a machine mid-lifecycle,
   restore in a fresh process context, continue — observable results identical to never
   suspending. Reuse child 2's side-table fixtures where they fit; add machine-level ones.
4. If a suspend point cannot be taken at arbitrary interpreter states (e.g. only between jobs /
   at metering checkpoints), DOCUMENT the suspend-point contract explicitly in the crate docs
   and test at exactly those points — an honest narrower contract beats a pretend-general one.

## Verification

- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (file + `$?`).
- The suspend/resume-equals-uninterrupted tests (result AND computrons) locked and green.
- `#![forbid(unsafe_code)]` intact everywhere you touch.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1) via shallow sha fetch;
  NEVER `git add` c/moddable.
- DOCTRINE accuracy-over-parity: the meter is endor's own frozen release-versioned cost table;
  never back-fit to oracle computrons — the suspend/resume bar compares endor to ITSELF.
- Capture test runs to files, check `$?`; `/tmp` is noexec (`bash /path/script.sh`).
- Budget: ONE 2400s invocation. Land green increments; report the honest remainder in tada.
- Report via tada ONLY; never inbox-send the parked supervisor.
