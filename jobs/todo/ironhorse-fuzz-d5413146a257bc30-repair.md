---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix Ironhorse fuzz finding d5413146a257bc30 (target `differential_regexp_surface`) and amend the standing PR

The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
load-bearing regression case AND the causal fix, then amend the ONE standing
pull request for fuzz findings.

## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)

- Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
- Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
- Toolchain: `nightly-2026-08-15`
- Minimized input sha256: `957c39a802d5b3a9f09413832ea4c03dba2d2fed67d8b6da0553a6cb6cef0563` (6 bytes)
- Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/d5413146a257bc30/input.bin`
- Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/d5413146a257bc30.md`
- Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`

## Procedure

1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
2. Recover the minimized input to a FILE without inlining it into any prompt:
   decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
   durable artifact path above. Verify `sha256sum` equals `957c39a802d5b3a9f09413832ea4c03dba2d2fed67d8b6da0553a6cb6cef0563`.
3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
   see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
   before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.

4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
   so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
   that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
5. Fix the causal defect. Keep the fix minimal and targeted.
6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
   `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
   PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
   and run its required gauntlet.
7. Document THIS case and its solution in the standing PR body or a PR comment (finding d5413146a257bc30).
8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
   comment, and record the unsolved finding visibly in the PR — never let it disappear.

<!-- garden-reaped: 1 -->
