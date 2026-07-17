---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T05:28:10Z -->

---
model: opus
---
# Stage 7 child 7/7: daemon-side boot-path PROBE (gap-revealing; worker/SES boot generators + workspace edge)

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 7 is the
engine boot-surface/intrinsics stage (supervisor decision, stage-6 acceptance PR #600
issuecomment-4997552045). This child is a **gap-revealing probe** per
`skills/gap-revealing-build/SKILL.md`: its deliverable is a structured report (plus any
honestly-landable slice), NOT a forced green.

## The question

Stage-6 child 5's daemon-gap map (its tada report `xs2rust-endor-stage6-supervisor-integration`
on the journal; restated in the stage-6 acceptance comment) named two daemon-SIDE blockers on
the maintainer finish line ("integrated with endor and passing all `test:rust` daemon tests"):
- **Gap #3 (L, the hard blocker):** the daemon worker/SES boot generators (`bus-worker-xs.js`,
  …) are absent from the tree and from git history (`rust/endo/README.md:164`), so
  `packages/daemon` `test:rust` cannot build an `endot` binary **even on C-XS**.
- **Gap #2 (M, architectural):** `rust/endo` (root workspace) cannot depend on the deliberately
  *excluded* `rust/engine` workspace; the edge must not entangle `forbid(unsafe_code)` engine
  crates with the daemon's C-FFI xsnap crate.

## The work

1. **Probe gap #3 to ground truth:** what exactly does `test:rust` build and invoke (read
   `packages/daemon/package.json` and the `rust/endo` build); which artifacts are missing;
   can they be REGENERATED from what the tree has (an endo bundling step? a build script in
   history? the upstream endo repo's equivalents, fetched read-only for comparison — no
   upstream writes of any kind)? Attempt the smallest honest reconstruction: if a stub or
   regenerated boot artifact lets `endot` BUILD (even failing tests), that is a landable slice.
   If not landable in budget, deliver the precise recipe (files, generators, provenance) the
   next stage would execute.
2. **Answer gap #2 with a concrete recommendation:** enumerate the options (un-exclude the
   nested workspace / path-dependency / a bridge crate) with the actual Cargo constraints on
   this tree (feature unification, profile conflicts, MSRV, the `forbid(unsafe_code)` boundary,
   what breaks `cargo test --workspace` in each), and recommend ONE with evidence (a scratch
   `cargo check` of the candidate edge counts as evidence). Do NOT land the restructuring
   itself unless it is genuinely small and green.
3. Structured output in your tada report: per-gap status (landed / recipe / blocked-with-why),
   the dependency order for a future daemon-integration stage, and any new gaps discovered.

## Verification (for anything you LAND)

- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0 (file + `$?`);
  root-workspace builds you touch also green.
- No engine-crate source changes expected from this child; if you make any,
  `./target/debug/compile-diff` curated 1711/1711 + SYMB 1711/1711 and
  `#![forbid(unsafe_code)]` intact.
- PR stays DRAFT.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- `cargo` at `$HOME/.cargo/bin`. Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` if
  needed; NEVER `git add` c/moddable.
- Read-only fetches of upstream `endojs/endo` for artifact comparison are allowed; NO upstream
  interaction (no comments, PRs, links, pushes).
- Capture runs to files, check `$?`; `/tmp` is noexec; use `$HOME/tmp` for TMPDIR.
- Budget: ONE 2400s invocation.
- Report via tada ONLY; never inbox-send the parked supervisor.
