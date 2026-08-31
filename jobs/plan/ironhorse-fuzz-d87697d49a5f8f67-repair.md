---
gate: go-ahead
priority: normal
role: builder
tier: mentor
token-budget: 250000
doomed: true
doom_signature: policy-refusal
doom_count: 1
requeue_cycles: 3
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-31T17:34:43Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-31T17:34:43Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix Ironhorse fuzz finding d87697d49a5f8f67 (target `differential_source`) and amend the standing PR

The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
load-bearing regression case AND the causal fix, then amend the ONE standing
pull request for fuzz findings.

## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)

- Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
- Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
- Toolchain: `nightly-2026-08-15`
- Minimized input sha256: `b4814c1b47ca2297e26e5e27a1151a79dc222cd408f51d4130a07d423229311b` (7 bytes)
- Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/d87697d49a5f8f67/input.bin`
- Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/d87697d49a5f8f67.md`
- Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`

## Procedure

1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
2. Recover the minimized input to a FILE without inlining it into any prompt:
   decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
   durable artifact path above. Verify `sha256sum` equals `b4814c1b47ca2297e26e5e27a1151a79dc222cd408f51d4130a07d423229311b`.
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
7. Document THIS case and its solution in the standing PR body or a PR comment (finding d87697d49a5f8f67).
8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
   comment, and record the unsolved finding visibly in the PR — never let it disappear.
