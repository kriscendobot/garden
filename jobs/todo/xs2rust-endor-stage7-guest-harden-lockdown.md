---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T04:04:03Z -->

---
model: opus
---
# Stage 7 child 4/7: guest `harden` + full `lockdown()` + `mutabilities` on the harden substrate

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 7 is the
engine boot-surface/intrinsics stage (supervisor decision, stage-6 acceptance PR #600
issuecomment-4997552045). Children 1–3 precede you serially — sync to the real remote tip and
READ what they actually shipped (child 1's live `globalThis` is your mounting point for guest
globals).

## The work

The review ledger holds these as "folds on the harden substrate" — the substrate exists
(petrify/harden internals from stage 4); this child makes it a GUEST surface (design
§ Hardened JavaScript and Compartment, requirement 5):
1. **`harden` as a guest global** — transitive freeze per the SES semantics the design names,
   callable from guest code, with dual-run agreement on observable results (the oracle's XS has
   native harden — use it as the result oracle where its build exposes it; where the oracle
   build does not expose the surface, lock endor-only behavioral tests and SAY so).
2. **`lockdown()` full semantics** — beyond the landed MODES wiring (convergence 4/5 landed
   lockdown/compartment MODES + third-host wiring): intrinsics repair/freeze to the extent the
   design's stage-4 bar needs for the boot bundles; name explicitly in your report which
   lockdown options are implemented vs stubbed-with-named-error.
3. **`mutabilities`** fold on the same substrate (the design/ledger names it with lockdown).
4. Every previously named `ses-mode:lockdown-unimplemented` /`feature:Compartment` skip in the
   test262-runner third-host wiring that YOUR work makes real: flip it from skip to run — the
   convergence design's ses-xs-parity axis (`endor-xst --features-include ses-xs-parity`) is
   the harness. Do NOT flip skips your work does not actually cover.

## Verification

- Behavioral tests locking harden/lockdown/mutabilities semantics (dual-run where the oracle
  exposes the surface; endor-only where not, honestly labeled).
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (file + `$?`).
- `./target/debug/compile-diff` (curated) → EXIT=0, 1711/1711 + SYMB 1711/1711.
- Targeted endor-xst incl. a `--features-include ses-xs-parity` run: 0 failed, coverage may
  only grow, remaining skips named.
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
