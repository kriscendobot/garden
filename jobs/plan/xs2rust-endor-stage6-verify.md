---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage6
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-16T21:30:06Z
---

---
model: opus
---
# Stage 6 child 6/6: whole-stage verify — snapshot bars + stage-5 bars HOLD at the tip

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Children 1–5 of
stage 6 have landed (seam flip, `endor-snapshot` atoms, `Machine` surface + meter-across-suspend,
round-trip/malformed-atom fuzz, supervisor integration or its gap probe). You are the stage's
independent verifier: reproduce EVERY bar at the CURRENT remote tip, from a fresh checkout, and
report measured numbers — not the children's claims. **Binding process rule (s16/s18): a
whole-tree claim requires the whole-tree enumeration AT THE CLAIMED TIP, and a workspace-green
claim requires running the workspace at that tip.** Record the tip sha in your report.

## The checklist (all captured to files, `$?` checked directly; report every number)

1. **Workspace**: `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0,
   every `test result:` line 0 failed.
2. **Snapshot bars**: the round-trip-invariance fixtures (child 2), the machine-level
   suspend/resume-equals-uninterrupted tests incl. meter state (child 3), and the
   malformed-atom/property-loop gates (child 4) all run green in the workspace run — name them
   individually. Confirm `#![forbid(unsafe_code)]` at every engine crate root INCLUDING
   `endor-snapshot` (grep the crate roots, list them).
3. **Seam flip holds** (child 1): `Compiler::default()` is `Endor`; grep `endor_oracle::` call
   sites and confirm the classification (differential harnesses only on default paths).
4. **Stage-5 bars HOLD at the tip**:
   - Curated `compile-diff` (no arg) → EXIT=0, 1711 identical, 0 divergent.
   - The COMPLETE 121-run `language/` enumeration: each top-level dir whole; `expressions/` +
     `statements/` per second-level subtree; loose `expressions/tco-pos.js` via a temp subtree
     (whole-`language/` in one process OOMs — per-subtree by design; invoke the built binary
     directly WITHOUT a `--` separator: `./target/debug/compile-diff language/<subtree>`).
     Expected: every run EXIT=0, summed divergent=0 endor-rejected=0 accept-disagree=0
     (s19 anchor at `69ec87becb`: total=20603 identical=16981 oracle-rejected=3622 all
     accept-agreed).
   - Stage-4 spot-checks: `endor-xst built-ins/Object` ≥182 covered / 0 failed,
     `built-ins/Function` ≥43/0, `built-ins/Array` ≥487/0, all skips named, EXIT=0.
5. **README ledger**: update `rust/engine/README.md`'s stage/bars ledger with stage 6's landed
   surface and measured numbers (match its existing style; commit as its own small commit).
6. If the supervisor-integration child (5) probed instead of landing: restate its gap map's
   headline in your report so the supervisor sees it without digging.

## Output

Your tada completion report carries: the tip sha, every measured number above, any deviation
flagged loudly (a deviation is a FINDING, not something to fix silently — the supervisor
dispatches fixers), and `orchestration-failed: true` only if a bar is genuinely violated.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1) via shallow sha fetch
  (README § Building the oracle); NEVER `git add` c/moddable.
- Capture test runs to files, check `$?`; `/tmp` is noexec (`bash /path/script.sh`).
- Budget: ONE 2400s invocation (the enumeration is ~5 min once the tree is built).
- Report via tada ONLY; never inbox-send the parked supervisor.
