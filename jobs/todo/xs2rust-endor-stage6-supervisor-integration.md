---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-16T22:43:04Z -->

---
model: opus
---
# Stage 6 child 5/6: supervisor suspend/resume integration on `-e endor-rs`

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 6
(Snapshots). Children 1–4 have landed. This is design § roadmap row 6's acceptance-bar item:
**"supervisor suspend/resume integration test passes on `-e endor-rs`"** — the endo daemon's
worker supervisor suspending an endor-engined worker to a snapshot and resuming it, through the
same lifecycle the C xsnap worker uses today. Read `designs/xs2rust-endor-engine.md` § roadmap
row 6 + § Snapshots, `designs/daemon-endor-architecture.md`, and
`designs/daemon-xs-worker-snapshot.md` from the live tree, then read the ACTUAL daemon/worker
wiring in the repo (where `-e`/engine selection happens, how the xsnap worker's suspend/resume
integration tests run) before writing anything.

## The work — with an explicit honesty valve

**Primary goal:** wire the endor engine (children 2–3's snapshot surface) into the daemon's
worker path far enough that an existing supervisor suspend/resume integration test (or a new
one mirroring the xsnap one) passes with the endor engine selected (`-e endor-rs` or whatever
the live engine-selection surface actually is), and commit that test green.

**The honesty valve (sized in the dispatch):** the daemon integration may NOT be reachable in
one invocation — the engine may still lack intrinsics/surfaces the daemon boot path needs (the
review ledger's post-stage-4 intrinsics list: live `globalThis` binding, `Compartment`/
`lockdown` as guest globals, etc.). ASSESS FIRST (read the boot path, try the smallest real boot),
and if the gap is structural, convert to a gap-revealing probe per
`skills/gap-revealing-build/SKILL.md`: deliver a STRUCTURED GAP REPORT in your tada completion
report — exactly which daemon-boot requirement fails against today's engine, in dependency
order, each gap sized — plus any genuinely-landable slice (e.g. the engine-selection plumbing
compiled in but feature-gated, a skipped-with-named-reason integration test that documents the
bar). A precise gap map is a SUCCESS for this child; a red branch or a pretend-green is a
failure.

## Verification

- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0 (file + `$?`).
- If the integration test lands: it runs green and is committed un-skipped; name the command in
  your tada report.
- If probe mode: branch left green (nothing half-landed), gap report structured as above.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- The Rust ENGINE workspace is `rust/engine`; the daemon/xsnap code lives elsewhere in the repo
  (the root workspace's xsnap crate historically does not build — do not be surprised; work from
  what `test:rust` actually runs). `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1) via shallow sha fetch;
  NEVER `git add` c/moddable.
- Maintainer finish line (PR #600, 2026-07-03, BINDING): integrated with endo and passing all
  `test:rust` daemon tests — this child is the first real step onto that surface; what you learn
  (even as gaps) feeds the stages after 6.
- Capture test runs to files, check `$?`; `/tmp` is noexec (`bash /path/script.sh`).
- Budget: ONE 2400s invocation. Assess early, choose build-vs-probe deliberately, land green.
- Report via tada ONLY; never inbox-send the parked supervisor.
